package zendesk.android.internal.proactivemessaging;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0005\b\u0000\u0018\u0000 \u00042\u00020\u0001:\u0003\u0003\u0004\u0005B\u0005¢\u0006\u0002\u0010\u0002¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/EvaluationLanguageMapper;", "", "()V", "CampaignLanguage", "Companion", "DeviceLanguage", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class EvaluationLanguageMapper {

    public static final Companion INSTANCE = new Companion(null);

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\b\u0082\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u0007j\u0002\b\b¨\u0006\t"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/EvaluationLanguageMapper$DeviceLanguage;", "", "value", "", "(Ljava/lang/String;ILjava/lang/String;)V", "getValue", "()Ljava/lang/String;", "SIMPLIFIED_CHINESE", "TRADITIONAL_CHINESE", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private enum DeviceLanguage {
        SIMPLIFIED_CHINESE("zh-Hans"),
        TRADITIONAL_CHINESE("zh-Hant");

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());
        private final String value;

        public static EnumEntries<DeviceLanguage> getEntries() {
            return $ENTRIES;
        }

        DeviceLanguage(String str) {
            this.value = str;
        }

        public final String getValue() {
            return this.value;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u0007j\u0002\b\b¨\u0006\t"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/EvaluationLanguageMapper$CampaignLanguage;", "", "value", "", "(Ljava/lang/String;ILjava/lang/String;)V", "getValue", "()Ljava/lang/String;", "SIMPLIFIED_CHINESE", "TRADITIONAL_CHINESE", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public enum CampaignLanguage {
        SIMPLIFIED_CHINESE("zh-cn"),
        TRADITIONAL_CHINESE("zh-tw");

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());
        private final String value;

        public static EnumEntries<CampaignLanguage> getEntries() {
            return $ENTRIES;
        }

        CampaignLanguage(String str) {
            this.value = str;
        }

        public final String getValue() {
            return this.value;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0019\u0010\u0003\u001a\u00020\u0004*\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0004H\u0000¢\u0006\u0002\b\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/EvaluationLanguageMapper$Companion;", "", "()V", "mapLanguage", "", "campaignLanguage", "mapLanguage$zendesk_zendesk_android", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final String mapLanguage$zendesk_zendesk_android(String str, String campaignLanguage) {
            Intrinsics.checkNotNullParameter(str, "<this>");
            Intrinsics.checkNotNullParameter(campaignLanguage, "campaignLanguage");
            if (Intrinsics.areEqual(campaignLanguage, CampaignLanguage.SIMPLIFIED_CHINESE.getValue())) {
                return StringsKt.contains$default((CharSequence) str, (CharSequence) DeviceLanguage.SIMPLIFIED_CHINESE.getValue(), false, 2, (Object) null) ? CampaignLanguage.SIMPLIFIED_CHINESE.getValue() : str;
            }
            return (Intrinsics.areEqual(campaignLanguage, CampaignLanguage.TRADITIONAL_CHINESE.getValue()) && StringsKt.contains$default((CharSequence) str, (CharSequence) DeviceLanguage.TRADITIONAL_CHINESE.getValue(), false, 2, (Object) null)) ? CampaignLanguage.TRADITIONAL_CHINESE.getValue() : str;
        }
    }
}
