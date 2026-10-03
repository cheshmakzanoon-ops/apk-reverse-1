package net.aihelp.config;

import android.text.TextUtils;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;

public class OperationConfig {
    private ConversationConfig conversationConfig;
    private String conversationTitle;
    private int selectIndex;

    public static class Builder {
        private String conversationTitle;
        private int selectIndex = Integer.MAX_VALUE;
        private ConversationConfig conversationConfig = new ConversationConfig.Builder().build();

        public Builder setSelectIndex(int i) {
            if (i < 0) {
                i = Integer.MAX_VALUE;
            }
            this.selectIndex = i;
            return this;
        }

        public Builder setConversationTitle(String str) {
            if (!TextUtils.isEmpty(str)) {
                this.conversationTitle = str;
            }
            return this;
        }

        public Builder setConversationConfig(ConversationConfig conversationConfig) {
            this.conversationConfig = conversationConfig;
            return this;
        }

        public OperationConfig build(int i, String str, ConversationConfig conversationConfig) {
            return setSelectIndex(i).setConversationTitle(str).setConversationConfig(conversationConfig).build();
        }

        public OperationConfig build() {
            return new OperationConfig(this.selectIndex, this.conversationTitle, this.conversationConfig);
        }
    }

    public int getSelectIndex() {
        return this.selectIndex;
    }

    public String getConversationTitle() {
        return this.conversationTitle;
    }

    public ConversationConfig getConversationConfig() {
        return this.conversationConfig;
    }

    private OperationConfig(int i, String str, ConversationConfig conversationConfig) {
        this.selectIndex = i;
        this.conversationTitle = str;
        this.conversationConfig = conversationConfig;
    }

    public String toString() {
        return "OperationConfig{selectIndex=" + this.selectIndex + ", supportBotTitle='" + this.conversationTitle + "', supportConfig=" + this.conversationConfig + AbstractJsonLexerKt.END_OBJ;
    }
}
