package net.aihelp.p007ui.helper;

import android.net.Uri;

public class AttachmentPickerFile {
    public int attachmentType;
    public String filePath;
    public boolean isFileCompressionAndCopyingDone;
    public final String originalFileName;
    public final Long originalFileSize;
    public Uri transientUri;

    public AttachmentPickerFile(String str, String str2, Long l) {
        this.filePath = str;
        this.originalFileName = str2;
        this.originalFileSize = l;
    }

    public AttachmentPickerFile(Uri uri, String str, Long l) {
        this.transientUri = uri;
        this.originalFileName = str;
        this.originalFileSize = l;
    }
}
