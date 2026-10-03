package net.aihelp.data.model.p005cs;

public class ChatInfoEntity implements Comparable<ChatInfoEntity> {
    public static final int TYPE_AGENT = 4;
    public static final int TYPE_BOT = 3;
    public static final int TYPE_TIMESTAMP = 1;
    public static final int TYPE_USER = 2;
    private String agentName;
    private String agentNickname;
    private String message;
    private int msgType;
    private long timeStamp;
    private int userId = -1;

    public int getUserId() {
        return this.userId;
    }

    public void setUserId(int i) {
        this.userId = i;
    }

    public String getAgentNickname() {
        return this.agentNickname;
    }

    public void setAgentNickname(String str) {
        this.agentNickname = str;
    }

    public String getAgentName() {
        return this.agentName;
    }

    public void setAgentName(String str) {
        this.agentName = str;
    }

    public long getTimeStamp() {
        return this.timeStamp;
    }

    public void setTimeStamp(long j) {
        this.timeStamp = j;
    }

    public int getMsgType() {
        return this.msgType;
    }

    public void setMsgType(int i) {
        this.msgType = i;
    }

    public String getMessage() {
        return this.message;
    }

    public void setMessage(String str) {
        this.message = str;
    }

    @Override
    public int compareTo(ChatInfoEntity chatInfoEntity) {
        return this.timeStamp < chatInfoEntity.getTimeStamp() ? -1 : 1;
    }
}
