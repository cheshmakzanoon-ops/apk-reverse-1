package net.aihelp.data.model.config;

import net.aihelp.data.model.init.PrivacyControlEntity;

public class BusinessLogicEntity {
    private GeneralEntity general;
    private HelpEntity help;
    private OnLineEntity onLine;

    public GeneralEntity getGeneral() {
        return this.general;
    }

    public void setGeneral(GeneralEntity generalEntity) {
        this.general = generalEntity;
    }

    public HelpEntity getHelp() {
        return this.help;
    }

    public void setHelp(HelpEntity helpEntity) {
        this.help = helpEntity;
    }

    public OnLineEntity getOnLine() {
        return this.onLine;
    }

    public void setOnLine(OnLineEntity onLineEntity) {
        this.onLine = onLineEntity;
    }

    public static class GeneralEntity {
        public static final int BG_OPTION_COLOR = 1;
        public static final int BG_OPTION_IMAGE = 2;
        private int bgOptions;
        private int direction;
        private FaqEvaluationEntity faqEvaluation;
        private PrivacyControlEntity information;

        public int getBgOptions() {
            return this.bgOptions;
        }

        public void setBgOptions(int i) {
            this.bgOptions = i;
        }

        public FaqEvaluationEntity getFaqEvaluation() {
            return this.faqEvaluation;
        }

        public void setFaqEvaluation(FaqEvaluationEntity faqEvaluationEntity) {
            this.faqEvaluation = faqEvaluationEntity;
        }

        public int getDirection() {
            return this.direction;
        }

        public void setDirection(int i) {
            this.direction = i;
        }

        public PrivacyControlEntity getInformation() {
            return this.information;
        }

        public void setInformation(PrivacyControlEntity privacyControlEntity) {
            this.information = privacyControlEntity;
        }

        public static class FaqEvaluationEntity {
            private boolean isFaqDetailValid;
            private boolean isOnlineValid;
            private boolean isOperateDetailValid;
            private boolean isSuggestionValid;

            public boolean isOnlineValid() {
                return this.isOnlineValid;
            }

            public void setOnlineValid(boolean z) {
                this.isOnlineValid = z;
            }

            public boolean isFaqDetailValid() {
                return this.isFaqDetailValid;
            }

            public void setFaqDetailValid(boolean z) {
                this.isFaqDetailValid = z;
            }

            public boolean isSuggestionValid() {
                return this.isSuggestionValid;
            }

            public void setSuggestionValid(boolean z) {
                this.isSuggestionValid = z;
            }

            public boolean isOperateDetailValid() {
                return this.isOperateDetailValid;
            }

            public void setOperateDetailValid(boolean z) {
                this.isOperateDetailValid = z;
            }
        }

        public static class InformationEntity {
            private int applicationIdentifier;
            private int applicationName;
            private int applicationVersion;
            private int batteryPower;
            private int batteryStatus;
            private int countryCode;
            private int deviceModel;
            private int freeSpacePhone;
            private int networkType;
            private int operator;
            private int osVersion;
            private int serverId;
            private int totalSpacePhone;

            public int getCountryCode() {
                return this.countryCode;
            }

            public void setCountryCode(int i) {
                this.countryCode = i;
            }

            public int getOperator() {
                return this.operator;
            }

            public void setOperator(int i) {
                this.operator = i;
            }

            public int getNetworkType() {
                return this.networkType;
            }

            public void setNetworkType(int i) {
                this.networkType = i;
            }

            public int getDeviceModel() {
                return this.deviceModel;
            }

            public void setDeviceModel(int i) {
                this.deviceModel = i;
            }

            public int getTotalSpacePhone() {
                return this.totalSpacePhone;
            }

            public void setTotalSpacePhone(int i) {
                this.totalSpacePhone = i;
            }

            public int getBatteryStatus() {
                return this.batteryStatus;
            }

            public void setBatteryStatus(int i) {
                this.batteryStatus = i;
            }

            public int getOsVersion() {
                return this.osVersion;
            }

