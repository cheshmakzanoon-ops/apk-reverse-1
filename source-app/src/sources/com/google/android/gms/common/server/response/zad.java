package com.google.android.gms.common.server.response;

import java.io.BufferedReader;
import java.io.IOException;

final class zad implements zai {
    zad() {
    }

    @Override
    public final Object zaa(FastParser fastParser, BufferedReader bufferedReader) throws FastParser.ParseException, IOException {
        return Double.valueOf(fastParser.zaj(bufferedReader));
    }
}
