package net.aihelp.common;

import net.aihelp.data.model.init.PrivacyControlEntity;

public class CustomConfig {

    public static class CommonSetting {
        public static String backgroundColorForAll = "#FFFFFF";
        public static String backgroundImageForLandscape = "";
        public static String backgroundImageForPortrait = "";
        public static String commonNegativeFeedbackHint = "";
        public static String commonPositiveFeedbackHint = "";
        public static String highlightedColor = "#FA8A1B";
        public static String interactElementTextColor = "#1B8AFA";
        public static boolean isBackgroundRenderedWithImage = false;
        public static boolean isEvaluationForAnswerPageEnable = false;
        public static boolean isEvaluationForBotEnable = false;
        public static boolean isEvaluationForOperationEnable = false;
        public static boolean isFaqUnhelpfulFeedbackEnable = false;
        public static boolean isLandscape = false;
        public static double navigationBarAlpha = 1.0d;
        public static String navigationBarBackground = "#FFFFFF";
        public static PrivacyControlEntity privacyControlData = null;
        public static int screenOrientation = 2;
        public static String textColor = "#333940";
        public static double upperBackgroundAlpha = 1.0d;
        public static String upperBackgroundColor = "#F2F3F4";
    }

    public static class CustomerService {
        public static String csBotSupportPortrait = "";
        public static int csEvaluateMaxCount = 3;
        public static String csInputHint = "";
        public static String csInviteEvaluate = "";
        public static String csManualSupportPortrait = "";
        public static String csNavigationBarTitleIcon = "";
        public static String csNavigationTitle = "";
        public static String csUserPortrait = "";
        public static String csWelcomeMessage = "";
        public static boolean isBotResolveQueryEnable = false;
        public static boolean isCsTitleIconVisible = false;
        public static boolean isEvaluateBadServiceEnable = true;
        public static boolean isHistoryChatEnable = false;
        public static boolean isMessageTimestampVisible = false;
        public static boolean isNicknameVisible = false;
        public static boolean isPortraitVisible = false;
        public static boolean isTicketRatingEnable = true;
        public static boolean isUnhelpfulFaqStoryNodeEnable = false;
    }

    public static class HelpCenter {
        public static String faqCSEntranceText = "";
        public static String faqHotTopicTitleIcon = "";
        public static String faqHotTopicsTitle = "";
        public static String faqNavigationBarTitleIcon = "";
        public static String faqNavigationTitle = "";
        public static String faqNotificationIcon = "";
        public static int faqNotificationInterval = 3;
        public static String faqSearchHint = "";
        public static String faqSectionTitle = "";
        public static String faqSectionTitleIcon = "";
        public static boolean isFaqHotTopicItemIconVisible = true;
        public static boolean isFaqHotTopicTitleIconVisible = true;
        public static boolean isFaqHotTopicTitleVisible = true;
        public static boolean isFaqHotTopicVisible = true;
        public static boolean isFaqNotificationIconVisible = true;
        public static boolean isFaqNotificationVisible = true;
        public static boolean isFaqSearchVisible = true;
        public static boolean isFaqSectionDisplayAsList = false;
        public static boolean isFaqSectionItemIconVisible = true;
        public static boolean isFaqSectionTitleIconVisible = true;
        public static boolean isFaqSectionTitleVisible = true;
        public static boolean isFaqTitleIconVisible = true;
    }

    public static class UploadLimit {
        public static int fileMaxSize = 31457280;
        public static String fileTypes = "";
        public static int imageMaxSize = 5242880;
        public static String imageTypes = "";
        public static boolean isFileEnableUploading = false;
        public static boolean isImageEnableUploading = false;
        public static boolean isVideoEnableUploading = false;
        public static String rpaAttachmentTypes = "";
        public static int videoMaxSize = 31457280;
        public static String videoTypes = "";
    }
}
