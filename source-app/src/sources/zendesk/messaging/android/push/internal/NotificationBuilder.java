package zendesk.messaging.android.push.internal;

import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import androidx.core.app.NotificationCompat;
import androidx.core.app.Person;
import j$.util.Objects;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.Zendesk;
import zendesk.android.ZendeskCredentials;
import zendesk.android.messaging.Messaging;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.extension.ZendeskKtxKt;
import zendesk.messaging.android.internal.messagingscreen.MessagingActivityIntentBuilder;

@Metadata(m17d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0000\u0018\u0000 %2\u00020\u0001:\u0001%B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0006\u0010\u0007\u001a\u00020\bJ\u000e\u0010\t\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u000bJ\u000e\u0010\f\u001a\u00020\u00002\u0006\u0010\r\u001a\u00020\u000eJ\u000e\u0010\u000f\u001a\u00020\u00002\u0006\u0010\u0010\u001a\u00020\u000eJ\u001e\u0010\u0011\u001a\u00020\u00002\u0006\u0010\u0012\u001a\u00020\u000e2\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0016J\u000e\u0010\u0017\u001a\u00020\u00002\u0006\u0010\u0018\u001a\u00020\u000eJ\u000e\u0010\u0019\u001a\u00020\u00002\u0006\u0010\u001a\u001a\u00020\u001bJ\u000e\u0010\u001c\u001a\u00020\u00002\u0006\u0010\u001d\u001a\u00020\u001bJ\u0010\u0010\u001e\u001a\u00020\u00002\b\u0010\u001f\u001a\u0004\u0018\u00010 J\u000e\u0010!\u001a\u00020\u00002\u0006\u0010\"\u001a\u00020\u000eJ\u000e\u0010#\u001a\u00020\u00002\u0006\u0010$\u001a\u00020\u001bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006&"}, m18d2 = {"Lzendesk/messaging/android/push/internal/NotificationBuilder;", "", "compatBuilder", "Landroidx/core/app/NotificationCompat$Builder;", "context", "Landroid/content/Context;", "(Landroidx/core/app/NotificationCompat$Builder;Landroid/content/Context;)V", "build", "Landroid/app/Notification;", "setAutoCancel", "autoCancel", "", "setCategory", "category", "", "setMessage", "message", "setMessagingStyle", "text", "received", "", "person", "Landroidx/core/app/Person;", "setOpenConversationIntent", "conversationId", "setOpenProactiveNotificationIntent", "notificationId", "", "setSmallIcon", "smallIconId", "setStyle", "style", "Landroidx/core/app/NotificationCompat$Style;", "setTitle", "title", "setUnreadCount", "unreadCount", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class NotificationBuilder {
    public static final String PROACTIVE_NOTIFICATION_ID = "NOTIFICATION_ID";
    private final NotificationCompat.Builder compatBuilder;
    private final Context context;

    public NotificationBuilder(NotificationCompat.Builder compatBuilder, Context context) {
        Intrinsics.checkNotNullParameter(compatBuilder, "compatBuilder");
        Intrinsics.checkNotNullParameter(context, "context");
        this.compatBuilder = compatBuilder;
        this.context = context;
    }

    public final NotificationBuilder setSmallIcon(int smallIconId) {
        this.compatBuilder.setSmallIcon(smallIconId);
        return this;
    }

    public final NotificationBuilder setStyle(NotificationCompat.Style style) {
        this.compatBuilder.setStyle(style);
        return this;
    }

    public final NotificationBuilder setMessagingStyle(String text, long received, Person person) {
        Intrinsics.checkNotNullParameter(text, "text");
        Intrinsics.checkNotNullParameter(person, "person");
        setStyle((NotificationCompat.Style) new NotificationCompat.MessagingStyle(person).addMessage(new NotificationCompat.MessagingStyle.Message(text, received, person)));
        return this;
    }

    public final NotificationBuilder setCategory(String category) {
        Intrinsics.checkNotNullParameter(category, "category");
        this.compatBuilder.setCategory(category);
        return this;
    }

    public final NotificationBuilder setAutoCancel(boolean autoCancel) {
        this.compatBuilder.setAutoCancel(autoCancel);
        return this;
    }

    public final NotificationBuilder setUnreadCount(int unreadCount) {
        this.compatBuilder.setNumber(unreadCount);
        return this;
    }

    public final NotificationBuilder setOpenProactiveNotificationIntent(int notificationId) {
        Intent launchIntentForPackage;
        DefaultMessaging defaultMessaging = ZendeskKtxKt.defaultMessaging(Zendesk.INSTANCE);
        if (defaultMessaging == null || (launchIntentForPackage = DefaultMessaging.m226x8c0ab3fb(defaultMessaging, this.context, 0, 2, null)) == null) {
            launchIntentForPackage = this.context.getPackageManager().getLaunchIntentForPackage(this.context.getPackageName());
        }
        if (launchIntentForPackage != null) {
            launchIntentForPackage.putExtra(PROACTIVE_NOTIFICATION_ID, notificationId);
        }
        int i = Build.VERSION.SDK_INT > 30 ? 1140850688 : 1073741824;
        if (launchIntentForPackage != null) {
            this.compatBuilder.setContentIntent(PendingIntent.getActivity(this.context, notificationId, launchIntentForPackage, i));
        }
        return this;
    }

    public final NotificationBuilder setOpenConversationIntent(String conversationId) {
        Intent launchIntentForPackage;
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        Messaging messaging = Zendesk.INSTANCE.getInstance().getMessaging();
        DefaultMessaging defaultMessaging = messaging instanceof DefaultMessaging ? (DefaultMessaging) messaging : null;
        ZendeskCredentials zendeskCredentials = defaultMessaging != null ? defaultMessaging.credentials : null;
        if (zendeskCredentials == null || (launchIntentForPackage = new MessagingActivityIntentBuilder(this.context, zendeskCredentials, conversationId).getIntent()) == null) {
            launchIntentForPackage = this.context.getPackageManager().getLaunchIntentForPackage(this.context.getPackageName());
        }
        int i = Build.VERSION.SDK_INT > 30 ? 1140850688 : 1073741824;
        if (launchIntentForPackage != null) {
            this.compatBuilder.setContentIntent(PendingIntent.getActivity(this.context, Objects.hash(new Object[]{conversationId}), launchIntentForPackage, i));
        }
        return this;
    }

    public final NotificationBuilder setTitle(String title) {
        Intrinsics.checkNotNullParameter(title, "title");
        this.compatBuilder.setContentTitle(title);
        return this;
    }

    public final NotificationBuilder setMessage(String message) {
        Intrinsics.checkNotNullParameter(message, "message");
        this.compatBuilder.setContentText(message);
        return this;
    }

    public final Notification build() {
        Notification notificationBuild = this.compatBuilder.build();
        Intrinsics.checkNotNullExpressionValue(notificationBuild, "build(...)");
        return notificationBuild;
    }
}
