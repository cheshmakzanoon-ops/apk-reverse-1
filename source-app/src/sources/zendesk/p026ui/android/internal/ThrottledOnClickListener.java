package zendesk.p026ui.android.internal;

import android.os.SystemClock;
import android.view.View;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b \u0018\u00002\u00020\u0001B\u000f\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0010\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH\u0016J\u0012\u0010\f\u001a\u00020\t2\b\u0010\r\u001a\u0004\u0018\u00010\u000bH&R\u001a\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00030\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, m18d2 = {"Lzendesk/ui/android/internal/ThrottledOnClickListener;", "Landroid/view/View$OnClickListener;", "minimumIntervalMillis", "", "(J)V", "lastClickMap", "", "", "onClick", "", "clickedView", "Landroid/view/View;", "onDebouncedClick", "view", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ThrottledOnClickListener implements View.OnClickListener {
    public static final int $stable = 8;
    private final Map<Integer, Long> lastClickMap;
    private final long minimumIntervalMillis;

    public ThrottledOnClickListener() {
        this(0L, 1, null);
    }

    public abstract void onDebouncedClick(View view);

    public ThrottledOnClickListener(long j) {
        this.minimumIntervalMillis = j;
        this.lastClickMap = new ConcurrentHashMap<>();
    }

    public ThrottledOnClickListener(long j, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? 500L : j);
    }

    @Override
    public void onClick(View clickedView) {
        Intrinsics.checkNotNullParameter(clickedView, "clickedView");
        int id = clickedView.getId();
        Long l = this.lastClickMap.get(Integer.valueOf(id));
        long jUptimeMillis = SystemClock.uptimeMillis();
        if (l == null || Math.abs(jUptimeMillis - l.longValue()) > this.minimumIntervalMillis) {
            this.lastClickMap.put(Integer.valueOf(id), Long.valueOf(jUptimeMillis));
            onDebouncedClick(clickedView);
        }
    }
}
