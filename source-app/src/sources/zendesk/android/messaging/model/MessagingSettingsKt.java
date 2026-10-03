package zendesk.android.messaging.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.settings.internal.model.BrandDto;
import zendesk.android.settings.internal.model.NativeMessagingDto;

@Metadata(m17d1 = {"\u0000$\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0002\u001aF\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u00072\u0006\u0010\t\u001a\u00020\u00072\b\u0010\n\u001a\u0004\u0018\u00010\u000b2\u0006\u0010\f\u001a\u00020\u0007H\u0000¨\u0006\r"}, m18d2 = {"toMessagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "Lzendesk/android/settings/internal/model/NativeMessagingDto;", "lightTheme", "Lzendesk/android/messaging/model/ColorTheme;", "darkTheme", "canUserCreateMoreConversations", "", "isMultiConversationsEnabled", "hipaaAttachmentFlag", "identifier", "", "canUserSeeConversationList", "zendesk_zendesk-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingSettingsKt {
    public static final MessagingSettings toMessagingSettings(NativeMessagingDto nativeMessagingDto, ColorTheme lightTheme, ColorTheme darkTheme, boolean z, boolean z2, boolean z3, String str, boolean z4) {
        String name;
        Intrinsics.checkNotNullParameter(nativeMessagingDto, "<this>");
        Intrinsics.checkNotNullParameter(lightTheme, "lightTheme");
        Intrinsics.checkNotNullParameter(darkTheme, "darkTheme");
        String integrationId = nativeMessagingDto.getIntegrationId();
        boolean enabled = nativeMessagingDto.getEnabled();
        BrandDto brand = nativeMessagingDto.getBrand();
        if (brand == null || (name = brand.getName()) == null) {
            name = "";
        }
        String title = nativeMessagingDto.getTitle();
        if (title == null) {
            title = "";
        }
        String description = nativeMessagingDto.getDescription();
        if (description == null) {
            description = "";
        }
        String logoUrl = nativeMessagingDto.getLogoUrl();
        return new MessagingSettings(integrationId, enabled, name, title, description, logoUrl == null ? "" : logoUrl, lightTheme, darkTheme, z, z2, z3, str == null ? "" : str, z4);
    }
}
