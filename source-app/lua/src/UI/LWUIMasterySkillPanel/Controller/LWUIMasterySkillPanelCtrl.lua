local LWUIMasterySkillPanelCtrl = BaseClass("LWUIMasterySkillPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasterySkillPanel)
end

LWUIMasterySkillPanelCtrl.CloseSelf = CloseSelf
return LWUIMasterySkillPanelCtrl
