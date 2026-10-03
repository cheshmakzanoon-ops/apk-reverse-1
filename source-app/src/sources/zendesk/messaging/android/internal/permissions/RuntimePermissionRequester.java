package zendesk.messaging.android.internal.permissions;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0000\b`\u0018\u00002\u00020\u0001J(\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0016\b\u0002\u0010\u0006\u001a\u0010\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0007H&¨\u0006\t"}, m18d2 = {"Lzendesk/messaging/android/internal/permissions/RuntimePermissionRequester;", "", "launchSinglePermissionRequest", "", "permission", "", "onPermissionResult", "Lkotlin/Function1;", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface RuntimePermissionRequester {
    void launchSinglePermissionRequest(String permission, Function1<? super Boolean, Unit> onPermissionResult);

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DefaultImpls {
        public static void launchSinglePermissionRequest$default(RuntimePermissionRequester runtimePermissionRequester, String str, Function1 function1, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: launchSinglePermissionRequest");
            }
            if ((i & 2) != 0) {
                function1 = null;
            }
            runtimePermissionRequester.launchSinglePermissionRequest(str, function1);
        }
    }
}
