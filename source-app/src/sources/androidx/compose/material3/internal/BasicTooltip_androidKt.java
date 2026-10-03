package androidx.compose.material3.internal;

import androidx.compose.foundation.C0399R;
import androidx.compose.foundation.MutatePriority;
import androidx.compose.foundation.gestures.ForEachGestureKt;
import androidx.compose.foundation.gestures.TapGestureDetectorKt;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.material3.TooltipState;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.input.pointer.AwaitPointerEventScope;
import androidx.compose.p002ui.input.pointer.PointerEventPass;
import androidx.compose.p002ui.input.pointer.PointerEventTimeoutCancellationException;
import androidx.compose.p002ui.input.pointer.PointerInputChange;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import androidx.compose.p002ui.input.pointer.PointerType;
import androidx.compose.p002ui.input.pointer.SuspendingPointerInputFilterKt;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.res.StringResources_androidKt;
import androidx.compose.p002ui.semantics.LiveRegionMode;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.CompositionScopedCoroutineScopeCanceller;
import androidx.compose.runtime.DisposableEffectResult;
import androidx.compose.runtime.DisposableEffectScope;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.window.AndroidPopup_androidKt;
import androidx.compose.ui.window.PopupPositionProvider;
import androidx.compose.ui.window.PopupProperties;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.RestrictedSuspendLambda;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowKt;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlowKt;

