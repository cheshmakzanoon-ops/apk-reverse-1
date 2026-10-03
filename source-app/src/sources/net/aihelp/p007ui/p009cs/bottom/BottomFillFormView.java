package net.aihelp.p007ui.p009cs.bottom;

import android.content.Context;
import android.view.View;
import net.aihelp.common.IntentValues;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.data.event.PageHoppingEvent;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;

public class BottomFillFormView extends BottomBaseView implements View.OnClickListener {
    public BottomFillFormView(Context context) {
        super(context);
        View.inflate(context, ResResolver.getLayoutId("aihelp_bottom_fill_form"), this);
        AIHelpButton aIHelpButton = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_btn_go_fill"));
        aIHelpButton.setText(ResResolver.getString("aihelp_fill_in"));
        aIHelpButton.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        if (AppInfoUtil.validateNetwork(getContext()) && view.getId() == ResResolver.getViewId("aihelp_btn_go_fill")) {
            EventBus.getDefault().post(new PageHoppingEvent(1009, this.bundle));
            AIHelpEventTracker.getInstance().onFormClicked(this.bundle.getString(IntentValues.INTENT_URL, ""));
        }
    }
}
