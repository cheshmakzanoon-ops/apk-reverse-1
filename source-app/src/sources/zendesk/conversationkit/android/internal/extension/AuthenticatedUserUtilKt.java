package zendesk.conversationkit.android.internal.extension;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.user.Jwt;

@Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u0016\u0010\u0002\u001a\u00020\u0003*\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u0001H\u0000\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0006"}, m18d2 = {"MILLISECONDS_IN_SECOND", "", "isJwtExpired", "", "Lzendesk/conversationkit/android/internal/user/Jwt;", "currentTimeMillis", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class AuthenticatedUserUtilKt {
    public static final long MILLISECONDS_IN_SECOND = 1000;

    public static boolean isJwtExpired$default(Jwt jwt, long j, int i, Object obj) {
        if ((i & 1) != 0) {
            j = System.currentTimeMillis();
        }
        return isJwtExpired(jwt, j);
    }

    public static final boolean isJwtExpired(Jwt jwt, long j) {
        Intrinsics.checkNotNullParameter(jwt, "<this>");
        Long exp = jwt.getExp();
        return exp != null && j > exp.longValue() * 1000;
    }
}
