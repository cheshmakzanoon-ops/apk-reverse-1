package cz.msebera.android.httpclient.params;

import java.util.Set;

@Deprecated
public abstract class AbstractHttpParams implements HttpParams, HttpParamsNames {
    protected AbstractHttpParams() {
    }

    @Override
    public long getLongParameter(String str, long j) {
        Object parameter = getParameter(str);
        return parameter == null ? j : ((Long) parameter).longValue();
    }

    @Override
    public HttpParams setLongParameter(String str, long j) {
        setParameter(str, Long.valueOf(j));
        return this;
    }

    @Override
    public int getIntParameter(String str, int i) {
        Object parameter = getParameter(str);
        return parameter == null ? i : ((Integer) parameter).intValue();
    }

    @Override
    public HttpParams setIntParameter(String str, int i) {
        setParameter(str, Integer.valueOf(i));
        return this;
    }

    @Override
    public double getDoubleParameter(String str, double d) {
        Object parameter = getParameter(str);
        return parameter == null ? d : ((Double) parameter).doubleValue();
    }

    @Override
    public HttpParams setDoubleParameter(String str, double d) {
        setParameter(str, Double.valueOf(d));
        return this;
    }

    @Override
    public boolean getBooleanParameter(String str, boolean z) {
        Object parameter = getParameter(str);
        return parameter == null ? z : ((Boolean) parameter).booleanValue();
    }

    @Override
    public HttpParams setBooleanParameter(String str, boolean z) {
        setParameter(str, z ? Boolean.TRUE : Boolean.FALSE);
        return this;
    }

    @Override
    public boolean isParameterTrue(String str) {
        return getBooleanParameter(str, false);
    }

    @Override
    public boolean isParameterFalse(String str) {
        return !getBooleanParameter(str, false);
    }

    @Override
    public Set<String> getNames() {
        throw new UnsupportedOperationException();
    }
}
