package zendesk.conversationkit.android.internal.rest.model;

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
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0015\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 *2\u00020\u0001:\u0002)*BC\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u0003\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\u0002\u0010\rB-\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u0003¢\u0006\u0002\u0010\u000eJ\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0007HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0003HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0003HÆ\u0003J\t\u0010\u001b\u001a\u00020\u0003HÆ\u0003J;\u0010\u001c\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\u00032\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u001d\u001a\u00020\u00052\b\u0010\u001e\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001f\u001a\u00020\u0003HÖ\u0001J\t\u0010 \u001a\u00020\u0007HÖ\u0001J&\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020\u00002\u0006\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020'HÁ\u0001¢\u0006\u0002\b(R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0011\u0010\n\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\t\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0012R\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0012¨\u0006+"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/RealtimeSettingsDto;", "", "seen1", "", "enabled", "", "baseUrl", "", "retryInterval", "maxConnectionAttempts", "connectionDelay", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(IZLjava/lang/String;IIILkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(ZLjava/lang/String;III)V", "getBaseUrl", "()Ljava/lang/String;", "getConnectionDelay", "()I", "getEnabled", "()Z", "getMaxConnectionAttempts", "getRetryInterval", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class RealtimeSettingsDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String baseUrl;
    private final int connectionDelay;
    private final boolean enabled;
    private final int maxConnectionAttempts;
    private final int retryInterval;

    public static RealtimeSettingsDto copy$default(RealtimeSettingsDto realtimeSettingsDto, boolean z, String str, int i, int i2, int i3, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            z = realtimeSettingsDto.enabled;
        }
        if ((i4 & 2) != 0) {
            str = realtimeSettingsDto.baseUrl;
        }
        String str2 = str;
        if ((i4 & 4) != 0) {
            i = realtimeSettingsDto.retryInterval;
        }
        int i5 = i;
        if ((i4 & 8) != 0) {
            i2 = realtimeSettingsDto.maxConnectionAttempts;
        }
        int i6 = i2;
        if ((i4 & 16) != 0) {
            i3 = realtimeSettingsDto.connectionDelay;
        }
        return realtimeSettingsDto.copy(z, str2, i5, i6, i3);
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final String getBaseUrl() {
        return this.baseUrl;
    }

    public final int getRetryInterval() {
        return this.retryInterval;
    }

    public final int getMaxConnectionAttempts() {
        return this.maxConnectionAttempts;
    }

    public final int getConnectionDelay() {
        return this.connectionDelay;
    }

    public final RealtimeSettingsDto copy(boolean enabled, String baseUrl, int retryInterval, int maxConnectionAttempts, int connectionDelay) {
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        return new RealtimeSettingsDto(enabled, baseUrl, retryInterval, maxConnectionAttempts, connectionDelay);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof RealtimeSettingsDto)) {
            return false;
        }
        RealtimeSettingsDto realtimeSettingsDto = (RealtimeSettingsDto) other;
        return this.enabled == realtimeSettingsDto.enabled && Intrinsics.areEqual(this.baseUrl, realtimeSettingsDto.baseUrl) && this.retryInterval == realtimeSettingsDto.retryInterval && this.maxConnectionAttempts == realtimeSettingsDto.maxConnectionAttempts && this.connectionDelay == realtimeSettingsDto.connectionDelay;
    }

    public int hashCode() {
        return (((((((UByte$$ExternalSyntheticBackport0.m30m(this.enabled) * 31) + this.baseUrl.hashCode()) * 31) + this.retryInterval) * 31) + this.maxConnectionAttempts) * 31) + this.connectionDelay;
    }

    public String toString() {
        return "RealtimeSettingsDto(enabled=" + this.enabled + ", baseUrl=" + this.baseUrl + ", retryInterval=" + this.retryInterval + ", maxConnectionAttempts=" + this.maxConnectionAttempts + ", connectionDelay=" + this.connectionDelay + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/RealtimeSettingsDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/RealtimeSettingsDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<RealtimeSettingsDto> serializer() {
            return RealtimeSettingsDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public RealtimeSettingsDto(int i, boolean z, String str, int i2, int i3, int i4, SerializationConstructorMarker serializationConstructorMarker) {
        if (31 != (i & 31)) {
            PluginExceptionsKt.throwMissingFieldException(i, 31, RealtimeSettingsDto$$serializer.INSTANCE.getDescriptor());
        }
        this.enabled = z;
        this.baseUrl = str;
        this.retryInterval = i2;
        this.maxConnectionAttempts = i3;
        this.connectionDelay = i4;
    }

    public RealtimeSettingsDto(boolean z, String baseUrl, int i, int i2, int i3) {
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        this.enabled = z;
        this.baseUrl = baseUrl;
        this.retryInterval = i;
        this.maxConnectionAttempts = i2;
        this.connectionDelay = i3;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(RealtimeSettingsDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeBooleanElement(serialDesc, 0, self.enabled);
        output.encodeStringElement(serialDesc, 1, self.baseUrl);
        output.encodeIntElement(serialDesc, 2, self.retryInterval);
        output.encodeIntElement(serialDesc, 3, self.maxConnectionAttempts);
        output.encodeIntElement(serialDesc, 4, self.connectionDelay);
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final String getBaseUrl() {
        return this.baseUrl;
    }

    public final int getRetryInterval() {
        return this.retryInterval;
    }

    public final int getMaxConnectionAttempts() {
        return this.maxConnectionAttempts;
    }

    public final int getConnectionDelay() {
        return this.connectionDelay;
    }
}
