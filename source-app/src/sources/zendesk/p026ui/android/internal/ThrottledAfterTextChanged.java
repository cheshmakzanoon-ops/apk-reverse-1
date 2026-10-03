package zendesk.p026ui.android.internal;

import android.os.SystemClock;
import android.text.Editable;
import android.text.TextWatcher;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\r\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\b \u0018\u00002\u00020\u0001B\u000f\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0012\u0010\u0007\u001a\u00020\b2\b\u0010\t\u001a\u0004\u0018\u00010\nH\u0016J*\u0010\u000b\u001a\u00020\b2\b\u0010\f\u001a\u0004\u0018\u00010\r2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0011\u001a\u00020\u000fH\u0016J\u0012\u0010\u0012\u001a\u00020\b2\b\u0010\t\u001a\u0004\u0018\u00010\nH&J*\u0010\u0013\u001a\u00020\b2\b\u0010\f\u001a\u0004\u0018\u00010\r2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0011\u001a\u00020\u000fH\u0016R\u0012\u0010\u0005\u001a\u0004\u0018\u00010\u0003X\u0082\u000e¢\u0006\u0004\n\u0002\u0010\u0006R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0014"}, m18d2 = {"Lzendesk/ui/android/internal/ThrottledAfterTextChanged;", "Landroid/text/TextWatcher;", "minimumIntervalMillis", "", "(J)V", "lastTextChangedTimeStamp", "Ljava/lang/Long;", "afterTextChanged", "", "text", "Landroid/text/Editable;", "beforeTextChanged", "p0", "", "p1", "", "p2", "p3", "onDebouncedAfterTextChanged", "onTextChanged", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ThrottledAfterTextChanged implements TextWatcher {
    public static final int $stable = 8;
    private Long lastTextChangedTimeStamp;
    private final long minimumIntervalMillis;

    public ThrottledAfterTextChanged() {
        this(0L, 1, null);
    }

    @Override
    public void beforeTextChanged(CharSequence p0, int p1, int p2, int p3) {
    }

    public abstract void onDebouncedAfterTextChanged(Editable text);

    @Override
    public void onTextChanged(CharSequence p0, int p1, int p2, int p3) {
    }

    public ThrottledAfterTextChanged(long j) {
        this.minimumIntervalMillis = j;
    }

    public ThrottledAfterTextChanged(long j, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? 20L : j);
    }

    @Override
    public void afterTextChanged(Editable text) {
        Long l = this.lastTextChangedTimeStamp;
        long jUptimeMillis = SystemClock.uptimeMillis();
        this.lastTextChangedTimeStamp = Long.valueOf(jUptimeMillis);
        if (l == null || Math.abs(jUptimeMillis - l.longValue()) > this.minimumIntervalMillis) {
            onDebouncedAfterTextChanged(text);
        }
    }
}
