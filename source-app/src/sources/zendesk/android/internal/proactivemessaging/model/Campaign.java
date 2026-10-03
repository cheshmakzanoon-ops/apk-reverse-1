package zendesk.android.internal.proactivemessaging.model;

import cz.msebera.android.httpclient.cookie.ClientCookie;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import zendesk.android.pageviewevents.PageView;
import zendesk.conversationkit.android.model.VisitType;

@Metadata(m17d1 = {"\u0000t\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u001c\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 D2\u00020\u0001:\u0002CDBg\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0001\u0010\b\u001a\u0004\u0018\u00010\t\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b\u0012\b\u0010\f\u001a\u0004\u0018\u00010\r\u0012\u000e\u0010\u000e\u001a\n\u0012\u0004\u0012\u00020\u0010\u0018\u00010\u000f\u0012\u0006\u0010\u0011\u001a\u00020\u0003\u0012\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\u0002\u0010\u0014BC\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r\u0012\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00100\u000f\u0012\u0006\u0010\u0011\u001a\u00020\u0003¢\u0006\u0002\u0010\u0015J\t\u0010'\u001a\u00020\u0005HÆ\u0003J\t\u0010(\u001a\u00020\u0007HÆ\u0003J\t\u0010)\u001a\u00020\tHÆ\u0003J\t\u0010*\u001a\u00020\u000bHÆ\u0003J\t\u0010+\u001a\u00020\rHÆ\u0003J\u000f\u0010,\u001a\b\u0012\u0004\u0012\u00020\u00100\u000fHÆ\u0003J\t\u0010-\u001a\u00020\u0003HÆ\u0003JU\u0010.\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\u000e\b\u0002\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00100\u000f2\b\b\u0002\u0010\u0011\u001a\u00020\u0003HÆ\u0001J\u0013\u0010/\u001a\u0002002\b\u00101\u001a\u0004\u0018\u00010\u0001HÖ\u0003J$\u00102\u001a\b\u0012\u0004\u0012\u00020\u00100\u000f2\u0006\u00103\u001a\u0002042\u0006\u00105\u001a\u0002062\u0006\u00107\u001a\u000208J\t\u00109\u001a\u00020\u0003HÖ\u0001J\t\u0010:\u001a\u00020\u0005HÖ\u0001J&\u0010;\u001a\u00020<2\u0006\u0010=\u001a\u00020\u00002\u0006\u0010>\u001a\u00020?2\u0006\u0010@\u001a\u00020AHÁ\u0001¢\u0006\u0002\bBR\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0016\u0010\u0017\u001a\u0004\b\u0018\u0010\u0019R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001bR\u0017\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00100\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b \u0010!R\u001c\u0010\b\u001a\u00020\t8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\"\u0010\u0017\u001a\u0004\b#\u0010$R\u0011\u0010\u0011\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b%\u0010&¨\u0006E"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Campaign;", "", "seen1", "", "campaignId", "", "integration", "Lzendesk/android/internal/proactivemessaging/model/Integration;", "trigger", "Lzendesk/android/internal/proactivemessaging/model/Trigger;", "schedule", "Lzendesk/android/internal/proactivemessaging/model/Schedule;", "status", "Lzendesk/android/internal/proactivemessaging/model/Status;", "paths", "", "Lzendesk/android/internal/proactivemessaging/model/Path;", ClientCookie.VERSION_ATTR, "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Lzendesk/android/internal/proactivemessaging/model/Integration;Lzendesk/android/internal/proactivemessaging/model/Trigger;Lzendesk/android/internal/proactivemessaging/model/Schedule;Lzendesk/android/internal/proactivemessaging/model/Status;Ljava/util/List;ILkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Lzendesk/android/internal/proactivemessaging/model/Integration;Lzendesk/android/internal/proactivemessaging/model/Trigger;Lzendesk/android/internal/proactivemessaging/model/Schedule;Lzendesk/android/internal/proactivemessaging/model/Status;Ljava/util/List;I)V", "getCampaignId$annotations", "()V", "getCampaignId", "()Ljava/lang/String;", "getIntegration", "()Lzendesk/android/internal/proactivemessaging/model/Integration;", "getPaths", "()Ljava/util/List;", "getSchedule", "()Lzendesk/android/internal/proactivemessaging/model/Schedule;", "getStatus", "()Lzendesk/android/internal/proactivemessaging/model/Status;", "getTrigger$annotations", "getTrigger", "()Lzendesk/android/internal/proactivemessaging/model/Trigger;", "getVersion", "()I", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "", "other", "evaluate", "event", "Lzendesk/android/pageviewevents/PageView;", "locale", "Ljava/util/Locale;", "visitType", "Lzendesk/conversationkit/android/model/VisitType;", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class Campaign {
    private final String campaignId;
    private final Integration integration;
    private final List<Path> paths;
    private final Schedule schedule;
    private final Status status;
    private final Trigger trigger;
    private final int version;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, null, new ArrayListSerializer(Path$$serializer.INSTANCE), null};

    public static Campaign copy$default(Campaign campaign, String str, Integration integration, Trigger trigger, Schedule schedule, Status status, List list, int i, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            str = campaign.campaignId;
        }
        if ((i2 & 2) != 0) {
            integration = campaign.integration;
        }
        Integration integration2 = integration;
        if ((i2 & 4) != 0) {
            trigger = campaign.trigger;
        }
        Trigger trigger2 = trigger;
        if ((i2 & 8) != 0) {
            schedule = campaign.schedule;
        }
        Schedule schedule2 = schedule;
        if ((i2 & 16) != 0) {
            status = campaign.status;
        }
        Status status2 = status;
        if ((i2 & 32) != 0) {
            list = campaign.paths;
        }
        List list2 = list;
        if ((i2 & 64) != 0) {
            i = campaign.version;
        }
        return campaign.copy(str, integration2, trigger2, schedule2, status2, list2, i);
    }

    @SerialName("campaign_id")
    public static void getCampaignId$annotations() {
    }

    @SerialName("when")
    public static void getTrigger$annotations() {
    }

    public final String getCampaignId() {
        return this.campaignId;
    }

    public final Integration getIntegration() {
        return this.integration;
    }

    public final Trigger getTrigger() {
        return this.trigger;
    }

    public final Schedule getSchedule() {
        return this.schedule;
    }

    public final Status getStatus() {
        return this.status;
    }

    public final List<Path> component6() {
        return this.paths;
    }

    public final int getVersion() {
        return this.version;
    }

    public final Campaign copy(String campaignId, Integration integration, Trigger trigger, Schedule schedule, Status status, List<Path> paths, int version) {
        Intrinsics.checkNotNullParameter(campaignId, "campaignId");
        Intrinsics.checkNotNullParameter(integration, "integration");
        Intrinsics.checkNotNullParameter(trigger, "trigger");
        Intrinsics.checkNotNullParameter(schedule, "schedule");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(paths, "paths");
        return new Campaign(campaignId, integration, trigger, schedule, status, paths, version);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Campaign)) {
            return false;
        }
        Campaign campaign = (Campaign) other;
        return Intrinsics.areEqual(this.campaignId, campaign.campaignId) && Intrinsics.areEqual(this.integration, campaign.integration) && Intrinsics.areEqual(this.trigger, campaign.trigger) && Intrinsics.areEqual(this.schedule, campaign.schedule) && this.status == campaign.status && Intrinsics.areEqual(this.paths, campaign.paths) && this.version == campaign.version;
    }

    public int hashCode() {
        return (((((((((((this.campaignId.hashCode() * 31) + this.integration.hashCode()) * 31) + this.trigger.hashCode()) * 31) + this.schedule.hashCode()) * 31) + this.status.hashCode()) * 31) + this.paths.hashCode()) * 31) + this.version;
    }

    public String toString() {
        return "Campaign(campaignId=" + this.campaignId + ", integration=" + this.integration + ", trigger=" + this.trigger + ", schedule=" + this.schedule + ", status=" + this.status + ", paths=" + this.paths + ", version=" + this.version + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Campaign$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Campaign;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<Campaign> serializer() {
            return Campaign$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public Campaign(int i, @SerialName("campaign_id") String str, Integration integration, @SerialName("when") Trigger trigger, Schedule schedule, Status status, List list, int i2, SerializationConstructorMarker serializationConstructorMarker) {
        if (127 != (i & 127)) {
            PluginExceptionsKt.throwMissingFieldException(i, 127, Campaign$$serializer.INSTANCE.getDescriptor());
        }
        this.campaignId = str;
        this.integration = integration;
        this.trigger = trigger;
        this.schedule = schedule;
        this.status = status;
        this.paths = list;
        this.version = i2;
    }

    public Campaign(String campaignId, Integration integration, Trigger trigger, Schedule schedule, Status status, List<Path> paths, int i) {
        Intrinsics.checkNotNullParameter(campaignId, "campaignId");
        Intrinsics.checkNotNullParameter(integration, "integration");
        Intrinsics.checkNotNullParameter(trigger, "trigger");
        Intrinsics.checkNotNullParameter(schedule, "schedule");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(paths, "paths");
        this.campaignId = campaignId;
        this.integration = integration;
        this.trigger = trigger;
        this.schedule = schedule;
        this.status = status;
        this.paths = paths;
        this.version = i;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(Campaign self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.campaignId);
        output.encodeSerializableElement(serialDesc, 1, Integration$$serializer.INSTANCE, self.integration);
        output.encodeSerializableElement(serialDesc, 2, Trigger$$serializer.INSTANCE, self.trigger);
        output.encodeSerializableElement(serialDesc, 3, Schedule$$serializer.INSTANCE, self.schedule);
        output.encodeSerializableElement(serialDesc, 4, Status.StatusSerializer.INSTANCE, self.status);
        output.encodeSerializableElement(serialDesc, 5, kSerializerArr[5], self.paths);
        output.encodeIntElement(serialDesc, 6, self.version);
    }

    public final String getCampaignId() {
        return this.campaignId;
    }

    public final Integration getIntegration() {
        return this.integration;
    }

    public final Trigger getTrigger() {
        return this.trigger;
    }

    public final Schedule getSchedule() {
        return this.schedule;
    }

    public final Status getStatus() {
        return this.status;
    }

    public final List<Path> getPaths() {
        return this.paths;
    }

    public final int getVersion() {
        return this.version;
    }

    public final List<Path> evaluate(PageView event, Locale locale, VisitType visitType) {
        boolean z;
        Intrinsics.checkNotNullParameter(event, "event");
        Intrinsics.checkNotNullParameter(locale, "locale");
        Intrinsics.checkNotNullParameter(visitType, "visitType");
        ArrayList arrayList = new ArrayList();
        for (Path path : this.paths) {
            Iterator<T> it = path.getCondition().getExpressions().iterator();
            while (true) {
                z = true;
                while (true) {
                    if (!it.hasNext()) {
                        break;
                    }
                    Expression expression = (Expression) it.next();
                    if (!z || !expression.evaluate$zendesk_zendesk_android(event, locale, visitType)) {
                        z = false;
                    }
                }
            }
            if (z) {
                arrayList.add(path);
            }
        }
        return arrayList;
    }
}
