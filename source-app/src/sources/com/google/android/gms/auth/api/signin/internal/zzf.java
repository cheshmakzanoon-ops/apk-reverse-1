package com.google.android.gms.auth.api.signin.internal;

import android.content.Context;
import android.util.Log;
import androidx.loader.content.AsyncTaskLoader;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.internal.SignInConnectionListener;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;

public final class zzf extends AsyncTaskLoader<Void> implements SignInConnectionListener {
    private Semaphore zzcb;
    private Set<GoogleApiClient> zzcc;

    public zzf(Context context, Set<GoogleApiClient> set) {
        super(context);
        this.zzcb = new Semaphore(0);
        this.zzcc = set;
    }

    public final Void loadInBackground() {
        Iterator<GoogleApiClient> it = this.zzcc.iterator();
        int i = 0;
        while (it.hasNext()) {
            if (it.next().maybeSignIn(this)) {
                i++;
            }
        }
        try {
            this.zzcb.tryAcquire(i, 5L, TimeUnit.SECONDS);
            return null;
        } catch (InterruptedException e) {
            Log.i("GACSignInLoader", "Unexpected InterruptedException", e);
            Thread.currentThread().interrupt();
            return null;
        }
    }

    protected final void onStartLoading() {
        this.zzcb.drainPermits();
        forceLoad();
    }

    @Override
    public final void onComplete() {
        this.zzcb.release();
    }
}
