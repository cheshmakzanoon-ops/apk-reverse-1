package androidx.core.graphics;

import android.app.NotificationChannelGroup;
import android.content.Context;
import android.content.pm.ShortcutInfo;
import android.content.pm.ShortcutManager;
import android.graphics.ImageDecoder;
import android.location.GnssMeasurementsEvent;
import android.location.GnssStatus;

public final class ColorKt$$ExternalSyntheticApiModelOutline0 {
    public static NotificationChannelGroup m93m(Object obj) {
        return (NotificationChannelGroup) obj;
    }

    public static ShortcutInfo.Builder m97m(Context context, String str) {
        return new ShortcutInfo.Builder(context, str);
    }

    public static ShortcutInfo m109m(Object obj) {
        return (ShortcutInfo) obj;
    }

    public static ShortcutManager m110m(Object obj) {
        return (ShortcutManager) obj;
    }

    public static ImageDecoder.OnHeaderDecodedListener m118m(Object obj) {
        return (ImageDecoder.OnHeaderDecodedListener) obj;
    }

    public static GnssMeasurementsEvent.Callback m121m(Object obj) {
        return (GnssMeasurementsEvent.Callback) obj;
    }

    public static GnssStatus m122m(Object obj) {
        return (GnssStatus) obj;
    }

    public static Class m126m() {
        return ShortcutManager.class;
    }

    public static void m131m() {
    }

    public static Class m$1() {
        return GnssMeasurementsEvent.Callback.class;
    }
}
