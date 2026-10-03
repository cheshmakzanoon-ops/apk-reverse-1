package zendesk.conversationkit.android.internal.rest.model;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.ConversationKt;
import zendesk.conversationkit.android.model.ConversationsPagination;

@Metadata(m17d1 = {"\u0000\u0012\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\u001a\u0014\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u0000¨\u0006\u0005"}, m18d2 = {"toConversationsPagination", "Lzendesk/conversationkit/android/model/ConversationsPagination;", "Lzendesk/conversationkit/android/internal/rest/model/ConversationsResponseDto;", "currentUserId", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsResponseDtoKt {
    public static final ConversationsPagination toConversationsPagination(ConversationsResponseDto conversationsResponseDto, String currentUserId) {
        Intrinsics.checkNotNullParameter(conversationsResponseDto, "<this>");
        Intrinsics.checkNotNullParameter(currentUserId, "currentUserId");
        List<ConversationDto> conversations = conversationsResponseDto.getConversations();
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(conversations, 10));
        Iterator<T> it = conversations.iterator();
        while (it.hasNext()) {
            arrayList.add(ConversationKt.enrichFormResponseFields(ConversationKt.toConversation$default((ConversationDto) it.next(), currentUserId, null, null, false, null, 30, null)));
        }
        return new ConversationsPagination(arrayList, conversationsResponseDto.getConversationsPagination().getHasMore());
    }
}
