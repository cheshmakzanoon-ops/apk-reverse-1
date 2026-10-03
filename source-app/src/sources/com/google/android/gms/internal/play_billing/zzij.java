package com.google.android.gms.internal.play_billing;

import com.google.common.base.Ascii;

final class zzij {
    static void zza(byte b, byte b2, byte b3, byte b4, char[] cArr, int i) throws zzgc {
        if (zze(b2) || (((b << Ascii.f83FS) + (b2 + 112)) >> 30) != 0 || zze(b3) || zze(b4)) {
            throw new zzgc("Protocol message had invalid UTF-8.");
        }
        int i2 = ((b & 7) << 18) | ((b2 & 63) << 12) | ((b3 & 63) << 6) | (b4 & 63);
        cArr[i] = (char) ((i2 >>> 10) + 55232);
        cArr[i + 1] = (char) ((i2 & 1023) + 56320);
    }

    static void zzc(byte b, byte b2, char[] cArr, int i) throws zzgc {
        if (b < -62 || zze(b2)) {
            throw new zzgc("Protocol message had invalid UTF-8.");
        }
        cArr[i] = (char) (((b & Ascii.f92US) << 6) | (b2 & 63));
    }

    static boolean zzd(byte b) {
        return b >= 0;
    }

    private static boolean zze(byte b) {
        return b > -65;
    }

    static void zzb(byte b, byte b2, byte b3, char[] cArr, int i) throws zzgc {
        if (!zze(b2)) {
            if (b != -32) {
                if (b != -19) {
                    if (!zze(b3)) {
                        cArr[i] = (char) (((b & Ascii.f89SI) << 12) | ((b2 & 63) << 6) | (b3 & 63));
                        return;
                    }
                } else if (b2 < -96) {
                    b = -19;
                    if (!zze(b3)) {
                        cArr[i] = (char) (((b & Ascii.f89SI) << 12) | ((b2 & 63) << 6) | (b3 & 63));
                        return;
                    }
                }
            } else if (b2 >= -96) {
                b = -32;
                if (b != -19) {
                    if (!zze(b3)) {
                        cArr[i] = (char) (((b & Ascii.f89SI) << 12) | ((b2 & 63) << 6) | (b3 & 63));
                        return;
                    }
                } else if (b2 < -96) {
                    b = -19;
                    if (!zze(b3)) {
                        cArr[i] = (char) (((b & Ascii.f89SI) << 12) | ((b2 & 63) << 6) | (b3 & 63));
                        return;
                    }
                }
            }
        }
        throw new zzgc("Protocol message had invalid UTF-8.");
    }
}
