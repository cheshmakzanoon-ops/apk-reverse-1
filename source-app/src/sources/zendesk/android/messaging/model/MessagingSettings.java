package zendesk.android.messaging.model;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.android.internal.InternalZendeskApi;

@InternalZendeskApi
@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b'\n\u0002\u0010\b\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001Bw\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\u000b\u0012\b\b\u0002\u0010\r\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u000e\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u000f\u001a\u00020\u0005\u0012\u0006\u0010\u0010\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0011\u001a\u00020\u0005¢\u0006\u0002\u0010\u0012J\u000b\u0010\"\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\t\u0010#\u001a\u00020\u0005HÆ\u0003J\t\u0010$\u001a\u00020\u0005HÆ\u0003J\t\u0010%\u001a\u00020\u0003HÆ\u0003J\t\u0010&\u001a\u00020\u0005HÆ\u0003J\t\u0010'\u001a\u00020\u0005HÆ\u0003J\t\u0010(\u001a\u00020\u0003HÆ\u0003J\t\u0010)\u001a\u00020\u0003HÆ\u0003J\t\u0010*\u001a\u00020\u0003HÆ\u0003J\t\u0010+\u001a\u00020\u0003HÆ\u0003J\t\u0010,\u001a\u00020\u000bHÆ\u0003J\t\u0010-\u001a\u00020\u000bHÆ\u0003J\t\u0010.\u001a\u00020\u0005HÆ\u0003J\u008d\u0001\u0010/\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\u00032\b\b\u0002\u0010\b\u001a\u00020\u00032\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\u000b2\b\b\u0002\u0010\r\u001a\u00020\u00052\b\b\u0002\u0010\u000e\u001a\u00020\u00052\b\b\u0002\u0010\u000f\u001a\u00020\u00052\b\b\u0002\u0010\u0010\u001a\u00020\u00032\b\b\u0002\u0010\u0011\u001a\u00020\u0005HÆ\u0001J\u0013\u00100\u001a\u00020\u00052\b\u00101\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00102\u001a\u000203HÖ\u0001J\t\u00104\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\r\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\u0011\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0016R\u0011\u0010\f\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0014R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0016R\u0011\u0010\u000f\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u0016R\u0011\u0010\u0010\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0014R\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0014R\u0011\u0010\u000e\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u0016R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u0019R\u0011\u0010\t\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u0014R\u0011\u0010\u0007\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\u0014¨\u00065"}, m18d2 = {"Lzendesk/android/messaging/model/MessagingSettings;", "", "integrationId", "", "enabled", "", "brand", "title", "description", "logoUrl", "lightTheme", "Lzendesk/android/messaging/model/ColorTheme;", "darkTheme", "canUserCreateMoreConversations", "isMultiConversationsEnabled", "hipaaAttachmentFlag", "identifier", "canUserSeeConversationList", "(Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/android/messaging/model/ColorTheme;Lzendesk/android/messaging/model/ColorTheme;ZZZLjava/lang/String;Z)V", "getBrand", "()Ljava/lang/String;", "getCanUserCreateMoreConversations", "()Z", "getCanUserSeeConversationList", "getDarkTheme", "()Lzendesk/android/messaging/model/ColorTheme;", "getDescription", "getEnabled", "getHipaaAttachmentFlag", "getIdentifier", "getIntegrationId", "getLightTheme", "getLogoUrl", "getTitle", "component1", "component10", "component11", "component12", "component13", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "other", "hashCode", "", "toString", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingSettings {
    private final String brand;
    private final boolean canUserCreateMoreConversations;
    private final boolean canUserSeeConversationList;
    private final ColorTheme darkTheme;
    private final String description;
    private final boolean enabled;
    private final boolean hipaaAttachmentFlag;
    private final String identifier;
    private final String integrationId;
    private final boolean isMultiConversationsEnabled;
    private final ColorTheme lightTheme;
    private final String logoUrl;
    private final String title;

    public final String getIntegrationId() {
        return this.integrationId;
    }

    public final boolean getIsMultiConversationsEnabled() {
        return this.isMultiConversationsEnabled;
    }

    public final boolean getHipaaAttachmentFlag() {
        return this.hipaaAttachmentFlag;
    }

    public final String getIdentifier() {
        return this.identifier;
    }

    public final boolean getCanUserSeeConversationList() {
        return this.canUserSeeConversationList;
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final String getBrand() {
        return this.brand;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getDescription() {
        return this.description;
    }

    public final String getLogoUrl() {
        return this.logoUrl;
    }

    public final ColorTheme getLightTheme() {
        return this.lightTheme;
    }

    public final ColorTheme getDarkTheme() {
        return this.darkTheme;
    }

    public final boolean getCanUserCreateMoreConversations() {
        return this.canUserCreateMoreConversations;
    }

    public final MessagingSettings copy(String integrationId, boolean enabled, String brand, String title, String description, String logoUrl, ColorTheme lightTheme, ColorTheme darkTheme, boolean canUserCreateMoreConversations, boolean isMultiConversationsEnabled, boolean hipaaAttachmentFlag, String identifier, boolean canUserSeeConversationList) {
        Intrinsics.checkNotNullParameter(brand, "brand");
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(description, "description");
        Intrinsics.checkNotNullParameter(logoUrl, "logoUrl");
        Intrinsics.checkNotNullParameter(lightTheme, "lightTheme");
        Intrinsics.checkNotNullParameter(darkTheme, "darkTheme");
        Intrinsics.checkNotNullParameter(identifier, "identifier");
        return new MessagingSettings(integrationId, enabled, brand, title, description, logoUrl, lightTheme, darkTheme, canUserCreateMoreConversations, isMultiConversationsEnabled, hipaaAttachmentFlag, identifier, canUserSeeConversationList);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessagingSettings)) {
            return false;
        }
        MessagingSettings messagingSettings = (MessagingSettings) other;
        return Intrinsics.areEqual(this.integrationId, messagingSettings.integrationId) && this.enabled == messagingSettings.enabled && Intrinsics.areEqual(this.brand, messagingSettings.brand) && Intrinsics.areEqual(this.title, messagingSettings.title) && Intrinsics.areEqual(this.description, messagingSettings.description) && Intrinsics.areEqual(this.logoUrl, messagingSettings.logoUrl) && Intrinsics.areEqual(this.lightTheme, messagingSettings.lightTheme) && Intrinsics.areEqual(this.darkTheme, messagingSettings.darkTheme) && this.canUserCreateMoreConversations == messagingSettings.canUserCreateMoreConversations && this.isMultiConversationsEnabled == messagingSettings.isMultiConversationsEnabled && this.hipaaAttachmentFlag == messagingSettings.hipaaAttachmentFlag && Intrinsics.areEqual(this.identifier, messagingSettings.identifier) && this.canUserSeeConversationList == messagingSettings.canUserSeeConversationList;
    }

    public int hashCode() {
        String str = this.integrationId;
        return ((((((((((((((((((((((((str == null ? 0 : str.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.enabled)) * 31) + this.brand.hashCode()) * 31) + this.title.hashCode()) * 31) + this.description.hashCode()) * 31) + this.logoUrl.hashCode()) * 31) + this.lightTheme.hashCode()) * 31) + this.darkTheme.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.canUserCreateMoreConversations)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isMultiConversationsEnabled)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.hipaaAttachmentFlag)) * 31) + this.identifier.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.canUserSeeConversationList);
    }

    public String toString() {
        return "MessagingSettings(integrationId=" + this.integrationId + ", enabled=" + this.enabled + ", brand=" + this.brand + ", title=" + this.title + ", description=" + this.description + ", logoUrl=" + this.logoUrl + ", lightTheme=" + this.lightTheme + ", darkTheme=" + this.darkTheme + ", canUserCreateMoreConversations=" + this.canUserCreateMoreConversations + ", isMultiConversationsEnabled=" + this.isMultiConversationsEnabled + ", hipaaAttachmentFlag=" + this.hipaaAttachmentFlag + ", identifier=" + this.identifier + ", canUserSeeConversationList=" + this.canUserSeeConversationList + ')';
    }

    public MessagingSettings(String str, boolean z, String brand, String title, String description, String logoUrl, ColorTheme lightTheme, ColorTheme darkTheme, boolean z2, boolean z3, boolean z4, String identifier, boolean z5) {
        Intrinsics.checkNotNullParameter(brand, "brand");
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(description, "description");
        Intrinsics.checkNotNullParameter(logoUrl, "logoUrl");
        Intrinsics.checkNotNullParameter(lightTheme, "lightTheme");
        Intrinsics.checkNotNullParameter(darkTheme, "darkTheme");
        Intrinsics.checkNotNullParameter(identifier, "identifier");
        this.integrationId = str;
        this.enabled = z;
        this.brand = brand;
        this.title = title;
        this.description = description;
        this.logoUrl = logoUrl;
        this.lightTheme = lightTheme;
        this.darkTheme = darkTheme;
        this.canUserCreateMoreConversations = z2;
        this.isMultiConversationsEnabled = z3;
        this.hipaaAttachmentFlag = z4;
        this.identifier = identifier;
        this.canUserSeeConversationList = z5;
    }

    public MessagingSettings(String str, boolean z, String str2, String str3, String str4, String str5, ColorTheme colorTheme, ColorTheme colorTheme2, boolean z2, boolean z3, boolean z4, String str6, boolean z5, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, z, str2, str3, str4, str5, colorTheme, colorTheme2, (i & 256) != 0 ? false : z2, (i & 512) != 0 ? false : z3, (i & 1024) != 0 ? false : z4, str6, (i & 4096) != 0 ? true : z5);
    }

    public final String getIntegrationId() {
        return this.integrationId;
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final String getBrand() {
        return this.brand;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getDescription() {
        return this.description;
    }

    public final String getLogoUrl() {
        return this.logoUrl;
    }

    public final ColorTheme getLightTheme() {
        return this.lightTheme;
    }

    public final ColorTheme getDarkTheme() {
        return this.darkTheme;
    }

    public final boolean getCanUserCreateMoreConversations() {
        return this.canUserCreateMoreConversations;
    }

    public final boolean isMultiConversationsEnabled() {
        return this.isMultiConversationsEnabled;
    }

    public final boolean getHipaaAttachmentFlag() {
        return this.hipaaAttachmentFlag;
    }

    public final String getIdentifier() {
        return this.identifier;
    }

    public final boolean getCanUserSeeConversationList() {
        return this.canUserSeeConversationList;
    }
}
