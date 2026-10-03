local UIHeroPVEFormationPanelCtrl = BaseClass("UIHeroPVEFormationPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPVEFormation)
end

UIHeroPVEFormationPanelCtrl.CloseSelf = CloseSelf
return UIHeroPVEFormationPanelCtrl
