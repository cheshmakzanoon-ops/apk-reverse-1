package zendesk.conversationkit.android.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B-\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000bJ\t\u0010\u0015\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0016\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0018\u001a\u00020\bHÆ\u0003J\t\u0010\u0019\u001a\u00020\nHÆ\u0003J;\u0010\u001a\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\nHÆ\u0001J\u0013\u0010\u001b\u001a\u00020\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001e\u001a\u00020\u001fHÖ\u0001J\t\u0010 \u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u000f¨\u0006!"}, m18d2 = {"Lzendesk/conversationkit/android/model/Config;", "", "app", "Lzendesk/conversationkit/android/model/App;", "baseUrl", "", "settingsBaseUrl", "integration", "Lzendesk/conversationkit/android/model/Integration;", "restRetryPolicy", "Lzendesk/conversationkit/android/model/RestRetryPolicy;", "(Lzendesk/conversationkit/android/model/App;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/model/Integration;Lzendesk/conversationkit/android/model/RestRetryPolicy;)V", "getApp", "()Lzendesk/conversationkit/android/model/App;", "getBaseUrl", "()Ljava/lang/String;", "getIntegration", "()Lzendesk/conversationkit/android/model/Integration;", "getRestRetryPolicy", "()Lzendesk/conversationkit/android/model/RestRetryPolicy;", "getSettingsBaseUrl", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class Config {
    private final App app;
    private final String baseUrl;
    private final Integration integration;
    private final RestRetryPolicy restRetryPolicy;
    private final String settingsBaseUrl;

    public static Config copy$default(Config config, App app, String str, String str2, Integration integration, RestRetryPolicy restRetryPolicy, int i, Object obj) {
        if ((i & 1) != 0) {
            app = config.app;
        }
        if ((i & 2) != 0) {
            str = config.baseUrl;
        }
        String str3 = str;
        if ((i & 4) != 0) {
            str2 = config.settingsBaseUrl;
        }
        String str4 = str2;
        if ((i & 8) != 0) {
            integration = config.integration;
        }
        Integration integration2 = integration;
        if ((i & 16) != 0) {
            restRetryPolicy = config.restRetryPolicy;
        }
        return config.copy(app, str3, str4, integration2, restRetryPolicy);
    }

    public final App getApp() {
        return this.app;
    }

    public final String getBaseUrl() {
        return this.baseUrl;
    }

    public final String getSettingsBaseUrl() {
        return this.settingsBaseUrl;
    }

    public final Integration getIntegration() {
        return this.integration;
    }

    public final RestRetryPolicy getRestRetryPolicy() {
        return this.restRetryPolicy;
    }

    public final Config copy(App app, String baseUrl, String settingsBaseUrl, Integration integration, RestRetryPolicy restRetryPolicy) {
        Intrinsics.checkNotNullParameter(app, "app");
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(settingsBaseUrl, "settingsBaseUrl");
        Intrinsics.checkNotNullParameter(integration, "integration");
        Intrinsics.checkNotNullParameter(restRetryPolicy, "restRetryPolicy");
        return new Config(app, baseUrl, settingsBaseUrl, integration, restRetryPolicy);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Config)) {
            return false;
        }
        Config config = (Config) other;
        return Intrinsics.areEqual(this.app, config.app) && Intrinsics.areEqual(this.baseUrl, config.baseUrl) && Intrinsics.areEqual(this.settingsBaseUrl, config.settingsBaseUrl) && Intrinsics.areEqual(this.integration, config.integration) && Intrinsics.areEqual(this.restRetryPolicy, config.restRetryPolicy);
    }

    public int hashCode() {
        return (((((((this.app.hashCode() * 31) + this.baseUrl.hashCode()) * 31) + this.settingsBaseUrl.hashCode()) * 31) + this.integration.hashCode()) * 31) + this.restRetryPolicy.hashCode();
    }

    public String toString() {
        return "Config(app=" + this.app + ", baseUrl=" + this.baseUrl + ", settingsBaseUrl=" + this.settingsBaseUrl + ", integration=" + this.integration + ", restRetryPolicy=" + this.restRetryPolicy + ')';
    }

    public Config(App app, String baseUrl, String settingsBaseUrl, Integration integration, RestRetryPolicy restRetryPolicy) {
        Intrinsics.checkNotNullParameter(app, "app");
        Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
        Intrinsics.checkNotNullParameter(settingsBaseUrl, "settingsBaseUrl");
        Intrinsics.checkNotNullParameter(integration, "integration");
        Intrinsics.checkNotNullParameter(restRetryPolicy, "restRetryPolicy");
        this.app = app;
        this.baseUrl = baseUrl;
        this.settingsBaseUrl = settingsBaseUrl;
        this.integration = integration;
        this.restRetryPolicy = restRetryPolicy;
    }

    public final App getApp() {
        return this.app;
    }

    public final String getBaseUrl() {
        return this.baseUrl;
    }

    public final String getSettingsBaseUrl() {
        return this.settingsBaseUrl;
    }

    public final Integration getIntegration() {
        return this.integration;
    }

    public final RestRetryPolicy getRestRetryPolicy() {
        return this.restRetryPolicy;
    }
}
