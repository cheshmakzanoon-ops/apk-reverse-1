package net.aihelp.core.util.bus;

interface Poster {
    void enqueue(Subscription subscription, Object obj);
}
