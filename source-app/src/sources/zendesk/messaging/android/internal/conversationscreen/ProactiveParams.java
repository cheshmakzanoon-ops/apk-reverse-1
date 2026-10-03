package zendesk.messaging.android.internal.conversationscreen;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\b\u0080\b\u0018\u00002\u00020\u0001B\u001d\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0005J\u0010\u0010\r\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\u0007J\u0010\u0010\u000e\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\u0007J&\u0010\u000f\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003HÆ\u0001¢\u0006\u0002\u0010\u0010J\u0013\u0010\u0011\u001a\u00020\u00122\b\u0010\u0013\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001R\u001e\u0010\u0004\u001a\u0004\u0018\u00010\u0003X\u0086\u000e¢\u0006\u0010\n\u0002\u0010\n\u001a\u0004\b\u0006\u0010\u0007\"\u0004\b\b\u0010\tR\u001e\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0086\u000e¢\u0006\u0010\n\u0002\u0010\n\u001a\u0004\b\u000b\u0010\u0007\"\u0004\b\f\u0010\t¨\u0006\u0017"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ProactiveParams;", "", "proactiveNotificationId", "", "hasSendReferralInfo", "(Ljava/lang/Integer;Ljava/lang/Integer;)V", "getHasSendReferralInfo", "()Ljava/lang/Integer;", "setHasSendReferralInfo", "(Ljava/lang/Integer;)V", "Ljava/lang/Integer;", "getProactiveNotificationId", "setProactiveNotificationId", "component1", "component2", "copy", "(Ljava/lang/Integer;Ljava/lang/Integer;)Lzendesk/messaging/android/internal/conversationscreen/ProactiveParams;", "equals", "", "other", "hashCode", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ProactiveParams {
    private Integer hasSendReferralInfo;
    private Integer proactiveNotificationId;

    public ProactiveParams() {
        this(null, 0 == true ? 1 : 0, 3, 0 == true ? 1 : 0);
    }

    public static ProactiveParams copy$default(ProactiveParams proactiveParams, Integer num, Integer num2, int i, Object obj) {
        if ((i & 1) != 0) {
            num = proactiveParams.proactiveNotificationId;
        }
        if ((i & 2) != 0) {
            num2 = proactiveParams.hasSendReferralInfo;
        }
        return proactiveParams.copy(num, num2);
    }

    public final Integer getProactiveNotificationId() {
        return this.proactiveNotificationId;
    }

    public final Integer getHasSendReferralInfo() {
        return this.hasSendReferralInfo;
    }

    public final ProactiveParams copy(Integer proactiveNotificationId, Integer hasSendReferralInfo) {
        return new ProactiveParams(proactiveNotificationId, hasSendReferralInfo);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ProactiveParams)) {
            return false;
        }
        ProactiveParams proactiveParams = (ProactiveParams) other;
        return Intrinsics.areEqual(this.proactiveNotificationId, proactiveParams.proactiveNotificationId) && Intrinsics.areEqual(this.hasSendReferralInfo, proactiveParams.hasSendReferralInfo);
    }

    public int hashCode() {
        Integer num = this.proactiveNotificationId;
        int iHashCode = (num == null ? 0 : num.hashCode()) * 31;
        Integer num2 = this.hasSendReferralInfo;
        return iHashCode + (num2 != null ? num2.hashCode() : 0);
    }

    public String toString() {
        return "ProactiveParams(proactiveNotificationId=" + this.proactiveNotificationId + ", hasSendReferralInfo=" + this.hasSendReferralInfo + ')';
    }

    public ProactiveParams(Integer num, Integer num2) {
        this.proactiveNotificationId = num;
        this.hasSendReferralInfo = num2;
    }

    public ProactiveParams(Integer num, Integer num2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : num, (i & 2) != 0 ? null : num2);
    }

    public final Integer getProactiveNotificationId() {
        return this.proactiveNotificationId;
    }

    public final void setProactiveNotificationId(Integer num) {
        this.proactiveNotificationId = num;
    }

    public final Integer getHasSendReferralInfo() {
        return this.hasSendReferralInfo;
    }

    public final void setHasSendReferralInfo(Integer num) {
        this.hasSendReferralInfo = num;
    }
}
