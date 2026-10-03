package zendesk.messaging.android.internal.conversationslistscreen.conversation.cache;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 \"2\u00020\u0001:\u0002!\"B7\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB!\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0007\u001a\u00020\u0005¢\u0006\u0002\u0010\u000bJ\t\u0010\u0010\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0005HÆ\u0003J'\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0018\u001a\u00020\u0005HÖ\u0001J&\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u00002\u0006\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u001fHÁ\u0001¢\u0006\u0002\b R\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\rR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\r¨\u0006#"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListUIPersistenceItem;", "", "seen1", "", "conversationId", "", "participantName", "avatarUrl", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getAvatarUrl", "()Ljava/lang/String;", "getConversationId", "getParticipantName", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_messaging_messaging_android", "$serializer", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ConversationsListUIPersistenceItem {

    public static final Companion INSTANCE = new Companion(null);
    private final String avatarUrl;
    private final String conversationId;
    private final String participantName;

    public static ConversationsListUIPersistenceItem copy$default(ConversationsListUIPersistenceItem conversationsListUIPersistenceItem, String str, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = conversationsListUIPersistenceItem.conversationId;
        }
        if ((i & 2) != 0) {
            str2 = conversationsListUIPersistenceItem.participantName;
        }
        if ((i & 4) != 0) {
            str3 = conversationsListUIPersistenceItem.avatarUrl;
        }
        return conversationsListUIPersistenceItem.copy(str, str2, str3);
    }

    public final String getConversationId() {
        return this.conversationId;
    }

    public final String getParticipantName() {
        return this.participantName;
    }

    public final String getAvatarUrl() {
        return this.avatarUrl;
    }

    public final ConversationsListUIPersistenceItem copy(String conversationId, String participantName, String avatarUrl) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        Intrinsics.checkNotNullParameter(participantName, "participantName");
        Intrinsics.checkNotNullParameter(avatarUrl, "avatarUrl");
        return new ConversationsListUIPersistenceItem(conversationId, participantName, avatarUrl);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ConversationsListUIPersistenceItem)) {
            return false;
        }
        ConversationsListUIPersistenceItem conversationsListUIPersistenceItem = (ConversationsListUIPersistenceItem) other;
        return Intrinsics.areEqual(this.conversationId, conversationsListUIPersistenceItem.conversationId) && Intrinsics.areEqual(this.participantName, conversationsListUIPersistenceItem.participantName) && Intrinsics.areEqual(this.avatarUrl, conversationsListUIPersistenceItem.avatarUrl);
    }

    public int hashCode() {
        return (((this.conversationId.hashCode() * 31) + this.participantName.hashCode()) * 31) + this.avatarUrl.hashCode();
    }

    public String toString() {
        return "ConversationsListUIPersistenceItem(conversationId=" + this.conversationId + ", participantName=" + this.participantName + ", avatarUrl=" + this.avatarUrl + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListUIPersistenceItem$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListUIPersistenceItem;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ConversationsListUIPersistenceItem> serializer() {
            return ConversationsListUIPersistenceItem$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ConversationsListUIPersistenceItem(int i, String str, String str2, String str3, SerializationConstructorMarker serializationConstructorMarker) {
        if (1 != (i & 1)) {
            PluginExceptionsKt.throwMissingFieldException(i, 1, ConversationsListUIPersistenceItem$$serializer.INSTANCE.getDescriptor());
        }
        this.conversationId = str;
        if ((i & 2) == 0) {
            this.participantName = "";
        } else {
            this.participantName = str2;
        }
        if ((i & 4) == 0) {
            this.avatarUrl = "";
        } else {
            this.avatarUrl = str3;
        }
    }

    public ConversationsListUIPersistenceItem(String conversationId, String participantName, String avatarUrl) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        Intrinsics.checkNotNullParameter(participantName, "participantName");
        Intrinsics.checkNotNullParameter(avatarUrl, "avatarUrl");
        this.conversationId = conversationId;
        this.participantName = participantName;
        this.avatarUrl = avatarUrl;
    }

    @JvmStatic
    public static final void write$Self$zendesk_messaging_messaging_android(ConversationsListUIPersistenceItem self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.conversationId);
        if (output.shouldEncodeElementDefault(serialDesc, 1) || !Intrinsics.areEqual(self.participantName, "")) {
            output.encodeStringElement(serialDesc, 1, self.participantName);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 2) && Intrinsics.areEqual(self.avatarUrl, "")) {
            return;
        }
        output.encodeStringElement(serialDesc, 2, self.avatarUrl);
    }

    public ConversationsListUIPersistenceItem(String str, String str2, String str3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, (i & 2) != 0 ? "" : str2, (i & 4) != 0 ? "" : str3);
    }

    public final String getConversationId() {
        return this.conversationId;
    }

    public final String getParticipantName() {
        return this.participantName;
    }

    public final String getAvatarUrl() {
        return this.avatarUrl;
    }
}
