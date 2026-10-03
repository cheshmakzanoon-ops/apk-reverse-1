local LWSeasonServerGroupCtrl = BaseClass("LWSeasonServerGroupCtrl", UIBaseCtrl)

function LWSeasonServerGroupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonServerGroup)
end

return LWSeasonServerGroupCtrl
