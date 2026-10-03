package net.aihelp.data.localize.config;

import android.text.TextUtils;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.localize.LocalizeHelper;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.utils.FileUtil;
import org.json.JSONArray;
import org.json.JSONObject;

public enum TextHelper {
    INSTANCE;

    private static final int TEXT_COMMON_NEGATIVE_HINT = 2;
    private static final int TEXT_COMMON_POSITIVE_HINT = 1;
    private static final int TEXT_CS_INPUT_HINT = 3;
    private static final int TEXT_CS_INVITE_EVALUATE = 4;
    private static final int TEXT_CS_NAVIGATION_TITLE = 1;
    private static final int TEXT_CS_WELCOME_MESSAGE = 2;
    private static final int TEXT_FAQ_CS_ENTRANCE = 5;
    private static final int TEXT_FAQ_HOT_TOPIC_TITLE = 3;
    private static final int TEXT_FAQ_NAVIGATION_TITLE = 1;
    private static final int TEXT_FAQ_SEARCH_HINT = 2;
    private static final int TEXT_FAQ_SECTION_TITLE = 4;
    private static final int TYPE_COMMON_SETTINGS = 3;
    private static final int TYPE_CUSTOMER_SERVICE = 2;
    private static final int TYPE_HELP_CENTER = 1;

    public void reset() {
        CustomConfig.HelpCenter.faqNavigationTitle = "";
        CustomConfig.HelpCenter.faqSearchHint = "";
        CustomConfig.HelpCenter.faqHotTopicsTitle = "";
        CustomConfig.HelpCenter.faqSectionTitle = "";
        CustomConfig.HelpCenter.faqCSEntranceText = "";
        CustomConfig.CustomerService.csNavigationTitle = "";
        CustomConfig.CustomerService.csWelcomeMessage = "";
        CustomConfig.CustomerService.csInputHint = "";
        CustomConfig.CustomerService.csInviteEvaluate = "";
        CustomConfig.CommonSetting.commonPositiveFeedbackHint = "";
        CustomConfig.CommonSetting.commonNegativeFeedbackHint = "";
    }

    public void prepareDataSource() {
        try {
            String contentFromFile = FileUtil.getContentFromFile(LocalizeUtil.getFileLocation(LocalizeHelper.FLAG_TEXT));
            if (TextUtils.isEmpty(contentFromFile)) {
                return;
            }
            JSONArray jSONArray = new JSONArray(contentFromFile);
            for (int i = 0; i < jSONArray.length(); i++) {
                JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray, i);
                int iOptInt = jsonObject.optInt("textType");
                int iOptInt2 = jsonObject.optInt("contentType");
                String strOptString = jsonObject.optString("content");
                if (iOptInt == 1) {
                    if (iOptInt2 == 1) {
                        CustomConfig.HelpCenter.faqNavigationTitle = strOptString;
                    } else if (iOptInt2 == 2) {
                        CustomConfig.HelpCenter.faqSearchHint = strOptString;
                    } else if (iOptInt2 == 3) {
                        CustomConfig.HelpCenter.faqHotTopicsTitle = strOptString;
                    } else if (iOptInt2 == 4) {
                        CustomConfig.HelpCenter.faqSectionTitle = strOptString;
                    } else if (iOptInt2 == 5) {
                        CustomConfig.HelpCenter.faqCSEntranceText = strOptString;
                    }
                } else if (iOptInt == 2) {
                    if (iOptInt2 == 1) {
                        CustomConfig.CustomerService.csNavigationTitle = strOptString;
                    } else if (iOptInt2 == 2) {
                        CustomConfig.CustomerService.csWelcomeMessage = strOptString;
                    } else if (iOptInt2 == 3) {
                        CustomConfig.CustomerService.csInputHint = strOptString;
                    } else if (iOptInt2 == 4) {
                        CustomConfig.CustomerService.csInviteEvaluate = strOptString;
                    }
                } else if (iOptInt == 3) {
                    if (iOptInt2 == 1) {
                        CustomConfig.CommonSetting.commonPositiveFeedbackHint = strOptString;
                    } else if (iOptInt2 == 2) {
                        CustomConfig.CommonSetting.commonNegativeFeedbackHint = strOptString;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
