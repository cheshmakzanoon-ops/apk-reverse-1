package zendesk.conversationkit.android.model.attachments;

import java.io.File;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b6\u0018\u00002\u00020\u0001:\u0002\u0003\u0004B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0002\u0005\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/conversationkit/android/model/attachments/DownloadAttachmentStatus;", "", "()V", "DownloadAttachmentFailed", "DownloadAttachmentSuccess", "Lzendesk/conversationkit/android/model/attachments/DownloadAttachmentStatus$DownloadAttachmentFailed;", "Lzendesk/conversationkit/android/model/attachments/DownloadAttachmentStatus$DownloadAttachmentSuccess;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class DownloadAttachmentStatus {
    public DownloadAttachmentStatus(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private DownloadAttachmentStatus() {
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005¢\u0006\u0002\u0010\bJ\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0005HÆ\u0003J1\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0017HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0019HÖ\u0001J\t\u0010\u001a\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\nR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\n¨\u0006\u001b"}, m18d2 = {"Lzendesk/conversationkit/android/model/attachments/DownloadAttachmentStatus$DownloadAttachmentSuccess;", "Lzendesk/conversationkit/android/model/attachments/DownloadAttachmentStatus;", "file", "Ljava/io/File;", "fileName", "", "messageId", "conversationId", "(Ljava/io/File;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getFile", "()Ljava/io/File;", "getFileName", "getMessageId", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DownloadAttachmentSuccess extends DownloadAttachmentStatus {
        private final String conversationId;
        private final File file;
        private final String fileName;
        private final String messageId;

        public static DownloadAttachmentSuccess copy$default(DownloadAttachmentSuccess downloadAttachmentSuccess, File file, String str, String str2, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                file = downloadAttachmentSuccess.file;
            }
            if ((i & 2) != 0) {
                str = downloadAttachmentSuccess.fileName;
            }
            if ((i & 4) != 0) {
                str2 = downloadAttachmentSuccess.messageId;
            }
            if ((i & 8) != 0) {
                str3 = downloadAttachmentSuccess.conversationId;
            }
            return downloadAttachmentSuccess.copy(file, str, str2, str3);
        }

        public final File getFile() {
            return this.file;
        }

        public final String getFileName() {
            return this.fileName;
        }

        public final String getMessageId() {
            return this.messageId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final DownloadAttachmentSuccess copy(File file, String fileName, String messageId, String conversationId) {
            Intrinsics.checkNotNullParameter(file, "file");
            Intrinsics.checkNotNullParameter(fileName, "fileName");
            Intrinsics.checkNotNullParameter(messageId, "messageId");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new DownloadAttachmentSuccess(file, fileName, messageId, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof DownloadAttachmentSuccess)) {
                return false;
            }
            DownloadAttachmentSuccess downloadAttachmentSuccess = (DownloadAttachmentSuccess) other;
            return Intrinsics.areEqual(this.file, downloadAttachmentSuccess.file) && Intrinsics.areEqual(this.fileName, downloadAttachmentSuccess.fileName) && Intrinsics.areEqual(this.messageId, downloadAttachmentSuccess.messageId) && Intrinsics.areEqual(this.conversationId, downloadAttachmentSuccess.conversationId);
        }

        public int hashCode() {
            return (((((this.file.hashCode() * 31) + this.fileName.hashCode()) * 31) + this.messageId.hashCode()) * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "DownloadAttachmentSuccess(file=" + this.file + ", fileName=" + this.fileName + ", messageId=" + this.messageId + ", conversationId=" + this.conversationId + ')';
        }

        public final File getFile() {
            return this.file;
        }

        public final String getFileName() {
            return this.fileName;
        }

        public final String getMessageId() {
            return this.messageId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public DownloadAttachmentSuccess(File file, String fileName, String messageId, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(file, "file");
            Intrinsics.checkNotNullParameter(fileName, "fileName");
            Intrinsics.checkNotNullParameter(messageId, "messageId");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.file = file;
            this.fileName = fileName;
            this.messageId = messageId;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0003HÆ\u0003J'\u0010\u000e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\b¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/model/attachments/DownloadAttachmentStatus$DownloadAttachmentFailed;", "Lzendesk/conversationkit/android/model/attachments/DownloadAttachmentStatus;", "fileName", "", "messageId", "conversationId", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getFileName", "getMessageId", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DownloadAttachmentFailed extends DownloadAttachmentStatus {
        private final String conversationId;
        private final String fileName;
        private final String messageId;

        public static DownloadAttachmentFailed copy$default(DownloadAttachmentFailed downloadAttachmentFailed, String str, String str2, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                str = downloadAttachmentFailed.fileName;
            }
            if ((i & 2) != 0) {
                str2 = downloadAttachmentFailed.messageId;
            }
            if ((i & 4) != 0) {
                str3 = downloadAttachmentFailed.conversationId;
            }
            return downloadAttachmentFailed.copy(str, str2, str3);
        }

        public final String getFileName() {
            return this.fileName;
        }

        public final String getMessageId() {
            return this.messageId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final DownloadAttachmentFailed copy(String fileName, String messageId, String conversationId) {
            Intrinsics.checkNotNullParameter(fileName, "fileName");
            Intrinsics.checkNotNullParameter(messageId, "messageId");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new DownloadAttachmentFailed(fileName, messageId, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof DownloadAttachmentFailed)) {
                return false;
            }
            DownloadAttachmentFailed downloadAttachmentFailed = (DownloadAttachmentFailed) other;
            return Intrinsics.areEqual(this.fileName, downloadAttachmentFailed.fileName) && Intrinsics.areEqual(this.messageId, downloadAttachmentFailed.messageId) && Intrinsics.areEqual(this.conversationId, downloadAttachmentFailed.conversationId);
        }

        public int hashCode() {
            return (((this.fileName.hashCode() * 31) + this.messageId.hashCode()) * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "DownloadAttachmentFailed(fileName=" + this.fileName + ", messageId=" + this.messageId + ", conversationId=" + this.conversationId + ')';
        }

        public final String getFileName() {
            return this.fileName;
        }

        public final String getMessageId() {
            return this.messageId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public DownloadAttachmentFailed(String fileName, String messageId, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(fileName, "fileName");
            Intrinsics.checkNotNullParameter(messageId, "messageId");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.fileName = fileName;
            this.messageId = messageId;
            this.conversationId = conversationId;
        }
    }
}
