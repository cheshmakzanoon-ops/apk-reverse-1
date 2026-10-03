package net.aihelp.data.localize.config;

import android.text.TextUtils;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.data.model.config.BusinessLogicEntity;
import net.aihelp.utils.FileUtil;

public enum BusinessLogicHelper {
    INSTANCE;

    public void prepareDataSource() {
        BusinessLogicEntity businessLogicEntity;
        try {
            String contentFromFile = FileUtil.getContentFromFile(LocalizeUtil.getFileLocation(1007));
            if (TextUtils.isEmpty(contentFromFile) || (businessLogicEntity = (BusinessLogicEntity) JsonHelper.toJavaObject(contentFromFile, BusinessLogicEntity.class)) == null) {
                return;
            }
            prepareCommonConfig(businessLogicEntity.getGeneral());
            prepareHelpCenterConfig(businessLogicEntity.getHelp());
            prepareCustomerServiceConfig(businessLogicEntity.getOnLine());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void prepareCommonConfig(BusinessLogicEntity.GeneralEntity generalEntity) {
        CustomConfig.CommonSetting.isBackgroundRenderedWithImage = generalEntity.getBgOptions() == 2;
        if (generalEntity.getFaqEvaluation() != null) {
            CustomConfig.CommonSetting.isEvaluationForBotEnable = generalEntity.getFaqEvaluation().isOnlineValid();
            CustomConfig.CommonSetting.isEvaluationForAnswerPageEnable = generalEntity.getFaqEvaluation().isFaqDetailValid();
            CustomConfig.CommonSetting.isFaqUnhelpfulFeedbackEnable = generalEntity.getFaqEvaluation().isSuggestionValid();
            CustomConfig.CommonSetting.isEvaluationForOperationEnable = generalEntity.getFaqEvaluation().isOperateDetailValid();
        }
        CustomConfig.CommonSetting.screenOrientation = generalEntity.getDirection();
        CustomConfig.CommonSetting.privacyControlData = generalEntity.getInformation();
    }

    private void prepareHelpCenterConfig(BusinessLogicEntity.HelpEntity helpEntity) {
        CustomConfig.HelpCenter.isFaqTitleIconVisible = helpEntity.getIsTitleIconValid();
        CustomConfig.HelpCenter.isFaqSearchVisible = helpEntity.getIsSearchValid();
        if (helpEntity.getNoticeBar() != null) {
            CustomConfig.HelpCenter.isFaqNotificationVisible = helpEntity.getNoticeBar().getIsNoticeValid();
            CustomConfig.HelpCenter.isFaqNotificationIconVisible = helpEntity.getNoticeBar().getIsNoticeIconValid();
            CustomConfig.HelpCenter.faqNotificationInterval = helpEntity.getNoticeBar().getIntervals();
        }
        if (helpEntity.getFaqList() != null) {
            CustomConfig.HelpCenter.isFaqHotTopicVisible = helpEntity.getFaqList().getIsFaqListValid();
            CustomConfig.HelpCenter.isFaqHotTopicTitleVisible = helpEntity.getFaqList().getIsTitleValid();
            CustomConfig.HelpCenter.isFaqHotTopicTitleIconVisible = helpEntity.getFaqList().getIsTitleIconValid();
            CustomConfig.HelpCenter.isFaqHotTopicItemIconVisible = helpEntity.getFaqList().getIsFaqIconValid();
        }
        if (helpEntity.getFaqSectionList() != null) {
            CustomConfig.HelpCenter.isFaqSectionTitleVisible = helpEntity.getFaqSectionList().getIsTitleValid();
            CustomConfig.HelpCenter.isFaqSectionTitleIconVisible = helpEntity.getFaqSectionList().getIsTitleIconValid();
            CustomConfig.HelpCenter.isFaqSectionItemIconVisible = helpEntity.getFaqSectionList().getIsFaqIconValid();
            CustomConfig.HelpCenter.isFaqSectionDisplayAsList = helpEntity.getFaqSectionList().getArrangement() == 1;
        }
    }

    private void prepareCustomerServiceConfig(BusinessLogicEntity.OnLineEntity onLineEntity) {
        CustomConfig.CustomerService.isCsTitleIconVisible = onLineEntity.getIsNavBarTitleIconValid();
        CustomConfig.CustomerService.isPortraitVisible = onLineEntity.getIsHeadValid();
        CustomConfig.CustomerService.isNicknameVisible = onLineEntity.getIsExternalName();
        CustomConfig.CustomerService.isMessageTimestampVisible = onLineEntity.getIsSendTime();
        if (onLineEntity.getHistoryTicket() != null) {
            CustomConfig.CustomerService.isHistoryChatEnable = onLineEntity.getHistoryTicket().getIsValid();
        }
        if (onLineEntity.getSatisfied() != null) {
            CustomConfig.CustomerService.isTicketRatingEnable = onLineEntity.getSatisfied().isValid();
            CustomConfig.CustomerService.isEvaluateBadServiceEnable = onLineEntity.getSatisfied().isFeedback();
            CustomConfig.CustomerService.csEvaluateMaxCount = onLineEntity.getSatisfied().getFeedbackMax();
        }
    }
}
