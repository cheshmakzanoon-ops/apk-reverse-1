package com.google.android.gms.internal.p003authapi;

import com.google.android.gms.common.Feature;

public final class zzam {
    public static final Feature zzcw;
    public static final Feature zzcx;
    private static final Feature zzcy;
    private static final Feature zzcz;
    private static final Feature zzda;
    private static final Feature zzdb;
    private static final Feature zzdc;
    public static final Feature[] zzdd;

    static {
        Feature feature = new Feature("auth_api_credentials_begin_sign_in", 2L);
        zzcw = feature;
        Feature feature2 = new Feature("auth_api_credentials_sign_out", 2L);
        zzcx = feature2;
        Feature feature3 = new Feature("auth_api_credentials_authorize", 1L);
        zzcy = feature3;
        Feature feature4 = new Feature("auth_api_credentials_revoke_access", 1L);
        zzcz = feature4;
        Feature feature5 = new Feature("auth_api_credentials_save_password", 2L);
        zzda = feature5;
        Feature feature6 = new Feature("auth_api_credentials_get_sign_in_intent", 2L);
        zzdb = feature6;
        Feature feature7 = new Feature("auth_api_credentials_save_account_linking_token", 1L);
        zzdc = feature7;
        zzdd = new Feature[]{feature, feature2, feature3, feature4, feature5, feature6, feature7};
    }
}
