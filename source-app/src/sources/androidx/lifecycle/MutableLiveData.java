package androidx.lifecycle;

public class MutableLiveData<T> extends LiveData<T> {
    public MutableLiveData(T t) {
        super(t);
    }

    public MutableLiveData() {
    }

    @Override
    public void postValue(T t) {
        super.postValue(t);
    }

    @Override
    public void setValue(T t) {
        super.setValue(t);
    }
}
