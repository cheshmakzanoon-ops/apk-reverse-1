package net.aihelp.p007ui.helper;

import android.view.View;
import net.aihelp.common.SpKeys;
import net.aihelp.config.AIHelpContext;
import net.aihelp.init.AIHelpSupport;
import net.aihelp.utils.SpUtil;
import net.aihelp.utils.TLog;
import net.aihelp.utils.ToastUtil;

public class BreakReleaseHelper implements View.OnClickListener {
    private int count;

    @Override
    public void onClick(View view) {
        int i = this.count;
        if (i < 7) {
            this.count = i + 1;
            return;
        }
        SpUtil.getInstance().put(SpKeys.TOGGLE_LOG, true);
        TLog.initLog(true);
        ToastUtil.INSTANCE.makeRawToast(AIHelpContext.getInstance().getContext(), String.format("Powered by AIHELP.NET @ %s", AIHelpSupport.getSDKVersion()));
    }
}
