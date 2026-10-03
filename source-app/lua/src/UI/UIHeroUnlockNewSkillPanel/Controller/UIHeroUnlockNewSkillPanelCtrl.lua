local UIHeroUnlockNewSkillPanelCtrl = BaseClass("UIHeroUnlockNewSkillPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroUnlockNewSkillPanel)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

UIHeroUnlockNewSkillPanelCtrl.CloseSelf = CloseSelf
UIHeroUnlockNewSkillPanelCtrl.Close = Close
return UIHeroUnlockNewSkillPanelCtrl
