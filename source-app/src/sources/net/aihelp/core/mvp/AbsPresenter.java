package net.aihelp.core.mvp;

import android.content.Context;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import net.aihelp.core.mvp.IRepository;
import net.aihelp.core.mvp.IView;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.BaseCallback;
import net.aihelp.data.logic.RequestRetryHandler;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SpUtil;
import net.aihelp.utils.ToastUtil;
import okhttp3.Call;
import org.json.JSONObject;

public abstract class AbsPresenter<V extends IView, R extends IRepository> implements IPresenter<V>, RequestRetryHandler.OnRetryRequestListener {
    protected final Context mContext;
    protected R mRepo;
    protected final RequestRetryHandler mRetryHandler;
    protected SpUtil mSp;
    protected V mView;

    protected void initOtherRepository() {
    }

    @Override
    public void onRetryRequest() {
    }

    @Override
    public void onRetryUpToMaxCount(int i, String str) {
    }

    public AbsPresenter(Context context) {
        this(context, 10);
    }

    public AbsPresenter(Context context, int i) {
        this.mContext = context;
        this.mRepo = (R) initRepository();
        this.mSp = SpUtil.getInstance();
        initOtherRepository();
        this.mRetryHandler = new RequestRetryHandler(this, i);
    }

    @Override
    public void attachView(V v) {
        this.mView = v;
    }

    @Override
    public void detachView() {
        this.mView = null;
    }

    public boolean isNetworkAvailable() {
        return AppInfoUtil.isNetworkAvailable(this.mContext);
    }

    protected R initRepository() {
        Class cls;
        Type genericSuperclass = getClass().getGenericSuperclass();
        if (!(genericSuperclass instanceof ParameterizedType) || (cls = (Class) ((ParameterizedType) genericSuperclass).getActualTypeArguments()[1]) == IRepository.class) {
            return null;
        }
        try {
            return (R) cls.getDeclaredConstructor(Context.class).newInstance(this.mContext);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    protected <T> void get(String str, JSONObject jSONObject, BaseCallback<T> baseCallback) {
        if (!isNetworkAvailable()) {
            ToastUtil.INSTANCE.makeRawToast(this.mContext, ResResolver.getString("aihelp_network_no_connect"));
        } else {
            AIHelpRequest.getInstance().requestGetByAsync(str, jSONObject, baseCallback);
        }
    }

    protected <T> Call post(String str, JSONObject jSONObject, BaseCallback<T> baseCallback) {
        if (!isNetworkAvailable()) {
            ToastUtil.INSTANCE.makeRawToast(this.mContext, ResResolver.getString("aihelp_network_no_connect"));
            return null;
        }
        return AIHelpRequest.getInstance().requestPostByJson(str, jSONObject, baseCallback);
    }

    protected void mqtt(String str, JSONObject jSONObject) {
        if (isNetworkAvailable()) {
            return;
        }
        ToastUtil.INSTANCE.makeRawToast(this.mContext, ResResolver.getString("aihelp_network_no_connect"));
    }
}
