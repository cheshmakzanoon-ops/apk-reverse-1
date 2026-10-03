package com.ishumei.smantifraud;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;

public class l11l11l1llIl {
    public static int l111l11111Il;
    public final Context l1111l111111Il;
    public HandlerThread l111l11111lIl = null;
    public final ServiceConnection l111l11111I1l = new l1111l111111Il();

    public class l1111l111111Il implements ServiceConnection {
        public l1111l111111Il() {
        }

        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            l11l11l1llIl.this.l111l11111lIl = new HandlerThread("sm-thread-ht");
            l11l11l1llIl.this.l111l11111lIl.start();
            l11l11l1llIl l11l11l1llil = l11l11l1llIl.this;
            Messenger messenger = new Messenger(l11l11l1llil.new l111l11111lIl(l11l11l1llil.l111l11111lIl.getLooper()));
            Messenger messenger2 = new Messenger(iBinder);
            Message messageObtain = Message.obtain();
            messageObtain.what = 1;
            messageObtain.replyTo = messenger;
            try {
                messenger2.send(messageObtain);
            } catch (Throwable unused) {
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
        }
    }

    public class l111l11111lIl extends Handler {
        public l111l11111lIl(Looper looper) {
            super(looper);
        }

        @Override
        public void handleMessage(Message message) {
            if (message.what != 1) {
                super.handleMessage(message);
            } else {
                int unused = l11l11l1llIl.l111l11111Il = message.arg1;
                l11l11l1llIl.this.l111l11111I1l();
            }
        }
    }

    public l11l11l1llIl(Context context) {
        this.l1111l111111Il = context;
    }

    public void l1111l111111Il() {
        try {
            this.l1111l111111Il.bindService(new Intent(this.l1111l111111Il, (Class<?>) IServiceImp.class), this.l111l11111I1l, 1);
        } catch (Throwable unused) {
        }
    }

    public void l111l11111I1l() {
        try {
            HandlerThread handlerThread = this.l111l11111lIl;
            if (handlerThread == null) {
                return;
            }
            handlerThread.quitSafely();
            this.l111l11111lIl = null;
            this.l1111l111111Il.unbindService(this.l111l11111I1l);
        } catch (Throwable unused) {
        }
    }

    public int l111l11111lIl() {
        return l111l11111Il;
    }
}
