package androidx.activity.compose;

import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.ActivityResultRegistry;
import androidx.activity.result.contract.ActivityResultContract;
import androidx.compose.runtime.DisposableEffectResult;
import androidx.compose.runtime.DisposableEffectScope;
import androidx.compose.runtime.State;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Lambda;

@Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0003*\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "Landroidx/compose/runtime/DisposableEffectResult;", "I", "O", "Landroidx/compose/runtime/DisposableEffectScope;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 48)
final class ActivityResultRegistryKt$rememberLauncherForActivityResult$1$1 extends Lambda implements Function1<DisposableEffectScope, DisposableEffectResult> {
    final ActivityResultRegistry $activityResultRegistry;
    final ActivityResultContract<I, O> $contract;
    final State<Function1<O, Unit>> $currentOnResult;
    final String $key;
    final ActivityResultLauncherHolder<I> $realLauncher;

    ActivityResultRegistryKt$rememberLauncherForActivityResult$1$1(ActivityResultLauncherHolder<I> activityResultLauncherHolder, ActivityResultRegistry activityResultRegistry, String str, ActivityResultContract<I, O> activityResultContract, State<? extends Function1<? super O, Unit>> state) {
        super(1);
        this.$realLauncher = activityResultLauncherHolder;
        this.$activityResultRegistry = activityResultRegistry;
        this.$key = str;
        this.$contract = activityResultContract;
        this.$currentOnResult = state;
    }

    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
        ActivityResultLauncherHolder<I> activityResultLauncherHolder = this.$realLauncher;
        ActivityResultRegistry activityResultRegistry = this.$activityResultRegistry;
        String str = this.$key;
        ActivityResultContract<I, O> activityResultContract = this.$contract;
        final State<Function1<O, Unit>> state = this.$currentOnResult;
        activityResultLauncherHolder.setLauncher((ActivityResultLauncher<I>) activityResultRegistry.register(str, activityResultContract, new ActivityResultCallback() {
            @Override
            public final void onActivityResult(Object obj) {
                ActivityResultRegistryKt$rememberLauncherForActivityResult$1$1.invoke$lambda$0(state, obj);
            }
        }));
        final ActivityResultLauncherHolder<I> activityResultLauncherHolder2 = this.$realLauncher;
        return new DisposableEffectResult() {
            @Override
            public void dispose() {
                activityResultLauncherHolder2.unregister();
            }
        };
    }

    public static final void invoke$lambda$0(State state, Object obj) {
        ((Function1) state.getValue()).invoke(obj);
    }
}
