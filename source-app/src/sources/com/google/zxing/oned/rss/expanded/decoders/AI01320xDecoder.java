package com.google.zxing.oned.rss.expanded.decoders;

import com.google.zxing.common.BitArray;
import com.loopj.android.http.AsyncHttpClient;

final class AI01320xDecoder extends AI013x0xDecoder {
    @Override
    protected int checkWeight(int i) {
        return i < 10000 ? i : i - AsyncHttpClient.DEFAULT_SOCKET_TIMEOUT;
    }

    AI01320xDecoder(BitArray bitArray) {
        super(bitArray);
    }

    @Override
    protected void addWeightCode(StringBuilder sb, int i) {
        if (i < 10000) {
            sb.append("(3202)");
        } else {
            sb.append("(3203)");
        }
    }
}
