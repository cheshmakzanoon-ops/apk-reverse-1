package net.aihelp.core.p004ui.glide.manager;

import java.util.Collections;
import java.util.Set;
import net.aihelp.core.p004ui.glide.RequestManager;

final class EmptyRequestManagerTreeNode implements RequestManagerTreeNode {
    EmptyRequestManagerTreeNode() {
    }

    @Override
    public Set<RequestManager> getDescendants() {
        return Collections.emptySet();
    }
}
