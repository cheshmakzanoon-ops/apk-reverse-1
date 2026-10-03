local LWUIMasterySkillUseCtrl = BaseClass("LWUIMasterySkillUseCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasterySkillUse, {anim = useAnimation})
end

LWUIMasterySkillUseCtrl.CloseSelf = CloseSelf
return LWUIMasterySkillUseCtrl
