local LWUIMasterySkillUseInWorldCtrl = BaseClass("LWUIMasterySkillUseInWorldCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasterySkillUseInWorld, {anim = useAnimation})
end

LWUIMasterySkillUseInWorldCtrl.CloseSelf = CloseSelf
return LWUIMasterySkillUseInWorldCtrl
