package net.aihelp.config;

import net.aihelp.config.enums.ConversationIntent;

public class ConversationConfig {
    private boolean alwaysShowHumanSupportButtonInBotPage;
    private int conversationIntent;
    private String storyNode;
    private String welcomeMessage;

    public static class Builder {
        private boolean alwaysShowHumanSupportButtonInBotPage;
        private int conversationIntent = ConversationIntent.BOT_SUPPORT.getValue();
        private String storyNode;
        private String welcomeMessage;

        public Builder setConversationIntent(ConversationIntent conversationIntent) {
            this.conversationIntent = conversationIntent.getValue();
            return this;
        }

        public Builder setAlwaysShowHumanSupportButtonInBotPage(boolean z) {
            this.alwaysShowHumanSupportButtonInBotPage = z;
            return this;
        }

        public Builder setWelcomeMessage(String str) {
            this.welcomeMessage = str;
            return this;
        }

        public Builder setStoryNode(String str) {
            this.storyNode = str;
            return this;
        }

        public ConversationConfig build(int i, boolean z, String str, String str2) {
            return new ConversationConfig(i, z, str, str2);
        }

        public ConversationConfig build() {
            return new ConversationConfig(this.conversationIntent, this.alwaysShowHumanSupportButtonInBotPage, this.welcomeMessage, this.storyNode);
        }
    }

    public int getConversationIntent() {
        return this.conversationIntent;
    }

    public boolean isAlwaysShowHumanSupportButtonInBotPage() {
        return this.alwaysShowHumanSupportButtonInBotPage;
    }

    public String getWelcomeMessage() {
        return this.welcomeMessage;
    }

    public String getStoryNode() {
        return this.storyNode;
    }

    private ConversationConfig(int i, boolean z, String str, String str2) {
        this.conversationIntent = i;
        this.alwaysShowHumanSupportButtonInBotPage = z;
        this.welcomeMessage = str;
        this.storyNode = str2;
    }

    public String toString() {
        return "SupportConfig{supportIntent=" + this.conversationIntent + ", alwaysShowHumanSupportButtonInBotPage=" + this.alwaysShowHumanSupportButtonInBotPage + ", welcomeMessage='" + this.welcomeMessage + "'}";
    }
}
