package zendesk.messaging.android.internal.conversationscreen;

import java.util.Map;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010%\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\u0005\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002JM\u0010\u0003\u001a\u001a\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00070\u0005\u0012\u0004\u0012\u00020\b0\u00042\u0012\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00070\u00052\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u00062\u0006\u0010\u000b\u001a\u00020\u0007H\u0000¢\u0006\u0002\b\f¨\u0006\r"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/PostbackMessageStatusUseCase;", "", "()V", "updatePostbackStatus", "Lkotlin/Pair;", "", "", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenPostbackStatus;", "", "currentStatuses", "actionId", "updatedStatus", "updatePostbackStatus$zendesk_messaging_messaging_android", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class PostbackMessageStatusUseCase {
    public static final PostbackMessageStatusUseCase INSTANCE = new PostbackMessageStatusUseCase();

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ConversationScreenPostbackStatus.values().length];
            try {
                iArr[ConversationScreenPostbackStatus.FAILED.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ConversationScreenPostbackStatus.SUCCESS.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ConversationScreenPostbackStatus.LOADING.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    private PostbackMessageStatusUseCase() {
    }

    public static Pair updatePostbackStatus$zendesk_messaging_messaging_android$default(PostbackMessageStatusUseCase postbackMessageStatusUseCase, Map map, String str, ConversationScreenPostbackStatus conversationScreenPostbackStatus, int i, Object obj) {
        if ((i & 2) != 0) {
            str = null;
        }
        return postbackMessageStatusUseCase.updatePostbackStatus$zendesk_messaging_messaging_android(map, str, conversationScreenPostbackStatus);
    }

    public final Pair<Map<String, ConversationScreenPostbackStatus>, Boolean> updatePostbackStatus$zendesk_messaging_messaging_android(Map<String, ConversationScreenPostbackStatus> currentStatuses, String actionId, ConversationScreenPostbackStatus updatedStatus) {
        Intrinsics.checkNotNullParameter(currentStatuses, "currentStatuses");
        Intrinsics.checkNotNullParameter(updatedStatus, "updatedStatus");
        int i = WhenMappings.$EnumSwitchMapping$0[updatedStatus.ordinal()];
        boolean z = true;
        if (i != 1) {
            if ((i == 2 || i == 3) && actionId != null) {
                currentStatuses.put(actionId, updatedStatus);
            }
            z = false;
        } else {
            currentStatuses.clear();
        }
        return new Pair<>(currentStatuses, Boolean.valueOf(z));
    }
}
