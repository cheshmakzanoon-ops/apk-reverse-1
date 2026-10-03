local LWUIMasterySkillDetailCtrl = BaseClass("LWUIMasterySkillDetailCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasterySkillDetail, {anim = useAnimation})
end

LWUIMasterySkillDetailCtrl.CloseSelf = CloseSelf
return LWUIMasterySkillDetailCtrl
