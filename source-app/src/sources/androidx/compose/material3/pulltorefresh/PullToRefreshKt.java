package androidx.compose.material3.pulltorefresh;

import androidx.compose.animation.core.AnimateAsStateKt;
import androidx.compose.animation.core.AnimationConstants;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.EasingKt;
import androidx.compose.animation.core.TweenSpec;
import androidx.compose.foundation.BackgroundKt;
import androidx.compose.foundation.CanvasKt;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScope;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.draw.DrawModifierKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.RectKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.AndroidPath_androidKt;
import androidx.compose.p002ui.graphics.ClipOp;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsLayerModifierKt;
import androidx.compose.p002ui.graphics.GraphicsLayerScope;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.PathFillType;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.graphics.StrokeCap;
import androidx.compose.p002ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawContext;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.drawscope.Stroke;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.semantics.ProgressBarRangeInfo;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.runtime.saveable.RememberSaveableKt;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000\u0080\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0018\u0002\n\u0002\b\u0006\u001a\u0010\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0002H\u0002\u001a(\u0010\u0017\u001a\u00020\u00182\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001bH\u0003ø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u001d\u001a\u007f\u0010\u001e\u001a\u00020\u00182\u0006\u0010\u001f\u001a\u00020 2\f\u0010!\u001a\b\u0012\u0004\u0012\u00020\u00180\u00192\b\b\u0002\u0010\"\u001a\u00020#2\b\b\u0002\u0010$\u001a\u00020%2\b\b\u0002\u0010&\u001a\u00020'2\u001e\b\u0002\u0010(\u001a\u0018\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020\u00180)¢\u0006\u0002\b+¢\u0006\u0002\b,2\u001c\u0010-\u001a\u0018\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020\u00180)¢\u0006\u0002\b+¢\u0006\u0002\b,H\u0007¢\u0006\u0002\u0010.\u001a\b\u0010/\u001a\u00020%H\u0007\u001a\r\u00100\u001a\u00020%H\u0007¢\u0006\u0002\u00101\u001aF\u00102\u001a\u00020\u0018*\u0002032\u0006\u00104\u001a\u0002052\u0006\u00106\u001a\u0002072\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u00108\u001a\u00020\u00022\u0006\u00109\u001a\u00020\u00152\u0006\u0010:\u001a\u00020\u0004H\u0002ø\u0001\u0000¢\u0006\u0004\b;\u0010<\u001a>\u0010=\u001a\u00020\u0018*\u0002032\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u00108\u001a\u00020\u00022\u0006\u00109\u001a\u00020\u00152\u0006\u0010>\u001a\u0002072\u0006\u0010:\u001a\u00020\u0004H\u0002ø\u0001\u0000¢\u0006\u0004\b?\u0010@\u001aH\u0010A\u001a\u00020#*\u00020#2\u0006\u0010\u001f\u001a\u00020 2\u0006\u0010$\u001a\u00020%2\b\b\u0002\u0010B\u001a\u00020 2\b\b\u0002\u0010C\u001a\u00020\u00042\f\u0010!\u001a\b\u0012\u0004\u0012\u00020\u00180\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\bD\u0010E\u001aN\u0010F\u001a\u00020#*\u00020#2\u0006\u0010$\u001a\u00020%2\u0006\u0010\u001f\u001a\u00020 2\b\b\u0002\u0010C\u001a\u00020\u00042\b\b\u0002\u0010G\u001a\u00020H2\b\b\u0002\u0010I\u001a\u00020\u001b2\b\b\u0002\u0010J\u001a\u00020\u0004H\u0007ø\u0001\u0000¢\u0006\u0004\bK\u0010L\"\u0014\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u0010\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0005\"\u0010\u0010\u0006\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0005\"\u0010\u0010\u0007\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0005\"\u000e\u0010\b\u001a\u00020\tX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\n\u001a\u00020\u0002X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u000b\u001a\u00020\u0002X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\f\u001a\u00020\u0002X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\r\u001a\u00020\u0002X\u0082T¢\u0006\u0002\n\u0000\"\u0016\u0010\u000e\u001a\u00020\u0004X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0005\u001a\u0004\b\u000f\u0010\u0010\"\u0016\u0010\u0011\u001a\u00020\u0004X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0005\u001a\u0004\b\u0012\u0010\u0010\"\u0010\u0010\u0013\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0005\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006M²\u0006\n\u0010N\u001a\u00020\u0002X\u008a\u0084\u0002"}, d2 = {"AlphaTween", "Landroidx/compose/animation/core/TweenSpec;", "", "ArcRadius", "Landroidx/compose/ui/unit/Dp;", "F", "ArrowHeight", "ArrowWidth", "CrossfadeDurationMs", "", "DragMultiplier", "MaxAlpha", "MaxProgressArc", "MinAlpha", "SpinnerContainerSize", "getSpinnerContainerSize", "()F", "SpinnerSize", "getSpinnerSize", "StrokeWidth", "ArrowValues", "Landroidx/compose/material3/pulltorefresh/ArrowValues;", "progress", "CircularArrowProgressIndicator", "", "Lkotlin/Function0;", "color", "Landroidx/compose/ui/graphics/Color;", "CircularArrowProgressIndicator-RPmYEkk", "(Lkotlin/jvm/functions/Function0;JLandroidx/compose/runtime/Composer;I)V", "PullToRefreshBox", "isRefreshing", "", "onRefresh", "modifier", "Landroidx/compose/ui/Modifier;", "state", "Landroidx/compose/material3/pulltorefresh/PullToRefreshState;", "contentAlignment", "Landroidx/compose/ui/Alignment;", "indicator", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/BoxScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "content", "(ZLkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;Landroidx/compose/material3/pulltorefresh/PullToRefreshState;Landroidx/compose/ui/Alignment;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "PullToRefreshState", "rememberPullToRefreshState", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/pulltorefresh/PullToRefreshState;", "drawArrow", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "arrow", "Landroidx/compose/ui/graphics/Path;", "bounds", "Landroidx/compose/ui/geometry/Rect;", "alpha", "values", "strokeWidth", "drawArrow-uDrxG_w", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;Landroidx/compose/ui/graphics/Path;Landroidx/compose/ui/geometry/Rect;JFLandroidx/compose/material3/pulltorefresh/ArrowValues;F)V", "drawCircularIndicator", "arcBounds", "drawCircularIndicator-KzyDr3Q", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;JFLandroidx/compose/material3/pulltorefresh/ArrowValues;Landroidx/compose/ui/geometry/Rect;F)V", "pullToRefresh", "enabled", "threshold", "pullToRefresh-Z4HSEVQ", "(Landroidx/compose/ui/Modifier;ZLandroidx/compose/material3/pulltorefresh/PullToRefreshState;ZFLkotlin/jvm/functions/Function0;)Landroidx/compose/ui/Modifier;", "pullToRefreshIndicator", "shape", "Landroidx/compose/ui/graphics/Shape;", "containerColor", "elevation", "pullToRefreshIndicator-wUdLESc", "(Landroidx/compose/ui/Modifier;Landroidx/compose/material3/pulltorefresh/PullToRefreshState;ZFLandroidx/compose/ui/graphics/Shape;JF)Landroidx/compose/ui/Modifier;", "material3_release", "targetAlpha"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class PullToRefreshKt {
    private static final int CrossfadeDurationMs = 100;
    private static final float DragMultiplier = 0.5f;
    private static final float MaxAlpha = 1.0f;
    private static final float MaxProgressArc = 0.8f;
    private static final float MinAlpha = 0.3f;
    private static final float StrokeWidth = Dp.constructor-impl((float) 2.5d);
    private static final float ArcRadius = Dp.constructor-impl((float) 5.5d);
    private static final float SpinnerSize = Dp.constructor-impl(16);
    private static final float SpinnerContainerSize = Dp.constructor-impl(40);
    private static final float ArrowWidth = Dp.constructor-impl(10);
    private static final float ArrowHeight = Dp.constructor-impl(5);
    private static final TweenSpec<Float> AlphaTween = AnimationSpecKt.tween$default(AnimationConstants.DefaultDurationMillis, 0, EasingKt.getLinearEasing(), 2, null);

    public static final void PullToRefreshBox(final boolean z, final Function0<Unit> function0, Modifier modifier, PullToRefreshState pullToRefreshState, Alignment alignment, Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function3, final Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function4, Composer composer, final int i, final int i2) {
        int i3;
        final Modifier modifier2;
        final PullToRefreshState pullToRefreshState2;
        int i4;
        Alignment topStart;
        int i5;
        int i6;
        Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function5;
        int i7;
        int i8;
        Modifier.Companion companion;
        final PullToRefreshState pullToRefreshStateRememberPullToRefreshState;
        int i9;
        PullToRefreshState pullToRefreshState3;
        Alignment alignment2;
        Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function3RememberComposableLambda;
        Modifier modifier3;
        int currentCompositeKeyHash;
        Function0<ComposeUiNode> constructor;
        Composer composerM4037constructorimpl;
        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash;
        final Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function6;
        final Alignment alignment3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i10;
        Composer composerStartRestartGroup = composer.startRestartGroup(1902956467);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(PullToRefreshBox)P(3,5,4,6,1,2)124@5580L28,126@5713L163,135@5931L199:PullToRefresh.kt#djiw08");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(z) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function0) ? 32 : 16;
        }
        int i11 = i2 & 4;
        if (i11 == 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    pullToRefreshState2 = pullToRefreshState;
                    if (composerStartRestartGroup.changed(pullToRefreshState2)) {
                        i10 = Fields.CameraDistance;
                    }
                    i3 |= i10;
                } else {
                    pullToRefreshState2 = pullToRefreshState;
                }
                i10 = Fields.RotationZ;
                i3 |= i10;
            } else {
                pullToRefreshState2 = pullToRefreshState;
            }
            i4 = i2 & 16;
            if (i4 != 0) {
                if ((i & 24576) == 0) {
                    topStart = alignment;
                    if (composerStartRestartGroup.changed(topStart)) {
                        i5 = Fields.Clip;
                    } else {
                        i5 = Fields.Shape;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 32;
                if (i6 != 0) {
                    if ((196608 & i) == 0) {
                        function5 = function3;
                        if (composerStartRestartGroup.changedInstance(function5)) {
                            i7 = Fields.RenderEffect;
                        } else {
                            i7 = 65536;
                        }
                        i3 |= i7;
                    }
                    if ((i2 & 64) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i8 = 1048576;
                        } else {
                            i8 = 524288;
                        }
                        i3 |= i8;
                    }
                    if ((599187 & i3) == 599186 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i11 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if ((i2 & 8) != 0) {
                                pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                                i3 &= -7169;
                            } else {
                                pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                            }
                            if (i4 != 0) {
                                topStart = Alignment.INSTANCE.getTopStart();
                            }
                            if (i6 != 0) {
                                i9 = i3;
                                modifier3 = companion;
                                pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                                alignment2 = topStart;
                                function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(BoxScope boxScope, Composer composer2, int i12) {
                                        int i13;
                                        ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                        if ((i12 & 6) == 0) {
                                            i13 = i12 | (composer2.changed(boxScope) ? 4 : 2);
                                        } else {
                                            i13 = i12;
                                        }
                                        if ((i13 & 19) != 18 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(1989171225, i13, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                            }
                                            PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                            } else {
                                i9 = i3;
                                pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                                alignment2 = topStart;
                                function3RememberComposableLambda = function5;
                                modifier3 = companion;
                            }
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                            }
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshState2;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = modifier2;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                        }
                        int i12 = i9;
                        Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function7 = function3RememberComposableLambda;
                        Alignment alignment4 = alignment2;
                        Modifier modifierM3360pullToRefreshZ4HSEVQ$default = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(alignment4, false);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default);
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
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                        function4.invoke(boxScopeInstance, composerStartRestartGroup, Integer.valueOf(((i12 >> 15) & 112) | 6));
                        function7.invoke(boxScopeInstance, composerStartRestartGroup, Integer.valueOf(((i12 >> 12) & 112) | 6));
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function6 = function7;
                        alignment3 = alignment4;
                        modifier2 = modifier3;
                        pullToRefreshState2 = pullToRefreshState3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        alignment3 = topStart;
                        function6 = function5;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i13) {
                                PullToRefreshKt.PullToRefreshBox(z, function0, modifier2, pullToRefreshState2, alignment3, function6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                function5 = function3;
                if ((i2 & 64) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = 1048576;
                    } else {
                        i8 = 524288;
                    }
                    i3 |= i8;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i13) {
                                    int i14;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i13 & 6) == 0) {
                                        i14 = i13 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i14 = i13;
                                    }
                                    if ((i14 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i14, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i13) {
                                    int i14;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i13 & 6) == 0) {
                                        i14 = i13 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i14 = i13;
                                    }
                                    if ((i14 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i14, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                    }
                    int i13 = i9;
                    Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function8 = function3RememberComposableLambda;
                    Alignment alignment5 = alignment2;
                    Modifier modifierM3360pullToRefreshZ4HSEVQ$default2 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(alignment5, false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default2);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                    function4.invoke(boxScopeInstance2, composerStartRestartGroup, Integer.valueOf(((i13 >> 15) & 112) | 6));
                    function8.invoke(boxScopeInstance2, composerStartRestartGroup, Integer.valueOf(((i13 >> 12) & 112) | 6));
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function6 = function8;
                    alignment3 = alignment5;
                    modifier2 = modifier3;
                    pullToRefreshState2 = pullToRefreshState3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i14) {
                                    int i15;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i14 & 6) == 0) {
                                        i15 = i14 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i15 = i14;
                                    }
                                    if ((i15 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i15, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i14) {
                                    int i15;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i14 & 6) == 0) {
                                        i15 = i14 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i15 = i14;
                                    }
                                    if ((i15 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i15, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                    }
                    int i14 = i9;
                    Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function9 = function3RememberComposableLambda;
                    Alignment alignment6 = alignment2;
                    Modifier modifierM3360pullToRefreshZ4HSEVQ$default3 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(alignment6, false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default3);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                    function4.invoke(boxScopeInstance3, composerStartRestartGroup, Integer.valueOf(((i14 >> 15) & 112) | 6));
                    function9.invoke(boxScopeInstance3, composerStartRestartGroup, Integer.valueOf(((i14 >> 12) & 112) | 6));
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function6 = function9;
                    alignment3 = alignment6;
                    modifier2 = modifier3;
                    pullToRefreshState2 = pullToRefreshState3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            PullToRefreshKt.PullToRefreshBox(z, function0, modifier2, pullToRefreshState2, alignment3, function6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            topStart = alignment;
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    function5 = function3;
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((i2 & 64) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = 1048576;
                    } else {
                        i8 = 524288;
                    }
                    i3 |= i8;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i15) {
                                    int i16;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i15 & 6) == 0) {
                                        i16 = i15 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i16 = i15;
                                    }
                                    if ((i16 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i16, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i15) {
                                    int i16;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i15 & 6) == 0) {
                                        i16 = i15 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i16 = i15;
                                    }
                                    if ((i16 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i16, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                    }
                    int i15 = i9;
                    Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function10 = function3RememberComposableLambda;
                    Alignment alignment7 = alignment2;
                    Modifier modifierM3360pullToRefreshZ4HSEVQ$default4 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy4 = BoxKt.maybeCachedBoxMeasurePolicy(alignment7, false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default4);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy4, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance4 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                    function4.invoke(boxScopeInstance4, composerStartRestartGroup, Integer.valueOf(((i15 >> 15) & 112) | 6));
                    function10.invoke(boxScopeInstance4, composerStartRestartGroup, Integer.valueOf(((i15 >> 12) & 112) | 6));
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function6 = function10;
                    alignment3 = alignment7;
                    modifier2 = modifier3;
                    pullToRefreshState2 = pullToRefreshState3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i16) {
                                    int i17;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i16 & 6) == 0) {
                                        i17 = i16 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i17 = i16;
                                    }
                                    if ((i17 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i17, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i16) {
                                    int i17;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i16 & 6) == 0) {
                                        i17 = i16 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i17 = i16;
                                    }
                                    if ((i17 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i17, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                    }
                    int i16 = i9;
                    Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function11 = function3RememberComposableLambda;
                    Alignment alignment8 = alignment2;
                    Modifier modifierM3360pullToRefreshZ4HSEVQ$default5 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy5 = BoxKt.maybeCachedBoxMeasurePolicy(alignment8, false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap5 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier5 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default5);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy5, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance5 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                    function4.invoke(boxScopeInstance5, composerStartRestartGroup, Integer.valueOf(((i16 >> 15) & 112) | 6));
                    function11.invoke(boxScopeInstance5, composerStartRestartGroup, Integer.valueOf(((i16 >> 12) & 112) | 6));
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function6 = function11;
                    alignment3 = alignment8;
                    modifier2 = modifier3;
                    pullToRefreshState2 = pullToRefreshState3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            PullToRefreshKt.PullToRefreshBox(z, function0, modifier2, pullToRefreshState2, alignment3, function6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            function5 = function3;
            if ((i2 & 64) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i8 = 1048576;
                } else {
                    i8 = 524288;
                }
                i3 |= i8;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i17) {
                                int i18;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i17 & 6) == 0) {
                                    i18 = i17 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i18 = i17;
                                }
                                if ((i18 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i18, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i17) {
                                int i18;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i17 & 6) == 0) {
                                    i18 = i17 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i18 = i17;
                                }
                                if ((i18 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i18, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                }
                int i17 = i9;
                Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function12 = function3RememberComposableLambda;
                Alignment alignment9 = alignment2;
                Modifier modifierM3360pullToRefreshZ4HSEVQ$default6 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy6 = BoxKt.maybeCachedBoxMeasurePolicy(alignment9, false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap6 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier6 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default6);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy6, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance6 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                function4.invoke(boxScopeInstance6, composerStartRestartGroup, Integer.valueOf(((i17 >> 15) & 112) | 6));
                function12.invoke(boxScopeInstance6, composerStartRestartGroup, Integer.valueOf(((i17 >> 12) & 112) | 6));
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function6 = function12;
                alignment3 = alignment9;
                modifier2 = modifier3;
                pullToRefreshState2 = pullToRefreshState3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i18) {
                                int i19;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i18 & 6) == 0) {
                                    i19 = i18 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i19 = i18;
                                }
                                if ((i19 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i19, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i18) {
                                int i19;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i18 & 6) == 0) {
                                    i19 = i18 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i19 = i18;
                                }
                                if ((i19 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i19, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                }
                int i18 = i9;
                Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function13 = function3RememberComposableLambda;
                Alignment alignment10 = alignment2;
                Modifier modifierM3360pullToRefreshZ4HSEVQ$default7 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy7 = BoxKt.maybeCachedBoxMeasurePolicy(alignment10, false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap7 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier7 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default7);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy7, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance7 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                function4.invoke(boxScopeInstance7, composerStartRestartGroup, Integer.valueOf(((i18 >> 15) & 112) | 6));
                function13.invoke(boxScopeInstance7, composerStartRestartGroup, Integer.valueOf(((i18 >> 12) & 112) | 6));
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function6 = function13;
                alignment3 = alignment10;
                modifier2 = modifier3;
                pullToRefreshState2 = pullToRefreshState3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i19) {
                        PullToRefreshKt.PullToRefreshBox(z, function0, modifier2, pullToRefreshState2, alignment3, function6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                pullToRefreshState2 = pullToRefreshState;
                if (composerStartRestartGroup.changed(pullToRefreshState2)) {
                    i10 = Fields.CameraDistance;
                }
                i3 |= i10;
            } else {
                pullToRefreshState2 = pullToRefreshState;
            }
            i10 = Fields.RotationZ;
            i3 |= i10;
        } else {
            pullToRefreshState2 = pullToRefreshState;
        }
        i4 = i2 & 16;
        if (i4 != 0) {
            if ((i & 24576) == 0) {
                topStart = alignment;
                if (composerStartRestartGroup.changed(topStart)) {
                    i5 = Fields.Clip;
                } else {
                    i5 = Fields.Shape;
                }
                i3 |= i5;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    function5 = function3;
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((i2 & 64) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = 1048576;
                    } else {
                        i8 = 524288;
                    }
                    i3 |= i8;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i19) {
                                    int i110;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i19 & 6) == 0) {
                                        i110 = i19 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i110 = i19;
                                    }
                                    if ((i110 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i110, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i19) {
                                    int i110;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i19 & 6) == 0) {
                                        i110 = i19 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i110 = i19;
                                    }
                                    if ((i110 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i110, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                    }
                    int i19 = i9;
                    Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function14 = function3RememberComposableLambda;
                    Alignment alignment11 = alignment2;
                    Modifier modifierM3360pullToRefreshZ4HSEVQ$default8 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy8 = BoxKt.maybeCachedBoxMeasurePolicy(alignment11, false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap8 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier8 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default8);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy8, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance8 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                    function4.invoke(boxScopeInstance8, composerStartRestartGroup, Integer.valueOf(((i19 >> 15) & 112) | 6));
                    function14.invoke(boxScopeInstance8, composerStartRestartGroup, Integer.valueOf(((i19 >> 12) & 112) | 6));
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function6 = function14;
                    alignment3 = alignment11;
                    modifier2 = modifier3;
                    pullToRefreshState2 = pullToRefreshState3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i110) {
                                    int i111;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i110 & 6) == 0) {
                                        i111 = i110 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i111 = i110;
                                    }
                                    if ((i111 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i111, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    } else {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                            i3 &= -7169;
                        } else {
                            pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                        }
                        if (i4 != 0) {
                            topStart = Alignment.INSTANCE.getTopStart();
                        }
                        if (i6 != 0) {
                            i9 = i3;
                            modifier3 = companion;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(BoxScope boxScope, Composer composer2, int i110) {
                                    int i111;
                                    ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                    if ((i110 & 6) == 0) {
                                        i111 = i110 | (composer2.changed(boxScope) ? 4 : 2);
                                    } else {
                                        i111 = i110;
                                    }
                                    if ((i111 & 19) != 18 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1989171225, i111, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                        }
                                        PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                        } else {
                            i9 = i3;
                            pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                            alignment2 = topStart;
                            function3RememberComposableLambda = function5;
                            modifier3 = companion;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                    }
                    int i110 = i9;
                    Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function15 = function3RememberComposableLambda;
                    Alignment alignment12 = alignment2;
                    Modifier modifierM3360pullToRefreshZ4HSEVQ$default9 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy9 = BoxKt.maybeCachedBoxMeasurePolicy(alignment12, false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap9 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier9 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default9);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy9, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance9 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                    function4.invoke(boxScopeInstance9, composerStartRestartGroup, Integer.valueOf(((i110 >> 15) & 112) | 6));
                    function15.invoke(boxScopeInstance9, composerStartRestartGroup, Integer.valueOf(((i110 >> 12) & 112) | 6));
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function6 = function15;
                    alignment3 = alignment12;
                    modifier2 = modifier3;
                    pullToRefreshState2 = pullToRefreshState3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111) {
                            PullToRefreshKt.PullToRefreshBox(z, function0, modifier2, pullToRefreshState2, alignment3, function6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            function5 = function3;
            if ((i2 & 64) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i8 = 1048576;
                } else {
                    i8 = 524288;
                }
                i3 |= i8;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i111) {
                                int i112;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i111 & 6) == 0) {
                                    i112 = i111 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i112 = i111;
                                }
                                if ((i112 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i112, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i111) {
                                int i112;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i111 & 6) == 0) {
                                    i112 = i111 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i112 = i111;
                                }
                                if ((i112 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i112, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                }
                int i111 = i9;
                Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function16 = function3RememberComposableLambda;
                Alignment alignment13 = alignment2;
                Modifier modifierM3360pullToRefreshZ4HSEVQ$default10 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy10 = BoxKt.maybeCachedBoxMeasurePolicy(alignment13, false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap10 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier10 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default10);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy10, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance10 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                function4.invoke(boxScopeInstance10, composerStartRestartGroup, Integer.valueOf(((i111 >> 15) & 112) | 6));
                function16.invoke(boxScopeInstance10, composerStartRestartGroup, Integer.valueOf(((i111 >> 12) & 112) | 6));
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function6 = function16;
                alignment3 = alignment13;
                modifier2 = modifier3;
                pullToRefreshState2 = pullToRefreshState3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i112) {
                                int i113;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i112 & 6) == 0) {
                                    i113 = i112 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i113 = i112;
                                }
                                if ((i113 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i113, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i112) {
                                int i113;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i112 & 6) == 0) {
                                    i113 = i112 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i113 = i112;
                                }
                                if ((i113 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i113, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                }
                int i112 = i9;
                Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function17 = function3RememberComposableLambda;
                Alignment alignment14 = alignment2;
                Modifier modifierM3360pullToRefreshZ4HSEVQ$default11 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy11 = BoxKt.maybeCachedBoxMeasurePolicy(alignment14, false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap11 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier11 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default11);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy11, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance11 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                function4.invoke(boxScopeInstance11, composerStartRestartGroup, Integer.valueOf(((i112 >> 15) & 112) | 6));
                function17.invoke(boxScopeInstance11, composerStartRestartGroup, Integer.valueOf(((i112 >> 12) & 112) | 6));
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function6 = function17;
                alignment3 = alignment14;
                modifier2 = modifier3;
                pullToRefreshState2 = pullToRefreshState3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i113) {
                        PullToRefreshKt.PullToRefreshBox(z, function0, modifier2, pullToRefreshState2, alignment3, function6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        topStart = alignment;
        i6 = i2 & 32;
        if (i6 != 0) {
            if ((196608 & i) == 0) {
                function5 = function3;
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
            if ((i2 & 64) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i8 = 1048576;
                } else {
                    i8 = 524288;
                }
                i3 |= i8;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i113) {
                                int i114;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i113 & 6) == 0) {
                                    i114 = i113 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i114 = i113;
                                }
                                if ((i114 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i114, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i113) {
                                int i114;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i113 & 6) == 0) {
                                    i114 = i113 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i114 = i113;
                                }
                                if ((i114 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i114, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                }
                int i113 = i9;
                Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function18 = function3RememberComposableLambda;
                Alignment alignment15 = alignment2;
                Modifier modifierM3360pullToRefreshZ4HSEVQ$default12 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy12 = BoxKt.maybeCachedBoxMeasurePolicy(alignment15, false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap12 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier12 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default12);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy12, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance12 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                function4.invoke(boxScopeInstance12, composerStartRestartGroup, Integer.valueOf(((i113 >> 15) & 112) | 6));
                function18.invoke(boxScopeInstance12, composerStartRestartGroup, Integer.valueOf(((i113 >> 12) & 112) | 6));
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function6 = function18;
                alignment3 = alignment15;
                modifier2 = modifier3;
                pullToRefreshState2 = pullToRefreshState3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i114) {
                                int i115;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i114 & 6) == 0) {
                                    i115 = i114 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i115 = i114;
                                }
                                if ((i115 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i115, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                        i3 &= -7169;
                    } else {
                        pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                    }
                    if (i4 != 0) {
                        topStart = Alignment.INSTANCE.getTopStart();
                    }
                    if (i6 != 0) {
                        i9 = i3;
                        modifier3 = companion;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(BoxScope boxScope, Composer composer2, int i114) {
                                int i115;
                                ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                                if ((i114 & 6) == 0) {
                                    i115 = i114 | (composer2.changed(boxScope) ? 4 : 2);
                                } else {
                                    i115 = i114;
                                }
                                if ((i115 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1989171225, i115, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                    }
                                    PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        i9 = i3;
                        pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                        alignment2 = topStart;
                        function3RememberComposableLambda = function5;
                        modifier3 = companion;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
                }
                int i114 = i9;
                Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function19 = function3RememberComposableLambda;
                Alignment alignment16 = alignment2;
                Modifier modifierM3360pullToRefreshZ4HSEVQ$default13 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy13 = BoxKt.maybeCachedBoxMeasurePolicy(alignment16, false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap13 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier13 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default13);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy13, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance13 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
                function4.invoke(boxScopeInstance13, composerStartRestartGroup, Integer.valueOf(((i114 >> 15) & 112) | 6));
                function19.invoke(boxScopeInstance13, composerStartRestartGroup, Integer.valueOf(((i114 >> 12) & 112) | 6));
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function6 = function19;
                alignment3 = alignment16;
                modifier2 = modifier3;
                pullToRefreshState2 = pullToRefreshState3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i115) {
                        PullToRefreshKt.PullToRefreshBox(z, function0, modifier2, pullToRefreshState2, alignment3, function6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        function5 = function3;
        if ((i2 & 64) != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function4)) {
                i8 = 1048576;
            } else {
                i8 = 524288;
            }
            i3 |= i8;
        }
        if ((599187 & i3) == 599186) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                    i3 &= -7169;
                } else {
                    pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                }
                if (i4 != 0) {
                    topStart = Alignment.INSTANCE.getTopStart();
                }
                if (i6 != 0) {
                    i9 = i3;
                    modifier3 = companion;
                    pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                    alignment2 = topStart;
                    function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(BoxScope boxScope, Composer composer2, int i115) {
                            int i116;
                            ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                            if ((i115 & 6) == 0) {
                                i116 = i115 | (composer2.changed(boxScope) ? 4 : 2);
                            } else {
                                i116 = i115;
                            }
                            if ((i116 & 19) != 18 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1989171225, i116, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                }
                                PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    i9 = i3;
                    pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                    alignment2 = topStart;
                    function3RememberComposableLambda = function5;
                    modifier3 = companion;
                }
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                    i3 &= -7169;
                } else {
                    pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                }
                if (i4 != 0) {
                    topStart = Alignment.INSTANCE.getTopStart();
                }
                if (i6 != 0) {
                    i9 = i3;
                    modifier3 = companion;
                    pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                    alignment2 = topStart;
                    function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(BoxScope boxScope, Composer composer2, int i115) {
                            int i116;
                            ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                            if ((i115 & 6) == 0) {
                                i116 = i115 | (composer2.changed(boxScope) ? 4 : 2);
                            } else {
                                i116 = i115;
                            }
                            if ((i116 & 19) != 18 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1989171225, i116, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                }
                                PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    i9 = i3;
                    pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                    alignment2 = topStart;
                    function3RememberComposableLambda = function5;
                    modifier3 = companion;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
            }
            int i115 = i9;
            Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function110 = function3RememberComposableLambda;
            Alignment alignment17 = alignment2;
            Modifier modifierM3360pullToRefreshZ4HSEVQ$default14 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy14 = BoxKt.maybeCachedBoxMeasurePolicy(alignment17, false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap14 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier14 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default14);
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
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy14, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance14 = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
            function4.invoke(boxScopeInstance14, composerStartRestartGroup, Integer.valueOf(((i115 >> 15) & 112) | 6));
            function110.invoke(boxScopeInstance14, composerStartRestartGroup, Integer.valueOf(((i115 >> 12) & 112) | 6));
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function6 = function110;
            alignment3 = alignment17;
            modifier2 = modifier3;
            pullToRefreshState2 = pullToRefreshState3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                    i3 &= -7169;
                } else {
                    pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                }
                if (i4 != 0) {
                    topStart = Alignment.INSTANCE.getTopStart();
                }
                if (i6 != 0) {
                    i9 = i3;
                    modifier3 = companion;
                    pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                    alignment2 = topStart;
                    function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(BoxScope boxScope, Composer composer2, int i116) {
                            int i117;
                            ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                            if ((i116 & 6) == 0) {
                                i117 = i116 | (composer2.changed(boxScope) ? 4 : 2);
                            } else {
                                i117 = i116;
                            }
                            if ((i117 & 19) != 18 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1989171225, i117, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                }
                                PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    i9 = i3;
                    pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                    alignment2 = topStart;
                    function3RememberComposableLambda = function5;
                    modifier3 = companion;
                }
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    pullToRefreshStateRememberPullToRefreshState = rememberPullToRefreshState(composerStartRestartGroup, 0);
                    i3 &= -7169;
                } else {
                    pullToRefreshStateRememberPullToRefreshState = pullToRefreshState2;
                }
                if (i4 != 0) {
                    topStart = Alignment.INSTANCE.getTopStart();
                }
                if (i6 != 0) {
                    i9 = i3;
                    modifier3 = companion;
                    pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                    alignment2 = topStart;
                    function3RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1989171225, true, new Function3<BoxScope, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((BoxScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(BoxScope boxScope, Composer composer2, int i116) {
                            int i117;
                            ComposerKt.sourceInformation(composer2, "C127@5723L147:PullToRefresh.kt#djiw08");
                            if ((i116 & 6) == 0) {
                                i117 = i116 | (composer2.changed(boxScope) ? 4 : 2);
                            } else {
                                i117 = i116;
                            }
                            if ((i117 & 19) != 18 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1989171225, i117, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox.<anonymous> (PullToRefresh.kt:127)");
                                }
                                PullToRefreshDefaults.INSTANCE.m3345Indicator2poqoh4(pullToRefreshStateRememberPullToRefreshState, z, boxScope.align(Modifier.INSTANCE, Alignment.INSTANCE.getTopCenter()), 0L, 0L, 0.0f, composer2, 1572864, 56);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    i9 = i3;
                    pullToRefreshState3 = pullToRefreshStateRememberPullToRefreshState;
                    alignment2 = topStart;
                    function3RememberComposableLambda = function5;
                    modifier3 = companion;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1902956467, i9, -1, "androidx.compose.material3.pulltorefresh.PullToRefreshBox (PullToRefresh.kt:134)");
            }
            int i116 = i9;
            Function3<? super BoxScope, ? super Composer, ? super Integer, Unit> function111 = function3RememberComposableLambda;
            Alignment alignment18 = alignment2;
            Modifier modifierM3360pullToRefreshZ4HSEVQ$default15 = m3360pullToRefreshZ4HSEVQ$default(modifier3, z, pullToRefreshState3, false, 0.0f, function0, 12, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy15 = BoxKt.maybeCachedBoxMeasurePolicy(alignment18, false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap15 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier15 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM3360pullToRefreshZ4HSEVQ$default15);
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
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy15, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance15 = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1101976897, "C139@6095L9,140@6113L11:PullToRefresh.kt#djiw08");
            function4.invoke(boxScopeInstance15, composerStartRestartGroup, Integer.valueOf(((i116 >> 15) & 112) | 6));
            function111.invoke(boxScopeInstance15, composerStartRestartGroup, Integer.valueOf(((i116 >> 12) & 112) | 6));
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function6 = function111;
            alignment3 = alignment18;
            modifier2 = modifier3;
            pullToRefreshState2 = pullToRefreshState3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i117) {
                    PullToRefreshKt.PullToRefreshBox(z, function0, modifier2, pullToRefreshState2, alignment3, function6, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final Modifier m3361pullToRefreshIndicatorwUdLESc(Modifier modifier, final PullToRefreshState pullToRefreshState, final boolean z, final float f, final Shape shape, long j, final float f2) {
        return BackgroundKt.m518backgroundbw27NRU(GraphicsLayerModifierKt.graphicsLayer(DrawModifierKt.drawWithContent(SizeKt.m1080size3ABfNKs(modifier, SpinnerContainerSize), new Function1<ContentDrawScope, Unit>() {
            public Object invoke(Object obj) {
                invoke((ContentDrawScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(ContentDrawScope contentDrawScope) {
                int iM4579getIntersectrtfAjoo = ClipOp.INSTANCE.m4579getIntersectrtfAjoo();
                DrawContext drawContext = contentDrawScope.getDrawContext();
                long jMo5102getSizeNHjbRc = drawContext.mo5102getSizeNHjbRc();
                drawContext.getCanvas().save();
                try {
                    drawContext.getTransform().mo5105clipRectN_I0leg(-3.4028235E38f, 0.0f, Float.MAX_VALUE, Float.MAX_VALUE, iM4579getIntersectrtfAjoo);
                    contentDrawScope.drawContent();
                } finally {
                    drawContext.getCanvas().restore();
                    drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
                }
            }
        }), new Function1<GraphicsLayerScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((GraphicsLayerScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                boolean z2 = pullToRefreshState.getDistanceFraction() > 0.0f || z;
                graphicsLayerScope.setTranslationY((pullToRefreshState.getDistanceFraction() * graphicsLayerScope.roundToPx-0680j_4(f)) - Size.m4412getHeightimpl(graphicsLayerScope.getSize()));
                graphicsLayerScope.setShadowElevation(z2 ? graphicsLayerScope.toPx-0680j_4(f2) : 0.0f);
                graphicsLayerScope.setShape(shape);
                graphicsLayerScope.setClip(true);
            }
        }), j, shape);
    }

    public static Modifier m3360pullToRefreshZ4HSEVQ$default(Modifier modifier, boolean z, PullToRefreshState pullToRefreshState, boolean z2, float f, Function0 function0, int i, Object obj) {
        if ((i & 4) != 0) {
            z2 = true;
        }
        boolean z3 = z2;
        if ((i & 8) != 0) {
            f = PullToRefreshDefaults.INSTANCE.m3347getPositionalThresholdD9Ej5fM();
        }
        return m3359pullToRefreshZ4HSEVQ(modifier, z, pullToRefreshState, z3, f, function0);
    }

    public static final Modifier m3359pullToRefreshZ4HSEVQ(Modifier modifier, boolean z, PullToRefreshState pullToRefreshState, boolean z2, float f, Function0<Unit> function0) {
        return modifier.then(new PullToRefreshElement(z, function0, z2, pullToRefreshState, f, null));
    }

    public static final PullToRefreshState rememberPullToRefreshState(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 318623070, "C(rememberPullToRefreshState)513@19156L83:PullToRefresh.kt#djiw08");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(318623070, i, -1, "androidx.compose.material3.pulltorefresh.rememberPullToRefreshState (PullToRefresh.kt:512)");
        }
        PullToRefreshStateImpl pullToRefreshStateImpl = (PullToRefreshStateImpl) RememberSaveableKt.m4142rememberSaveable(new Object[0], (Saver) PullToRefreshStateImpl.INSTANCE.getSaver(), (String) null, (Function0) new Function0<PullToRefreshStateImpl>() {
            public final PullToRefreshStateImpl m3364invoke() {
                return new PullToRefreshStateImpl();
            }
        }, composer, 3072, 4);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return pullToRefreshStateImpl;
    }

    public static final PullToRefreshState PullToRefreshState() {
        return new PullToRefreshStateImpl();
    }

    public static final void m3353CircularArrowProgressIndicatorRPmYEkk(final Function0<Float> function0, final long j, Composer composer, final int i) {
        int i2;
        Composer composer2;
        Composer composer3;
        Composer composerStartRestartGroup = composer.startRestartGroup(-569718810);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(CircularArrowProgressIndicator)P(1,0:c#ui.graphics.Color)562@20583L61,564@20745L76,565@20843L74,567@20982L98,571@21118L443,566@20922L639:PullToRefresh.kt#djiw08");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changed(j) ? 32 : 16;
        }
        if ((i2 & 19) != 18 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-569718810, i2, -1, "androidx.compose.material3.pulltorefresh.CircularArrowProgressIndicator (PullToRefresh.kt:561)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1136642763, "CC(remember):PullToRefresh.kt#9igjgp");
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            Object obj = objRememberedValue;
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                Path Path = AndroidPath_androidKt.Path();
                Path.mo4481setFillTypeoQ8Xj4U(PathFillType.INSTANCE.m4880getEvenOddRgk1Os());
                composerStartRestartGroup.updateRememberedValue(Path);
                obj = Path;
            }
            final Path path = (Path) obj;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1136647962, "CC(remember):PullToRefresh.kt#9igjgp");
            Object objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = SnapshotStateKt.derivedStateOf(new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m3363invoke() {
                        return Float.valueOf(((Number) function0.invoke()).floatValue() < 1.0f ? 0.3f : 1.0f);
                    }
                });
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            final State<Float> stateAnimateFloatAsState = AnimateAsStateKt.animateFloatAsState(CircularArrowProgressIndicator_RPmYEkk$lambda$4((State) objRememberedValue2), AlphaTween, 0.0f, null, null, composerStartRestartGroup, 48, 28);
            Modifier.Companion companion = Modifier.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1136655568, "CC(remember):PullToRefresh.kt#9igjgp");
            int i3 = i2 & 14;
            boolean z = i3 == 4;
            Object objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (z || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj2) {
                        invoke((SemanticsPropertyReceiver) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function0.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierM1080size3ABfNKs = SizeKt.m1080size3ABfNKs(SemanticsModifierKt.semantics(companion, true, (Function1) objRememberedValue3), SpinnerSize);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1136660265, "CC(remember):PullToRefresh.kt#9igjgp");
            boolean zChanged = (i3 == 4) | composerStartRestartGroup.changed(stateAnimateFloatAsState) | ((i2 & 112) == 32) | composerStartRestartGroup.changedInstance(path);
            Object objRememberedValue4 = composerStartRestartGroup.rememberedValue();
            if (zChanged || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                Composer composer4 = composerStartRestartGroup;
                objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj2) throws Throwable {
                        invoke((DrawScope) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) throws Throwable {
                        long j2;
                        ArrowValues ArrowValues = PullToRefreshKt.ArrowValues(((Number) function0.invoke()).floatValue());
                        float fFloatValue = stateAnimateFloatAsState.getValue().floatValue();
                        float rotation = ArrowValues.getRotation();
                        long j3 = j;
                        Path path2 = path;
                        long jMo5082getCenterF1C5BW0 = drawScope.mo5082getCenterF1C5BW0();
                        DrawContext drawContext = drawScope.getDrawContext();
                        long jMo5102getSizeNHjbRc = drawContext.mo5102getSizeNHjbRc();
                        drawContext.getCanvas().save();
                        try {
                            drawContext.getTransform().mo5108rotateUv8p0NA(rotation, jMo5082getCenterF1C5BW0);
                            Rect rectM4385Rect3MmeM6k = RectKt.m4385Rect3MmeM6k(androidx.compose.p002ui.geometry.SizeKt.m4425getCenteruvyYCjk(drawScope.mo5083getSizeNHjbRc()), drawScope.toPx-0680j_4(PullToRefreshKt.ArcRadius) + (drawScope.toPx-0680j_4(PullToRefreshKt.StrokeWidth) / 2.0f));
                            try {
                                PullToRefreshKt.m3358drawCircularIndicatorKzyDr3Q(drawScope, j3, fFloatValue, ArrowValues, rectM4385Rect3MmeM6k, PullToRefreshKt.StrokeWidth);
                                PullToRefreshKt.m3357drawArrowuDrxG_w(drawScope, path2, rectM4385Rect3MmeM6k, j3, fFloatValue, ArrowValues, PullToRefreshKt.StrokeWidth);
                                drawContext.getCanvas().restore();
                                drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
                            } catch (Throwable th) {
                                th = th;
                                j2 = jMo5102getSizeNHjbRc;
                                drawContext.getCanvas().restore();
                                drawContext.mo5103setSizeuvyYCjk(j2);
                                throw th;
                            }
                        } catch (Throwable th2) {
                            th = th2;
                            j2 = jMo5102getSizeNHjbRc;
                        }
                    }
                };
                composer4.updateRememberedValue(objRememberedValue4);
                composer2 = composer4;
            } else {
                composer2 = composerStartRestartGroup;
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            CanvasKt.Canvas(modifierM1080size3ABfNKs, (Function1) objRememberedValue4, composer2, 0);
            composer3 = composer2;
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
                composer3 = composer2;
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
            composer3 = composerStartRestartGroup;
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composer3.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer5, int i4) {
                    PullToRefreshKt.m3353CircularArrowProgressIndicatorRPmYEkk(function0, j, composer5, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final void m3358drawCircularIndicatorKzyDr3Q(DrawScope drawScope, long j, float f, ArrowValues arrowValues, Rect rect, float f2) {
        DrawScope.CC.m5165drawArcyD3GUKo$default(drawScope, j, arrowValues.getStartAngle(), arrowValues.getEndAngle() - arrowValues.getStartAngle(), false, rect.m4381getTopLeftF1C5BW0(), rect.m4379getSizeNHjbRc(), f, new Stroke(drawScope.toPx-0680j_4(f2), 0.0f, StrokeCap.INSTANCE.m4963getButtKaPHkGw(), 0, null, 26, null), null, 0, 768, null);
    }

    public static final ArrowValues ArrowValues(float f) {
        float fMax = (Math.max(Math.min(1.0f, f) - 0.4f, 0.0f) * 5) / 3;
        float fCoerceIn = RangesKt.coerceIn(Math.abs(f) - 1.0f, 0.0f, 2.0f);
        float fPow = (((0.4f * fMax) - 0.25f) + (fCoerceIn - (((float) Math.pow(fCoerceIn, 2)) / 4))) * 0.5f;
        float f2 = 360;
        return new ArrowValues(fPow, fPow * f2, ((0.8f * fMax) + fPow) * f2, Math.min(1.0f, fMax));
    }

    public static final void m3357drawArrowuDrxG_w(DrawScope drawScope, Path path, Rect rect, long j, float f, ArrowValues arrowValues, float f2) {
        path.reset();
        path.moveTo(0.0f, 0.0f);
        float f3 = ArrowWidth;
        path.lineTo((drawScope.toPx-0680j_4(f3) * arrowValues.getScale()) / 2, drawScope.toPx-0680j_4(ArrowHeight) * arrowValues.getScale());
        path.lineTo(drawScope.toPx-0680j_4(f3) * arrowValues.getScale(), 0.0f);
        path.mo4483translatek4lQ0M(OffsetKt.Offset(((Math.min(rect.getWidth(), rect.getHeight()) / 2.0f) + Offset.m4346getXimpl(rect.m4376getCenterF1C5BW0())) - ((drawScope.toPx-0680j_4(f3) * arrowValues.getScale()) / 2.0f), Offset.m4347getYimpl(rect.m4376getCenterF1C5BW0()) - drawScope.toPx-0680j_4(f2)));
        float endAngle = arrowValues.getEndAngle() - drawScope.toPx-0680j_4(f2);
        long jMo5082getCenterF1C5BW0 = drawScope.mo5082getCenterF1C5BW0();
        DrawContext drawContext = drawScope.getDrawContext();
        long jMo5102getSizeNHjbRc = drawContext.mo5102getSizeNHjbRc();
        drawContext.getCanvas().save();
        try {
            drawContext.getTransform().mo5108rotateUv8p0NA(endAngle, jMo5082getCenterF1C5BW0);
            DrawScope.CC.m5176drawPathLG529CI$default(drawScope, path, j, f, new Stroke(drawScope.toPx-0680j_4(f2), 0.0f, 0, 0, null, 30, null), null, 0, 48, null);
        } finally {
            drawContext.getCanvas().restore();
            drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
        }
    }

    public static final float getSpinnerSize() {
        return SpinnerSize;
    }

    public static final float getSpinnerContainerSize() {
        return SpinnerContainerSize;
    }

    private static final float CircularArrowProgressIndicator_RPmYEkk$lambda$4(State<Float> state) {
        return state.getValue().floatValue();
    }
}
