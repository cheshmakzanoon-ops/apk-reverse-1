package zendesk.android.settings.internal.model;

import java.util.List;
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
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0013\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 22\u00020\u0001:\u000212BQ\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b\u0012\u000e\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\r\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010¢\u0006\u0002\u0010\u0011B3\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\u0002\u0010\u0012J\t\u0010\u001d\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001e\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001f\u001a\u00020\tHÆ\u0003J\t\u0010 \u001a\u00020\u000bHÆ\u0003J\u000f\u0010!\u001a\b\u0012\u0004\u0012\u00020\u000e0\rHÆ\u0003JA\u0010\"\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\u000e\b\u0002\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\rHÆ\u0001J\u0013\u0010#\u001a\u00020$2\b\u0010%\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010&\u001a\u00020\u0003HÖ\u0001J\t\u0010'\u001a\u00020(HÖ\u0001J&\u0010)\u001a\u00020*2\u0006\u0010+\u001a\u00020\u00002\u0006\u0010,\u001a\u00020-2\u0006\u0010.\u001a\u00020/HÁ\u0001¢\u0006\u0002\b0R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001c¨\u00063"}, m18d2 = {"Lzendesk/android/settings/internal/model/SunCoConfigDto;", "", "seen1", "", "app", "Lzendesk/android/settings/internal/model/AppDto;", "baseUrl", "Lzendesk/android/settings/internal/model/BaseUrlDto;", "integration", "Lzendesk/android/settings/internal/model/IntegrationDto;", "restRetryPolicy", "Lzendesk/android/settings/internal/model/RestRetryPolicyDto;", "integrations", "", "Lzendesk/android/settings/internal/model/ChannelIntegration;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/android/settings/internal/model/AppDto;Lzendesk/android/settings/internal/model/BaseUrlDto;Lzendesk/android/settings/internal/model/IntegrationDto;Lzendesk/android/settings/internal/model/RestRetryPolicyDto;Ljava/util/List;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/android/settings/internal/model/AppDto;Lzendesk/android/settings/internal/model/BaseUrlDto;Lzendesk/android/settings/internal/model/IntegrationDto;Lzendesk/android/settings/internal/model/RestRetryPolicyDto;Ljava/util/List;)V", "getApp", "()Lzendesk/android/settings/internal/model/AppDto;", "getBaseUrl", "()Lzendesk/android/settings/internal/model/BaseUrlDto;", "getIntegration", "()Lzendesk/android/settings/internal/model/IntegrationDto;", "getIntegrations", "()Ljava/util/List;", "getRestRetryPolicy", "()Lzendesk/android/settings/internal/model/RestRetryPolicyDto;", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class SunCoConfigDto {
    private final AppDto app;
    private final BaseUrlDto baseUrl;
    private final IntegrationDto integration;
    private final List<ChannelIntegration> integrations;
    private final RestRetryPolicyDto restRetryPolicy;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, new ArrayListSerializer(ChannelIntegration$$serializer.INSTANCE)};

    public static SunCoConfigDto copy$default(SunCoConfigDto sunCoConfigDto, AppDto appDto, BaseUrlDto baseUrlDto, IntegrationDto integrationDto, RestRetryPolicyDto restRetryPolicyDto, List list, int i, Object obj) {
        if ((i & 1) != 0) {
            appDto = sunCoConfigDto.app;
        }
        if ((i & 2) != 0) {
            baseUrlDto = sunCoConfigDto.baseUrl;
        }
        BaseUrlDto baseUrlDto2 = baseUrlDto;
        if ((i & 4) != 0) {
            integrationDto = sunCoConfigDto.integration;
        }
        IntegrationDto integrationDto2 = integrationDto;
        if ((i & 8) != 0) {
            restRetryPolicyDto = sunCoConfigDto.restRetryPolicy;
        }
        RestRetryPolicyDto restRetryPolicyDto2 = restRetryPolicyDto;
        if ((i & 16) != 0) {
            list = sunCoConfigDto.integrations;
        }
        return sunCoConfigDto.copy(appDto, baseUrlDto2, integrationDto2, restRetryPolicyDto2, list);
    }

    public final AppDto getApp() {
        return this.app;
    }

    public final BaseUrlDto getBaseUrl() {
        return this.baseUrl;
    }

    public final IntegrationDto getIntegration() {
        return this.integration;
    }

    public final RestRetryPolicyDto getRestRetryPolicy() {
        return this.restRetryPolicy;
    }

    public final List<ChannelIntegration> component5() {
        return this.integrations;
    }

    public final SunCoConfigDto copy(AppDto app, BaseUrlDto baseUrl, IntegrationDto integration, RestRetryPolicyDto restRetryPolicy, List<ChannelIntegration> integrations) {
        Intrinsics.checkNotNullParameter(app, "app");
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(integration, "integration");
        Intrinsics.checkNotNullParameter(restRetryPolicy, "restRetryPolicy");
        Intrinsics.checkNotNullParameter(integrations, "integrations");
        return new SunCoConfigDto(app, baseUrl, integration, restRetryPolicy, integrations);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof SunCoConfigDto)) {
            return false;
        }
        SunCoConfigDto sunCoConfigDto = (SunCoConfigDto) other;
        return Intrinsics.areEqual(this.app, sunCoConfigDto.app) && Intrinsics.areEqual(this.baseUrl, sunCoConfigDto.baseUrl) && Intrinsics.areEqual(this.integration, sunCoConfigDto.integration) && Intrinsics.areEqual(this.restRetryPolicy, sunCoConfigDto.restRetryPolicy) && Intrinsics.areEqual(this.integrations, sunCoConfigDto.integrations);
    }

    public int hashCode() {
        return (((((((this.app.hashCode() * 31) + this.baseUrl.hashCode()) * 31) + this.integration.hashCode()) * 31) + this.restRetryPolicy.hashCode()) * 31) + this.integrations.hashCode();
    }

    public String toString() {
        return "SunCoConfigDto(app=" + this.app + ", baseUrl=" + this.baseUrl + ", integration=" + this.integration + ", restRetryPolicy=" + this.restRetryPolicy + ", integrations=" + this.integrations + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/settings/internal/model/SunCoConfigDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/settings/internal/model/SunCoConfigDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<SunCoConfigDto> serializer() {
            return SunCoConfigDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public SunCoConfigDto(int i, AppDto appDto, BaseUrlDto baseUrlDto, IntegrationDto integrationDto, RestRetryPolicyDto restRetryPolicyDto, List list, SerializationConstructorMarker serializationConstructorMarker) {
        if (31 != (i & 31)) {
            PluginExceptionsKt.throwMissingFieldException(i, 31, SunCoConfigDto$$serializer.INSTANCE.getDescriptor());
        }
        this.app = appDto;
        this.baseUrl = baseUrlDto;
        this.integration = integrationDto;
        this.restRetryPolicy = restRetryPolicyDto;
        this.integrations = list;
    }

    public SunCoConfigDto(AppDto app, BaseUrlDto baseUrl, IntegrationDto integration, RestRetryPolicyDto restRetryPolicy, List<ChannelIntegration> integrations) {
        Intrinsics.checkNotNullParameter(app, "app");
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(integration, "integration");
        Intrinsics.checkNotNullParameter(restRetryPolicy, "restRetryPolicy");
        Intrinsics.checkNotNullParameter(integrations, "integrations");
        this.app = app;
        this.baseUrl = baseUrl;
        this.integration = integration;
        this.restRetryPolicy = restRetryPolicy;
        this.integrations = integrations;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(SunCoConfigDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeSerializableElement(serialDesc, 0, AppDto$$serializer.INSTANCE, self.app);
        output.encodeSerializableElement(serialDesc, 1, BaseUrlDto$$serializer.INSTANCE, self.baseUrl);
        output.encodeSerializableElement(serialDesc, 2, IntegrationDto$$serializer.INSTANCE, self.integration);
        output.encodeSerializableElement(serialDesc, 3, RestRetryPolicyDto$$serializer.INSTANCE, self.restRetryPolicy);
        output.encodeSerializableElement(serialDesc, 4, kSerializerArr[4], self.integrations);
    }

    public final AppDto getApp() {
        return this.app;
    }

    public final BaseUrlDto getBaseUrl() {
        return this.baseUrl;
    }

    public final IntegrationDto getIntegration() {
        return this.integration;
    }

    public final RestRetryPolicyDto getRestRetryPolicy() {
        return this.restRetryPolicy;
    }

    public final List<ChannelIntegration> getIntegrations() {
        return this.integrations;
    }
}
