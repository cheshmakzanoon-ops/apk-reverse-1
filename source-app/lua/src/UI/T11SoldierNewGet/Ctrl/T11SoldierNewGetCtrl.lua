local T11SoldierNewGetCtrl = BaseClass("T11SoldierNewGetCtrl", UIBaseCtrl)

function T11SoldierNewGetCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.T11SoldierNewGet)
end

return T11SoldierNewGetCtrl
