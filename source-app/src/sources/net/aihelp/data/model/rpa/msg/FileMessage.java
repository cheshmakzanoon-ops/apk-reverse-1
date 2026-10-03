package net.aihelp.data.model.rpa.msg;

import java.text.DecimalFormat;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.helper.BitmapHelper;
import net.aihelp.utils.MediaUtils;
import okhttp3.internal.p011ws.RealWebSocket;

public class FileMessage extends Message {
    private String fileName;
    private long fileSize;
    private int[] imageSize;
    private String videoThumbnail;

    public FileMessage(int i) {
        this(i, "");
    }

    public FileMessage(int i, String str) {
        super(i);
        setContent(str);
    }

    public String getFileName() {
        return this.fileName;
    }

    public void setFileInfo(String str, long j) {
        this.fileName = str;
        this.fileSize = j;
    }

    public String getFileSize() {
        DecimalFormat decimalFormat = new DecimalFormat("#.00");
        long j = this.fileSize;
        if (j == 0) {
            return "0B";
        }
        if (j < RealWebSocket.DEFAULT_MINIMUM_DEFLATE_SIZE) {
            return this.fileSize + "B";
        }
        if (j < 1048576) {
            return decimalFormat.format(this.fileSize / 1024.0d) + "KB";
        }
        if (j < 1073741824) {
            return decimalFormat.format(this.fileSize / 1048576.0d) + "MB";
        }
        return decimalFormat.format(this.fileSize / 1.073741824E9d) + "GB";
    }

    public String getVideoThumbnail() {
        return this.videoThumbnail;
    }

    public void setVideoThumbnail(String str) {
        this.videoThumbnail = str;
        setImageSize(BitmapHelper.computeSize(str));
    }

    public int[] getImageSize() {
        return this.imageSize;
    }

    public void setImageSize(int[] iArr) {
        this.imageSize = iArr;
    }

    public void prepareVideoThumbnail() {
        setVideoThumbnail(MediaUtils.getImageForVideoSync(getContent()));
    }
}
