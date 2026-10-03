package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.dynamic.IObjectWrapper;
import java.util.Map;

public final class zzcw extends zzbu implements zzcu {
    zzcw(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.measurement.api.internal.IAppMeasurementDynamiteService");
    }

    @Override
    public final void beginAdUnitExposure(String str, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeLong(j);
        zzb(23, parcelM23a_);
    }

    @Override
    public final void clearConditionalUserProperty(String str, String str2, Bundle bundle) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        zzbw.zza(parcelM23a_, bundle);
        zzb(9, parcelM23a_);
    }

    @Override
    public final void clearMeasurementEnabled(long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeLong(j);
        zzb(43, parcelM23a_);
    }

    @Override
    public final void endAdUnitExposure(String str, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeLong(j);
        zzb(24, parcelM23a_);
    }

    @Override
    public final void generateEventId(zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(22, parcelM23a_);
    }

    @Override
    public final void getAppInstanceId(zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(20, parcelM23a_);
    }

    @Override
    public final void getCachedAppInstanceId(zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(19, parcelM23a_);
    }

    @Override
    public final void getConditionalUserProperties(String str, String str2, zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(10, parcelM23a_);
    }

    @Override
    public final void getCurrentScreenClass(zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(17, parcelM23a_);
    }

    @Override
    public final void getCurrentScreenName(zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(16, parcelM23a_);
    }

    @Override
    public final void getGmpAppId(zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(21, parcelM23a_);
    }

    @Override
    public final void getMaxUserProperties(String str, zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(6, parcelM23a_);
    }

    @Override
    public final void getSessionId(zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(46, parcelM23a_);
    }

    @Override
    public final void getTestFlag(zzcv zzcvVar, int i) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzcvVar);
        parcelM23a_.writeInt(i);
        zzb(38, parcelM23a_);
    }

    @Override
    public final void getUserProperties(String str, String str2, boolean z, zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        zzbw.zza(parcelM23a_, z);
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(5, parcelM23a_);
    }

    @Override
    public final void initForTests(Map map) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeMap(map);
        zzb(37, parcelM23a_);
    }

    @Override
    public final void initialize(IObjectWrapper iObjectWrapper, zzdd zzddVar, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, iObjectWrapper);
        zzbw.zza(parcelM23a_, zzddVar);
        parcelM23a_.writeLong(j);
        zzb(1, parcelM23a_);
    }

    @Override
    public final void isDataCollectionEnabled(zzcv zzcvVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzcvVar);
        zzb(40, parcelM23a_);
    }

    @Override
    public final void logEvent(String str, String str2, Bundle bundle, boolean z, boolean z2, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        zzbw.zza(parcelM23a_, bundle);
        zzbw.zza(parcelM23a_, z);
        zzbw.zza(parcelM23a_, z2);
        parcelM23a_.writeLong(j);
        zzb(2, parcelM23a_);
    }

    @Override
    public final void logEventAndBundle(String str, String str2, Bundle bundle, zzcv zzcvVar, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        zzbw.zza(parcelM23a_, bundle);
        zzbw.zza(parcelM23a_, zzcvVar);
        parcelM23a_.writeLong(j);
        zzb(3, parcelM23a_);
    }

    @Override
    public final void logHealthData(int i, String str, IObjectWrapper iObjectWrapper, IObjectWrapper iObjectWrapper2, IObjectWrapper iObjectWrapper3) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeInt(i);
        parcelM23a_.writeString(str);
        zzbw.zza(parcelM23a_, iObjectWrapper);
        zzbw.zza(parcelM23a_, iObjectWrapper2);
        zzbw.zza(parcelM23a_, iObjectWrapper3);
        zzb(33, parcelM23a_);
    }

    @Override
    public final void onActivityCreated(IObjectWrapper iObjectWrapper, Bundle bundle, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, iObjectWrapper);
        zzbw.zza(parcelM23a_, bundle);
        parcelM23a_.writeLong(j);
        zzb(27, parcelM23a_);
    }

    @Override
    public final void onActivityDestroyed(IObjectWrapper iObjectWrapper, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, iObjectWrapper);
        parcelM23a_.writeLong(j);
        zzb(28, parcelM23a_);
    }

    @Override
    public final void onActivityPaused(IObjectWrapper iObjectWrapper, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, iObjectWrapper);
        parcelM23a_.writeLong(j);
        zzb(29, parcelM23a_);
    }

    @Override
    public final void onActivityResumed(IObjectWrapper iObjectWrapper, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, iObjectWrapper);
        parcelM23a_.writeLong(j);
        zzb(30, parcelM23a_);
    }

    @Override
    public final void onActivitySaveInstanceState(IObjectWrapper iObjectWrapper, zzcv zzcvVar, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, iObjectWrapper);
        zzbw.zza(parcelM23a_, zzcvVar);
        parcelM23a_.writeLong(j);
        zzb(31, parcelM23a_);
    }

    @Override
    public final void onActivityStarted(IObjectWrapper iObjectWrapper, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, iObjectWrapper);
        parcelM23a_.writeLong(j);
        zzb(25, parcelM23a_);
    }

    @Override
    public final void onActivityStopped(IObjectWrapper iObjectWrapper, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, iObjectWrapper);
        parcelM23a_.writeLong(j);
        zzb(26, parcelM23a_);
    }

    @Override
    public final void performAction(Bundle bundle, zzcv zzcvVar, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, bundle);
        zzbw.zza(parcelM23a_, zzcvVar);
        parcelM23a_.writeLong(j);
        zzb(32, parcelM23a_);
    }

    @Override
    public final void registerOnMeasurementEventListener(zzda zzdaVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzdaVar);
        zzb(35, parcelM23a_);
    }

    @Override
    public final void resetAnalyticsData(long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeLong(j);
        zzb(12, parcelM23a_);
    }

    @Override
    public final void setConditionalUserProperty(Bundle bundle, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, bundle);
        parcelM23a_.writeLong(j);
        zzb(8, parcelM23a_);
    }

    @Override
    public final void setConsent(Bundle bundle, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, bundle);
        parcelM23a_.writeLong(j);
        zzb(44, parcelM23a_);
    }

    @Override
    public final void setConsentThirdParty(Bundle bundle, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, bundle);
        parcelM23a_.writeLong(j);
        zzb(45, parcelM23a_);
    }

    @Override
    public final void setCurrentScreen(IObjectWrapper iObjectWrapper, String str, String str2, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, iObjectWrapper);
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        parcelM23a_.writeLong(j);
        zzb(15, parcelM23a_);
    }

    @Override
    public final void setDataCollectionEnabled(boolean z) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, z);
        zzb(39, parcelM23a_);
    }

    @Override
    public final void setDefaultEventParameters(Bundle bundle) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, bundle);
        zzb(42, parcelM23a_);
    }

    @Override
    public final void setEventInterceptor(zzda zzdaVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzdaVar);
        zzb(34, parcelM23a_);
    }

    @Override
    public final void setInstanceIdProvider(zzdb zzdbVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzdbVar);
        zzb(18, parcelM23a_);
    }

    @Override
    public final void setMeasurementEnabled(boolean z, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, z);
        parcelM23a_.writeLong(j);
        zzb(11, parcelM23a_);
    }

    @Override
    public final void setMinimumSessionDuration(long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeLong(j);
        zzb(13, parcelM23a_);
    }

    @Override
    public final void setSessionTimeoutDuration(long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeLong(j);
        zzb(14, parcelM23a_);
    }

    @Override
    public final void setUserId(String str, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeLong(j);
        zzb(7, parcelM23a_);
    }

    @Override
    public final void setUserProperty(String str, String str2, IObjectWrapper iObjectWrapper, boolean z, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        zzbw.zza(parcelM23a_, iObjectWrapper);
        zzbw.zza(parcelM23a_, z);
        parcelM23a_.writeLong(j);
        zzb(4, parcelM23a_);
    }

    @Override
    public final void unregisterOnMeasurementEventListener(zzda zzdaVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, zzdaVar);
        zzb(36, parcelM23a_);
    }
}
