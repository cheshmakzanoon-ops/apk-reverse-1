package net.aihelp.data.localize.config;

import android.text.TextUtils;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.data.model.config.StyleSheetEntity;
import net.aihelp.utils.FileUtil;

public enum StyleSheetHelper {
    INSTANCE;

    public void prepareDataSource() {
        StyleSheetEntity styleSheetEntity;
        try {
            String contentFromFile = FileUtil.getContentFromFile(LocalizeUtil.getFileLocation(1006));
            if (TextUtils.isEmpty(contentFromFile) || (styleSheetEntity = (StyleSheetEntity) JsonHelper.toJavaObject(contentFromFile, StyleSheetEntity.class)) == null) {
                return;
            }
            prepareCommonConfig(styleSheetEntity.getGeneral());
            prepareHelpCenterConfig(styleSheetEntity.getHelp());
            prepareCustomerServiceConfig(styleSheetEntity.getOnLine());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void prepareCustomerServiceConfig(StyleSheetEntity.OnLineEntity onLineEntity) {
        CustomConfig.CustomerService.csNavigationBarTitleIcon = onLineEntity.getNavBar();
        CustomConfig.CustomerService.csBotSupportPortrait = onLineEntity.getRobotImgUrl();
        CustomConfig.CustomerService.csManualSupportPortrait = onLineEntity.getCustomerImgUrl();
        CustomConfig.CustomerService.csUserPortrait = onLineEntity.getUserImgUrl();
    }

    private void prepareHelpCenterConfig(StyleSheetEntity.HelpEntity helpEntity) {
        CustomConfig.HelpCenter.faqNavigationBarTitleIcon = helpEntity.getNavBar();
        CustomConfig.HelpCenter.faqNotificationIcon = helpEntity.getNoticeBar();
        CustomConfig.HelpCenter.faqHotTopicTitleIcon = helpEntity.getFaqList();
        CustomConfig.HelpCenter.faqSectionTitleIcon = helpEntity.getFaqSectionList();
    }

    private void prepareCommonConfig(StyleSheetEntity.GeneralEntity generalEntity) {
        if (generalEntity.getNavBar() != null) {
            CustomConfig.CommonSetting.navigationBarBackground = generalEntity.getNavBar().getColor();
            CustomConfig.CommonSetting.navigationBarAlpha = generalEntity.getNavBar().getTransparency();
        }
        CustomConfig.CommonSetting.backgroundColorForAll = generalEntity.getVertical();
        CustomConfig.CommonSetting.backgroundImageForPortrait = generalEntity.getVerticalImgUrl();
        CustomConfig.CommonSetting.backgroundImageForLandscape = generalEntity.getHorizontalImgUrl();
        if (generalEntity.getFrontColor() != null) {
            CustomConfig.CommonSetting.upperBackgroundColor = generalEntity.getFrontColor().getColor();
            CustomConfig.CommonSetting.upperBackgroundAlpha = generalEntity.getFrontColor().getTransparency();
        }
        CustomConfig.CommonSetting.textColor = generalEntity.getTextColor();
        CustomConfig.CommonSetting.highlightedColor = generalEntity.getHighlightColor();
        CustomConfig.CommonSetting.interactElementTextColor = generalEntity.getButtonColor();
    }
}
