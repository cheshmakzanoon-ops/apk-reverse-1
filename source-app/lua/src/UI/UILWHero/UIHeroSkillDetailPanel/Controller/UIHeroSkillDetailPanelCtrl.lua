local UIHeroSkillDetailPanelCtrl = BaseClass("UIHeroSkillDetailPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroSkillDetailPanel)
end

UIHeroSkillDetailPanelCtrl.CloseSelf = CloseSelf
return UIHeroSkillDetailPanelCtrl
