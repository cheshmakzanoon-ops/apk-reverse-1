package com.google.android.gms.location;

import android.app.Activity;
import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

public class SettingsClient extends GoogleApi<Api.ApiOptions.NoOptions> {
    public static final int zza = 0;

    public SettingsClient(Activity activity) {
        super(activity, LocationServices.API, Api.ApiOptions.NO_OPTIONS, GoogleApi.Settings.DEFAULT_SETTINGS);
    }

    public Task<LocationSettingsResponse> checkLocationSettings(final LocationSettingsRequest locationSettingsRequest) {
        return doRead(TaskApiCall.builder().run(new RemoteCall(locationSettingsRequest) {
            private final LocationSettingsRequest zza;

            {
                this.zza = locationSettingsRequest;
            }

            @Override
            public final void accept(Object obj, Object obj2) throws RemoteException {
                LocationSettingsRequest locationSettingsRequest2 = this.zza;
                int i = SettingsClient.zza;
                ((com.google.android.gms.internal.location.zzaz) obj).zzL(locationSettingsRequest2, new zzbt((TaskCompletionSource) obj2), null);
            }
        }).setMethodKey(2426).build());
    }

    public SettingsClient(Context context) {
        super(context, LocationServices.API, Api.ApiOptions.NO_OPTIONS, GoogleApi.Settings.DEFAULT_SETTINGS);
    }
}
