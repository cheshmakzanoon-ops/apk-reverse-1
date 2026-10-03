package zendesk.android.settings.internal.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0000\u001a\f\u0010\u0003\u001a\u00020\u0001*\u00020\u0002H\u0000\u001a\f\u0010\u0004\u001a\u00020\u0001*\u00020\u0002H\u0000¨\u0006\u0005"}, m18d2 = {"canUserCreateMoreConversations", "", "Lzendesk/android/settings/internal/model/SettingsDto;", "canUserSeeConversationList", "isMultiConversationsEnabled", "zendesk_zendesk-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class SettingsDtoKt {
    public static final boolean canUserCreateMoreConversations(SettingsDto settingsDto) {
        IntegrationDto integration;
        Intrinsics.checkNotNullParameter(settingsDto, "<this>");
        SunCoConfigDto sunCoConfigDto = settingsDto.getSunCoConfigDto();
        if (sunCoConfigDto == null || (integration = sunCoConfigDto.getIntegration()) == null) {
            return false;
        }
        return integration.getCanUserCreateMoreConversations();
    }

    public static final boolean canUserSeeConversationList(SettingsDto settingsDto) {
        IntegrationDto integration;
        Intrinsics.checkNotNullParameter(settingsDto, "<this>");
        SunCoConfigDto sunCoConfigDto = settingsDto.getSunCoConfigDto();
        if (sunCoConfigDto == null || (integration = sunCoConfigDto.getIntegration()) == null) {
            return true;
        }
        return integration.getCanUserSeeConversationList();
    }

    public static final boolean isMultiConversationsEnabled(SettingsDto settingsDto) {
        AppDto app;
        AppSettingsDto settings;
        Intrinsics.checkNotNullParameter(settingsDto, "<this>");
        SunCoConfigDto sunCoConfigDto = settingsDto.getSunCoConfigDto();
        if (sunCoConfigDto == null || (app = sunCoConfigDto.getApp()) == null || (settings = app.getSettings()) == null) {
            return false;
        }
        return settings.isMultiConvoEnabled();
    }
}
