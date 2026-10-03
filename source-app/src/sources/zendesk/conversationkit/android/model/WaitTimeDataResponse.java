package zendesk.conversationkit.android.model;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 \u001f2\u00020\u0001:\u0002\u001e\u001fB%\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bB\r\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\tJ\t\u0010\u000e\u001a\u00020\u0005HÆ\u0003J\u0013\u0010\u000f\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0015HÖ\u0001J&\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00002\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cHÁ\u0001¢\u0006\u0002\b\u001dR\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\n\u0010\u000b\u001a\u0004\b\f\u0010\r¨\u0006 "}, m18d2 = {"Lzendesk/conversationkit/android/model/WaitTimeDataResponse;", "", "seen1", "", "waitTimeData", "Lzendesk/conversationkit/android/model/WaitTimeData;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/WaitTimeData;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/model/WaitTimeData;)V", "getWaitTimeData$annotations", "()V", "getWaitTimeData", "()Lzendesk/conversationkit/android/model/WaitTimeData;", "component1", "copy", "equals", "", "other", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class WaitTimeDataResponse {

    public static final Companion INSTANCE = new Companion(null);
    private final WaitTimeData waitTimeData;

    public static WaitTimeDataResponse copy$default(WaitTimeDataResponse waitTimeDataResponse, WaitTimeData waitTimeData, int i, Object obj) {
        if ((i & 1) != 0) {
            waitTimeData = waitTimeDataResponse.waitTimeData;
        }
        return waitTimeDataResponse.copy(waitTimeData);
    }

    @SerialName(Bayeux.KEY_DATA)
    public static void getWaitTimeData$annotations() {
    }

    public final WaitTimeData getWaitTimeData() {
        return this.waitTimeData;
    }

    public final WaitTimeDataResponse copy(WaitTimeData waitTimeData) {
        Intrinsics.checkNotNullParameter(waitTimeData, "waitTimeData");
        return new WaitTimeDataResponse(waitTimeData);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        return (other instanceof WaitTimeDataResponse) && Intrinsics.areEqual(this.waitTimeData, ((WaitTimeDataResponse) other).waitTimeData);
    }

    public int hashCode() {
        return this.waitTimeData.hashCode();
    }

    public String toString() {
        return "WaitTimeDataResponse(waitTimeData=" + this.waitTimeData + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/WaitTimeDataResponse$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/WaitTimeDataResponse;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<WaitTimeDataResponse> serializer() {
            return WaitTimeDataResponse$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public WaitTimeDataResponse(int i, @SerialName(Bayeux.KEY_DATA) WaitTimeData waitTimeData, SerializationConstructorMarker serializationConstructorMarker) {
        if (1 != (i & 1)) {
            PluginExceptionsKt.throwMissingFieldException(i, 1, WaitTimeDataResponse$$serializer.INSTANCE.getDescriptor());
        }
        this.waitTimeData = waitTimeData;
    }

    public WaitTimeDataResponse(WaitTimeData waitTimeData) {
        Intrinsics.checkNotNullParameter(waitTimeData, "waitTimeData");
        this.waitTimeData = waitTimeData;
    }

    public final WaitTimeData getWaitTimeData() {
        return this.waitTimeData;
    }
}
