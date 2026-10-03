package zendesk.conversationkit.android.model;

import java.util.List;
import java.util.Map;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlinx.serialization.ContextualSerializer;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0016\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 62\u00020\u0001:\u000256Bv\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u0007\u001a\n\u0012\u0004\u0012\u00020\t\u0018\u00010\b\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b\u0012\u0019\u0010\f\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u000e\u0018\u00010\r\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012¢\u0006\u0002\u0010\u0013B^\b\u0000\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\b\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0019\u0010\f\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u000e\u0018\u00010\r\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0014J\t\u0010 \u001a\u00020\u0005HÆ\u0003J\u000b\u0010!\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\t0\bHÆ\u0003J\t\u0010#\u001a\u00020\u000bHÆ\u0003J\u001c\u0010$\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u000e\u0018\u00010\rHÆ\u0003J\u000b\u0010%\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010&\u001a\u0004\u0018\u00010\u0005HÆ\u0003Jn\u0010'\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00052\u000e\b\u0002\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\b2\b\b\u0002\u0010\n\u001a\u00020\u000b2\u001b\b\u0002\u0010\f\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u000e\u0018\u00010\r2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010(\u001a\u00020)2\b\u0010*\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010+\u001a\u00020\u0003HÖ\u0001J\t\u0010,\u001a\u00020\u0005HÖ\u0001J&\u0010-\u001a\u00020.2\u0006\u0010/\u001a\u00020\u00002\u0006\u00100\u001a\u0002012\u0006\u00102\u001a\u000203HÁ\u0001¢\u0006\u0002\b4R\u0017\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\b¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0013\u0010\u0010\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0018R\u0013\u0010\u000f\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0018R$\u0010\f\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u000e\u0018\u00010\r¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u0018¨\u00067"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageItem;", "", "seen1", "", "title", "", "description", "actions", "", "Lzendesk/conversationkit/android/model/MessageAction;", "size", "Lzendesk/conversationkit/android/model/MessageItemSize;", "metadata", "", "Lkotlinx/serialization/Contextual;", "mediaUrl", "mediaType", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/model/MessageItemSize;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/model/MessageItemSize;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)V", "getActions", "()Ljava/util/List;", "getDescription", "()Ljava/lang/String;", "getMediaType", "getMediaUrl", "getMetadata", "()Ljava/util/Map;", "getSize", "()Lzendesk/conversationkit/android/model/MessageItemSize;", "getTitle", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class MessageItem {
    private final List<MessageAction> actions;
    private final String description;
    private final String mediaType;
    private final String mediaUrl;
    private final Map<String, Object> metadata;
    private final MessageItemSize size;
    private final String title;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, new ArrayListSerializer(MessageAction.INSTANCE.serializer()), MessageItemSize.INSTANCE.serializer(), new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null};

    public static MessageItem copy$default(MessageItem messageItem, String str, String str2, List list, MessageItemSize messageItemSize, Map map, String str3, String str4, int i, Object obj) {
        if ((i & 1) != 0) {
            str = messageItem.title;
        }
        if ((i & 2) != 0) {
            str2 = messageItem.description;
        }
        String str5 = str2;
        if ((i & 4) != 0) {
            list = messageItem.actions;
        }
        List list2 = list;
        if ((i & 8) != 0) {
            messageItemSize = messageItem.size;
        }
        MessageItemSize messageItemSize2 = messageItemSize;
        if ((i & 16) != 0) {
            map = messageItem.metadata;
        }
        Map map2 = map;
        if ((i & 32) != 0) {
            str3 = messageItem.mediaUrl;
        }
        String str6 = str3;
        if ((i & 64) != 0) {
            str4 = messageItem.mediaType;
        }
        return messageItem.copy(str, str5, list2, messageItemSize2, map2, str6, str4);
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getDescription() {
        return this.description;
    }

    public final List<MessageAction> component3() {
        return this.actions;
    }

    public final MessageItemSize getSize() {
        return this.size;
    }

    public final Map<String, Object> component5() {
        return this.metadata;
    }

    public final String getMediaUrl() {
        return this.mediaUrl;
    }

    public final String getMediaType() {
        return this.mediaType;
    }

    public final MessageItem copy(String title, String description, List<? extends MessageAction> actions, MessageItemSize size, Map<String, ? extends Object> metadata, String mediaUrl, String mediaType) {
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(actions, "actions");
        Intrinsics.checkNotNullParameter(size, "size");
        return new MessageItem(title, description, actions, size, metadata, mediaUrl, mediaType);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessageItem)) {
            return false;
        }
        MessageItem messageItem = (MessageItem) other;
        return Intrinsics.areEqual(this.title, messageItem.title) && Intrinsics.areEqual(this.description, messageItem.description) && Intrinsics.areEqual(this.actions, messageItem.actions) && this.size == messageItem.size && Intrinsics.areEqual(this.metadata, messageItem.metadata) && Intrinsics.areEqual(this.mediaUrl, messageItem.mediaUrl) && Intrinsics.areEqual(this.mediaType, messageItem.mediaType);
    }

    public int hashCode() {
        int iHashCode = this.title.hashCode() * 31;
        String str = this.description;
        int iHashCode2 = (((((iHashCode + (str == null ? 0 : str.hashCode())) * 31) + this.actions.hashCode()) * 31) + this.size.hashCode()) * 31;
        Map<String, Object> map = this.metadata;
        int iHashCode3 = (iHashCode2 + (map == null ? 0 : map.hashCode())) * 31;
        String str2 = this.mediaUrl;
        int iHashCode4 = (iHashCode3 + (str2 == null ? 0 : str2.hashCode())) * 31;
        String str3 = this.mediaType;
        return iHashCode4 + (str3 != null ? str3.hashCode() : 0);
    }

    public String toString() {
        return "MessageItem(title=" + this.title + ", description=" + this.description + ", actions=" + this.actions + ", size=" + this.size + ", metadata=" + this.metadata + ", mediaUrl=" + this.mediaUrl + ", mediaType=" + this.mediaType + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageItem$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageItem;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<MessageItem> serializer() {
            return MessageItem$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public MessageItem(int i, String str, String str2, List list, MessageItemSize messageItemSize, Map map, String str3, String str4, SerializationConstructorMarker serializationConstructorMarker) {
        if (127 != (i & 127)) {
            PluginExceptionsKt.throwMissingFieldException(i, 127, MessageItem$$serializer.INSTANCE.getDescriptor());
        }
        this.title = str;
        this.description = str2;
        this.actions = list;
        this.size = messageItemSize;
        this.metadata = map;
        this.mediaUrl = str3;
        this.mediaType = str4;
    }

    public MessageItem(String title, String str, List<? extends MessageAction> actions, MessageItemSize size, Map<String, ? extends Object> map, String str2, String str3) {
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(actions, "actions");
        Intrinsics.checkNotNullParameter(size, "size");
        this.title = title;
        this.description = str;
        this.actions = actions;
        this.size = size;
        this.metadata = map;
        this.mediaUrl = str2;
        this.mediaType = str3;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(MessageItem self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.title);
        output.encodeNullableSerializableElement(serialDesc, 1, StringSerializer.INSTANCE, self.description);
        output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.actions);
        output.encodeSerializableElement(serialDesc, 3, kSerializerArr[3], self.size);
        output.encodeNullableSerializableElement(serialDesc, 4, kSerializerArr[4], self.metadata);
        output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.mediaUrl);
        output.encodeNullableSerializableElement(serialDesc, 6, StringSerializer.INSTANCE, self.mediaType);
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getDescription() {
        return this.description;
    }

    public final List<MessageAction> getActions() {
        return this.actions;
    }

    public final MessageItemSize getSize() {
        return this.size;
    }

    public final Map<String, Object> getMetadata() {
        return this.metadata;
    }

    public final String getMediaUrl() {
        return this.mediaUrl;
    }

    public final String getMediaType() {
        return this.mediaType;
    }
}
