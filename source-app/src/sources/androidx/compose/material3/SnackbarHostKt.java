package androidx.compose.material3;

import androidx.autofill.HintConstants;
import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimatableKt;
import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.EasingKt;
import androidx.compose.animation.core.TweenSpec;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsLayerModifierKt;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.platform.AccessibilityManager;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.p002ui.semantics.LiveRegionMode;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScope;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.State;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.util.ListUtilsKt;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000h\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\t\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a:\u0010\u0004\u001a\u00020\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\u0017\u0010\n\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00050\u000b¢\u0006\u0002\b\fH\u0003¢\u0006\u0002\u0010\r\u001a:\u0010\u000e\u001a\u00020\u00052\u0006\u0010\u000f\u001a\u00020\u00102\b\b\u0002\u0010\b\u001a\u00020\t2\u0019\b\u0002\u0010\u0011\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00050\u000b¢\u0006\u0002\b\fH\u0007¢\u0006\u0002\u0010\u0012\u001a9\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00150\u00142\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00150\u00172\u0006\u0010\u0018\u001a\u00020\u00192\u000e\b\u0002\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u00050\u001bH\u0003¢\u0006\u0002\u0010\u001c\u001a)\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\u00150\u00142\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00150\u00172\u0006\u0010\u0018\u001a\u00020\u0019H\u0003¢\u0006\u0002\u0010\u001e\u001a\u001e\u0010\u001f\u001a\u00020 *\u00020!2\u0006\u0010\"\u001a\u00020\u00192\b\u0010#\u001a\u0004\u0018\u00010$H\u0000\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0002\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0003\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000*b\b\u0002\u0010%\"-\u0012\u001e\u0012\u001c\u0012\u0004\u0012\u00020\u00050\u001b¢\u0006\u0002\b\f¢\u0006\f\b&\u0012\b\b'\u0012\u0004\b\b(\n\u0012\u0004\u0012\u00020\u00050\u000b¢\u0006\u0002\b\f2-\u0012\u001e\u0012\u001c\u0012\u0004\u0012\u00020\u00050\u001b¢\u0006\u0002\b\f¢\u0006\f\b&\u0012\b\b'\u0012\u0004\b\b(\n\u0012\u0004\u0012\u00020\u00050\u000b¢\u0006\u0002\b\f¨\u0006("}, d2 = {"SnackbarFadeInMillis", "", "SnackbarFadeOutMillis", "SnackbarInBetweenDelayMillis", "FadeInFadeOutWithScale", "", "current", "Landroidx/compose/material3/SnackbarData;", "modifier", "Landroidx/compose/ui/Modifier;", "content", "Lkotlin/Function1;", "Landroidx/compose/runtime/Composable;", "(Landroidx/compose/material3/SnackbarData;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "SnackbarHost", "hostState", "Landroidx/compose/material3/SnackbarHostState;", "snackbar", "(Landroidx/compose/material3/SnackbarHostState;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "animatedOpacity", "Landroidx/compose/runtime/State;", "", "animation", "Landroidx/compose/animation/core/AnimationSpec;", "visible", "", "onAnimationFinish", "Lkotlin/Function0;", "(Landroidx/compose/animation/core/AnimationSpec;ZLkotlin/jvm/functions/Function0;Landroidx/compose/runtime/Composer;II)Landroidx/compose/runtime/State;", "animatedScale", "(Landroidx/compose/animation/core/AnimationSpec;ZLandroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/State;", "toMillis", "", "Landroidx/compose/material3/SnackbarDuration;", "hasAction", "accessibilityManager", "Landroidx/compose/ui/platform/AccessibilityManager;", "FadeInFadeOutTransition", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SnackbarHostKt {
    private static final int SnackbarFadeInMillis = 150;
    private static final int SnackbarFadeOutMillis = 75;
    private static final int SnackbarInBetweenDelayMillis = 0;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[SnackbarDuration.values().length];
            try {
                iArr[SnackbarDuration.Indefinite.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[SnackbarDuration.Long.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[SnackbarDuration.Short.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final void SnackbarHost(final SnackbarHostState snackbarHostState, Modifier modifier, Function3<? super SnackbarData, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(464178177);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(SnackbarHost)223@9468L7,224@9516L348,224@9480L384,235@9869L134:SnackbarHost.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(snackbarHostState) ? 4 : 2) | i;
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
            i3 |= composerStartRestartGroup.changedInstance(function3) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i3 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
            if (i4 != 0) {
                modifier = Modifier.INSTANCE;
            }
            if (i5 != 0) {
                function3 = ComposableSingletons$SnackbarHostKt.INSTANCE.m2226getLambda1$material3_release();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(464178177, i3, -1, "androidx.compose.material3.SnackbarHost (SnackbarHost.kt:221)");
            }
            SnackbarData currentSnackbarData = snackbarHostState.getCurrentSnackbarData();
            ProvidableCompositionLocal<AccessibilityManager> localAccessibilityManager = CompositionLocalsKt.getLocalAccessibilityManager();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composerStartRestartGroup.consume(localAccessibilityManager);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            AccessibilityManager accessibilityManager = (AccessibilityManager) objConsume;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -487334772, "CC(remember):SnackbarHost.kt#9igjgp");
            boolean zChanged = composerStartRestartGroup.changed(currentSnackbarData) | composerStartRestartGroup.changedInstance(accessibilityManager);
            SnackbarHostKt$SnackbarHost$1$1 snackbarHostKt$SnackbarHost$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (zChanged || snackbarHostKt$SnackbarHost$1$1RememberedValue == Composer.INSTANCE.getEmpty()) {
                snackbarHostKt$SnackbarHost$1$1RememberedValue = new SnackbarHostKt$SnackbarHost$1$1(currentSnackbarData, accessibilityManager, null);
                composerStartRestartGroup.updateRememberedValue(snackbarHostKt$SnackbarHost$1$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            EffectsKt.LaunchedEffect(currentSnackbarData, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) snackbarHostKt$SnackbarHost$1$1RememberedValue, composerStartRestartGroup, 0);
            FadeInFadeOutWithScale(snackbarHostState.getCurrentSnackbarData(), modifier, function3, composerStartRestartGroup, i3 & 1008, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        final Modifier modifier2 = modifier;
        final Function3<? super SnackbarData, ? super Composer, ? super Integer, Unit> function4 = function3;
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
                    SnackbarHostKt.SnackbarHost(snackbarHostState, modifier2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final long toMillis(SnackbarDuration snackbarDuration, boolean z, AccessibilityManager accessibilityManager) throws NoWhenBranchMatchedException {
        long j;
        int i = WhenMappings.$EnumSwitchMapping$0[snackbarDuration.ordinal()];
        if (i == 1) {
            j = Long.MAX_VALUE;
        } else if (i == 2) {
            j = 10000;
        } else {
            if (i != 3) {
                throw new NoWhenBranchMatchedException();
            }
            j = 4000;
        }
        long j2 = j;
        return accessibilityManager == null ? j2 : accessibilityManager.calculateRecommendedTimeoutMillis(j2, true, true, z);
    }

    public static final void FadeInFadeOutWithScale(final SnackbarData snackbarData, Modifier modifier, final Function3<? super SnackbarData, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        Modifier.Companion companion;
        Object objRememberedValue;
        final FadeInFadeOutState fadeInFadeOutState;
        int currentCompositeKeyHash;
        Function0<ComposeUiNode> constructor;
        Composer composerM4037constructorimpl;
        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash;
        List items;
        int size;
        int i5;
        List items2;
        ArrayList arrayList;
        int size2;
        int i6;
        final List mutableList;
        List listFastFilterNotNull;
        List items3;
        int size3;
        int i7;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        final SnackbarData snackbarData2 = snackbarData;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1316639904);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(FadeInFadeOutWithScale)P(1,2)328@12730L48,393@15387L162:SnackbarHost.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(snackbarData2) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i8 = i2 & 2;
        if (i8 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i2 & 4) != 0) {
                i3 |= 384;
            } else if ((i & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i4 = Fields.RotationX;
                } else {
                    i4 = Fields.SpotShadowColor;
                }
                i3 |= i4;
            }
            if ((i3 & 147) == 146 || !composerStartRestartGroup.getSkipping()) {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1316639904, i3, -1, "androidx.compose.material3.FadeInFadeOutWithScale (SnackbarHost.kt:327)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1256815738, "CC(remember):SnackbarHost.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new FadeInFadeOutState();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                fadeInFadeOutState = (FadeInFadeOutState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.startReplaceGroup(-1256811491);
                ComposerKt.sourceInformation(composerStartRestartGroup, "*337@13129L2237");
                if (!Intrinsics.areEqual(snackbarData2, fadeInFadeOutState.getCurrent())) {
                    fadeInFadeOutState.setCurrent(snackbarData2);
                    items2 = fadeInFadeOutState.getItems();
                    arrayList = new ArrayList(items2.size());
                    size2 = items2.size();
                    for (i6 = 0; i6 < size2; i6++) {
                        arrayList.add((SnackbarData) ((FadeInFadeOutAnimationItem) items2.get(i6)).getKey());
                    }
                    mutableList = CollectionsKt.toMutableList(arrayList);
                    if (!mutableList.contains(snackbarData2)) {
                        mutableList.add(snackbarData2);
                    }
                    fadeInFadeOutState.getItems().clear();
                    listFastFilterNotNull = ListUtilsKt.fastFilterNotNull(mutableList);
                    items3 = fadeInFadeOutState.getItems();
                    size3 = listFastFilterNotNull.size();
                    i7 = 0;
                    while (i7 < size3) {
                        final SnackbarData snackbarData3 = (SnackbarData) listFastFilterNotNull.get(i7);
                        items3.add(new FadeInFadeOutAnimationItem(snackbarData3, ComposableLambdaKt.rememberComposableLambda(-1654683077, true, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Function2<? super Composer, ? super Integer, Unit> function2, Composer composer2, int i9) {
                                int i10;
                                ComposerKt.sourceInformation(composer2, "C356@14017L313,348@13634L718,365@14401L364,380@15042L241,374@14782L570:SnackbarHost.kt#uh7d8r");
                                if ((i9 & 6) == 0) {
                                    i10 = i9 | (composer2.changedInstance(function2) ? 4 : 2);
                                } else {
                                    i10 = i9;
                                }
                                if ((i10 & 19) != 18 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1654683077, i10, -1, "androidx.compose.material3.FadeInFadeOutWithScale.<anonymous>.<anonymous> (SnackbarHost.kt:338)");
                                    }
                                    boolean zAreEqual = Intrinsics.areEqual(snackbarData3, snackbarData2);
                                    int i11 = zAreEqual ? 150 : 75;
                                    int i12 = (!zAreEqual || ListUtilsKt.fastFilterNotNull(mutableList).size() == 1) ? 0 : 75;
                                    TweenSpec tweenSpecTween = AnimationSpecKt.tween(i11, i12, EasingKt.getLinearEasing());
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1201029357, "CC(remember):SnackbarHost.kt#9igjgp");
                                    boolean zChanged = composer2.changed(snackbarData3) | composer2.changedInstance(fadeInFadeOutState);
                                    final SnackbarData snackbarData4 = snackbarData3;
                                    final FadeInFadeOutState<SnackbarData> fadeInFadeOutState2 = fadeInFadeOutState;
                                    Object objRememberedValue2 = composer2.rememberedValue();
                                    if (zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue2 = (Function0) new Function0<Unit>() {
                                            {
                                                super(0);
                                            }

                                            public Object invoke() {
                                                m2847invoke();
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2847invoke() {
                                                if (Intrinsics.areEqual(snackbarData4, fadeInFadeOutState2.getCurrent())) {
                                                    return;
                                                }
                                                List<FadeInFadeOutAnimationItem<SnackbarData>> items4 = fadeInFadeOutState2.getItems();
                                                final SnackbarData snackbarData5 = snackbarData4;
                                                CollectionsKt.removeAll(items4, new Function1<FadeInFadeOutAnimationItem<SnackbarData>, Boolean>() {
                                                    {
                                                        super(1);
                                                    }

                                                    public final Boolean invoke(FadeInFadeOutAnimationItem<SnackbarData> fadeInFadeOutAnimationItem) {
                                                        return Boolean.valueOf(Intrinsics.areEqual(fadeInFadeOutAnimationItem.getKey(), snackbarData5));
                                                    }
                                                });
                                                RecomposeScope scope = fadeInFadeOutState2.getScope();
                                                if (scope != null) {
                                                    scope.invalidate();
                                                }
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue2);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    State stateAnimatedOpacity = SnackbarHostKt.animatedOpacity(tweenSpecTween, zAreEqual, (Function0) objRememberedValue2, composer2, 0, 0);
                                    State stateAnimatedScale = SnackbarHostKt.animatedScale(AnimationSpecKt.tween(i11, i12, EasingKt.getFastOutSlowInEasing()), zAreEqual, composer2, 0);
                                    Modifier modifierM4751graphicsLayerAp8cVGQ$default = GraphicsLayerModifierKt.m4751graphicsLayerAp8cVGQ$default(Modifier.INSTANCE, ((Number) stateAnimatedScale.getValue()).floatValue(), ((Number) stateAnimatedScale.getValue()).floatValue(), ((Number) stateAnimatedOpacity.getValue()).floatValue(), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0L, null, false, null, 0L, 0L, 0, 131064, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1201062085, "CC(remember):SnackbarHost.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(snackbarData3);
                                    final SnackbarData snackbarData5 = snackbarData3;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                SemanticsPropertiesKt.m6629setLiveRegionhR3wRGc(semanticsPropertyReceiver, LiveRegionMode.INSTANCE.m6603getPolite0phEisY());
                                                final SnackbarData snackbarData6 = snackbarData5;
                                                SemanticsPropertiesKt.dismiss$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                                    {
                                                        super(0);
                                                    }

                                                    public final Boolean m2846invoke() {
                                                        snackbarData6.dismiss();
                                                        return true;
                                                    }
                                                }, 1, null);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(modifierM4751graphicsLayerAp8cVGQ$default, false, (Function1) objRememberedValue3, 1, null);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierSemantics$default);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer2.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer2.startReusableNode();
                                    if (composer2.getInserting()) {
                                        composer2.createNode(constructor2);
                                    } else {
                                        composer2.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer2, -514884474, "C388@15324L10:SnackbarHost.kt#uh7d8r");
                                    function2.invoke(composer2, Integer.valueOf(i10 & 14));
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
                        }, composerStartRestartGroup, 54)));
                        i7++;
                        snackbarData2 = snackbarData;
                    }
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1643979990, "C394@15425L21:SnackbarHost.kt#uh7d8r");
                fadeInFadeOutState.setScope(ComposablesKt.getCurrentRecomposeScope(composerStartRestartGroup, 0));
                composerStartRestartGroup.startReplaceGroup(1748085441);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                items = fadeInFadeOutState.getItems();
                size = items.size();
                for (i5 = 0; i5 < size; i5++) {
                    FadeInFadeOutAnimationItem fadeInFadeOutAnimationItem = (FadeInFadeOutAnimationItem) items.get(i5);
                    final SnackbarData snackbarData4 = (SnackbarData) fadeInFadeOutAnimationItem.component1();
                    Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> function3Component2 = fadeInFadeOutAnimationItem.component2();
                    composerStartRestartGroup.startMovableGroup(1201076541, snackbarData4);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "395@15520L19,395@15512L27");
                    function3Component2.invoke(ComposableLambdaKt.rememberComposableLambda(-1135367807, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i9) {
                            ComposerKt.sourceInformation(composer2, "C395@15522L15:SnackbarHost.kt#uh7d8r");
                            if ((i9 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1135367807, i9, -1, "androidx.compose.material3.FadeInFadeOutWithScale.<anonymous>.<anonymous>.<anonymous>.<anonymous> (SnackbarHost.kt:395)");
                            }
                            Function3<SnackbarData, Composer, Integer, Unit> function4 = function3;
                            SnackbarData snackbarData5 = snackbarData4;
                            Intrinsics.checkNotNull(snackbarData5);
                            function4.invoke(snackbarData5, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, 6);
                    composerStartRestartGroup.endMovableGroup();
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                companion = modifier2;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier3 = companion;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i9) {
                        SnackbarHostKt.FadeInFadeOutWithScale(snackbarData, modifier3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i4 = Fields.RotationX;
            } else {
                i4 = Fields.SpotShadowColor;
            }
            i3 |= i4;
        }
        if ((i3 & 147) == 146) {
            if (i8 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1316639904, i3, -1, "androidx.compose.material3.FadeInFadeOutWithScale (SnackbarHost.kt:327)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1256815738, "CC(remember):SnackbarHost.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new FadeInFadeOutState();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            fadeInFadeOutState = (FadeInFadeOutState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.startReplaceGroup(-1256811491);
            ComposerKt.sourceInformation(composerStartRestartGroup, "*337@13129L2237");
            if (!Intrinsics.areEqual(snackbarData2, fadeInFadeOutState.getCurrent())) {
                fadeInFadeOutState.setCurrent(snackbarData2);
                items2 = fadeInFadeOutState.getItems();
                arrayList = new ArrayList(items2.size());
                size2 = items2.size();
                while (i6 < size2) {
                    arrayList.add((SnackbarData) ((FadeInFadeOutAnimationItem) items2.get(i6)).getKey());
                }
                mutableList = CollectionsKt.toMutableList(arrayList);
                if (!mutableList.contains(snackbarData2)) {
                    mutableList.add(snackbarData2);
                }
                fadeInFadeOutState.getItems().clear();
                listFastFilterNotNull = ListUtilsKt.fastFilterNotNull(mutableList);
                items3 = fadeInFadeOutState.getItems();
                size3 = listFastFilterNotNull.size();
                i7 = 0;
                while (i7 < size3) {
                    final SnackbarData snackbarData5 = (SnackbarData) listFastFilterNotNull.get(i7);
                    items3.add(new FadeInFadeOutAnimationItem(snackbarData5, ComposableLambdaKt.rememberComposableLambda(-1654683077, true, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Function2<? super Composer, ? super Integer, Unit> function2, Composer composer2, int i9) {
                            int i10;
                            ComposerKt.sourceInformation(composer2, "C356@14017L313,348@13634L718,365@14401L364,380@15042L241,374@14782L570:SnackbarHost.kt#uh7d8r");
                            if ((i9 & 6) == 0) {
                                i10 = i9 | (composer2.changedInstance(function2) ? 4 : 2);
                            } else {
                                i10 = i9;
                            }
                            if ((i10 & 19) != 18 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1654683077, i10, -1, "androidx.compose.material3.FadeInFadeOutWithScale.<anonymous>.<anonymous> (SnackbarHost.kt:338)");
                                }
                                boolean zAreEqual = Intrinsics.areEqual(snackbarData5, snackbarData2);
                                int i11 = zAreEqual ? 150 : 75;
                                int i12 = (!zAreEqual || ListUtilsKt.fastFilterNotNull(mutableList).size() == 1) ? 0 : 75;
                                TweenSpec tweenSpecTween = AnimationSpecKt.tween(i11, i12, EasingKt.getLinearEasing());
                                ComposerKt.sourceInformationMarkerStart(composer2, 1201029357, "CC(remember):SnackbarHost.kt#9igjgp");
                                boolean zChanged = composer2.changed(snackbarData5) | composer2.changedInstance(fadeInFadeOutState);
                                final SnackbarData snackbarData6 = snackbarData5;
                                final FadeInFadeOutState<SnackbarData> fadeInFadeOutState2 = fadeInFadeOutState;
                                Object objRememberedValue2 = composer2.rememberedValue();
                                if (zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue2 = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2847invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2847invoke() {
                                            if (Intrinsics.areEqual(snackbarData6, fadeInFadeOutState2.getCurrent())) {
                                                return;
                                            }
                                            List<FadeInFadeOutAnimationItem<SnackbarData>> items4 = fadeInFadeOutState2.getItems();
                                            final SnackbarData snackbarData7 = snackbarData6;
                                            CollectionsKt.removeAll(items4, new Function1<FadeInFadeOutAnimationItem<SnackbarData>, Boolean>() {
                                                {
                                                    super(1);
                                                }

                                                public final Boolean invoke(FadeInFadeOutAnimationItem<SnackbarData> fadeInFadeOutAnimationItem2) {
                                                    return Boolean.valueOf(Intrinsics.areEqual(fadeInFadeOutAnimationItem2.getKey(), snackbarData7));
                                                }
                                            });
                                            RecomposeScope scope = fadeInFadeOutState2.getScope();
                                            if (scope != null) {
                                                scope.invalidate();
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue2);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                State stateAnimatedOpacity = SnackbarHostKt.animatedOpacity(tweenSpecTween, zAreEqual, (Function0) objRememberedValue2, composer2, 0, 0);
                                State stateAnimatedScale = SnackbarHostKt.animatedScale(AnimationSpecKt.tween(i11, i12, EasingKt.getFastOutSlowInEasing()), zAreEqual, composer2, 0);
                                Modifier modifierM4751graphicsLayerAp8cVGQ$default = GraphicsLayerModifierKt.m4751graphicsLayerAp8cVGQ$default(Modifier.INSTANCE, ((Number) stateAnimatedScale.getValue()).floatValue(), ((Number) stateAnimatedScale.getValue()).floatValue(), ((Number) stateAnimatedOpacity.getValue()).floatValue(), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0L, null, false, null, 0L, 0L, 0, 131064, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1201062085, "CC(remember):SnackbarHost.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(snackbarData5);
                                final SnackbarData snackbarData7 = snackbarData5;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            SemanticsPropertiesKt.m6629setLiveRegionhR3wRGc(semanticsPropertyReceiver, LiveRegionMode.INSTANCE.m6603getPolite0phEisY());
                                            final SnackbarData snackbarData8 = snackbarData7;
                                            SemanticsPropertiesKt.dismiss$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                                {
                                                    super(0);
                                                }

                                                public final Boolean m2846invoke() {
                                                    snackbarData8.dismiss();
                                                    return true;
                                                }
                                            }, 1, null);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(modifierM4751graphicsLayerAp8cVGQ$default, false, (Function1) objRememberedValue3, 1, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierSemantics$default);
                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor2);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -514884474, "C388@15324L10:SnackbarHost.kt#uh7d8r");
                                function2.invoke(composer2, Integer.valueOf(i10 & 14));
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
                    }, composerStartRestartGroup, 54)));
                    i7++;
                    snackbarData2 = snackbarData;
                }
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1643979990, "C394@15425L21:SnackbarHost.kt#uh7d8r");
            fadeInFadeOutState.setScope(ComposablesKt.getCurrentRecomposeScope(composerStartRestartGroup, 0));
            composerStartRestartGroup.startReplaceGroup(1748085441);
            ComposerKt.sourceInformation(composerStartRestartGroup, "");
            items = fadeInFadeOutState.getItems();
            size = items.size();
            while (i5 < size) {
                FadeInFadeOutAnimationItem fadeInFadeOutAnimationItem2 = (FadeInFadeOutAnimationItem) items.get(i5);
                final SnackbarData snackbarData6 = (SnackbarData) fadeInFadeOutAnimationItem2.component1();
                Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> function3Component3 = fadeInFadeOutAnimationItem2.component2();
                composerStartRestartGroup.startMovableGroup(1201076541, snackbarData6);
                ComposerKt.sourceInformation(composerStartRestartGroup, "395@15520L19,395@15512L27");
                function3Component3.invoke(ComposableLambdaKt.rememberComposableLambda(-1135367807, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i9) {
                        ComposerKt.sourceInformation(composer2, "C395@15522L15:SnackbarHost.kt#uh7d8r");
                        if ((i9 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1135367807, i9, -1, "androidx.compose.material3.FadeInFadeOutWithScale.<anonymous>.<anonymous>.<anonymous>.<anonymous> (SnackbarHost.kt:395)");
                        }
                        Function3<SnackbarData, Composer, Integer, Unit> function4 = function3;
                        SnackbarData snackbarData7 = snackbarData6;
                        Intrinsics.checkNotNull(snackbarData7);
                        function4.invoke(snackbarData7, composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, 6);
                composerStartRestartGroup.endMovableGroup();
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            if (i8 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1316639904, i3, -1, "androidx.compose.material3.FadeInFadeOutWithScale (SnackbarHost.kt:327)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1256815738, "CC(remember):SnackbarHost.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new FadeInFadeOutState();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            fadeInFadeOutState = (FadeInFadeOutState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.startReplaceGroup(-1256811491);
            ComposerKt.sourceInformation(composerStartRestartGroup, "*337@13129L2237");
            if (!Intrinsics.areEqual(snackbarData2, fadeInFadeOutState.getCurrent())) {
                fadeInFadeOutState.setCurrent(snackbarData2);
                items2 = fadeInFadeOutState.getItems();
                arrayList = new ArrayList(items2.size());
                size2 = items2.size();
                while (i6 < size2) {
                    arrayList.add((SnackbarData) ((FadeInFadeOutAnimationItem) items2.get(i6)).getKey());
                }
                mutableList = CollectionsKt.toMutableList(arrayList);
                if (!mutableList.contains(snackbarData2)) {
                    mutableList.add(snackbarData2);
                }
                fadeInFadeOutState.getItems().clear();
                listFastFilterNotNull = ListUtilsKt.fastFilterNotNull(mutableList);
                items3 = fadeInFadeOutState.getItems();
                size3 = listFastFilterNotNull.size();
                i7 = 0;
                while (i7 < size3) {
                    final SnackbarData snackbarData7 = (SnackbarData) listFastFilterNotNull.get(i7);
                    items3.add(new FadeInFadeOutAnimationItem(snackbarData7, ComposableLambdaKt.rememberComposableLambda(-1654683077, true, new Function3<Function2<? super Composer, ? super Integer, ? extends Unit>, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((Function2<? super Composer, ? super Integer, Unit>) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Function2<? super Composer, ? super Integer, Unit> function2, Composer composer2, int i9) {
                            int i10;
                            ComposerKt.sourceInformation(composer2, "C356@14017L313,348@13634L718,365@14401L364,380@15042L241,374@14782L570:SnackbarHost.kt#uh7d8r");
                            if ((i9 & 6) == 0) {
                                i10 = i9 | (composer2.changedInstance(function2) ? 4 : 2);
                            } else {
                                i10 = i9;
                            }
                            if ((i10 & 19) != 18 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1654683077, i10, -1, "androidx.compose.material3.FadeInFadeOutWithScale.<anonymous>.<anonymous> (SnackbarHost.kt:338)");
                                }
                                boolean zAreEqual = Intrinsics.areEqual(snackbarData7, snackbarData2);
                                int i11 = zAreEqual ? 150 : 75;
                                int i12 = (!zAreEqual || ListUtilsKt.fastFilterNotNull(mutableList).size() == 1) ? 0 : 75;
                                TweenSpec tweenSpecTween = AnimationSpecKt.tween(i11, i12, EasingKt.getLinearEasing());
                                ComposerKt.sourceInformationMarkerStart(composer2, 1201029357, "CC(remember):SnackbarHost.kt#9igjgp");
                                boolean zChanged = composer2.changed(snackbarData7) | composer2.changedInstance(fadeInFadeOutState);
                                final SnackbarData snackbarData8 = snackbarData7;
                                final FadeInFadeOutState<SnackbarData> fadeInFadeOutState2 = fadeInFadeOutState;
                                Object objRememberedValue2 = composer2.rememberedValue();
                                if (zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue2 = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2847invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2847invoke() {
                                            if (Intrinsics.areEqual(snackbarData8, fadeInFadeOutState2.getCurrent())) {
                                                return;
                                            }
                                            List<FadeInFadeOutAnimationItem<SnackbarData>> items4 = fadeInFadeOutState2.getItems();
                                            final SnackbarData snackbarData9 = snackbarData8;
                                            CollectionsKt.removeAll(items4, new Function1<FadeInFadeOutAnimationItem<SnackbarData>, Boolean>() {
                                                {
                                                    super(1);
                                                }

                                                public final Boolean invoke(FadeInFadeOutAnimationItem<SnackbarData> fadeInFadeOutAnimationItem3) {
                                                    return Boolean.valueOf(Intrinsics.areEqual(fadeInFadeOutAnimationItem3.getKey(), snackbarData9));
                                                }
                                            });
                                            RecomposeScope scope = fadeInFadeOutState2.getScope();
                                            if (scope != null) {
                                                scope.invalidate();
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue2);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                State stateAnimatedOpacity = SnackbarHostKt.animatedOpacity(tweenSpecTween, zAreEqual, (Function0) objRememberedValue2, composer2, 0, 0);
                                State stateAnimatedScale = SnackbarHostKt.animatedScale(AnimationSpecKt.tween(i11, i12, EasingKt.getFastOutSlowInEasing()), zAreEqual, composer2, 0);
                                Modifier modifierM4751graphicsLayerAp8cVGQ$default = GraphicsLayerModifierKt.m4751graphicsLayerAp8cVGQ$default(Modifier.INSTANCE, ((Number) stateAnimatedScale.getValue()).floatValue(), ((Number) stateAnimatedScale.getValue()).floatValue(), ((Number) stateAnimatedOpacity.getValue()).floatValue(), 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0L, null, false, null, 0L, 0L, 0, 131064, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1201062085, "CC(remember):SnackbarHost.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(snackbarData7);
                                final SnackbarData snackbarData9 = snackbarData7;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            SemanticsPropertiesKt.m6629setLiveRegionhR3wRGc(semanticsPropertyReceiver, LiveRegionMode.INSTANCE.m6603getPolite0phEisY());
                                            final SnackbarData snackbarData10 = snackbarData9;
                                            SemanticsPropertiesKt.dismiss$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                                                {
                                                    super(0);
                                                }

                                                public final Boolean m2846invoke() {
                                                    snackbarData10.dismiss();
                                                    return true;
                                                }
                                            }, 1, null);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(modifierM4751graphicsLayerAp8cVGQ$default, false, (Function1) objRememberedValue3, 1, null);
                                ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap3 = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composer2, modifierSemantics$default);
                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer2.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer2.startReusableNode();
                                if (composer2.getInserting()) {
                                    composer2.createNode(constructor2);
                                } else {
                                    composer2.useNode();
                                }
                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer2, -514884474, "C388@15324L10:SnackbarHost.kt#uh7d8r");
                                function2.invoke(composer2, Integer.valueOf(i10 & 14));
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
                    }, composerStartRestartGroup, 54)));
                    i7++;
                    snackbarData2 = snackbarData;
                }
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1643979990, "C394@15425L21:SnackbarHost.kt#uh7d8r");
            fadeInFadeOutState.setScope(ComposablesKt.getCurrentRecomposeScope(composerStartRestartGroup, 0));
            composerStartRestartGroup.startReplaceGroup(1748085441);
            ComposerKt.sourceInformation(composerStartRestartGroup, "");
            items = fadeInFadeOutState.getItems();
            size = items.size();
            while (i5 < size) {
                FadeInFadeOutAnimationItem fadeInFadeOutAnimationItem3 = (FadeInFadeOutAnimationItem) items.get(i5);
                final SnackbarData snackbarData8 = (SnackbarData) fadeInFadeOutAnimationItem3.component1();
                Function3<Function2<? super Composer, ? super Integer, Unit>, Composer, Integer, Unit> function3Component4 = fadeInFadeOutAnimationItem3.component2();
                composerStartRestartGroup.startMovableGroup(1201076541, snackbarData8);
                ComposerKt.sourceInformation(composerStartRestartGroup, "395@15520L19,395@15512L27");
                function3Component4.invoke(ComposableLambdaKt.rememberComposableLambda(-1135367807, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i9) {
                        ComposerKt.sourceInformation(composer2, "C395@15522L15:SnackbarHost.kt#uh7d8r");
                        if ((i9 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1135367807, i9, -1, "androidx.compose.material3.FadeInFadeOutWithScale.<anonymous>.<anonymous>.<anonymous>.<anonymous> (SnackbarHost.kt:395)");
                        }
                        Function3<SnackbarData, Composer, Integer, Unit> function4 = function3;
                        SnackbarData snackbarData9 = snackbarData8;
                        Intrinsics.checkNotNull(snackbarData9);
                        function4.invoke(snackbarData9, composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, 6);
                composerStartRestartGroup.endMovableGroup();
            }
            composerStartRestartGroup.endReplaceGroup();
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
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier4 = companion;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i9) {
                    SnackbarHostKt.FadeInFadeOutWithScale(snackbarData, modifier4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final State<Float> animatedOpacity(AnimationSpec<Float> animationSpec, boolean z, Function0<Unit> function0, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, 1431889134, "C(animatedOpacity)P(!1,2)419@16197L49,420@16275L111,420@16251L135:SnackbarHost.kt#uh7d8r");
        if ((i2 & 4) != 0) {
            function0 = new Function0<Unit>() {
                public final void m2848invoke() {
                }

                public Object invoke() {
                    m2848invoke();
                    return Unit.INSTANCE;
                }
            };
        }
        Function0<Unit> function1 = function0;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1431889134, i, -1, "androidx.compose.material3.animatedOpacity (SnackbarHost.kt:418)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 2104079446, "CC(remember):SnackbarHost.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = AnimatableKt.Animatable$default(!z ? 1.0f : 0.0f, 0.0f, 2, null);
            composer.updateRememberedValue(objRememberedValue);
        }
        Animatable animatable = (Animatable) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        Boolean boolValueOf = Boolean.valueOf(z);
        ComposerKt.sourceInformationMarkerStart(composer, 2104082004, "CC(remember):SnackbarHost.kt#9igjgp");
        boolean zChangedInstance = composer.changedInstance(animatable) | ((((i & 112) ^ 48) > 32 && composer.changed(z)) || (i & 48) == 32) | composer.changedInstance(animationSpec) | ((((i & 896) ^ 384) > 256 && composer.changed(function1)) || (i & 384) == 256);
        Object objRememberedValue2 = composer.rememberedValue();
        if (zChangedInstance || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue2 = (Function2) new SnackbarHostKt$animatedOpacity$2$1(animatable, z, animationSpec, function1, null);
            composer.updateRememberedValue(objRememberedValue2);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        EffectsKt.LaunchedEffect(boolValueOf, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue2, composer, (i >> 3) & 14);
        State<Float> stateAsState = animatable.asState();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateAsState;
    }

    public static final State<Float> animatedScale(AnimationSpec<Float> animationSpec, boolean z, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1966809761, "C(animatedScale)429@16538L51,430@16618L85,430@16594L109:SnackbarHost.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1966809761, i, -1, "androidx.compose.material3.animatedScale (SnackbarHost.kt:428)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 1433330423, "CC(remember):SnackbarHost.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = AnimatableKt.Animatable$default(!z ? 1.0f : 0.8f, 0.0f, 2, null);
            composer.updateRememberedValue(objRememberedValue);
        }
        Animatable animatable = (Animatable) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        Boolean boolValueOf = Boolean.valueOf(z);
        ComposerKt.sourceInformationMarkerStart(composer, 1433333017, "CC(remember):SnackbarHost.kt#9igjgp");
        boolean zChangedInstance = composer.changedInstance(animatable) | ((((i & 112) ^ 48) > 32 && composer.changed(z)) || (i & 48) == 32) | composer.changedInstance(animationSpec);
        Object objRememberedValue2 = composer.rememberedValue();
        if (zChangedInstance || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue2 = (Function2) new SnackbarHostKt$animatedScale$1$1(animatable, z, animationSpec, null);
            composer.updateRememberedValue(objRememberedValue2);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        EffectsKt.LaunchedEffect(boolValueOf, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue2, composer, (i >> 3) & 14);
        State<Float> stateAsState = animatable.asState();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateAsState;
    }
}
