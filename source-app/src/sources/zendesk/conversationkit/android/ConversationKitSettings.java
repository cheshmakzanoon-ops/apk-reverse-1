package zendesk.conversationkit.android;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\u0018\u0000 \u000e2\u00020\u0001:\u0003\r\u000e\u000fB\u001f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0003¢\u0006\u0002\u0010\u0007R\u0014\u0010\u0006\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\tR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\f¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitSettings;", "", "integrationId", "", "region", "Lzendesk/conversationkit/android/ConversationKitSettings$Region;", "baseUrl", "(Ljava/lang/String;Lzendesk/conversationkit/android/ConversationKitSettings$Region;Ljava/lang/String;)V", "getBaseUrl$zendesk_conversationkit_conversationkit_android", "()Ljava/lang/String;", "getIntegrationId", "getRegion", "()Lzendesk/conversationkit/android/ConversationKitSettings$Region;", "Builder", "Companion", "Region", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationKitSettings {

    public static final Companion INSTANCE = new Companion(null);
    private final String baseUrl;
    private final String integrationId;
    private final Region region;

    public ConversationKitSettings(String str, Region region, String str2, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, region, str2);
    }

    @JvmStatic
    public static final Builder builder(String str) {
        return INSTANCE.builder(str);
    }

    private ConversationKitSettings(String str, Region region, String str2) {
        this.integrationId = str;
        this.region = region;
        this.baseUrl = str2;
    }

    public final String getIntegrationId() {
        return this.integrationId;
    }

    public final Region getRegion() {
        return this.region;
    }

    public final String getBaseUrl() {
        return this.baseUrl;
    }

    @Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u0018\u00002\u00020\u0001B\u000f\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0006\u0010\b\u001a\u00020\tJ\u000e\u0010\n\u001a\u00020\u00002\u0006\u0010\u0005\u001a\u00020\u0003J\u000e\u0010\u000b\u001a\u00020\u00002\u0006\u0010\u0006\u001a\u00020\u0007R\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\f"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitSettings$Builder;", "", "integrationId", "", "(Ljava/lang/String;)V", "baseUrl", "region", "Lzendesk/conversationkit/android/ConversationKitSettings$Region;", "build", "Lzendesk/conversationkit/android/ConversationKitSettings;", "withBaseUrl", "withRegion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        private String baseUrl;
        private final String integrationId;
        private Region region;

        public Builder(String integrationId) {
            Intrinsics.checkNotNullParameter(integrationId, "integrationId");
            this.integrationId = integrationId;
            this.region = Region.US;
        }

        public final Builder withRegion(Region region) {
            Intrinsics.checkNotNullParameter(region, "region");
            this.region = region;
            return this;
        }

        public final Builder withBaseUrl(String baseUrl) {
            Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
            this.baseUrl = baseUrl;
            return this;
        }

        public final ConversationKitSettings build() {
            String str = this.integrationId;
            Region region = this.region;
            String str2 = this.baseUrl;
            if (str2 == null) {
                str2 = "";
            }
            return new ConversationKitSettings(str, region, str2, null);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u0007j\u0002\b\b¨\u0006\t"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitSettings$Region;", "", "value", "", "(Ljava/lang/String;ILjava/lang/String;)V", "getValue$zendesk_conversationkit_conversationkit_android", "()Ljava/lang/String;", "US", "EU", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public enum Region {
        US(""),
        EU(".eu-1");

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());
        private final String value;

        public static EnumEntries<Region> getEntries() {
            return $ENTRIES;
        }

        Region(String str) {
            this.value = str;
        }

        public final String getValue() {
            return this.value;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007¨\u0006\u0007"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitSettings$Companion;", "", "()V", "builder", "Lzendesk/conversationkit/android/ConversationKitSettings$Builder;", "integrationId", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @JvmStatic
        public final Builder builder(String integrationId) {
            Intrinsics.checkNotNullParameter(integrationId, "integrationId");
            return new Builder(integrationId);
        }
    }
}
