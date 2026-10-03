package net.aihelp.data.logic;

import android.os.Handler;
import android.os.Message;
import java.util.Random;
import net.aihelp.init.InitHelper;

public class RequestRetryHandler extends Handler {
    private static final int MAXIMUM_BACKOFF = 32000;
    private final int maxRetryCount;
    private int retryCount;
    private final OnRetryRequestListener retryListener;

    public interface OnRetryRequestListener {
        void onRetryRequest();

        void onRetryUpToMaxCount(int i, String str);
    }

    public RequestRetryHandler(OnRetryRequestListener onRetryRequestListener, int i) {
        this.retryListener = onRetryRequestListener;
        this.maxRetryCount = Math.max(3, i);
    }

    public void handleRetryRequest(int i, String str) {
        if (i >= 500) {
            InitHelper.getInstance().onAIHelpInitializedCallback(false, str);
            return;
        }
        int i2 = this.retryCount;
        this.retryCount = i2 + 1;
        double dPow = (Math.pow(2.0d, i2) * 1000.0d) + ((double) new Random().nextInt(1001));
        if (this.retryCount <= this.maxRetryCount) {
            sendEmptyMessageDelayed(0, (long) Math.min(dPow, 32000.0d));
            return;
        }
        removeCallbacksAndMessages(null);
        OnRetryRequestListener onRetryRequestListener = this.retryListener;
        if (onRetryRequestListener != null) {
            onRetryRequestListener.onRetryUpToMaxCount(i, str);
        }
    }

    @Override
    public void handleMessage(Message message) {
        OnRetryRequestListener onRetryRequestListener = this.retryListener;
        if (onRetryRequestListener != null) {
            onRetryRequestListener.onRetryRequest();
        }
    }
}
