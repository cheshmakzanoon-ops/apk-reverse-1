package dagger.internal;

public final class Providers {
    public static <T> Provider<T> asDaggerProvider(final javax.inject.Provider<T> provider) {
        Preconditions.checkNotNull(provider);
        return new Provider<T>() {
            @Override
            public T get() {
                return (T) provider.get();
            }
        };
    }

    private Providers() {
    }
}
