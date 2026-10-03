package net.aihelp.config;

public class ApiConfig {
    private final String entranceId;
    private final String welcomeMessage;

    public static class Builder {
        private String entranceId;
        private String welcomeMessage;

        public Builder setEntranceId(String str) {
            this.entranceId = str;
            return this;
        }

        public Builder setWelcomeMessage(String str) {
            this.welcomeMessage = str;
            return this;
        }

        public ApiConfig build(String str, String str2) {
            return new ApiConfig(str, str2);
        }

        public ApiConfig build() {
            return new ApiConfig(this.entranceId, this.welcomeMessage);
        }
    }

    public String getWelcomeMessage() {
        return this.welcomeMessage;
    }

    public String getEntranceId() {
        return this.entranceId;
    }

    public ApiConfig(String str, String str2) {
        this.entranceId = str;
        this.welcomeMessage = str2;
    }
}