            public void setOsVersion(int i) {
                this.osVersion = i;
            }

            public int getFreeSpacePhone() {
                return this.freeSpacePhone;
            }

            public void setFreeSpacePhone(int i) {
                this.freeSpacePhone = i;
            }

            public int getBatteryPower() {
                return this.batteryPower;
            }

            public void setBatteryPower(int i) {
                this.batteryPower = i;
            }

            public int getApplicationIdentifier() {
                return this.applicationIdentifier;
            }

            public void setApplicationIdentifier(int i) {
                this.applicationIdentifier = i;
            }

            public int getApplicationVersion() {
                return this.applicationVersion;
            }

            public void setApplicationVersion(int i) {
                this.applicationVersion = i;
            }

            public int getApplicationName() {
                return this.applicationName;
            }

            public void setApplicationName(int i) {
                this.applicationName = i;
            }

            public int getServerId() {
                return this.serverId;
            }

            public void setServerId(int i) {
                this.serverId = i;
            }
        }
    }

    public static class HelpEntity {
        public static final int ARRANGEMENT_GRID = 2;
        public static final int ARRANGEMENT_LIST = 1;
        private FaqListEntity faqList;
        private FaqSectionListEntity faqSectionList;
        private boolean isSearchValid;
        private boolean isTitleIconValid;
        private NoticeBarEntity noticeBar;

        public boolean getIsTitleIconValid() {
            return this.isTitleIconValid;
        }

        public void setIsTitleIconValid(boolean z) {
            this.isTitleIconValid = z;
        }

        public boolean getIsSearchValid() {
            return this.isSearchValid;
        }

        public void setIsSearchValid(boolean z) {
            this.isSearchValid = z;
        }

        public NoticeBarEntity getNoticeBar() {
            return this.noticeBar;
        }

        public void setNoticeBar(NoticeBarEntity noticeBarEntity) {
            this.noticeBar = noticeBarEntity;
        }

        public FaqListEntity getFaqList() {
            return this.faqList;
        }

        public void setFaqList(FaqListEntity faqListEntity) {
            this.faqList = faqListEntity;
        }

        public FaqSectionListEntity getFaqSectionList() {
            return this.faqSectionList;
        }

        public void setFaqSectionList(FaqSectionListEntity faqSectionListEntity) {
            this.faqSectionList = faqSectionListEntity;
        }

        public static class NoticeBarEntity {
            private int intervals;
            private boolean isNoticeIconValid;
            private boolean isNoticeValid;

            public boolean getIsNoticeValid() {
                return this.isNoticeValid;
            }

            public void setIsNoticeValid(boolean z) {
                this.isNoticeValid = z;
            }

            public boolean getIsNoticeIconValid() {
                return this.isNoticeIconValid;
            }

            public void setIsNoticeIconValid(boolean z) {
                this.isNoticeIconValid = z;
            }

            public int getIntervals() {
                return this.intervals;
            }

            public void setIntervals(int i) {
                this.intervals = i;
            }
        }

        public static class FaqListEntity {
            private boolean isFaqIconValid;
            private boolean isFaqListValid;
            private boolean isTitleIconValid;
            private boolean isTitleValid;

            public boolean getIsFaqListValid() {
                return this.isFaqListValid;
            }

            public void setIsFaqListValid(boolean z) {
                this.isFaqListValid = z;
            }

            public boolean getIsTitleIconValid() {
                return this.isTitleIconValid;
            }

            public void setIsTitleIconValid(boolean z) {
                this.isTitleIconValid = z;
            }

            public boolean getIsTitleValid() {
                return this.isTitleValid;
            }

            public void setIsTitleValid(boolean z) {
                this.isTitleValid = z;
            }

            public boolean getIsFaqIconValid() {
                return this.isFaqIconValid;
            }

            public void setIsFaqIconValid(boolean z) {
                this.isFaqIconValid = z;
            }
        }

