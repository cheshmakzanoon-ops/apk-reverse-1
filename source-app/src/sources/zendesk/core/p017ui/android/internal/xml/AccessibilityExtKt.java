package zendesk.core.p017ui.android.internal.xml;

import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Context;
import android.view.View;
import android.view.accessibility.AccessibilityManager;
import androidx.core.view.AccessibilityDelegateCompat;
import androidx.core.view.ViewCompat;
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.InternalZendeskUIApi;

@Metadata(m17d1 = {"\u0000,\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\t\n\u0002\b\u0002\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0007\u001a\u001c\u0010\u0003\u001a\u00020\u0004*\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\tH\u0007\u001a\u0014\u0010\n\u001a\u00020\u0004*\u00020\u00052\u0006\u0010\u000b\u001a\u00020\u0007H\u0007\u001a\u001c\u0010\f\u001a\u00020\u0004*\u00020\u00052\u0006\u0010\r\u001a\u00020\u00022\u0006\u0010\u000e\u001a\u00020\u000fH\u0007\u001a\u001c\u0010\u0010\u001a\u00020\u0004*\u00020\u00052\u0006\u0010\r\u001a\u00020\u00022\u0006\u0010\u000e\u001a\u00020\u000fH\u0007¨\u0006\u0011"}, m18d2 = {"isAccessibilityServiceRunning", "", "Landroid/content/Context;", "overrideAccessibilityNodeActionInfo", "", "Landroid/view/View;", "announcement", "", "actionId", "", "overrideAccessibilityNodeClassNameInfo", "className", "postDelayRequestFocusByAccessibilityEventWhenAccessibilityRunning", "context", "eventDelay", "", "postDelayRequestFocusWhenAccessibilityRunning", "zendesk.core.ui_core-ui"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class AccessibilityExtKt {
    @InternalZendeskUIApi
    public static final boolean isAccessibilityServiceRunning(Context context) {
        Intrinsics.checkNotNullParameter(context, "<this>");
        Object systemService = context.getSystemService("accessibility");
        Intrinsics.checkNotNull(systemService, "null cannot be cast to non-null type android.view.accessibility.AccessibilityManager");
        List<AccessibilityServiceInfo> enabledAccessibilityServiceList = ((AccessibilityManager) systemService).getEnabledAccessibilityServiceList(-1);
        Intrinsics.checkNotNullExpressionValue(enabledAccessibilityServiceList, "getEnabledAccessibilityServiceList(...)");
        return !enabledAccessibilityServiceList.isEmpty();
    }

    @InternalZendeskUIApi
    public static final void postDelayRequestFocusWhenAccessibilityRunning(final View view, Context context, long j) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(context, "context");
        if (isAccessibilityServiceRunning(context)) {
            view.postDelayed(new Runnable() {
                @Override
                public final void run() {
                    AccessibilityExtKt.postDelayRequestFocusWhenAccessibilityRunning$lambda$0(view);
                }
            }, j);
        }
    }

    public static final void postDelayRequestFocusWhenAccessibilityRunning$lambda$0(View this_postDelayRequestFocusWhenAccessibilityRunning) {
        Intrinsics.checkNotNullParameter(this_postDelayRequestFocusWhenAccessibilityRunning, "$this_postDelayRequestFocusWhenAccessibilityRunning");
        this_postDelayRequestFocusWhenAccessibilityRunning.sendAccessibilityEvent(8);
        this_postDelayRequestFocusWhenAccessibilityRunning.requestFocusFromTouch();
    }

    @InternalZendeskUIApi
    public static final void m214xcf2b36ba(final View view, Context context, long j) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(context, "context");
        if (isAccessibilityServiceRunning(context)) {
            view.postDelayed(new Runnable() {
                @Override
                public final void run() {
                    AccessibilityExtKt.m215x83dcd93e(view);
                }
            }, j);
        }
    }

    public static final void m215x83dcd93e(View this_postDelayRequestFocusByAccessibilityEventWhenAccessibilityRunning) {
        Intrinsics.checkNotNullParameter(this_postDelayRequestFocusByAccessibilityEventWhenAccessibilityRunning, "$this_postDelayRequestFocusByAccessibilityEventWhenAccessibilityRunning");
        this_postDelayRequestFocusByAccessibilityEventWhenAccessibilityRunning.sendAccessibilityEvent(8);
    }

    @InternalZendeskUIApi
    public static final void overrideAccessibilityNodeActionInfo(View view, final String announcement, final int i) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(announcement, "announcement");
        ViewCompat.setAccessibilityDelegate(view, new AccessibilityDelegateCompat() {
            public void onInitializeAccessibilityNodeInfo(View host, AccessibilityNodeInfoCompat info) {
                Intrinsics.checkNotNullParameter(host, "host");
                Intrinsics.checkNotNullParameter(info, "info");
                super.onInitializeAccessibilityNodeInfo(host, info);
                info.setClassName((CharSequence) null);
                info.addAction(new AccessibilityNodeInfoCompat.AccessibilityActionCompat(i, announcement));
            }
        });
    }

    @InternalZendeskUIApi
    public static final void overrideAccessibilityNodeClassNameInfo(View view, final String className) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(className, "className");
        ViewCompat.setAccessibilityDelegate(view, new AccessibilityDelegateCompat() {
            public void onInitializeAccessibilityNodeInfo(View host, AccessibilityNodeInfoCompat info) {
                Intrinsics.checkNotNullParameter(host, "host");
                Intrinsics.checkNotNullParameter(info, "info");
                super.onInitializeAccessibilityNodeInfo(host, info);
                info.setClassName(className);
            }
        });
    }
}
