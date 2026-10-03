package net.aihelp.core.util.logger.model;

public class LogMessage {
    private final String message;
    private final String stacktrace;
    private final long timeStamp;
    private final String type;

    public LogMessage(String str, long j, String str2, String str3) {
        this.type = str;
        this.timeStamp = j;
        this.message = str2;
        this.stacktrace = str3;
    }

    public String getType() {
        return this.type;
    }

    public long getTimeStamp() {
        return this.timeStamp;
    }

    public String getMessage() {
        return this.message;
    }

    public String getStacktrace() {
        return this.stacktrace;
    }
}
