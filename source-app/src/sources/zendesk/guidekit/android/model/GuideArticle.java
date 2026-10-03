package zendesk.guidekit.android.model;

import java.util.List;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0012\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001BA\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\n¢\u0006\u0002\u0010\fJ\t\u0010\u0016\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J\u000b\u0010\u0018\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010\u0019\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010\u001a\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u000b0\nHÆ\u0003JQ\u0010\u001c\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00052\u000e\b\u0002\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\nHÆ\u0001J\u0013\u0010\u001d\u001a\u00020\u001e2\b\u0010\u001f\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010 \u001a\u00020!HÖ\u0001J\t\u0010\"\u001a\u00020\u0005HÖ\u0001R\u0017\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\n¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0013\u0010\b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0010R\u0013\u0010\u0007\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0010¨\u0006#"}, m18d2 = {"Lzendesk/guidekit/android/model/GuideArticle;", "", "id", "", "locale", "", "htmlUrl", "title", "htmlBody", "attachments", "", "Lzendesk/guidekit/android/model/GuideAttachment;", "(JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;)V", "getAttachments", "()Ljava/util/List;", "getHtmlBody", "()Ljava/lang/String;", "getHtmlUrl", "getId", "()J", "getLocale", "getTitle", "component1", "component2", "component3", "component4", "component5", "component6", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class GuideArticle {
    private final List<GuideAttachment> attachments;
    private final String htmlBody;
    private final String htmlUrl;
    private final long id;
    private final String locale;
    private final String title;

    public final long getId() {
        return this.id;
    }

    public final String getLocale() {
        return this.locale;
    }

    public final String getHtmlUrl() {
        return this.htmlUrl;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getHtmlBody() {
        return this.htmlBody;
    }

    public final List<GuideAttachment> component6() {
        return this.attachments;
    }

    public final GuideArticle copy(long id, String locale, String htmlUrl, String title, String htmlBody, List<GuideAttachment> attachments) {
        Intrinsics.checkNotNullParameter(locale, "locale");
        Intrinsics.checkNotNullParameter(attachments, "attachments");
        return new GuideArticle(id, locale, htmlUrl, title, htmlBody, attachments);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof GuideArticle)) {
            return false;
        }
        GuideArticle guideArticle = (GuideArticle) other;
        return this.id == guideArticle.id && Intrinsics.areEqual(this.locale, guideArticle.locale) && Intrinsics.areEqual(this.htmlUrl, guideArticle.htmlUrl) && Intrinsics.areEqual(this.title, guideArticle.title) && Intrinsics.areEqual(this.htmlBody, guideArticle.htmlBody) && Intrinsics.areEqual(this.attachments, guideArticle.attachments);
    }

    public int hashCode() {
        int iM27m = ((UByte$$ExternalSyntheticBackport0.m27m(this.id) * 31) + this.locale.hashCode()) * 31;
        String str = this.htmlUrl;
        int iHashCode = (iM27m + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.title;
        int iHashCode2 = (iHashCode + (str2 == null ? 0 : str2.hashCode())) * 31;
        String str3 = this.htmlBody;
        return ((iHashCode2 + (str3 != null ? str3.hashCode() : 0)) * 31) + this.attachments.hashCode();
    }

    public String toString() {
        return "GuideArticle(id=" + this.id + ", locale=" + this.locale + ", htmlUrl=" + this.htmlUrl + ", title=" + this.title + ", htmlBody=" + this.htmlBody + ", attachments=" + this.attachments + ')';
    }

    public GuideArticle(long j, String locale, String str, String str2, String str3, List<GuideAttachment> attachments) {
        Intrinsics.checkNotNullParameter(locale, "locale");
        Intrinsics.checkNotNullParameter(attachments, "attachments");
        this.id = j;
        this.locale = locale;
        this.htmlUrl = str;
        this.title = str2;
        this.htmlBody = str3;
        this.attachments = attachments;
    }

    public final long getId() {
        return this.id;
    }

    public final String getLocale() {
        return this.locale;
    }

    public final String getHtmlUrl() {
        return this.htmlUrl;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getHtmlBody() {
        return this.htmlBody;
    }

    public final List<GuideAttachment> getAttachments() {
        return this.attachments;
    }
}
