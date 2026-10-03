package com.unity3d.player;

import java.lang.reflect.Method;
import java.util.HashMap;

final class C1143r {

    private HashMap f485a = new HashMap();

    private Class f486b;

    private Object f487c;

    class a {

        public Class[] f488a;

        public Method f489b = null;

        public a(Class[] clsArr) {
            this.f488a = clsArr;
        }
    }

    public C1143r(Class cls, Object obj) {
        this.f486b = cls;
        this.f487c = obj;
    }

    private void m689a(String str, a aVar) {
        try {
            aVar.f489b = this.f486b.getMethod(str, aVar.f488a);
        } catch (Exception e) {
            C1134i.Log(6, "Exception while trying to get method " + str + ". " + e.getLocalizedMessage());
            aVar.f489b = null;
        }
    }

    public final Object m690a(String str, Object... objArr) {
        StringBuilder sb;
        Object objInvoke = null;
        if (this.f485a.containsKey(str)) {
            a aVar = (a) this.f485a.get(str);
            if (aVar.f489b == null) {
                m689a(str, aVar);
            }
            if (aVar.f489b != null) {
                try {
                    objInvoke = objArr.length == 0 ? aVar.f489b.invoke(this.f487c, null) : aVar.f489b.invoke(this.f487c, objArr);
                } catch (Exception e) {
                    C1134i.Log(6, "Error trying to call delegated method " + str + ". " + e.getLocalizedMessage());
                }
                return objInvoke;
            }
            sb = new StringBuilder("Unable to create method: ");
        } else {
            sb = new StringBuilder("No definition for method ");
            sb.append(str);
            str = " can be found";
        }
        sb.append(str);
        C1134i.Log(6, sb.toString());
        return null;
    }

    public final void m691a(String str, Class[] clsArr) {
        this.f485a.put(str, new a(clsArr));
    }
}
