package com.google.android.gms.internal.play_billing;

import com.google.android.gms.common.ConnectionResult;
import com.google.zxing.aztec.encoder.Encoder;
import com.ishumei.smantifraud.l11l11lI1lll;

final class zzix implements zzfx {
    static final zzfx zza = new zzix();

    private zzix() {
    }

    @Override
    public final boolean zza(int i) {
        switch (i) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
                return true;
            default:
                switch (i) {
                    case 22:
                    case ConnectionResult.API_DISABLED:
                    case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                    case 25:
                    case 26:
                    case 27:
                    case 28:
                    case 29:
                    case l11l11lI1lll.l11l1111Il1l:
                    case 31:
                    case 32:
                    case Encoder.DEFAULT_EC_PERCENT:
                    case 34:
                    case 35:
                    case 36:
                        return true;
                    default:
                        return false;
                }
        }
    }
}
