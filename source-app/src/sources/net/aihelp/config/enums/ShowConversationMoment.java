package net.aihelp.config.enums;

public enum ShowConversationMoment {
    NEVER(1),
    ALWAYS(2),
    ONLY_IN_ANSWER_PAGE(3),
    AFTER_MARKING_UNHELPFUL(4);

    private int value;

    ShowConversationMoment(int i) {
        this.value = i;
    }

    public int getValue() {
        return this.value;
    }

    public static ShowConversationMoment fromValue(int i) {
        if (i == 1) {
            return NEVER;
        }
        if (i == 2) {
            return ALWAYS;
        }
        if (i == 3) {
            return ONLY_IN_ANSWER_PAGE;
        }
        if (i != 4) {
            return null;
        }
        return AFTER_MARKING_UNHELPFUL;
    }
}
