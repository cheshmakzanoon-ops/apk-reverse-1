package zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0012\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001B-\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\u0006\u0010\b\u001a\u00020\u0005¢\u0006\u0002\u0010\tJ\t\u0010\u0011\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0013\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0005HÆ\u0003J;\u0010\u0016\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00032\b\b\u0002\u0010\b\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0017\u001a\u00020\u00182\b\u0010\u0019\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001a\u001a\u00020\u001bHÖ\u0001J\t\u0010\u001c\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0007\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000bR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000b¨\u0006\u001d"}, m18d2 = {"Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "", "id", "", "title", "", "type", "size", "contentUrl", "(JLjava/lang/String;Ljava/lang/String;JLjava/lang/String;)V", "getContentUrl", "()Ljava/lang/String;", "getId", "()J", "getSize", "getTitle", "getType", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleAttachmentItem {
    public static final int $stable = 0;
    private final String contentUrl;
    private final long id;
    private final long size;
    private final String title;
    private final String type;

    public final long getId() {
        return this.id;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getType() {
        return this.type;
    }

    public final long getSize() {
        return this.size;
    }

    public final String getContentUrl() {
        return this.contentUrl;
    }

    public final ArticleAttachmentItem copy(long id, String title, String type, long size, String contentUrl) {
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(contentUrl, "contentUrl");
        return new ArticleAttachmentItem(id, title, type, size, contentUrl);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ArticleAttachmentItem)) {
            return false;
        }
        ArticleAttachmentItem articleAttachmentItem = (ArticleAttachmentItem) other;
        return this.id == articleAttachmentItem.id && Intrinsics.areEqual(this.title, articleAttachmentItem.title) && Intrinsics.areEqual(this.type, articleAttachmentItem.type) && this.size == articleAttachmentItem.size && Intrinsics.areEqual(this.contentUrl, articleAttachmentItem.contentUrl);
    }

    public int hashCode() {
        return (((((((UByte$$ExternalSyntheticBackport0.m27m(this.id) * 31) + this.title.hashCode()) * 31) + this.type.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.size)) * 31) + this.contentUrl.hashCode();
    }

    public String toString() {
        return "ArticleAttachmentItem(id=" + this.id + ", title=" + this.title + ", type=" + this.type + ", size=" + this.size + ", contentUrl=" + this.contentUrl + ')';
    }

    public ArticleAttachmentItem(long j, String title, String type, long j2, String contentUrl) {
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(contentUrl, "contentUrl");
        this.id = j;
        this.title = title;
        this.type = type;
        this.size = j2;
        this.contentUrl = contentUrl;
    }

    public final long getId() {
        return this.id;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getType() {
        return this.type;
    }

    public final long getSize() {
        return this.size;
    }

    public final String getContentUrl() {
        return this.contentUrl;
    }
}
