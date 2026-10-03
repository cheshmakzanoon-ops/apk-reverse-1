package cz.msebera.android.httpclient.params;

@Deprecated
public class SyncBasicHttpParams extends BasicHttpParams {
    private static final long serialVersionUID = 5387834869062660642L;

    @Override
    public synchronized boolean removeParameter(String str) {
        return super.removeParameter(str);
    }

    @Override
    public synchronized HttpParams setParameter(String str, Object obj) {
        return super.setParameter(str, obj);
    }

    @Override
    public synchronized Object getParameter(String str) {
        return super.getParameter(str);
    }

    @Override
    public synchronized boolean isParameterSet(String str) {
        return super.isParameterSet(str);
    }

    @Override
    public synchronized boolean isParameterSetLocally(String str) {
        return super.isParameterSetLocally(str);
    }

    @Override
    public synchronized void setParameters(String[] strArr, Object obj) {
        super.setParameters(strArr, obj);
    }

    @Override
    public synchronized void clear() {
        super.clear();
    }

    @Override
    public synchronized Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
