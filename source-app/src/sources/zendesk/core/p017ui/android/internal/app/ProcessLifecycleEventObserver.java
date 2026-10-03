package zendesk.core.p017ui.android.internal.app;

import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleEventObserver;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LifecycleOwnerKt;
import androidx.lifecycle.ProcessLifecycleOwner;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import zendesk.core.p017ui.android.internal.InternalZendeskUIApi;

@Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u0000 \u000f2\u00020\u0001:\u0001\u000fB\u0005¢\u0006\u0002\u0010\u0002J\u0018\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eH\u0016R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u0017\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00050\u00078F¢\u0006\u0006\u001a\u0004\b\u0006\u0010\b¨\u0006\u0010"}, m18d2 = {"Lzendesk/core/ui/android/internal/app/ProcessLifecycleEventObserver;", "Landroidx/lifecycle/LifecycleEventObserver;", "()V", "_isInForeground", "Lkotlinx/coroutines/flow/MutableStateFlow;", "", "isInForeground", "Lkotlinx/coroutines/flow/Flow;", "()Lkotlinx/coroutines/flow/Flow;", "onStateChanged", "", "source", "Landroidx/lifecycle/LifecycleOwner;", "event", "Landroidx/lifecycle/Lifecycle$Event;", "Companion", "zendesk.core.ui_core-ui"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@InternalZendeskUIApi
public final class ProcessLifecycleEventObserver implements LifecycleEventObserver {
    private MutableStateFlow<Boolean> _isInForeground = StateFlowKt.MutableStateFlow(false);

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[Lifecycle.Event.values().length];
            try {
                iArr[Lifecycle.Event.ON_STOP.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[Lifecycle.Event.ON_START.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public final Flow<Boolean> isInForeground() {
        return this._isInForeground;
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0087\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0006\u0010\u0003\u001a\u00020\u0004J\u0006\u0010\u0005\u001a\u00020\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/core/ui/android/internal/app/ProcessLifecycleEventObserver$Companion;", "", "()V", "newInstance", "Lzendesk/core/ui/android/internal/app/ProcessLifecycleEventObserver;", "processLifeCycleOwnerCoroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "zendesk.core.ui_core-ui"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @InternalZendeskUIApi
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final ProcessLifecycleEventObserver newInstance() {
            LifecycleObserver processLifecycleEventObserver = new ProcessLifecycleEventObserver();
            ProcessLifecycleOwner.Companion.get().getLifecycle().addObserver(processLifecycleEventObserver);
            return processLifecycleEventObserver;
        }

        public final CoroutineScope processLifeCycleOwnerCoroutineScope() {
            return LifecycleOwnerKt.getLifecycleScope(ProcessLifecycleOwner.Companion.get());
        }
    }

    public void onStateChanged(LifecycleOwner source, Lifecycle.Event event) {
        Intrinsics.checkNotNullParameter(source, "source");
        Intrinsics.checkNotNullParameter(event, "event");
        int i = WhenMappings.$EnumSwitchMapping$0[event.ordinal()];
        if (i == 1) {
            this._isInForeground.setValue(false);
        } else {
            if (i != 2) {
                return;
            }
            this._isInForeground.setValue(true);
        }
    }
}
