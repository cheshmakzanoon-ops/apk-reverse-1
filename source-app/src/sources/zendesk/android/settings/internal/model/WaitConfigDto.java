package zendesk.android.settings.internal.model;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.UByte$$ExternalSyntheticBackport0;
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

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0015\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 +2\u00020\u0001:\u0002*+BE\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB1\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\rJ\t\u0010\u0016\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0005HÆ\u0003J\u0010\u0010\u0019\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\u0011J\u0010\u0010\u001a\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\u0011JD\u0010\u001b\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u0003HÆ\u0001¢\u0006\u0002\u0010\u001cJ\u0013\u0010\u001d\u001a\u00020\u00052\b\u0010\u001e\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001f\u001a\u00020\u0003HÖ\u0001J\t\u0010 \u001a\u00020!HÖ\u0001J&\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020\u00002\u0006\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020(HÁ\u0001¢\u0006\u0002\b)R\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0015\u0010\t\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\u0012\u001a\u0004\b\u0010\u0010\u0011R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u000fR\u0015\u0010\b\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\u0012\u001a\u0004\b\u0015\u0010\u0011¨\u0006,"}, m18d2 = {"Lzendesk/android/settings/internal/model/WaitConfigDto;", "", "seen1", "", "waitTimeEnabled", "", "queuePositionEnabled", "onlyDecreasingQueue", "waitTimeOverride", "queuePollingInterval", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(IZZZLjava/lang/Integer;Ljava/lang/Integer;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(ZZZLjava/lang/Integer;Ljava/lang/Integer;)V", "getOnlyDecreasingQueue", "()Z", "getQueuePollingInterval", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getQueuePositionEnabled", "getWaitTimeEnabled", "getWaitTimeOverride", "component1", "component2", "component3", "component4", "component5", "copy", "(ZZZLjava/lang/Integer;Ljava/lang/Integer;)Lzendesk/android/settings/internal/model/WaitConfigDto;", "equals", "other", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class WaitConfigDto {

    public static final Companion INSTANCE = new Companion(null);
    private final boolean onlyDecreasingQueue;
    private final Integer queuePollingInterval;
    private final boolean queuePositionEnabled;
    private final boolean waitTimeEnabled;
    private final Integer waitTimeOverride;

    public static WaitConfigDto copy$default(WaitConfigDto waitConfigDto, boolean z, boolean z2, boolean z3, Integer num, Integer num2, int i, Object obj) {
        if ((i & 1) != 0) {
            z = waitConfigDto.waitTimeEnabled;
        }
        if ((i & 2) != 0) {
            z2 = waitConfigDto.queuePositionEnabled;
        }
        boolean z4 = z2;
        if ((i & 4) != 0) {
            z3 = waitConfigDto.onlyDecreasingQueue;
        }
        boolean z5 = z3;
        if ((i & 8) != 0) {
            num = waitConfigDto.waitTimeOverride;
        }
        Integer num3 = num;
        if ((i & 16) != 0) {
            num2 = waitConfigDto.queuePollingInterval;
        }
        return waitConfigDto.copy(z, z4, z5, num3, num2);
    }

    public final boolean getWaitTimeEnabled() {
        return this.waitTimeEnabled;
    }

    public final boolean getQueuePositionEnabled() {
        return this.queuePositionEnabled;
    }

    public final boolean getOnlyDecreasingQueue() {
        return this.onlyDecreasingQueue;
    }

    public final Integer getWaitTimeOverride() {
        return this.waitTimeOverride;
    }

    public final Integer getQueuePollingInterval() {
        return this.queuePollingInterval;
    }

    public final WaitConfigDto copy(boolean waitTimeEnabled, boolean queuePositionEnabled, boolean onlyDecreasingQueue, Integer waitTimeOverride, Integer queuePollingInterval) {
        return new WaitConfigDto(waitTimeEnabled, queuePositionEnabled, onlyDecreasingQueue, waitTimeOverride, queuePollingInterval);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof WaitConfigDto)) {
            return false;
        }
        WaitConfigDto waitConfigDto = (WaitConfigDto) other;
        return this.waitTimeEnabled == waitConfigDto.waitTimeEnabled && this.queuePositionEnabled == waitConfigDto.queuePositionEnabled && this.onlyDecreasingQueue == waitConfigDto.onlyDecreasingQueue && Intrinsics.areEqual(this.waitTimeOverride, waitConfigDto.waitTimeOverride) && Intrinsics.areEqual(this.queuePollingInterval, waitConfigDto.queuePollingInterval);
    }

    public int hashCode() {
        int iM30m = ((((UByte$$ExternalSyntheticBackport0.m30m(this.waitTimeEnabled) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.queuePositionEnabled)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.onlyDecreasingQueue)) * 31;
        Integer num = this.waitTimeOverride;
        int iHashCode = (iM30m + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.queuePollingInterval;
        return iHashCode + (num2 != null ? num2.hashCode() : 0);
    }

    public String toString() {
        return "WaitConfigDto(waitTimeEnabled=" + this.waitTimeEnabled + ", queuePositionEnabled=" + this.queuePositionEnabled + ", onlyDecreasingQueue=" + this.onlyDecreasingQueue + ", waitTimeOverride=" + this.waitTimeOverride + ", queuePollingInterval=" + this.queuePollingInterval + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/settings/internal/model/WaitConfigDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/settings/internal/model/WaitConfigDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<WaitConfigDto> serializer() {
            return WaitConfigDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public WaitConfigDto(int i, boolean z, boolean z2, boolean z3, Integer num, Integer num2, SerializationConstructorMarker serializationConstructorMarker) {
        if (31 != (i & 31)) {
            PluginExceptionsKt.throwMissingFieldException(i, 31, WaitConfigDto$$serializer.INSTANCE.getDescriptor());
        }
        this.waitTimeEnabled = z;
        this.queuePositionEnabled = z2;
        this.onlyDecreasingQueue = z3;
        this.waitTimeOverride = num;
        this.queuePollingInterval = num2;
    }

    public WaitConfigDto(boolean z, boolean z2, boolean z3, Integer num, Integer num2) {
        this.waitTimeEnabled = z;
        this.queuePositionEnabled = z2;
        this.onlyDecreasingQueue = z3;
        this.waitTimeOverride = num;
        this.queuePollingInterval = num2;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(WaitConfigDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeBooleanElement(serialDesc, 0, self.waitTimeEnabled);
        output.encodeBooleanElement(serialDesc, 1, self.queuePositionEnabled);
        output.encodeBooleanElement(serialDesc, 2, self.onlyDecreasingQueue);
        output.encodeNullableSerializableElement(serialDesc, 3, IntSerializer.INSTANCE, self.waitTimeOverride);
        output.encodeNullableSerializableElement(serialDesc, 4, IntSerializer.INSTANCE, self.queuePollingInterval);
    }

    public final boolean getWaitTimeEnabled() {
        return this.waitTimeEnabled;
    }

    public final boolean getQueuePositionEnabled() {
        return this.queuePositionEnabled;
    }

    public final boolean getOnlyDecreasingQueue() {
        return this.onlyDecreasingQueue;
    }

    public final Integer getWaitTimeOverride() {
        return this.waitTimeOverride;
    }

    public final Integer getQueuePollingInterval() {
        return this.queuePollingInterval;
    }
}
