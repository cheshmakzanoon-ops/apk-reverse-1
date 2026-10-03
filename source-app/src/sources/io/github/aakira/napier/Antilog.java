package io.github.aakira.napier;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m16bv = {1, 0, 3}, m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0005\b&\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u001a\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\bH\u0016J,\u0010\t\u001a\u00020\n2\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\b2\b\u0010\u000b\u001a\u0004\u0018\u00010\f2\b\u0010\r\u001a\u0004\u0018\u00010\bJ.\u0010\u000e\u001a\u00020\n2\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\b2\b\u0010\u000b\u001a\u0004\u0018\u00010\f2\b\u0010\r\u001a\u0004\u0018\u00010\bH$J3\u0010\u000f\u001a\u00020\n2\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\b2\b\u0010\u000b\u001a\u0004\u0018\u00010\f2\b\u0010\r\u001a\u0004\u0018\u00010\bH\u0000¢\u0006\u0002\b\u0010¨\u0006\u0011"}, m18d2 = {"Lio/github/aakira/napier/Antilog;", "", "()V", "isEnable", "", "priority", "Lio/github/aakira/napier/Napier$Level;", "tag", "", "log", "", "throwable", "", "message", "performLog", "rawLog", "rawLog$napier_release", "napier_release"}, m19k = 1, m20mv = {1, 4, 2})
public abstract class Antilog {
    public boolean isEnable(Napier.Level priority, String tag) {
        Intrinsics.checkNotNullParameter(priority, "priority");
        return true;
    }

    protected abstract void performLog(Napier.Level priority, String tag, Throwable throwable, String message);

    public final void log(Napier.Level priority, String tag, Throwable throwable, String message) {
        Intrinsics.checkNotNullParameter(priority, "priority");
        if (isEnable(priority, tag)) {
            performLog(priority, tag, throwable, message);
        }
    }

    public final void rawLog$napier_release(Napier.Level priority, String tag, Throwable throwable, String message) {
        Intrinsics.checkNotNullParameter(priority, "priority");
        performLog(priority, tag, throwable, message);
    }
}
