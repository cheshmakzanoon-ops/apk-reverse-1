package net.aihelp.p007ui.adapter.p008cs.user;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.widget.ImageView;
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

public class UserVideoAdapter extends BaseMsgAdapter {
    private final ExecutorService mExecutorService;

    public UserVideoAdapter(Context context, Fragment fragment) {
        super(context, fragment);
        this.mExecutorService = Executors.newCachedThreadPool();
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_user_video");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 12;
    }

    @Override
    public void convert(final ViewHolder viewHolder, Message message, final int i) {
        if (message instanceof FileMessage) {
            final FileMessage fileMessage = (FileMessage) message;
            Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), CustomConfig.CustomerService.csUserPortrait, CustomConfig.CustomerService.isPortraitVisible, "aihelp_svg_portrait_user");
            viewHolder.setVisible(getViewId("aihelp_iv_msg_retry"), false);
            if (fileMessage.getMsgStatus() == 2) {
                ((AIHelpLoadingImageView) viewHolder.getView(getViewId("aihelp_iv_holder"))).resetStatus();
                return;
            }
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
                        if ((UserVideoAdapter.this.mContext instanceof Activity) && ((Activity) UserVideoAdapter.this.mContext).isFinishing()) {
                            TLog.m138d("You cannot start a load for a destroyed activity, interrupt current invoke.");
                        } else {
                            ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    UserVideoAdapter.this.loadUpImageView(viewHolder, fileMessage, i);
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
        if (fileMessage.getMsgStatus() == 3) {
            viewHolder.setVisible(getViewId("aihelp_iv_msg_retry"), true);
            viewHolder.setOnClickListener(getViewId("aihelp_iv_msg_retry"), getFileRetryListener(i, fileMessage));
        } else {
            aIHelpLoadingImageView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (aIHelpLoadingImageView.isLoading()) {
                        return;
                    }
                    PreviewActivity.startAct(UserVideoAdapter.this.mFragment, PreviewInfo.get(fileMessage.getContent()));
                }
            });
        }
    }
}
