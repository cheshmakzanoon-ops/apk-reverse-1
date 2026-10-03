package androidx.compose.p000ui.viewinterop;

import android.content.Context;
import android.view.View;
import androidx.compose.p000ui.unit.Density;
import androidx.compose.p000ui.unit.LayoutDirection;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionContext;
import androidx.compose.runtime.CompositionLocal;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.saveable.SaveableStateRegistry;
import androidx.compose.runtime.saveable.SaveableStateRegistryKt;
import androidx.compose.ui.ComposedModifierKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.internal.InlineClassHelperKt;
import androidx.compose.ui.node.ComposeUiNode;
import androidx.compose.ui.node.LayoutNode;
import androidx.compose.ui.node.Owner;
import androidx.compose.ui.node.UiApplier;
import androidx.compose.ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.ui.platform.CompositionLocalsKt;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.exifinterface.media.ExifInterface;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.compose.LocalLifecycleOwnerKt;
import androidx.savedstate.SavedStateRegistryOwner;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001ay\u0010\u0007\u001a\u00020\u0003\"\b\b\u0000\u0010\b*\u00020\u00022\u0012\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u0002H\b0\u00012\b\b\u0002\u0010\u000b\u001a\u00020\f2\u0016\b\u0002\u0010\r\u001a\u0010\u0012\u0004\u0012\u0002H\b\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u00012\u0014\b\u0002\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u0002H\b\u0012\u0004\u0012\u00020\u00030\u00012\u0014\b\u0002\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u0002H\b\u0012\u0004\u0012\u00020\u00030\u0001H\u0007¢\u0006\u0002\u0010\u0010\u001aK\u0010\u0007\u001a\u00020\u0003\"\b\b\u0000\u0010\b*\u00020\u00022\u0012\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u0002H\b0\u00012\b\b\u0002\u0010\u000b\u001a\u00020\f2\u0014\b\u0002\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u0002H\b\u0012\u0004\u0012\u00020\u00030\u0001H\u0007¢\u0006\u0002\u0010\u0011\u001a1\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00140\u0013\"\b\b\u0000\u0010\b*\u00020\u00022\u0012\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u0002H\b0\u0001H\u0003¢\u0006\u0002\u0010\u0015\u001a\u001c\u0010\u0016\u001a\b\u0012\u0004\u0012\u0002H\b0\u0017\"\b\b\u0000\u0010\b*\u00020\u0002*\u00020\u0014H\u0002\u001a^\u0010\u0018\u001a\u00020\u0003\"\b\b\u0000\u0010\b*\u00020\u0002*\b\u0012\u0004\u0012\u00020\u00140\u00192\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020%H\u0002ø\u0001\u0000¢\u0006\u0004\b&\u0010'\"\"\u0010\u0000\u001a\u0013\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001¢\u0006\u0002\b\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006("}, d2 = {"NoOpUpdate", "Lkotlin/Function1;", "Landroid/view/View;", "", "Lkotlin/ExtensionFunctionType;", "getNoOpUpdate", "()Lkotlin/jvm/functions/Function1;", "AndroidView", ExifInterface.GPS_DIRECTION_TRUE, "factory", "Landroid/content/Context;", "modifier", "Landroidx/compose/ui/Modifier;", "onReset", "onRelease", "update", "(Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "(Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "createAndroidViewNodeFactory", "Lkotlin/Function0;", "Landroidx/compose/ui/node/LayoutNode;", "(Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;I)Lkotlin/jvm/functions/Function0;", "requireViewFactoryHolder", "Landroidx/compose/ui/viewinterop/ViewFactoryHolder;", "updateViewHolderParams", "Landroidx/compose/runtime/Updater;", "compositeKeyHash", "", "density", "Landroidx/compose/ui/unit/Density;", "lifecycleOwner", "Landroidx/lifecycle/LifecycleOwner;", "savedStateRegistryOwner", "Landroidx/savedstate/SavedStateRegistryOwner;", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "compositionLocalMap", "Landroidx/compose/runtime/CompositionLocalMap;", "updateViewHolderParams-6NefGtU", "(Landroidx/compose/runtime/Composer;Landroidx/compose/ui/Modifier;ILandroidx/compose/ui/unit/Density;Landroidx/lifecycle/LifecycleOwner;Landroidx/savedstate/SavedStateRegistryOwner;Landroidx/compose/ui/unit/LayoutDirection;Landroidx/compose/runtime/CompositionLocalMap;)V", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidView_androidKt {
    private static final Function1<View, Unit> NoOpUpdate = new Function1<View, Unit>() {
        public final void invoke(View view) {
        }

        public Object invoke(Object obj) {
            invoke((View) obj);
            return Unit.INSTANCE;
        }
    };

    public static final <T extends View> void AndroidView(final Function1<? super Context, ? extends T> function1, Modifier modifier, Function1<? super T, Unit> function2, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1783766393);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AndroidView)108@5537L130:AndroidView.android.kt#z33iqn");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function1) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i4 = i2 & 2;
        if (i4 != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
        }
        int i5 = i2 & 4;
        if (i5 != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? 256 : 128;
        }
        if ((i3 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
            if (i4 != 0) {
                modifier = (Modifier) Modifier.Companion;
            }
            if (i5 != 0) {
                function2 = NoOpUpdate;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1783766393, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:107)");
            }
            AndroidView(function1, modifier, null, NoOpUpdate, function2, composerStartRestartGroup, (i3 & 14) | 3072 | (i3 & 112) | ((i3 << 6) & 57344), 4);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        final Modifier modifier2 = modifier;
        final Function1<? super T, Unit> function3 = function2;
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

                public final void invoke(Composer composer2, int i6) {
                    AndroidView_androidKt.AndroidView(function1, modifier2, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final <T extends View> void AndroidView(final Function1<? super Context, ? extends T> function1, Modifier modifier, Function1<? super T, Unit> function2, Function1<? super T, Unit> function3, Function1<? super T, Unit> function4, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        Function1<? super T, Unit> function5;
        int i5;
        int i6;
        Function1<? super T, Unit> function6;
        int i7;
        int i8;
        Function1<? super T, Unit> function7;
        int i9;
        Modifier modifier3;
        int currentCompositeKeyHash;
        Modifier modifierMaterializeModifier;
        Density density;
        LayoutDirection layoutDirection;
        CompositionLocalMap currentCompositionLocalMap;
        LifecycleOwner lifecycleOwner;
        SavedStateRegistryOwner savedStateRegistryOwner;
        Function0<LayoutNode> function0CreateAndroidViewNodeFactory;
        Function0<LayoutNode> function0CreateAndroidViewNodeFactory2;
        final Function1<? super T, Unit> function8;
        final Function1<? super T, Unit> function9;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-180024211);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(AndroidView)P(!2,3)212@11953L23,214@12100L7,215@12155L7,222@12611L7,223@12682L7:AndroidView.android.kt#z33iqn");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function1) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i10 = i2 & 2;
        if (i10 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    function5 = function2;
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i5 = 256;
                    } else {
                        i5 = 128;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        function6 = function3;
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i7 = 2048;
                        } else {
                            i7 = 1024;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 16;
                    if (i8 != 0) {
                        if ((i & 24576) == 0) {
                            function7 = function4;
                            if (composerStartRestartGroup.changedInstance(function7)) {
                                i9 = 16384;
                            } else {
                                i9 = 8192;
                            }
                            i3 |= i9;
                        }
                        if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                            if (i10 != 0) {
                                modifier3 = (Modifier) Modifier.Companion;
                            } else {
                                modifier3 = modifier2;
                            }
                            if (i4 != 0) {
                                function5 = null;
                            }
                            if (i6 != 0) {
                                function6 = NoOpUpdate;
                            }
                            if (i8 != 0) {
                                function7 = NoOpUpdate;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                            }
                            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                            modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                            CompositionLocal localDensity = CompositionLocalsKt.getLocalDensity();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume = composerStartRestartGroup.consume(localDensity);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            density = (Density) objConsume;
                            CompositionLocal localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume2 = composerStartRestartGroup.consume(localLayoutDirection);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            layoutDirection = (LayoutDirection) objConsume2;
                            currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                            CompositionLocal localLifecycleOwner = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume3 = composerStartRestartGroup.consume(localLifecycleOwner);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            lifecycleOwner = (LifecycleOwner) objConsume3;
                            CompositionLocal localSavedStateRegistryOwner = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume4 = composerStartRestartGroup.consume(localSavedStateRegistryOwner);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume4;
                            if (function5 != null) {
                                composerStartRestartGroup.startReplaceGroup(607871394);
                                ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                                function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                                if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composerStartRestartGroup.startReusableNode();
                                if (composerStartRestartGroup.getInserting()) {
                                    composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                                } else {
                                    composerStartRestartGroup.useNode();
                                }
                                Composer composer2 = Updater.constructor-impl(composerStartRestartGroup);
                                m2098updateViewHolderParams6NefGtU(composer2, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                                Updater.set-impl(composer2, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((LayoutNode) obj, (Function1) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function10) {
                                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function10);
                                    }
                                });
                                Updater.set-impl(composer2, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((LayoutNode) obj, (Function1) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function10) {
                                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function10);
                                    }
                                });
                                Updater.set-impl(composer2, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((LayoutNode) obj, (Function1) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function10) {
                                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function10);
                                    }
                                });
                                composerStartRestartGroup.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                composerStartRestartGroup.endReplaceGroup();
                            } else {
                                composerStartRestartGroup.startReplaceGroup(608726777);
                                ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                                function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                                if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composerStartRestartGroup.startNode();
                                if (composerStartRestartGroup.getInserting()) {
                                    composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                                } else {
                                    composerStartRestartGroup.useNode();
                                }
                                Composer composer3 = Updater.constructor-impl(composerStartRestartGroup);
                                m2098updateViewHolderParams6NefGtU(composer3, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                                Updater.set-impl(composer3, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((LayoutNode) obj, (Function1) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function10) {
                                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function10);
                                    }
                                });
                                Updater.set-impl(composer3, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((LayoutNode) obj, (Function1) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function10) {
                                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function10);
                                    }
                                });
                                composerStartRestartGroup.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                composerStartRestartGroup.endReplaceGroup();
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier3 = modifier2;
                        }
                        function8 = function5;
                        function9 = function7;
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier4 = modifier3;
                            final Function1<? super T, Unit> function10 = function6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer4, int i11) {
                                    AndroidView_androidKt.AndroidView(function1, modifier4, function8, function10, function9, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 24576;
                    function7 = function4;
                    if ((i3 & 9363) == 9362) {
                        if (i10 != 0) {
                            modifier3 = (Modifier) Modifier.Companion;
                        } else {
                            modifier3 = modifier2;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if (i6 != 0) {
                            function6 = NoOpUpdate;
                        }
                        if (i8 != 0) {
                            function7 = NoOpUpdate;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                        }
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
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
                        currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        CompositionLocal localLifecycleOwner2 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume7 = composerStartRestartGroup.consume(localLifecycleOwner2);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        lifecycleOwner = (LifecycleOwner) objConsume7;
                        CompositionLocal localSavedStateRegistryOwner2 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume8 = composerStartRestartGroup.consume(localSavedStateRegistryOwner2);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume8;
                        if (function5 != null) {
                            composerStartRestartGroup.startReplaceGroup(607871394);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                            function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startReusableNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer4 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer4, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer4, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function11) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function11);
                                }
                            });
                            Updater.set-impl(composer4, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function11) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function11);
                                }
                            });
                            Updater.set-impl(composer4, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function11) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function11);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(608726777);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                            function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer5 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer5, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer5, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function11) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function11);
                                }
                            });
                            Updater.set-impl(composer5, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function11) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function11);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    } else {
                        if (i10 != 0) {
                            modifier3 = (Modifier) Modifier.Companion;
                        } else {
                            modifier3 = modifier2;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if (i6 != 0) {
                            function6 = NoOpUpdate;
                        }
                        if (i8 != 0) {
                            function7 = NoOpUpdate;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                        }
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                        CompositionLocal localDensity3 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume9 = composerStartRestartGroup.consume(localDensity3);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume9;
                        CompositionLocal localLayoutDirection3 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume10 = composerStartRestartGroup.consume(localLayoutDirection3);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        layoutDirection = (LayoutDirection) objConsume10;
                        currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        CompositionLocal localLifecycleOwner3 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11 = composerStartRestartGroup.consume(localLifecycleOwner3);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        lifecycleOwner = (LifecycleOwner) objConsume11;
                        CompositionLocal localSavedStateRegistryOwner3 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume12 = composerStartRestartGroup.consume(localSavedStateRegistryOwner3);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume12;
                        if (function5 != null) {
                            composerStartRestartGroup.startReplaceGroup(607871394);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                            function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startReusableNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer6 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer6, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer6, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function11) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function11);
                                }
                            });
                            Updater.set-impl(composer6, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function11) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function11);
                                }
                            });
                            Updater.set-impl(composer6, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function11) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function11);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(608726777);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                            function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer7 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer7, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer7, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function11) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function11);
                                }
                            });
                            Updater.set-impl(composer7, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function11) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function11);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                    function8 = function5;
                    function9 = function7;
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier5 = modifier3;
                        final Function1<? super T, Unit> function11 = function6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer8, int i11) {
                                AndroidView_androidKt.AndroidView(function1, modifier5, function8, function11, function9, composer8, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                function6 = function3;
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        function7 = function4;
                        if (composerStartRestartGroup.changedInstance(function7)) {
                            i9 = 16384;
                        } else {
                            i9 = 8192;
                        }
                        i3 |= i9;
                    }
                    if ((i3 & 9363) == 9362) {
                        if (i10 != 0) {
                            modifier3 = (Modifier) Modifier.Companion;
                        } else {
                            modifier3 = modifier2;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if (i6 != 0) {
                            function6 = NoOpUpdate;
                        }
                        if (i8 != 0) {
                            function7 = NoOpUpdate;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                        }
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                        CompositionLocal localDensity4 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume13 = composerStartRestartGroup.consume(localDensity4);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume13;
                        CompositionLocal localLayoutDirection4 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume14 = composerStartRestartGroup.consume(localLayoutDirection4);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        layoutDirection = (LayoutDirection) objConsume14;
                        currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        CompositionLocal localLifecycleOwner4 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume15 = composerStartRestartGroup.consume(localLifecycleOwner4);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        lifecycleOwner = (LifecycleOwner) objConsume15;
                        CompositionLocal localSavedStateRegistryOwner4 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume16 = composerStartRestartGroup.consume(localSavedStateRegistryOwner4);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume16;
                        if (function5 != null) {
                            composerStartRestartGroup.startReplaceGroup(607871394);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                            function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startReusableNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer8 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer8, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer8, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function12) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function12);
                                }
                            });
                            Updater.set-impl(composer8, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function12) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function12);
                                }
                            });
                            Updater.set-impl(composer8, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function12) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function12);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(608726777);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                            function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer9 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer9, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer9, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function12) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function12);
                                }
                            });
                            Updater.set-impl(composer9, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function12) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function12);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    } else {
                        if (i10 != 0) {
                            modifier3 = (Modifier) Modifier.Companion;
                        } else {
                            modifier3 = modifier2;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if (i6 != 0) {
                            function6 = NoOpUpdate;
                        }
                        if (i8 != 0) {
                            function7 = NoOpUpdate;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                        }
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                        CompositionLocal localDensity5 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume17 = composerStartRestartGroup.consume(localDensity5);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume17;
                        CompositionLocal localLayoutDirection5 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume18 = composerStartRestartGroup.consume(localLayoutDirection5);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        layoutDirection = (LayoutDirection) objConsume18;
                        currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        CompositionLocal localLifecycleOwner5 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume19 = composerStartRestartGroup.consume(localLifecycleOwner5);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        lifecycleOwner = (LifecycleOwner) objConsume19;
                        CompositionLocal localSavedStateRegistryOwner5 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume110 = composerStartRestartGroup.consume(localSavedStateRegistryOwner5);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume110;
                        if (function5 != null) {
                            composerStartRestartGroup.startReplaceGroup(607871394);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                            function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startReusableNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer10 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer10, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer10, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function12) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function12);
                                }
                            });
                            Updater.set-impl(composer10, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function12) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function12);
                                }
                            });
                            Updater.set-impl(composer10, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function12) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function12);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(608726777);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                            function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer11 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer11, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer11, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function12) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function12);
                                }
                            });
                            Updater.set-impl(composer11, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function12) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function12);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                    function8 = function5;
                    function9 = function7;
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier6 = modifier3;
                        final Function1<? super T, Unit> function12 = function6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer12, int i11) {
                                AndroidView_androidKt.AndroidView(function1, modifier6, function8, function12, function9, composer12, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                function7 = function4;
                if ((i3 & 9363) == 9362) {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity6 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111 = composerStartRestartGroup.consume(localDensity6);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume111;
                    CompositionLocal localLayoutDirection6 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume112 = composerStartRestartGroup.consume(localLayoutDirection6);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume112;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner6 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume113 = composerStartRestartGroup.consume(localLifecycleOwner6);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume113;
                    CompositionLocal localSavedStateRegistryOwner6 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume114 = composerStartRestartGroup.consume(localSavedStateRegistryOwner6);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume114;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer12 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer12, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer12, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function13) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function13);
                            }
                        });
                        Updater.set-impl(composer12, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function13) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function13);
                            }
                        });
                        Updater.set-impl(composer12, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function13) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function13);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer13 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer13, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer13, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function13) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function13);
                            }
                        });
                        Updater.set-impl(composer13, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function13) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function13);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity7 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume115 = composerStartRestartGroup.consume(localDensity7);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume115;
                    CompositionLocal localLayoutDirection7 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume116 = composerStartRestartGroup.consume(localLayoutDirection7);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume116;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner7 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume117 = composerStartRestartGroup.consume(localLifecycleOwner7);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume117;
                    CompositionLocal localSavedStateRegistryOwner7 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume118 = composerStartRestartGroup.consume(localSavedStateRegistryOwner7);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume118;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer14 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer14, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer14, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function13) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function13);
                            }
                        });
                        Updater.set-impl(composer14, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function13) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function13);
                            }
                        });
                        Updater.set-impl(composer14, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function13) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function13);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer15 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer15, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer15, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function13) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function13);
                            }
                        });
                        Updater.set-impl(composer15, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function13) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function13);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                function8 = function5;
                function9 = function7;
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier7 = modifier3;
                    final Function1<? super T, Unit> function13 = function6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer16, int i11) {
                            AndroidView_androidKt.AndroidView(function1, modifier7, function8, function13, function9, composer16, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            function5 = function2;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    function6 = function3;
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i7 = 2048;
                    } else {
                        i7 = 1024;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        function7 = function4;
                        if (composerStartRestartGroup.changedInstance(function7)) {
                            i9 = 16384;
                        } else {
                            i9 = 8192;
                        }
                        i3 |= i9;
                    }
                    if ((i3 & 9363) == 9362) {
                        if (i10 != 0) {
                            modifier3 = (Modifier) Modifier.Companion;
                        } else {
                            modifier3 = modifier2;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if (i6 != 0) {
                            function6 = NoOpUpdate;
                        }
                        if (i8 != 0) {
                            function7 = NoOpUpdate;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                        }
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                        CompositionLocal localDensity8 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume119 = composerStartRestartGroup.consume(localDensity8);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume119;
                        CompositionLocal localLayoutDirection8 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1110 = composerStartRestartGroup.consume(localLayoutDirection8);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        layoutDirection = (LayoutDirection) objConsume1110;
                        currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        CompositionLocal localLifecycleOwner8 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111 = composerStartRestartGroup.consume(localLifecycleOwner8);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        lifecycleOwner = (LifecycleOwner) objConsume1111;
                        CompositionLocal localSavedStateRegistryOwner8 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1112 = composerStartRestartGroup.consume(localSavedStateRegistryOwner8);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume1112;
                        if (function5 != null) {
                            composerStartRestartGroup.startReplaceGroup(607871394);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                            function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startReusableNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer16 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer16, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer16, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function14) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function14);
                                }
                            });
                            Updater.set-impl(composer16, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function14) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function14);
                                }
                            });
                            Updater.set-impl(composer16, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function14) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function14);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(608726777);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                            function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer17 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer17, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer17, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function14) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function14);
                                }
                            });
                            Updater.set-impl(composer17, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function14) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function14);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    } else {
                        if (i10 != 0) {
                            modifier3 = (Modifier) Modifier.Companion;
                        } else {
                            modifier3 = modifier2;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if (i6 != 0) {
                            function6 = NoOpUpdate;
                        }
                        if (i8 != 0) {
                            function7 = NoOpUpdate;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                        }
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                        CompositionLocal localDensity9 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1113 = composerStartRestartGroup.consume(localDensity9);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume1113;
                        CompositionLocal localLayoutDirection9 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1114 = composerStartRestartGroup.consume(localLayoutDirection9);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        layoutDirection = (LayoutDirection) objConsume1114;
                        currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        CompositionLocal localLifecycleOwner9 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1115 = composerStartRestartGroup.consume(localLifecycleOwner9);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        lifecycleOwner = (LifecycleOwner) objConsume1115;
                        CompositionLocal localSavedStateRegistryOwner9 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1116 = composerStartRestartGroup.consume(localSavedStateRegistryOwner9);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume1116;
                        if (function5 != null) {
                            composerStartRestartGroup.startReplaceGroup(607871394);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                            function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startReusableNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer18 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer18, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer18, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function14) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function14);
                                }
                            });
                            Updater.set-impl(composer18, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function14) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function14);
                                }
                            });
                            Updater.set-impl(composer18, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function14) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function14);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(608726777);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                            function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer19 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer19, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer19, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function14) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function14);
                                }
                            });
                            Updater.set-impl(composer19, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function14) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function14);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                    function8 = function5;
                    function9 = function7;
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier8 = modifier3;
                        final Function1<? super T, Unit> function14 = function6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer110, int i11) {
                                AndroidView_androidKt.AndroidView(function1, modifier8, function8, function14, function9, composer110, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                function7 = function4;
                if ((i3 & 9363) == 9362) {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity10 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1117 = composerStartRestartGroup.consume(localDensity10);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume1117;
                    CompositionLocal localLayoutDirection10 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1118 = composerStartRestartGroup.consume(localLayoutDirection10);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume1118;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner10 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1119 = composerStartRestartGroup.consume(localLifecycleOwner10);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume1119;
                    CompositionLocal localSavedStateRegistryOwner10 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11110 = composerStartRestartGroup.consume(localSavedStateRegistryOwner10);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume11110;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer110 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer110, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer110, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function15) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function15);
                            }
                        });
                        Updater.set-impl(composer110, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function15) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function15);
                            }
                        });
                        Updater.set-impl(composer110, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function15) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function15);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer111 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer111, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer111, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function15) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function15);
                            }
                        });
                        Updater.set-impl(composer111, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function15) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function15);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity11 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111 = composerStartRestartGroup.consume(localDensity11);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume11111;
                    CompositionLocal localLayoutDirection11 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11112 = composerStartRestartGroup.consume(localLayoutDirection11);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume11112;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner11 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11113 = composerStartRestartGroup.consume(localLifecycleOwner11);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume11113;
                    CompositionLocal localSavedStateRegistryOwner11 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11114 = composerStartRestartGroup.consume(localSavedStateRegistryOwner11);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume11114;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer112 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer112, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer112, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function15) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function15);
                            }
                        });
                        Updater.set-impl(composer112, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function15) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function15);
                            }
                        });
                        Updater.set-impl(composer112, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function15) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function15);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer113 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer113, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer113, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function15) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function15);
                            }
                        });
                        Updater.set-impl(composer113, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function15) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function15);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                function8 = function5;
                function9 = function7;
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier9 = modifier3;
                    final Function1<? super T, Unit> function15 = function6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer114, int i11) {
                            AndroidView_androidKt.AndroidView(function1, modifier9, function8, function15, function9, composer114, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            function6 = function3;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    function7 = function4;
                    if (composerStartRestartGroup.changedInstance(function7)) {
                        i9 = 16384;
                    } else {
                        i9 = 8192;
                    }
                    i3 |= i9;
                }
                if ((i3 & 9363) == 9362) {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity12 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11115 = composerStartRestartGroup.consume(localDensity12);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume11115;
                    CompositionLocal localLayoutDirection12 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11116 = composerStartRestartGroup.consume(localLayoutDirection12);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume11116;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner12 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11117 = composerStartRestartGroup.consume(localLifecycleOwner12);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume11117;
                    CompositionLocal localSavedStateRegistryOwner12 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11118 = composerStartRestartGroup.consume(localSavedStateRegistryOwner12);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume11118;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer114 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer114, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer114, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function16) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function16);
                            }
                        });
                        Updater.set-impl(composer114, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function16) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function16);
                            }
                        });
                        Updater.set-impl(composer114, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function16) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function16);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer115 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer115, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer115, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function16) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function16);
                            }
                        });
                        Updater.set-impl(composer115, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function16) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function16);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity13 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11119 = composerStartRestartGroup.consume(localDensity13);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume11119;
                    CompositionLocal localLayoutDirection13 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111110 = composerStartRestartGroup.consume(localLayoutDirection13);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume111110;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner13 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111 = composerStartRestartGroup.consume(localLifecycleOwner13);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume111111;
                    CompositionLocal localSavedStateRegistryOwner13 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111112 = composerStartRestartGroup.consume(localSavedStateRegistryOwner13);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume111112;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer116 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer116, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer116, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function16) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function16);
                            }
                        });
                        Updater.set-impl(composer116, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function16) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function16);
                            }
                        });
                        Updater.set-impl(composer116, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function16) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function16);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer117 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer117, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer117, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function16) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function16);
                            }
                        });
                        Updater.set-impl(composer117, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function16) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function16);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                function8 = function5;
                function9 = function7;
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier10 = modifier3;
                    final Function1<? super T, Unit> function16 = function6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer118, int i11) {
                            AndroidView_androidKt.AndroidView(function1, modifier10, function8, function16, function9, composer118, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            function7 = function4;
            if ((i3 & 9363) == 9362) {
                if (i10 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if (i6 != 0) {
                    function6 = NoOpUpdate;
                }
                if (i8 != 0) {
                    function7 = NoOpUpdate;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                }
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                CompositionLocal localDensity14 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111113 = composerStartRestartGroup.consume(localDensity14);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume111113;
                CompositionLocal localLayoutDirection14 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111114 = composerStartRestartGroup.consume(localLayoutDirection14);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                layoutDirection = (LayoutDirection) objConsume111114;
                currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                CompositionLocal localLifecycleOwner14 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111115 = composerStartRestartGroup.consume(localLifecycleOwner14);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                lifecycleOwner = (LifecycleOwner) objConsume111115;
                CompositionLocal localSavedStateRegistryOwner14 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111116 = composerStartRestartGroup.consume(localSavedStateRegistryOwner14);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume111116;
                if (function5 != null) {
                    composerStartRestartGroup.startReplaceGroup(607871394);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                    function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer118 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer118, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer118, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function17) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function17);
                        }
                    });
                    Updater.set-impl(composer118, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function17) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function17);
                        }
                    });
                    Updater.set-impl(composer118, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function17) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function17);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(608726777);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                    function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer119 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer119, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer119, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function17) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function17);
                        }
                    });
                    Updater.set-impl(composer119, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function17) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function17);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                if (i10 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if (i6 != 0) {
                    function6 = NoOpUpdate;
                }
                if (i8 != 0) {
                    function7 = NoOpUpdate;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                }
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                CompositionLocal localDensity15 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111117 = composerStartRestartGroup.consume(localDensity15);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume111117;
                CompositionLocal localLayoutDirection15 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111118 = composerStartRestartGroup.consume(localLayoutDirection15);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                layoutDirection = (LayoutDirection) objConsume111118;
                currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                CompositionLocal localLifecycleOwner15 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111119 = composerStartRestartGroup.consume(localLifecycleOwner15);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                lifecycleOwner = (LifecycleOwner) objConsume111119;
                CompositionLocal localSavedStateRegistryOwner15 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111110 = composerStartRestartGroup.consume(localSavedStateRegistryOwner15);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume1111110;
                if (function5 != null) {
                    composerStartRestartGroup.startReplaceGroup(607871394);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                    function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer1110 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer1110, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer1110, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function17) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function17);
                        }
                    });
                    Updater.set-impl(composer1110, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function17) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function17);
                        }
                    });
                    Updater.set-impl(composer1110, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function17) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function17);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(608726777);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                    function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer1111 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer1111, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer1111, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function17) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function17);
                        }
                    });
                    Updater.set-impl(composer1111, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function17) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function17);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            function8 = function5;
            function9 = function7;
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier11 = modifier3;
                final Function1<? super T, Unit> function17 = function6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer1112, int i11) {
                        AndroidView_androidKt.AndroidView(function1, modifier11, function8, function17, function9, composer1112, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                function5 = function2;
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i5 = 256;
                } else {
                    i5 = 128;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    function6 = function3;
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i7 = 2048;
                    } else {
                        i7 = 1024;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        function7 = function4;
                        if (composerStartRestartGroup.changedInstance(function7)) {
                            i9 = 16384;
                        } else {
                            i9 = 8192;
                        }
                        i3 |= i9;
                    }
                    if ((i3 & 9363) == 9362) {
                        if (i10 != 0) {
                            modifier3 = (Modifier) Modifier.Companion;
                        } else {
                            modifier3 = modifier2;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if (i6 != 0) {
                            function6 = NoOpUpdate;
                        }
                        if (i8 != 0) {
                            function7 = NoOpUpdate;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                        }
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                        CompositionLocal localDensity16 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111111 = composerStartRestartGroup.consume(localDensity16);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume1111111;
                        CompositionLocal localLayoutDirection16 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111112 = composerStartRestartGroup.consume(localLayoutDirection16);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        layoutDirection = (LayoutDirection) objConsume1111112;
                        currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        CompositionLocal localLifecycleOwner16 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111113 = composerStartRestartGroup.consume(localLifecycleOwner16);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        lifecycleOwner = (LifecycleOwner) objConsume1111113;
                        CompositionLocal localSavedStateRegistryOwner16 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111114 = composerStartRestartGroup.consume(localSavedStateRegistryOwner16);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume1111114;
                        if (function5 != null) {
                            composerStartRestartGroup.startReplaceGroup(607871394);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                            function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startReusableNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer1112 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer1112, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer1112, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function18) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function18);
                                }
                            });
                            Updater.set-impl(composer1112, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function18) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function18);
                                }
                            });
                            Updater.set-impl(composer1112, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function18) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function18);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(608726777);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                            function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer1113 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer1113, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer1113, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function18) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function18);
                                }
                            });
                            Updater.set-impl(composer1113, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function18) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function18);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    } else {
                        if (i10 != 0) {
                            modifier3 = (Modifier) Modifier.Companion;
                        } else {
                            modifier3 = modifier2;
                        }
                        if (i4 != 0) {
                            function5 = null;
                        }
                        if (i6 != 0) {
                            function6 = NoOpUpdate;
                        }
                        if (i8 != 0) {
                            function7 = NoOpUpdate;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                        }
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                        CompositionLocal localDensity17 = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111115 = composerStartRestartGroup.consume(localDensity17);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume1111115;
                        CompositionLocal localLayoutDirection17 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111116 = composerStartRestartGroup.consume(localLayoutDirection17);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        layoutDirection = (LayoutDirection) objConsume1111116;
                        currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        CompositionLocal localLifecycleOwner17 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111117 = composerStartRestartGroup.consume(localLifecycleOwner17);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        lifecycleOwner = (LifecycleOwner) objConsume1111117;
                        CompositionLocal localSavedStateRegistryOwner17 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111118 = composerStartRestartGroup.consume(localSavedStateRegistryOwner17);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume1111118;
                        if (function5 != null) {
                            composerStartRestartGroup.startReplaceGroup(607871394);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                            function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startReusableNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer1114 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer1114, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer1114, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function18) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function18);
                                }
                            });
                            Updater.set-impl(composer1114, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function18) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function18);
                                }
                            });
                            Updater.set-impl(composer1114, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function18) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function18);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        } else {
                            composerStartRestartGroup.startReplaceGroup(608726777);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                            function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            Composer composer1115 = Updater.constructor-impl(composerStartRestartGroup);
                            m2098updateViewHolderParams6NefGtU(composer1115, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                            Updater.set-impl(composer1115, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function18) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function18);
                                }
                            });
                            Updater.set-impl(composer1115, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                                public Object invoke(Object obj, Object obj2) {
                                    invoke((LayoutNode) obj, (Function1) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function18) {
                                    AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function18);
                                }
                            });
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.endReplaceGroup();
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                    function8 = function5;
                    function9 = function7;
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier12 = modifier3;
                        final Function1<? super T, Unit> function18 = function6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer1116, int i11) {
                                AndroidView_androidKt.AndroidView(function1, modifier12, function8, function18, function9, composer1116, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                function7 = function4;
                if ((i3 & 9363) == 9362) {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity18 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1111119 = composerStartRestartGroup.consume(localDensity18);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume1111119;
                    CompositionLocal localLayoutDirection18 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111110 = composerStartRestartGroup.consume(localLayoutDirection18);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume11111110;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner18 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111111 = composerStartRestartGroup.consume(localLifecycleOwner18);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume11111111;
                    CompositionLocal localSavedStateRegistryOwner18 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111112 = composerStartRestartGroup.consume(localSavedStateRegistryOwner18);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume11111112;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer1116 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer1116, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer1116, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function19) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function19);
                            }
                        });
                        Updater.set-impl(composer1116, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function19) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function19);
                            }
                        });
                        Updater.set-impl(composer1116, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function19) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function19);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer1117 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer1117, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer1117, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function19) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function19);
                            }
                        });
                        Updater.set-impl(composer1117, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function19) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function19);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity19 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111113 = composerStartRestartGroup.consume(localDensity19);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume11111113;
                    CompositionLocal localLayoutDirection19 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111114 = composerStartRestartGroup.consume(localLayoutDirection19);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume11111114;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner19 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111115 = composerStartRestartGroup.consume(localLifecycleOwner19);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume11111115;
                    CompositionLocal localSavedStateRegistryOwner19 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111116 = composerStartRestartGroup.consume(localSavedStateRegistryOwner19);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume11111116;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer1118 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer1118, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer1118, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function19) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function19);
                            }
                        });
                        Updater.set-impl(composer1118, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function19) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function19);
                            }
                        });
                        Updater.set-impl(composer1118, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function19) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function19);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer1119 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer1119, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer1119, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function19) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function19);
                            }
                        });
                        Updater.set-impl(composer1119, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function19) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function19);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                function8 = function5;
                function9 = function7;
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier13 = modifier3;
                    final Function1<? super T, Unit> function19 = function6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer11110, int i11) {
                            AndroidView_androidKt.AndroidView(function1, modifier13, function8, function19, function9, composer11110, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            function6 = function3;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    function7 = function4;
                    if (composerStartRestartGroup.changedInstance(function7)) {
                        i9 = 16384;
                    } else {
                        i9 = 8192;
                    }
                    i3 |= i9;
                }
                if ((i3 & 9363) == 9362) {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity110 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111117 = composerStartRestartGroup.consume(localDensity110);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume11111117;
                    CompositionLocal localLayoutDirection110 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111118 = composerStartRestartGroup.consume(localLayoutDirection110);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume11111118;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner110 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111119 = composerStartRestartGroup.consume(localLifecycleOwner110);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume11111119;
                    CompositionLocal localSavedStateRegistryOwner110 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111110 = composerStartRestartGroup.consume(localSavedStateRegistryOwner110);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume111111110;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer11110 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer11110, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer11110, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function110) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function110);
                            }
                        });
                        Updater.set-impl(composer11110, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function110) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function110);
                            }
                        });
                        Updater.set-impl(composer11110, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function110) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function110);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer11111 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer11111, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer11111, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function110) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function110);
                            }
                        });
                        Updater.set-impl(composer11111, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function110) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function110);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity111 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111111 = composerStartRestartGroup.consume(localDensity111);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume111111111;
                    CompositionLocal localLayoutDirection111 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111112 = composerStartRestartGroup.consume(localLayoutDirection111);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume111111112;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner111 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111113 = composerStartRestartGroup.consume(localLifecycleOwner111);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume111111113;
                    CompositionLocal localSavedStateRegistryOwner111 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111114 = composerStartRestartGroup.consume(localSavedStateRegistryOwner111);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume111111114;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer11112 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer11112, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer11112, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function110) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function110);
                            }
                        });
                        Updater.set-impl(composer11112, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function110) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function110);
                            }
                        });
                        Updater.set-impl(composer11112, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function110) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function110);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer11113 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer11113, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer11113, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function110) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function110);
                            }
                        });
                        Updater.set-impl(composer11113, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function110) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function110);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                function8 = function5;
                function9 = function7;
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier14 = modifier3;
                    final Function1<? super T, Unit> function110 = function6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer11114, int i11) {
                            AndroidView_androidKt.AndroidView(function1, modifier14, function8, function110, function9, composer11114, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            function7 = function4;
            if ((i3 & 9363) == 9362) {
                if (i10 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if (i6 != 0) {
                    function6 = NoOpUpdate;
                }
                if (i8 != 0) {
                    function7 = NoOpUpdate;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                }
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                CompositionLocal localDensity112 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111115 = composerStartRestartGroup.consume(localDensity112);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume111111115;
                CompositionLocal localLayoutDirection112 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111116 = composerStartRestartGroup.consume(localLayoutDirection112);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                layoutDirection = (LayoutDirection) objConsume111111116;
                currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                CompositionLocal localLifecycleOwner112 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111117 = composerStartRestartGroup.consume(localLifecycleOwner112);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                lifecycleOwner = (LifecycleOwner) objConsume111111117;
                CompositionLocal localSavedStateRegistryOwner112 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111118 = composerStartRestartGroup.consume(localSavedStateRegistryOwner112);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume111111118;
                if (function5 != null) {
                    composerStartRestartGroup.startReplaceGroup(607871394);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                    function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer11114 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer11114, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer11114, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function111) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function111);
                        }
                    });
                    Updater.set-impl(composer11114, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function111) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function111);
                        }
                    });
                    Updater.set-impl(composer11114, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function111) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function111);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(608726777);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                    function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer11115 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer11115, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer11115, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function111) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function111);
                        }
                    });
                    Updater.set-impl(composer11115, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function111) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function111);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                if (i10 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if (i6 != 0) {
                    function6 = NoOpUpdate;
                }
                if (i8 != 0) {
                    function7 = NoOpUpdate;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                }
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                CompositionLocal localDensity113 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111119 = composerStartRestartGroup.consume(localDensity113);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume111111119;
                CompositionLocal localLayoutDirection113 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111110 = composerStartRestartGroup.consume(localLayoutDirection113);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                layoutDirection = (LayoutDirection) objConsume1111111110;
                currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                CompositionLocal localLifecycleOwner113 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111111 = composerStartRestartGroup.consume(localLifecycleOwner113);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                lifecycleOwner = (LifecycleOwner) objConsume1111111111;
                CompositionLocal localSavedStateRegistryOwner113 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111112 = composerStartRestartGroup.consume(localSavedStateRegistryOwner113);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume1111111112;
                if (function5 != null) {
                    composerStartRestartGroup.startReplaceGroup(607871394);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                    function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer11116 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer11116, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer11116, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function111) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function111);
                        }
                    });
                    Updater.set-impl(composer11116, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function111) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function111);
                        }
                    });
                    Updater.set-impl(composer11116, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function111) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function111);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(608726777);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                    function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer11117 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer11117, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer11117, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function111) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function111);
                        }
                    });
                    Updater.set-impl(composer11117, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function111) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function111);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            function8 = function5;
            function9 = function7;
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier15 = modifier3;
                final Function1<? super T, Unit> function111 = function6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer11118, int i11) {
                        AndroidView_androidKt.AndroidView(function1, modifier15, function8, function111, function9, composer11118, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        function5 = function2;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                function6 = function3;
                if (composerStartRestartGroup.changedInstance(function6)) {
                    i7 = 2048;
                } else {
                    i7 = 1024;
                }
                i3 |= i7;
            }
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    function7 = function4;
                    if (composerStartRestartGroup.changedInstance(function7)) {
                        i9 = 16384;
                    } else {
                        i9 = 8192;
                    }
                    i3 |= i9;
                }
                if ((i3 & 9363) == 9362) {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity114 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1111111113 = composerStartRestartGroup.consume(localDensity114);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume1111111113;
                    CompositionLocal localLayoutDirection114 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1111111114 = composerStartRestartGroup.consume(localLayoutDirection114);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume1111111114;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner114 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1111111115 = composerStartRestartGroup.consume(localLifecycleOwner114);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume1111111115;
                    CompositionLocal localSavedStateRegistryOwner114 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1111111116 = composerStartRestartGroup.consume(localSavedStateRegistryOwner114);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume1111111116;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer11118 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer11118, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer11118, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function112) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function112);
                            }
                        });
                        Updater.set-impl(composer11118, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function112) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function112);
                            }
                        });
                        Updater.set-impl(composer11118, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function112) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function112);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer11119 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer11119, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer11119, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function112) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function112);
                            }
                        });
                        Updater.set-impl(composer11119, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function112) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function112);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    if (i10 != 0) {
                        modifier3 = (Modifier) Modifier.Companion;
                    } else {
                        modifier3 = modifier2;
                    }
                    if (i4 != 0) {
                        function5 = null;
                    }
                    if (i6 != 0) {
                        function6 = NoOpUpdate;
                    }
                    if (i8 != 0) {
                        function7 = NoOpUpdate;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                    }
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                    CompositionLocal localDensity115 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1111111117 = composerStartRestartGroup.consume(localDensity115);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume1111111117;
                    CompositionLocal localLayoutDirection115 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1111111118 = composerStartRestartGroup.consume(localLayoutDirection115);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    layoutDirection = (LayoutDirection) objConsume1111111118;
                    currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    CompositionLocal localLifecycleOwner115 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1111111119 = composerStartRestartGroup.consume(localLifecycleOwner115);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    lifecycleOwner = (LifecycleOwner) objConsume1111111119;
                    CompositionLocal localSavedStateRegistryOwner115 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111111110 = composerStartRestartGroup.consume(localSavedStateRegistryOwner115);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume11111111110;
                    if (function5 != null) {
                        composerStartRestartGroup.startReplaceGroup(607871394);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                        function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer111110 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer111110, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer111110, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function112) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function112);
                            }
                        });
                        Updater.set-impl(composer111110, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function112) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function112);
                            }
                        });
                        Updater.set-impl(composer111110, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function112) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function112);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(608726777);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                        function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer111111 = Updater.constructor-impl(composerStartRestartGroup);
                        m2098updateViewHolderParams6NefGtU(composer111111, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                        Updater.set-impl(composer111111, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function112) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function112);
                            }
                        });
                        Updater.set-impl(composer111111, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                            public Object invoke(Object obj, Object obj2) {
                                invoke((LayoutNode) obj, (Function1) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function112) {
                                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function112);
                            }
                        });
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                function8 = function5;
                function9 = function7;
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier16 = modifier3;
                    final Function1<? super T, Unit> function112 = function6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer111112, int i11) {
                            AndroidView_androidKt.AndroidView(function1, modifier16, function8, function112, function9, composer111112, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            function7 = function4;
            if ((i3 & 9363) == 9362) {
                if (i10 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if (i6 != 0) {
                    function6 = NoOpUpdate;
                }
                if (i8 != 0) {
                    function7 = NoOpUpdate;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                }
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                CompositionLocal localDensity116 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111111 = composerStartRestartGroup.consume(localDensity116);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume11111111111;
                CompositionLocal localLayoutDirection116 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111112 = composerStartRestartGroup.consume(localLayoutDirection116);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                layoutDirection = (LayoutDirection) objConsume11111111112;
                currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                CompositionLocal localLifecycleOwner116 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111113 = composerStartRestartGroup.consume(localLifecycleOwner116);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                lifecycleOwner = (LifecycleOwner) objConsume11111111113;
                CompositionLocal localSavedStateRegistryOwner116 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111114 = composerStartRestartGroup.consume(localSavedStateRegistryOwner116);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume11111111114;
                if (function5 != null) {
                    composerStartRestartGroup.startReplaceGroup(607871394);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                    function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer111112 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer111112, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer111112, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function113) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function113);
                        }
                    });
                    Updater.set-impl(composer111112, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function113) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function113);
                        }
                    });
                    Updater.set-impl(composer111112, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function113) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function113);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(608726777);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                    function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer111113 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer111113, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer111113, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function113) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function113);
                        }
                    });
                    Updater.set-impl(composer111113, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function113) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function113);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                if (i10 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if (i6 != 0) {
                    function6 = NoOpUpdate;
                }
                if (i8 != 0) {
                    function7 = NoOpUpdate;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                }
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                CompositionLocal localDensity117 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111115 = composerStartRestartGroup.consume(localDensity117);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume11111111115;
                CompositionLocal localLayoutDirection117 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111116 = composerStartRestartGroup.consume(localLayoutDirection117);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                layoutDirection = (LayoutDirection) objConsume11111111116;
                currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                CompositionLocal localLifecycleOwner117 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111117 = composerStartRestartGroup.consume(localLifecycleOwner117);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                lifecycleOwner = (LifecycleOwner) objConsume11111111117;
                CompositionLocal localSavedStateRegistryOwner117 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111118 = composerStartRestartGroup.consume(localSavedStateRegistryOwner117);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume11111111118;
                if (function5 != null) {
                    composerStartRestartGroup.startReplaceGroup(607871394);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                    function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer111114 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer111114, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer111114, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function113) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function113);
                        }
                    });
                    Updater.set-impl(composer111114, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function113) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function113);
                        }
                    });
                    Updater.set-impl(composer111114, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function113) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function113);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(608726777);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                    function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer111115 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer111115, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer111115, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function113) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function113);
                        }
                    });
                    Updater.set-impl(composer111115, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function113) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function113);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            function8 = function5;
            function9 = function7;
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier17 = modifier3;
                final Function1<? super T, Unit> function113 = function6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer111116, int i11) {
                        AndroidView_androidKt.AndroidView(function1, modifier17, function8, function113, function9, composer111116, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        function6 = function3;
        i8 = i2 & 16;
        if (i8 != 0) {
            if ((i & 24576) == 0) {
                function7 = function4;
                if (composerStartRestartGroup.changedInstance(function7)) {
                    i9 = 16384;
                } else {
                    i9 = 8192;
                }
                i3 |= i9;
            }
            if ((i3 & 9363) == 9362) {
                if (i10 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if (i6 != 0) {
                    function6 = NoOpUpdate;
                }
                if (i8 != 0) {
                    function7 = NoOpUpdate;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                }
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                CompositionLocal localDensity118 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111119 = composerStartRestartGroup.consume(localDensity118);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume11111111119;
                CompositionLocal localLayoutDirection118 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111110 = composerStartRestartGroup.consume(localLayoutDirection118);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                layoutDirection = (LayoutDirection) objConsume111111111110;
                currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                CompositionLocal localLifecycleOwner118 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111111 = composerStartRestartGroup.consume(localLifecycleOwner118);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                lifecycleOwner = (LifecycleOwner) objConsume111111111111;
                CompositionLocal localSavedStateRegistryOwner118 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111112 = composerStartRestartGroup.consume(localSavedStateRegistryOwner118);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume111111111112;
                if (function5 != null) {
                    composerStartRestartGroup.startReplaceGroup(607871394);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                    function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer111116 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer111116, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer111116, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function114) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function114);
                        }
                    });
                    Updater.set-impl(composer111116, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function114) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function114);
                        }
                    });
                    Updater.set-impl(composer111116, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function114) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function114);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(608726777);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                    function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer111117 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer111117, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer111117, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function114) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function114);
                        }
                    });
                    Updater.set-impl(composer111117, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function114) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function114);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                if (i10 != 0) {
                    modifier3 = (Modifier) Modifier.Companion;
                } else {
                    modifier3 = modifier2;
                }
                if (i4 != 0) {
                    function5 = null;
                }
                if (i6 != 0) {
                    function6 = NoOpUpdate;
                }
                if (i8 != 0) {
                    function7 = NoOpUpdate;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
                }
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
                CompositionLocal localDensity119 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111113 = composerStartRestartGroup.consume(localDensity119);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume111111111113;
                CompositionLocal localLayoutDirection119 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111114 = composerStartRestartGroup.consume(localLayoutDirection119);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                layoutDirection = (LayoutDirection) objConsume111111111114;
                currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                CompositionLocal localLifecycleOwner119 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111115 = composerStartRestartGroup.consume(localLifecycleOwner119);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                lifecycleOwner = (LifecycleOwner) objConsume111111111115;
                CompositionLocal localSavedStateRegistryOwner119 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111116 = composerStartRestartGroup.consume(localSavedStateRegistryOwner119);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume111111111116;
                if (function5 != null) {
                    composerStartRestartGroup.startReplaceGroup(607871394);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                    function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer111118 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer111118, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer111118, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function114) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function114);
                        }
                    });
                    Updater.set-impl(composer111118, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function114) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function114);
                        }
                    });
                    Updater.set-impl(composer111118, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function114) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function114);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(608726777);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                    function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    Composer composer111119 = Updater.constructor-impl(composerStartRestartGroup);
                    m2098updateViewHolderParams6NefGtU(composer111119, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                    Updater.set-impl(composer111119, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function114) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function114);
                        }
                    });
                    Updater.set-impl(composer111119, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                        public Object invoke(Object obj, Object obj2) {
                            invoke((LayoutNode) obj, (Function1) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function114) {
                            AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function114);
                        }
                    });
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            function8 = function5;
            function9 = function7;
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier18 = modifier3;
                final Function1<? super T, Unit> function114 = function6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer1111110, int i11) {
                        AndroidView_androidKt.AndroidView(function1, modifier18, function8, function114, function9, composer1111110, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        function7 = function4;
        if ((i3 & 9363) == 9362) {
            if (i10 != 0) {
                modifier3 = (Modifier) Modifier.Companion;
            } else {
                modifier3 = modifier2;
            }
            if (i4 != 0) {
                function5 = null;
            }
            if (i6 != 0) {
                function6 = NoOpUpdate;
            }
            if (i8 != 0) {
                function7 = NoOpUpdate;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
            }
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
            CompositionLocal localDensity1110 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume111111111117 = composerStartRestartGroup.consume(localDensity1110);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            density = (Density) objConsume111111111117;
            CompositionLocal localLayoutDirection1110 = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume111111111118 = composerStartRestartGroup.consume(localLayoutDirection1110);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            layoutDirection = (LayoutDirection) objConsume111111111118;
            currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            CompositionLocal localLifecycleOwner1110 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume111111111119 = composerStartRestartGroup.consume(localLifecycleOwner1110);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            lifecycleOwner = (LifecycleOwner) objConsume111111111119;
            CompositionLocal localSavedStateRegistryOwner1110 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1111111111110 = composerStartRestartGroup.consume(localSavedStateRegistryOwner1110);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume1111111111110;
            if (function5 != null) {
                composerStartRestartGroup.startReplaceGroup(607871394);
                ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                } else {
                    composerStartRestartGroup.useNode();
                }
                Composer composer1111110 = Updater.constructor-impl(composerStartRestartGroup);
                m2098updateViewHolderParams6NefGtU(composer1111110, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                Updater.set-impl(composer1111110, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                    public Object invoke(Object obj, Object obj2) {
                        invoke((LayoutNode) obj, (Function1) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function115) {
                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function115);
                    }
                });
                Updater.set-impl(composer1111110, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                    public Object invoke(Object obj, Object obj2) {
                        invoke((LayoutNode) obj, (Function1) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function115) {
                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function115);
                    }
                });
                Updater.set-impl(composer1111110, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                    public Object invoke(Object obj, Object obj2) {
                        invoke((LayoutNode) obj, (Function1) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function115) {
                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function115);
                    }
                });
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(608726777);
                ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                } else {
                    composerStartRestartGroup.useNode();
                }
                Composer composer1111111 = Updater.constructor-impl(composerStartRestartGroup);
                m2098updateViewHolderParams6NefGtU(composer1111111, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                Updater.set-impl(composer1111111, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                    public Object invoke(Object obj, Object obj2) {
                        invoke((LayoutNode) obj, (Function1) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function115) {
                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function115);
                    }
                });
                Updater.set-impl(composer1111111, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                    public Object invoke(Object obj, Object obj2) {
                        invoke((LayoutNode) obj, (Function1) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function115) {
                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function115);
                    }
                });
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endReplaceGroup();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            if (i10 != 0) {
                modifier3 = (Modifier) Modifier.Companion;
            } else {
                modifier3 = modifier2;
            }
            if (i4 != 0) {
                function5 = null;
            }
            if (i6 != 0) {
                function6 = NoOpUpdate;
            }
            if (i8 != 0) {
                function7 = NoOpUpdate;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-180024211, i3, -1, "androidx.compose.ui.viewinterop.AndroidView (AndroidView.android.kt:211)");
            }
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, FocusGroupNode_androidKt.focusInteropModifier(modifier3));
            CompositionLocal localDensity1111 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1111111111111 = composerStartRestartGroup.consume(localDensity1111);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            density = (Density) objConsume1111111111111;
            CompositionLocal localLayoutDirection1111 = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1111111111112 = composerStartRestartGroup.consume(localLayoutDirection1111);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            layoutDirection = (LayoutDirection) objConsume1111111111112;
            currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            CompositionLocal localLifecycleOwner1111 = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1111111111113 = composerStartRestartGroup.consume(localLifecycleOwner1111);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            lifecycleOwner = (LifecycleOwner) objConsume1111111111113;
            CompositionLocal localSavedStateRegistryOwner1111 = AndroidCompositionLocals_androidKt.getLocalSavedStateRegistryOwner();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1111111111114 = composerStartRestartGroup.consume(localSavedStateRegistryOwner1111);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            savedStateRegistryOwner = (SavedStateRegistryOwner) objConsume1111111111114;
            if (function5 != null) {
                composerStartRestartGroup.startReplaceGroup(607871394);
                ComposerKt.sourceInformation(composerStartRestartGroup, "227@12792L37,226@12726L843");
                function0CreateAndroidViewNodeFactory2 = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1405779621, "CC(ReusableComposeNode):Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory2);
                } else {
                    composerStartRestartGroup.useNode();
                }
                Composer composer1111112 = Updater.constructor-impl(composerStartRestartGroup);
                m2098updateViewHolderParams6NefGtU(composer1111112, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                Updater.set-impl(composer1111112, function5, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                    public Object invoke(Object obj, Object obj2) {
                        invoke((LayoutNode) obj, (Function1) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function115) {
                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setResetBlock(function115);
                    }
                });
                Updater.set-impl(composer1111112, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                    public Object invoke(Object obj, Object obj2) {
                        invoke((LayoutNode) obj, (Function1) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function115) {
                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function115);
                    }
                });
                Updater.set-impl(composer1111112, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                    public Object invoke(Object obj, Object obj2) {
                        invoke((LayoutNode) obj, (Function1) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function115) {
                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function115);
                    }
                });
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(608726777);
                ComposerKt.sourceInformation(composerStartRestartGroup, "245@13649L37,244@13591L756");
                function0CreateAndroidViewNodeFactory = createAndroidViewNodeFactory(function1, composerStartRestartGroup, i3 & 14);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1886828752, "CC(ComposeNode):Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof UiApplier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(function0CreateAndroidViewNodeFactory);
                } else {
                    composerStartRestartGroup.useNode();
                }
                Composer composer1111113 = Updater.constructor-impl(composerStartRestartGroup);
                m2098updateViewHolderParams6NefGtU(composer1111113, modifierMaterializeModifier, currentCompositeKeyHash, density, lifecycleOwner, savedStateRegistryOwner, layoutDirection, currentCompositionLocalMap);
                Updater.set-impl(composer1111113, function7, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                    public Object invoke(Object obj, Object obj2) {
                        invoke((LayoutNode) obj, (Function1) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function115) {
                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setUpdateBlock(function115);
                    }
                });
                Updater.set-impl(composer1111113, function6, new Function2<LayoutNode, Function1<? super T, ? extends Unit>, Unit>() {
                    public Object invoke(Object obj, Object obj2) {
                        invoke((LayoutNode) obj, (Function1) obj2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(LayoutNode layoutNode, Function1<? super T, Unit> function115) {
                        AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setReleaseBlock(function115);
                    }
                });
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endReplaceGroup();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        function8 = function5;
        function9 = function7;
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier19 = modifier3;
            final Function1<? super T, Unit> function115 = function6;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer1111114, int i11) {
                    AndroidView_androidKt.AndroidView(function1, modifier19, function8, function115, function9, composer1111114, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    private static final <T extends View> Function0<LayoutNode> createAndroidViewNodeFactory(final Function1<? super Context, ? extends T> function1, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 2030558801, "C(createAndroidViewNodeFactory)267@14499L23,268@14554L7,269@14588L28,270@14668L7,271@14706L7,273@14726L297:AndroidView.android.kt#z33iqn");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(2030558801, i, -1, "androidx.compose.ui.viewinterop.createAndroidViewNodeFactory (AndroidView.android.kt:266)");
        }
        final int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer, 0);
        CompositionLocal localContext = AndroidCompositionLocals_androidKt.getLocalContext();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localContext);
        ComposerKt.sourceInformationMarkerEnd(composer);
        final Context context = (Context) objConsume;
        final CompositionContext compositionContextRememberCompositionContext = ComposablesKt.rememberCompositionContext(composer, 0);
        CompositionLocal localSaveableStateRegistry = SaveableStateRegistryKt.getLocalSaveableStateRegistry();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume2 = composer.consume(localSaveableStateRegistry);
        ComposerKt.sourceInformationMarkerEnd(composer);
        final SaveableStateRegistry saveableStateRegistry = (SaveableStateRegistry) objConsume2;
        CompositionLocal localView = AndroidCompositionLocals_androidKt.getLocalView();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume3 = composer.consume(localView);
        ComposerKt.sourceInformationMarkerEnd(composer);
        final View view = (View) objConsume3;
        ComposerKt.sourceInformationMarkerStart(composer, -1137327224, "CC(remember):AndroidView.android.kt#9igjgp");
        boolean zChangedInstance = composer.changedInstance(context) | ((((i & 14) ^ 6) > 4 && composer.changed(function1)) || (i & 6) == 4) | composer.changedInstance(compositionContextRememberCompositionContext) | composer.changedInstance(saveableStateRegistry) | composer.changed(currentCompositeKeyHash) | composer.changedInstance(view);
        Object objRememberedValue = composer.rememberedValue();
        if (zChangedInstance || objRememberedValue == Composer.Companion.getEmpty()) {
            objRememberedValue = (Function0) new Function0<LayoutNode>() {
                {
                    super(0);
                }

                public final LayoutNode m2099invoke() {
                    Context context2 = context;
                    Function1<Context, T> function2 = function1;
                    CompositionContext compositionContext = compositionContextRememberCompositionContext;
                    SaveableStateRegistry saveableStateRegistry2 = saveableStateRegistry;
                    int i2 = currentCompositeKeyHash;
                    Owner owner = view;
                    Intrinsics.checkNotNull(owner, "null cannot be cast to non-null type androidx.compose.ui.node.Owner");
                    return new ViewFactoryHolder(context2, function2, compositionContext, saveableStateRegistry2, i2, owner).getLayoutNode();
                }
            };
            composer.updateRememberedValue(objRememberedValue);
        }
        Function0<LayoutNode> function0 = (Function0) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return function0;
    }

    private static final <T extends View> void m2098updateViewHolderParams6NefGtU(Composer composer, Modifier modifier, int i, Density density, LifecycleOwner lifecycleOwner, SavedStateRegistryOwner savedStateRegistryOwner, LayoutDirection layoutDirection, CompositionLocalMap compositionLocalMap) {
        Updater.set-impl(composer, compositionLocalMap, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
        Updater.set-impl(composer, modifier, new Function2<LayoutNode, Modifier, Unit>() {
            public Object invoke(Object obj, Object obj2) {
                invoke((LayoutNode) obj, (Modifier) obj2);
                return Unit.INSTANCE;
            }

            public final void invoke(LayoutNode layoutNode, Modifier modifier2) {
                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setModifier(modifier2);
            }
        });
        Updater.set-impl(composer, density, new Function2<LayoutNode, Density, Unit>() {
            public Object invoke(Object obj, Object obj2) {
                invoke((LayoutNode) obj, (Density) obj2);
                return Unit.INSTANCE;
            }

            public final void invoke(LayoutNode layoutNode, Density density2) {
                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setDensity(density2);
            }
        });
        Updater.set-impl(composer, lifecycleOwner, new Function2<LayoutNode, LifecycleOwner, Unit>() {
            public Object invoke(Object obj, Object obj2) {
                invoke((LayoutNode) obj, (LifecycleOwner) obj2);
                return Unit.INSTANCE;
            }

            public final void invoke(LayoutNode layoutNode, LifecycleOwner lifecycleOwner2) {
                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setLifecycleOwner(lifecycleOwner2);
            }
        });
        Updater.set-impl(composer, savedStateRegistryOwner, new Function2<LayoutNode, SavedStateRegistryOwner, Unit>() {
            public Object invoke(Object obj, Object obj2) {
                invoke((LayoutNode) obj, (SavedStateRegistryOwner) obj2);
                return Unit.INSTANCE;
            }

            public final void invoke(LayoutNode layoutNode, SavedStateRegistryOwner savedStateRegistryOwner2) {
                AndroidView_androidKt.requireViewFactoryHolder(layoutNode).setSavedStateRegistryOwner(savedStateRegistryOwner2);
            }
        });
        Updater.set-impl(composer, layoutDirection, new Function2<LayoutNode, LayoutDirection, Unit>() {

            @Metadata(k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
            public class WhenMappings {
                public static final int[] $EnumSwitchMapping$0;

                static {
                    int[] iArr = new int[LayoutDirection.values().length];
                    try {
                        iArr[LayoutDirection.Ltr.ordinal()] = 1;
                    } catch (NoSuchFieldError unused) {
                    }
                    try {
                        iArr[LayoutDirection.Rtl.ordinal()] = 2;
                    } catch (NoSuchFieldError unused2) {
                    }
                    $EnumSwitchMapping$0 = iArr;
                }
            }

            public Object invoke(Object obj, Object obj2) throws NoWhenBranchMatchedException, KotlinNothingValueException {
                invoke((LayoutNode) obj, (LayoutDirection) obj2);
                return Unit.INSTANCE;
            }

            public final void invoke(LayoutNode layoutNode, LayoutDirection layoutDirection2) throws NoWhenBranchMatchedException, KotlinNothingValueException {
                ViewFactoryHolder viewFactoryHolderRequireViewFactoryHolder = AndroidView_androidKt.requireViewFactoryHolder(layoutNode);
                int i2 = WhenMappings.$EnumSwitchMapping$0[layoutDirection2.ordinal()];
                int i3 = 1;
                if (i2 == 1) {
                    i3 = 0;
                } else if (i2 != 2) {
                    throw new NoWhenBranchMatchedException();
                }
                viewFactoryHolderRequireViewFactoryHolder.setLayoutDirection(i3);
            }
        });
        Function2 setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
        if (composer.getInserting() || !Intrinsics.areEqual(composer.rememberedValue(), Integer.valueOf(i))) {
            composer.updateRememberedValue(Integer.valueOf(i));
            composer.apply(Integer.valueOf(i), setCompositeKeyHash);
        }
    }

    public static final <T extends View> ViewFactoryHolder<T> requireViewFactoryHolder(LayoutNode layoutNode) throws KotlinNothingValueException {
        AndroidViewHolder interopViewFactoryHolder$ui_release = layoutNode.getInteropViewFactoryHolder$ui_release();
        if (interopViewFactoryHolder$ui_release != null) {
            return (ViewFactoryHolder) interopViewFactoryHolder$ui_release;
        }
        InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("Required value was null.");
        throw new KotlinNothingValueException();
    }

    public static final Function1<View, Unit> getNoOpUpdate() {
        return NoOpUpdate;
    }
}
