package zendesk.conversationkit.android.model;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0016\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 ,2\u00020\u0001:\u0002+,BC\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0005\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0001\u0010\b\u001a\u00020\t\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB'\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\rJ\t\u0010\u0019\u001a\u00020\u0003HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\u001b\u001a\u0004\u0018\u00010\u0007HÆ\u0003J\t\u0010\u001c\u001a\u00020\tHÆ\u0003J3\u0010\u001d\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\b\u001a\u00020\tHÆ\u0001J\u0013\u0010\u001e\u001a\u00020\t2\b\u0010\u001f\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010 \u001a\u00020\u0003HÖ\u0001J\t\u0010!\u001a\u00020\"HÖ\u0001J&\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020\u00002\u0006\u0010&\u001a\u00020'2\u0006\u0010(\u001a\u00020)HÁ\u0001¢\u0006\u0002\b*R\u001c\u0010\b\u001a\u00020\t8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u000e\u0010\u000f\u001a\u0004\b\b\u0010\u0010R\u001c\u0010\u0005\u001a\u00020\u00038\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0011\u0010\u000f\u001a\u0004\b\u0012\u0010\u0013R\u001c\u0010\u0004\u001a\u00020\u00038\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0014\u0010\u000f\u001a\u0004\b\u0015\u0010\u0013R\u001e\u0010\u0006\u001a\u0004\u0018\u00010\u00078\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0016\u0010\u000f\u001a\u0004\b\u0017\u0010\u0018¨\u0006-"}, m18d2 = {"Lzendesk/conversationkit/android/model/WaitTimeData;", "", "seen1", "", "queuePosition", "lowestQueuePosition", "responseTimeDto", "Lzendesk/conversationkit/android/model/ResponseTimeDto;", "isInitialRouting", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(IIILzendesk/conversationkit/android/model/ResponseTimeDto;ZLkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(IILzendesk/conversationkit/android/model/ResponseTimeDto;Z)V", "isInitialRouting$annotations", "()V", "()Z", "getLowestQueuePosition$annotations", "getLowestQueuePosition", "()I", "getQueuePosition$annotations", "getQueuePosition", "getResponseTimeDto$annotations", "getResponseTimeDto", "()Lzendesk/conversationkit/android/model/ResponseTimeDto;", "component1", "component2", "component3", "component4", "copy", "equals", "other", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class WaitTimeData {

    public static final Companion INSTANCE = new Companion(null);
    private final boolean isInitialRouting;
    private final int lowestQueuePosition;
    private final int queuePosition;
    private final ResponseTimeDto responseTimeDto;

    public static WaitTimeData copy$default(WaitTimeData waitTimeData, int i, int i2, ResponseTimeDto responseTimeDto, boolean z, int i3, Object obj) {
        if ((i3 & 1) != 0) {
            i = waitTimeData.queuePosition;
        }
        if ((i3 & 2) != 0) {
            i2 = waitTimeData.lowestQueuePosition;
        }
        if ((i3 & 4) != 0) {
            responseTimeDto = waitTimeData.responseTimeDto;
        }
        if ((i3 & 8) != 0) {
            z = waitTimeData.isInitialRouting;
        }
        return waitTimeData.copy(i, i2, responseTimeDto, z);
    }

    @SerialName("lowest_queue_position")
    public static void getLowestQueuePosition$annotations() {
    }

    @SerialName("queue_position")
    public static void getQueuePosition$annotations() {
    }

    @SerialName("response_time")
    public static void getResponseTimeDto$annotations() {
    }

    @SerialName("is_initial_routing")
    public static void isInitialRouting$annotations() {
    }

    public final int getQueuePosition() {
        return this.queuePosition;
    }

    public final int getLowestQueuePosition() {
        return this.lowestQueuePosition;
    }

    public final ResponseTimeDto getResponseTimeDto() {
        return this.responseTimeDto;
    }

    public final boolean getIsInitialRouting() {
        return this.isInitialRouting;
    }

    public final WaitTimeData copy(int queuePosition, int lowestQueuePosition, ResponseTimeDto responseTimeDto, boolean isInitialRouting) {
        return new WaitTimeData(queuePosition, lowestQueuePosition, responseTimeDto, isInitialRouting);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof WaitTimeData)) {
            return false;
        }
        WaitTimeData waitTimeData = (WaitTimeData) other;
        return this.queuePosition == waitTimeData.queuePosition && this.lowestQueuePosition == waitTimeData.lowestQueuePosition && Intrinsics.areEqual(this.responseTimeDto, waitTimeData.responseTimeDto) && this.isInitialRouting == waitTimeData.isInitialRouting;
    }

    public int hashCode() {
        int i = ((this.queuePosition * 31) + this.lowestQueuePosition) * 31;
        ResponseTimeDto responseTimeDto = this.responseTimeDto;
        return ((i + (responseTimeDto == null ? 0 : responseTimeDto.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isInitialRouting);
    }

    public String toString() {
        return "WaitTimeData(queuePosition=" + this.queuePosition + ", lowestQueuePosition=" + this.lowestQueuePosition + ", responseTimeDto=" + this.responseTimeDto + ", isInitialRouting=" + this.isInitialRouting + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/WaitTimeData$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/WaitTimeData;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<WaitTimeData> serializer() {
            return WaitTimeData$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public WaitTimeData(int i, @SerialName("queue_position") int i2, @SerialName("lowest_queue_position") int i3, @SerialName("response_time") ResponseTimeDto responseTimeDto, @SerialName("is_initial_routing") boolean z, SerializationConstructorMarker serializationConstructorMarker) {
        if (15 != (i & 15)) {
            PluginExceptionsKt.throwMissingFieldException(i, 15, WaitTimeData$$serializer.INSTANCE.getDescriptor());
        }
        this.queuePosition = i2;
        this.lowestQueuePosition = i3;
        this.responseTimeDto = responseTimeDto;
        this.isInitialRouting = z;
    }

    public WaitTimeData(int i, int i2, ResponseTimeDto responseTimeDto, boolean z) {
        this.queuePosition = i;
        this.lowestQueuePosition = i2;
        this.responseTimeDto = responseTimeDto;
        this.isInitialRouting = z;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(WaitTimeData self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeIntElement(serialDesc, 0, self.queuePosition);
        output.encodeIntElement(serialDesc, 1, self.lowestQueuePosition);
        output.encodeNullableSerializableElement(serialDesc, 2, ResponseTimeDto$$serializer.INSTANCE, self.responseTimeDto);
        output.encodeBooleanElement(serialDesc, 3, self.isInitialRouting);
    }

    public final int getQueuePosition() {
        return this.queuePosition;
    }

    public final int getLowestQueuePosition() {
        return this.lowestQueuePosition;
    }

    public final ResponseTimeDto getResponseTimeDto() {
        return this.responseTimeDto;
    }

    public final boolean isInitialRouting() {
        return this.isInitialRouting;
    }
}
