package com.ishumei.smantifraud;

import android.text.TextUtils;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public abstract class l11l1111I11l implements l1l11II111l {
    public final ReadWriteLock l1111l111111Il = new ReentrantReadWriteLock(true);

    @Override
    public final String l1111l111111Il() {
        try {
            if (!this.l1111l111111Il.readLock().tryLock(50L, TimeUnit.MILLISECONDS)) {
                return "";
            }
            try {
                return l111l11111lIl();
            } finally {
                this.l1111l111111Il.readLock().unlock();
            }
        } catch (Throwable unused) {
            return "";
        }
    }

    @Override
    public void l1111l111111Il(String str) {
        if (TextUtils.isEmpty(str)) {
            return;
        }
        try {
            this.l1111l111111Il.writeLock().lock();
            l111l11111lIl(str);
        } catch (Throwable unused) {
        }
        this.l1111l111111Il.writeLock().unlock();
    }

    public abstract String l111l11111lIl();

    public abstract void l111l11111lIl(String str);
}
