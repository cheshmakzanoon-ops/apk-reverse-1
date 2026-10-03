package zendesk.conversationkit.android.model;

import j$.time.LocalDateTime;
import j$.time.ZoneId;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.faye.WsActivityEventDto;
import zendesk.conversationkit.android.internal.faye.WsResponseTimeDto;
import zendesk.core.android.internal.DateKtxKt;

@Metadata(m17d1 = {"\u0000$\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a#\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006H\u0000¢\u0006\u0002\u0010\u0007\u001a\u000e\u0010\b\u001a\u0004\u0018\u00010\t*\u00020\nH\u0000¨\u0006\u000b"}, m18d2 = {"toActivityEvent", "Lzendesk/conversationkit/android/model/ActivityEvent;", "Lzendesk/conversationkit/android/internal/faye/WsActivityEventDto;", "conversationId", "", "appMakerLastRead", "", "(Lzendesk/conversationkit/android/internal/faye/WsActivityEventDto;Ljava/lang/String;Ljava/lang/Double;)Lzendesk/conversationkit/android/model/ActivityEvent;", "toConversationRoutingStatus", "Lzendesk/conversationkit/android/model/ConversationRoutingStatus;", "Lzendesk/conversationkit/android/model/ActivityData;", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ActivityDataKt {

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ActivityData.values().length];
            try {
                iArr[ActivityData.CONVERSATION_ROUTING_QUEUED.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ActivityData.CONVERSATION_ROUTING_ASSIGNED.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ActivityData.CONVERSATION_ROUTING_CLEARED.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final ActivityEvent toActivityEvent(WsActivityEventDto wsActivityEventDto, String conversationId, Double d) {
        ActivityData activityData;
        AuthorType authorType;
        LocalDateTime localDateTime$default;
        Intrinsics.checkNotNullParameter(wsActivityEventDto, "<this>");
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        ActivityData[] activityDataArrValues = ActivityData.values();
        int length = activityDataArrValues.length;
        int i = 0;
        int i2 = 0;
        while (true) {
            if (i2 >= length) {
                activityData = null;
                break;
            }
            ActivityData activityData2 = activityDataArrValues[i2];
            if (Intrinsics.areEqual(activityData2.getType(), wsActivityEventDto.getType())) {
                activityData = activityData2;
                break;
            }
            i2++;
        }
        String appUserId = wsActivityEventDto.getAppUserId();
        String name = wsActivityEventDto.getData().getName();
        String avatarUrl = wsActivityEventDto.getData().getAvatarUrl();
        AuthorType[] authorTypeArrValues = AuthorType.values();
        int length2 = authorTypeArrValues.length;
        while (true) {
            if (i >= length2) {
                authorType = null;
                break;
            }
            authorType = authorTypeArrValues[i];
            if (Intrinsics.areEqual(authorType.getValue(), wsActivityEventDto.getRole())) {
                break;
            }
            i++;
        }
        if (Intrinsics.areEqual(AuthorType.BUSINESS.getValue(), wsActivityEventDto.getRole())) {
            localDateTime$default = DateKtxKt.toLocalDateTime$default(d, (ZoneId) null, 1, (Object) null);
        } else {
            localDateTime$default = DateKtxKt.toLocalDateTime$default(wsActivityEventDto.getData().getLastRead(), (ZoneId) null, 1, (Object) null);
        }
        LocalDateTime localDateTime = localDateTime$default;
        WsResponseTimeDto responseTime = wsActivityEventDto.getData().getResponseTime();
        Long queuePosition = wsActivityEventDto.getData().getQueuePosition();
        Long lValueOf = Long.valueOf(queuePosition != null ? queuePosition.longValue() : 0L);
        Long lowestQueuePosition = wsActivityEventDto.getData().getLowestQueuePosition();
        return new ActivityEvent(conversationId, activityData, appUserId, name, avatarUrl, authorType, localDateTime, responseTime, lValueOf, Long.valueOf(lowestQueuePosition != null ? lowestQueuePosition.longValue() : 0L));
    }

    public static final ConversationRoutingStatus toConversationRoutingStatus(ActivityData activityData) {
        Intrinsics.checkNotNullParameter(activityData, "<this>");
        int i = WhenMappings.$EnumSwitchMapping$0[activityData.ordinal()];
        if (i == 1) {
            return ConversationRoutingStatus.QUEUED;
        }
        if (i == 2) {
            return ConversationRoutingStatus.ASSIGNED;
        }
        if (i != 3) {
            return null;
        }
        return ConversationRoutingStatus.UNKNOWN;
    }
}
