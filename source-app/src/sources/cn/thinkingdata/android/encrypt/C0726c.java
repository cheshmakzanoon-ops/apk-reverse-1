package cn.thinkingdata.android.encrypt;

import android.text.TextUtils;
import cn.thinkingdata.android.utils.C0750a;
import cn.thinkingdata.android.utils.TDLog;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.spec.SecretKeySpec;
import org.json.JSONArray;
import org.json.JSONObject;

public class C0726c {
    static String m514a(String str, byte[] bArr) {
        if (TextUtils.isEmpty(str)) {
            TDLog.m682i("ThinkingAnalytics.TAEncryptUtils", "PublicKey is null.");
            return null;
        }
        try {
            PublicKey publicKeyGeneratePublic = KeyFactory.getInstance("RSA").generatePublic(new X509EncodedKeySpec(C0725b.m512a(str)));
            Cipher cipher = Cipher.getInstance("RSA/None/PKCS1Padding");
            cipher.init(1, publicKeyGeneratePublic);
            return new String(C0750a.m689a(cipher.doFinal(bArr)));
        } catch (Exception e) {
            TDLog.m679d("ThinkingAnalytics.TAEncryptUtils", "AES加密失败:" + e.getMessage());
            return null;
        }
    }

    static String m515a(byte[] bArr, String str) {
        if (bArr != null && str != null) {
            byte[] bytes = str.getBytes();
            try {
                SecretKeySpec secretKeySpec = new SecretKeySpec(bArr, "AES");
                Cipher cipher = Cipher.getInstance("AES/ECB/PKCS7Padding");
                cipher.init(1, secretKeySpec);
                return new String(C0750a.m689a(cipher.doFinal(bytes)));
            } catch (Exception e) {
                TDLog.m679d("ThinkingAnalytics.TAEncryptUtils", "RSA加密失败:" + e.getMessage());
            }
        }
        return null;
    }

    public static boolean m516a(JSONArray jSONArray) {
        for (int i = 0; i < jSONArray.length(); i++) {
            try {
                if (m517a(jSONArray.getJSONObject(i))) {
                    return true;
                }
            } catch (Exception unused) {
            }
        }
        return false;
    }

    public static boolean m517a(JSONObject jSONObject) {
        return jSONObject != null && jSONObject.length() == 3 && jSONObject.has("ekey") && jSONObject.has("pkv") && jSONObject.has("payload");
    }

    static byte[] m518a() throws NoSuchAlgorithmException {
        KeyGenerator keyGenerator = KeyGenerator.getInstance("AES");
        keyGenerator.init(128);
        return keyGenerator.generateKey().getEncoded();
    }
}
