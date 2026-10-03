package cn.thinkingdata.android.encrypt;

import android.text.TextUtils;
import cn.thinkingdata.android.TDConfig;
import com.facebook.internal.security.CertificateUtil;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONObject;

public class C0728e {

    private static final Map<String, C0728e> f186d = new HashMap();

    private InterfaceC0724a f187a;

    private final List<InterfaceC0724a> f188b;

    private final TDConfig f189c;

    private C0728e(TDConfig tDConfig) {
        ArrayList arrayList = new ArrayList();
        this.f188b = arrayList;
        this.f189c = tDConfig;
        arrayList.add(new C0727d());
    }

    public static C0728e m519a(String str) {
        C0728e c0728e;
        Map<String, C0728e> map = f186d;
        synchronized (map) {
            c0728e = map.get(str);
        }
        return c0728e;
    }

    public static C0728e m520a(String str, TDConfig tDConfig) {
        C0728e c0728e;
        Map<String, C0728e> map = f186d;
        synchronized (map) {
            c0728e = map.get(str);
            if (c0728e == null) {
                c0728e = new C0728e(tDConfig);
                map.put(str, c0728e);
            }
        }
        return c0728e;
    }

    private boolean m521a(InterfaceC0724a interfaceC0724a) {
        return TextUtils.isEmpty(interfaceC0724a.mo510b()) || TextUtils.isEmpty(interfaceC0724a.mo508a());
    }

    private boolean m522b(TDSecreteKey tDSecreteKey) {
        return tDSecreteKey == null || TextUtils.isEmpty(tDSecreteKey.publicKey);
    }

    InterfaceC0724a m523a(TDSecreteKey tDSecreteKey) {
        if (m522b(tDSecreteKey)) {
            return null;
        }
        for (InterfaceC0724a interfaceC0724a : this.f188b) {
            if (interfaceC0724a != null && m525a(interfaceC0724a, tDSecreteKey)) {
                return interfaceC0724a;
            }
        }
        return null;
    }

    public JSONObject m524a(JSONObject jSONObject) {
        try {
            TDConfig tDConfig = this.f189c;
            if (tDConfig == null) {
                return jSONObject;
            }
            TDSecreteKey secreteKey = tDConfig.getSecreteKey();
            if (m522b(secreteKey)) {
                return jSONObject;
            }
            if (!m525a(this.f187a, secreteKey)) {
                this.f187a = m523a(secreteKey);
            }
            if (this.f187a == null) {
                return jSONObject;
            }
            String strSubstring = secreteKey.publicKey;
            if (strSubstring.startsWith("EC:")) {
                strSubstring = strSubstring.substring(strSubstring.indexOf(CertificateUtil.DELIMITER) + 1);
            }
            String strMo511b = this.f187a.mo511b(strSubstring);
            if (TextUtils.isEmpty(strMo511b)) {
                return jSONObject;
            }
            String strMo509a = this.f187a.mo509a(jSONObject.toString());
            if (TextUtils.isEmpty(strMo509a)) {
                return jSONObject;
            }
            JSONObject jSONObject2 = new JSONObject();
            jSONObject2.put("ekey", strMo511b);
            jSONObject2.put("pkv", secreteKey.version);
            jSONObject2.put("payload", strMo509a);
            return jSONObject2;
        } catch (Exception unused) {
            return jSONObject;
        }
    }

    boolean m525a(InterfaceC0724a interfaceC0724a, TDSecreteKey tDSecreteKey) {
        return (interfaceC0724a == null || m522b(tDSecreteKey) || m521a(interfaceC0724a) || !interfaceC0724a.mo510b().equals(tDSecreteKey.asymmetricEncryption) || !interfaceC0724a.mo508a().equals(tDSecreteKey.symmetricEncryption)) ? false : true;
    }
}
