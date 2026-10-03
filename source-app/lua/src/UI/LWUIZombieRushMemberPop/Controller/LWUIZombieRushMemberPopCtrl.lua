local LWUIZombieRushMemberPopCtrl = BaseClass("LWUIZombieRushMemberPopCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIZombieRushMemberPopCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIZombieRushMemberPop)
end

return LWUIZombieRushMemberPopCtrl
