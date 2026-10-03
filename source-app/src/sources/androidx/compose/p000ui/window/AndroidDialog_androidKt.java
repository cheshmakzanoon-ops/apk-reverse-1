package androidx.compose.p000ui.window;

import android.view.View;
import androidx.compose.p000ui.unit.Constraints;
import androidx.compose.p000ui.unit.Density;
import androidx.compose.p000ui.unit.LayoutDirection;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionContext;
import androidx.compose.runtime.CompositionLocal;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.DisposableEffectResult;
import androidx.compose.runtime.DisposableEffectScope;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.runtime.saveable.RememberSaveableKt;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.ui.ComposedModifierKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.layout.IntrinsicMeasureScope;
import androidx.compose.ui.layout.Measurable;
import androidx.compose.ui.layout.MeasurePolicy;
import androidx.compose.ui.layout.MeasureResult;
import androidx.compose.ui.layout.MeasureScope;
import androidx.compose.ui.layout.Placeable;
import androidx.compose.ui.node.ComposeUiNode;
import androidx.compose.ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.ui.platform.CompositionLocalsKt;
import androidx.compose.ui.semantics.SemanticsModifierKt;
import androidx.compose.ui.semantics.SemanticsPropertiesKt;
import androidx.compose.ui.semantics.SemanticsPropertyReceiver;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000$\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a8\u0010\u0000\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00010\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u0011\u0010\u0006\u001a\r\u0012\u0004\u0012\u00020\u00010\u0003¢\u0006\u0002\b\u0007H\u0007¢\u0006\u0002\u0010\b\u001a*\u0010\t\u001a\u00020\u00012\b\b\u0002\u0010\n\u001a\u00020\u000b2\u0011\u0010\u0006\u001a\r\u0012\u0004\u0012\u00020\u00010\u0003¢\u0006\u0002\b\u0007H\u0003¢\u0006\u0002\u0010\f¨\u0006\r²\u0006\u0015\u0010\u000e\u001a\r\u0012\u0004\u0012\u00020\u00010\u0003¢\u0006\u0002\b\u0007X\u008a\u0084\u0002"}, d2 = {"Dialog", "", "onDismissRequest", "Lkotlin/Function0;", "properties", "Landroidx/compose/ui/window/DialogProperties;", "content", "Landroidx/compose/runtime/Composable;", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/window/DialogProperties;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "DialogLayout", "modifier", "Landroidx/compose/ui/Modifier;", "(Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "ui_release", "currentContent"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidDialog_androidKt {
    public static final void Dialog(final Function0<Unit> function0, DialogProperties dialogProperties, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        int i3;
        DialogProperties dialogProperties2;
        int i4;
        View view;
        Density density;
        LayoutDirection layoutDirection;
        CompositionContext compositionContextRememberCompositionContext;
        final State stateRememberUpdatedState;
        UUID uuid;
        boolean zChanged;
        LayoutDirection layoutDirection2;
        Composer composer2;
        Object obj;
        final DialogWrapper dialogWrapper;
        boolean zChangedInstance;
        Object objRememberedValue;
        boolean z;
        final LayoutDirection layoutDirection3;
        boolean zChanged2;
        final DialogProperties dialogProperties3;
        Object obj2;
        final DialogProperties dialogProperties4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-2032877254);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Dialog)P(1,2)167@7096L7,168@7135L7,169@7190L7,170@7220L28,171@7275L29,172@7324L38,173@7380L616,194@8027L129,194@8002L154,203@8173L182,203@8162L193:AndroidDialog.android.kt#2oxthz");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i5 = i2 & 2;
        if (i5 == 0) {
            if ((i & 48) == 0) {
                dialogProperties2 = dialogProperties;
                i3 |= composerStartRestartGroup.changed(dialogProperties2) ? 32 : 16;
            }
            if ((i2 & 4) != 0) {
                i3 |= 384;
            } else if ((i & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i4 = 256;
                } else {
                    i4 = 128;
                }
                i3 |= i4;
            }
            if ((i3 & 147) == 146 || !composerStartRestartGroup.getSkipping()) {
                if (i5 != 0) {
                    dialogProperties2 = new DialogProperties(false, false, false, 7, (DefaultConstructorMarker) null);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-2032877254, i3, -1, "androidx.compose.ui.window.Dialog (AndroidDialog.android.kt:166)");
                }
                CompositionLocal localView = AndroidCompositionLocals_androidKt.getLocalView();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume = composerStartRestartGroup.consume(localView);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                view = (View) objConsume;
                CompositionLocal localDensity = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume2 = composerStartRestartGroup.consume(localDensity);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume2;
                CompositionLocal localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume3 = composerStartRestartGroup.consume(localLayoutDirection);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                layoutDirection = (LayoutDirection) objConsume3;
                compositionContextRememberCompositionContext = ComposablesKt.rememberCompositionContext(composerStartRestartGroup, 0);
                stateRememberUpdatedState = SnapshotStateKt.rememberUpdatedState(function2, composerStartRestartGroup, (i3 >> 6) & 14);
                uuid = (UUID) RememberSaveableKt.rememberSaveable(new Object[0], (Saver) null, (String) null, new Function0<UUID>() {
                    public final UUID invoke() {
                        return UUID.randomUUID();
                    }
                }, composerStartRestartGroup, 3072, 6);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -464840651, "CC(remember):AndroidDialog.android.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(view) | composerStartRestartGroup.changed(density);
                Object objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged || objRememberedValue2 == Composer.Companion.getEmpty()) {
                    layoutDirection2 = layoutDirection;
                    composer2 = composerStartRestartGroup;
                    DialogWrapper dialogWrapper2 = new DialogWrapper(function0, dialogProperties2, view, layoutDirection2, density, uuid);
                    dialogWrapper2.setContent(compositionContextRememberCompositionContext, (Function2) ComposableLambdaKt.composableLambdaInstance(488261145, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj3, Object obj4) {
                            invoke((Composer) obj3, ((Number) obj4).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i6) {
                            ComposerKt.sourceInformation(composer3, "C187@7910L56,185@7825L141:AndroidDialog.android.kt#2oxthz");
                            if ((i6 & 3) != 2 || !composer3.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(488261145, i6, -1, "androidx.compose.ui.window.Dialog.<anonymous>.<anonymous>.<anonymous> (AndroidDialog.android.kt:185)");
                                }
                                Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(Modifier.Companion, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public Object invoke(Object obj3) {
                                        invoke((SemanticsPropertyReceiver) obj3);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                        SemanticsPropertiesKt.dialog(semanticsPropertyReceiver);
                                    }
                                }, 1, (Object) null);
                                final State<Function2<Composer, Integer, Unit>> state = stateRememberUpdatedState;
                                AndroidDialog_androidKt.DialogLayout(modifierSemantics$default, ComposableLambdaKt.rememberComposableLambda(-533674951, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj3, Object obj4) {
                                        invoke((Composer) obj3, ((Number) obj4).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer4, int i7) {
                                        ComposerKt.sourceInformation(composer4, "C188@7932L16:AndroidDialog.android.kt#2oxthz");
                                        if ((i7 & 3) == 2 && composer4.getSkipping()) {
                                            composer4.skipToGroupEnd();
                                            return;
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-533674951, i7, -1, "androidx.compose.ui.window.Dialog.<anonymous>.<anonymous>.<anonymous>.<anonymous> (AndroidDialog.android.kt:188)");
                                        }
                                        AndroidDialog_androidKt.Dialog$lambda$0(state).invoke(composer4, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer3, 54), composer3, 48, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer3.skipToGroupEnd();
                        }
                    }));
                    composer2.updateRememberedValue(dialogWrapper2);
                    obj = dialogWrapper2;
                } else {
                    layoutDirection2 = layoutDirection;
                    composer2 = composerStartRestartGroup;
                    obj = objRememberedValue2;
                }
                dialogWrapper = (DialogWrapper) obj;
                ComposerKt.sourceInformationMarkerEnd(composer2);
                ComposerKt.sourceInformationMarkerStart(composer2, -464820434, "CC(remember):AndroidDialog.android.kt#9igjgp");
                zChangedInstance = composer2.changedInstance(dialogWrapper);
                objRememberedValue = composer2.rememberedValue();
                if (!zChangedInstance || objRememberedValue == Composer.Companion.getEmpty()) {
                    objRememberedValue = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                        {
                            super(1);
                        }

                        public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                            dialogWrapper.show();
                            final DialogWrapper dialogWrapper3 = dialogWrapper;
                            return new DisposableEffectResult() {
                                public void dispose() {
                                    dialogWrapper3.dismiss();
                                    dialogWrapper3.disposeComposition();
                                }
                            };
                        }
                    };
                    composer2.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composer2);
                EffectsKt.DisposableEffect(dialogWrapper, (Function1) objRememberedValue, composer2, 0);
                ComposerKt.sourceInformationMarkerStart(composer2, -464815709, "CC(remember):AndroidDialog.android.kt#9igjgp");
                boolean zChangedInstance2 = composer2.changedInstance(dialogWrapper);
                if ((i3 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                boolean z2 = zChangedInstance2 | z;
                layoutDirection3 = layoutDirection2;
                zChanged2 = z2 | ((i3 & 112) == 32) | composer2.changed(layoutDirection3);
                Object objRememberedValue3 = composer2.rememberedValue();
                if (!zChanged2 || objRememberedValue3 == Composer.Companion.getEmpty()) {
                    dialogProperties3 = dialogProperties2;
                    obj2 = (Function0) new Function0<Unit>() {
                        {
                            super(0);
                        }

                        public Object invoke() throws NoWhenBranchMatchedException {
                            m2111invoke();
                            return Unit.INSTANCE;
                        }

                        public final void m2111invoke() throws NoWhenBranchMatchedException {
                            dialogWrapper.updateParameters(function0, dialogProperties3, layoutDirection3);
                        }
                    };
                    composer2.updateRememberedValue(obj2);
                } else {
                    obj2 = objRememberedValue3;
                    dialogProperties3 = dialogProperties2;
                }
                ComposerKt.sourceInformationMarkerEnd(composer2);
                EffectsKt.SideEffect((Function0) obj2, composer2, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                dialogProperties4 = dialogProperties3;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                dialogProperties4 = dialogProperties2;
                composer2 = composerStartRestartGroup;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj3, Object obj4) {
                        invoke((Composer) obj3, ((Number) obj4).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i6) {
                        AndroidDialog_androidKt.Dialog(function0, dialogProperties4, function2, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        dialogProperties2 = dialogProperties;
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            if (composerStartRestartGroup.changedInstance(function2)) {
                i4 = 256;
            } else {
                i4 = 128;
            }
            i3 |= i4;
        }
        if ((i3 & 147) == 146) {
            if (i5 != 0) {
                dialogProperties2 = new DialogProperties(false, false, false, 7, (DefaultConstructorMarker) null);
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2032877254, i3, -1, "androidx.compose.ui.window.Dialog (AndroidDialog.android.kt:166)");
            }
            CompositionLocal localView2 = AndroidCompositionLocals_androidKt.getLocalView();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume4 = composerStartRestartGroup.consume(localView2);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            view = (View) objConsume4;
            CompositionLocal localDensity2 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume5 = composerStartRestartGroup.consume(localDensity2);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            density = (Density) objConsume5;
            CompositionLocal localLayoutDirection2 = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume6 = composerStartRestartGroup.consume(localLayoutDirection2);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            layoutDirection = (LayoutDirection) objConsume6;
            compositionContextRememberCompositionContext = ComposablesKt.rememberCompositionContext(composerStartRestartGroup, 0);
            stateRememberUpdatedState = SnapshotStateKt.rememberUpdatedState(function2, composerStartRestartGroup, (i3 >> 6) & 14);
            uuid = (UUID) RememberSaveableKt.rememberSaveable(new Object[0], (Saver) null, (String) null, new Function0<UUID>() {
                public final UUID invoke() {
                    return UUID.randomUUID();
                }
            }, composerStartRestartGroup, 3072, 6);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -464840651, "CC(remember):AndroidDialog.android.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(view) | composerStartRestartGroup.changed(density);
            Object objRememberedValue4 = composerStartRestartGroup.rememberedValue();
            if (zChanged) {
                layoutDirection2 = layoutDirection;
                composer2 = composerStartRestartGroup;
                DialogWrapper dialogWrapper3 = new DialogWrapper(function0, dialogProperties2, view, layoutDirection2, density, uuid);
                dialogWrapper3.setContent(compositionContextRememberCompositionContext, (Function2) ComposableLambdaKt.composableLambdaInstance(488261145, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj3, Object obj4) {
                        invoke((Composer) obj3, ((Number) obj4).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i6) {
                        ComposerKt.sourceInformation(composer3, "C187@7910L56,185@7825L141:AndroidDialog.android.kt#2oxthz");
                        if ((i6 & 3) != 2 || !composer3.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(488261145, i6, -1, "androidx.compose.ui.window.Dialog.<anonymous>.<anonymous>.<anonymous> (AndroidDialog.android.kt:185)");
                            }
                            Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(Modifier.Companion, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public Object invoke(Object obj3) {
                                    invoke((SemanticsPropertyReceiver) obj3);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    SemanticsPropertiesKt.dialog(semanticsPropertyReceiver);
                                }
                            }, 1, (Object) null);
                            final State<? extends Function2<? super Composer, ? super Integer, Unit>> state = stateRememberUpdatedState;
                            AndroidDialog_androidKt.DialogLayout(modifierSemantics$default, ComposableLambdaKt.rememberComposableLambda(-533674951, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj3, Object obj4) {
                                    invoke((Composer) obj3, ((Number) obj4).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i7) {
                                    ComposerKt.sourceInformation(composer4, "C188@7932L16:AndroidDialog.android.kt#2oxthz");
                                    if ((i7 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-533674951, i7, -1, "androidx.compose.ui.window.Dialog.<anonymous>.<anonymous>.<anonymous>.<anonymous> (AndroidDialog.android.kt:188)");
                                    }
                                    AndroidDialog_androidKt.Dialog$lambda$0(state).invoke(composer4, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54), composer3, 48, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer3.skipToGroupEnd();
                    }
                }));
                composer2.updateRememberedValue(dialogWrapper3);
                obj = dialogWrapper3;
            } else {
                layoutDirection2 = layoutDirection;
                composer2 = composerStartRestartGroup;
                DialogWrapper dialogWrapper4 = new DialogWrapper(function0, dialogProperties2, view, layoutDirection2, density, uuid);
                dialogWrapper4.setContent(compositionContextRememberCompositionContext, (Function2) ComposableLambdaKt.composableLambdaInstance(488261145, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj3, Object obj4) {
                        invoke((Composer) obj3, ((Number) obj4).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i6) {
                        ComposerKt.sourceInformation(composer3, "C187@7910L56,185@7825L141:AndroidDialog.android.kt#2oxthz");
                        if ((i6 & 3) != 2 || !composer3.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(488261145, i6, -1, "androidx.compose.ui.window.Dialog.<anonymous>.<anonymous>.<anonymous> (AndroidDialog.android.kt:185)");
                            }
                            Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(Modifier.Companion, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public Object invoke(Object obj3) {
                                    invoke((SemanticsPropertyReceiver) obj3);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    SemanticsPropertiesKt.dialog(semanticsPropertyReceiver);
                                }
                            }, 1, (Object) null);
                            final State<? extends Function2<? super Composer, ? super Integer, Unit>> state = stateRememberUpdatedState;
                            AndroidDialog_androidKt.DialogLayout(modifierSemantics$default, ComposableLambdaKt.rememberComposableLambda(-533674951, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj3, Object obj4) {
                                    invoke((Composer) obj3, ((Number) obj4).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i7) {
                                    ComposerKt.sourceInformation(composer4, "C188@7932L16:AndroidDialog.android.kt#2oxthz");
                                    if ((i7 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-533674951, i7, -1, "androidx.compose.ui.window.Dialog.<anonymous>.<anonymous>.<anonymous>.<anonymous> (AndroidDialog.android.kt:188)");
                                    }
                                    AndroidDialog_androidKt.Dialog$lambda$0(state).invoke(composer4, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54), composer3, 48, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer3.skipToGroupEnd();
                    }
                }));
                composer2.updateRememberedValue(dialogWrapper4);
                obj = dialogWrapper4;
            }
            dialogWrapper = (DialogWrapper) obj;
            ComposerKt.sourceInformationMarkerEnd(composer2);
            ComposerKt.sourceInformationMarkerStart(composer2, -464820434, "CC(remember):AndroidDialog.android.kt#9igjgp");
            zChangedInstance = composer2.changedInstance(dialogWrapper);
            objRememberedValue = composer2.rememberedValue();
            if (!zChangedInstance) {
                objRememberedValue = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                    {
                        super(1);
                    }

                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                        dialogWrapper.show();
                        final DialogWrapper dialogWrapper5 = dialogWrapper;
                        return new DisposableEffectResult() {
                            public void dispose() {
                                dialogWrapper5.dismiss();
                                dialogWrapper5.disposeComposition();
                            }
                        };
                    }
                };
                composer2.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                    {
                        super(1);
                    }

                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                        dialogWrapper.show();
                        final DialogWrapper dialogWrapper5 = dialogWrapper;
                        return new DisposableEffectResult() {
                            public void dispose() {
                                dialogWrapper5.dismiss();
                                dialogWrapper5.disposeComposition();
                            }
                        };
                    }
                };
                composer2.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            EffectsKt.DisposableEffect(dialogWrapper, (Function1) objRememberedValue, composer2, 0);
            ComposerKt.sourceInformationMarkerStart(composer2, -464815709, "CC(remember):AndroidDialog.android.kt#9igjgp");
            boolean zChangedInstance3 = composer2.changedInstance(dialogWrapper);
            if ((i3 & 14) == 4) {
                z = true;
            } else {
                z = false;
            }
            boolean z3 = zChangedInstance3 | z;
            layoutDirection3 = layoutDirection2;
            zChanged2 = z3 | ((i3 & 112) == 32) | composer2.changed(layoutDirection3);
            Object objRememberedValue5 = composer2.rememberedValue();
            if (zChanged2) {
                dialogProperties3 = dialogProperties2;
                obj2 = (Function0) new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() throws NoWhenBranchMatchedException {
                        m2111invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m2111invoke() throws NoWhenBranchMatchedException {
                        dialogWrapper.updateParameters(function0, dialogProperties3, layoutDirection3);
                    }
                };
                composer2.updateRememberedValue(obj2);
            } else {
                dialogProperties3 = dialogProperties2;
                obj2 = (Function0) new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() throws NoWhenBranchMatchedException {
                        m2111invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m2111invoke() throws NoWhenBranchMatchedException {
                        dialogWrapper.updateParameters(function0, dialogProperties3, layoutDirection3);
                    }
                };
                composer2.updateRememberedValue(obj2);
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            EffectsKt.SideEffect((Function0) obj2, composer2, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            dialogProperties4 = dialogProperties3;
        } else {
            if (i5 != 0) {
                dialogProperties2 = new DialogProperties(false, false, false, 7, (DefaultConstructorMarker) null);
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2032877254, i3, -1, "androidx.compose.ui.window.Dialog (AndroidDialog.android.kt:166)");
            }
            CompositionLocal localView3 = AndroidCompositionLocals_androidKt.getLocalView();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume7 = composerStartRestartGroup.consume(localView3);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            view = (View) objConsume7;
            CompositionLocal localDensity3 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume8 = composerStartRestartGroup.consume(localDensity3);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            density = (Density) objConsume8;
            CompositionLocal localLayoutDirection3 = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume9 = composerStartRestartGroup.consume(localLayoutDirection3);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            layoutDirection = (LayoutDirection) objConsume9;
            compositionContextRememberCompositionContext = ComposablesKt.rememberCompositionContext(composerStartRestartGroup, 0);
            stateRememberUpdatedState = SnapshotStateKt.rememberUpdatedState(function2, composerStartRestartGroup, (i3 >> 6) & 14);
            uuid = (UUID) RememberSaveableKt.rememberSaveable(new Object[0], (Saver) null, (String) null, new Function0<UUID>() {
                public final UUID invoke() {
                    return UUID.randomUUID();
                }
            }, composerStartRestartGroup, 3072, 6);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -464840651, "CC(remember):AndroidDialog.android.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(view) | composerStartRestartGroup.changed(density);
            Object objRememberedValue6 = composerStartRestartGroup.rememberedValue();
            if (zChanged) {
                layoutDirection2 = layoutDirection;
                composer2 = composerStartRestartGroup;
                DialogWrapper dialogWrapper5 = new DialogWrapper(function0, dialogProperties2, view, layoutDirection2, density, uuid);
                dialogWrapper5.setContent(compositionContextRememberCompositionContext, (Function2) ComposableLambdaKt.composableLambdaInstance(488261145, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj3, Object obj4) {
                        invoke((Composer) obj3, ((Number) obj4).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i6) {
                        ComposerKt.sourceInformation(composer3, "C187@7910L56,185@7825L141:AndroidDialog.android.kt#2oxthz");
                        if ((i6 & 3) != 2 || !composer3.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(488261145, i6, -1, "androidx.compose.ui.window.Dialog.<anonymous>.<anonymous>.<anonymous> (AndroidDialog.android.kt:185)");
                            }
                            Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(Modifier.Companion, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public Object invoke(Object obj3) {
                                    invoke((SemanticsPropertyReceiver) obj3);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    SemanticsPropertiesKt.dialog(semanticsPropertyReceiver);
                                }
                            }, 1, (Object) null);
                            final State<? extends Function2<? super Composer, ? super Integer, Unit>> state = stateRememberUpdatedState;
                            AndroidDialog_androidKt.DialogLayout(modifierSemantics$default, ComposableLambdaKt.rememberComposableLambda(-533674951, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj3, Object obj4) {
                                    invoke((Composer) obj3, ((Number) obj4).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i7) {
                                    ComposerKt.sourceInformation(composer4, "C188@7932L16:AndroidDialog.android.kt#2oxthz");
                                    if ((i7 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-533674951, i7, -1, "androidx.compose.ui.window.Dialog.<anonymous>.<anonymous>.<anonymous>.<anonymous> (AndroidDialog.android.kt:188)");
                                    }
                                    AndroidDialog_androidKt.Dialog$lambda$0(state).invoke(composer4, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54), composer3, 48, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer3.skipToGroupEnd();
                    }
                }));
                composer2.updateRememberedValue(dialogWrapper5);
                obj = dialogWrapper5;
            } else {
                layoutDirection2 = layoutDirection;
                composer2 = composerStartRestartGroup;
                DialogWrapper dialogWrapper6 = new DialogWrapper(function0, dialogProperties2, view, layoutDirection2, density, uuid);
                dialogWrapper6.setContent(compositionContextRememberCompositionContext, (Function2) ComposableLambdaKt.composableLambdaInstance(488261145, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj3, Object obj4) {
                        invoke((Composer) obj3, ((Number) obj4).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i6) {
                        ComposerKt.sourceInformation(composer3, "C187@7910L56,185@7825L141:AndroidDialog.android.kt#2oxthz");
                        if ((i6 & 3) != 2 || !composer3.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(488261145, i6, -1, "androidx.compose.ui.window.Dialog.<anonymous>.<anonymous>.<anonymous> (AndroidDialog.android.kt:185)");
                            }
                            Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(Modifier.Companion, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public Object invoke(Object obj3) {
                                    invoke((SemanticsPropertyReceiver) obj3);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    SemanticsPropertiesKt.dialog(semanticsPropertyReceiver);
                                }
                            }, 1, (Object) null);
                            final State<? extends Function2<? super Composer, ? super Integer, Unit>> state = stateRememberUpdatedState;
                            AndroidDialog_androidKt.DialogLayout(modifierSemantics$default, ComposableLambdaKt.rememberComposableLambda(-533674951, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj3, Object obj4) {
                                    invoke((Composer) obj3, ((Number) obj4).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i7) {
                                    ComposerKt.sourceInformation(composer4, "C188@7932L16:AndroidDialog.android.kt#2oxthz");
                                    if ((i7 & 3) == 2 && composer4.getSkipping()) {
                                        composer4.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-533674951, i7, -1, "androidx.compose.ui.window.Dialog.<anonymous>.<anonymous>.<anonymous>.<anonymous> (AndroidDialog.android.kt:188)");
                                    }
                                    AndroidDialog_androidKt.Dialog$lambda$0(state).invoke(composer4, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer3, 54), composer3, 48, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer3.skipToGroupEnd();
                    }
                }));
                composer2.updateRememberedValue(dialogWrapper6);
                obj = dialogWrapper6;
            }
            dialogWrapper = (DialogWrapper) obj;
            ComposerKt.sourceInformationMarkerEnd(composer2);
            ComposerKt.sourceInformationMarkerStart(composer2, -464820434, "CC(remember):AndroidDialog.android.kt#9igjgp");
            zChangedInstance = composer2.changedInstance(dialogWrapper);
            objRememberedValue = composer2.rememberedValue();
            if (!zChangedInstance) {
                objRememberedValue = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                    {
                        super(1);
                    }

                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                        dialogWrapper.show();
                        final DialogWrapper dialogWrapper7 = dialogWrapper;
                        return new DisposableEffectResult() {
                            public void dispose() {
                                dialogWrapper7.dismiss();
                                dialogWrapper7.disposeComposition();
                            }
                        };
                    }
                };
                composer2.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                    {
                        super(1);
                    }

                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                        dialogWrapper.show();
                        final DialogWrapper dialogWrapper7 = dialogWrapper;
                        return new DisposableEffectResult() {
                            public void dispose() {
                                dialogWrapper7.dismiss();
                                dialogWrapper7.disposeComposition();
                            }
                        };
                    }
                };
                composer2.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            EffectsKt.DisposableEffect(dialogWrapper, (Function1) objRememberedValue, composer2, 0);
            ComposerKt.sourceInformationMarkerStart(composer2, -464815709, "CC(remember):AndroidDialog.android.kt#9igjgp");
            boolean zChangedInstance4 = composer2.changedInstance(dialogWrapper);
            if ((i3 & 14) == 4) {
                z = true;
            } else {
                z = false;
            }
            boolean z4 = zChangedInstance4 | z;
            layoutDirection3 = layoutDirection2;
            zChanged2 = z4 | ((i3 & 112) == 32) | composer2.changed(layoutDirection3);
            Object objRememberedValue7 = composer2.rememberedValue();
            if (zChanged2) {
                dialogProperties3 = dialogProperties2;
                obj2 = (Function0) new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() throws NoWhenBranchMatchedException {
                        m2111invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m2111invoke() throws NoWhenBranchMatchedException {
                        dialogWrapper.updateParameters(function0, dialogProperties3, layoutDirection3);
                    }
                };
                composer2.updateRememberedValue(obj2);
            } else {
                dialogProperties3 = dialogProperties2;
                obj2 = (Function0) new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() throws NoWhenBranchMatchedException {
                        m2111invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m2111invoke() throws NoWhenBranchMatchedException {
                        dialogWrapper.updateParameters(function0, dialogProperties3, layoutDirection3);
                    }
                };
                composer2.updateRememberedValue(obj2);
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            EffectsKt.SideEffect((Function0) obj2, composer2, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            dialogProperties4 = dialogProperties3;
        }
        scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj3, Object obj4) {
                    invoke((Composer) obj3, ((Number) obj4).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i6) {
                    AndroidDialog_androidKt.Dialog(function0, dialogProperties4, function2, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void DialogLayout(final Modifier modifier, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1177876616);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DialogLayout)P(1)465@18400L455:AndroidDialog.android.kt#2oxthz");
        int i4 = i2 & 1;
        if (i4 != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(modifier) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? 32 : 16;
        }
        if ((i3 & 19) != 18 || !composerStartRestartGroup.getSkipping()) {
            if (i4 != 0) {
                modifier = (Modifier) Modifier.Companion;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1177876616, i3, -1, "androidx.compose.ui.window.DialogLayout (AndroidDialog.android.kt:464)");
            }
            C00411 c00411 = new MeasurePolicy() {
                public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i5) {
                    return MeasurePolicy.-CC.$default$maxIntrinsicHeight(this, intrinsicMeasureScope, list, i5);
                }

                public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i5) {
                    return MeasurePolicy.-CC.$default$maxIntrinsicWidth(this, intrinsicMeasureScope, list, i5);
                }

                public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i5) {
                    return MeasurePolicy.-CC.$default$minIntrinsicHeight(this, intrinsicMeasureScope, list, i5);
                }

                public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i5) {
                    return MeasurePolicy.-CC.$default$minIntrinsicWidth(this, intrinsicMeasureScope, list, i5);
                }

                public final MeasureResult m2113measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j) {
                    Object obj;
                    ArrayList arrayList = new ArrayList(list.size());
                    int size = list.size();
                    for (int i5 = 0; i5 < size; i5++) {
                        arrayList.add(list.get(i5).measure-BRTryo0(j));
                    }
                    final ArrayList arrayList2 = arrayList;
                    Object obj2 = null;
                    int i6 = 1;
                    if (!arrayList2.isEmpty()) {
                        obj = arrayList2.get(0);
                        int width = ((Placeable) obj).getWidth();
                        int lastIndex = CollectionsKt.getLastIndex(arrayList2);
                        if (1 <= lastIndex) {
                            int i7 = 1;
                            while (true) {
                                Object obj3 = arrayList2.get(i7);
                                int width2 = ((Placeable) obj3).getWidth();
                                if (width < width2) {
                                    obj = obj3;
                                    width = width2;
                                }
                                if (i7 == lastIndex) {
                                    break;
                                }
                                i7++;
                            }
                        }
                    } else {
                        obj = null;
                    }
                    Placeable placeable = (Placeable) obj;
                    int width3 = placeable != null ? placeable.getWidth() : Constraints.m1768getMinWidthimpl(j);
                    if (!arrayList2.isEmpty()) {
                        Object obj4 = arrayList2.get(0);
                        int height = ((Placeable) obj4).getHeight();
                        int lastIndex2 = CollectionsKt.getLastIndex(arrayList2);
                        if (1 <= lastIndex2) {
                            while (true) {
                                Object obj5 = arrayList2.get(i6);
                                int height2 = ((Placeable) obj5).getHeight();
                                if (height < height2) {
                                    obj4 = obj5;
                                    height = height2;
                                }
                                if (i6 == lastIndex2) {
                                    break;
                                }
                                i6++;
                            }
                        }
                        obj2 = obj4;
                    }
                    Placeable placeable2 = (Placeable) obj2;
                    return MeasureScope.-CC.layout$default(measureScope, width3, placeable2 != null ? placeable2.getHeight() : Constraints.m1767getMinHeightimpl(j), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj6) {
                            invoke((Placeable.PlacementScope) obj6);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Placeable.PlacementScope placementScope) {
                            List<Placeable> list2 = arrayList2;
                            int size2 = list2.size();
                            for (int i8 = 0; i8 < size2; i8++) {
                                Placeable.PlacementScope.placeRelative$default(placementScope, list2.get(i8), 0, 0, 0.0f, 4, (Object) null);
                            }
                        }
                    }, 4, (Object) null);
                }
            };
            int i5 = ((i3 >> 3) & 14) | 384 | ((i3 << 3) & 112);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier);
            Function0 constructor = ComposeUiNode.Companion.getConstructor();
            int i6 = ((i5 << 6) & 896) | 6;
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
            Composer composer2 = Updater.constructor-impl(composerStartRestartGroup);
            Updater.set-impl(composer2, c00411, ComposeUiNode.Companion.getSetMeasurePolicy());
            Updater.set-impl(composer2, currentCompositionLocalMap, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
            Function2 setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
            if (composer2.getInserting() || !Intrinsics.areEqual(composer2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.set-impl(composer2, modifierMaterializeModifier, ComposeUiNode.Companion.getSetModifier());
            function2.invoke(composerStartRestartGroup, Integer.valueOf((i6 >> 6) & 14));
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
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

                public final void invoke(Composer composer3, int i7) {
                    AndroidDialog_androidKt.DialogLayout(modifier, function2, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final Function2<Composer, Integer, Unit> Dialog$lambda$0(State<? extends Function2<? super Composer, ? super Integer, Unit>> state) {
        return (Function2) state.getValue();
    }
}
