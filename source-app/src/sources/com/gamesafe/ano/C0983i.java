package com.gamesafe.ano;

import com.facebook.appevents.AppEventsConstants;

class C0983i implements InterfaceC0981g.a {

    final C0982h f558a;

    C0983i(C0982h c0982h) {
        this.f558a = c0982h;
    }

    @Override
    public void mo874a(int i) {
        String str = this.f558a.f557c;
        if (this.f558a.f557c == null) {
            this.f558a.f557c = AppEventsConstants.EVENT_PARAM_VALUE_NO;
        }
        if (this.f558a.f556b != null) {
            this.f558a.f556b = null;
        }
        StringBuilder sb = new StringBuilder();
        sb.append(C0975a.m846a("hnb_wjs_ydnhdnn:ntn:"));
        sb.append(C0975a.m846a("|hnb_wjs_dy=") + str);
        sb.append(C0975a.m846a("|woi_dy=") + i);
        C0976b.m847a(sb.toString());
    }
}
