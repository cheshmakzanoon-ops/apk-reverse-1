package zendesk.messaging.android.push.internal;

import androidx.compose.animation.core.ComplexDouble$;
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
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0010\u0006\n\u0002\b\u0005\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b!\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 B2\u00020\u0001:\u0002ABB\u0087\u0001\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011\u0012\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\u0002\u0010\u0014Bi\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\u0005\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\u0002\u0010\u0015J\t\u0010'\u001a\u00020\u0005HÆ\u0003J\u000b\u0010(\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u0010\u0010)\u001a\u0004\u0018\u00010\u0011HÆ\u0003¢\u0006\u0002\u0010\u001dJ\t\u0010*\u001a\u00020\u0005HÆ\u0003J\t\u0010+\u001a\u00020\u0005HÆ\u0003J\u000b\u0010,\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010-\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010.\u001a\u00020\u000bHÆ\u0003J\t\u0010/\u001a\u00020\u0005HÆ\u0003J\u000b\u00100\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u00101\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u0088\u0001\u00102\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\u00052\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÆ\u0001¢\u0006\u0002\u00103J\u0013\u00104\u001a\u0002052\b\u00106\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00107\u001a\u00020\u0003HÖ\u0001J\t\u00108\u001a\u00020\u0005HÖ\u0001J&\u00109\u001a\u00020:2\u0006\u0010;\u001a\u00020\u00002\u0006\u0010<\u001a\u00020=2\u0006\u0010>\u001a\u00020?HÁ\u0001¢\u0006\u0002\b@R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0013\u0010\t\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0017R\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0019\u0010\u001a\u001a\u0004\b\u001b\u0010\u0017R\u0015\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\n\n\u0002\u0010\u001e\u001a\u0004\b\u001c\u0010\u001dR\u0013\u0010\u000f\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u0017R\u0013\u0010\u000e\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u0017R\u0013\u0010\b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\u0017R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010#R\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u0017R\u0013\u0010\r\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b%\u0010\u0017R\u0011\u0010\f\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b&\u0010\u0017¨\u0006C"}, m18d2 = {"Lzendesk/messaging/android/push/internal/MessagePayload;", "", "seen1", "", "id", "", "authorId", "role", "name", "avatarUrl", "received", "", "type", "text", "mediaUrl", "mediaType", "mediaSize", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Long;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Long;)V", "getAuthorId", "()Ljava/lang/String;", "getAvatarUrl", "getId$annotations", "()V", "getId", "getMediaSize", "()Ljava/lang/Long;", "Ljava/lang/Long;", "getMediaType", "getMediaUrl", "getName", "getReceived", "()D", "getRole", "getText", "getType", "component1", "component10", "component11", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Long;)Lzendesk/messaging/android/push/internal/MessagePayload;", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_messaging_messaging_android", "$serializer", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class MessagePayload {

    public static final Companion INSTANCE = new Companion(null);
    private final String authorId;
    private final String avatarUrl;
    private final String id;
    private final Long mediaSize;
    private final String mediaType;
    private final String mediaUrl;
    private final String name;
    private final double received;
    private final String role;
    private final String text;
    private final String type;

    @SerialName("_id")
    public static void getId$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final String getMediaType() {
        return this.mediaType;
    }

    public final Long getMediaSize() {
        return this.mediaSize;
    }

    public final String getAuthorId() {
        return this.authorId;
    }

    public final String getRole() {
        return this.role;
    }

    public final String getName() {
        return this.name;
    }

    public final String getAvatarUrl() {
        return this.avatarUrl;
    }

    public final double getReceived() {
        return this.received;
    }

    public final String getType() {
        return this.type;
    }

    public final String getText() {
        return this.text;
    }

    public final String getMediaUrl() {
        return this.mediaUrl;
    }

    public final MessagePayload copy(String id, String authorId, String role, String name, String avatarUrl, double received, String type, String text, String mediaUrl, String mediaType, Long mediaSize) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(authorId, "authorId");
        Intrinsics.checkNotNullParameter(role, "role");
        Intrinsics.checkNotNullParameter(type, "type");
        return new MessagePayload(id, authorId, role, name, avatarUrl, received, type, text, mediaUrl, mediaType, mediaSize);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessagePayload)) {
            return false;
        }
        MessagePayload messagePayload = (MessagePayload) other;
        return Intrinsics.areEqual(this.id, messagePayload.id) && Intrinsics.areEqual(this.authorId, messagePayload.authorId) && Intrinsics.areEqual(this.role, messagePayload.role) && Intrinsics.areEqual(this.name, messagePayload.name) && Intrinsics.areEqual(this.avatarUrl, messagePayload.avatarUrl) && Double.compare(this.received, messagePayload.received) == 0 && Intrinsics.areEqual(this.type, messagePayload.type) && Intrinsics.areEqual(this.text, messagePayload.text) && Intrinsics.areEqual(this.mediaUrl, messagePayload.mediaUrl) && Intrinsics.areEqual(this.mediaType, messagePayload.mediaType) && Intrinsics.areEqual(this.mediaSize, messagePayload.mediaSize);
    }

    public int hashCode() {
        int iHashCode = ((((this.id.hashCode() * 31) + this.authorId.hashCode()) * 31) + this.role.hashCode()) * 31;
        String str = this.name;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.avatarUrl;
        int iHashCode3 = (((((iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31) + ComplexDouble$.ExternalSyntheticBackport0.m(this.received)) * 31) + this.type.hashCode()) * 31;
        String str3 = this.text;
        int iHashCode4 = (iHashCode3 + (str3 == null ? 0 : str3.hashCode())) * 31;
        String str4 = this.mediaUrl;
        int iHashCode5 = (iHashCode4 + (str4 == null ? 0 : str4.hashCode())) * 31;
        String str5 = this.mediaType;
        int iHashCode6 = (iHashCode5 + (str5 == null ? 0 : str5.hashCode())) * 31;
        Long l = this.mediaSize;
        return iHashCode6 + (l != null ? l.hashCode() : 0);
    }

    public String toString() {
        return "MessagePayload(id=" + this.id + ", authorId=" + this.authorId + ", role=" + this.role + ", name=" + this.name + ", avatarUrl=" + this.avatarUrl + ", received=" + this.received + ", type=" + this.type + ", text=" + this.text + ", mediaUrl=" + this.mediaUrl + ", mediaType=" + this.mediaType + ", mediaSize=" + this.mediaSize + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/push/internal/MessagePayload$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/messaging/android/push/internal/MessagePayload;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<MessagePayload> serializer() {
            return MessagePayload$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public MessagePayload(int i, @SerialName("_id") String str, String str2, String str3, String str4, String str5, double d, String str6, String str7, String str8, String str9, Long l, SerializationConstructorMarker serializationConstructorMarker) {
        if (2047 != (i & 2047)) {
            PluginExceptionsKt.throwMissingFieldException(i, 2047, MessagePayload$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.authorId = str2;
        this.role = str3;
        this.name = str4;
        this.avatarUrl = str5;
        this.received = d;
        this.type = str6;
        this.text = str7;
        this.mediaUrl = str8;
        this.mediaType = str9;
        this.mediaSize = l;
    }

    public MessagePayload(String id, String authorId, String role, String str, String str2, double d, String type, String str3, String str4, String str5, Long l) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(authorId, "authorId");
        Intrinsics.checkNotNullParameter(role, "role");
        Intrinsics.checkNotNullParameter(type, "type");
        this.id = id;
        this.authorId = authorId;
        this.role = role;
        this.name = str;
        this.avatarUrl = str2;
        this.received = d;
        this.type = type;
        this.text = str3;
        this.mediaUrl = str4;
        this.mediaType = str5;
        this.mediaSize = l;
    }

    @JvmStatic
    public static final void write$Self$zendesk_messaging_messaging_android(MessagePayload self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeStringElement(serialDesc, 1, self.authorId);
        output.encodeStringElement(serialDesc, 2, self.role);
        output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.name);
        output.encodeNullableSerializableElement(serialDesc, 4, StringSerializer.INSTANCE, self.avatarUrl);
        output.encodeDoubleElement(serialDesc, 5, self.received);
        output.encodeStringElement(serialDesc, 6, self.type);
        output.encodeNullableSerializableElement(serialDesc, 7, StringSerializer.INSTANCE, self.text);
        output.encodeNullableSerializableElement(serialDesc, 8, StringSerializer.INSTANCE, self.mediaUrl);
        output.encodeNullableSerializableElement(serialDesc, 9, StringSerializer.INSTANCE, self.mediaType);
        output.encodeNullableSerializableElement(serialDesc, 10, LongSerializer.INSTANCE, self.mediaSize);
    }

    public final String getId() {
        return this.id;
    }

    public final String getAuthorId() {
        return this.authorId;
    }

    public final String getRole() {
        return this.role;
    }

    public final String getName() {
        return this.name;
    }

    public final String getAvatarUrl() {
        return this.avatarUrl;
    }

    public final double getReceived() {
        return this.received;
    }

    public final String getType() {
        return this.type;
    }

    public final String getText() {
        return this.text;
    }

    public final String getMediaUrl() {
        return this.mediaUrl;
    }

    public final String getMediaType() {
        return this.mediaType;
    }

    public final Long getMediaSize() {
        return this.mediaSize;
    }
}
