package net.aihelp.data.model.p005cs;

import android.text.TextUtils;
import java.util.List;
import net.aihelp.core.net.json.GenericType;
import net.aihelp.data.model.p005cs.storyline.BotFormUrl;
import net.aihelp.data.model.p005cs.storyline.BotOrderInfo;
import net.aihelp.data.model.p005cs.storyline.BotTag;
import net.aihelp.data.model.p005cs.storyline.BotUrl;
import net.aihelp.p007ui.helper.LogoutMqttHelper;

public class ElvaBotMsg extends ConversationMsg {

    @GenericType(String.class)
    private List<String> actions;
    private BotFormUrl botFormUrl;
    private String botMsg;
    private BotOrderInfo botOrderInfo;

    @GenericType(BotTag.class)
    private List<BotTag> botTagList;
    private BotUrl botUrl;
    private String faqContentId;
    private String faqMainId;
    private boolean hasAction;
    private boolean hasFormUrl;
    private boolean hasOrderInfo;
    private boolean hasTag;
    private boolean hasUrl;
    private boolean isBotStupid;
    private boolean isFaqViewed;
    private boolean isSimilarMatched;
    private String rawResponse;
    private String template;
    private String userInput;

    public ElvaBotMsg() {
        setMsgType(11);
        setTimeStamp(System.currentTimeMillis());
    }

    public boolean isFaqViewed() {
        return this.isFaqViewed;
    }

    public void setFaqViewed(boolean z) {
        this.isFaqViewed = z;
    }

    public String getTemplate() {
        return this.template;
    }

    public void setTemplate(String str) {
        this.template = str;
    }

    public String getFaqContentId() {
        return this.faqContentId;
    }

    public void setFaqContentId(String str) {
        if (!TextUtils.isEmpty(str)) {
            str = str.replace("&isCustom=1", "");
        }
        this.faqContentId = str;
    }

    public String getFaqMainId() {
        return this.faqMainId;
    }

    public void setFaqMainId(String str) {
        this.faqMainId = str;
    }

    public boolean isSimilarMatched() {
        return this.isSimilarMatched;
    }

    public void setSimilarMatched(boolean z) {
        this.isSimilarMatched = z;
    }

    public String getRawResponse() {
        return this.rawResponse;
    }

    public void setRawResponse(String str) {
        this.rawResponse = str;
    }

    public boolean isBotStupid() {
        return this.isBotStupid;
    }

    public void setBotStupid(boolean z) {
        this.isBotStupid = z;
    }

    public boolean isHasAction() {
        return this.hasAction;
    }

    public boolean isHasUrl() {
        return this.hasUrl;
    }

    public boolean isHasFormUrl() {
        return this.hasFormUrl;
    }

    public boolean isHasOrderInfo() {
        return this.hasOrderInfo;
    }

    public boolean isHasTag() {
        return this.hasTag;
    }

    public String getBotMsg() {
        return this.botMsg;
    }

    public void setBotMsg(String str) {
        this.botMsg = str;
    }

    public String getUserInput() {
        return this.userInput;
    }

    public void setUserInput(String str) {
        this.userInput = str;
    }

    public List<String> getActions() {
        return this.actions;
    }

    public void setActions(List<String> list) {
        this.actions = list;
        setHasAction();
    }

    public List<BotTag> getBotTagList() {
        return this.botTagList;
    }

    public void setBotTagList(List<BotTag> list) {
        this.botTagList = list;
        setHasTag();
    }

    public BotUrl getBotUrl() {
        return this.botUrl;
    }

    public void setBotUrl(BotUrl botUrl) {
        this.botUrl = botUrl;
        setHasUrl();
    }

    public BotFormUrl getBotFormUrl() {
        return this.botFormUrl;
    }

    public void setBotFormUrl(BotFormUrl botFormUrl) {
        this.botFormUrl = botFormUrl;
        setHasFormUrl();
    }

    public BotOrderInfo getBotOrderInfo() {
        return this.botOrderInfo;
    }

    public void setBotOrderInfo(BotOrderInfo botOrderInfo) {
        this.botOrderInfo = botOrderInfo;
        setHasOrderInfo();
    }

    private void setHasAction() {
        this.hasAction = true;
        LogoutMqttHelper.updateType(LogoutMqttHelper.LOGOUT_TYPE_ACTION_DISPLAY);
    }

    private void setHasUrl() {
        this.hasUrl = true;
    }

    private void setHasFormUrl() {
        this.hasFormUrl = true;
        LogoutMqttHelper.updateType("4");
    }

    private void setHasTag() {
        this.hasTag = true;
    }

    private void setHasOrderInfo() {
        this.hasOrderInfo = true;
    }
}
