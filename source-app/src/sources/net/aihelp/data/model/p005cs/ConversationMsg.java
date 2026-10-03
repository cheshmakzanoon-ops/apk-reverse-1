package net.aihelp.data.model.p005cs;

import android.text.TextUtils;
import net.aihelp.p007ui.helper.BitmapHelper;

public class ConversationMsg {
    public static final int STATUS_FAILURE = 1004;
    public static final int STATUS_FAQ_HELPFUL = 200;
    public static final int STATUS_FAQ_NORMAL = 100;
    public static final int STATUS_FAQ_UNHELPFUL = 300;
    public static final int STATUS_FAQ_UNHELPFUL_FEEDBACK_GIVEN = 400;
    public static final int STATUS_RETRY = 1002;
    public static final int STATUS_SENDING = 1001;
    public static final int STATUS_SUCCESS = 1003;
    public static final int TYPE_ADMIN_FAQ = 51;
    public static final int TYPE_ADMIN_IMAGE = 81;
    public static final int TYPE_ADMIN_RICHTEXT = 101;
    public static final int TYPE_ADMIN_TEXT = 11;
    public static final int TYPE_ADMIN_TYPING = 111;
    public static final int TYPE_ADMIN_VIDEO = 91;
    public static final int TYPE_TIMESTAMP = 41;
    public static final int TYPE_USER_IMAGE = 61;
    public static final int TYPE_USER_TEXT = 21;
    public static final int TYPE_USER_TEXT_BOT = 31;
    public static final int TYPE_USER_VIDEO = 71;
    private String faqTicketId;
    private int[] imageSize;
    private boolean isMessageFromServer;
    private String msgContent;
    private int msgStatus;
    private int msgType;
    private String nickname;
    private long timeStamp;
    private String videoThumbnail;

    public void prepareVideoThumbnail() {
    }

    public ConversationMsg() {
        setTimeStamp(System.currentTimeMillis());
    }

    public ConversationMsg(int i, int i2) {
        this();
        this.msgType = i;
        this.msgStatus = i2;
    }

    public String getFaqTicketId() {
        return this.faqTicketId;
    }

    public void setFaqTicketId(String str) {
        if (TextUtils.isEmpty(str)) {
            return;
        }
        this.faqTicketId = str;
    }

    public String getNickname() {
        if (TextUtils.isEmpty(this.nickname)) {
            return "";
        }
        return this.nickname;
    }

    public void setNickname(String str) {
        this.nickname = str;
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

    public void setMessageFromServer(boolean z) {
        this.isMessageFromServer = z;
    }

    public boolean isMessageFromServer() {
        return this.isMessageFromServer;
    }

    public String getMsgContent() {
        return this.msgContent;
    }

    public void setMsgContent(String str) {
        this.msgContent = str;
    }

    public int getMsgType() {
        return this.msgType;
    }

    public void setMsgType(int i) {
        this.msgType = i;
    }

    public int getMsgStatus() {
        return this.msgStatus;
    }

    public void setMsgStatus(int i) {
        this.msgStatus = i;
    }

    public long getTimeStamp() {
        return this.timeStamp;
    }

    public void setTimeStamp(long j) {
        this.timeStamp = j;
    }

    public boolean isUserMessage() {
        return this.msgType == 21;
    }
}
