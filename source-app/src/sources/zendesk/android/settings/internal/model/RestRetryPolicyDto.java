package zendesk.android.settings.internal.model;

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
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 $2\u00020\u0001:\u0002#$B3\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB\u001d\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003¢\u0006\u0002\u0010\u000bJ\t\u0010\u0011\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0013\u001a\u00020\u0003HÆ\u0003J'\u0010\u0014\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0019\u001a\u00020\u001aHÖ\u0001J&\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u00002\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020!HÁ\u0001¢\u0006\u0002\b\"R\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\u0007\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\r¨\u0006%"}, m18d2 = {"Lzendesk/android/settings/internal/model/RestRetryPolicyDto;", "", "seen1", "", "intervals", "Lzendesk/android/settings/internal/model/RetryIntervalDto;", "backoffMultiplier", "maxRetries", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/android/settings/internal/model/RetryIntervalDto;IILkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/android/settings/internal/model/RetryIntervalDto;II)V", "getBackoffMultiplier", "()I", "getIntervals", "()Lzendesk/android/settings/internal/model/RetryIntervalDto;", "getMaxRetries", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class RestRetryPolicyDto {

    public static final Companion INSTANCE = new Companion(null);
    private final int backoffMultiplier;
    private final RetryIntervalDto intervals;
    private final int maxRetries;

    public static RestRetryPolicyDto copy$default(RestRetryPolicyDto restRetryPolicyDto, RetryIntervalDto retryIntervalDto, int i, int i2, int i3, Object obj) {
        if ((i3 & 1) != 0) {
            retryIntervalDto = restRetryPolicyDto.intervals;
        }
        if ((i3 & 2) != 0) {
            i = restRetryPolicyDto.backoffMultiplier;
        }
        if ((i3 & 4) != 0) {
            i2 = restRetryPolicyDto.maxRetries;
        }
        return restRetryPolicyDto.copy(retryIntervalDto, i, i2);
    }

    public final RetryIntervalDto getIntervals() {
        return this.intervals;
    }

    public final int getBackoffMultiplier() {
        return this.backoffMultiplier;
    }

    public final int getMaxRetries() {
        return this.maxRetries;
    }

    public final RestRetryPolicyDto copy(RetryIntervalDto intervals, int backoffMultiplier, int maxRetries) {
        Intrinsics.checkNotNullParameter(intervals, "intervals");
        return new RestRetryPolicyDto(intervals, backoffMultiplier, maxRetries);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof RestRetryPolicyDto)) {
            return false;
        }
        RestRetryPolicyDto restRetryPolicyDto = (RestRetryPolicyDto) other;
        return Intrinsics.areEqual(this.intervals, restRetryPolicyDto.intervals) && this.backoffMultiplier == restRetryPolicyDto.backoffMultiplier && this.maxRetries == restRetryPolicyDto.maxRetries;
    }

    public int hashCode() {
        return (((this.intervals.hashCode() * 31) + this.backoffMultiplier) * 31) + this.maxRetries;
    }

    public String toString() {
        return "RestRetryPolicyDto(intervals=" + this.intervals + ", backoffMultiplier=" + this.backoffMultiplier + ", maxRetries=" + this.maxRetries + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/settings/internal/model/RestRetryPolicyDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/settings/internal/model/RestRetryPolicyDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<RestRetryPolicyDto> serializer() {
            return RestRetryPolicyDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public RestRetryPolicyDto(int i, RetryIntervalDto retryIntervalDto, int i2, int i3, SerializationConstructorMarker serializationConstructorMarker) {
        if (7 != (i & 7)) {
            PluginExceptionsKt.throwMissingFieldException(i, 7, RestRetryPolicyDto$$serializer.INSTANCE.getDescriptor());
        }
        this.intervals = retryIntervalDto;
        this.backoffMultiplier = i2;
        this.maxRetries = i3;
    }

    public RestRetryPolicyDto(RetryIntervalDto intervals, int i, int i2) {
        Intrinsics.checkNotNullParameter(intervals, "intervals");
        this.intervals = intervals;
        this.backoffMultiplier = i;
        this.maxRetries = i2;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(RestRetryPolicyDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeSerializableElement(serialDesc, 0, RetryIntervalDto$$serializer.INSTANCE, self.intervals);
        output.encodeIntElement(serialDesc, 1, self.backoffMultiplier);
        output.encodeIntElement(serialDesc, 2, self.maxRetries);
    }

    public final RetryIntervalDto getIntervals() {
        return this.intervals;
    }

    public final int getBackoffMultiplier() {
        return this.backoffMultiplier;
    }

    public final int getMaxRetries() {
        return this.maxRetries;
    }
}
