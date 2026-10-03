package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;
import com.google.common.collect.ImmutableSetMultimap;

public final class zzha {
    public static final Supplier<ImmutableSetMultimap<String, String>> zza = Suppliers.memoize(new Supplier() {
        @Override
        public final Object get() {
            return new ImmutableSetMultimap.Builder().build();
        }
    });
}
