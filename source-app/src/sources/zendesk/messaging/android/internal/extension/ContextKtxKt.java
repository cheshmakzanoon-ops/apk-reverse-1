package zendesk.messaging.android.internal.extension;

import android.content.Context;
import androidx.appcompat.app.AppCompatDelegate;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

@Metadata(m17d1 = {"\u0000 \n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\u001a$\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u0006H\u0000\u001a\f\u0010\b\u001a\u00020\t*\u00020\u0002H\u0002¨\u0006\n"}, m18d2 = {"getMessagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "Landroid/content/Context;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", MessagingComponentKt.USER_LIGHT_COLORS, "Lzendesk/android/messaging/model/UserColors;", MessagingComponentKt.USER_DARK_COLORS, "isNightModeActive", "", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ContextKtxKt {
    public static final MessagingTheme getMessagingTheme(Context context, MessagingSettings messagingSettings, UserColors userLightColors, UserColors userDarkColors) {
        Intrinsics.checkNotNullParameter(context, "<this>");
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(userLightColors, "userLightColors");
        Intrinsics.checkNotNullParameter(userDarkColors, "userDarkColors");
        if (isNightModeActive(context)) {
            return MessagingTheme.INSTANCE.from(context, messagingSettings.getDarkTheme(), userDarkColors);
        }
        return MessagingTheme.INSTANCE.from(context, messagingSettings.getLightTheme(), userLightColors);
    }

    private static final boolean isNightModeActive(Context context) {
        int defaultNightMode = AppCompatDelegate.getDefaultNightMode();
        if (defaultNightMode == 2) {
            return true;
        }
        if (defaultNightMode == 1) {
            return false;
        }
        int i = context.getResources().getConfiguration().uiMode & 48;
        return (i == 0 || i == 16 || i != 32) ? false : true;
    }
}
