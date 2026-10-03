package zendesk.messaging.android.push;

import android.content.Context;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\u0018\u0000 \n2\u00020\u0001:\u0001\nB\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0016J\u0010\u0010\u0007\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\tH\u0016¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/push/DefaultMessagingService;", "Lcom/google/firebase/messaging/FirebaseMessagingService;", "()V", "onMessageReceived", "", "remoteMessage", "Lcom/google/firebase/messaging/RemoteMessage;", "onNewToken", "newToken", "", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultMessagingService extends FirebaseMessagingService {
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "DefaultMessagingService";

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[PushResponsibility.values().length];
            try {
                iArr[PushResponsibility.MESSAGING_SHOULD_DISPLAY.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[PushResponsibility.MESSAGING_SHOULD_NOT_DISPLAY.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[PushResponsibility.NOT_FROM_MESSAGING.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public void onMessageReceived(RemoteMessage remoteMessage) {
        Intrinsics.checkNotNullParameter(remoteMessage, "remoteMessage");
        Map data = remoteMessage.getData();
        Intrinsics.checkNotNullExpressionValue(data, "getData(...)");
        int i = WhenMappings.$EnumSwitchMapping$0[PushNotifications.shouldBeDisplayed(data).ordinal()];
        if (i != 1) {
            if (i == 2) {
                Logger.m217d(LOG_TAG, "Notification received from Messaging but shouldn't be displayed", new Object[0]);
                return;
            } else {
                if (i != 3) {
                    return;
                }
                Logger.m217d(LOG_TAG, "Notification received but doesn't belong to Messaging", new Object[0]);
                return;
            }
        }
        Context context = (Context) this;
        Map data2 = remoteMessage.getData();
        Intrinsics.checkNotNullExpressionValue(data2, "getData(...)");
        if (PushNotifications.validatePushIntegration(context, data2)) {
            Logger.m217d(LOG_TAG, "Notification received from Messaging and should be displayed", new Object[0]);
            Map data3 = remoteMessage.getData();
            Intrinsics.checkNotNullExpressionValue(data3, "getData(...)");
            PushNotifications.displayNotification(context, data3);
            return;
        }
        Logger.m217d(LOG_TAG, "Notification received from Messaging but shouldn't be displayed since push integration is not valid.", new Object[0]);
    }

    public void onNewToken(String newToken) {
        Intrinsics.checkNotNullParameter(newToken, "newToken");
        Logger.m217d(LOG_TAG, "New FCM token: " + newToken, new Object[0]);
        PushNotifications.updatePushNotificationToken(newToken);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/messaging/android/push/DefaultMessagingService$Companion;", "", "()V", "LOG_TAG", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
