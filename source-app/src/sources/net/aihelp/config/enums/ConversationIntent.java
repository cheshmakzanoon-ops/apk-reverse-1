package net.aihelp.config.enums;

public enum ConversationIntent {
    BOT_SUPPORT(1),
    HUMAN_SUPPORT(2);

    private int value;

    ConversationIntent(int i) {
        this.value = i;
    }

    public int getValue() {
        return this.value;
    }

    public static ConversationIntent fromValue(int i) {
        if (i == 1) {
            return BOT_SUPPORT;
        }
        if (i != 2) {
            return null;
        }
        return HUMAN_SUPPORT;
    }
}
