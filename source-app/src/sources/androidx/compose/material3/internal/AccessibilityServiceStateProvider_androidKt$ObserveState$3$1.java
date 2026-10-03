package androidx.compose.material3.internal;

import androidx.compose.runtime.DisposableEffectResult;
import androidx.compose.runtime.DisposableEffectScope;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleEventObserver;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Lambda;

@Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\n¢\u0006\u0002\b\u0003"}, d2 = {"<anonymous>", "Landroidx/compose/runtime/DisposableEffectResult;", "Landroidx/compose/runtime/DisposableEffectScope;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 48)
final class AccessibilityServiceStateProvider_androidKt$ObserveState$3$1 extends Lambda implements Function1<DisposableEffectScope, DisposableEffectResult> {
    final Function1<Lifecycle.Event, Unit> $handleEvent;
    final LifecycleOwner $lifecycleOwner;
    final Function0<Unit> $onDispose;

    AccessibilityServiceStateProvider_androidKt$ObserveState$3$1(LifecycleOwner lifecycleOwner, Function1<? super Lifecycle.Event, Unit> function1, Function0<Unit> function0) {
        super(1);
        this.$lifecycleOwner = lifecycleOwner;
        this.$handleEvent = function1;
        this.$onDispose = function0;
    }

    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
        final Function1<Lifecycle.Event, Unit> function1 = this.$handleEvent;
        final LifecycleObserver lifecycleObserver = new LifecycleEventObserver() {
            public final void onStateChanged(LifecycleOwner lifecycleOwner, Lifecycle.Event event) {
                function1.invoke(event);
            }
        };
        this.$lifecycleOwner.getLifecycle().addObserver(lifecycleObserver);
        final Function0<Unit> function0 = this.$onDispose;
        final LifecycleOwner lifecycleOwner = this.$lifecycleOwner;
        return new DisposableEffectResult() {
            @Override
            public void dispose() {
                function0.invoke();
                lifecycleOwner.getLifecycle().removeObserver(lifecycleObserver);
            }
        };
    }
}
