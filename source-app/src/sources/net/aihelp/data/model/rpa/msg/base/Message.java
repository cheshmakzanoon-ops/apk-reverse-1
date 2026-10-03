package net.aihelp.data.model.rpa.msg.base;

import android.text.TextUtils;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.data.model.rpa.msg.BotMessage;
import net.aihelp.data.model.rpa.msg.UserMessage;
import org.json.JSONObject;

public class Message {
    public static final int STATUS_FAILURE = 3;
    public static final int STATUS_NORMAL = 1;
    public static final int STATUS_SENDING = 2;
    public static final int TYPE_AGENT_BOT_ANSWER = 5;
    public static final int TYPE_AGENT_FILE = 9;
    public static final int TYPE_AGENT_IMAGE = 6;
    public static final int TYPE_AGENT_RICH_TEXT = 8;
    public static final int TYPE_AGENT_RPA_FAQ = 4;
    public static final int TYPE_AGENT_TEXT = 3;
    public static final int TYPE_AGENT_VIDEO = 7;
    public static final int TYPE_LOADING = 2;
    public static final int TYPE_TIMESTAMP = 1;
    public static final int TYPE_USER_EVALUATE_FAQ = 13;
    public static final int TYPE_USER_FILE = 14;
    public static final int TYPE_USER_IMAGE = 11;
    public static final int TYPE_USER_TEXT = 10;
    public static final int TYPE_USER_VIDEO = 12;
    protected String content;
    private boolean enableInteraction;
    private boolean isDuringRPAProcedure;
    private boolean isNormalMessage;
    protected int msgStatus;
    protected int msgType;
    protected String nickname;
    private JSONObject requestParams;
    protected long timestamp;

    public Message() {
        this.isDuringRPAProcedure = true;
        this.enableInteraction = true;
        this.msgStatus = 1;
        setMsgStatus(1);
        setTimestamp(System.currentTimeMillis());
    }

    public Message(int i) {
        this();
        this.msgType = i;
    }

    public boolean isEnableInteraction() {
        return this.enableInteraction;
    }

    public void setEnableInteraction(boolean z) {
        this.enableInteraction = z;
    }

    public boolean isNormalMessage() {
        return this.isNormalMessage;
    }

    public void setNormalMessage(boolean z) {
        this.isNormalMessage = z;
    }

    public boolean isDuringRPAProcedure() {
        return this.isDuringRPAProcedure;
    }

    public void setDuringRPAProcedure(boolean z) {
        this.isDuringRPAProcedure = z;
    }

    public JSONObject getRequestParams() {
        return this.requestParams;
    }

    public void setRequestParams(JSONObject jSONObject) {
        this.requestParams = jSONObject;
    }

    public long getTimestamp() {
        return this.timestamp;
    }

    public void setTimestamp(long j) {
        if (j > 0) {
            this.timestamp = j;
        }
    }

    public String getNickname() {
        return this.nickname;
    }

    public void setNickname(String str) {
        this.nickname = str;
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

    public String getContent() {
        return this.content;
    }

    public void setContent(String str) {
        this.content = str;
    }

    public static Message getDefaultMessage() {
        String str;
        BotMessage botMessage = new BotMessage("");
        botMessage.setTimestamp(100L);
        if (!TextUtils.isEmpty(Const.CUSTOM_WELCOME_MSG)) {
            str = Const.CUSTOM_WELCOME_MSG;
        } else if (TextUtils.isEmpty(CustomConfig.CustomerService.csWelcomeMessage)) {
            str = "What can I do for you?";
        } else {
            str = CustomConfig.CustomerService.csWelcomeMessage;
        }
        botMessage.setContent(str);
        return botMessage;
    }

    public static Message getAgentTypingMsg() {
        return new Message(2);
    }

    public static UserMessage getUserTextMsg(String str) {
        UserMessage userMessage = new UserMessage();
        userMessage.setContent(str);
        return userMessage;
    }

    public boolean isTimeStampMessage() {
        return this.msgType == 1;
    }

    public boolean isUserMessage() {
        int i = this.msgType;
        return i == 10 || i == 11 || i == 12 || i == 13 || i == 14;
    }

    public boolean isAgentMessage() {
        int i = this.msgType;
        return i == 3 || i == 6 || i == 7 || i == 4 || i == 8 || i == 5 || i == 9;
    }

    public boolean isEmptyMessage() {
        return this.msgType <= 0;
    }
}
