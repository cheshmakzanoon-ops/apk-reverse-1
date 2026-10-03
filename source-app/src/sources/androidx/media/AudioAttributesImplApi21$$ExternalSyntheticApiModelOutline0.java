package androidx.media;

import android.adservices.adid.AdId;
import android.adservices.adid.AdIdManager;
import android.adservices.adselection.AdSelectionConfig;
import android.adservices.adselection.AdSelectionManager;
import android.adservices.adselection.AdSelectionOutcome;
import android.adservices.adselection.ReportImpressionRequest;
import android.adservices.appsetid.AppSetId;
import android.app.Notification;
import android.view.WindowInsetsController;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.inputmethod.InputContentInfo;
import java.util.Map;

public final class AudioAttributesImplApi21$$ExternalSyntheticApiModelOutline0 {
    public static AdId m279m(Object obj) {
        return (AdId) obj;
    }

    public static AdIdManager m280m(Object obj) {
        return (AdIdManager) obj;
    }

    public static AdSelectionConfig.Builder m281m() {
        return new AdSelectionConfig.Builder();
    }

    public static AdSelectionManager m288m(Object obj) {
        return (AdSelectionManager) obj;
    }

    public static AdSelectionOutcome m289m(Object obj) {
        return (AdSelectionOutcome) obj;
    }

    public static ReportImpressionRequest m290m(long j, AdSelectionConfig adSelectionConfig) {
        return new ReportImpressionRequest(j, adSelectionConfig);
    }

    public static AppSetId m291m(Object obj) {
        return (AppSetId) obj;
    }

    public static Notification.DecoratedMediaCustomViewStyle m294m() {
        return new Notification.DecoratedMediaCustomViewStyle();
    }

    public static android.media.session.MediaSessionManager.RemoteUserInfo m298m(String str, int i, int i2) {
        return new android.media.session.MediaSessionManager.RemoteUserInfo(str, i, i2);
    }

    public static WindowInsetsController.OnControllableInsetsChangedListener m302m(Object obj) {
        return (WindowInsetsController.OnControllableInsetsChangedListener) obj;
    }

    public static AccessibilityNodeInfo.TouchDelegateInfo m306m(Map map) {
        return new AccessibilityNodeInfo.TouchDelegateInfo(map);
    }

    public static InputContentInfo m308m(Object obj) {
        return (InputContentInfo) obj;
    }

    public static Class m310m() {
        return AdIdManager.class;
    }

    public static void m316m() {
    }

    public static Class m2240m$1() {
        return AdSelectionManager.class;
    }
}
