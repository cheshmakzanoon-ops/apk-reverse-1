package net.aihelp.p007ui.widget;

import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.util.AttributeSet;
import android.view.View;
import android.widget.RelativeLayout;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.bus.Subscribe;
import net.aihelp.core.util.bus.ThreadMode;
import net.aihelp.core.util.bus.event.EventCenter;
import net.aihelp.data.event.NewMessageArrivedEvent;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.faq.BaseFaqFragment;
import net.aihelp.p007ui.faq.FaqContentFragment;
import net.aihelp.p007ui.faq.FaqHomeFragment;
import net.aihelp.p007ui.faq.FaqListFragment;
import net.aihelp.p007ui.faq.IFaqEventListener;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AIHelpServiceEntrance extends RelativeLayout {
    View vNotification;

    public AIHelpServiceEntrance(Context context) {
        this(context, null);
    }

    public AIHelpServiceEntrance(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpServiceEntrance(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_layout_service_entrance"), this);
        ((AIHelpButton) findViewById(ResResolver.getViewId("aihelp_tv_entrance"))).setText(CustomConfig.HelpCenter.faqCSEntranceText);
        View viewFindViewById = findViewById(ResResolver.getViewId("aihelp_v_unread_status"));
        this.vNotification = viewFindViewById;
        viewFindViewById.setBackground(Styles.getDrawable(Color.parseColor("#FF4747"), 999));
        this.vNotification.setVisibility(8);
        updateEntranceStatus(false, false);
    }

    public void setup(Bundle bundle, IFaqEventListener iFaqEventListener, BaseFaqFragment baseFaqFragment) {
        if (bundle == null || iFaqEventListener == null) {
            return;
        }
        updateViewVisibility(bundle, baseFaqFragment);
        updateViewClickEvent(bundle, iFaqEventListener, baseFaqFragment);
    }

    public void updateViewVisibility(Bundle bundle, BaseFaqFragment baseFaqFragment) {
        boolean z = true;
        if (TicketStatusTracker.hasUnreadMsg) {
            updateEntranceStatus(true, true);
            return;
        }
        if (TicketStatusTracker.isTicketActive || Const.TOGGLE_FETCH_MESSAGE) {
            updateEntranceStatus(true, false);
            return;
        }
        if (bundle == null || baseFaqFragment == null) {
            return;
        }
        String string = bundle.getString(IntentValues.FAQ_SUPPORT_MOMENT, "");
        boolean z2 = (baseFaqFragment instanceof FaqHomeFragment) && string.contains("1");
        boolean z3 = (baseFaqFragment instanceof FaqListFragment) && string.contains("2");
        boolean z4 = (baseFaqFragment instanceof FaqContentFragment) && string.contains("3");
        if (!z2 && !z3 && !z4) {
            z = false;
        }
        updateEntranceStatus(z, false);
    }

    private void updateEntranceStatus(boolean z, boolean z2) {
        if (z) {
            setVisibility(0);
            this.vNotification.setVisibility(z2 ? 0 : 8);
        } else {
            setVisibility(8);
        }
    }

    private void updateViewClickEvent(final Bundle bundle, final IFaqEventListener iFaqEventListener, final BaseFaqFragment baseFaqFragment) {
        setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AIHelpServiceEntrance.this.onIntentToCustomerService(bundle, iFaqEventListener, baseFaqFragment);
            }
        });
    }

    public void onIntentToCustomerService(Bundle bundle, IFaqEventListener iFaqEventListener, BaseFaqFragment baseFaqFragment) {
        if (bundle == null || iFaqEventListener == null || baseFaqFragment == null) {
            return;
        }
        updateEntranceStatus(true, false);
        iFaqEventListener.onIntentToCustomerService(bundle, true);
        String str = "";
        if (baseFaqFragment instanceof FaqContentFragment) {
            str = ((FaqContentFragment) baseFaqFragment).hashCode() + "";
        }
        AIHelpEventTracker.getInstance().clickServiceEntrance(str);
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        EventBus.getDefault().register(this);
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        EventBus.getDefault().unregister(this);
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEventComing(EventCenter eventCenter) {
        if (eventCenter instanceof NewMessageArrivedEvent) {
            updateViewVisibility(null, null);
        }
    }
}
