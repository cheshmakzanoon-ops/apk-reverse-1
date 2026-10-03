package com.ishumei.smantifraud;

import java.io.ByteArrayOutputStream;
import java.util.zip.Inflater;

public class l11l1l1I1l {
    public static byte[] l1111l111111Il(byte[] bArr) throws Exception {
        int iInflate;
        byte[] bArr2 = new byte[l111l11l11Ill.l111l11111lIl];
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(bArr.length);
        Inflater inflater = new Inflater();
        inflater.setInput(bArr, 0, bArr.length);
        while (!inflater.finished() && (iInflate = inflater.inflate(bArr2)) > 0) {
            byteArrayOutputStream.write(bArr2, 0, iInflate);
        }
        inflater.end();
        return byteArrayOutputStream.toByteArray();
    }
}
