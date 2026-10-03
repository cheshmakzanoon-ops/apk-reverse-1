package com.google.android.gms.games.provider;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.content.pm.ProviderInfo;
import android.database.Cursor;
import android.net.Uri;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.internal.games_v2.zzbw;
import com.google.android.gms.internal.games_v2.zzfn;

public class PlayGamesInitProvider extends ContentProvider {
    @Override
    public final void attachInfo(Context context, ProviderInfo providerInfo) {
        Preconditions.checkNotNull(providerInfo, "PlayGamesSdkInitProvider ProviderInfo cannot be null.");
        if ("com.google.android.gms.games.playgamesinitprovider".equals(providerInfo.authority)) {
            throw new IllegalStateException("Incorrect provider authority in manifest. Most likely due to a missing applicationId variable in application's build.gradle.");
        }
        super.attachInfo(context, providerInfo);
    }

    @Override
    public final int delete(Uri uri, String str, String[] strArr) {
        return 0;
    }

    @Override
    public final String getType(Uri uri) {
        return null;
    }

    @Override
    public final Uri insert(Uri uri, ContentValues contentValues) {
        return null;
    }

    @Override
    public final boolean onCreate() {
        Context context = getContext();
        if (context == null) {
            zzfn.zze("GamesInitProvider", "No Context available. Please manually invoke PlayGamesSdk.initialize().");
            return false;
        }
        zzbw.zza(context);
        return false;
    }

    @Override
    public final Cursor query(Uri uri, String[] strArr, String str, String[] strArr2, String str2) {
        return null;
    }

    @Override
    public final int update(Uri uri, ContentValues contentValues, String str, String[] strArr) {
        return 0;
    }
}
