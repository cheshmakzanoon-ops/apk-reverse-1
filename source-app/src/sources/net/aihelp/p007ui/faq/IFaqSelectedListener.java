package net.aihelp.p007ui.faq;

import net.aihelp.data.model.faq.FaqListEntity;

public interface IFaqSelectedListener {
    void onIntentToQuestionContent(FaqListEntity faqListEntity);

    void onIntentToSubSectionOrQuestionList(FaqListEntity faqListEntity);
}
