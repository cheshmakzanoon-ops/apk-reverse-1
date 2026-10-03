package zendesk.core.android.internal.app;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import zendesk.core.android.internal.InternalZendeskApi;

@InternalZendeskApi
@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\b\r\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B#\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0003¢\u0006\u0002\u0010\u0006J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0003HÆ\u0003J'\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u00032\b\u0010\u000f\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\b¨\u0006\u0014"}, m18d2 = {"Lzendesk/core/android/internal/app/FeatureFlagManager;", "", "isConversationExtensionBackButtonEnabled", "", "enableConversationFieldValidator", "enableWaitTimeBanner", "(ZZZ)V", "getEnableConversationFieldValidator", "()Z", "getEnableWaitTimeBanner", "component1", "component2", "component3", "copy", "equals", "other", "hashCode", "", "toString", "", "zendesk.core_core-utilities"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FeatureFlagManager {
    private final boolean enableConversationFieldValidator;
    private final boolean enableWaitTimeBanner;
    private final boolean isConversationExtensionBackButtonEnabled;

    public FeatureFlagManager() {
        this(false, false, false, 7, null);
    }

    public static FeatureFlagManager copy$default(FeatureFlagManager featureFlagManager, boolean z, boolean z2, boolean z3, int i, Object obj) {
        if ((i & 1) != 0) {
            z = featureFlagManager.isConversationExtensionBackButtonEnabled;
        }
        if ((i & 2) != 0) {
            z2 = featureFlagManager.enableConversationFieldValidator;
        }
        if ((i & 4) != 0) {
            z3 = featureFlagManager.enableWaitTimeBanner;
        }
        return featureFlagManager.copy(z, z2, z3);
    }

    public final boolean getIsConversationExtensionBackButtonEnabled() {
        return this.isConversationExtensionBackButtonEnabled;
    }

    public final boolean getEnableConversationFieldValidator() {
        return this.enableConversationFieldValidator;
    }

    public final boolean getEnableWaitTimeBanner() {
        return this.enableWaitTimeBanner;
    }

    public final FeatureFlagManager copy(boolean isConversationExtensionBackButtonEnabled, boolean enableConversationFieldValidator, boolean enableWaitTimeBanner) {
        return new FeatureFlagManager(isConversationExtensionBackButtonEnabled, enableConversationFieldValidator, enableWaitTimeBanner);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof FeatureFlagManager)) {
            return false;
        }
        FeatureFlagManager featureFlagManager = (FeatureFlagManager) other;
        return this.isConversationExtensionBackButtonEnabled == featureFlagManager.isConversationExtensionBackButtonEnabled && this.enableConversationFieldValidator == featureFlagManager.enableConversationFieldValidator && this.enableWaitTimeBanner == featureFlagManager.enableWaitTimeBanner;
    }

    public int hashCode() {
        return (((UByte$$ExternalSyntheticBackport0.m30m(this.isConversationExtensionBackButtonEnabled) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.enableConversationFieldValidator)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.enableWaitTimeBanner);
    }

    public String toString() {
        return "FeatureFlagManager(isConversationExtensionBackButtonEnabled=" + this.isConversationExtensionBackButtonEnabled + ", enableConversationFieldValidator=" + this.enableConversationFieldValidator + ", enableWaitTimeBanner=" + this.enableWaitTimeBanner + ')';
    }

    public FeatureFlagManager(boolean z, boolean z2, boolean z3) {
        this.isConversationExtensionBackButtonEnabled = z;
        this.enableConversationFieldValidator = z2;
        this.enableWaitTimeBanner = z3;
    }

    public FeatureFlagManager(boolean z, boolean z2, boolean z3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? false : z, (i & 2) != 0 ? false : z2, (i & 4) != 0 ? false : z3);
    }

    public final boolean isConversationExtensionBackButtonEnabled() {
        return this.isConversationExtensionBackButtonEnabled;
    }

    public final boolean getEnableConversationFieldValidator() {
        return this.enableConversationFieldValidator;
    }

    public final boolean getEnableWaitTimeBanner() {
        return this.enableWaitTimeBanner;
    }
}
