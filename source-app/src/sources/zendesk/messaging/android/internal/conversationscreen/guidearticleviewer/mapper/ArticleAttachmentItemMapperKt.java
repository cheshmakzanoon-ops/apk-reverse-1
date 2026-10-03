package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.mapper;

import android.webkit.MimeTypeMap;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import zendesk.guidekit.android.model.GuideAttachment;
import zendesk.p026ui.android.conversation.articleviewer.articleattachmentcarousel.ArticleAttachmentItem;

@Metadata(m17d1 = {"\u0000\u001e\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\u0018\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u0001H\u0000\u001a\u0010\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0002\u001a\u00020\u0001H\u0000\u001a\u0018\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007*\b\u0012\u0004\u0012\u00020\t0\u0007H\u0000¨\u0006\n"}, m18d2 = {"getFileExtension", "", "fileName", "contentType", "hasFileExtension", "", "toArticleAttachmentList", "", "Lzendesk/ui/android/conversation/articleviewer/articleattachmentcarousel/ArticleAttachmentItem;", "Lzendesk/guidekit/android/model/GuideAttachment;", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ArticleAttachmentItemMapperKt {
    public static final List<ArticleAttachmentItem> toArticleAttachmentList(List<GuideAttachment> list) {
        Intrinsics.checkNotNullParameter(list, "<this>");
        ArrayList arrayList = new ArrayList();
        for (Object obj : list) {
            if (((GuideAttachment) obj).getContentUrl().length() > 0) {
                arrayList.add(obj);
            }
        }
        ArrayList<GuideAttachment> arrayList2 = arrayList;
        ArrayList arrayList3 = new ArrayList(CollectionsKt.collectionSizeOrDefault(arrayList2, 10));
        for (GuideAttachment guideAttachment : arrayList2) {
            long id = guideAttachment.getId();
            String fileName = guideAttachment.getFileName();
            String fileExtension = getFileExtension(guideAttachment.getFileName(), guideAttachment.getContentType());
            Long size = guideAttachment.getSize();
            arrayList3.add(new ArticleAttachmentItem(id, fileName, fileExtension, size != null ? size.longValue() : 0L, guideAttachment.getContentUrl()));
        }
        return arrayList3;
    }

    public static final boolean hasFileExtension(String fileName) {
        Intrinsics.checkNotNullParameter(fileName, "fileName");
        int iLastIndexOf$default = StringsKt.lastIndexOf$default((CharSequence) fileName, '.', 0, false, 6, (Object) null);
        return (iLastIndexOf$default == -1 || iLastIndexOf$default == 0 || iLastIndexOf$default == fileName.length() - 1) ? false : true;
    }

    public static final String getFileExtension(String fileName, String contentType) {
        Intrinsics.checkNotNullParameter(fileName, "fileName");
        Intrinsics.checkNotNullParameter(contentType, "contentType");
        if (hasFileExtension(fileName)) {
            return StringsKt.substringAfterLast(fileName, '.', "");
        }
        String extensionFromMimeType = MimeTypeMap.getSingleton().getExtensionFromMimeType(contentType);
        return extensionFromMimeType == null ? "" : extensionFromMimeType;
    }
}
