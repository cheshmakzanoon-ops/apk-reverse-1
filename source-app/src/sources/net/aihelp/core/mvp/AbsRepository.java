package net.aihelp.core.mvp;

import android.content.Context;
import android.text.TextUtils;
import java.lang.reflect.Field;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.UserProfile;
import net.aihelp.utils.SpUtil;

public abstract class AbsRepository implements IRepository {
    protected Context mContext;
    protected SpUtil mSp = SpUtil.getInstance();

    public AbsRepository(Context context) {
        this.mContext = context;
    }

    protected void doSave(String str, Object obj) {
        this.mSp.put(str, obj);
    }

    protected void updateUserProfile(String str, String str2) {
        updateValue(UserProfile.class, str, str2);
    }

    protected void updateAPI(String str, String str2) {
        if (TextUtils.isEmpty(str2)) {
            return;
        }
        updateValue(API.class, str, str2);
    }

    protected void updateConst(String str, Object obj) {
        updateValue(Const.class, str, obj);
    }

    private void updateValue(Class cls, String str, Object obj) {
        try {
            Field declaredField = cls.getDeclaredField(str.split("\\.")[1]);
            declaredField.setAccessible(true);
            if (obj != null) {
                declaredField.set(null, obj);
            } else if ("String".equals(declaredField.getType().getSimpleName())) {
                declaredField.set(null, "");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
