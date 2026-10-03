package com.google.android.gms.dynamic;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import androidx.fragment.app.Fragment;
import com.google.android.gms.common.internal.Preconditions;

public final class SupportFragmentWrapper extends IFragmentWrapper.Stub {
    private final Fragment zza;

    private SupportFragmentWrapper(Fragment fragment) {
        this.zza = fragment;
    }

    public static SupportFragmentWrapper wrap(Fragment fragment) {
        if (fragment != null) {
            return new SupportFragmentWrapper(fragment);
        }
        return null;
    }

    @Override
    public final void zzA(IObjectWrapper iObjectWrapper) {
        View view = (View) ObjectWrapper.unwrap(iObjectWrapper);
        Preconditions.checkNotNull(view);
        this.zza.unregisterForContextMenu(view);
    }

    @Override
    public final IObjectWrapper zzb() {
        return ObjectWrapper.wrap(this.zza.getActivity());
    }

    @Override
    public final Bundle zzc() {
        return this.zza.getArguments();
    }

    @Override
    public final int zzd() {
        return this.zza.getId();
    }

    @Override
    public final IFragmentWrapper zze() {
        return wrap(this.zza.getParentFragment());
    }

    @Override
    public final IObjectWrapper zzf() {
        return ObjectWrapper.wrap(this.zza.getResources());
    }

    @Override
    public final boolean zzg() {
        return this.zza.getRetainInstance();
    }

    @Override
    public final String zzh() {
        return this.zza.getTag();
    }

    @Override
    public final IFragmentWrapper zzi() {
        return wrap(this.zza.getTargetFragment());
    }

    @Override
    public final int zzj() {
        return this.zza.getTargetRequestCode();
    }

    @Override
    public final boolean zzk() {
        return this.zza.getUserVisibleHint();
    }

    @Override
    public final IObjectWrapper zzl() {
        return ObjectWrapper.wrap(this.zza.getView());
    }

    @Override
    public final boolean zzm() {
        return this.zza.isAdded();
    }

    @Override
    public final boolean zzn() {
        return this.zza.isDetached();
    }

    @Override
    public final boolean zzo() {
        return this.zza.isHidden();
    }

    @Override
    public final boolean zzp() {
        return this.zza.isInLayout();
    }

    @Override
    public final boolean zzq() {
        return this.zza.isRemoving();
    }

    @Override
    public final boolean zzr() {
        return this.zza.isResumed();
    }

    @Override
    public final boolean zzs() {
        return this.zza.isVisible();
    }

    @Override
    public final void zzt(IObjectWrapper iObjectWrapper) {
        View view = (View) ObjectWrapper.unwrap(iObjectWrapper);
        Preconditions.checkNotNull(view);
        this.zza.registerForContextMenu(view);
    }

    @Override
    public final void zzu(boolean z) {
        this.zza.setHasOptionsMenu(z);
    }

    @Override
    public final void zzv(boolean z) {
        this.zza.setMenuVisibility(z);
    }

    @Override
    public final void zzw(boolean z) {
        this.zza.setRetainInstance(z);
    }

    @Override
    public final void zzx(boolean z) {
        this.zza.setUserVisibleHint(z);
    }

    @Override
    public final void zzy(Intent intent) {
        this.zza.startActivity(intent);
    }

    @Override
    public final void zzz(Intent intent, int i) {
        this.zza.startActivityForResult(intent, i);
    }
}
