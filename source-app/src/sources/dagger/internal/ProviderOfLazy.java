package dagger.internal;

import dagger.Lazy;

public final class ProviderOfLazy<T> implements Provider<Lazy<T>> {
    static final boolean $assertionsDisabled = false;
    private final Provider<T> provider;

    private ProviderOfLazy(Provider<T> provider) {
        this.provider = provider;
    }

    @Override
    public Lazy<T> get() {
        return DoubleCheck.lazy(this.provider);
    }

    public static <T> Provider<Lazy<T>> create(Provider<T> provider) {
        return new ProviderOfLazy((Provider) Preconditions.checkNotNull(provider));
    }

    @Deprecated
    public static <T> Provider<Lazy<T>> create(javax.inject.Provider<T> provider) {
        return create(Providers.asDaggerProvider(provider));
    }
}
