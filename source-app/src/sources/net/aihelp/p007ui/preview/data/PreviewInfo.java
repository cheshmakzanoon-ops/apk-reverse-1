package net.aihelp.p007ui.preview.data;

import android.text.TextUtils;
import java.io.Serializable;
import java.util.regex.Pattern;
import net.aihelp.utils.DomainSupportHelper;
import net.aihelp.utils.RegexDefinition;

public class PreviewInfo implements Serializable {
    public static final int PREVIEW_TYPE_FILE = 3;
    public static final int PREVIEW_TYPE_IMAGE = 1;
    public static final int PREVIEW_TYPE_VIDEO = 2;
    private String fileName;
    private String filePath;
    private long fileSize;
    private boolean isPicking;
    private int type;

    private PreviewInfo() {
    }

    public static PreviewInfo get(String str) {
        return get(str, "", 0L, false);
    }

    public static PreviewInfo get(String str, String str2) {
        return get(str, str2, 0L, false);
    }

    public static PreviewInfo get(String str, String str2, long j, boolean z) {
        PreviewInfo previewInfo = new PreviewInfo();
        previewInfo.filePath = DomainSupportHelper.getAdjustedUrl(str);
        previewInfo.fileName = str2;
        previewInfo.fileSize = j;
        previewInfo.isPicking = z;
        return preparePreviewType(previewInfo);
    }

    private static PreviewInfo preparePreviewType(PreviewInfo previewInfo) {
        String filePath = previewInfo.getFilePath();
        if (Pattern.compile(RegexDefinition.ANDROID_SUPPORTED_IMAGE).matcher(filePath).matches()) {
            previewInfo.type = 1;
        } else if (Pattern.compile(RegexDefinition.ANDROID_SUPPORTED_VIDEO).matcher(filePath).matches()) {
            previewInfo.type = 2;
        } else {
            previewInfo.type = 3;
        }
        return previewInfo;
    }

    public int getType() {
        return this.type;
    }

    public String getFilePath() {
        return TextUtils.isEmpty(this.filePath) ? "" : this.filePath;
    }

    public String getFileName() {
        return TextUtils.isEmpty(this.fileName) ? "" : this.fileName;
    }

    public long getFileSize() {
        return this.fileSize;
    }

    public boolean isPicking() {
        return this.isPicking;
    }

    public boolean isImageFile() {
        return this.type == 1;
    }

    public boolean isVideoFile() {
        return this.type == 2;
    }

    public boolean isMediaFile() {
        return isImageFile() || isVideoFile();
    }
}
