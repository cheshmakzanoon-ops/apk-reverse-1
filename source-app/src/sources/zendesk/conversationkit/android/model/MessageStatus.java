package zendesk.conversationkit.android.model;

import java.lang.annotation.Annotation;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.LazyThreadSafetyMode;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlin.reflect.KClass;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SealedClassSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.EnumsKt;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import zendesk.conversationkit.android.internal.ErrorKtxKt;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u0000 \u00132\u00020\u0001:\b\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001aB#\b\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bB\u000f\b\u0004\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\tJ!\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u00002\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0012HÇ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b\u0082\u0001\u0005\u001b\u001c\u001d\u001e\u001f¨\u0006 "}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus;", "", "seen1", "", "statusType", "Lzendesk/conversationkit/android/model/MessageStatus$StatusType;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageStatus$StatusType;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/model/MessageStatus$StatusType;)V", "getStatusType", "()Lzendesk/conversationkit/android/model/MessageStatus$StatusType;", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "Companion", "DownloadFailed", "Downloading", "Failed", "Failure", "Pending", "Sent", "StatusType", "Lzendesk/conversationkit/android/model/MessageStatus$DownloadFailed;", "Lzendesk/conversationkit/android/model/MessageStatus$Downloading;", "Lzendesk/conversationkit/android/model/MessageStatus$Failed;", "Lzendesk/conversationkit/android/model/MessageStatus$Pending;", "Lzendesk/conversationkit/android/model/MessageStatus$Sent;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public abstract class MessageStatus {
    private final StatusType statusType;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {StatusType.INSTANCE.serializer()};
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return new SealedClassSerializer("zendesk.conversationkit.android.model.MessageStatus", Reflection.getOrCreateKotlinClass(MessageStatus.class), new KClass[]{Reflection.getOrCreateKotlinClass(DownloadFailed.class), Reflection.getOrCreateKotlinClass(Downloading.class), Reflection.getOrCreateKotlinClass(Failed.class), Reflection.getOrCreateKotlinClass(Pending.class), Reflection.getOrCreateKotlinClass(Sent.class)}, new KSerializer[]{MessageStatus$DownloadFailed$$serializer.INSTANCE, MessageStatus$Downloading$$serializer.INSTANCE, MessageStatus$Failed$$serializer.INSTANCE, MessageStatus$Pending$$serializer.INSTANCE, MessageStatus$Sent$$serializer.INSTANCE}, new Annotation[0]);
        }
    });

    public MessageStatus(StatusType statusType, DefaultConstructorMarker defaultConstructorMarker) {
        this(statusType);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public MessageStatus(int i, StatusType statusType, SerializationConstructorMarker serializationConstructorMarker) {
        this.statusType = statusType;
    }

    private MessageStatus(StatusType statusType) {
        this.statusType = statusType;
    }

    @JvmStatic
    public static final void write$Self(MessageStatus self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeSerializableElement(serialDesc, 0, $childSerializers[0], self.statusType);
    }

    public final StatusType getStatusType() {
        return this.statusType;
    }

    @Metadata(m17d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 \u001f2\u00020\u0001:\u0002\u001e\u001fB-\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB\u000f\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\u000bJ\t\u0010\u000e\u001a\u00020\u0007HÆ\u0003J\u0013\u0010\u000f\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0007HÖ\u0001J&\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00002\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cHÁ\u0001¢\u0006\u0002\b\u001dR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\r¨\u0006 "}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Pending;", "Lzendesk/conversationkit/android/model/MessageStatus;", "seen1", "", "statusType", "Lzendesk/conversationkit/android/model/MessageStatus$StatusType;", "id", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageStatus$StatusType;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("pending")
    public static final class Pending extends MessageStatus {
        private final String id;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {StatusType.INSTANCE.serializer(), null};

        public Pending() {
            this(null, 1, 0 == true ? 1 : 0);
        }

        public static Pending copy$default(Pending pending, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = pending.id;
            }
            return pending.copy(str);
        }

        public final String getId() {
            return this.id;
        }

        public final Pending copy(String id) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new Pending(id);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Pending) && Intrinsics.areEqual(this.id, ((Pending) other).id);
        }

        public int hashCode() {
            return this.id.hashCode();
        }

        public String toString() {
            return "Pending(id=" + this.id + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Pending$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageStatus$Pending;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Pending> serializer() {
                return MessageStatus$Pending$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Pending(int i, StatusType statusType, String str, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, statusType, serializationConstructorMarker);
            if (1 != (i & 1)) {
                PluginExceptionsKt.throwMissingFieldException(i, 1, MessageStatus$Pending$$serializer.INSTANCE.getDescriptor());
            }
            if ((i & 2) == 0) {
                this.id = "PENDING";
            } else {
                this.id = str;
            }
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Pending self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageStatus.write$Self(self, output, serialDesc);
            if (!output.shouldEncodeElementDefault(serialDesc, 1) && Intrinsics.areEqual(self.id, "PENDING")) {
                return;
            }
            output.encodeStringElement(serialDesc, 1, self.id);
        }

        public Pending(String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? "PENDING" : str);
        }

        public final String getId() {
            return this.id;
        }

        public Pending(String id) {
            super(StatusType.PENDING, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
        }
    }

    @Metadata(m17d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 \u001f2\u00020\u0001:\u0002\u001e\u001fB-\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB\u000f\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\u000bJ\t\u0010\u000e\u001a\u00020\u0007HÆ\u0003J\u0013\u0010\u000f\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0007HÖ\u0001J&\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00002\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cHÁ\u0001¢\u0006\u0002\b\u001dR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\r¨\u0006 "}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Sent;", "Lzendesk/conversationkit/android/model/MessageStatus;", "seen1", "", "statusType", "Lzendesk/conversationkit/android/model/MessageStatus$StatusType;", "id", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageStatus$StatusType;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("sent")
    public static final class Sent extends MessageStatus {
        private final String id;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {StatusType.INSTANCE.serializer(), null};

        public Sent() {
            this(null, 1, 0 == true ? 1 : 0);
        }

        public static Sent copy$default(Sent sent, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = sent.id;
            }
            return sent.copy(str);
        }

        public final String getId() {
            return this.id;
        }

        public final Sent copy(String id) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new Sent(id);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Sent) && Intrinsics.areEqual(this.id, ((Sent) other).id);
        }

        public int hashCode() {
            return this.id.hashCode();
        }

        public String toString() {
            return "Sent(id=" + this.id + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Sent$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageStatus$Sent;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Sent> serializer() {
                return MessageStatus$Sent$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Sent(int i, StatusType statusType, String str, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, statusType, serializationConstructorMarker);
            if (1 != (i & 1)) {
                PluginExceptionsKt.throwMissingFieldException(i, 1, MessageStatus$Sent$$serializer.INSTANCE.getDescriptor());
            }
            if ((i & 2) == 0) {
                this.id = "SENT";
            } else {
                this.id = str;
            }
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Sent self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageStatus.write$Self(self, output, serialDesc);
            if (!output.shouldEncodeElementDefault(serialDesc, 1) && Intrinsics.areEqual(self.id, "SENT")) {
                return;
            }
            output.encodeStringElement(serialDesc, 1, self.id);
        }

        public Sent(String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? "SENT" : str);
        }

        public final String getId() {
            return this.id;
        }

        public Sent(String id) {
            super(StatusType.SENT, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
        }
    }

    @Metadata(m17d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000  2\u00020\u0001:\u0002\u001f B-\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB\r\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\u000bJ\t\u0010\u000e\u001a\u00020\u0007HÆ\u0003J\u0013\u0010\u000f\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001J&\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00002\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001dHÁ\u0001¢\u0006\u0002\b\u001eR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\r¨\u0006!"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Failed;", "Lzendesk/conversationkit/android/model/MessageStatus;", "seen1", "", "statusType", "Lzendesk/conversationkit/android/model/MessageStatus$StatusType;", "failure", "Lzendesk/conversationkit/android/model/MessageStatus$Failure;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageStatus$StatusType;Lzendesk/conversationkit/android/model/MessageStatus$Failure;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/model/MessageStatus$Failure;)V", "getFailure", "()Lzendesk/conversationkit/android/model/MessageStatus$Failure;", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("failed")
    public static final class Failed extends MessageStatus {
        private final Failure failure;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {StatusType.INSTANCE.serializer(), Failure.INSTANCE.serializer()};

        public static Failed copy$default(Failed failed, Failure failure, int i, Object obj) {
            if ((i & 1) != 0) {
                failure = failed.failure;
            }
            return failed.copy(failure);
        }

        public final Failure getFailure() {
            return this.failure;
        }

        public final Failed copy(Failure failure) {
            Intrinsics.checkNotNullParameter(failure, "failure");
            return new Failed(failure);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Failed) && this.failure == ((Failed) other).failure;
        }

        public int hashCode() {
            return this.failure.hashCode();
        }

        public String toString() {
            return "Failed(failure=" + this.failure + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Failed$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageStatus$Failed;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Failed> serializer() {
                return MessageStatus$Failed$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Failed(int i, StatusType statusType, Failure failure, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, statusType, serializationConstructorMarker);
            if (3 != (i & 3)) {
                PluginExceptionsKt.throwMissingFieldException(i, 3, MessageStatus$Failed$$serializer.INSTANCE.getDescriptor());
            }
            this.failure = failure;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Failed self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageStatus.write$Self(self, output, serialDesc);
            output.encodeSerializableElement(serialDesc, 1, $childSerializers[1], self.failure);
        }

        public final Failure getFailure() {
            return this.failure;
        }

        public Failed(Failure failure) {
            super(StatusType.FAILED, null);
            Intrinsics.checkNotNullParameter(failure, "failure");
            this.failure = failure;
        }
    }

    @Metadata(m17d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 \u001f2\u00020\u0001:\u0002\u001e\u001fB-\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB\u000f\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\u000bJ\t\u0010\u000e\u001a\u00020\u0007HÆ\u0003J\u0013\u0010\u000f\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0007HÖ\u0001J&\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00002\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cHÁ\u0001¢\u0006\u0002\b\u001dR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\r¨\u0006 "}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Downloading;", "Lzendesk/conversationkit/android/model/MessageStatus;", "seen1", "", "statusType", "Lzendesk/conversationkit/android/model/MessageStatus$StatusType;", "id", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageStatus$StatusType;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("downloading")
    public static final class Downloading extends MessageStatus {
        private final String id;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {StatusType.INSTANCE.serializer(), null};

        public Downloading() {
            this(null, 1, 0 == true ? 1 : 0);
        }

        public static Downloading copy$default(Downloading downloading, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = downloading.id;
            }
            return downloading.copy(str);
        }

        public final String getId() {
            return this.id;
        }

        public final Downloading copy(String id) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new Downloading(id);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Downloading) && Intrinsics.areEqual(this.id, ((Downloading) other).id);
        }

        public int hashCode() {
            return this.id.hashCode();
        }

        public String toString() {
            return "Downloading(id=" + this.id + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Downloading$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageStatus$Downloading;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Downloading> serializer() {
                return MessageStatus$Downloading$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Downloading(int i, StatusType statusType, String str, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, statusType, serializationConstructorMarker);
            if (1 != (i & 1)) {
                PluginExceptionsKt.throwMissingFieldException(i, 1, MessageStatus$Downloading$$serializer.INSTANCE.getDescriptor());
            }
            if ((i & 2) == 0) {
                this.id = "DOWNLOADING";
            } else {
                this.id = str;
            }
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Downloading self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageStatus.write$Self(self, output, serialDesc);
            if (!output.shouldEncodeElementDefault(serialDesc, 1) && Intrinsics.areEqual(self.id, "DOWNLOADING")) {
                return;
            }
            output.encodeStringElement(serialDesc, 1, self.id);
        }

        public Downloading(String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? "DOWNLOADING" : str);
        }

        public final String getId() {
            return this.id;
        }

        public Downloading(String id) {
            super(StatusType.DOWNLOADING, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
        }
    }

    @Metadata(m17d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 \u001f2\u00020\u0001:\u0002\u001e\u001fB-\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB\u000f\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\u000bJ\t\u0010\u000e\u001a\u00020\u0007HÆ\u0003J\u0013\u0010\u000f\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0007HÖ\u0001J&\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00002\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cHÁ\u0001¢\u0006\u0002\b\u001dR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\r¨\u0006 "}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$DownloadFailed;", "Lzendesk/conversationkit/android/model/MessageStatus;", "seen1", "", "statusType", "Lzendesk/conversationkit/android/model/MessageStatus$StatusType;", "id", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageStatus$StatusType;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("download_failed")
    public static final class DownloadFailed extends MessageStatus {
        private final String id;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {StatusType.INSTANCE.serializer(), null};

        public DownloadFailed() {
            this(null, 1, 0 == true ? 1 : 0);
        }

        public static DownloadFailed copy$default(DownloadFailed downloadFailed, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = downloadFailed.id;
            }
            return downloadFailed.copy(str);
        }

        public final String getId() {
            return this.id;
        }

        public final DownloadFailed copy(String id) {
            Intrinsics.checkNotNullParameter(id, "id");
            return new DownloadFailed(id);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof DownloadFailed) && Intrinsics.areEqual(this.id, ((DownloadFailed) other).id);
        }

        public int hashCode() {
            return this.id.hashCode();
        }

        public String toString() {
            return "DownloadFailed(id=" + this.id + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$DownloadFailed$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageStatus$DownloadFailed;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<DownloadFailed> serializer() {
                return MessageStatus$DownloadFailed$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public DownloadFailed(int i, StatusType statusType, String str, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, statusType, serializationConstructorMarker);
            if (1 != (i & 1)) {
                PluginExceptionsKt.throwMissingFieldException(i, 1, MessageStatus$DownloadFailed$$serializer.INSTANCE.getDescriptor());
            }
            if ((i & 2) == 0) {
                this.id = "DOWNLOAD_FAILED";
            } else {
                this.id = str;
            }
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(DownloadFailed self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageStatus.write$Self(self, output, serialDesc);
            if (!output.shouldEncodeElementDefault(serialDesc, 1) && Intrinsics.areEqual(self.id, "DOWNLOAD_FAILED")) {
                return;
            }
            output.encodeStringElement(serialDesc, 1, self.id);
        }

        public DownloadFailed(String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? "DOWNLOAD_FAILED" : str);
        }

        public final String getId() {
            return this.id;
        }

        public DownloadFailed(String id) {
            super(StatusType.DOWNLOAD_FAILED, null);
            Intrinsics.checkNotNullParameter(id, "id");
            this.id = id;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\n\b\u0087\u0081\u0002\u0018\u0000 \f2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\fB\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u0007j\u0002\b\bj\u0002\b\tj\u0002\b\nj\u0002\b\u000b¨\u0006\r"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$StatusType;", "", "value", "", "(Ljava/lang/String;ILjava/lang/String;)V", "getValue", "()Ljava/lang/String;", "PENDING", "SENT", "FAILED", "DOWNLOADING", "DOWNLOAD_FAILED", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    public enum StatusType {
        PENDING("pending"),
        SENT("sent"),
        FAILED("failed"),
        DOWNLOADING("downloading"),
        DOWNLOAD_FAILED("download_failed");

        private final String value;
        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

        public static final Companion INSTANCE = new Companion(null);
        private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
            @Override
            public final KSerializer<Object> invoke() {
                return EnumsKt.createSimpleEnumSerializer("zendesk.conversationkit.android.model.MessageStatus.StatusType", StatusType.values());
            }
        });

        public static EnumEntries<StatusType> getEntries() {
            return $ENTRIES;
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$StatusType$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageStatus$StatusType;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            private final KSerializer get$cachedSerializer() {
                return (KSerializer) StatusType.$cachedSerializer$delegate.getValue();
            }

            public final KSerializer<StatusType> serializer() {
                return get$cachedSerializer();
            }
        }

        StatusType(String str) {
            this.value = str;
        }

        public final String getValue() {
            return this.value;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0005\b\u0087\u0081\u0002\u0018\u0000 \u00052\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\u0005B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Failure;", "", "(Ljava/lang/String;I)V", "GENERAL", "CONTENT_TOO_LARGE", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    public enum Failure {
        GENERAL,
        CONTENT_TOO_LARGE;

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

        public static final Companion INSTANCE = new Companion(null);
        private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
            @Override
            public final KSerializer<Object> invoke() {
                return EnumsKt.createSimpleEnumSerializer("zendesk.conversationkit.android.model.MessageStatus.Failure", Failure.values());
            }
        });

        public static EnumEntries<Failure> getEntries() {
            return $ENTRIES;
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Failure$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageStatus$Failure;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            private final KSerializer get$cachedSerializer() {
                return (KSerializer) Failure.$cachedSerializer$delegate.getValue();
            }

            public final KSerializer<Failure> serializer() {
                return get$cachedSerializer();
            }
        }
    }

    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000e\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006J\u000f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\bHÆ\u0001¨\u0006\n"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageStatus$Companion;", "", "()V", "failed", "Lzendesk/conversationkit/android/model/MessageStatus$Failed;", "throwable", "", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageStatus;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) MessageStatus.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<MessageStatus> serializer() {
            return get$cachedSerializer();
        }

        public final Failed failed(Throwable throwable) {
            Intrinsics.checkNotNullParameter(throwable, "throwable");
            if (ErrorKtxKt.isContentTooLargeException(throwable)) {
                return new Failed(Failure.CONTENT_TOO_LARGE);
            }
            return new Failed(Failure.GENERAL);
        }
    }
}
