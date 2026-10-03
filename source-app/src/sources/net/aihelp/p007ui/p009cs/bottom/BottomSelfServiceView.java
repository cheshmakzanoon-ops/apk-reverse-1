package net.aihelp.p007ui.p009cs.bottom;

import android.content.Context;
import android.os.Parcelable;
import android.view.View;
import net.aihelp.common.IntentValues;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.msg.bot.SelfService;
import net.aihelp.p007ui.p009cs.util.viewer.SelfServiceViewer;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;

public class BottomSelfServiceView extends BottomBaseView implements View.OnClickListener {
    private SelfServiceViewer selfServiceViewer;

    public BottomSelfServiceView(Context context) {
        super(context);
        View.inflate(context, ResResolver.getLayoutId("aihelp_bottom_self_service"), this);
        AIHelpButton aIHelpButton = (AIHelpButton) findViewById(ResResolver.getViewId("aihelp_btn_check_service"));
        aIHelpButton.setText(ResResolver.getString("aihelp_view_details"));
        aIHelpButton.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        super.onClick(view);
        if (AppInfoUtil.validateNetwork(getContext()) && view.getId() == ResResolver.getViewId("aihelp_btn_check_service")) {
            Parcelable parcelable = this.bundle.getParcelable(IntentValues.BOTTOM_SELF_SERVICE);
            if ((parcelable instanceof SelfService) && ((SelfService) parcelable).isEnableSend()) {
                SelfServiceViewer selfServiceViewer = new SelfServiceViewer();
                this.selfServiceViewer = selfServiceViewer;
                selfServiceViewer.getService(getContext(), (SelfService) this.bundle.getParcelable(IntentValues.BOTTOM_SELF_SERVICE));
                this.selfServiceViewer.setOnSelfServiceConfirmListener(new SelfServiceViewer.OnSelfServiceConfirmListener() {
                    @Override
                    public void onSelected(Message message) {
                        if (!AppInfoUtil.validateNetwork(BottomSelfServiceView.this.getContext()) || BottomSelfServiceView.this.mListener == null) {
                            return;
                        }
                        BottomSelfServiceView.this.mListener.onUserAction(message);
                    }
                });
            }
        }
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        SelfServiceViewer selfServiceViewer = this.selfServiceViewer;
        if (selfServiceViewer != null) {
            selfServiceViewer.setOnSelfServiceConfirmListener(null);
        }
    }
}
