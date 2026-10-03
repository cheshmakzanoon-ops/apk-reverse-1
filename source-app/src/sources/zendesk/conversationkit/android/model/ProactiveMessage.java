package zendesk.conversationkit.android.model;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.random.Random;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0012\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 ,2\u00020\u0001:\u0002+,BQ\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0006\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0006\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0006\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\u0002\u0010\rB7\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\u0006\u0010\b\u001a\u00020\u0006\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u0006¢\u0006\u0002\u0010\u000eJ\t\u0010\u0017\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0006HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0006HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0006HÆ\u0003J\t\u0010\u001b\u001a\u00020\u0003HÆ\u0003J\t\u0010\u001c\u001a\u00020\u0006HÆ\u0003JE\u0010\u001d\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\u00062\b\b\u0002\u0010\b\u001a\u00020\u00062\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u001e\u001a\u00020\u001f2\b\u0010 \u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010!\u001a\u00020\u0003HÖ\u0001J\t\u0010\"\u001a\u00020\u0006HÖ\u0001J&\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020\u00002\u0006\u0010&\u001a\u00020'2\u0006\u0010(\u001a\u00020)HÁ\u0001¢\u0006\u0002\b*R\u0011\u0010\u0007\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0011\u0010\b\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u0011\u0010\t\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0013R\u0011\u0010\n\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0010R\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0010¨\u0006-"}, m18d2 = {"Lzendesk/conversationkit/android/model/ProactiveMessage;", "", "seen1", "", "id", "title", "", "body", "campaignId", "campaignVersion", "jwt", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V", "getBody", "()Ljava/lang/String;", "getCampaignId", "getCampaignVersion", "()I", "getId", "getJwt", "getTitle", "component1", "component2", "component3", "component4", "component5", "component6", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ProactiveMessage {

    public static final Companion INSTANCE = new Companion(null);
    private final String body;
    private final String campaignId;
    private final int campaignVersion;
    private final int id;
    private final String jwt;
    private final String title;

    public static ProactiveMessage copy$default(ProactiveMessage proactiveMessage, int i, String str, String str2, String str3, int i2, String str4, int i3, Object obj) {
        if ((i3 & 1) != 0) {
            i = proactiveMessage.id;
        }
        if ((i3 & 2) != 0) {
            str = proactiveMessage.title;
        }
        String str5 = str;
        if ((i3 & 4) != 0) {
            str2 = proactiveMessage.body;
        }
        String str6 = str2;
        if ((i3 & 8) != 0) {
            str3 = proactiveMessage.campaignId;
        }
        String str7 = str3;
        if ((i3 & 16) != 0) {
            i2 = proactiveMessage.campaignVersion;
        }
        int i4 = i2;
        if ((i3 & 32) != 0) {
            str4 = proactiveMessage.jwt;
        }
        return proactiveMessage.copy(i, str5, str6, str7, i4, str4);
    }

    public final int getId() {
        return this.id;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getBody() {
        return this.body;
    }

    public final String getCampaignId() {
        return this.campaignId;
    }

    public final int getCampaignVersion() {
        return this.campaignVersion;
    }

    public final String getJwt() {
        return this.jwt;
    }

    public final ProactiveMessage copy(int id, String title, String body, String campaignId, int campaignVersion, String jwt) {
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(body, "body");
        Intrinsics.checkNotNullParameter(campaignId, "campaignId");
        Intrinsics.checkNotNullParameter(jwt, "jwt");
        return new ProactiveMessage(id, title, body, campaignId, campaignVersion, jwt);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ProactiveMessage)) {
            return false;
        }
        ProactiveMessage proactiveMessage = (ProactiveMessage) other;
        return this.id == proactiveMessage.id && Intrinsics.areEqual(this.title, proactiveMessage.title) && Intrinsics.areEqual(this.body, proactiveMessage.body) && Intrinsics.areEqual(this.campaignId, proactiveMessage.campaignId) && this.campaignVersion == proactiveMessage.campaignVersion && Intrinsics.areEqual(this.jwt, proactiveMessage.jwt);
    }

    public int hashCode() {
        return (((((((((this.id * 31) + this.title.hashCode()) * 31) + this.body.hashCode()) * 31) + this.campaignId.hashCode()) * 31) + this.campaignVersion) * 31) + this.jwt.hashCode();
    }

    public String toString() {
        return "ProactiveMessage(id=" + this.id + ", title=" + this.title + ", body=" + this.body + ", campaignId=" + this.campaignId + ", campaignVersion=" + this.campaignVersion + ", jwt=" + this.jwt + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/ProactiveMessage$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ProactiveMessage> serializer() {
            return ProactiveMessage$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ProactiveMessage(int i, int i2, String str, String str2, String str3, int i3, String str4, SerializationConstructorMarker serializationConstructorMarker) {
        if (62 != (i & 62)) {
            PluginExceptionsKt.throwMissingFieldException(i, 62, ProactiveMessage$$serializer.INSTANCE.getDescriptor());
        }
        if ((i & 1) == 0) {
            this.id = Random.INSTANCE.nextInt();
        } else {
            this.id = i2;
        }
        this.title = str;
        this.body = str2;
        this.campaignId = str3;
        this.campaignVersion = i3;
        this.jwt = str4;
    }

    public ProactiveMessage(int i, String title, String body, String campaignId, int i2, String jwt) {
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(body, "body");
        Intrinsics.checkNotNullParameter(campaignId, "campaignId");
        Intrinsics.checkNotNullParameter(jwt, "jwt");
        this.id = i;
        this.title = title;
        this.body = body;
        this.campaignId = campaignId;
        this.campaignVersion = i2;
        this.jwt = jwt;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(ProactiveMessage self, CompositeEncoder output, SerialDescriptor serialDesc) {
        if (output.shouldEncodeElementDefault(serialDesc, 0) || self.id != Random.INSTANCE.nextInt()) {
            output.encodeIntElement(serialDesc, 0, self.id);
        }
        output.encodeStringElement(serialDesc, 1, self.title);
        output.encodeStringElement(serialDesc, 2, self.body);
        output.encodeStringElement(serialDesc, 3, self.campaignId);
        output.encodeIntElement(serialDesc, 4, self.campaignVersion);
        output.encodeStringElement(serialDesc, 5, self.jwt);
    }

    public ProactiveMessage(int i, String str, String str2, String str3, int i2, String str4, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this((i3 & 1) != 0 ? Random.INSTANCE.nextInt() : i, str, str2, str3, i2, str4);
    }

    public final int getId() {
        return this.id;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getBody() {
        return this.body;
    }

    public final String getCampaignId() {
        return this.campaignId;
    }

    public final int getCampaignVersion() {
        return this.campaignVersion;
    }

    public final String getJwt() {
        return this.jwt;
    }
}
