package zendesk.p026ui.android.internal;

import android.view.View;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001a\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\u001a \u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00012\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006H\u0000\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000¨\u0006\b"}, m18d2 = {"DEFAULT_DEBOUNCE_MINIMUM_INTERVAL_MILLIS", "", "throttledOnClickListener", "Lzendesk/ui/android/internal/ThrottledOnClickListener;", "minimumIntervalMillis", "onClick", "Lkotlin/Function0;", "", "zendesk.ui_ui-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ThrottledOnClickListenerKt {
    private static final long DEFAULT_DEBOUNCE_MINIMUM_INTERVAL_MILLIS = 500;

    public static ThrottledOnClickListener throttledOnClickListener$default(long j, Function0 function0, int i, Object obj) {
        if ((i & 1) != 0) {
            j = DEFAULT_DEBOUNCE_MINIMUM_INTERVAL_MILLIS;
        }
        return throttledOnClickListener(j, function0);
    }

    public static final ThrottledOnClickListener throttledOnClickListener(long j, final Function0<Unit> onClick) {
        Intrinsics.checkNotNullParameter(onClick, "onClick");
        return new ThrottledOnClickListener(j) {
            @Override
            public void onDebouncedClick(View view) {
                onClick.invoke();
            }
        };
    }
}
