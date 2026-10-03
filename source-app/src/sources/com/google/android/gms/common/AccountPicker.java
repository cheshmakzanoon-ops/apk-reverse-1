package com.google.android.gms.common;

import android.accounts.Account;
import android.content.Intent;
import android.os.Bundle;
import com.google.android.gms.common.internal.Preconditions;
import java.util.ArrayList;
import java.util.List;

public final class AccountPicker {

    public static class AccountChooserOptions {
        private Account zza;
        private ArrayList zzb;
        private ArrayList zzc;
        private boolean zzd;
        private String zze;
        private Bundle zzf;

        public static class Builder {
            private Account zza;
            private ArrayList zzb;
            private ArrayList zzc;
            private boolean zzd = false;
            private String zze;
            private Bundle zzf;

            public AccountChooserOptions build() {
                Preconditions.checkArgument(true, "We only support hostedDomain filter for account chip styled account picker");
                Preconditions.checkArgument(true, "Consent is only valid for account chip styled account picker");
                AccountChooserOptions accountChooserOptions = new AccountChooserOptions();
                accountChooserOptions.zzf(this.zzc);
                accountChooserOptions.zzd(this.zzb);
                accountChooserOptions.zzh(this.zzd);
                accountChooserOptions.zzl(this.zzf);
                accountChooserOptions.zzb(this.zza);
                accountChooserOptions.zzj(this.zze);
                return accountChooserOptions;
            }

            public Builder setAllowableAccounts(List<Account> list) {
                this.zzb = list == null ? null : new ArrayList(list);
                return this;
            }

            public Builder setAllowableAccountsTypes(List<String> list) {
                this.zzc = list == null ? null : new ArrayList(list);
                return this;
            }

            public Builder setAlwaysShowAccountPicker(boolean z) {
                this.zzd = z;
                return this;
            }

            public Builder setOptionsForAddingAccount(Bundle bundle) {
                this.zzf = bundle;
                return this;
            }

            public Builder setSelectedAccount(Account account) {
                this.zza = account;
                return this;
            }

            public Builder setTitleOverrideText(String str) {
                this.zze = str;
                return this;
            }
        }

        final Account zza() {
            return this.zza;
        }

        final void zzb(Account account) {
            this.zza = account;
        }

        final ArrayList zzc() {
            return this.zzb;
        }

        final void zzd(ArrayList arrayList) {
            this.zzb = arrayList;
        }

        final ArrayList zze() {
            return this.zzc;
        }

        final void zzf(ArrayList arrayList) {
            this.zzc = arrayList;
        }

        final boolean zzg() {
            return this.zzd;
        }

        final void zzh(boolean z) {
            this.zzd = z;
        }

        final String zzi() {
            return this.zze;
        }

        final void zzj(String str) {
            this.zze = str;
        }

        final Bundle zzk() {
            return this.zzf;
        }

        final void zzl(Bundle bundle) {
            this.zzf = bundle;
        }
    }

    private AccountPicker() {
    }

    @Deprecated
    public static Intent newChooseAccountIntent(Account account, ArrayList<Account> arrayList, String[] strArr, boolean z, String str, String str2, String[] strArr2, Bundle bundle) {
        Intent intent = new Intent();
        Preconditions.checkArgument(true, "We only support hostedDomain filter for account chip styled account picker");
        intent.setAction("com.google.android.gms.common.account.CHOOSE_ACCOUNT");
        intent.setPackage("com.google.android.gms");
        intent.putExtra("allowableAccounts", arrayList);
        intent.putExtra("allowableAccountTypes", strArr);
        intent.putExtra("addAccountOptions", bundle);
        intent.putExtra("selectedAccount", account);
        intent.putExtra("alwaysPromptForAccount", z);
        intent.putExtra("descriptionTextOverride", str);
        intent.putExtra("authTokenType", str2);
        intent.putExtra("addAccountRequiredFeatures", strArr2);
        intent.putExtra("setGmsCoreAccount", false);
        intent.putExtra("overrideTheme", 0);
        intent.putExtra("overrideCustomTheme", 0);
        intent.putExtra("hostedDomainFilter", (String) null);
        return intent;
    }

    public static Intent newChooseAccountIntent(AccountChooserOptions accountChooserOptions) {
        Intent intent = new Intent();
        Preconditions.checkArgument(true, "We only support hostedDomain filter for account chip styled account picker");
        Preconditions.checkArgument(true, "Consent is only valid for account chip styled account picker");
        Preconditions.checkArgument(true, "Making the selected account non-clickable is only supported for the THEME_DAY_NIGHT_GOOGLE_MATERIAL2, THEME_LIGHT_GOOGLE_MATERIAL3, THEME_DARK_GOOGLE_MATERIAL3 or THEME_DAY_NIGHT_GOOGLE_MATERIAL3 themes");
        intent.setAction("com.google.android.gms.common.account.CHOOSE_ACCOUNT");
        intent.setPackage("com.google.android.gms");
        intent.putExtra("allowableAccounts", accountChooserOptions.zzc());
        if (accountChooserOptions.zze() != null) {
            intent.putExtra("allowableAccountTypes", (String[]) accountChooserOptions.zze().toArray(new String[0]));
        }
        intent.putExtra("addAccountOptions", accountChooserOptions.zzk());
        intent.putExtra("selectedAccount", accountChooserOptions.zza());
        intent.putExtra("selectedAccountIsNotClickable", false);
        intent.putExtra("alwaysPromptForAccount", accountChooserOptions.zzg());
        intent.putExtra("descriptionTextOverride", accountChooserOptions.zzi());
        intent.putExtra("setGmsCoreAccount", false);
        intent.putExtra("realClientPackage", (String) null);
        intent.putExtra("overrideTheme", 0);
        intent.putExtra("overrideCustomTheme", 0);
        intent.putExtra("hostedDomainFilter", (String) null);
        Bundle bundle = new Bundle();
        if (!bundle.isEmpty()) {
            intent.putExtra("first_party_options_bundle", bundle);
        }
        return intent;
    }
}
