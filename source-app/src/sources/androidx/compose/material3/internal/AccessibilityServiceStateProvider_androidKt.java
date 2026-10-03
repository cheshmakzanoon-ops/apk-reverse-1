package androidx.compose.material3.internal;

import android.content.Context;
import android.view.accessibility.AccessibilityManager;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.DisposableEffectResult;
import androidx.compose.runtime.DisposableEffectScope;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.State;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.compose.LocalLifecycleOwnerKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\u0004\u001a;\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0014\b\u0002\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00030\u00072\u000e\b\u0002\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00030\nH\u0003¢\u0006\u0002\u0010\u000b\u001a'\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r2\b\b\u0002\u0010\u000f\u001a\u00020\u000e2\b\b\u0002\u0010\u0010\u001a\u00020\u000eH\u0001¢\u0006\u0002\u0010\u0011\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0012"}, d2 = {"SwitchAccessActivityName", "", "ObserveState", "", "lifecycleOwner", "Landroidx/lifecycle/LifecycleOwner;", "handleEvent", "Lkotlin/Function1;", "Landroidx/lifecycle/Lifecycle$Event;", "onDispose", "Lkotlin/Function0;", "(Landroidx/lifecycle/LifecycleOwner;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function0;Landroidx/compose/runtime/Composer;II)V", "rememberAccessibilityServiceState", "Landroidx/compose/runtime/State;", "", "listenToTouchExplorationState", "listenToSwitchAccessState", "(ZZLandroidx/compose/runtime/Composer;II)Landroidx/compose/runtime/State;", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AccessibilityServiceStateProvider_androidKt {
    private static final String SwitchAccessActivityName = "SwitchAccess";

    public static final State<Boolean> rememberAccessibilityServiceState(boolean z, boolean z2, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -1771705152, "C(rememberAccessibilityServiceState)P(1)47@1997L7,52@2152L157,57@2374L7,58@2405L144,63@2571L45,56@2315L307:AccessibilityServiceStateProvider.android.kt#mqatfk");
        boolean z3 = true;
        if ((i2 & 1) != 0) {
            z = true;
        }
        if ((i2 & 2) != 0) {
            z2 = true;
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1771705152, i, -1, "androidx.compose.material3.internal.rememberAccessibilityServiceState (AccessibilityServiceStateProvider.android.kt:46)");
        }
        ProvidableCompositionLocal<Context> localContext = AndroidCompositionLocals_androidKt.getLocalContext();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localContext);
        ComposerKt.sourceInformationMarkerEnd(composer);
        Object systemService = ((Context) objConsume).getSystemService("accessibility");
        Intrinsics.checkNotNull(systemService, "null cannot be cast to non-null type android.view.accessibility.AccessibilityManager");
        final AccessibilityManager accessibilityManager = (AccessibilityManager) systemService;
        ComposerKt.sourceInformationMarkerStart(composer, 18334252, "CC(remember):AccessibilityServiceStateProvider.android.kt#9igjgp");
        boolean z4 = (((i & 14) ^ 6) > 4 && composer.changed(z)) || (i & 6) == 4;
        if ((((i & 112) ^ 48) <= 32 || !composer.changed(z2)) && (i & 48) != 32) {
            z3 = false;
        }
        boolean z5 = z4 | z3;
        Object objRememberedValue = composer.rememberedValue();
        if (z5 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new Listener(z, z2);
            composer.updateRememberedValue(objRememberedValue);
        }
        final Listener listener = (Listener) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        ProvidableCompositionLocal localLifecycleOwner = LocalLifecycleOwnerKt.getLocalLifecycleOwner();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume2 = composer.consume(localLifecycleOwner);
        ComposerKt.sourceInformationMarkerEnd(composer);
        LifecycleOwner lifecycleOwner = (LifecycleOwner) objConsume2;
        ComposerKt.sourceInformationMarkerStart(composer, 18342335, "CC(remember):AccessibilityServiceStateProvider.android.kt#9igjgp");
        boolean zChanged = composer.changed(listener) | composer.changedInstance(accessibilityManager);
        Object objRememberedValue2 = composer.rememberedValue();
        if (zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue2 = (Function1) new Function1<Lifecycle.Event, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((Lifecycle.Event) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(Lifecycle.Event event) {
                    if (event == Lifecycle.Event.ON_RESUME) {
                        listener.register(accessibilityManager);
                    }
                }
            };
            composer.updateRememberedValue(objRememberedValue2);
        }
        Function1 function1 = (Function1) objRememberedValue2;
        ComposerKt.sourceInformationMarkerEnd(composer);
        ComposerKt.sourceInformationMarkerStart(composer, 18347548, "CC(remember):AccessibilityServiceStateProvider.android.kt#9igjgp");
        boolean zChanged2 = composer.changed(listener) | composer.changedInstance(accessibilityManager);
        Object objRememberedValue3 = composer.rememberedValue();
        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue3 = (Function0) new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m3238invoke();
                    return Unit.INSTANCE;
                }

                public final void m3238invoke() {
                    listener.unregister(accessibilityManager);
                }
            };
            composer.updateRememberedValue(objRememberedValue3);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        ObserveState(lifecycleOwner, function1, (Function0) objRememberedValue3, composer, 0, 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return listener;
    }

    public static final void ObserveState(final LifecycleOwner lifecycleOwner, Function1<? super Lifecycle.Event, Unit> function1, Function0<Unit> function0, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1868327245);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ObserveState)P(1)75@2842L259,75@2809L292:AccessibilityServiceStateProvider.android.kt#mqatfk");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(lifecycleOwner) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i4 = i2 & 2;
        if (i4 != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function1) ? 32 : 16;
        }
        int i5 = i2 & 4;
        if (i5 != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function0) ? 256 : Fields.SpotShadowColor;
        }
        if ((i3 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
            if (i4 != 0) {
                function1 = new Function1<Lifecycle.Event, Unit>() {
                    public final void invoke(Lifecycle.Event event) {
                    }

                    public Object invoke(Object obj) {
                        invoke((Lifecycle.Event) obj);
                        return Unit.INSTANCE;
                    }
                };
            }
            if (i5 != 0) {
                function0 = new Function0<Unit>() {
                    public final void m3236invoke() {
                    }

                    public Object invoke() {
                        m3236invoke();
                        return Unit.INSTANCE;
                    }
                };
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1868327245, i3, -1, "androidx.compose.material3.internal.ObserveState (AccessibilityServiceStateProvider.android.kt:74)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1591666214, "CC(remember):AccessibilityServiceStateProvider.android.kt#9igjgp");
            boolean zChangedInstance = ((i3 & 112) == 32) | composerStartRestartGroup.changedInstance(lifecycleOwner) | ((i3 & 896) == 256);
            AccessibilityServiceStateProvider_androidKt$ObserveState$3$1 accessibilityServiceStateProvider_androidKt$ObserveState$3$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (zChangedInstance || accessibilityServiceStateProvider_androidKt$ObserveState$3$1RememberedValue == Composer.INSTANCE.getEmpty()) {
                accessibilityServiceStateProvider_androidKt$ObserveState$3$1RememberedValue = new AccessibilityServiceStateProvider_androidKt$ObserveState$3$1(lifecycleOwner, function1, function0);
                composerStartRestartGroup.updateRememberedValue(accessibilityServiceStateProvider_androidKt$ObserveState$3$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            EffectsKt.DisposableEffect(lifecycleOwner, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) accessibilityServiceStateProvider_androidKt$ObserveState$3$1RememberedValue, composerStartRestartGroup, i3 & 14);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        final Function1<? super Lifecycle.Event, Unit> function2 = function1;
        final Function0<Unit> function3 = function0;
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
                    AccessibilityServiceStateProvider_androidKt.ObserveState(lifecycleOwner, function2, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }
}
