package cn.thinkingdata.android.encrypt;

public class C0727d implements InterfaceC0724a {

    byte[] f184a;

    String f185b;

    @Override
    public String mo508a() {
        return "AES";
    }

    @Override
    public String mo509a(String str) {
        return C0726c.m515a(this.f184a, str);
    }

    @Override
    public String mo510b() {
        return "RSA";
    }

    @Override
    public String mo511b(String str) {
        try {
            byte[] bArrM518a = C0726c.m518a();
            this.f184a = bArrM518a;
            String strM514a = C0726c.m514a(str, bArrM518a);
            this.f185b = strM514a;
            return strM514a;
        } catch (Exception unused) {
            return null;
        }
    }
}
