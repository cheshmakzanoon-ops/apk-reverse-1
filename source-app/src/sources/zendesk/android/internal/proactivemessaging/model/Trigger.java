package zendesk.android.internal.proactivemessaging.model;

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
import kotlinx.serialization.internal.IntSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 #2\u00020\u0001:\u0002\"#B-\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\tB\u0019\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\nJ\t\u0010\u0010\u001a\u00020\u0005HÆ\u0003J\u0010\u0010\u0011\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\fJ$\u0010\u0012\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0003HÆ\u0001¢\u0006\u0002\u0010\u0013J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0018\u001a\u00020\u0019HÖ\u0001J&\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u00002\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020 HÁ\u0001¢\u0006\u0002\b!R\u0015\u0010\u0006\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\r\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006$"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Trigger;", "", "seen1", "", "type", "Lzendesk/android/internal/proactivemessaging/model/TriggerType;", "duration", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/android/internal/proactivemessaging/model/TriggerType;Ljava/lang/Integer;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/android/internal/proactivemessaging/model/TriggerType;Ljava/lang/Integer;)V", "getDuration", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getType", "()Lzendesk/android/internal/proactivemessaging/model/TriggerType;", "component1", "component2", "copy", "(Lzendesk/android/internal/proactivemessaging/model/TriggerType;Ljava/lang/Integer;)Lzendesk/android/internal/proactivemessaging/model/Trigger;", "equals", "", "other", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class Trigger {

    public static final Companion INSTANCE = new Companion(null);
    private final Integer duration;
    private final TriggerType type;

    public static Trigger copy$default(Trigger trigger, TriggerType triggerType, Integer num, int i, Object obj) {
        if ((i & 1) != 0) {
            triggerType = trigger.type;
        }
        if ((i & 2) != 0) {
            num = trigger.duration;
        }
        return trigger.copy(triggerType, num);
    }

    public final TriggerType getType() {
        return this.type;
    }

    public final Integer getDuration() {
        return this.duration;
    }

    public final Trigger copy(TriggerType type, Integer duration) {
        Intrinsics.checkNotNullParameter(type, "type");
        return new Trigger(type, duration);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Trigger)) {
            return false;
        }
        Trigger trigger = (Trigger) other;
        return this.type == trigger.type && Intrinsics.areEqual(this.duration, trigger.duration);
    }

    public int hashCode() {
        int iHashCode = this.type.hashCode() * 31;
        Integer num = this.duration;
        return iHashCode + (num == null ? 0 : num.hashCode());
    }

    public String toString() {
        return "Trigger(type=" + this.type + ", duration=" + this.duration + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Trigger$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Trigger;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<Trigger> serializer() {
            return Trigger$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public Trigger(int i, TriggerType triggerType, Integer num, SerializationConstructorMarker serializationConstructorMarker) {
        if (1 != (i & 1)) {
            PluginExceptionsKt.throwMissingFieldException(i, 1, Trigger$$serializer.INSTANCE.getDescriptor());
        }
        this.type = triggerType;
        if ((i & 2) == 0) {
            this.duration = null;
        } else {
            this.duration = num;
        }
    }

    public Trigger(TriggerType type, Integer num) {
        Intrinsics.checkNotNullParameter(type, "type");
        this.type = type;
        this.duration = num;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(Trigger self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeSerializableElement(serialDesc, 0, TriggerType.TriggerTypeSerializer.INSTANCE, self.type);
        if (!output.shouldEncodeElementDefault(serialDesc, 1) && self.duration == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 1, IntSerializer.INSTANCE, self.duration);
    }

    public Trigger(TriggerType triggerType, Integer num, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(triggerType, (i & 2) != 0 ? null : num);
    }

    public final TriggerType getType() {
        return this.type;
    }

    public final Integer getDuration() {
        return this.duration;
    }
}
