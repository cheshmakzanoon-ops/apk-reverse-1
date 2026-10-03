package zendesk.android.internal.usercolors;

import kotlin.Metadata;
import zendesk.android.messaging.model.UserColors;

@Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u0010\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u0004\u0018\u00010\u0002H\u0000\u001a\u0010\u0010\u0003\u001a\u0004\u0018\u00010\u0002*\u0004\u0018\u00010\u0001H\u0000¨\u0006\u0004"}, m18d2 = {"toPersistence", "Lzendesk/android/internal/usercolors/UserColorsPersistence;", "Lzendesk/android/messaging/model/UserColors;", "toUserColors", "zendesk_zendesk-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserColorsPersistenceKt {
    public static final UserColorsPersistence toPersistence(UserColors userColors) {
        if (userColors != null) {
            return new UserColorsPersistence(userColors.getOnMessage(), userColors.getOnAction(), userColors.getOnPrimary());
        }
        return null;
    }

    public static final UserColors toUserColors(UserColorsPersistence userColorsPersistence) {
        if (userColorsPersistence != null) {
            return new UserColors(userColorsPersistence.getOnMessage(), userColorsPersistence.getOnAction(), userColorsPersistence.getOnPrimary());
        }
        return null;
    }
}
