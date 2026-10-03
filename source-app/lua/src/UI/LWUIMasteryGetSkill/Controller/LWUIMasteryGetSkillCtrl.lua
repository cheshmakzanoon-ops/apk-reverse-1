local LWUIMasteryGetSkillCtrl = BaseClass("LWUIMasteryGetSkillCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasteryGetSkill, {anim = useAnimation})
end

LWUIMasteryGetSkillCtrl.CloseSelf = CloseSelf
return LWUIMasteryGetSkillCtrl
