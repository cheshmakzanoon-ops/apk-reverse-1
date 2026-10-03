package zendesk.guidekit.android.model;

import java.net.MalformedURLException;
import java.net.URL;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.MatchGroup;
import kotlin.text.MatchGroupCollection;
import kotlin.text.MatchResult;
import kotlin.text.Regex;
import kotlin.text.StringsKt;
import zendesk.guidekit.android.exception.InvalidGuideArticleUrl;

@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\u0018\u0000 \u000f2\u00020\u0001:\u0001\u000fB\u001f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e¨\u0006\u0010"}, m18d2 = {"Lzendesk/guidekit/android/model/GuideArticleUrl;", "", "url", "", "articleId", "", "locale", "Lzendesk/guidekit/android/model/GuideLocale;", "(Ljava/lang/String;JLzendesk/guidekit/android/model/GuideLocale;)V", "getArticleId", "()J", "getLocale", "()Lzendesk/guidekit/android/model/GuideLocale;", "getUrl", "()Ljava/lang/String;", "Companion", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class GuideArticleUrl {

    public static final Companion INSTANCE = new Companion(null);
    private final long articleId;
    private final GuideLocale locale;
    private final String url;

    public GuideArticleUrl(String str, long j, GuideLocale guideLocale, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, j, guideLocale);
    }

    private GuideArticleUrl(String str, long j, GuideLocale guideLocale) {
        this.url = str;
        this.articleId = j;
        this.locale = guideLocale;
    }

    public final String getUrl() {
        return this.url;
    }

    public final long getArticleId() {
        return this.articleId;
    }

    public final GuideLocale getLocale() {
        return this.locale;
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\b\u0010\u0003\u001a\u00020\u0004H\u0002J\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bJ\u0016\u0010\t\u001a\u00020\n2\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\u000b\u001a\u00020\b¨\u0006\f"}, m18d2 = {"Lzendesk/guidekit/android/model/GuideArticleUrl$Companion;", "", "()V", "articleRegex", "Lkotlin/text/Regex;", "from", "Lzendesk/guidekit/android/model/GuideArticleUrl;", "url", "", "isValidGuideUrl", "", "hostMapping", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final boolean isValidGuideUrl(String url, String hostMapping) {
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(hostMapping, "hostMapping");
            try {
                URL url2 = new URL(url);
                String host = url2.getHost();
                Intrinsics.checkNotNullExpressionValue(host, "getHost(...)");
                if (!StringsKt.contains$default((CharSequence) host, (CharSequence) hostMapping, false, 2, (Object) null)) {
                    return false;
                }
                Regex regexArticleRegex = articleRegex();
                String path = url2.getPath();
                Intrinsics.checkNotNullExpressionValue(path, "getPath(...)");
                return regexArticleRegex.matches(path);
            } catch (MalformedURLException unused) {
                return false;
            }
        }

        public final GuideArticleUrl from(String url) throws InvalidGuideArticleUrl {
            MatchGroupCollection groups;
            MatchGroup matchGroup;
            String value;
            MatchGroupCollection groups2;
            MatchGroup matchGroup2;
            Intrinsics.checkNotNullParameter(url, "url");
            Long lValueOf = null;
            MatchResult matchResultFind$default = Regex.find$default(articleRegex(), url, 0, 2, null);
            String value2 = (matchResultFind$default == null || (groups2 = matchResultFind$default.getGroups()) == null || (matchGroup2 = groups2.get(1)) == null) ? null : matchGroup2.getValue();
            if (matchResultFind$default != null && (groups = matchResultFind$default.getGroups()) != null && (matchGroup = groups.get(2)) != null && (value = matchGroup.getValue()) != null) {
                lValueOf = Long.valueOf(Long.parseLong(value));
            }
            if (value2 == null || lValueOf == null) {
                throw new InvalidGuideArticleUrl(url);
            }
            return new GuideArticleUrl(url, lValueOf.longValue(), GuideLocale.INSTANCE.toGuideLocale(value2), null);
        }

        private final Regex articleRegex() {
            return new Regex("/hc/([a-z-]+)/articles/(\\d+)(?:[/-]?.*)?$");
        }
    }
}
