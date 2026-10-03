package androidx.compose.material3;

import androidx.compose.foundation.MutatorMutex;
import androidx.compose.foundation.interaction.InteractionSourceKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.material3.internal.BasicTooltipKt;
import androidx.compose.material3.internal.BasicTooltip_androidKt;
import androidx.compose.material3.internal.TextFieldImplKt;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.layout.OnGloballyPositionedModifierKt;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.window.PopupPositionProvider;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000>\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a%\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H\u0003¢\u0006\u0002\u0010\b\u001a^\u0010\t\u001a\u00020\u00012\u001c\u0010\n\u001a\u0018\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00010\u000b¢\u0006\u0002\b\r¢\u0006\u0002\b\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\u0011\u001a\u00020\u00032\u0011\u0010\u0012\u001a\r\u0012\u0004\u0012\u00020\u00010\u0013¢\u0006\u0002\b\rH\u0007¢\u0006\u0002\u0010\u0014¨\u0006\u0015"}, d2 = {"HandleInteractions", "", "enabled", "", "state", "Landroidx/compose/material3/TooltipState;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "(ZLandroidx/compose/material3/TooltipState;Landroidx/compose/foundation/interaction/MutableInteractionSource;Landroidx/compose/runtime/Composer;I)V", TextFieldImplKt.LabelId, "label", "Lkotlin/Function1;", "Landroidx/compose/material3/TooltipScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "modifier", "Landroidx/compose/ui/Modifier;", "isPersistent", "content", "Lkotlin/Function0;", "(Lkotlin/jvm/functions/Function3;Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/interaction/MutableInteractionSource;ZLkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LabelKt {
    public static final void Label(final Function3<? super TooltipScope, ? super Composer, ? super Integer, Unit> function3, Modifier modifier, MutableInteractionSource mutableInteractionSource, boolean z, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        MutableInteractionSource mutableInteractionSource2;
        int i5;
        int i6;
        boolean z2;
        int i7;
        int i8;
        Modifier modifier3;
        MutableInteractionSource mutableInteractionSource3;
        boolean z3;
        MutableInteractionSource mutableInteractionSource4;
        LabelStateImpl labelStateImplRememberBasicTooltipState;
        final Ref.ObjectRef objectRef;
        Object objRememberedValue;
        Object objRememberedValue2;
        final MutableInteractionSource mutableInteractionSource5;
        final boolean z4;
        Object objRememberedValue3;
        Object objRememberedValue4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-544399326);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Label)P(3,4,1,2)74@3254L38,79@3493L33,80@3543L52,82@3646L103,88@3835L17,86@3755L249,95@4009L127:Label.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function3) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i9 = i2 & 2;
        if (i9 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    mutableInteractionSource2 = mutableInteractionSource;
                    if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                    if ((i2 & 16) != 0) {
                        i3 |= 24576;
                    } else if ((i & 24576) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i8 = Fields.Clip;
                        } else {
                            i8 = Fields.Shape;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                        if (i9 != 0) {
                            modifier3 = Modifier.INSTANCE;
                        } else {
                            modifier3 = modifier2;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        } else {
                            z3 = z2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                        }
                        composerStartRestartGroup.startReplaceGroup(519104973);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                        if (mutableInteractionSource3 == null) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                            objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                        } else {
                            mutableInteractionSource4 = mutableInteractionSource3;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                        if (z3) {
                            composerStartRestartGroup.startReplaceGroup(-1087377900);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                            labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                        } else {
                            composerStartRestartGroup.startReplaceGroup(519114025);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                            labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        TooltipState tooltipState = labelStateImplRememberBasicTooltipState;
                        objectRef = new Ref.ObjectRef();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        objectRef.element = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                                {
                                    super(0);
                                }

                                public final LayoutCoordinates m2462invoke() {
                                    return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                                }
                            });
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        final TooltipScopeImpl tooltipScopeImpl = (TooltipScopeImpl) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i10) {
                                ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                                if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                                }
                                function3.invoke(tooltipScopeImpl, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), tooltipState, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i10) {
                                ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                                if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                                }
                                Modifier.Companion companion = Modifier.INSTANCE;
                                final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                                Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((LayoutCoordinates) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(LayoutCoordinates layoutCoordinates) {
                                        ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                                    }
                                });
                                Function2<Composer, Integer, Unit> function4 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                composer2.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                        HandleInteractions(!z3, tooltipState, mutableInteractionSource4, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = modifier3;
                        mutableInteractionSource5 = mutableInteractionSource3;
                        z4 = z3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        mutableInteractionSource5 = mutableInteractionSource2;
                        z4 = z2;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier4 = modifier2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i10) {
                                LabelKt.Label(function3, modifier4, mutableInteractionSource5, z4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                z2 = z;
                if ((i2 & 16) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                    }
                    composerStartRestartGroup.startReplaceGroup(519104973);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                    if (mutableInteractionSource3 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                    } else {
                        mutableInteractionSource4 = mutableInteractionSource3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc2 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                    if (z3) {
                        composerStartRestartGroup.startReplaceGroup(-1087377900);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                        labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                    } else {
                        composerStartRestartGroup.startReplaceGroup(519114025);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                        labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    TooltipState tooltipState2 = labelStateImplRememberBasicTooltipState;
                    objectRef = new Ref.ObjectRef();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    objectRef.element = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                            {
                                super(0);
                            }

                            public final LayoutCoordinates m2462invoke() {
                                return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                            }
                        });
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final TooltipScopeImpl tooltipScopeImpl2 = (TooltipScopeImpl) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc2, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                            }
                            function3.invoke(tooltipScopeImpl2, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), tooltipState2, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                            }
                            Modifier.Companion companion = Modifier.INSTANCE;
                            final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                            Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((LayoutCoordinates) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutCoordinates layoutCoordinates) {
                                    ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                                }
                            });
                            Function2<Composer, Integer, Unit> function4 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                    HandleInteractions(!z3, tooltipState2, mutableInteractionSource4, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    mutableInteractionSource5 = mutableInteractionSource3;
                    z4 = z3;
                } else {
                    if (i9 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                    }
                    composerStartRestartGroup.startReplaceGroup(519104973);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                    if (mutableInteractionSource3 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                    } else {
                        mutableInteractionSource4 = mutableInteractionSource3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc3 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                    if (z3) {
                        composerStartRestartGroup.startReplaceGroup(-1087377900);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                        labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                    } else {
                        composerStartRestartGroup.startReplaceGroup(519114025);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                        labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    TooltipState tooltipState3 = labelStateImplRememberBasicTooltipState;
                    objectRef = new Ref.ObjectRef();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    objectRef.element = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                            {
                                super(0);
                            }

                            public final LayoutCoordinates m2462invoke() {
                                return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                            }
                        });
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final TooltipScopeImpl tooltipScopeImpl3 = (TooltipScopeImpl) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc3, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                            }
                            function3.invoke(tooltipScopeImpl3, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), tooltipState3, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                            }
                            Modifier.Companion companion = Modifier.INSTANCE;
                            final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                            Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((LayoutCoordinates) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutCoordinates layoutCoordinates) {
                                    ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                                }
                            });
                            Function2<Composer, Integer, Unit> function4 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                    HandleInteractions(!z3, tooltipState3, mutableInteractionSource4, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    mutableInteractionSource5 = mutableInteractionSource3;
                    z4 = z3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            LabelKt.Label(function3, modifier5, mutableInteractionSource5, z4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            mutableInteractionSource2 = mutableInteractionSource;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                    }
                    composerStartRestartGroup.startReplaceGroup(519104973);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                    if (mutableInteractionSource3 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                    } else {
                        mutableInteractionSource4 = mutableInteractionSource3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc4 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                    if (z3) {
                        composerStartRestartGroup.startReplaceGroup(-1087377900);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                        labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                    } else {
                        composerStartRestartGroup.startReplaceGroup(519114025);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                        labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    TooltipState tooltipState4 = labelStateImplRememberBasicTooltipState;
                    objectRef = new Ref.ObjectRef();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    objectRef.element = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                            {
                                super(0);
                            }

                            public final LayoutCoordinates m2462invoke() {
                                return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                            }
                        });
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final TooltipScopeImpl tooltipScopeImpl4 = (TooltipScopeImpl) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc4, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                            }
                            function3.invoke(tooltipScopeImpl4, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), tooltipState4, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                            }
                            Modifier.Companion companion = Modifier.INSTANCE;
                            final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                            Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((LayoutCoordinates) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutCoordinates layoutCoordinates) {
                                    ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                                }
                            });
                            Function2<Composer, Integer, Unit> function4 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                    HandleInteractions(!z3, tooltipState4, mutableInteractionSource4, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    mutableInteractionSource5 = mutableInteractionSource3;
                    z4 = z3;
                } else {
                    if (i9 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                    }
                    composerStartRestartGroup.startReplaceGroup(519104973);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                    if (mutableInteractionSource3 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                    } else {
                        mutableInteractionSource4 = mutableInteractionSource3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc5 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                    if (z3) {
                        composerStartRestartGroup.startReplaceGroup(-1087377900);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                        labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                    } else {
                        composerStartRestartGroup.startReplaceGroup(519114025);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                        labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    TooltipState tooltipState5 = labelStateImplRememberBasicTooltipState;
                    objectRef = new Ref.ObjectRef();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    objectRef.element = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                            {
                                super(0);
                            }

                            public final LayoutCoordinates m2462invoke() {
                                return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                            }
                        });
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final TooltipScopeImpl tooltipScopeImpl5 = (TooltipScopeImpl) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc5, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                            }
                            function3.invoke(tooltipScopeImpl5, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), tooltipState5, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                            }
                            Modifier.Companion companion = Modifier.INSTANCE;
                            final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                            Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((LayoutCoordinates) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutCoordinates layoutCoordinates) {
                                    ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                                }
                            });
                            Function2<Composer, Integer, Unit> function4 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                    HandleInteractions(!z3, tooltipState5, mutableInteractionSource4, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    mutableInteractionSource5 = mutableInteractionSource3;
                    z4 = z3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier6 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            LabelKt.Label(function3, modifier6, mutableInteractionSource5, z4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            z2 = z;
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i3 |= i8;
            }
            if ((i3 & 9363) == 9362) {
                if (i9 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                if (i6 != 0) {
                    z3 = false;
                } else {
                    z3 = z2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                }
                composerStartRestartGroup.startReplaceGroup(519104973);
                ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc6 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                if (z3) {
                    composerStartRestartGroup.startReplaceGroup(-1087377900);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                    labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                } else {
                    composerStartRestartGroup.startReplaceGroup(519114025);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                    labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                    composerStartRestartGroup.endReplaceGroup();
                }
                TooltipState tooltipState6 = labelStateImplRememberBasicTooltipState;
                objectRef = new Ref.ObjectRef();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                objectRef.element = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                        {
                            super(0);
                        }

                        public final LayoutCoordinates m2462invoke() {
                            return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final TooltipScopeImpl tooltipScopeImpl6 = (TooltipScopeImpl) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc6, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                        }
                        function3.invoke(tooltipScopeImpl6, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), tooltipState6, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                        }
                        Modifier.Companion companion = Modifier.INSTANCE;
                        final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                        Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((LayoutCoordinates) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutCoordinates layoutCoordinates) {
                                ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                            }
                        });
                        Function2<Composer, Integer, Unit> function4 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                        function4.invoke(composer2, 0);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                HandleInteractions(!z3, tooltipState6, mutableInteractionSource4, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                mutableInteractionSource5 = mutableInteractionSource3;
                z4 = z3;
            } else {
                if (i9 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                if (i6 != 0) {
                    z3 = false;
                } else {
                    z3 = z2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                }
                composerStartRestartGroup.startReplaceGroup(519104973);
                ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc7 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                if (z3) {
                    composerStartRestartGroup.startReplaceGroup(-1087377900);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                    labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                } else {
                    composerStartRestartGroup.startReplaceGroup(519114025);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                    labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                    composerStartRestartGroup.endReplaceGroup();
                }
                TooltipState tooltipState7 = labelStateImplRememberBasicTooltipState;
                objectRef = new Ref.ObjectRef();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                objectRef.element = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                        {
                            super(0);
                        }

                        public final LayoutCoordinates m2462invoke() {
                            return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final TooltipScopeImpl tooltipScopeImpl7 = (TooltipScopeImpl) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc7, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                        }
                        function3.invoke(tooltipScopeImpl7, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), tooltipState7, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                        }
                        Modifier.Companion companion = Modifier.INSTANCE;
                        final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                        Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((LayoutCoordinates) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutCoordinates layoutCoordinates) {
                                ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                            }
                        });
                        Function2<Composer, Integer, Unit> function4 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                        function4.invoke(composer2, 0);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                HandleInteractions(!z3, tooltipState7, mutableInteractionSource4, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                mutableInteractionSource5 = mutableInteractionSource3;
                z4 = z3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier7 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        LabelKt.Label(function3, modifier7, mutableInteractionSource5, z4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                mutableInteractionSource2 = mutableInteractionSource;
                if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i3 |= i8;
                }
                if ((i3 & 9363) == 9362) {
                    if (i9 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                    }
                    composerStartRestartGroup.startReplaceGroup(519104973);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                    if (mutableInteractionSource3 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                    } else {
                        mutableInteractionSource4 = mutableInteractionSource3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc8 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                    if (z3) {
                        composerStartRestartGroup.startReplaceGroup(-1087377900);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                        labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                    } else {
                        composerStartRestartGroup.startReplaceGroup(519114025);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                        labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    TooltipState tooltipState8 = labelStateImplRememberBasicTooltipState;
                    objectRef = new Ref.ObjectRef();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    objectRef.element = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                            {
                                super(0);
                            }

                            public final LayoutCoordinates m2462invoke() {
                                return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                            }
                        });
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final TooltipScopeImpl tooltipScopeImpl8 = (TooltipScopeImpl) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc8, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                            }
                            function3.invoke(tooltipScopeImpl8, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), tooltipState8, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                            }
                            Modifier.Companion companion = Modifier.INSTANCE;
                            final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                            Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((LayoutCoordinates) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutCoordinates layoutCoordinates) {
                                    ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                                }
                            });
                            Function2<Composer, Integer, Unit> function4 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                    HandleInteractions(!z3, tooltipState8, mutableInteractionSource4, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    mutableInteractionSource5 = mutableInteractionSource3;
                    z4 = z3;
                } else {
                    if (i9 != 0) {
                        modifier3 = Modifier.INSTANCE;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                    }
                    composerStartRestartGroup.startReplaceGroup(519104973);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                    if (mutableInteractionSource3 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                    } else {
                        mutableInteractionSource4 = mutableInteractionSource3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc9 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                    if (z3) {
                        composerStartRestartGroup.startReplaceGroup(-1087377900);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                        labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                    } else {
                        composerStartRestartGroup.startReplaceGroup(519114025);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                        labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    TooltipState tooltipState9 = labelStateImplRememberBasicTooltipState;
                    objectRef = new Ref.ObjectRef();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    objectRef.element = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                            {
                                super(0);
                            }

                            public final LayoutCoordinates m2462invoke() {
                                return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                            }
                        });
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final TooltipScopeImpl tooltipScopeImpl9 = (TooltipScopeImpl) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc9, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                            }
                            function3.invoke(tooltipScopeImpl9, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), tooltipState9, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                            if ((i10 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                            }
                            Modifier.Companion companion = Modifier.INSTANCE;
                            final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                            Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((LayoutCoordinates) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutCoordinates layoutCoordinates) {
                                    ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                                }
                            });
                            Function2<Composer, Integer, Unit> function4 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                    HandleInteractions(!z3, tooltipState9, mutableInteractionSource4, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    mutableInteractionSource5 = mutableInteractionSource3;
                    z4 = z3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier8 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i10) {
                            LabelKt.Label(function3, modifier8, mutableInteractionSource5, z4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            z2 = z;
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i3 |= i8;
            }
            if ((i3 & 9363) == 9362) {
                if (i9 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                if (i6 != 0) {
                    z3 = false;
                } else {
                    z3 = z2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                }
                composerStartRestartGroup.startReplaceGroup(519104973);
                ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc10 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                if (z3) {
                    composerStartRestartGroup.startReplaceGroup(-1087377900);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                    labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                } else {
                    composerStartRestartGroup.startReplaceGroup(519114025);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                    labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                    composerStartRestartGroup.endReplaceGroup();
                }
                TooltipState tooltipState10 = labelStateImplRememberBasicTooltipState;
                objectRef = new Ref.ObjectRef();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                objectRef.element = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                        {
                            super(0);
                        }

                        public final LayoutCoordinates m2462invoke() {
                            return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final TooltipScopeImpl tooltipScopeImpl10 = (TooltipScopeImpl) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc10, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                        }
                        function3.invoke(tooltipScopeImpl10, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), tooltipState10, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                        }
                        Modifier.Companion companion = Modifier.INSTANCE;
                        final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                        Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((LayoutCoordinates) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutCoordinates layoutCoordinates) {
                                ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                            }
                        });
                        Function2<Composer, Integer, Unit> function4 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                        function4.invoke(composer2, 0);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                HandleInteractions(!z3, tooltipState10, mutableInteractionSource4, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                mutableInteractionSource5 = mutableInteractionSource3;
                z4 = z3;
            } else {
                if (i9 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                if (i6 != 0) {
                    z3 = false;
                } else {
                    z3 = z2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                }
                composerStartRestartGroup.startReplaceGroup(519104973);
                ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc11 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                if (z3) {
                    composerStartRestartGroup.startReplaceGroup(-1087377900);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                    labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                } else {
                    composerStartRestartGroup.startReplaceGroup(519114025);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                    labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                    composerStartRestartGroup.endReplaceGroup();
                }
                TooltipState tooltipState11 = labelStateImplRememberBasicTooltipState;
                objectRef = new Ref.ObjectRef();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                objectRef.element = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                        {
                            super(0);
                        }

                        public final LayoutCoordinates m2462invoke() {
                            return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final TooltipScopeImpl tooltipScopeImpl11 = (TooltipScopeImpl) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc11, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                        }
                        function3.invoke(tooltipScopeImpl11, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), tooltipState11, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                        }
                        Modifier.Companion companion = Modifier.INSTANCE;
                        final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                        Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((LayoutCoordinates) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutCoordinates layoutCoordinates) {
                                ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                            }
                        });
                        Function2<Composer, Integer, Unit> function4 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                        function4.invoke(composer2, 0);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                HandleInteractions(!z3, tooltipState11, mutableInteractionSource4, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                mutableInteractionSource5 = mutableInteractionSource3;
                z4 = z3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier9 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        LabelKt.Label(function3, modifier9, mutableInteractionSource5, z4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        mutableInteractionSource2 = mutableInteractionSource;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i3 |= i8;
            }
            if ((i3 & 9363) == 9362) {
                if (i9 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                if (i6 != 0) {
                    z3 = false;
                } else {
                    z3 = z2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                }
                composerStartRestartGroup.startReplaceGroup(519104973);
                ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc12 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                if (z3) {
                    composerStartRestartGroup.startReplaceGroup(-1087377900);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                    labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                } else {
                    composerStartRestartGroup.startReplaceGroup(519114025);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                    labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                    composerStartRestartGroup.endReplaceGroup();
                }
                TooltipState tooltipState12 = labelStateImplRememberBasicTooltipState;
                objectRef = new Ref.ObjectRef();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                objectRef.element = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                        {
                            super(0);
                        }

                        public final LayoutCoordinates m2462invoke() {
                            return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final TooltipScopeImpl tooltipScopeImpl12 = (TooltipScopeImpl) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc12, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                        }
                        function3.invoke(tooltipScopeImpl12, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), tooltipState12, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                        }
                        Modifier.Companion companion = Modifier.INSTANCE;
                        final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                        Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((LayoutCoordinates) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutCoordinates layoutCoordinates) {
                                ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                            }
                        });
                        Function2<Composer, Integer, Unit> function4 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                        function4.invoke(composer2, 0);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                HandleInteractions(!z3, tooltipState12, mutableInteractionSource4, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                mutableInteractionSource5 = mutableInteractionSource3;
                z4 = z3;
            } else {
                if (i9 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                if (i6 != 0) {
                    z3 = false;
                } else {
                    z3 = z2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
                }
                composerStartRestartGroup.startReplaceGroup(519104973);
                ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc13 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
                if (z3) {
                    composerStartRestartGroup.startReplaceGroup(-1087377900);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                    labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
                } else {
                    composerStartRestartGroup.startReplaceGroup(519114025);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                    labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                    composerStartRestartGroup.endReplaceGroup();
                }
                TooltipState tooltipState13 = labelStateImplRememberBasicTooltipState;
                objectRef = new Ref.ObjectRef();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                objectRef.element = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                        {
                            super(0);
                        }

                        public final LayoutCoordinates m2462invoke() {
                            return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                        }
                    });
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final TooltipScopeImpl tooltipScopeImpl13 = (TooltipScopeImpl) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc13, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                        }
                        function3.invoke(tooltipScopeImpl13, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), tooltipState13, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                        if ((i10 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                        }
                        Modifier.Companion companion = Modifier.INSTANCE;
                        final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                        Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((LayoutCoordinates) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutCoordinates layoutCoordinates) {
                                ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                            }
                        });
                        Function2<Composer, Integer, Unit> function4 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                        function4.invoke(composer2, 0);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        composer2.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
                HandleInteractions(!z3, tooltipState13, mutableInteractionSource4, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                mutableInteractionSource5 = mutableInteractionSource3;
                z4 = z3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier10 = modifier2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i10) {
                        LabelKt.Label(function3, modifier10, mutableInteractionSource5, z4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        z2 = z;
        if ((i2 & 16) != 0) {
            i3 |= 24576;
        } else if ((i & 24576) == 0) {
            if (composerStartRestartGroup.changedInstance(function2)) {
                i8 = Fields.Clip;
            } else {
                i8 = Fields.Shape;
            }
            i3 |= i8;
        }
        if ((i3 & 9363) == 9362) {
            if (i9 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            if (i4 != 0) {
                mutableInteractionSource3 = null;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            if (i6 != 0) {
                z3 = false;
            } else {
                z3 = z2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
            }
            composerStartRestartGroup.startReplaceGroup(519104973);
            ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
            if (mutableInteractionSource3 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
            } else {
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            composerStartRestartGroup.endReplaceGroup();
            PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc14 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
            if (z3) {
                composerStartRestartGroup.startReplaceGroup(-1087377900);
                ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endReplaceGroup();
                labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
            } else {
                composerStartRestartGroup.startReplaceGroup(519114025);
                ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                composerStartRestartGroup.endReplaceGroup();
            }
            TooltipState tooltipState14 = labelStateImplRememberBasicTooltipState;
            objectRef = new Ref.ObjectRef();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            objectRef.element = (MutableState) objRememberedValue;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                    {
                        super(0);
                    }

                    public final LayoutCoordinates m2462invoke() {
                        return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                    }
                });
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            final TooltipScopeImpl tooltipScopeImpl14 = (TooltipScopeImpl) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc14, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i10) {
                    ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                    if ((i10 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                    }
                    function3.invoke(tooltipScopeImpl14, composer2, 6);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), tooltipState14, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i10) {
                    ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                    if ((i10 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                    }
                    Modifier.Companion companion = Modifier.INSTANCE;
                    final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                    Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((LayoutCoordinates) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutCoordinates layoutCoordinates) {
                            ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                        }
                    });
                    Function2<Composer, Integer, Unit> function4 = function2;
                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                    ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                    function4.invoke(composer2, 0);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    composer2.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
            HandleInteractions(!z3, tooltipState14, mutableInteractionSource4, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier3;
            mutableInteractionSource5 = mutableInteractionSource3;
            z4 = z3;
        } else {
            if (i9 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            if (i4 != 0) {
                mutableInteractionSource3 = null;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            if (i6 != 0) {
                z3 = false;
            } else {
                z3 = z2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-544399326, i3, -1, "androidx.compose.material3.Label (Label.kt:70)");
            }
            composerStartRestartGroup.startReplaceGroup(519104973);
            ComposerKt.sourceInformation(composerStartRestartGroup, "72@3116L39");
            if (mutableInteractionSource3 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519105624, "CC(remember):Label.kt#9igjgp");
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue4 = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue4;
            } else {
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            composerStartRestartGroup.endReplaceGroup();
            PopupPositionProvider popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc15 = TooltipDefaults.INSTANCE.m3177rememberPlainTooltipPositionProviderkHDZbjc(0.0f, composerStartRestartGroup, 48, 1);
            if (z3) {
                composerStartRestartGroup.startReplaceGroup(-1087377900);
                ComposerKt.sourceInformation(composerStartRestartGroup, "76@3335L29");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519112622, "CC(remember):Label.kt#9igjgp");
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue3 = new LabelStateImpl(false, false, 3, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endReplaceGroup();
                labelStateImplRememberBasicTooltipState = (LabelStateImpl) objRememberedValue3;
            } else {
                composerStartRestartGroup.startReplaceGroup(519114025);
                ComposerKt.sourceInformation(composerStartRestartGroup, "77@3378L56");
                labelStateImplRememberBasicTooltipState = BasicTooltipKt.rememberBasicTooltipState(false, false, new MutatorMutex(), composerStartRestartGroup, 0, 3);
                composerStartRestartGroup.endReplaceGroup();
            }
            TooltipState tooltipState15 = labelStateImplRememberBasicTooltipState;
            objectRef = new Ref.ObjectRef();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519117682, "CC(remember):Label.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            objectRef.element = (MutableState) objRememberedValue;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519119301, "CC(remember):Label.kt#9igjgp");
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = new TooltipScopeImpl(new Function0<LayoutCoordinates>() {
                    {
                        super(0);
                    }

                    public final LayoutCoordinates m2462invoke() {
                        return (LayoutCoordinates) ((MutableState) objectRef.element).getValue();
                    }
                });
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            final TooltipScopeImpl tooltipScopeImpl15 = (TooltipScopeImpl) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            BasicTooltip_androidKt.BasicTooltipBox(popupPositionProviderM3177rememberPlainTooltipPositionProviderkHDZbjc15, ComposableLambdaKt.rememberComposableLambda(784196780, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i10) {
                    ComposerKt.sourceInformation(composer2, "C88@3843L7:Label.kt#uh7d8r");
                    if ((i10 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(784196780, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:88)");
                    }
                    function3.invoke(tooltipScopeImpl15, composer2, 6);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), tooltipState15, modifier3, false, false, ComposableLambdaKt.rememberComposableLambda(1950723216, r12, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i10) {
                    ComposerKt.sourceInformation(composer2, "C83@3656L87:Label.kt#uh7d8r");
                    if ((i10 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1950723216, i10, -1, "androidx.compose.material3.Label.<anonymous> (Label.kt:83)");
                    }
                    Modifier.Companion companion = Modifier.INSTANCE;
                    final Ref.ObjectRef<MutableState<LayoutCoordinates>> objectRef2 = objectRef;
                    Modifier modifierOnGloballyPositioned = OnGloballyPositionedModifierKt.onGloballyPositioned(companion, new Function1<LayoutCoordinates, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((LayoutCoordinates) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutCoordinates layoutCoordinates) {
                            ((MutableState) objectRef2.element).setValue(layoutCoordinates);
                        }
                    });
                    Function2<Composer, Integer, Unit> function4 = function2;
                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierOnGloballyPositioned);
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
                    ComposerKt.sourceInformationMarkerStart(composer2, -90340533, "C83@3732L9:Label.kt#uh7d8r");
                    function4.invoke(composer2, 0);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    composer2.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i3 << 6) & 7168) | 1794096, 0);
            HandleInteractions(!z3, tooltipState15, mutableInteractionSource4, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier3;
            mutableInteractionSource5 = mutableInteractionSource3;
            z4 = z3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier11 = modifier2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i10) {
                    LabelKt.Label(function3, modifier11, mutableInteractionSource5, z4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void HandleInteractions(final boolean z, final TooltipState tooltipState, final MutableInteractionSource mutableInteractionSource, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(-627258109);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(HandleInteractions)P(!1,2)110@4384L587,110@4350L621:Label.kt#uh7d8r");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changed(z) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= (i & 64) == 0 ? composerStartRestartGroup.changed(tooltipState) : composerStartRestartGroup.changedInstance(tooltipState) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changed(mutableInteractionSource) ? 256 : Fields.SpotShadowColor;
        }
        if ((i2 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-627258109, i2, -1, "androidx.compose.material3.HandleInteractions (Label.kt:108)");
            }
            if (z) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 354570583, "CC(remember):Label.kt#9igjgp");
                boolean z2 = true;
                boolean z3 = (i2 & 896) == 256;
                if ((i2 & 112) != 32 && ((i2 & 64) == 0 || !composerStartRestartGroup.changedInstance(tooltipState))) {
                    z2 = false;
                }
                boolean z4 = z3 | z2;
                LabelKt$HandleInteractions$1$1 labelKt$HandleInteractions$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (z4 || labelKt$HandleInteractions$1$1RememberedValue == Composer.INSTANCE.getEmpty()) {
                    labelKt$HandleInteractions$1$1RememberedValue = new LabelKt$HandleInteractions$1$1(mutableInteractionSource, tooltipState, null);
                    composerStartRestartGroup.updateRememberedValue(labelKt$HandleInteractions$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) labelKt$HandleInteractions$1$1RememberedValue, composerStartRestartGroup, (i2 >> 6) & 14);
            }
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
                    LabelKt.HandleInteractions(z, tooltipState, mutableInteractionSource, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }
}
