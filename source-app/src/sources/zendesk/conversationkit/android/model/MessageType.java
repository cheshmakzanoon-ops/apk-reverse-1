package zendesk.conversationkit.android.model;

import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.LazyThreadSafetyMode;
import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.internal.EnumsKt;

@Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u000f\b\u0087\u0081\u0002\u0018\u0000 \u00112\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\u0011B\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u0007j\u0002\b\bj\u0002\b\tj\u0002\b\nj\u0002\b\u000bj\u0002\b\fj\u0002\b\rj\u0002\b\u000ej\u0002\b\u000fj\u0002\b\u0010¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageType;", "", "value", "", "(Ljava/lang/String;ILjava/lang/String;)V", "getValue$zendesk_conversationkit_conversationkit_android", "()Ljava/lang/String;", "UNSUPPORTED", "TEXT", "FILE_UPLOAD", "FILE", "IMAGE", "CAROUSEL", "LIST", "LOCATION", "FORM", "FORM_RESPONSE", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public enum MessageType {
    UNSUPPORTED("unsupported"),
    TEXT("text"),
    FILE_UPLOAD("file_upload"),
    FILE("file"),
    IMAGE("image"),
    CAROUSEL("carousel"),
    LIST("list"),
    LOCATION("location"),
    FORM("form"),
    FORM_RESPONSE("formResponse");

    private final String value;
    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static final Companion INSTANCE = new Companion(null);
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return EnumsKt.createSimpleEnumSerializer("zendesk.conversationkit.android.model.MessageType", MessageType.values());
        }
    });

    public static EnumEntries<MessageType> getEntries() {
        return $ENTRIES;
    }

    MessageType(String str) {
        this.value = str;
    }

    public final String getValue() {
        return this.value;
    }

    @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000e\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006J\u000f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\u00040\bHÆ\u0001¨\u0006\t"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageType$Companion;", "", "()V", "findByValue", "Lzendesk/conversationkit/android/model/MessageType;", "value", "", "serializer", "Lkotlinx/serialization/KSerializer;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) MessageType.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<MessageType> serializer() {
            return get$cachedSerializer();
        }

        public final MessageType findByValue(String value) {
            Intrinsics.checkNotNullParameter(value, "value");
            for (MessageType messageType : MessageType.values()) {
                if (Intrinsics.areEqual(messageType.getValue(), value)) {
                    if (messageType == null) {
                        return MessageType.UNSUPPORTED;
                    }
                    return messageType;
                }
            }
            messageType = null;
            if (messageType == null) {
                return MessageType.UNSUPPORTED;
            }
            return messageType;
        }
    }
}