        public static class FaqSectionListEntity {
            private int arrangement;
            private boolean isFaqIconValid;
            private boolean isTitleIconValid;
            private boolean isTitleValid;

            public boolean getIsTitleValid() {
                return this.isTitleValid;
            }

            public void setIsTitleValid(boolean z) {
                this.isTitleValid = z;
            }

            public boolean getIsTitleIconValid() {
                return this.isTitleIconValid;
            }

            public void setIsTitleIconValid(boolean z) {
                this.isTitleIconValid = z;
            }

            public boolean getIsFaqIconValid() {
                return this.isFaqIconValid;
            }

            public void setIsFaqIconValid(boolean z) {
                this.isFaqIconValid = z;
            }

            public int getArrangement() {
                return this.arrangement;
            }

            public void setArrangement(int i) {
                this.arrangement = i;
            }
        }
    }

    public static class OnLineEntity {
        private HistoryTicketEntity historyTicket;
        private boolean isExternalName;
        private boolean isHeadValid;
        private boolean isNavBarTitleIconValid;
        private boolean isSendTime;
        private OperateModuleEntity operateModule;
        private SatisfiedEntity satisfied;

        public boolean getIsNavBarTitleIconValid() {
            return this.isNavBarTitleIconValid;
        }

        public void setIsNavBarTitleIconValid(boolean z) {
            this.isNavBarTitleIconValid = z;
        }

        public boolean getIsHeadValid() {
            return this.isHeadValid;
        }

        public void setIsHeadValid(boolean z) {
            this.isHeadValid = z;
        }

        public boolean getIsExternalName() {
            return this.isExternalName;
        }

        public void setIsExternalName(boolean z) {
            this.isExternalName = z;
        }

        public boolean getIsSendTime() {
            return this.isSendTime;
        }

        public void setIsSendTime(boolean z) {
            this.isSendTime = z;
        }

        public HistoryTicketEntity getHistoryTicket() {
            return this.historyTicket;
        }

        public void setHistoryTicket(HistoryTicketEntity historyTicketEntity) {
            this.historyTicket = historyTicketEntity;
        }

        public SatisfiedEntity getSatisfied() {
            return this.satisfied;
        }

        public void setSatisfied(SatisfiedEntity satisfiedEntity) {
            this.satisfied = satisfiedEntity;
        }

        public OperateModuleEntity getOperateModule() {
            return this.operateModule;
        }

        public void setOperateModule(OperateModuleEntity operateModuleEntity) {
            this.operateModule = operateModuleEntity;
        }

        public static class HistoryTicketEntity {
            private boolean isValid;

            public boolean getIsValid() {
                return this.isValid;
            }

            public void setIsValid(boolean z) {
                this.isValid = z;
            }
        }

        public static class SatisfiedEntity {
            private int feedbackMax;
            private boolean isFeedback;
            private boolean isValid;

            public boolean isValid() {
                return this.isValid;
            }

            public void setValid(boolean z) {
                this.isValid = z;
            }

            public boolean isFeedback() {
                return this.isFeedback;
            }

            public void setFeedback(boolean z) {
                this.isFeedback = z;
            }

            public void setIsFeedback(boolean z) {
                this.isFeedback = z;
            }

            public int getFeedbackMax() {
                return this.feedbackMax;
            }

            public void setFeedbackMax(int i) {
                this.feedbackMax = i;
            }
        }

        public static class OperateModuleEntity {
            private boolean isEvaluation;
            private boolean isOperateModule;
            private int showOperateModule;

            public boolean getIsOperateModule() {
                return this.isOperateModule;
            }

            public void setIsOperateModule(boolean z) {
                this.isOperateModule = z;
            }

            public boolean getIsEvaluation() {
                return this.isEvaluation;
            }

            public void setIsEvaluation(boolean z) {
                this.isEvaluation = z;
            }

            public int getShowOperateModule() {
                return this.showOperateModule;
            }

            public void setShowOperateModule(int i) {
                this.showOperateModule = i;
            }
        }
    }
}
