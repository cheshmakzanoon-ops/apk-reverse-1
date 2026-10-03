package zendesk.conversationkit.android.internal.faye;

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
import zendesk.conversationkit.android.internal.rest.model.MessageDto;
import zendesk.conversationkit.android.internal.rest.model.MessageDto$$serializer;

@Metadata(m17d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 +2\u00020\u0001:\u0002*+BA\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b\u0012\b\u0010\f\u001a\u0004\u0018\u00010\r¢\u0006\u0002\u0010\u000eB-\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\t\u0012\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\u000fJ\t\u0010\u0018\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0007HÆ\u0003J\u000b\u0010\u001a\u001a\u0004\u0018\u00010\tHÆ\u0003J\u000b\u0010\u001b\u001a\u0004\u0018\u00010\u000bHÆ\u0003J5\u0010\u001c\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\t2\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u000bHÆ\u0001J\u0013\u0010\u001d\u001a\u00020\u001e2\b\u0010\u001f\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010 \u001a\u00020\u0003HÖ\u0001J\t\u0010!\u001a\u00020\u0005HÖ\u0001J&\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020\u00002\u0006\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020(HÁ\u0001¢\u0006\u0002\b)R\u0013\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0013\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017¨\u0006,"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/WsFayeMessageDto;", "", "seen1", "", "type", "", "conversation", "Lzendesk/conversationkit/android/internal/faye/WsConversationDto;", "message", "Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "activity", "Lzendesk/conversationkit/android/internal/faye/WsActivityEventDto;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Lzendesk/conversationkit/android/internal/faye/WsConversationDto;Lzendesk/conversationkit/android/internal/rest/model/MessageDto;Lzendesk/conversationkit/android/internal/faye/WsActivityEventDto;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Lzendesk/conversationkit/android/internal/faye/WsConversationDto;Lzendesk/conversationkit/android/internal/rest/model/MessageDto;Lzendesk/conversationkit/android/internal/faye/WsActivityEventDto;)V", "getActivity", "()Lzendesk/conversationkit/android/internal/faye/WsActivityEventDto;", "getConversation", "()Lzendesk/conversationkit/android/internal/faye/WsConversationDto;", "getMessage", "()Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "getType", "()Ljava/lang/String;", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class WsFayeMessageDto {

    public static final Companion INSTANCE = new Companion(null);
    private final WsActivityEventDto activity;
    private final WsConversationDto conversation;
    private final MessageDto message;
    private final String type;

    public static WsFayeMessageDto copy$default(WsFayeMessageDto wsFayeMessageDto, String str, WsConversationDto wsConversationDto, MessageDto messageDto, WsActivityEventDto wsActivityEventDto, int i, Object obj) {
        if ((i & 1) != 0) {
            str = wsFayeMessageDto.type;
        }
        if ((i & 2) != 0) {
            wsConversationDto = wsFayeMessageDto.conversation;
        }
        if ((i & 4) != 0) {
            messageDto = wsFayeMessageDto.message;
        }
        if ((i & 8) != 0) {
            wsActivityEventDto = wsFayeMessageDto.activity;
        }
        return wsFayeMessageDto.copy(str, wsConversationDto, messageDto, wsActivityEventDto);
    }

    public final String getType() {
        return this.type;
    }

    public final WsConversationDto getConversation() {
        return this.conversation;
    }

    public final MessageDto getMessage() {
        return this.message;
    }

    public final WsActivityEventDto getActivity() {
        return this.activity;
    }

    public final WsFayeMessageDto copy(String type, WsConversationDto conversation, MessageDto message, WsActivityEventDto activity) {
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(conversation, "conversation");
        return new WsFayeMessageDto(type, conversation, message, activity);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof WsFayeMessageDto)) {
            return false;
        }
        WsFayeMessageDto wsFayeMessageDto = (WsFayeMessageDto) other;
        return Intrinsics.areEqual(this.type, wsFayeMessageDto.type) && Intrinsics.areEqual(this.conversation, wsFayeMessageDto.conversation) && Intrinsics.areEqual(this.message, wsFayeMessageDto.message) && Intrinsics.areEqual(this.activity, wsFayeMessageDto.activity);
    }

    public int hashCode() {
        int iHashCode = ((this.type.hashCode() * 31) + this.conversation.hashCode()) * 31;
        MessageDto messageDto = this.message;
        int iHashCode2 = (iHashCode + (messageDto == null ? 0 : messageDto.hashCode())) * 31;
        WsActivityEventDto wsActivityEventDto = this.activity;
        return iHashCode2 + (wsActivityEventDto != null ? wsActivityEventDto.hashCode() : 0);
    }

    public String toString() {
        return "WsFayeMessageDto(type=" + this.type + ", conversation=" + this.conversation + ", message=" + this.message + ", activity=" + this.activity + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/WsFayeMessageDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/faye/WsFayeMessageDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<WsFayeMessageDto> serializer() {
            return WsFayeMessageDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public WsFayeMessageDto(int i, String str, WsConversationDto wsConversationDto, MessageDto messageDto, WsActivityEventDto wsActivityEventDto, SerializationConstructorMarker serializationConstructorMarker) {
        if (3 != (i & 3)) {
            PluginExceptionsKt.throwMissingFieldException(i, 3, WsFayeMessageDto$$serializer.INSTANCE.getDescriptor());
        }
        this.type = str;
        this.conversation = wsConversationDto;
        if ((i & 4) == 0) {
            this.message = null;
        } else {
            this.message = messageDto;
        }
        if ((i & 8) == 0) {
            this.activity = null;
        } else {
            this.activity = wsActivityEventDto;
        }
    }

    public WsFayeMessageDto(String type, WsConversationDto conversation, MessageDto messageDto, WsActivityEventDto wsActivityEventDto) {
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(conversation, "conversation");
        this.type = type;
        this.conversation = conversation;
        this.message = messageDto;
        this.activity = wsActivityEventDto;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(WsFayeMessageDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.type);
        output.encodeSerializableElement(serialDesc, 1, WsConversationDto$$serializer.INSTANCE, self.conversation);
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.message != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, MessageDto$$serializer.INSTANCE, self.message);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 3) && self.activity == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 3, WsActivityEventDto$$serializer.INSTANCE, self.activity);
    }

    public WsFayeMessageDto(String str, WsConversationDto wsConversationDto, MessageDto messageDto, WsActivityEventDto wsActivityEventDto, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, wsConversationDto, (i & 4) != 0 ? null : messageDto, (i & 8) != 0 ? null : wsActivityEventDto);
    }

    public final String getType() {
        return this.type;
    }

    public final WsConversationDto getConversation() {
        return this.conversation;
    }

    public final MessageDto getMessage() {
        return this.message;
    }

    public final WsActivityEventDto getActivity() {
        return this.activity;
    }
}
