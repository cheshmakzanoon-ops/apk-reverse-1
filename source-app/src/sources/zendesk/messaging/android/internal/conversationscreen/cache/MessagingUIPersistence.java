package zendesk.messaging.android.internal.conversationscreen.cache;

import java.util.LinkedHashMap;
import java.util.Map;
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
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 %2\u00020\u0001:\u0002$%BC\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\u0014\u0010\u0007\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\t\u0018\u00010\b\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB-\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0005\u0012\u0014\b\u0002\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\t0\b¢\u0006\u0002\u0010\rJ\t\u0010\u0013\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0005HÆ\u0003J\u0015\u0010\u0015\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\t0\bHÆ\u0003J3\u0010\u0016\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\u0014\b\u0002\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\t0\bHÆ\u0001J\u0013\u0010\u0017\u001a\u00020\u00182\b\u0010\u0019\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001a\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001b\u001a\u00020\u0005HÖ\u0001J&\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u00002\u0006\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\"HÁ\u0001¢\u0006\u0002\b#R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000fR\u001d\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\t0\b¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012¨\u0006&"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/cache/MessagingUIPersistence;", "", "seen1", "", "conversationId", "", "composerText", "forms", "", "Lzendesk/messaging/android/internal/conversationscreen/cache/StoredForm;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/util/Map;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;)V", "getComposerText", "()Ljava/lang/String;", "getConversationId", "getForms", "()Ljava/util/Map;", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_messaging_messaging_android", "$serializer", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class MessagingUIPersistence {
    private final String composerText;
    private final String conversationId;
    private final Map<String, StoredForm> forms;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, StoredForm$$serializer.INSTANCE)};

    public static MessagingUIPersistence copy$default(MessagingUIPersistence messagingUIPersistence, String str, String str2, Map map, int i, Object obj) {
        if ((i & 1) != 0) {
            str = messagingUIPersistence.conversationId;
        }
        if ((i & 2) != 0) {
            str2 = messagingUIPersistence.composerText;
        }
        if ((i & 4) != 0) {
            map = messagingUIPersistence.forms;
        }
        return messagingUIPersistence.copy(str, str2, map);
    }

    public final String getConversationId() {
        return this.conversationId;
    }

    public final String getComposerText() {
        return this.composerText;
    }

    public final Map<String, StoredForm> component3() {
        return this.forms;
    }

    public final MessagingUIPersistence copy(String conversationId, String composerText, Map<String, StoredForm> forms) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        Intrinsics.checkNotNullParameter(composerText, "composerText");
        Intrinsics.checkNotNullParameter(forms, "forms");
        return new MessagingUIPersistence(conversationId, composerText, forms);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessagingUIPersistence)) {
            return false;
        }
        MessagingUIPersistence messagingUIPersistence = (MessagingUIPersistence) other;
        return Intrinsics.areEqual(this.conversationId, messagingUIPersistence.conversationId) && Intrinsics.areEqual(this.composerText, messagingUIPersistence.composerText) && Intrinsics.areEqual(this.forms, messagingUIPersistence.forms);
    }

    public int hashCode() {
        return (((this.conversationId.hashCode() * 31) + this.composerText.hashCode()) * 31) + this.forms.hashCode();
    }

    public String toString() {
        return "MessagingUIPersistence(conversationId=" + this.conversationId + ", composerText=" + this.composerText + ", forms=" + this.forms + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/cache/MessagingUIPersistence$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/messaging/android/internal/conversationscreen/cache/MessagingUIPersistence;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<MessagingUIPersistence> serializer() {
            return MessagingUIPersistence$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public MessagingUIPersistence(int i, String str, String str2, Map map, SerializationConstructorMarker serializationConstructorMarker) {
        if (1 != (i & 1)) {
            PluginExceptionsKt.throwMissingFieldException(i, 1, MessagingUIPersistence$$serializer.INSTANCE.getDescriptor());
        }
        this.conversationId = str;
        if ((i & 2) == 0) {
            this.composerText = "";
        } else {
            this.composerText = str2;
        }
        if ((i & 4) == 0) {
            this.forms = new LinkedHashMap();
        } else {
            this.forms = map;
        }
    }

    public MessagingUIPersistence(String conversationId, String composerText, Map<String, StoredForm> forms) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        Intrinsics.checkNotNullParameter(composerText, "composerText");
        Intrinsics.checkNotNullParameter(forms, "forms");
        this.conversationId = conversationId;
        this.composerText = composerText;
        this.forms = forms;
    }

    @JvmStatic
    public static final void write$Self$zendesk_messaging_messaging_android(MessagingUIPersistence self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.conversationId);
        if (output.shouldEncodeElementDefault(serialDesc, 1) || !Intrinsics.areEqual(self.composerText, "")) {
            output.encodeStringElement(serialDesc, 1, self.composerText);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 2) && Intrinsics.areEqual(self.forms, new LinkedHashMap())) {
            return;
        }
        output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.forms);
    }

    public final String getConversationId() {
        return this.conversationId;
    }

    public MessagingUIPersistence(String str, String str2, LinkedHashMap linkedHashMap, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, (i & 2) != 0 ? "" : str2, (i & 4) != 0 ? new LinkedHashMap() : linkedHashMap);
    }

    public final String getComposerText() {
        return this.composerText;
    }

    public final Map<String, StoredForm> getForms() {
        return this.forms;
    }
}
