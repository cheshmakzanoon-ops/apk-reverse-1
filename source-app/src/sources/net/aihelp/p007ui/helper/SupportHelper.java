package net.aihelp.p007ui.helper;

import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import java.util.concurrent.atomic.AtomicBoolean;
import net.aihelp.common.IntentValues;
import net.aihelp.p007ui.err.FaqErrorFragment;
import net.aihelp.p007ui.faq.FaqContentFragment;
import net.aihelp.p007ui.faq.FaqHomeFragment;
import net.aihelp.p007ui.faq.FaqListFragment;
import net.aihelp.p007ui.faq.FaqSearchFragment;
import net.aihelp.p007ui.p009cs.CustomerServiceFragment;
import net.aihelp.p007ui.p009cs.IntentUrlFragment;
import net.aihelp.p007ui.wrapper.FaqEventListenerWrapper;
import net.aihelp.utils.ResResolver;

public class SupportHelper extends FaqEventListenerWrapper {
    private final Bundle bundle;
    private final FragmentManager childFragmentManager;
    private final Context context;
    private final AtomicBoolean isSupportStarted = new AtomicBoolean();
    private int supportMode;

    @Override
    public void afterTextChanged(Editable editable) {
    }

    @Override
    public void beforeTextChanged(CharSequence charSequence, int i, int i2, int i3) {
    }

    public SupportHelper(Context context, FragmentManager fragmentManager, Bundle bundle) {
        this.context = context;
        this.childFragmentManager = fragmentManager;
        this.bundle = bundle;
    }

    public void start() {
        if (this.isSupportStarted.get()) {
            return;
        }
        int i = this.bundle.getInt(IntentValues.SUPPORT_MODE, 0);
        this.supportMode = i;
        if (i == 3) {
            onIntentToQuestionList(this.bundle, false);
        } else if (i == 4) {
            onIntentToQuestionContent(this.bundle, false);
        } else if (i == 6) {
            onIntentToFillForm(this.bundle, false);
        } else if (i == 7) {
            onIntentToCustomerService(this.bundle, false);
        } else if (i == 8) {
            onIntentToErrorEntrance();
        } else {
            onIntentToSectionRoot(this.bundle, false);
        }
        this.isSupportStarted.set(true);
    }

    private void onIntentToErrorEntrance() {
        FragmentHelper.startFragment(this.childFragmentManager, ResResolver.getViewId("aihelp_support_fragment_container"), FaqErrorFragment.newInstance(this.bundle), null, null, false, false);
    }

    public void onIntentToSectionRoot(Bundle bundle, boolean z) {
        FaqHomeFragment faqHomeFragmentNewInstance = FaqHomeFragment.newInstance(bundle);
        FragmentHelper.startFragment(this.childFragmentManager, ResResolver.getViewId("aihelp_support_fragment_container"), faqHomeFragmentNewInstance, null, z ? faqHomeFragmentNewInstance.getClass().getName() : null, false, false);
    }

    @Override
    public void onIntentToQuestionList(Bundle bundle, boolean z) {
        FaqListFragment faqListFragmentNewInstance = FaqListFragment.newInstance(bundle);
        FragmentHelper.startFragment(this.childFragmentManager, ResResolver.getViewId("aihelp_support_fragment_container"), faqListFragmentNewInstance, "", z ? faqListFragmentNewInstance.getClass().getName() : null, false, false);
    }

    @Override
    public void onIntentToQuestionContent(Bundle bundle, boolean z) {
        FaqContentFragment faqContentFragmentNewInstance = FaqContentFragment.newInstance(bundle);
        FragmentHelper.startFragment(this.childFragmentManager, ResResolver.getViewId("aihelp_support_fragment_container"), faqContentFragmentNewInstance, "", z ? faqContentFragmentNewInstance.getClass().getName() : null, true, false);
    }

    @Override
    public void onIntentToSearch(Bundle bundle) {
        int viewId = ResResolver.getViewId("aihelp_support_fragment_container");
        FaqSearchFragment faqSearchFragmentNewInstance = FaqSearchFragment.newInstance(bundle);
        FragmentHelper.startFragment(this.childFragmentManager, viewId, faqSearchFragmentNewInstance, "tag_faq_search", faqSearchFragmentNewInstance.getClass().getName(), false, false);
    }

    @Override
    public void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
        FaqSearchFragment faqSearchFragment = (FaqSearchFragment) this.childFragmentManager.findFragmentByTag("tag_faq_search");
        if (faqSearchFragment != null) {
            faqSearchFragment.onQuery(String.valueOf(charSequence).trim());
        }
    }

    @Override
    public void onIntentToCustomerService(Bundle bundle, boolean z) {
        CustomerServiceFragment customerServiceFragmentNewInstance = CustomerServiceFragment.newInstance(bundle);
        FragmentHelper.startFragment(this.childFragmentManager, ResResolver.getViewId("aihelp_support_fragment_container"), customerServiceFragmentNewInstance, null, z ? customerServiceFragmentNewInstance.getClass().getName() : null, false, false);
    }

    @Override
    public void onIntentToFillForm(Bundle bundle, boolean z) {
        IntentUrlFragment intentUrlFragmentNewInstance = IntentUrlFragment.newInstance(bundle);
        String name = z ? intentUrlFragmentNewInstance.getClass().getName() : null;
        FragmentHelper.startFragment(this.childFragmentManager, ResResolver.getViewId("aihelp_support_fragment_container"), intentUrlFragmentNewInstance, name, name, false, false);
    }

    private Fragment getTopMostFaqFragment() {
        return FragmentHelper.getTopMostFragment(this.childFragmentManager);
    }
}