@Metadata(d1 = {"\u0000<\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\b\u0003\u001aa\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0011\u0010\u0004\u001a\r\u0012\u0004\u0012\u00020\u00010\u0005¢\u0006\u0002\b\u00062\u0006\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\b\b\u0002\u0010\r\u001a\u00020\f2\u0011\u0010\u000e\u001a\r\u0012\u0004\u0012\u00020\u00010\u0005¢\u0006\u0002\b\u0006H\u0001¢\u0006\u0002\u0010\u000f\u001a@\u0010\u0010\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u000b\u001a\u00020\f2\u0011\u0010\u000e\u001a\r\u0012\u0004\u0012\u00020\u00010\u0005¢\u0006\u0002\b\u0006H\u0003¢\u0006\u0002\u0010\u0013\u001a:\u0010\u0014\u001a\u00020\u00012\u0006\u0010\r\u001a\u00020\f2\u0006\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\n2\u0011\u0010\u000e\u001a\r\u0012\u0004\u0012\u00020\u00010\u0005¢\u0006\u0002\b\u0006H\u0003¢\u0006\u0002\u0010\u0015\u001a,\u0010\u0016\u001a\u00020\n*\u00020\n2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\f2\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\u0011\u001a\u00020\u0012H\u0002\u001a\u001c\u0010\u001a\u001a\u00020\n*\u00020\n2\u0006\u0010\u0019\u001a\u00020\f2\u0006\u0010\u0007\u001a\u00020\bH\u0002¨\u0006\u001b"}, d2 = {"BasicTooltipBox", "", "positionProvider", "Landroidx/compose/ui/window/PopupPositionProvider;", "tooltip", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "state", "Landroidx/compose/material3/TooltipState;", "modifier", "Landroidx/compose/ui/Modifier;", "focusable", "", "enableUserInput", "content", "(Landroidx/compose/ui/window/PopupPositionProvider;Lkotlin/jvm/functions/Function2;Landroidx/compose/material3/TooltipState;Landroidx/compose/ui/Modifier;ZZLkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "TooltipPopup", "scope", "Lkotlinx/coroutines/CoroutineScope;", "(Landroidx/compose/ui/window/PopupPositionProvider;Landroidx/compose/material3/TooltipState;Lkotlinx/coroutines/CoroutineScope;ZLkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "WrappedAnchor", "(ZLandroidx/compose/material3/TooltipState;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "anchorSemantics", "label", "", "enabled", "handleGestures", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class BasicTooltip_androidKt {
    public static final void BasicTooltipBox(final PopupPositionProvider popupPositionProvider, final Function2<? super Composer, ? super Integer, Unit> function2, final TooltipState tooltipState, Modifier modifier, boolean z, boolean z2, final Function2<? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        final boolean z3;
        int i5;
        int i6;
        boolean z4;
        int i7;
        int i8;
        int i9;
        Modifier modifier3;
        boolean z5;
        boolean z6;
        Object objRememberedValue;
        CoroutineScope coroutineScope;
        int currentCompositeKeyHash;
        Function0<ComposeUiNode> constructor;
        Composer composerM4037constructorimpl;
        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash;
        boolean z7;
        Object objRememberedValue2;
        final Modifier modifier4;
        final boolean z8;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-550509567);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(BasicTooltipBox)P(4,6,5,3,2,1)86@3910L24,87@3939L451,106@4420L35,106@4396L59:BasicTooltip.android.kt#mqatfk");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(popupPositionProvider) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? 32 : 16;
        }
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= (i & Fields.RotationY) == 0 ? composerStartRestartGroup.changed(tooltipState) : composerStartRestartGroup.changedInstance(tooltipState) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        int i10 = i2 & 8;
        if (i10 == 0) {
            if ((i & 3072) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? Fields.CameraDistance : Fields.RotationZ;
            }
            i4 = i2 & 16;
            if (i4 != 0) {
                if ((i & 24576) == 0) {
                    z3 = z;
                    if (composerStartRestartGroup.changed(z3)) {
                        i5 = Fields.Clip;
                    } else {
                        i5 = Fields.Shape;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 32;
                if (i6 != 0) {
                    if ((196608 & i) == 0) {
                        z4 = z2;
                        if (composerStartRestartGroup.changed(z4)) {
                            i7 = Fields.RenderEffect;
                        } else {
                            i7 = 65536;
                        }
                        i3 |= i7;
                    }
                    if ((i2 & 64) != 0) {
                        if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i8 = 1048576;
                            } else {
                                i8 = 524288;
                            }
                            i3 |= i8;
                        }
                        i9 = i3;
                        if ((599187 & i9) == 599186 || !composerStartRestartGroup.getSkipping()) {
                            if (i10 != 0) {
                                modifier3 = Modifier.INSTANCE;
                            } else {
                                modifier3 = modifier2;
                            }
                            z5 = true;
                            if (i4 != 0) {
                                z6 = true;
                            } else {
                                z6 = z3;
                            }
                            if (i6 != 0) {
                                z4 = true;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            Modifier.Companion companion = Modifier.INSTANCE;
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
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
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                            composerStartRestartGroup.startReplaceGroup(-625876949);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                            if (tooltipState.getIsVisible()) {
                                int i11 = i9 >> 3;
                                z7 = false;
                                TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i11 & 112) | (i11 & 7168) | (57344 & (i9 << 9)));
                            } else {
                                z7 = false;
                            }
                            composerStartRestartGroup.endReplaceGroup();
                            int i12 = i9 >> 3;
                            WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i12 & 112) | (i12 & 896) | ((i9 >> 9) & 7168), 0);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                            if ((i9 & 896) != 256 && ((i9 & Fields.RotationY) == 0 || !composerStartRestartGroup.changedInstance(tooltipState))) {
                                z5 = z7;
                            }
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!z5 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                    {
                                        super(1);
                                    }

                                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                        final TooltipState tooltipState2 = tooltipState;
                                        return new DisposableEffectResult() {
                                            @Override
                                            public void dispose() {
                                                tooltipState2.onDispose();
                                            }
                                        };
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier4 = modifier3;
                            z8 = z4;
                            z3 = z6;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier4 = modifier2;
                            z8 = z4;
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
                                    BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 1572864;
                    i9 = i3;
                    if ((599187 & i9) == 599186) {
                        if (i10 != 0) {
                            modifier3 = Modifier.INSTANCE;
                        } else {
                            modifier3 = modifier2;
                        }
                        z5 = true;
                        if (i4 != 0) {
                            z6 = true;
                        } else {
                            z6 = z3;
                        }
                        if (i6 != 0) {
                            z4 = true;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller2 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller2);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller2;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        Modifier.Companion companion2 = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion2);
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                        composerStartRestartGroup.startReplaceGroup(-625876949);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                        if (tooltipState.getIsVisible()) {
                            int i13 = i9 >> 3;
                            z7 = false;
                            TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i13 & 112) | (i13 & 7168) | (57344 & (i9 << 9)));
                        } else {
                            z7 = false;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i14 = i9 >> 3;
                        WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i14 & 112) | (i14 & 896) | ((i9 >> 9) & 7168), 0);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                        if ((i9 & 896) != 256) {
                            z5 = z7;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier4 = modifier3;
                        z8 = z4;
                        z3 = z6;
                    } else {
                        if (i10 != 0) {
                            modifier3 = Modifier.INSTANCE;
                        } else {
                            modifier3 = modifier2;
                        }
                        z5 = true;
                        if (i4 != 0) {
                            z6 = true;
                        } else {
                            z6 = z3;
                        }
                        if (i6 != 0) {
                            z4 = true;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller3 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller3);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller3;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        Modifier.Companion companion3 = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion3);
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                        composerStartRestartGroup.startReplaceGroup(-625876949);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                        if (tooltipState.getIsVisible()) {
                            int i15 = i9 >> 3;
                            z7 = false;
                            TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i15 & 112) | (i15 & 7168) | (57344 & (i9 << 9)));
                        } else {
                            z7 = false;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i16 = i9 >> 3;
                        WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i16 & 112) | (i16 & 896) | ((i9 >> 9) & 7168), 0);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                        if ((i9 & 896) != 256) {
                            z5 = z7;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier4 = modifier3;
                        z8 = z4;
                        z3 = z6;
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
                                BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                z4 = z2;
                if ((i2 & 64) != 0) {
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i8 = 1048576;
                        } else {
                            i8 = 524288;
                        }
                        i3 |= i8;
                    }
                    i9 = i3;
                    if ((599187 & i9) == 599186) {
                        if (i10 != 0) {
                            modifier3 = Modifier.INSTANCE;
                        } else {
                            modifier3 = modifier2;
                        }
                        z5 = true;
                        if (i4 != 0) {
                            z6 = true;
                        } else {
                            z6 = z3;
                        }
                        if (i6 != 0) {
                            z4 = true;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller4 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller4);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller4;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        Modifier.Companion companion4 = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy4 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion4);
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                        composerStartRestartGroup.startReplaceGroup(-625876949);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                        if (tooltipState.getIsVisible()) {
                            int i17 = i9 >> 3;
                            z7 = false;
                            TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i17 & 112) | (i17 & 7168) | (57344 & (i9 << 9)));
                        } else {
                            z7 = false;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i18 = i9 >> 3;
                        WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i18 & 112) | (i18 & 896) | ((i9 >> 9) & 7168), 0);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                        if ((i9 & 896) != 256) {
                            z5 = z7;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier4 = modifier3;
                        z8 = z4;
                        z3 = z6;
                    } else {
                        if (i10 != 0) {
                            modifier3 = Modifier.INSTANCE;
                        } else {
                            modifier3 = modifier2;
                        }
                        z5 = true;
                        if (i4 != 0) {
                            z6 = true;
                        } else {
                            z6 = z3;
                        }
                        if (i6 != 0) {
                            z4 = true;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller5 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller5);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller5;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        Modifier.Companion companion5 = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy5 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap5 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier5 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion5);
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                        composerStartRestartGroup.startReplaceGroup(-625876949);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                        if (tooltipState.getIsVisible()) {
                            int i19 = i9 >> 3;
                            z7 = false;
                            TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i19 & 112) | (i19 & 7168) | (57344 & (i9 << 9)));
                        } else {
                            z7 = false;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i110 = i9 >> 3;
                        WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i110 & 112) | (i110 & 896) | ((i9 >> 9) & 7168), 0);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                        if ((i9 & 896) != 256) {
                            z5 = z7;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier4 = modifier3;
                        z8 = z4;
                        z3 = z6;
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
                                BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 1572864;
                i9 = i3;
                if ((599187 & i9) == 599186) {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller6 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller6);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller6;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion6 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy6 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap6 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier6 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion6);
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i111 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i111 & 112) | (i111 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i112 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i112 & 112) | (i112 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
                } else {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller7 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller7);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller7;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion7 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy7 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap7 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier7 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion7);
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i113 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i113 & 112) | (i113 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i114 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i114 & 112) | (i114 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
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
                            BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z3 = z;
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    z4 = z2;
                    if (composerStartRestartGroup.changed(z4)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((i2 & 64) != 0) {
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i8 = 1048576;
                        } else {
                            i8 = 524288;
                        }
                        i3 |= i8;
                    }
                    i9 = i3;
                    if ((599187 & i9) == 599186) {
                        if (i10 != 0) {
                            modifier3 = Modifier.INSTANCE;
                        } else {
                            modifier3 = modifier2;
                        }
                        z5 = true;
                        if (i4 != 0) {
                            z6 = true;
                        } else {
                            z6 = z3;
                        }
                        if (i6 != 0) {
                            z4 = true;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller8 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller8);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller8;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        Modifier.Companion companion8 = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy8 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap8 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier8 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion8);
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                        composerStartRestartGroup.startReplaceGroup(-625876949);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                        if (tooltipState.getIsVisible()) {
                            int i115 = i9 >> 3;
                            z7 = false;
                            TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i115 & 112) | (i115 & 7168) | (57344 & (i9 << 9)));
                        } else {
                            z7 = false;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i116 = i9 >> 3;
                        WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i116 & 112) | (i116 & 896) | ((i9 >> 9) & 7168), 0);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                        if ((i9 & 896) != 256) {
                            z5 = z7;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier4 = modifier3;
                        z8 = z4;
                        z3 = z6;
                    } else {
                        if (i10 != 0) {
                            modifier3 = Modifier.INSTANCE;
                        } else {
                            modifier3 = modifier2;
                        }
                        z5 = true;
                        if (i4 != 0) {
                            z6 = true;
                        } else {
                            z6 = z3;
                        }
                        if (i6 != 0) {
                            z4 = true;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller9 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller9);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller9;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        Modifier.Companion companion9 = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy9 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap9 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier9 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion9);
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                        composerStartRestartGroup.startReplaceGroup(-625876949);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                        if (tooltipState.getIsVisible()) {
                            int i117 = i9 >> 3;
                            z7 = false;
                            TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i117 & 112) | (i117 & 7168) | (57344 & (i9 << 9)));
                        } else {
                            z7 = false;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i118 = i9 >> 3;
                        WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i118 & 112) | (i118 & 896) | ((i9 >> 9) & 7168), 0);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                        if ((i9 & 896) != 256) {
                            z5 = z7;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier4 = modifier3;
                        z8 = z4;
                        z3 = z6;
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

                            public final void invoke(Composer composer2, int i119) {
                                BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 1572864;
                i9 = i3;
                if ((599187 & i9) == 599186) {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller10 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller10);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller10;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion10 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy10 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap10 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier10 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion10);
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i119 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i119 & 112) | (i119 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1110 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i1110 & 112) | (i1110 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
                } else {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller11;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion11 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy11 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap11 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier11 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion11);
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i1111 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i1111 & 112) | (i1111 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1112 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i1112 & 112) | (i1112 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
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

                        public final void invoke(Composer composer2, int i1113) {
                            BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            z4 = z2;
            if ((i2 & 64) != 0) {
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = 1048576;
                    } else {
                        i8 = 524288;
                    }
                    i3 |= i8;
                }
                i9 = i3;
                if ((599187 & i9) == 599186) {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller12 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller12);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller12;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion12 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy12 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap12 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier12 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion12);
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i1113 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i1113 & 112) | (i1113 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1114 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i1114 & 112) | (i1114 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
                } else {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller13 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller13);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller13;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion13 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy13 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap13 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier13 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion13);
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i1115 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i1115 & 112) | (i1115 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1116 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i1116 & 112) | (i1116 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
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

                        public final void invoke(Composer composer2, int i1117) {
                            BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 1572864;
            i9 = i3;
            if ((599187 & i9) == 599186) {
                if (i10 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                z5 = true;
                if (i4 != 0) {
                    z6 = true;
                } else {
                    z6 = z3;
                }
                if (i6 != 0) {
                    z4 = true;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller14 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller14);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller14;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                Modifier.Companion companion14 = Modifier.INSTANCE;
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy14 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap14 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier14 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion14);
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                composerStartRestartGroup.startReplaceGroup(-625876949);
                ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                if (tooltipState.getIsVisible()) {
                    int i1117 = i9 >> 3;
                    z7 = false;
                    TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i1117 & 112) | (i1117 & 7168) | (57344 & (i9 << 9)));
                } else {
                    z7 = false;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i1118 = i9 >> 3;
                WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i1118 & 112) | (i1118 & 896) | ((i9 >> 9) & 7168), 0);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                if ((i9 & 896) != 256) {
                    z5 = z7;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                z8 = z4;
                z3 = z6;
            } else {
                if (i10 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                z5 = true;
                if (i4 != 0) {
                    z6 = true;
                } else {
                    z6 = z3;
                }
                if (i6 != 0) {
                    z4 = true;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller15 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller15);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller15;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                Modifier.Companion companion15 = Modifier.INSTANCE;
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy15 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap15 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier15 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion15);
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                composerStartRestartGroup.startReplaceGroup(-625876949);
                ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                if (tooltipState.getIsVisible()) {
                    int i1119 = i9 >> 3;
                    z7 = false;
                    TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i1119 & 112) | (i1119 & 7168) | (57344 & (i9 << 9)));
                } else {
                    z7 = false;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i11110 = i9 >> 3;
                WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i11110 & 112) | (i11110 & 896) | ((i9 >> 9) & 7168), 0);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                if ((i9 & 896) != 256) {
                    z5 = z7;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                z8 = z4;
                z3 = z6;
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

                    public final void invoke(Composer composer2, int i11111) {
                        BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        modifier2 = modifier;
        i4 = i2 & 16;
        if (i4 != 0) {
            if ((i & 24576) == 0) {
                z3 = z;
                if (composerStartRestartGroup.changed(z3)) {
                    i5 = Fields.Clip;
                } else {
                    i5 = Fields.Shape;
                }
                i3 |= i5;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                if ((196608 & i) == 0) {
                    z4 = z2;
                    if (composerStartRestartGroup.changed(z4)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((i2 & 64) != 0) {
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i8 = 1048576;
                        } else {
                            i8 = 524288;
                        }
                        i3 |= i8;
                    }
                    i9 = i3;
                    if ((599187 & i9) == 599186) {
                        if (i10 != 0) {
                            modifier3 = Modifier.INSTANCE;
                        } else {
                            modifier3 = modifier2;
                        }
                        z5 = true;
                        if (i4 != 0) {
                            z6 = true;
                        } else {
                            z6 = z3;
                        }
                        if (i6 != 0) {
                            z4 = true;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller16 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller16);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller16;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        Modifier.Companion companion16 = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy16 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap16 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier16 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion16);
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
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy16, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance16 = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                        composerStartRestartGroup.startReplaceGroup(-625876949);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                        if (tooltipState.getIsVisible()) {
                            int i11111 = i9 >> 3;
                            z7 = false;
                            TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i11111 & 112) | (i11111 & 7168) | (57344 & (i9 << 9)));
                        } else {
                            z7 = false;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i11112 = i9 >> 3;
                        WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i11112 & 112) | (i11112 & 896) | ((i9 >> 9) & 7168), 0);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                        if ((i9 & 896) != 256) {
                            z5 = z7;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier4 = modifier3;
                        z8 = z4;
                        z3 = z6;
                    } else {
                        if (i10 != 0) {
                            modifier3 = Modifier.INSTANCE;
                        } else {
                            modifier3 = modifier2;
                        }
                        z5 = true;
                        if (i4 != 0) {
                            z6 = true;
                        } else {
                            z6 = z3;
                        }
                        if (i6 != 0) {
                            z4 = true;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller17 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller17);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller17;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        Modifier.Companion companion17 = Modifier.INSTANCE;
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy17 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap17 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier17 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion17);
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
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy17, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance17 = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                        composerStartRestartGroup.startReplaceGroup(-625876949);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                        if (tooltipState.getIsVisible()) {
                            int i11113 = i9 >> 3;
                            z7 = false;
                            TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i11113 & 112) | (i11113 & 7168) | (57344 & (i9 << 9)));
                        } else {
                            z7 = false;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i11114 = i9 >> 3;
                        WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i11114 & 112) | (i11114 & 896) | ((i9 >> 9) & 7168), 0);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                        if ((i9 & 896) != 256) {
                            z5 = z7;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z5) {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                                {
                                    super(1);
                                }

                                public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                    final TooltipState tooltipState2 = tooltipState;
                                    return new DisposableEffectResult() {
                                        @Override
                                        public void dispose() {
                                            tooltipState2.onDispose();
                                        }
                                    };
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier4 = modifier3;
                        z8 = z4;
                        z3 = z6;
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

                            public final void invoke(Composer composer2, int i11115) {
                                BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 1572864;
                i9 = i3;
                if ((599187 & i9) == 599186) {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller18 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller18);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller18;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion18 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy18 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap18 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier18 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion18);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy18, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance18 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i11115 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i11115 & 112) | (i11115 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i11116 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i11116 & 112) | (i11116 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
                } else {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller19 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller19);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller19;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion19 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy19 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap19 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier19 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion19);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy19, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance19 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i11117 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i11117 & 112) | (i11117 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i11118 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i11118 & 112) | (i11118 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
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

                        public final void invoke(Composer composer2, int i11119) {
                            BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            z4 = z2;
            if ((i2 & 64) != 0) {
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = 1048576;
                    } else {
                        i8 = 524288;
                    }
                    i3 |= i8;
                }
                i9 = i3;
                if ((599187 & i9) == 599186) {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller110 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller110);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller110;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion110 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy110 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap110 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier110 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion110);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy110, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance110 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i11119 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i11119 & 112) | (i11119 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i111110 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i111110 & 112) | (i111110 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
                } else {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller111;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion111 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy111 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap111 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier111 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion111);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy111, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance111 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i111111 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i111111 & 112) | (i111111 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i111112 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i111112 & 112) | (i111112 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
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

                        public final void invoke(Composer composer2, int i111113) {
                            BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 1572864;
            i9 = i3;
            if ((599187 & i9) == 599186) {
                if (i10 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                z5 = true;
                if (i4 != 0) {
                    z6 = true;
                } else {
                    z6 = z3;
                }
                if (i6 != 0) {
                    z4 = true;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller112 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller112);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller112;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                Modifier.Companion companion112 = Modifier.INSTANCE;
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy112 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap112 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier112 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion112);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy112, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance112 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                composerStartRestartGroup.startReplaceGroup(-625876949);
                ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                if (tooltipState.getIsVisible()) {
                    int i111113 = i9 >> 3;
                    z7 = false;
                    TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i111113 & 112) | (i111113 & 7168) | (57344 & (i9 << 9)));
                } else {
                    z7 = false;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i111114 = i9 >> 3;
                WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i111114 & 112) | (i111114 & 896) | ((i9 >> 9) & 7168), 0);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                if ((i9 & 896) != 256) {
                    z5 = z7;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                z8 = z4;
                z3 = z6;
            } else {
                if (i10 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                z5 = true;
                if (i4 != 0) {
                    z6 = true;
                } else {
                    z6 = z3;
                }
                if (i6 != 0) {
                    z4 = true;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller113 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller113);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller113;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                Modifier.Companion companion113 = Modifier.INSTANCE;
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy113 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap113 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier113 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion113);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy113, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance113 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                composerStartRestartGroup.startReplaceGroup(-625876949);
                ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                if (tooltipState.getIsVisible()) {
                    int i111115 = i9 >> 3;
                    z7 = false;
                    TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i111115 & 112) | (i111115 & 7168) | (57344 & (i9 << 9)));
                } else {
                    z7 = false;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i111116 = i9 >> 3;
                WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i111116 & 112) | (i111116 & 896) | ((i9 >> 9) & 7168), 0);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                if ((i9 & 896) != 256) {
                    z5 = z7;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                z8 = z4;
                z3 = z6;
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

                    public final void invoke(Composer composer2, int i111117) {
                        BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        z3 = z;
        i6 = i2 & 32;
        if (i6 != 0) {
            if ((196608 & i) == 0) {
                z4 = z2;
                if (composerStartRestartGroup.changed(z4)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
            if ((i2 & 64) != 0) {
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i8 = 1048576;
                    } else {
                        i8 = 524288;
                    }
                    i3 |= i8;
                }
                i9 = i3;
                if ((599187 & i9) == 599186) {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller114 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller114);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller114;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion114 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy114 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap114 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier114 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion114);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy114, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance114 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i111117 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i111117 & 112) | (i111117 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i111118 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i111118 & 112) | (i111118 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
                } else {
                    if (i10 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    z5 = true;
                    if (i4 != 0) {
                        z6 = true;
                    } else {
                        z6 = z3;
                    }
                    if (i6 != 0) {
                        z4 = true;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller115 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller115);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller115;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    Modifier.Companion companion115 = Modifier.INSTANCE;
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy115 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap115 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier115 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion115);
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
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy115, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                    BoxScopeInstance boxScopeInstance115 = BoxScopeInstance.INSTANCE;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                    composerStartRestartGroup.startReplaceGroup(-625876949);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                    if (tooltipState.getIsVisible()) {
                        int i111119 = i9 >> 3;
                        z7 = false;
                        TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i111119 & 112) | (i111119 & 7168) | (57344 & (i9 << 9)));
                    } else {
                        z7 = false;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1111110 = i9 >> 3;
                    WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i1111110 & 112) | (i1111110 & 896) | ((i9 >> 9) & 7168), 0);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                    if ((i9 & 896) != 256) {
                        z5 = z7;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z5) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                final TooltipState tooltipState2 = tooltipState;
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                        tooltipState2.onDispose();
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier4 = modifier3;
                    z8 = z4;
                    z3 = z6;
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

                        public final void invoke(Composer composer2, int i1111111) {
                            BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 1572864;
            i9 = i3;
            if ((599187 & i9) == 599186) {
                if (i10 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                z5 = true;
                if (i4 != 0) {
                    z6 = true;
                } else {
                    z6 = z3;
                }
                if (i6 != 0) {
                    z4 = true;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller116 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller116);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller116;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                Modifier.Companion companion116 = Modifier.INSTANCE;
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy116 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap116 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier116 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion116);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy116, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance116 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                composerStartRestartGroup.startReplaceGroup(-625876949);
                ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                if (tooltipState.getIsVisible()) {
                    int i1111111 = i9 >> 3;
                    z7 = false;
                    TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i1111111 & 112) | (i1111111 & 7168) | (57344 & (i9 << 9)));
                } else {
                    z7 = false;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i1111112 = i9 >> 3;
                WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i1111112 & 112) | (i1111112 & 896) | ((i9 >> 9) & 7168), 0);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                if ((i9 & 896) != 256) {
                    z5 = z7;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                z8 = z4;
                z3 = z6;
            } else {
                if (i10 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                z5 = true;
                if (i4 != 0) {
                    z6 = true;
                } else {
                    z6 = z3;
                }
                if (i6 != 0) {
                    z4 = true;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller117 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller117);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller117;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                Modifier.Companion companion117 = Modifier.INSTANCE;
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy117 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap117 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier117 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion117);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy117, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance117 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                composerStartRestartGroup.startReplaceGroup(-625876949);
                ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                if (tooltipState.getIsVisible()) {
                    int i1111113 = i9 >> 3;
                    z7 = false;
                    TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i1111113 & 112) | (i1111113 & 7168) | (57344 & (i9 << 9)));
                } else {
                    z7 = false;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i1111114 = i9 >> 3;
                WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i1111114 & 112) | (i1111114 & 896) | ((i9 >> 9) & 7168), 0);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                if ((i9 & 896) != 256) {
                    z5 = z7;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                z8 = z4;
                z3 = z6;
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

                    public final void invoke(Composer composer2, int i1111115) {
                        BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        z4 = z2;
        if ((i2 & 64) != 0) {
            if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i8 = 1048576;
                } else {
                    i8 = 524288;
                }
                i3 |= i8;
            }
            i9 = i3;
            if ((599187 & i9) == 599186) {
                if (i10 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                z5 = true;
                if (i4 != 0) {
                    z6 = true;
                } else {
                    z6 = z3;
                }
                if (i6 != 0) {
                    z4 = true;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller118 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller118);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller118;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                Modifier.Companion companion118 = Modifier.INSTANCE;
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy118 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap118 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier118 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion118);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy118, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance118 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                composerStartRestartGroup.startReplaceGroup(-625876949);
                ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                if (tooltipState.getIsVisible()) {
                    int i1111115 = i9 >> 3;
                    z7 = false;
                    TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i1111115 & 112) | (i1111115 & 7168) | (57344 & (i9 << 9)));
                } else {
                    z7 = false;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i1111116 = i9 >> 3;
                WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i1111116 & 112) | (i1111116 & 896) | ((i9 >> 9) & 7168), 0);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                if ((i9 & 896) != 256) {
                    z5 = z7;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                z8 = z4;
                z3 = z6;
            } else {
                if (i10 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                z5 = true;
                if (i4 != 0) {
                    z6 = true;
                } else {
                    z6 = z3;
                }
                if (i6 != 0) {
                    z4 = true;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller119 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller119);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller119;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                Modifier.Companion companion119 = Modifier.INSTANCE;
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy119 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap119 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier119 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion119);
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
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy119, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance119 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
                composerStartRestartGroup.startReplaceGroup(-625876949);
                ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
                if (tooltipState.getIsVisible()) {
                    int i1111117 = i9 >> 3;
                    z7 = false;
                    TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i1111117 & 112) | (i1111117 & 7168) | (57344 & (i9 << 9)));
                } else {
                    z7 = false;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i1111118 = i9 >> 3;
                WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i1111118 & 112) | (i1111118 & 896) | ((i9 >> 9) & 7168), 0);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
                if ((i9 & 896) != 256) {
                    z5 = z7;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z5) {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            final TooltipState tooltipState2 = tooltipState;
                            return new DisposableEffectResult() {
                                @Override
                                public void dispose() {
                                    tooltipState2.onDispose();
                                }
                            };
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
                z8 = z4;
                z3 = z6;
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

                    public final void invoke(Composer composer2, int i1111119) {
                        BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 1572864;
        i9 = i3;
        if ((599187 & i9) == 599186) {
            if (i10 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            z5 = true;
            if (i4 != 0) {
                z6 = true;
            } else {
                z6 = z3;
            }
            if (i6 != 0) {
                z4 = true;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1110 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1110);
                objRememberedValue = compositionScopedCoroutineScopeCanceller1110;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            Modifier.Companion companion1110 = Modifier.INSTANCE;
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy1110 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap1110 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier1110 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion1110);
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
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy1110, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance1110 = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
            composerStartRestartGroup.startReplaceGroup(-625876949);
            ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
            if (tooltipState.getIsVisible()) {
                int i1111119 = i9 >> 3;
                z7 = false;
                TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i1111119 & 112) | (i1111119 & 7168) | (57344 & (i9 << 9)));
            } else {
                z7 = false;
            }
            composerStartRestartGroup.endReplaceGroup();
            int i11111110 = i9 >> 3;
            WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i11111110 & 112) | (i11111110 & 896) | ((i9 >> 9) & 7168), 0);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
            if ((i9 & 896) != 256) {
                z5 = z7;
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z5) {
                objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                    {
                        super(1);
                    }

                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                        final TooltipState tooltipState2 = tooltipState;
                        return new DisposableEffectResult() {
                            @Override
                            public void dispose() {
                                tooltipState2.onDispose();
                            }
                        };
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                    {
                        super(1);
                    }

                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                        final TooltipState tooltipState2 = tooltipState;
                        return new DisposableEffectResult() {
                            @Override
                            public void dispose() {
                                tooltipState2.onDispose();
                            }
                        };
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
            z8 = z4;
            z3 = z6;
        } else {
            if (i10 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            z5 = true;
            if (i4 != 0) {
                z6 = true;
            } else {
                z6 = z3;
            }
            if (i6 != 0) {
                z4 = true;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-550509567, i9, -1, "androidx.compose.material3.internal.BasicTooltipBox (BasicTooltip.android.kt:85)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1111 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1111);
                objRememberedValue = compositionScopedCoroutineScopeCanceller1111;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            Modifier.Companion companion1111 = Modifier.INSTANCE;
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy1111 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap1111 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier1111 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion1111);
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
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy1111, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance1111 = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2072656365, "C98@4223L161:BasicTooltip.android.kt#mqatfk");
            composerStartRestartGroup.startReplaceGroup(-625876949);
            ComposerKt.sourceInformation(composerStartRestartGroup, "89@3988L215");
            if (tooltipState.getIsVisible()) {
                int i11111111 = i9 >> 3;
                z7 = false;
                TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z6, function2, composerStartRestartGroup, (i9 & 14) | (i11111111 & 112) | (i11111111 & 7168) | (57344 & (i9 << 9)));
            } else {
                z7 = false;
            }
            composerStartRestartGroup.endReplaceGroup();
            int i11111112 = i9 >> 3;
            WrappedAnchor(z4, tooltipState, modifier3, function3, composerStartRestartGroup, ((i9 >> 15) & 14) | (i11111112 & 112) | (i11111112 & 896) | ((i9 >> 9) & 7168), 0);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1907285077, "CC(remember):BasicTooltip.android.kt#9igjgp");
            if ((i9 & 896) != 256) {
                z5 = z7;
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z5) {
                objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                    {
                        super(1);
                    }

                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                        final TooltipState tooltipState2 = tooltipState;
                        return new DisposableEffectResult() {
                            @Override
                            public void dispose() {
                                tooltipState2.onDispose();
                            }
                        };
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                    {
                        super(1);
                    }

                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                        final TooltipState tooltipState2 = tooltipState;
                        return new DisposableEffectResult() {
                            @Override
                            public void dispose() {
                                tooltipState2.onDispose();
                            }
                        };
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            EffectsKt.DisposableEffect(tooltipState, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue2, composerStartRestartGroup, (i9 >> 6) & 14);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
            z8 = z4;
            z3 = z6;
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

                public final void invoke(Composer composer2, int i11111113) {
                    BasicTooltip_androidKt.BasicTooltipBox(popupPositionProvider, function2, tooltipState, modifier4, z3, z8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void WrappedAnchor(final boolean z, final TooltipState tooltipState, Modifier modifier, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(1848240995);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(WrappedAnchor)P(1,3,2)116@4644L24,117@4694L38,118@4737L212:BasicTooltip.android.kt#mqatfk");
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
            i3 |= (i & 64) == 0 ? composerStartRestartGroup.changed(tooltipState) : composerStartRestartGroup.changedInstance(tooltipState) ? 32 : 16;
        }
        int i4 = i2 & 4;
        if (i4 != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changed(modifier) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i2 & 8) != 0) {
            i3 |= 3072;
        } else if ((i & 3072) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i3 & 1171) == 1170 && composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.skipToGroupEnd();
        } else {
            if (i4 != 0) {
                modifier = Modifier.INSTANCE;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1848240995, i3, -1, "androidx.compose.material3.internal.WrappedAnchor (BasicTooltip.android.kt:115)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller);
                objRememberedValue = compositionScopedCoroutineScopeCanceller;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CoroutineScope coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierAnchorSemantics = anchorSemantics(handleGestures(modifier, z, tooltipState), StringResources_androidKt.stringResource(C0399R.string.tooltip_label, composerStartRestartGroup, 0), z, tooltipState, coroutineScope);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierAnchorSemantics);
            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
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
            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 400210223, "C124@4934L9:BasicTooltip.android.kt#mqatfk");
            function2.invoke(composerStartRestartGroup, Integer.valueOf((i3 >> 9) & 14));
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        final Modifier modifier2 = modifier;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i5) {
                    BasicTooltip_androidKt.WrappedAnchor(z, tooltipState, modifier2, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void TooltipPopup(final PopupPositionProvider popupPositionProvider, final TooltipState tooltipState, final CoroutineScope coroutineScope, final boolean z, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(-273292979);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(TooltipPopup)P(2,4,3,1)136@5181L44,139@5314L109,145@5491L251,137@5230L512:BasicTooltip.android.kt#mqatfk");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changed(popupPositionProvider) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= (i & 64) == 0 ? composerStartRestartGroup.changed(tooltipState) : composerStartRestartGroup.changedInstance(tooltipState) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(coroutineScope) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i & 3072) == 0) {
            i2 |= composerStartRestartGroup.changed(z) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i & 24576) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function2) ? Fields.Clip : Fields.Shape;
        }
        if ((i2 & 9363) != 9362 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-273292979, i2, -1, "androidx.compose.material3.internal.TooltipPopup (BasicTooltip.android.kt:135)");
            }
            boolean z2 = false;
            final String strStringResource = StringResources_androidKt.stringResource(C0399R.string.tooltip_description, composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 162917156, "CC(remember):BasicTooltip.android.kt#9igjgp");
            if ((i2 & 112) == 32 || ((i2 & 64) != 0 && composerStartRestartGroup.changedInstance(tooltipState))) {
                z2 = true;
            }
            boolean zChangedInstance = composerStartRestartGroup.changedInstance(coroutineScope) | z2;
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (zChangedInstance || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = (Function0) new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m3249invoke();
                        return Unit.INSTANCE;
                    }

                    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
                    @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$TooltipPopup$1$1$1", f = "BasicTooltip.android.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
                    static final class C14791 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                        final TooltipState $state;
                        int label;

                        C14791(TooltipState tooltipState, Continuation<? super C14791> continuation) {
                            super(2, continuation);
                            this.$state = tooltipState;
                        }

                        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                            return new C14791(this.$state, continuation);
                        }

                        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                        }

                        public final Object invokeSuspend(Object obj) {
                            IntrinsicsKt.getCOROUTINE_SUSPENDED();
                            if (this.label != 0) {
                                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                            }
                            ResultKt.throwOnFailure(obj);
                            this.$state.dismiss();
                            return Unit.INSTANCE;
                        }
                    }

                    public final void m3249invoke() {
                        if (tooltipState.getIsVisible()) {
                            BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C14791(tooltipState, null), 3, (Object) null);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            AndroidPopup_androidKt.Popup(popupPositionProvider, (Function0) objRememberedValue, new PopupProperties(z, false, false, false, 14, (DefaultConstructorMarker) null), ComposableLambdaKt.rememberComposableLambda(610617071, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i3) {
                    ComposerKt.sourceInformation(composer2, "C148@5564L128,146@5501L235:BasicTooltip.android.kt#mqatfk");
                    if ((i3 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(610617071, i3, -1, "androidx.compose.material3.internal.TooltipPopup.<anonymous> (BasicTooltip.android.kt:146)");
                        }
                        Modifier.Companion companion = Modifier.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer2, 1377587702, "CC(remember):BasicTooltip.android.kt#9igjgp");
                        boolean zChanged = composer2.changed(strStringResource);
                        final String str = strStringResource;
                        Object objRememberedValue2 = composer2.rememberedValue();
                        if (zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    SemanticsPropertiesKt.m6629setLiveRegionhR3wRGc(semanticsPropertyReceiver, LiveRegionMode.INSTANCE.m6602getAssertive0phEisY());
                                    SemanticsPropertiesKt.setPaneTitle(semanticsPropertyReceiver, str);
                                }
                            };
                            composer2.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(companion, false, (Function1) objRememberedValue2, 1, null);
                        Function2<Composer, Integer, Unit> function3 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierSemantics$default);
                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composer2.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composer2.startReusableNode();
                        if (composer2.getInserting()) {
                            composer2.createNode(constructor);
                        } else {
                            composer2.useNode();
                        }
                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer2);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                        ComposerKt.sourceInformationMarkerStart(composer2, -1900261851, "C153@5717L9:BasicTooltip.android.kt#mqatfk");
                        function3.invoke(composer2, 0);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2 & 14) | 3072, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i3) {
                    BasicTooltip_androidKt.TooltipPopup(popupPositionProvider, tooltipState, coroutineScope, z, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$handleGestures$1", f = "BasicTooltip.android.kt", i = {}, l = {162}, m = "invokeSuspend", n = {}, s = {})
    static final class C14841 extends SuspendLambda implements Function2<PointerInputScope, Continuation<? super Unit>, Object> {
        final TooltipState $state;
        private Object L$0;
        int label;

        C14841(TooltipState tooltipState, Continuation<? super C14841> continuation) {
            super(2, continuation);
            this.$state = tooltipState;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c14841 = new C14841(this.$state, continuation);
            c14841.L$0 = obj;
            return c14841;
        }

        public final Object invoke(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) {
            return create(pointerInputScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$handleGestures$1$1", f = "BasicTooltip.android.kt", i = {}, l = {163}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final PointerInputScope $$this$pointerInput;
            final TooltipState $state;
            private Object L$0;
            int label;

            AnonymousClass1(PointerInputScope pointerInputScope, TooltipState tooltipState, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.$$this$pointerInput = pointerInputScope;
                this.$state = tooltipState;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass1 = new AnonymousClass1(this.$$this$pointerInput, this.$state, continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$handleGestures$1$1$1", f = "BasicTooltip.android.kt", i = {0, 0, 0, 0, 1, 1, 1, 2}, l = {171, 177, 197}, m = "invokeSuspend", n = {"$this$awaitEachGesture", "isLongPressedFlow", "pass", "longPressTimeout", "$this$awaitEachGesture", "isLongPressedFlow", "pass", "isLongPressedFlow"}, s = {"L$0", "L$1", "L$2", "J$0", "L$0", "L$1", "L$2", "L$0"})
            static final class C18101 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
                final CoroutineScope $$this$coroutineScope;
                final TooltipState $state;
                long J$0;
                private Object L$0;
                Object L$1;
                Object L$2;
                int label;

                C18101(CoroutineScope coroutineScope, TooltipState tooltipState, Continuation<? super C18101> continuation) {
                    super(2, continuation);
                    this.$$this$coroutineScope = coroutineScope;
                    this.$state = tooltipState;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    Continuation<Unit> c18101 = new C18101(this.$$this$coroutineScope, this.$state, continuation);
                    c18101.L$0 = obj;
                    return c18101;
                }

                public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
                    return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final Object invokeSuspend(Object obj) throws Throwable {
                    MutableStateFlow MutableStateFlow;
                    Object objAwaitFirstDown$default;
                    AwaitPointerEventScope awaitPointerEventScope;
                    PointerEventPass pointerEventPass;
                    long j;
                    PointerEventPass pointerEventPass2;
                    AwaitPointerEventScope awaitPointerEventScope2;
                    MutableStateFlow mutableStateFlow;
                    MutableStateFlow mutableStateFlow2;
                    Object objWaitForUpOrCancellation;
                    PointerInputChange pointerInputChange;
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    MutableStateFlow mutableStateFlow3 = this.label;
                    try {
                        if (mutableStateFlow3 == 0) {
                            ResultKt.throwOnFailure(obj);
                            AwaitPointerEventScope awaitPointerEventScope3 = (AwaitPointerEventScope) this.L$0;
                            MutableStateFlow = StateFlowKt.MutableStateFlow(Boxing.boxBoolean(false));
                            long longPressTimeoutMillis = awaitPointerEventScope3.getViewConfiguration().getLongPressTimeoutMillis();
                            PointerEventPass pointerEventPass3 = PointerEventPass.Initial;
                            this.L$0 = awaitPointerEventScope3;
                            this.L$1 = MutableStateFlow;
                            this.L$2 = pointerEventPass3;
                            this.J$0 = longPressTimeoutMillis;
                            this.label = 1;
                            objAwaitFirstDown$default = TapGestureDetectorKt.awaitFirstDown$default(awaitPointerEventScope3, false, pointerEventPass3, (Continuation) this, 1, null);
                            if (objAwaitFirstDown$default == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            awaitPointerEventScope = awaitPointerEventScope3;
                            pointerEventPass = pointerEventPass3;
                            j = longPressTimeoutMillis;
                        } else {
                            if (mutableStateFlow3 != 1) {
                                if (mutableStateFlow3 != 2) {
                                    if (mutableStateFlow3 != 3) {
                                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                                    }
                                    MutableStateFlow mutableStateFlow4 = (MutableStateFlow) this.L$0;
                                    ResultKt.throwOnFailure(obj);
                                    objWaitForUpOrCancellation = obj;
                                    mutableStateFlow3 = mutableStateFlow4;
                                    pointerInputChange = (PointerInputChange) objWaitForUpOrCancellation;
                                    if (pointerInputChange != null) {
                                        pointerInputChange.consume();
                                    }
                                    mutableStateFlow3.tryEmit(Boxing.boxBoolean(false));
                                    return Unit.INSTANCE;
                                }
                                PointerEventPass pointerEventPass4 = (PointerEventPass) this.L$2;
                                mutableStateFlow2 = (MutableStateFlow) this.L$1;
                                awaitPointerEventScope2 = (AwaitPointerEventScope) this.L$0;
                                try {
                                    ResultKt.throwOnFailure(obj);
                                    mutableStateFlow2.tryEmit(Boxing.boxBoolean(false));
                                } catch (PointerEventTimeoutCancellationException unused) {
                                    pointerEventPass2 = pointerEventPass4;
                                    mutableStateFlow = mutableStateFlow2;
                                    BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass2(mutableStateFlow, this.$state, null), 1, (Object) null);
                                    this.L$0 = mutableStateFlow;
                                    this.L$1 = null;
                                    this.L$2 = null;
                                    this.label = 3;
                                    objWaitForUpOrCancellation = TapGestureDetectorKt.waitForUpOrCancellation(awaitPointerEventScope2, pointerEventPass2, (Continuation) this);
                                    mutableStateFlow3 = mutableStateFlow;
                                    if (objWaitForUpOrCancellation == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                    pointerInputChange = (PointerInputChange) objWaitForUpOrCancellation;
                                    if (pointerInputChange != null) {
                                        pointerInputChange.consume();
                                    }
                                    mutableStateFlow3.tryEmit(Boxing.boxBoolean(false));
                                } catch (Throwable th) {
                                    th = th;
                                    mutableStateFlow3 = mutableStateFlow2;
                                    mutableStateFlow3.tryEmit(Boxing.boxBoolean(false));
                                    throw th;
                                }
                                return Unit.INSTANCE;
                            }
                            j = this.J$0;
                            pointerEventPass = (PointerEventPass) this.L$2;
                            MutableStateFlow mutableStateFlow5 = (MutableStateFlow) this.L$1;
                            awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                            ResultKt.throwOnFailure(obj);
                            MutableStateFlow = mutableStateFlow5;
                            objAwaitFirstDown$default = obj;
                        }
                        int type = ((PointerInputChange) objAwaitFirstDown$default).getType();
                        if (PointerType.m5919equalsimpl0(type, PointerType.INSTANCE.m5926getTouchT8wyACA()) || PointerType.m5919equalsimpl0(type, PointerType.INSTANCE.m5925getStylusT8wyACA())) {
                            try {
                                this.L$0 = awaitPointerEventScope;
                                this.L$1 = MutableStateFlow;
                                this.L$2 = pointerEventPass;
                                this.label = 2;
                                if (awaitPointerEventScope.withTimeout(j, new C18111(pointerEventPass, null), (Continuation) this) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                mutableStateFlow2 = MutableStateFlow;
                                mutableStateFlow2.tryEmit(Boxing.boxBoolean(false));
                            } catch (PointerEventTimeoutCancellationException unused2) {
                                pointerEventPass2 = pointerEventPass;
                                awaitPointerEventScope2 = awaitPointerEventScope;
                                mutableStateFlow = MutableStateFlow;
                                BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass2(mutableStateFlow, this.$state, null), 1, (Object) null);
                                this.L$0 = mutableStateFlow;
                                this.L$1 = null;
                                this.L$2 = null;
                                this.label = 3;
                                objWaitForUpOrCancellation = TapGestureDetectorKt.waitForUpOrCancellation(awaitPointerEventScope2, pointerEventPass2, (Continuation) this);
                                mutableStateFlow3 = mutableStateFlow;
                                if (objWaitForUpOrCancellation == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                pointerInputChange = (PointerInputChange) objWaitForUpOrCancellation;
                                if (pointerInputChange != null) {
                                    pointerInputChange.consume();
                                }
                                mutableStateFlow3.tryEmit(Boxing.boxBoolean(false));
                            } catch (Throwable th2) {
                                th = th2;
                                mutableStateFlow3 = MutableStateFlow;
                                mutableStateFlow3.tryEmit(Boxing.boxBoolean(false));
                                throw th;
                            }
                        }
                        return Unit.INSTANCE;
                    } catch (Throwable th3) {
                        th = th3;
                    }
                }

                @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Landroidx/compose/ui/input/pointer/PointerInputChange;", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
                @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$handleGestures$1$1$1$1", f = "BasicTooltip.android.kt", i = {}, l = {178}, m = "invokeSuspend", n = {}, s = {})
                static final class C18111 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super PointerInputChange>, Object> {
                    final PointerEventPass $pass;
                    private Object L$0;
                    int label;

                    C18111(PointerEventPass pointerEventPass, Continuation<? super C18111> continuation) {
                        super(2, continuation);
                        this.$pass = pointerEventPass;
                    }

                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        Continuation<Unit> c18111 = new C18111(this.$pass, continuation);
                        c18111.L$0 = obj;
                        return c18111;
                    }

                    public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super PointerInputChange> continuation) {
                        return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
                    }

                    public final Object invokeSuspend(Object obj) {
                        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                        int i = this.label;
                        if (i == 0) {
                            ResultKt.throwOnFailure(obj);
                            this.label = 1;
                            obj = TapGestureDetectorKt.waitForUpOrCancellation((AwaitPointerEventScope) this.L$0, this.$pass, (Continuation) this);
                            if (obj == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        } else {
                            if (i != 1) {
                                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                            }
                            ResultKt.throwOnFailure(obj);
                        }
                        return obj;
                    }
                }

                @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
                @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$handleGestures$1$1$1$2", f = "BasicTooltip.android.kt", i = {}, l = {185, 187, 187}, m = "invokeSuspend", n = {}, s = {})
                static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    final MutableStateFlow<Boolean> $isLongPressedFlow;
                    final TooltipState $state;
                    Object L$0;
                    int label;

                    AnonymousClass2(MutableStateFlow<Boolean> mutableStateFlow, TooltipState tooltipState, Continuation<? super AnonymousClass2> continuation) {
                        super(2, continuation);
                        this.$isLongPressedFlow = mutableStateFlow;
                        this.$state = tooltipState;
                    }

                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new AnonymousClass2(this.$isLongPressedFlow, this.$state, continuation);
                    }

                    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                    }

                    public final Object invokeSuspend(Object obj) throws Throwable {
                        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                        int i = this.label;
                        Continuation continuation = null;
                        int i2 = 3;
                        try {
                            if (i == 0) {
                                ResultKt.throwOnFailure(obj);
                                this.$isLongPressedFlow.tryEmit(Boxing.boxBoolean(true));
                                this.label = 1;
                                if (this.$state.show(MutatePriority.PreventUserInput, (Continuation) this) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                            } else {
                                if (i == 1) {
                                    ResultKt.throwOnFailure(obj);
                                } else {
                                    if (i != 2) {
                                        if (i != 3) {
                                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                                        }
                                        Throwable th = (Throwable) this.L$0;
                                        ResultKt.throwOnFailure(obj);
                                        throw th;
                                    }
                                    ResultKt.throwOnFailure(obj);
                                }
                                return Unit.INSTANCE;
                            }
                            Flow flow = this.$isLongPressedFlow;
                            i2 = this.$state;
                            C18121 c18121 = new C18121(i2, null);
                            continuation = (Continuation) this;
                            this.label = 2;
                            if (FlowKt.collectLatest(flow, c18121, continuation) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return Unit.INSTANCE;
                        } catch (Throwable th2) {
                            this.L$0 = th2;
                            this.label = i2;
                            if (FlowKt.collectLatest(this.$isLongPressedFlow, new C18121(this.$state, continuation), (Continuation) this) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            throw th2;
                        }
                    }

                    @Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u008a@"}, d2 = {"<anonymous>", "", "isLongPressed", ""}, k = 3, mv = {1, 8, 0}, xi = 48)
                    @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$handleGestures$1$1$1$2$1", f = "BasicTooltip.android.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
                    static final class C18121 extends SuspendLambda implements Function2<Boolean, Continuation<? super Unit>, Object> {
                        final TooltipState $state;
                        boolean Z$0;
                        int label;

                        C18121(TooltipState tooltipState, Continuation<? super C18121> continuation) {
                            super(2, continuation);
                            this.$state = tooltipState;
                        }

                        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                            Continuation<Unit> c18121 = new C18121(this.$state, continuation);
                            c18121.Z$0 = ((Boolean) obj).booleanValue();
                            return c18121;
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke(((Boolean) obj).booleanValue(), (Continuation<? super Unit>) obj2);
                        }

                        public final Object invoke(boolean z, Continuation<? super Unit> continuation) {
                            return create(Boolean.valueOf(z), continuation).invokeSuspend(Unit.INSTANCE);
                        }

                        public final Object invokeSuspend(Object obj) {
                            IntrinsicsKt.getCOROUTINE_SUSPENDED();
                            if (this.label != 0) {
                                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                            }
                            ResultKt.throwOnFailure(obj);
                            if (!this.Z$0) {
                                this.$state.dismiss();
                            }
                            return Unit.INSTANCE;
                        }
                    }
                }
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                    this.label = 1;
                    if (ForEachGestureKt.awaitEachGesture(this.$$this$pointerInput, new C18101(coroutineScope, this.$state, null), (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (CoroutineScopeKt.coroutineScope(new AnonymousClass1((PointerInputScope) this.L$0, this.$state, null), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    private static final Modifier handleGestures(Modifier modifier, boolean z, TooltipState tooltipState) {
        return z ? SuspendingPointerInputFilterKt.pointerInput(SuspendingPointerInputFilterKt.pointerInput(modifier, tooltipState, new C14841(tooltipState, null)), tooltipState, new C14852(tooltipState, null)) : modifier;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$handleGestures$2", f = "BasicTooltip.android.kt", i = {}, l = {ComposerKt.reuseKey}, m = "invokeSuspend", n = {}, s = {})
    static final class C14852 extends SuspendLambda implements Function2<PointerInputScope, Continuation<? super Unit>, Object> {
        final TooltipState $state;
        private Object L$0;
        int label;

        C14852(TooltipState tooltipState, Continuation<? super C14852> continuation) {
            super(2, continuation);
            this.$state = tooltipState;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c14852 = new C14852(this.$state, continuation);
            c14852.L$0 = obj;
            return c14852;
        }

        public final Object invoke(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) {
            return create(pointerInputScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$handleGestures$2$1", f = "BasicTooltip.android.kt", i = {}, l = {208}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final PointerInputScope $$this$pointerInput;
            final TooltipState $state;
            private Object L$0;
            int label;

            AnonymousClass1(PointerInputScope pointerInputScope, TooltipState tooltipState, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.$$this$pointerInput = pointerInputScope;
                this.$state = tooltipState;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass1 = new AnonymousClass1(this.$$this$pointerInput, this.$state, continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$handleGestures$2$1$1", f = "BasicTooltip.android.kt", i = {0, 0}, l = {212}, m = "invokeSuspend", n = {"$this$awaitPointerEventScope", "pass"}, s = {"L$0", "L$1"})
            static final class C18131 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
                final CoroutineScope $$this$coroutineScope;
                final TooltipState $state;
                private Object L$0;
                Object L$1;
                int label;

                C18131(CoroutineScope coroutineScope, TooltipState tooltipState, Continuation<? super C18131> continuation) {
                    super(2, continuation);
                    this.$$this$coroutineScope = coroutineScope;
                    this.$state = tooltipState;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    Continuation<Unit> c18131 = new C18131(this.$$this$coroutineScope, this.$state, continuation);
                    c18131.L$0 = obj;
                    return c18131;
                }

                public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
                    return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final java.lang.Object invokeSuspend(java.lang.Object r12) {
                    throw new UnsupportedOperationException("Method not decompiled: androidx.compose.material3.internal.BasicTooltip_androidKt.C14852.AnonymousClass1.C18131.invokeSuspend(java.lang.Object):java.lang.Object");
                }

                @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
                @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$handleGestures$2$1$1$1", f = "BasicTooltip.android.kt", i = {}, l = {217}, m = "invokeSuspend", n = {}, s = {})
                static final class C18141 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    final TooltipState $state;
                    int label;

                    C18141(TooltipState tooltipState, Continuation<? super C18141> continuation) {
                        super(2, continuation);
                        this.$state = tooltipState;
                    }

                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new C18141(this.$state, continuation);
                    }

                    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                    }

                    public final Object invokeSuspend(Object obj) {
                        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                        int i = this.label;
                        if (i == 0) {
                            ResultKt.throwOnFailure(obj);
                            this.label = 1;
                            if (this.$state.show(MutatePriority.UserInput, (Continuation) this) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        } else {
                            if (i != 1) {
                                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                            }
                            ResultKt.throwOnFailure(obj);
                        }
                        return Unit.INSTANCE;
                    }
                }
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                    this.label = 1;
                    if (this.$$this$pointerInput.awaitPointerEventScope(new C18131(coroutineScope, this.$state, null), (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (CoroutineScopeKt.coroutineScope(new AnonymousClass1((PointerInputScope) this.L$0, this.$state, null), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    private static final Modifier anchorSemantics(Modifier modifier, final String str, boolean z, final TooltipState tooltipState, final CoroutineScope coroutineScope) {
        return z ? SemanticsModifierKt.semantics(modifier, true, new Function1<SemanticsPropertyReceiver, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((SemanticsPropertyReceiver) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                String str2 = str;
                final CoroutineScope coroutineScope2 = coroutineScope;
                final TooltipState tooltipState2 = tooltipState;
                SemanticsPropertiesKt.onLongClick(semanticsPropertyReceiver, str2, new Function0<Boolean>() {
                    {
                        super(0);
                    }

                    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
                    @DebugMetadata(c = "androidx.compose.material3.internal.BasicTooltip_androidKt$anchorSemantics$1$1$1", f = "BasicTooltip.android.kt", i = {}, l = {241}, m = "invokeSuspend", n = {}, s = {})
                    static final class C18091 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                        final TooltipState $state;
                        int label;

                        C18091(TooltipState tooltipState, Continuation<? super C18091> continuation) {
                            super(2, continuation);
                            this.$state = tooltipState;
                        }

                        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                            return new C18091(this.$state, continuation);
                        }

                        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                        }

                        public final Object invokeSuspend(Object obj) {
                            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                            int i = this.label;
                            if (i == 0) {
                                ResultKt.throwOnFailure(obj);
                                this.label = 1;
                                if (TooltipState.CC.show$default(this.$state, null, (Continuation) this, 1, null) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                            } else {
                                if (i != 1) {
                                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                                }
                                ResultKt.throwOnFailure(obj);
                            }
                            return Unit.INSTANCE;
                        }
                    }

                    public final Boolean m3250invoke() {
                        BuildersKt.launch$default(coroutineScope2, (CoroutineContext) null, (CoroutineStart) null, new C18091(tooltipState2, null), 3, (Object) null);
                        return true;
                    }
                });
            }
        }) : modifier;
    }
}
