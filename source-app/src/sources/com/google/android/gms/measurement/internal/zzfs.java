package com.google.android.gms.measurement.internal;

import android.content.Context;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Looper;
import com.google.android.gms.common.internal.BaseGmsClient;

public final class zzfs extends BaseGmsClient<zzfk> {
    @Override
    public final int getMinApkVersion() {
        return 12451000;
    }

    @Override
    public final IInterface createServiceInterface(IBinder iBinder) {
        if (iBinder == null) {
            return null;
        }
        IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.gms.measurement.internal.IMeasurementService");
        if (iInterfaceQueryLocalInterface instanceof zzfk) {
            return (zzfk) iInterfaceQueryLocalInterface;
        }
        return new zzfm(iBinder);
    }

    @Override
    protected final String getServiceDescriptor() {
        return "com.google.android.gms.measurement.internal.IMeasurementService";
    }

    @Override
    protected final String getStartServiceAction() {
        return "com.google.android.gms.measurement.START";
    }

    public zzfs(Context context, Looper looper, BaseGmsClient.BaseConnectionCallbacks baseConnectionCallbacks, BaseGmsClient.BaseOnConnectionFailedListener baseOnConnectionFailedListener) {
        super(context, looper, 93, baseConnectionCallbacks, baseOnConnectionFailedListener, null);
    }
}
