package zendesk.conversationkit.android.model.attachments;

import java.io.File;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\u0002\u0003\u0004B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0002\u0005\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/conversationkit/android/model/attachments/ProcessAttachmentStatus;", "", "()V", "AttachmentAvailableInStorage", "AttachmentToBeDownloaded", "Lzendesk/conversationkit/android/model/attachments/ProcessAttachmentStatus$AttachmentAvailableInStorage;", "Lzendesk/conversationkit/android/model/attachments/ProcessAttachmentStatus$AttachmentToBeDownloaded;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ProcessAttachmentStatus {
    public ProcessAttachmentStatus(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private ProcessAttachmentStatus() {
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/model/attachments/ProcessAttachmentStatus$AttachmentAvailableInStorage;", "Lzendesk/conversationkit/android/model/attachments/ProcessAttachmentStatus;", "file", "Ljava/io/File;", "(Ljava/io/File;)V", "getFile", "()Ljava/io/File;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AttachmentAvailableInStorage extends ProcessAttachmentStatus {
        private final File file;

        public static AttachmentAvailableInStorage copy$default(AttachmentAvailableInStorage attachmentAvailableInStorage, File file, int i, Object obj) {
            if ((i & 1) != 0) {
                file = attachmentAvailableInStorage.file;
            }
            return attachmentAvailableInStorage.copy(file);
        }

        public final File getFile() {
            return this.file;
        }

        public final AttachmentAvailableInStorage copy(File file) {
            Intrinsics.checkNotNullParameter(file, "file");
            return new AttachmentAvailableInStorage(file);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AttachmentAvailableInStorage) && Intrinsics.areEqual(this.file, ((AttachmentAvailableInStorage) other).file);
        }

        public int hashCode() {
            return this.file.hashCode();
        }

        public String toString() {
            return "AttachmentAvailableInStorage(file=" + this.file + ')';
        }

        public final File getFile() {
            return this.file;
        }

        public AttachmentAvailableInStorage(File file) {
            super(null);
            Intrinsics.checkNotNullParameter(file, "file");
            this.file = file;
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÆ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/conversationkit/android/model/attachments/ProcessAttachmentStatus$AttachmentToBeDownloaded;", "Lzendesk/conversationkit/android/model/attachments/ProcessAttachmentStatus;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AttachmentToBeDownloaded extends ProcessAttachmentStatus {
        public static final AttachmentToBeDownloaded INSTANCE = new AttachmentToBeDownloaded();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof AttachmentToBeDownloaded)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return -227429599;
        }

        public String toString() {
            return "AttachmentToBeDownloaded";
        }

        private AttachmentToBeDownloaded() {
            super(null);
        }
    }
}
