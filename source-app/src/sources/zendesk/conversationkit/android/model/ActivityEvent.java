package zendesk.conversationkit.android.model;

import j$.time.LocalDateTime;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.faye.WsResponseTimeDto;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0017\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0013\b\u0086\b\u0018\u00002\u00020\u0001Bk\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0004\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\n\u001a\u0004\u0018\u00010\t\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u000b\u0012\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\r\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u0011\u001a\u0004\u0018\u00010\u000f¢\u0006\u0004\b\u0012\u0010\u0013J\u0010\u0010\u0014\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b\u0014\u0010\u0015J\u0012\u0010\u0016\u001a\u0004\u0018\u00010\u0004HÆ\u0003¢\u0006\u0004\b\u0016\u0010\u0017J\u0012\u0010\u0018\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\b\u0018\u0010\u0015J\u0012\u0010\u0019\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\b\u0019\u0010\u0015J\u0012\u0010\u001a\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\b\u001a\u0010\u0015J\u0012\u0010\u001b\u001a\u0004\u0018\u00010\tHÆ\u0003¢\u0006\u0004\b\u001b\u0010\u001cJ\u0012\u0010\u001d\u001a\u0004\u0018\u00010\u000bHÆ\u0003¢\u0006\u0004\b\u001d\u0010\u001eJ\u0012\u0010\u001f\u001a\u0004\u0018\u00010\rHÆ\u0003¢\u0006\u0004\b\u001f\u0010 J\u0012\u0010!\u001a\u0004\u0018\u00010\u000fHÆ\u0003¢\u0006\u0004\b!\u0010\"J\u0012\u0010#\u001a\u0004\u0018\u00010\u000fHÆ\u0003¢\u0006\u0004\b#\u0010\"J\u0086\u0001\u0010$\u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00022\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00042\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00022\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00022\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00022\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\t2\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u000b2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\r2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u000f2\n\b\u0002\u0010\u0011\u001a\u0004\u0018\u00010\u000fHÆ\u0001¢\u0006\u0004\b$\u0010%J\u0010\u0010&\u001a\u00020\u0002HÖ\u0001¢\u0006\u0004\b&\u0010\u0015J\u0010\u0010(\u001a\u00020'HÖ\u0001¢\u0006\u0004\b(\u0010)J\u001a\u0010,\u001a\u00020+2\b\u0010*\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b,\u0010-R\u0017\u0010\u0003\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u0003\u0010.\u001a\u0004\b/\u0010\u0015R\u0019\u0010\u0005\u001a\u0004\u0018\u00010\u00048\u0006¢\u0006\f\n\u0004\b\u0005\u00100\u001a\u0004\b1\u0010\u0017R\u0019\u0010\u0006\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\u0006\u0010.\u001a\u0004\b2\u0010\u0015R\u0019\u0010\u0007\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\u0007\u0010.\u001a\u0004\b3\u0010\u0015R\u0019\u0010\b\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\b\u0010.\u001a\u0004\b4\u0010\u0015R\u0019\u0010\n\u001a\u0004\u0018\u00010\t8\u0006¢\u0006\f\n\u0004\b\n\u00105\u001a\u0004\b6\u0010\u001cR\u0019\u0010\f\u001a\u0004\u0018\u00010\u000b8\u0006¢\u0006\f\n\u0004\b\f\u00107\u001a\u0004\b8\u0010\u001eR\u0019\u0010\u000e\u001a\u0004\u0018\u00010\r8\u0006¢\u0006\f\n\u0004\b\u000e\u00109\u001a\u0004\b:\u0010 R\u0019\u0010\u0010\u001a\u0004\u0018\u00010\u000f8\u0006¢\u0006\f\n\u0004\b\u0010\u0010;\u001a\u0004\b<\u0010\"R\u0019\u0010\u0011\u001a\u0004\u0018\u00010\u000f8\u0006¢\u0006\f\n\u0004\b\u0011\u0010;\u001a\u0004\b=\u0010\"¨\u0006>"}, m18d2 = {"Lzendesk/conversationkit/android/model/ActivityEvent;", "", "", "conversationId", "Lzendesk/conversationkit/android/model/ActivityData;", "activityData", "userId", "userName", "userAvatarUrl", "Lzendesk/conversationkit/android/model/AuthorType;", "role", "j$/time/LocalDateTime", "lastRead", "Lzendesk/conversationkit/android/internal/faye/WsResponseTimeDto;", "responseTime", "", "queuePosition", "lowestQueuePosition", "<init>", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/ActivityData;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/model/AuthorType;Lj$/time/LocalDateTime;Lzendesk/conversationkit/android/internal/faye/WsResponseTimeDto;Ljava/lang/Long;Ljava/lang/Long;)V", "component1", "()Ljava/lang/String;", "component2", "()Lzendesk/conversationkit/android/model/ActivityData;", "component3", "component4", "component5", "component6", "()Lzendesk/conversationkit/android/model/AuthorType;", "component7", "()Lj$/time/LocalDateTime;", "component8", "()Lzendesk/conversationkit/android/internal/faye/WsResponseTimeDto;", "component9", "()Ljava/lang/Long;", "component10", "copy", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/ActivityData;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/model/AuthorType;Lj$/time/LocalDateTime;Lzendesk/conversationkit/android/internal/faye/WsResponseTimeDto;Ljava/lang/Long;Ljava/lang/Long;)Lzendesk/conversationkit/android/model/ActivityEvent;", "toString", "", "hashCode", "()I", "other", "", "equals", "(Ljava/lang/Object;)Z", "Ljava/lang/String;", "getConversationId", "Lzendesk/conversationkit/android/model/ActivityData;", "getActivityData", "getUserId", "getUserName", "getUserAvatarUrl", "Lzendesk/conversationkit/android/model/AuthorType;", "getRole", "Lj$/time/LocalDateTime;", "getLastRead", "Lzendesk/conversationkit/android/internal/faye/WsResponseTimeDto;", "getResponseTime", "Ljava/lang/Long;", "getQueuePosition", "getLowestQueuePosition", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ActivityEvent {
    private final ActivityData activityData;
    private final String conversationId;
    private final LocalDateTime lastRead;
    private final Long lowestQueuePosition;
    private final Long queuePosition;
    private final WsResponseTimeDto responseTime;
    private final AuthorType role;
    private final String userAvatarUrl;
    private final String userId;
    private final String userName;

    public final String getConversationId() {
        return this.conversationId;
    }

    public final Long getLowestQueuePosition() {
        return this.lowestQueuePosition;
    }

    public final ActivityData getActivityData() {
        return this.activityData;
    }

    public final String getUserId() {
        return this.userId;
    }

    public final String getUserName() {
        return this.userName;
    }

    public final String getUserAvatarUrl() {
        return this.userAvatarUrl;
    }

    public final AuthorType getRole() {
        return this.role;
    }

    public final LocalDateTime getLastRead() {
        return this.lastRead;
    }

    public final WsResponseTimeDto getResponseTime() {
        return this.responseTime;
    }

    public final Long getQueuePosition() {
        return this.queuePosition;
    }

    public final ActivityEvent copy(String conversationId, ActivityData activityData, String userId, String userName, String userAvatarUrl, AuthorType role, LocalDateTime lastRead, WsResponseTimeDto responseTime, Long queuePosition, Long lowestQueuePosition) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        return new ActivityEvent(conversationId, activityData, userId, userName, userAvatarUrl, role, lastRead, responseTime, queuePosition, lowestQueuePosition);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ActivityEvent)) {
            return false;
        }
        ActivityEvent activityEvent = (ActivityEvent) other;
        return Intrinsics.areEqual(this.conversationId, activityEvent.conversationId) && this.activityData == activityEvent.activityData && Intrinsics.areEqual(this.userId, activityEvent.userId) && Intrinsics.areEqual(this.userName, activityEvent.userName) && Intrinsics.areEqual(this.userAvatarUrl, activityEvent.userAvatarUrl) && this.role == activityEvent.role && Intrinsics.areEqual(this.lastRead, activityEvent.lastRead) && Intrinsics.areEqual(this.responseTime, activityEvent.responseTime) && Intrinsics.areEqual(this.queuePosition, activityEvent.queuePosition) && Intrinsics.areEqual(this.lowestQueuePosition, activityEvent.lowestQueuePosition);
    }

    public int hashCode() {
        int iHashCode = this.conversationId.hashCode() * 31;
        ActivityData activityData = this.activityData;
        int iHashCode2 = (iHashCode + (activityData == null ? 0 : activityData.hashCode())) * 31;
        String str = this.userId;
        int iHashCode3 = (iHashCode2 + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.userName;
        int iHashCode4 = (iHashCode3 + (str2 == null ? 0 : str2.hashCode())) * 31;
        String str3 = this.userAvatarUrl;
        int iHashCode5 = (iHashCode4 + (str3 == null ? 0 : str3.hashCode())) * 31;
        AuthorType authorType = this.role;
        int iHashCode6 = (iHashCode5 + (authorType == null ? 0 : authorType.hashCode())) * 31;
        LocalDateTime localDateTime = this.lastRead;
        int iHashCode7 = (iHashCode6 + (localDateTime == null ? 0 : localDateTime.hashCode())) * 31;
        WsResponseTimeDto wsResponseTimeDto = this.responseTime;
        int iHashCode8 = (iHashCode7 + (wsResponseTimeDto == null ? 0 : wsResponseTimeDto.hashCode())) * 31;
        Long l = this.queuePosition;
        int iHashCode9 = (iHashCode8 + (l == null ? 0 : l.hashCode())) * 31;
        Long l2 = this.lowestQueuePosition;
        return iHashCode9 + (l2 != null ? l2.hashCode() : 0);
    }

    public String toString() {
        return "ActivityEvent(conversationId=" + this.conversationId + ", activityData=" + this.activityData + ", userId=" + this.userId + ", userName=" + this.userName + ", userAvatarUrl=" + this.userAvatarUrl + ", role=" + this.role + ", lastRead=" + this.lastRead + ", responseTime=" + this.responseTime + ", queuePosition=" + this.queuePosition + ", lowestQueuePosition=" + this.lowestQueuePosition + ')';
    }

    public ActivityEvent(String conversationId, ActivityData activityData, String str, String str2, String str3, AuthorType authorType, LocalDateTime localDateTime, WsResponseTimeDto wsResponseTimeDto, Long l, Long l2) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        this.conversationId = conversationId;
        this.activityData = activityData;
        this.userId = str;
        this.userName = str2;
        this.userAvatarUrl = str3;
        this.role = authorType;
        this.lastRead = localDateTime;
        this.responseTime = wsResponseTimeDto;
        this.queuePosition = l;
        this.lowestQueuePosition = l2;
    }

    public ActivityEvent(String str, ActivityData activityData, String str2, String str3, String str4, AuthorType authorType, LocalDateTime localDateTime, WsResponseTimeDto wsResponseTimeDto, Long l, Long l2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, activityData, str2, str3, str4, authorType, localDateTime, (i & 128) != 0 ? null : wsResponseTimeDto, l, l2);
    }

    public final String getConversationId() {
        return this.conversationId;
    }

    public final ActivityData getActivityData() {
        return this.activityData;
    }

    public final String getUserId() {
        return this.userId;
    }

    public final String getUserName() {
        return this.userName;
    }

    public final String getUserAvatarUrl() {
        return this.userAvatarUrl;
    }

    public final AuthorType getRole() {
        return this.role;
    }

    public final LocalDateTime getLastRead() {
        return this.lastRead;
    }

    public final WsResponseTimeDto getResponseTime() {
        return this.responseTime;
    }

    public final Long getQueuePosition() {
        return this.queuePosition;
    }

    public final Long getLowestQueuePosition() {
        return this.lowestQueuePosition;
    }
}
