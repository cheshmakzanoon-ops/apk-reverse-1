package zendesk.messaging.android.internal.proactivemessaging;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import androidx.core.app.NotificationCompat;
import com.unity3d.player.l$a$;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import okio.NioSystemFileSystem$$ExternalSyntheticApiModelOutline0;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.MessagingBuildConfig;
import zendesk.messaging.android.push.internal.NotificationBuilder;
import zendesk.messaging.android.push.internal.NotificationProcessor;

@Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010!\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\t\b\u0000\u0018\u0000  2\u00020\u0001:\u0001 B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0010\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0016H\u0003J\u0006\u0010\u0017\u001a\u00020\u0018J\u001e\u0010\u0019\u001a\u00020\u00182\u0006\u0010\u001a\u001a\u00020\t2\u0006\u0010\u001b\u001a\u00020\u00162\u0006\u0010\u001c\u001a\u00020\u0016J\u0017\u0010\u001d\u001a\u00020\u00182\n\b\u0001\u0010\u001e\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\u001fR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\b¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0010\u0010\f\u001a\u0004\u0018\u00010\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u001e\u0010\u000e\u001a\u00020\t8\u0006@\u0006X\u0087\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012¨\u0006!"}, m18d2 = {"Lzendesk/messaging/android/internal/proactivemessaging/LocalNotificationHandler;", "", "notificationProcessor", "Lzendesk/messaging/android/push/internal/NotificationProcessor;", "context", "Landroid/content/Context;", "(Lzendesk/messaging/android/push/internal/NotificationProcessor;Landroid/content/Context;)V", "localNotificationsIds", "", "", "getLocalNotificationsIds", "()Ljava/util/List;", "notificationManager", "Landroid/app/NotificationManager;", "smallNotificationIconId", "getSmallNotificationIconId", "()I", "setSmallNotificationIconId", "(I)V", "buildChannel", "Landroid/app/NotificationChannel;", "channelName", "", "clearLocalNotifications", "", "displayLocalNotification", "id", "title", "body", "setLocalNotificationSmallIconId", "smallIconId", "(Ljava/lang/Integer;)V", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class LocalNotificationHandler {
    private static final String channelName = "Proactive Messages";
    private static final String proactiveMessageNotificationChannelId = "PROACTIVE_MESSAGING_NOTIFICATION_CHANNEL_ID";
    private final Context context;
    private final List<Integer> localNotificationsIds;
    private NotificationManager notificationManager;
    private final NotificationProcessor notificationProcessor;
    private int smallNotificationIconId;

    public LocalNotificationHandler(NotificationProcessor notificationProcessor, Context context) {
        NotificationManager notificationManager;
        Intrinsics.checkNotNullParameter(notificationProcessor, "notificationProcessor");
        Intrinsics.checkNotNullParameter(context, "context");
        this.notificationProcessor = notificationProcessor;
        this.context = context;
        this.smallNotificationIconId = C1256R.drawable.zma_default_notification_icon;
        Object systemService = context.getSystemService("notification");
        this.notificationManager = systemService instanceof NotificationManager ? (NotificationManager) systemService : null;
        this.localNotificationsIds = new ArrayList();
        if (!MessagingBuildConfig.INSTANCE.atLeastAndroid26() || (notificationManager = this.notificationManager) == null) {
            return;
        }
        l$a$.ExternalSyntheticApiModelOutline0.m(notificationManager, buildChannel(channelName));
    }

    public final int getSmallNotificationIconId() {
        return this.smallNotificationIconId;
    }

    public final void setSmallNotificationIconId(int i) {
        this.smallNotificationIconId = i;
    }

    public final List<Integer> getLocalNotificationsIds() {
        return this.localNotificationsIds;
    }

    private final NotificationChannel buildChannel(String channelName2) {
        NioSystemFileSystem$$ExternalSyntheticApiModelOutline0.m172m();
        NotificationChannel notificationChannelM = l$a$.ExternalSyntheticApiModelOutline0.m(proactiveMessageNotificationChannelId, channelName2, 4);
        notificationChannelM.enableVibration(true);
        notificationChannelM.enableLights(true);
        return notificationChannelM;
    }

    public final void displayLocalNotification(int id, String title, String body) {
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(body, "body");
        this.localNotificationsIds.add(Integer.valueOf(id));
        this.notificationProcessor.displayLocalNotification(this.context, id, title, body, new NotificationBuilder(new NotificationCompat.Builder(this.context, proactiveMessageNotificationChannelId), this.context), this.smallNotificationIconId);
    }

    public final void clearLocalNotifications() {
        NotificationManager notificationManager = this.notificationManager;
        if (notificationManager != null) {
            notificationManager.cancelAll();
        }
        this.localNotificationsIds.clear();
    }

    public final void setLocalNotificationSmallIconId(Integer smallIconId) {
        this.smallNotificationIconId = smallIconId != null ? smallIconId.intValue() : C1256R.drawable.zma_default_notification_icon;
    }
}
