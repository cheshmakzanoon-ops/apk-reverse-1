package net.aihelp.p007ui.adapter.p008cs.agent;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.fragment.app.Fragment;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.p007ui.preview.PreviewActivity;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.p007ui.widget.AIHelpLoadingImageView;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import net.aihelp.utils.TLog;

public class AgentVideoAdapter extends BaseMsgAdapter {
    private final ExecutorService mExecutorService;

    public AgentVideoAdapter(Context context, Fragment fragment) {
        super(context, fragment);
        this.mExecutorService = Executors.newCachedThreadPool();
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_agent_video");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 7;
    }

    @Override
    public void convert(final ViewHolder viewHolder, Message message, final int i) {
        if (message instanceof FileMessage) {
            final FileMessage fileMessage = (FileMessage) message;
            Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), CustomConfig.CustomerService.csManualSupportPortrait, CustomConfig.CustomerService.isPortraitVisible, "aihelp_svg_portrait_agent");
            Styles.reRenderTextView((TextView) viewHolder.getView(getViewId("aihelp_tv_nickname")), fileMessage.getNickname(), Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.8d), CustomConfig.CustomerService.isNicknameVisible && !TextUtils.isEmpty(fileMessage.getNickname()), 13);
            if (fileMessage.getVideoThumbnail() != null) {
                loadUpImageView(viewHolder, fileMessage, i);
                return;
            }
            ExecutorService executorService = this.mExecutorService;
            if (executorService != null) {
                executorService.execute(new Runnable() {
                    @Override
                    public void run() {
                        fileMessage.prepareVideoThumbnail();
                        if ((AgentVideoAdapter.this.mContext instanceof Activity) && ((Activity) AgentVideoAdapter.this.mContext).isFinishing()) {
                            TLog.m138d("You cannot start a load for a destroyed activity, interrupt current invoke.");
                        } else {
                            ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    AgentVideoAdapter.this.loadUpImageView(viewHolder, fileMessage, i);
                                }
                            });
                        }
                    }
                });
            }
        }
    }

    public void loadUpImageView(ViewHolder viewHolder, final FileMessage fileMessage, int i) {
        final AIHelpLoadingImageView aIHelpLoadingImageView = (AIHelpLoadingImageView) viewHolder.getView(getViewId("aihelp_iv_holder"));
        aIHelpLoadingImageView.loadIntoImageView(this.mContext, fileMessage);
        aIHelpLoadingImageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (aIHelpLoadingImageView.isLoading()) {
                    return;
                }
                PreviewActivity.startAct(AgentVideoAdapter.this.mFragment, PreviewInfo.get(fileMessage.getContent()));
            }
        });
    }
}
