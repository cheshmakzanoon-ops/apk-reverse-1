package net.aihelp.config;

import kotlinx.serialization.json.internal.AbstractJsonLexerKt;
import net.aihelp.config.enums.ShowConversationMoment;

public class FaqConfig {
    private ConversationConfig conversationConfig;
    private int showConversationMoment;

    public static class Builder {
        private int showConversationMoment = ShowConversationMoment.NEVER.getValue();
        private ConversationConfig conversationConfig = new ConversationConfig.Builder().build();

        public Builder setShowConversationMoment(ShowConversationMoment showConversationMoment) {
            this.showConversationMoment = showConversationMoment.getValue();
            return this;
        }

        public Builder setConversationConfig(ConversationConfig conversationConfig) {
            if (conversationConfig != null) {
                this.conversationConfig = conversationConfig;
            }
            return this;
        }

        public FaqConfig build(int i, ConversationConfig conversationConfig) {
            return new FaqConfig(i, conversationConfig);
        }

        public FaqConfig build() {
            return new FaqConfig(this.showConversationMoment, this.conversationConfig);
        }
    }

    public int getShowConversationMoment() {
        return this.showConversationMoment;
    }

    public ConversationConfig getConversationConfig() {
        return this.conversationConfig;
    }

    private FaqConfig(int i, ConversationConfig conversationConfig) {
        this.showConversationMoment = i;
        this.conversationConfig = conversationConfig;
    }

    public String toString() {
        return "FaqConfig{showConversationMoment=" + this.showConversationMoment + ", supportConfig=" + this.conversationConfig + AbstractJsonLexerKt.END_OBJ;
    }
}
