package zendesk.guidekit.android.model;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0014\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B/\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\u0006\u0010\b\u001a\u00020\u0006¢\u0006\u0002\u0010\tJ\t\u0010\u0013\u001a\u00020\u0003HÆ\u0003J\u0010\u0010\u0014\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\u0011J\t\u0010\u0015\u001a\u00020\u0006HÆ\u0003J\t\u0010\u0016\u001a\u00020\u0006HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0006HÆ\u0003JB\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\u00062\b\b\u0002\u0010\b\u001a\u00020\u0006HÆ\u0001¢\u0006\u0002\u0010\u0019J\u0013\u0010\u001a\u001a\u00020\u001b2\b\u0010\u001c\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001d\u001a\u00020\u001eHÖ\u0001J\t\u0010\u001f\u001a\u00020\u0006HÖ\u0001R\u0011\u0010\u0007\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\b\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\u000bR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0015\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\u0012\u001a\u0004\b\u0010\u0010\u0011¨\u0006 "}, m18d2 = {"Lzendesk/guidekit/android/model/GuideAttachment;", "", "id", "", "size", "fileName", "", "contentType", "contentUrl", "(JLjava/lang/Long;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getContentType", "()Ljava/lang/String;", "getContentUrl", "getFileName", "getId", "()J", "getSize", "()Ljava/lang/Long;", "Ljava/lang/Long;", "component1", "component2", "component3", "component4", "component5", "copy", "(JLjava/lang/Long;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lzendesk/guidekit/android/model/GuideAttachment;", "equals", "", "other", "hashCode", "", "toString", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class GuideAttachment {
    private final String contentType;
    private final String contentUrl;
    private final String fileName;
    private final long id;
    private final Long size;

    public static GuideAttachment copy$default(GuideAttachment guideAttachment, long j, Long l, String str, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            j = guideAttachment.id;
        }
        long j2 = j;
        if ((i & 2) != 0) {
            l = guideAttachment.size;
        }
        Long l2 = l;
        if ((i & 4) != 0) {
            str = guideAttachment.fileName;
        }
        String str4 = str;
        if ((i & 8) != 0) {
            str2 = guideAttachment.contentType;
        }
        String str5 = str2;
        if ((i & 16) != 0) {
            str3 = guideAttachment.contentUrl;
        }
        return guideAttachment.copy(j2, l2, str4, str5, str3);
    }

    public final long getId() {
        return this.id;
    }

    public final Long getSize() {
        return this.size;
    }

    public final String getFileName() {
        return this.fileName;
    }

    public final String getContentType() {
        return this.contentType;
    }

    public final String getContentUrl() {
        return this.contentUrl;
    }

    public final GuideAttachment copy(long id, Long size, String fileName, String contentType, String contentUrl) {
        Intrinsics.checkNotNullParameter(fileName, "fileName");
        Intrinsics.checkNotNullParameter(contentType, "contentType");
        Intrinsics.checkNotNullParameter(contentUrl, "contentUrl");
        return new GuideAttachment(id, size, fileName, contentType, contentUrl);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof GuideAttachment)) {
            return false;
        }
        GuideAttachment guideAttachment = (GuideAttachment) other;
        return this.id == guideAttachment.id && Intrinsics.areEqual(this.size, guideAttachment.size) && Intrinsics.areEqual(this.fileName, guideAttachment.fileName) && Intrinsics.areEqual(this.contentType, guideAttachment.contentType) && Intrinsics.areEqual(this.contentUrl, guideAttachment.contentUrl);
    }

    public int hashCode() {
        int iM27m = UByte$$ExternalSyntheticBackport0.m27m(this.id) * 31;
        Long l = this.size;
        return ((((((iM27m + (l == null ? 0 : l.hashCode())) * 31) + this.fileName.hashCode()) * 31) + this.contentType.hashCode()) * 31) + this.contentUrl.hashCode();
    }

    public String toString() {
        return "GuideAttachment(id=" + this.id + ", size=" + this.size + ", fileName=" + this.fileName + ", contentType=" + this.contentType + ", contentUrl=" + this.contentUrl + ')';
    }

    public GuideAttachment(long j, Long l, String fileName, String contentType, String contentUrl) {
        Intrinsics.checkNotNullParameter(fileName, "fileName");
        Intrinsics.checkNotNullParameter(contentType, "contentType");
        Intrinsics.checkNotNullParameter(contentUrl, "contentUrl");
        this.id = j;
        this.size = l;
        this.fileName = fileName;
        this.contentType = contentType;
        this.contentUrl = contentUrl;
    }

    public final long getId() {
        return this.id;
    }

    public final Long getSize() {
        return this.size;
    }

    public final String getFileName() {
        return this.fileName;
    }

    public final String getContentType() {
        return this.contentType;
    }

    public final String getContentUrl() {
        return this.contentUrl;
    }
}
