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
import kotlinx.serialization.builtins.BuiltinSerializersKt;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.IntSerializer;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010%\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 !2\u00020\u0001:\u0002 !B;\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0016\u0010\u0006\u001a\u0012\u0012\u0004\u0012\u00020\u0003\u0012\u0006\u0012\u0004\u0018\u00010\u0005\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB%\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0016\b\u0002\u0010\u0006\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0007¢\u0006\u0002\u0010\u000bJ\t\u0010\u0010\u001a\u00020\u0005HÆ\u0003J\u0017\u0010\u0011\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0007HÆ\u0003J+\u0010\u0012\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u0016\b\u0002\u0010\u0006\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0007HÆ\u0001J\u0013\u0010\u0013\u001a\u00020\u00142\b\u0010\u0015\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0016\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0017\u001a\u00020\u0005HÖ\u0001J&\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u00002\u0006\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u001eHÁ\u0001¢\u0006\u0002\b\u001fR\u001f\u0010\u0006\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006\""}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/cache/StoredForm;", "", "seen1", "", "formId", "", "fields", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/util/Map;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/Map;)V", "getFields", "()Ljava/util/Map;", "getFormId", "()Ljava/lang/String;", "component1", "component2", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_messaging_messaging_android", "$serializer", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class StoredForm {
    private final Map<Integer, String> fields;
    private final String formId;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, new LinkedHashMapSerializer(IntSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE))};

    public static StoredForm copy$default(StoredForm storedForm, String str, Map map, int i, Object obj) {
        if ((i & 1) != 0) {
            str = storedForm.formId;
        }
        if ((i & 2) != 0) {
            map = storedForm.fields;
        }
        return storedForm.copy(str, map);
    }

    public final String getFormId() {
        return this.formId;
    }

    public final Map<Integer, String> component2() {
        return this.fields;
    }

    public final StoredForm copy(String formId, Map<Integer, String> fields) {
        Intrinsics.checkNotNullParameter(formId, "formId");
        Intrinsics.checkNotNullParameter(fields, "fields");
        return new StoredForm(formId, fields);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof StoredForm)) {
            return false;
        }
        StoredForm storedForm = (StoredForm) other;
        return Intrinsics.areEqual(this.formId, storedForm.formId) && Intrinsics.areEqual(this.fields, storedForm.fields);
    }

    public int hashCode() {
        return (this.formId.hashCode() * 31) + this.fields.hashCode();
    }

    public String toString() {
        return "StoredForm(formId=" + this.formId + ", fields=" + this.fields + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/cache/StoredForm$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/messaging/android/internal/conversationscreen/cache/StoredForm;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<StoredForm> serializer() {
            return StoredForm$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public StoredForm(int i, String str, Map map, SerializationConstructorMarker serializationConstructorMarker) {
        if (1 != (i & 1)) {
            PluginExceptionsKt.throwMissingFieldException(i, 1, StoredForm$$serializer.INSTANCE.getDescriptor());
        }
        this.formId = str;
        if ((i & 2) == 0) {
            this.fields = new LinkedHashMap();
        } else {
            this.fields = map;
        }
    }

    public StoredForm(String formId, Map<Integer, String> fields) {
        Intrinsics.checkNotNullParameter(formId, "formId");
        Intrinsics.checkNotNullParameter(fields, "fields");
        this.formId = formId;
        this.fields = fields;
    }

    @JvmStatic
    public static final void write$Self$zendesk_messaging_messaging_android(StoredForm self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.formId);
        if (!output.shouldEncodeElementDefault(serialDesc, 1) && Intrinsics.areEqual(self.fields, new LinkedHashMap())) {
            return;
        }
        output.encodeSerializableElement(serialDesc, 1, kSerializerArr[1], self.fields);
    }

    public final String getFormId() {
        return this.formId;
    }

    public StoredForm(String str, LinkedHashMap linkedHashMap, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, (i & 2) != 0 ? new LinkedHashMap() : linkedHashMap);
    }

    public final Map<Integer, String> getFields() {
        return this.fields;
    }
}
