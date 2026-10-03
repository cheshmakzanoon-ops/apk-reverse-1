package net.aihelp.common;

import android.content.Context;
import android.content.Intent;
import net.aihelp.config.enums.ShowConversationMoment;
import net.aihelp.data.model.config.ProcessEntity;
import net.aihelp.p007ui.HostActivity;

public class IntentValues {
    public static final String BOTTOM_DURING_PROCEDURE = "bottom_during_procedure";
    public static final String BOTTOM_FAQ_CONTENT_ID = "bottom_faq_content_id";
    public static final String BOTTOM_SELF_SERVICE = "bottom_self_service";
    public static final String BOTTOM_TICKET_FINISHED = "bottom_ticket_finished";
    public static final String BOT_EMBEDDED_IN_OPERATION = "bot_embedded_in_operation";
    public static final String BOT_INTENT_ACTION_NAME = "bot_intent_action_name";
    public static final String BOT_INTENT_LIST = "bot_intent_list";
    public static final String CONTACT_US_ALWAYS_ONLINE = "isContactUsAlwaysOnline";
    public static final String FAQ_MAIN_ID = "faq_main_id";
    public static final String FAQ_SUPPORT_MOMENT = "faq_support_moment";
    public static final int HIDE_CS_LOADING = 1004;
    public static final int HIDE_SUPPORT_ACTION = 1002;
    public static final String HUMAN_EMBEDDED_IN_OPERATION = "HUMAN_embedded_in_operation";
    public static final String INTENT_URL = "intent_url";
    public static final String INTENT_URL_TITLE = "intent_url_title";
    public static final int MODE_CONVERSATION = 2;
    public static final int MODE_CUSTOMER_SERVICE = 7;
    public static final int MODE_ELVA = 1;
    public static final int MODE_ERROR_ENTRANCE = 8;
    public static final int MODE_OPERATE = 5;
    public static final int MODE_SHOW_SECTION = 3;
    public static final int MODE_SHOW_SINGLE_FAQ = 4;
    public static final int MODE_URL = 6;
    public static final String OPERATE_SECTION_ID = "operate_section";
    public static final String OPERATE_SELECT_INDEX = "operate_select_position";
    public static final String OPERATE_SUPPORT_BOT_TITLE = "operate_elva_title";
    public static final int PAGE_HOPPING_CONVERSATION = 1008;
    public static final int PAGE_HOPPING_FORM = 1009;
    public static final String PREVIEW_INFO = "preview_info";
    public static final int REQUEST_CODE_ATTACHMENT = 1001;
    public static final int REQUEST_CODE_PREVIEW = 1002;
    public static final String SEARCH_MATCH = "search_match";
    public static final String SECTION_ICON = "section_icon";
    public static final String SECTION_ID = "section_id";
    public static final String SECTION_NAME = "section_name";
    public static final int SHOW_CS_LOADING = 1003;
    public static final int SHOW_SUPPORT_ACTION = 1001;
    public static final String SKIP_ELVA_IN_FAQ = "skip_elva_in_faq";
    public static final String SUB_SECTION_ID = "sub_section_id";
    public static final int SUPPORT_ACTION_FAQ = 1005;
    public static final int SUPPORT_ACTION_MSG = 1006;
    public static final int SUPPORT_ACTION_MSG_UNREAD = 1007;
    public static final String SUPPORT_MODE = "support_mode";

    public static Intent getShowErrorEntranceIntent(Context context) {
        Intent intent = new Intent(context, (Class<?>) HostActivity.class);
        intent.putExtra(SUPPORT_MODE, 8);
        return intent;
    }

    public static Intent getShowFAQIntent(Context context, ProcessEntity processEntity) {
        Intent intent = new Intent(context, (Class<?>) HostActivity.class);
        intent.putExtra(FAQ_SUPPORT_MOMENT, processEntity.getFaqEntrances());
        return intent;
    }

    public static Intent getShowFAQSectionIntent(Context context, ProcessEntity processEntity) {
        Intent intent = new Intent(context, (Class<?>) HostActivity.class);
        intent.putExtra(SUPPORT_MODE, 3);
        intent.putExtra(SECTION_ID, processEntity.getSectionId());
        intent.putExtra(FAQ_SUPPORT_MOMENT, processEntity.getFaqEntrances());
        return intent;
    }

    public static Intent getShowSingleFAQIntent(Context context, ProcessEntity processEntity) {
        Intent intent = new Intent(context, (Class<?>) HostActivity.class);
        intent.putExtra(SUPPORT_MODE, 4);
        intent.putExtra(FAQ_MAIN_ID, processEntity.getFaqId());
        intent.putExtra(FAQ_SUPPORT_MOMENT, processEntity.getFaqEntrances());
        return intent;
    }

    public static Intent getShowSingleFAQIntent(Context context, String str, ShowConversationMoment showConversationMoment) {
        Intent intent = new Intent(context, (Class<?>) HostActivity.class);
        intent.putExtra(SUPPORT_MODE, 4);
        intent.putExtra(FAQ_MAIN_ID, str);
        intent.putExtra(FAQ_SUPPORT_MOMENT, getFaqEntranceByMoment(showConversationMoment));
        return intent;
    }

    public static Intent getShowCustomerServiceIntent(Context context) {
        Intent intent = new Intent(context, (Class<?>) HostActivity.class);
        intent.putExtra(SUPPORT_MODE, 7);
        return intent;
    }

    public static Intent getUrlIntent(Context context, String str) {
        Intent intent = new Intent(context, (Class<?>) HostActivity.class);
        intent.putExtra(SUPPORT_MODE, 6);
        intent.putExtra(INTENT_URL, str);
        return intent;
    }

    public static Intent wrapForApplicationContext(Intent intent) {
        if (intent != null) {
            intent.addFlags(805306368);
        }
        return intent;
    }

    static class C04221 {
        static final int[] $SwitchMap$net$aihelp$config$enums$ShowConversationMoment;

        static {
            int[] iArr = new int[ShowConversationMoment.values().length];
            $SwitchMap$net$aihelp$config$enums$ShowConversationMoment = iArr;
            try {
                iArr[ShowConversationMoment.ALWAYS.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$net$aihelp$config$enums$ShowConversationMoment[ShowConversationMoment.ONLY_IN_ANSWER_PAGE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$net$aihelp$config$enums$ShowConversationMoment[ShowConversationMoment.AFTER_MARKING_UNHELPFUL.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
        }
    }

    private static String getFaqEntranceByMoment(ShowConversationMoment showConversationMoment) {
        int i = C04221.$SwitchMap$net$aihelp$config$enums$ShowConversationMoment[showConversationMoment.ordinal()];
        if (i == 1 || i == 2) {
            return "3";
        }
        if (i == 3) {
            return "4";
        }
        return "";
    }
}
