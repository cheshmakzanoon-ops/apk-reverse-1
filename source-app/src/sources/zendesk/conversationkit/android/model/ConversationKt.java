package zendesk.conversationkit.android.model;

import j$.time.LocalDateTime;
import j$.time.ZoneId;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.TuplesKt;
import kotlin.collections.CollectionsKt;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.rest.model.AppUserDto;
import zendesk.conversationkit.android.internal.rest.model.ConversationDto;
import zendesk.conversationkit.android.internal.rest.model.ConversationResponseDto;
import zendesk.conversationkit.android.internal.rest.model.MessageDto;
import zendesk.conversationkit.android.internal.rest.model.ParticipantDto;
import zendesk.core.android.internal.DateKtxKt;

@Metadata(m17d1 = {"\u00008\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0001H\u0000\u001a`\u0010\u0002\u001a\u00020\u0001*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0016\b\u0002\u0010\u0006\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\b\u0018\u00010\u00072\u0010\b\u0002\u0010\t\u001a\n\u0012\u0004\u0012\u00020\u000b\u0018\u00010\n2\b\b\u0002\u0010\f\u001a\u00020\r2\u0016\b\u0002\u0010\u000e\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u000f\u0018\u00010\u0007H\u0000\u001a\u0014\u0010\u0002\u001a\u00020\u0001*\u00020\u00102\u0006\u0010\u0004\u001a\u00020\u0005H\u0000¨\u0006\u0011"}, m18d2 = {"enrichFormResponseFields", "Lzendesk/conversationkit/android/model/Conversation;", "toConversation", "Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;", "currentUserId", "", "appUsers", "", "Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;", "altMessages", "", "Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "hasPrevious", "", "metadata", "", "Lzendesk/conversationkit/android/internal/rest/model/ConversationResponseDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationKt {
    public static final Conversation toConversation(ConversationResponseDto conversationResponseDto, String currentUserId) {
        Intrinsics.checkNotNullParameter(conversationResponseDto, "<this>");
        Intrinsics.checkNotNullParameter(currentUserId, "currentUserId");
        ConversationDto conversation = conversationResponseDto.getConversation();
        Map mapPlus = MapsKt.plus(conversationResponseDto.getAppUsers(), TuplesKt.m25to(conversationResponseDto.getAppUser().getId(), conversationResponseDto.getAppUser()));
        List<MessageDto> messages = conversationResponseDto.getMessages();
        Boolean hasPrevious = conversationResponseDto.getHasPrevious();
        return toConversation(conversation, currentUserId, mapPlus, messages, hasPrevious != null ? hasPrevious.booleanValue() : false, conversationResponseDto.getConversation().getMetadata());
    }

    public static Conversation toConversation$default(ConversationDto conversationDto, String str, Map map, List list, boolean z, Map map2, int i, Object obj) {
        if ((i & 2) != 0) {
            map = MapsKt.emptyMap();
        }
        Map map3 = map;
        if ((i & 4) != 0) {
            list = conversationDto.getMessages();
        }
        List list2 = list;
        if ((i & 8) != 0) {
            z = false;
        }
        boolean z2 = z;
        if ((i & 16) != 0) {
            map2 = null;
        }
        return toConversation(conversationDto, str, map3, list2, z2, map2);
    }

    public static final Conversation toConversation(ConversationDto conversationDto, String currentUserId, Map<String, AppUserDto> map, List<MessageDto> list, boolean z, Map<String, ? extends Object> map2) {
        Participant participant;
        List listEmptyList;
        Object next;
        Intrinsics.checkNotNullParameter(conversationDto, "<this>");
        Intrinsics.checkNotNullParameter(currentUserId, "currentUserId");
        String id = conversationDto.getId();
        String displayName = conversationDto.getDisplayName();
        String description = conversationDto.getDescription();
        String iconUrl = conversationDto.getIconUrl();
        ConversationType conversationType = Intrinsics.areEqual(conversationDto.getType(), "personal") ? ConversationType.PERSONAL : ConversationType.GROUP;
        boolean zIsDefault = conversationDto.isDefault();
        List<String> appMakers = conversationDto.getAppMakers();
        if (appMakers == null) {
            appMakers = CollectionsKt.emptyList();
        }
        List<String> list2 = appMakers;
        LocalDateTime localDateTime$default = DateKtxKt.toLocalDateTime$default(conversationDto.getAppMakerLastRead(), (ZoneId) null, 1, (Object) null);
        Double lastUpdatedAt = conversationDto.getLastUpdatedAt();
        List<ParticipantDto> participants = conversationDto.getParticipants();
        if (participants != null) {
            Iterator<T> it = participants.iterator();
            do {
                if (!it.hasNext()) {
                    next = null;
                    break;
                }
                next = it.next();
            } while (!Intrinsics.areEqual(((ParticipantDto) next).getAppUserId(), currentUserId));
            ParticipantDto participantDto = (ParticipantDto) next;
            if (participantDto != null) {
                participant = ParticipantKt.toParticipant(participantDto);
            } else {
                participant = null;
            }
        } else {
            participant = null;
        }
        List<ParticipantDto> participants2 = conversationDto.getParticipants();
        if (participants2 == null) {
            participants2 = CollectionsKt.emptyList();
        }
        List<ParticipantDto> list3 = participants2;
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(list3, 10));
        Iterator<T> it2 = list3.iterator();
        while (it2.hasNext()) {
            arrayList.add(ParticipantKt.toParticipant((ParticipantDto) it2.next()));
        }
        ArrayList arrayList2 = arrayList;
        if (list != null) {
            List<MessageDto> list4 = list;
            ArrayList arrayList3 = new ArrayList(CollectionsKt.collectionSizeOrDefault(list4, 10));
            for (Iterator it3 = list4.iterator(); it3.hasNext(); it3 = it3) {
                arrayList3.add(MessageKt.toMessage$default((MessageDto) it3.next(), null, null, 3, null));
            }
            listEmptyList = arrayList3;
        } else {
            listEmptyList = CollectionsKt.emptyList();
        }
        return new Conversation(id, displayName, description, iconUrl, conversationType, zIsDefault, list2, localDateTime$default, lastUpdatedAt, participant, arrayList2, listEmptyList, z, Intrinsics.areEqual(conversationDto.getStatus(), "active") ? ConversationStatus.ACTIVE : ConversationStatus.IDLE, map2, conversationDto.getRoutingStatus(), DateKtxKt.toLocalDateTime$default(conversationDto.getCreatedAt(), (ZoneId) null, 1, (Object) null));
    }

    public static final Conversation enrichFormResponseFields(Conversation conversation) {
        Intrinsics.checkNotNullParameter(conversation, "<this>");
        List<Message> messages = conversation.getMessages();
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(messages, 10));
        Iterator<T> it = messages.iterator();
        while (it.hasNext()) {
            arrayList.add(MessageKt.enrichFormResponseFields((Message) it.next(), conversation));
        }
        return conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : arrayList, (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null);
    }
}
