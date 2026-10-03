package net.aihelp.data.model.rpa.msg;

import android.text.TextUtils;
import java.util.List;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.msg.bot.Answer;
import net.aihelp.data.model.rpa.msg.bot.ExternalUrl;
import net.aihelp.data.model.rpa.msg.bot.Faq;
import net.aihelp.data.model.rpa.msg.bot.FormUrl;
import net.aihelp.data.model.rpa.msg.bot.SelfService;
import net.aihelp.utils.ListUtil;
import okhttp3.HttpUrl;

public class BotMessage extends Message {
    public static final int USER_FEEDBACK_INVISIBLE = -1;
    public static final int USER_FEEDBACK_NEGATIVE = 2;
    public static final int USER_FEEDBACK_NONE = 0;
    public static final int USER_FEEDBACK_POSITIVE = 1;
    private List<Answer> botAnswers;
    private ExternalUrl externalUrl;
    private Faq faq;
    private FormUrl formUrl;
    private SelfService selfService;
    private int userFeedback;

    public BotMessage(String str) {
        setNickname(str);
    }

    public FormUrl getFormUrl() {
        return this.formUrl;
    }

    public void setFormUrl(FormUrl formUrl) {
        this.formUrl = formUrl;
    }

    public ExternalUrl getExternalUrl() {
        return this.externalUrl;
    }

    public void setExternalUrl(ExternalUrl externalUrl) {
        this.externalUrl = externalUrl;
    }

    public Faq getFaq() {
        return this.faq;
    }

    public void setFaq(Faq faq) {
        this.faq = faq;
        if (hasFaq()) {
            setMsgType(4);
        }
    }

    public SelfService getSelfService() {
        return this.selfService;
    }

    public void setSelfService(SelfService selfService) {
        this.selfService = selfService;
        if (hasSelfService() && selfService.isEnableSend()) {
            setNormalMessage(false);
        }
    }

    public List<Answer> getBotAnswers() {
        return this.botAnswers;
    }

    public void setBotAnswers(List<Answer> list) {
        this.botAnswers = list;
        if (hasBotAnswers()) {
            setMsgType(5);
        }
    }

    public int getUserFeedback() {
        return this.userFeedback;
    }

    public void setUserFeedback(int i) {
        this.userFeedback = i;
    }

    @Override
    public void setContent(String str) {
        super.setContent(str);
        setMsgType(3);
    }

    public boolean hasFormUrl() {
        FormUrl formUrl = this.formUrl;
        return (formUrl == null || TextUtils.isEmpty(formUrl.getLink()) || TextUtils.isEmpty(this.formUrl.getTitle())) ? false : true;
    }

    public boolean hasExternalUrl() {
        ExternalUrl externalUrl = this.externalUrl;
        return (externalUrl == null || TextUtils.isEmpty(externalUrl.getLink()) || TextUtils.isEmpty(this.externalUrl.getTitle())) ? false : true;
    }

    public boolean hasFaq() {
        Faq faq = this.faq;
        return (faq == null || ListUtil.isListEmpty(faq.getFaqDataList())) ? false : true;
    }

    public boolean hasSelfService() {
        SelfService selfService = this.selfService;
        return (selfService == null || TextUtils.isEmpty(selfService.getSelfServiceData()) || HttpUrl.PATH_SEGMENT_ENCODE_SET_URI.equals(this.selfService.getSelfServiceData())) ? false : true;
    }

    public boolean hasBotAnswers() {
        return !ListUtil.isListEmpty(this.botAnswers);
    }
}
