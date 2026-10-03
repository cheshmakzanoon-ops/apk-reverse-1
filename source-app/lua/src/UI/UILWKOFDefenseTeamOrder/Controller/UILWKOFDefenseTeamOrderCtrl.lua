local UILWKOFDefenseTeamOrderCtrl = BaseClass("UILWKOFDefenseTeamOrderCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWKOFDefenseTeamOrder)
end

UILWKOFDefenseTeamOrderCtrl.CloseSelf = CloseSelf
return UILWKOFDefenseTeamOrderCtrl
