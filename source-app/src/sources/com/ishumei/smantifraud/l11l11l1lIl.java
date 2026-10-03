package com.ishumei.smantifraud;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.security.cert.CertificateFactory;
import java.security.spec.MGF1ParameterSpec;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.OAEPParameterSpec;
import javax.crypto.spec.PSource;
import javax.crypto.spec.SecretKeySpec;

public class l11l11l1lIl {
    public static String l1111l111111Il() throws Exception {
        KeyGenerator keyGenerator = KeyGenerator.getInstance("AES");
        keyGenerator.init(l1l11lI1l.l111l11111lIl);
        return l1l1l11Ill.l1111l111111Il(keyGenerator.generateKey().getEncoded());
    }

    public static String l1111l111111Il(String str, String str2) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWITHSHA-256ANDMGF1PADDING");
        cipher.init(1, CertificateFactory.getInstance("X.509").generateCertificate(new ByteArrayInputStream(l1l1l11Ill.l111l11111lIl(str))).getPublicKey(), new OAEPParameterSpec("SHA-256", "MGF1", MGF1ParameterSpec.SHA256, PSource.PSpecified.DEFAULT));
        return l1l1l11Ill.l1111l111111Il(cipher.doFinal(l1l1l11Ill.l111l11111lIl(str2)));
    }

    public static SecretKey l1111l111111Il(String str) throws Exception {
        byte[] bArrL111l11111lIl = l1l1l11Ill.l111l11111lIl(str);
        return new SecretKeySpec(bArrL111l11111lIl, 0, bArrL111l11111lIl.length, "AES");
    }

    public static byte[] l1111l111111Il(String str, byte[] bArr) throws IOException {
        try {
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(2, l1111l111111Il(str), new IvParameterSpec("0102030405060708".getBytes()));
            return cipher.doFinal(bArr);
        } catch (Exception e) {
            throw new IOException(e);
        }
    }

    public static byte[] l1111l111111Il(String str, byte[] bArr, int i) throws IOException {
        try {
            return l1111l111111Il(str, bArr);
        } catch (Exception e) {
            throw new IOException(e);
        }
    }

    public static String l111l11111lIl(String str, byte[] bArr, int i) throws IOException {
        try {
            return new String(l1111l111111Il(str, bArr, i), l11l11l1lI1l.l11l111ll1Il);
        } catch (Throwable th) {
            throw new IOException(th);
        }
    }
}
