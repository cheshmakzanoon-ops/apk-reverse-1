package zendesk.conversationkit.android.model;

import java.util.concurrent.TimeUnit;
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
import kotlinx.serialization.internal.EnumsKt;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u001d\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 72\u00020\u0001:\u000267Ba\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u0003\u0012\u0006\u0010\u000b\u001a\u00020\t\u0012\b\u0010\f\u001a\u0004\u0018\u00010\r\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\u0002\u0010\u0012BI\b\u0000\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u0003\u0012\u0006\u0010\u000b\u001a\u00020\t\u0012\b\b\u0002\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u0007\u0012\u0006\u0010\u000f\u001a\u00020\u0007¢\u0006\u0002\u0010\u0013J\t\u0010!\u001a\u00020\u0005HÆ\u0003J\t\u0010\"\u001a\u00020\u0007HÆ\u0003J\t\u0010#\u001a\u00020\tHÆ\u0003J\t\u0010$\u001a\u00020\u0003HÆ\u0003J\t\u0010%\u001a\u00020\tHÆ\u0003J\t\u0010&\u001a\u00020\rHÆ\u0003J\t\u0010'\u001a\u00020\u0007HÆ\u0003J\t\u0010(\u001a\u00020\u0007HÆ\u0003JY\u0010)\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u00032\b\b\u0002\u0010\u000b\u001a\u00020\t2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u00072\b\b\u0002\u0010\u000f\u001a\u00020\u0007HÆ\u0001J\u0013\u0010*\u001a\u00020\u00052\b\u0010+\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010,\u001a\u00020\u0003HÖ\u0001J\t\u0010-\u001a\u00020\u0007HÖ\u0001J&\u0010.\u001a\u00020/2\u0006\u00100\u001a\u00020\u00002\u0006\u00101\u001a\u0002022\u0006\u00103\u001a\u000204HÁ\u0001¢\u0006\u0002\b5R\u0011\u0010\u000e\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0015R\u0011\u0010\u000b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0011\u0010\n\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0018R\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u0011\u0010\u000f\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u0015¨\u00068"}, m18d2 = {"Lzendesk/conversationkit/android/model/RealtimeSettings;", "", "seen1", "", "enabled", "", "baseUrl", "", "retryInterval", "", "maxConnectionAttempts", "connectionDelay", "timeUnit", "Ljava/util/concurrent/TimeUnit;", "appId", "userId", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(IZLjava/lang/String;JIJLjava/util/concurrent/TimeUnit;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(ZLjava/lang/String;JIJLjava/util/concurrent/TimeUnit;Ljava/lang/String;Ljava/lang/String;)V", "getAppId", "()Ljava/lang/String;", "getBaseUrl", "getConnectionDelay", "()J", "getEnabled", "()Z", "getMaxConnectionAttempts", "()I", "getRetryInterval", "getTimeUnit", "()Ljava/util/concurrent/TimeUnit;", "getUserId", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "copy", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class RealtimeSettings {
    private final String appId;
    private final String baseUrl;
    private final long connectionDelay;
    private final boolean enabled;
    private final int maxConnectionAttempts;
    private final long retryInterval;
    private final TimeUnit timeUnit;
    private final String userId;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, null, EnumsKt.createSimpleEnumSerializer("java.util.concurrent.TimeUnit", TimeUnit.values()), null, null};

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final String getBaseUrl() {
        return this.baseUrl;
    }

    public final long getRetryInterval() {
        return this.retryInterval;
    }

    public final int getMaxConnectionAttempts() {
        return this.maxConnectionAttempts;
    }

    public final long getConnectionDelay() {
        return this.connectionDelay;
    }

    public final TimeUnit getTimeUnit() {
        return this.timeUnit;
    }

    public final String getAppId() {
        return this.appId;
    }

    public final String getUserId() {
        return this.userId;
    }

    public final RealtimeSettings copy(boolean enabled, String baseUrl, long retryInterval, int maxConnectionAttempts, long connectionDelay, TimeUnit timeUnit, String appId, String userId) {
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(timeUnit, "timeUnit");
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(userId, "userId");
        return new RealtimeSettings(enabled, baseUrl, retryInterval, maxConnectionAttempts, connectionDelay, timeUnit, appId, userId);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof RealtimeSettings)) {
            return false;
        }
        RealtimeSettings realtimeSettings = (RealtimeSettings) other;
        return this.enabled == realtimeSettings.enabled && Intrinsics.areEqual(this.baseUrl, realtimeSettings.baseUrl) && this.retryInterval == realtimeSettings.retryInterval && this.maxConnectionAttempts == realtimeSettings.maxConnectionAttempts && this.connectionDelay == realtimeSettings.connectionDelay && this.timeUnit == realtimeSettings.timeUnit && Intrinsics.areEqual(this.appId, realtimeSettings.appId) && Intrinsics.areEqual(this.userId, realtimeSettings.userId);
    }

    public int hashCode() {
        return (((((((((((((UByte$$ExternalSyntheticBackport0.m30m(this.enabled) * 31) + this.baseUrl.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.retryInterval)) * 31) + this.maxConnectionAttempts) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.connectionDelay)) * 31) + this.timeUnit.hashCode()) * 31) + this.appId.hashCode()) * 31) + this.userId.hashCode();
    }

    public String toString() {
        return "RealtimeSettings(enabled=" + this.enabled + ", baseUrl=" + this.baseUrl + ", retryInterval=" + this.retryInterval + ", maxConnectionAttempts=" + this.maxConnectionAttempts + ", connectionDelay=" + this.connectionDelay + ", timeUnit=" + this.timeUnit + ", appId=" + this.appId + ", userId=" + this.userId + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/RealtimeSettings$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/RealtimeSettings;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<RealtimeSettings> serializer() {
            return RealtimeSettings$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public RealtimeSettings(int i, boolean z, String str, long j, int i2, long j2, TimeUnit timeUnit, String str2, String str3, SerializationConstructorMarker serializationConstructorMarker) {
        if (223 != (i & 223)) {
            PluginExceptionsKt.throwMissingFieldException(i, 223, RealtimeSettings$$serializer.INSTANCE.getDescriptor());
        }
        this.enabled = z;
        this.baseUrl = str;
        this.retryInterval = j;
        this.maxConnectionAttempts = i2;
        this.connectionDelay = j2;
        if ((i & 32) == 0) {
            this.timeUnit = TimeUnit.SECONDS;
        } else {
            this.timeUnit = timeUnit;
        }
        this.appId = str2;
        this.userId = str3;
    }

    public RealtimeSettings(boolean z, String baseUrl, long j, int i, long j2, TimeUnit timeUnit, String appId, String userId) {
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(timeUnit, "timeUnit");
        Intrinsics.checkNotNullParameter(appId, "appId");
        Intrinsics.checkNotNullParameter(userId, "userId");
        this.enabled = z;
        this.baseUrl = baseUrl;
        this.retryInterval = j;
        this.maxConnectionAttempts = i;
        this.connectionDelay = j2;
        this.timeUnit = timeUnit;
        this.appId = appId;
        this.userId = userId;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(RealtimeSettings self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeBooleanElement(serialDesc, 0, self.enabled);
        output.encodeStringElement(serialDesc, 1, self.baseUrl);
        output.encodeLongElement(serialDesc, 2, self.retryInterval);
        output.encodeIntElement(serialDesc, 3, self.maxConnectionAttempts);
        output.encodeLongElement(serialDesc, 4, self.connectionDelay);
        if (output.shouldEncodeElementDefault(serialDesc, 5) || self.timeUnit != TimeUnit.SECONDS) {
            output.encodeSerializableElement(serialDesc, 5, kSerializerArr[5], self.timeUnit);
        }
        output.encodeStringElement(serialDesc, 6, self.appId);
        output.encodeStringElement(serialDesc, 7, self.userId);
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final String getBaseUrl() {
        return this.baseUrl;
    }

    public final long getRetryInterval() {
        return this.retryInterval;
    }

    public final int getMaxConnectionAttempts() {
        return this.maxConnectionAttempts;
    }

    public final long getConnectionDelay() {
        return this.connectionDelay;
    }

    public RealtimeSettings(boolean z, String str, long j, int i, long j2, TimeUnit timeUnit, String str2, String str3, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(z, str, j, i, j2, (i2 & 32) != 0 ? TimeUnit.SECONDS : timeUnit, str2, str3);
    }

    public final TimeUnit getTimeUnit() {
        return this.timeUnit;
    }

    public final String getAppId() {
        return this.appId;
    }

    public final String getUserId() {
        return this.userId;
    }
}
