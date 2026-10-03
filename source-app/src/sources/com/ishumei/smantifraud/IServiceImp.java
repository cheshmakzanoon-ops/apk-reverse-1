package com.ishumei.smantifraud;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import com.ishumei.smantifraud.dfp.SMSDK;

public class IServiceImp extends Service {
    public static final int ISI_HAS_MAGISK = 1;
    public HandlerThread l1111l111111Il = null;

    public static class l1111l111111Il extends Handler {
        public l1111l111111Il(Looper looper) {
            super(looper);
        }

        @Override
        public void handleMessage(Message message) {
            if (message.what != 1) {
                super.handleMessage(message);
                return;
            }
            try {
                int iMa2 = SMSDK.ma2();
                if (iMa2 > 0) {
                    Messenger messenger = message.replyTo;
                    Message messageObtain = Message.obtain((Handler) null, 1);
                    messageObtain.arg1 = iMa2;
                    messenger.send(messageObtain);
                }
            } catch (Throwable unused) {
            }
        }
    }

    public final void l1111l111111Il() {
        HandlerThread handlerThread = this.l1111l111111Il;
        if (handlerThread == null) {
            return;
        }
        handlerThread.quitSafely();
        this.l1111l111111Il = null;
    }

    @Override
    public IBinder onBind(Intent intent) {
        HandlerThread handlerThread = new HandlerThread("sm-thread-iht");
        this.l1111l111111Il = handlerThread;
        handlerThread.start();
        return new Messenger(new l1111l111111Il(this.l1111l111111Il.getLooper())).getBinder();
    }

    @Override
    public boolean onUnbind(Intent intent) {
        l1111l111111Il();
        return super.onUnbind(intent);
    }
}
