local UIHeroFakePVPFormationPanelCtrl = BaseClass("UIHeroFakePVPFormationPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation)
end

UIHeroFakePVPFormationPanelCtrl.CloseSelf = CloseSelf
return UIHeroFakePVPFormationPanelCtrl
