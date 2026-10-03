package zendesk.guidekit.android.model;

import java.util.Locale;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Regex;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0005\u0018\u0000 \u00072\u00020\u0001:\u0001\u0007B\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\b"}, m18d2 = {"Lzendesk/guidekit/android/model/GuideLocale;", "", "locale", "", "(Ljava/lang/String;)V", "getLocale", "()Ljava/lang/String;", "Companion", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class GuideLocale {

    public static final Companion INSTANCE = new Companion(null);
    private final String locale;

    public GuideLocale(String str, DefaultConstructorMarker defaultConstructorMarker) {
        this(str);
    }

    private GuideLocale(String str) {
        this.locale = str;
    }

    public final String getLocale() {
        return this.locale;
    }

    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0002J\n\u0010\u0007\u001a\u00020\b*\u00020\tJ\n\u0010\u0007\u001a\u00020\b*\u00020\u0006¨\u0006\n"}, m18d2 = {"Lzendesk/guidekit/android/model/GuideLocale$Companion;", "", "()V", "isValidGuideLocale", "", "input", "", "toGuideLocale", "Lzendesk/guidekit/android/model/GuideLocale;", "Ljava/util/Locale;", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final boolean isValidGuideLocale(String input) {
            return new Regex("[a-z]{2,3}(-[a-z0-9]{2,3})?").matches(input);
        }

        public final GuideLocale toGuideLocale(Locale locale) {
            Intrinsics.checkNotNullParameter(locale, "<this>");
            String languageTag = locale.toLanguageTag();
            Intrinsics.checkNotNullExpressionValue(languageTag, "toLanguageTag(...)");
            return toGuideLocale(languageTag);
        }

        public final GuideLocale toGuideLocale(String str) {
            String lowerCase;
            Intrinsics.checkNotNullParameter(str, "<this>");
            if (Intrinsics.areEqual(str, "zh-Hans")) {
                lowerCase = "zh-cn";
            } else if (Intrinsics.areEqual(str, "zh-Hant")) {
                lowerCase = "zh-tw";
            } else {
                Locale ROOT = Locale.ROOT;
                Intrinsics.checkNotNullExpressionValue(ROOT, "ROOT");
                lowerCase = str.toLowerCase(ROOT);
                Intrinsics.checkNotNullExpressionValue(lowerCase, "toLowerCase(...)");
            }
            DefaultConstructorMarker defaultConstructorMarker = null;
            if (isValidGuideLocale(lowerCase)) {
                return new GuideLocale(lowerCase, defaultConstructorMarker);
            }
            Logger.m219e("GuideLocale", "Unable to convert " + lowerCase + " to a GuideLocale returning en-us as default fallback", new Object[0]);
            String languageTag = Locale.US.toLanguageTag();
            Intrinsics.checkNotNullExpressionValue(languageTag, "toLanguageTag(...)");
            Locale ROOT2 = Locale.ROOT;
            Intrinsics.checkNotNullExpressionValue(ROOT2, "ROOT");
            String lowerCase2 = languageTag.toLowerCase(ROOT2);
            Intrinsics.checkNotNullExpressionValue(lowerCase2, "toLowerCase(...)");
            return new GuideLocale(lowerCase2, defaultConstructorMarker);
        }
    }
}
