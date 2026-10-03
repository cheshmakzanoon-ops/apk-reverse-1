package com.google.android.gms.games;

import com.google.android.gms.common.Feature;

public final class zzd {
    public static final Feature zza;
    public static final Feature zzb;
    public static final Feature zzc;
    public static final Feature zzd;
    public static final Feature zze;
    public static final Feature zzf;
    public static final Feature zzg;
    public static final Feature zzh;
    public static final Feature zzi;
    public static final Feature[] zzj;

    static {
        Feature feature = new Feature("games_get_account_selection_intent", 1L);
        zza = feature;
        Feature feature2 = new Feature("games_get_privacy_settings_intent", 1L);
        zzb = feature2;
        Feature feature3 = new Feature("games_load_player_force_reload", 1L);
        zzc = feature3;
        Feature feature4 = new Feature("games_load_profile_capabilities", 2L);
        zzd = feature4;
        Feature feature5 = new Feature("games_recall", 1L);
        zze = feature5;
        Feature feature6 = new Feature("games_report_player", 1L);
        zzf = feature6;
        Feature feature7 = new Feature("games_app_shortcuts", 1L);
        zzg = feature7;
        Feature feature8 = new Feature("games_game_streaks", 1L);
        zzh = feature8;
        Feature feature9 = new Feature("games_public_gamer_profile", 1L);
        zzi = feature9;
        zzj = new Feature[]{feature, feature2, feature3, feature4, feature5, feature6, feature7, feature8, feature9};
    }
}
