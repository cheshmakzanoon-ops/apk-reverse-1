package zendesk.conversationkit.android.internal;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.rest.model.ClientDto;
import zendesk.conversationkit.android.internal.rest.model.ClientInfoDto;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ \u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\u00032\u0006\u0010\r\u001a\u00020\u00032\b\u0010\u000e\u001a\u0004\u0018\u00010\u0003R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000f"}, m18d2 = {"Lzendesk/conversationkit/android/internal/ClientDtoProvider;", "", "sdkVendor", "", "sdkVersion", "hostAppInfo", "Lzendesk/conversationkit/android/internal/HostAppInfo;", "localeProvider", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/HostAppInfo;Lzendesk/core/ui/android/internal/local/LocaleProvider;)V", "buildClient", "Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "integrationId", Bayeux.KEY_CLIENT_ID, "pushToken", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ClientDtoProvider {
    private final HostAppInfo hostAppInfo;
    private final LocaleProvider localeProvider;
    private final String sdkVendor;
    private final String sdkVersion;

    public ClientDtoProvider(String sdkVendor, String sdkVersion, HostAppInfo hostAppInfo, LocaleProvider localeProvider) {
        Intrinsics.checkNotNullParameter(sdkVendor, "sdkVendor");
        Intrinsics.checkNotNullParameter(sdkVersion, "sdkVersion");
        Intrinsics.checkNotNullParameter(hostAppInfo, "hostAppInfo");
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        this.sdkVendor = sdkVendor;
        this.sdkVersion = sdkVersion;
        this.hostAppInfo = hostAppInfo;
        this.localeProvider = localeProvider;
    }

    public final ClientDto buildClient(String integrationId, String clientId, String pushToken) {
        Intrinsics.checkNotNullParameter(integrationId, "integrationId");
        Intrinsics.checkNotNullParameter(clientId, "clientId");
        return new ClientDto(clientId, (String) null, (String) null, "android", integrationId, pushToken, this.hostAppInfo.getAppVersion$zendesk_conversationkit_conversationkit_android(), (String) null, new ClientInfoDto(this.hostAppInfo.getAppPackage$zendesk_conversationkit_conversationkit_android(), this.hostAppInfo.getAppName$zendesk_conversationkit_conversationkit_android(), this.sdkVendor, this.sdkVersion, this.hostAppInfo.m207x1b9e53ed() + ' ' + this.hostAppInfo.getDeviceModel$zendesk_conversationkit_conversationkit_android(), this.hostAppInfo.m208x83735694(), this.hostAppInfo.m209xb0259b04(), this.hostAppInfo.m205xeb92e959(), this.hostAppInfo.m206xce3d0167(), this.localeProvider.getLocale().toLanguageTag()), 134, (DefaultConstructorMarker) null);
    }
}
