package zendesk.guidekit.android.internal.data.mapper;

import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.guidekit.android.internal.rest.model.ArticleDto;
import zendesk.guidekit.android.internal.rest.model.ArticleResponseDto;
import zendesk.guidekit.android.internal.rest.model.AttachmentDto;
import zendesk.guidekit.android.internal.rest.model.AttachmentResponseDto;
import zendesk.guidekit.android.model.GuideArticle;
import zendesk.guidekit.android.model.GuideAttachment;

@Metadata(m17d1 = {"\u0000\u001c\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u001a\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004H\u0000\u001a\u0012\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004*\u00020\u0007H\u0000¨\u0006\b"}, m18d2 = {"toGuideArticle", "Lzendesk/guidekit/android/model/GuideArticle;", "Lzendesk/guidekit/android/internal/rest/model/ArticleResponseDto;", "attachments", "", "Lzendesk/guidekit/android/model/GuideAttachment;", "toGuideAttachment", "Lzendesk/guidekit/android/internal/rest/model/AttachmentResponseDto;", "zendesk.guidekit_guidekit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class GuideArticleMapperKt {
    public static final List<GuideAttachment> toGuideAttachment(AttachmentResponseDto attachmentResponseDto) {
        Intrinsics.checkNotNullParameter(attachmentResponseDto, "<this>");
        List<AttachmentDto> articleAttachments = attachmentResponseDto.getArticleAttachments();
        if (articleAttachments == null) {
            return CollectionsKt.emptyList();
        }
        List<AttachmentDto> list = articleAttachments;
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(list, 10));
        for (AttachmentDto attachmentDto : list) {
            long id = attachmentDto.getId();
            Long size = attachmentDto.getSize();
            String fileName = attachmentDto.getFileName();
            String str = fileName == null ? "" : fileName;
            String contentType = attachmentDto.getContentType();
            String str2 = contentType == null ? "" : contentType;
            String contentUrl = attachmentDto.getContentUrl();
            if (contentUrl == null) {
                contentUrl = "";
            }
            arrayList.add(new GuideAttachment(id, size, str, str2, contentUrl));
        }
        return arrayList;
    }

    public static final GuideArticle toGuideArticle(ArticleResponseDto articleResponseDto, List<GuideAttachment> attachments) {
        Intrinsics.checkNotNullParameter(articleResponseDto, "<this>");
        Intrinsics.checkNotNullParameter(attachments, "attachments");
        ArticleDto article = articleResponseDto.getArticle();
        return new GuideArticle(article.getId(), article.getLocale(), article.getHtmlUrl(), article.getTitle(), article.getBody(), attachments);
    }
}
