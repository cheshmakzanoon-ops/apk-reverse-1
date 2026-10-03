package com.google.zxing.client.result;

import com.google.zxing.Result;

public final class URLTOResultParser extends ResultParser {
    @Override
    public URIParsedResult parse(Result result) {
        int iIndexOf;
        String massagedText = getMassagedText(result);
        if ((massagedText.startsWith("urlto:") || massagedText.startsWith("URLTO:")) && (iIndexOf = massagedText.indexOf(58, 6)) >= 0) {
            return new URIParsedResult(massagedText.substring(iIndexOf + 1), iIndexOf > 6 ? massagedText.substring(6, iIndexOf) : null);
        }
        return null;
    }
}
