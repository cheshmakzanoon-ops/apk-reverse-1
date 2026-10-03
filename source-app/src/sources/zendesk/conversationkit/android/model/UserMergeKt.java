package zendesk.conversationkit.android.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.rest.model.UserMergeDataDTO;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0000¨\u0006\u0003"}, m18d2 = {"toUserMerge", "Lzendesk/conversationkit/android/model/UserMerge;", "Lzendesk/conversationkit/android/internal/rest/model/UserMergeDataDTO;", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserMergeKt {
    public static final UserMerge toUserMerge(UserMergeDataDTO userMergeDataDTO) {
        Intrinsics.checkNotNullParameter(userMergeDataDTO, "<this>");
        return new UserMerge(userMergeDataDTO.getSurvivingAppUser().getId(), userMergeDataDTO.getSurvivingAppUser().getUserId(), userMergeDataDTO.getReason());
    }
}
