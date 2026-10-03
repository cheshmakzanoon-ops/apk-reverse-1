package net.aihelp.p007ui.faq;

import android.os.Bundle;
import android.text.TextWatcher;

public interface IFaqEventListener extends TextWatcher {
    void onIntentToConversation(Bundle bundle);

    void onIntentToCustomerService(Bundle bundle, boolean z);

    void onIntentToElvaBot(Bundle bundle);

    void onIntentToFillForm(Bundle bundle, boolean z);

    void onIntentToOperateContent(Bundle bundle);

    void onIntentToQuestionContent(Bundle bundle, boolean z);

    void onIntentToQuestionList(Bundle bundle, boolean z);

    void onIntentToSearch(Bundle bundle);

    void onIntentToSectionList(Bundle bundle);
}
