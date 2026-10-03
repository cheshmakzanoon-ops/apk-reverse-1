package com.ishumei.smantifraud;

import android.content.Context;
import android.content.res.Resources;
import android.util.Base64;
import android.util.Log;
import java.io.ByteArrayInputStream;
import java.security.PublicKey;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class l1l11lIll1l {
    public static final String l111l11111lIl = "Smlog";
    public Set<PublicKey> l1111l111111Il;
    public static final String l111l11111I1l = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAr7bHgiuxpwHsK7Qui8xU\nFmOr75gvMsd/dTEDDJdSSxtf6An7xyqpRR90PL2abxM1dEqlXnf2tqw1Ne4Xwl5j\nlRfdnJLmN0pTy/4lj4/7tv0Sk3iiKkypnEUtR6WfMgH0QZfKHM1+di+y9TFRtv6y\n//0rb+T+W8a9nsNL/ggjnar86461qO0rOs2cXjp3kOG1FEJ5MVmFmBGtnrKpa73X\npXyTqRxB/M0n1n/W9nGqC4FSYa04T6N5RIZGBN2z2MT5IKGbFlbC8UrW0DxW7AYI\nmQQcHtGl/m00QLVWutHQoVJYnFPlXTcHYvASLu+RhhsbDmxMgJJ0mcDpvsC4PjvB\n+TxywElgS70vE0XmLD+OJtvsBslHZvPBKCOdT0MS+tgSOIfga+z1Z1g7+DVagf7q\nuvmag8jfPioyKvxnK/EgsTUVi2ghzq8wm27ud/mIM7AY2qEORR8Go3TVB4HzWQgp\nZrt3i5MIlCaY504LzSRiigHCzAPlHws+W0rB5N+er5/2pJKnfBSDiCiFAVtCLOZ7\ngLiMm0jhO2B6tUXHI/+MRPjy02i59lINMRRev56GKtcd9qO/0kUJWdZTdA2XoS82\nixPvZtXQpUpuL12ab+9EaDK8Z4RHJYYfCT3Q5vNAXaiWQ+8PTWm2QgBR/bkwSWc+\nNpUFgNPN9PvQi8WEg5UmAGMCAwEAAQ==";
    public static final byte[] l11l1111lIIl = Base64.decode(l111l11111I1l, 0);
    public static final String l111l11111Il = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE7l1ex+HA220Dpn7mthvsTWpdamgu\nD/9/SQ59dx9EIm29sa/6FsvHrcV30lacqrewLVQBXT5DKyqO107sSHVBpA==";
    public static final byte[] l11l1111I11l = Base64.decode(l111l11111Il, 0);
    public static final String l111l1111l1Il = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCia63rbi5EYe/VDoLmt5TRdSMf\nd5tjkWP/96r/C3JHTsAsQ+wzfNes7UA+jCigZtX3hwszl94OuE4TQKuvpSe/lWmg\nMdsGUmX4RFlXYfC78hdLt0GAZMAoDo9Sd47b0ke2RekZyOmLw9vCkT/X11DEHTVm\n+Vfkl5YLCazOkjWFmwIDAQAB";
    public static final byte[] l11l1111I1l = Base64.decode(l111l1111l1Il, 0);
    public static final String l111l1111llIl = "MIGbMBAGByqGSM49AgEGBSuBBAAjA4GGAAQBs9Qjr//REhkXW7jUqjY9KNwWac4r\n5+kdUGk+TZjRo1YEa47Axwj6AJsbOjo4QsHiYRiWTELvFeiuBsKqyuF0xyAAKvDo\nfBqrEq1/Ckxo2mz7Q4NQes3g4ahSjtgUSh0k85fYwwHjCeLyZ5kEqgHG9OpOH526\nFFAK3slSUgC8RObbxys=";
    public static final byte[] l11l1111I1ll = Base64.decode(l111l1111llIl, 0);
    public static final String l111l1111lI1l = "MIGbMBAGByqGSM49AgEGBSuBBAAjA4GGAAQBhbGuLrpql5I2WJmrE5kEVZOo+dgA\n46mKrVJf/sgzfzs2u7M9c1Y9ZkCEiiYkhTFE9vPbasmUfXybwgZ2EM30A1ABPd12\n4n3JbEDfsB/wnMH1AcgsJyJFPbETZiy42Fhwi+2BCA5bcHe7SrdkRIYSsdBRaKBo\nZsapxB0gAOs0jSPRX5M=";
    public static final byte[] l11l1111Il = Base64.decode(l111l1111lI1l, 0);
    public static final String l111l1111lIl = "MIGbMBAGByqGSM49AgEGBSuBBAAjA4GGAAQB9XeEN8lg6p5xvMVWG42P2Qi/aRKX\n2rPRNgK92UlO9O/TIFCKHC1AWCLFitPVEow5W+yEgC2wOiYxgepY85TOoH0AuEkL\noiC6ldbF2uNVU3rYYSytWAJg3GFKd1l9VLDmxox58Hyw2Jmdd5VSObGiTFQ/SgKs\nn2fbQPtpGlNxgEfd6Y8=";
    public static final byte[] l11l1111Il1l = Base64.decode(l111l1111lIl, 0);

    public enum l1111l111111Il {
        UNKNOWN,
        AOSP,
        GOOGLE,
        KNOX,
        OEM
    }

    public l1111l111111Il l1111l111111Il(byte[] bArr) {
        if (Arrays.equals(bArr, l11l1111lIIl)) {
            return l1111l111111Il.GOOGLE;
        }
        if (!Arrays.equals(bArr, l11l1111I11l) && !Arrays.equals(bArr, l11l1111I1l)) {
            if (!Arrays.equals(bArr, l11l1111Il) && !Arrays.equals(bArr, l11l1111I1ll) && !Arrays.equals(bArr, l11l1111Il1l)) {
                Set<PublicKey> set = this.l1111l111111Il;
                if (set != null) {
                    Iterator<PublicKey> it = set.iterator();
                    while (it.hasNext()) {
                        if (Arrays.equals(bArr, it.next().getEncoded())) {
                            return l1111l111111Il.OEM;
                        }
                    }
                }
                return l1111l111111Il.UNKNOWN;
            }
            return l1111l111111Il.KNOX;
        }
        return l1111l111111Il.AOSP;
    }

    public void l1111l111111Il(Context context) {
        Resources resources = context.getApplicationContext().getResources();
        int identifier = resources.getIdentifier("android:array/vendor_required_attestation_certificates", null, null);
        if (identifier == 0) {
            return;
        }
        HashSet hashSet = new HashSet();
        try {
            CertificateFactory certificateFactory = CertificateFactory.getInstance("X.509");
            for (String str : resources.getStringArray(identifier)) {
                hashSet.add(certificateFactory.generateCertificate(new ByteArrayInputStream(str.replaceAll("\\s+", "\n").replaceAll("-BEGIN\\nCERTIFICATE-", "-BEGIN CERTIFICATE-").replaceAll("-END\\nCERTIFICATE-", "-END CERTIFICATE-").getBytes())).getPublicKey());
            }
            Iterator it = hashSet.iterator();
            while (it.hasNext()) {
                if (Arrays.equals(((PublicKey) it.next()).getEncoded(), l11l1111lIIl)) {
                    it.remove();
                }
            }
            if (hashSet.isEmpty()) {
                return;
            }
            this.l1111l111111Il = hashSet;
        } catch (CertificateException e) {
            Log.e("Smlog", "getOemKeys: ", e);
        }
    }
}
