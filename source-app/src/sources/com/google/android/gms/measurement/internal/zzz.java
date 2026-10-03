package com.google.android.gms.measurement.internal;

import androidx.collection.ArrayMap;
import com.google.android.gms.internal.measurement.zzob;
import java.util.HashSet;
import java.util.Iterator;

final class zzz extends zzac {
    private com.google.android.gms.internal.measurement.zzew.zzb zzg;
    private final zzt zzh;

    @Override
    final int zza() {
        return this.zzg.zzb();
    }

    @Override
    final boolean zzc() {
        return false;
    }

    zzz(zzt zztVar, String str, int i, com.google.android.gms.internal.measurement.zzew.zzb zzbVar) {
        super(str, i);
        this.zzh = zztVar;
        this.zzg = zzbVar;
    }

    @Override
    final boolean zzb() {
        return this.zzg.zzk();
    }

    final boolean zza(Long l, Long l2, com.google.android.gms.internal.measurement.zzfi.zze zzeVar, long j, zzbc zzbcVar, boolean z) {
        HashSet hashSet;
        Iterator<com.google.android.gms.internal.measurement.zzew.zzc> it;
        ArrayMap arrayMap;
        Iterator<com.google.android.gms.internal.measurement.zzfi.zzg> it2;
        Iterator<com.google.android.gms.internal.measurement.zzew.zzc> it3;
        com.google.android.gms.internal.measurement.zzew.zzc next;
        boolean z2;
        String strZze;
        Object obj;
        Boolean boolZza;
        Boolean boolZza2;
        String str;
        Boolean boolZza3;
        com.google.android.gms.internal.measurement.zzfi.zzg next2;
        Long lValueOf;
        Double dValueOf;
        com.google.android.gms.internal.measurement.zzew.zzc next3;
        Boolean bool = false;
        boolean z3 = zzob.zza() && this.zzh.zze().zzf(this.zza, zzbi.zzbg);
        long j2 = this.zzg.zzj() ? zzbcVar.zze : j;
        if (this.zzh.zzj().zza(2)) {
            this.zzh.zzj().zzp().zza("Evaluating filter. audience, filter, event", Integer.valueOf(this.zzb), this.zzg.zzl() ? Integer.valueOf(this.zzg.zzb()) : null, this.zzh.zzi().zza(this.zzg.zzf()));
            this.zzh.zzj().zzp().zza("Filter definition", this.zzh.mo32g_().zza(this.zzg));
        }
        if (!this.zzg.zzl() || this.zzg.zzb() > 256) {
            this.zzh.zzj().zzu().zza("Invalid event filter ID. appId, id", zzfr.zza(this.zza), String.valueOf(this.zzg.zzl() ? Integer.valueOf(this.zzg.zzb()) : null));
            return false;
        }
        boolean z4 = this.zzg.zzh() || this.zzg.zzi() || this.zzg.zzj();
        if (z && !z4) {
            this.zzh.zzj().zzp().zza("Event filter already evaluated true and it is not associated with an enhanced audience. audience ID, filter ID", Integer.valueOf(this.zzb), this.zzg.zzl() ? Integer.valueOf(this.zzg.zzb()) : null);
            return true;
        }
        com.google.android.gms.internal.measurement.zzew.zzb zzbVar = this.zzg;
        String strZzg = zzeVar.zzg();
        if (zzbVar.zzk()) {
            Boolean boolZza4 = zza(j2, zzbVar.zze());
            if (boolZza4 == null) {
                bool = null;
                break;
            }
            if (boolZza4.booleanValue()) {
                hashSet = new HashSet();
                it = zzbVar.zzg().iterator();
                while (true) {
                    if (it.hasNext()) {
                        next3 = it.next();
                        if (next3.zze().isEmpty()) {
                            this.zzh.zzj().zzu().zza("null or empty param name in filter. event", this.zzh.zzi().zza(strZzg));
                        } else {
                            hashSet.add(next3.zze());
                        }
                    } else {
                        arrayMap = new ArrayMap();
                        it2 = zzeVar.zzh().iterator();
                        while (true) {
                            if (it2.hasNext()) {
                                next2 = it2.next();
                                if (!hashSet.contains(next2.zzg())) {
                                    if (next2.zzl()) {
                                        String strZzg2 = next2.zzg();
                                        if (next2.zzl()) {
                                            lValueOf = Long.valueOf(next2.zzd());
                                        } else {
                                            lValueOf = null;
                                        }
                                        arrayMap.put(strZzg2, lValueOf);
                                    } else if (next2.zzj()) {
                                        String strZzg3 = next2.zzg();
                                        if (next2.zzj()) {
                                            dValueOf = Double.valueOf(next2.zza());
                                        } else {
                                            dValueOf = null;
                                        }
                                        arrayMap.put(strZzg3, dValueOf);
                                    } else if (next2.zzn()) {
                                        arrayMap.put(next2.zzg(), next2.zzh());
                                    } else {
                                        this.zzh.zzj().zzu().zza("Unknown value for param. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(next2.zzg()));
                                    }
                                }
                            } else {
                                it3 = zzbVar.zzg().iterator();
                                while (true) {
                                    if (it3.hasNext()) {
                                        next = it3.next();
                                        if (next.zzg()) {
                                            z2 = false;
                                        } else {
                                            z2 = false;
                                        }
                                        strZze = next.zze();
                                        if (strZze.isEmpty()) {
                                            this.zzh.zzj().zzu().zza("Event has empty param name. event", this.zzh.zzi().zza(strZzg));
                                        } else {
                                            obj = arrayMap.get(strZze);
                                            if (obj instanceof Long) {
                                                if (!next.zzh()) {
                                                    this.zzh.zzj().zzu().zza("No number filter for long param. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                                } else {
                                                    boolZza = zza(((Long) obj).longValue(), next.zzc());
                                                    if (boolZza == null) {
                                                        if (boolZza.booleanValue() == z2) {
                                                            break;
                                                            break;
                                                        }
                                                    }
                                                }
                                            } else if (obj instanceof Double) {
                                                if (!next.zzh()) {
                                                    this.zzh.zzj().zzu().zza("No number filter for double param. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                                } else {
                                                    boolZza2 = zza(((Double) obj).doubleValue(), next.zzc());
                                                    if (boolZza2 == null) {
                                                        if (boolZza2.booleanValue() == z2) {
                                                            break;
                                                            break;
                                                        }
                                                    }
                                                }
                                            } else if (obj instanceof String) {
                                                if (next.zzj()) {
                                                    boolZza3 = zza((String) obj, next.zzd(), this.zzh.zzj());
                                                } else if (next.zzh()) {
                                                    str = (String) obj;
                                                    if (zzmz.zzb(str)) {
                                                        boolZza3 = zza(str, next.zzc());
                                                    } else {
                                                        this.zzh.zzj().zzu().zza("Invalid param value for number filter. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                                    }
                                                } else {
                                                    this.zzh.zzj().zzu().zza("No filter for String param. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                                }
                                                if (boolZza3 == null) {
                                                    if (boolZza3.booleanValue() == z2) {
                                                        break;
                                                        break;
                                                    }
                                                }
                                            } else {
                                                if (obj == null) {
                                                    this.zzh.zzj().zzp().zza("Missing param for filter. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                                    break;
                                                }
                                                this.zzh.zzj().zzu().zza("Unknown param type. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                            }
                                        }
                                    } else {
                                        bool = true;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    bool = null;
                    break;
                }
            }
        } else {
            hashSet = new HashSet();
            it = zzbVar.zzg().iterator();
            while (true) {
                if (it.hasNext()) {
                    next3 = it.next();
                    if (next3.zze().isEmpty()) {
                        this.zzh.zzj().zzu().zza("null or empty param name in filter. event", this.zzh.zzi().zza(strZzg));
                    } else {
                        hashSet.add(next3.zze());
                    }
                } else {
                    arrayMap = new ArrayMap();
                    it2 = zzeVar.zzh().iterator();
                    while (true) {
                        if (it2.hasNext()) {
                            next2 = it2.next();
                            if (!hashSet.contains(next2.zzg())) {
                                if (next2.zzl()) {
                                    String strZzg4 = next2.zzg();
                                    if (next2.zzl()) {
                                        lValueOf = Long.valueOf(next2.zzd());
                                    } else {
                                        lValueOf = null;
                                    }
                                    arrayMap.put(strZzg4, lValueOf);
                                } else if (next2.zzj()) {
                                    String strZzg5 = next2.zzg();
                                    if (next2.zzj()) {
                                        dValueOf = Double.valueOf(next2.zza());
                                    } else {
                                        dValueOf = null;
                                    }
                                    arrayMap.put(strZzg5, dValueOf);
                                } else if (next2.zzn()) {
                                    arrayMap.put(next2.zzg(), next2.zzh());
                                } else {
                                    this.zzh.zzj().zzu().zza("Unknown value for param. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(next2.zzg()));
                                }
                            }
                        } else {
                            it3 = zzbVar.zzg().iterator();
                            while (true) {
                                if (it3.hasNext()) {
                                    next = it3.next();
                                    if (next.zzg() || !next.zzf()) {
                                        z2 = false;
                                    } else {
                                        z2 = true;
                                    }
                                    strZze = next.zze();
                                    if (strZze.isEmpty()) {
                                        this.zzh.zzj().zzu().zza("Event has empty param name. event", this.zzh.zzi().zza(strZzg));
                                    } else {
                                        obj = arrayMap.get(strZze);
                                        if (obj instanceof Long) {
                                            if (!next.zzh()) {
                                                this.zzh.zzj().zzu().zza("No number filter for long param. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                            } else {
                                                boolZza = zza(((Long) obj).longValue(), next.zzc());
                                                if (boolZza == null) {
                                                    if (boolZza.booleanValue() == z2) {
                                                        break;
                                                    }
                                                }
                                            }
                                        } else if (obj instanceof Double) {
                                            if (!next.zzh()) {
                                                this.zzh.zzj().zzu().zza("No number filter for double param. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                            } else {
                                                boolZza2 = zza(((Double) obj).doubleValue(), next.zzc());
                                                if (boolZza2 == null) {
                                                    if (boolZza2.booleanValue() == z2) {
                                                        break;
                                                    }
                                                }
                                            }
                                        } else if (obj instanceof String) {
                                            if (next.zzj()) {
                                                boolZza3 = zza((String) obj, next.zzd(), this.zzh.zzj());
                                            } else if (next.zzh()) {
                                                str = (String) obj;
                                                if (zzmz.zzb(str)) {
                                                    boolZza3 = zza(str, next.zzc());
                                                } else {
                                                    this.zzh.zzj().zzu().zza("Invalid param value for number filter. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                                }
                                            } else {
                                                this.zzh.zzj().zzu().zza("No filter for String param. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                            }
                                            if (boolZza3 == null) {
                                                if (boolZza3.booleanValue() == z2) {
                                                    break;
                                                }
                                            }
                                        } else {
                                            if (obj == null) {
                                                this.zzh.zzj().zzp().zza("Missing param for filter. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                                break;
                                            }
                                            this.zzh.zzj().zzu().zza("Unknown param type. event, param", this.zzh.zzi().zza(strZzg), this.zzh.zzi().zzb(strZze));
                                        }
                                    }
                                } else {
                                    bool = true;
                                    break;
                                }
                            }
                        }
                    }
                }
                bool = null;
                break;
            }
        }
        this.zzh.zzj().zzp().zza("Event filter result", bool == null ? "null" : bool);
        if (bool == null) {
            return false;
        }
        this.zzc = true;
        if (!bool.booleanValue()) {
            return true;
        }
        this.zzd = true;
        if (z4 && zzeVar.zzk()) {
            Long lValueOf2 = Long.valueOf(zzeVar.zzd());
            if (this.zzg.zzi()) {
                if (z3 && this.zzg.zzk()) {
                    lValueOf2 = l;
                }
                this.zzf = lValueOf2;
            } else {
                if (z3 && this.zzg.zzk()) {
                    lValueOf2 = l2;
                }
                this.zze = lValueOf2;
            }
        }
        return true;
    }
}
