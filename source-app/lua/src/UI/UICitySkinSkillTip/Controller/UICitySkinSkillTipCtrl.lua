local UICitySkinSkillTipCtrl = BaseClass("UICitySkinSkillTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICitySkinSkillTip, {anim = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end

UICitySkinSkillTipCtrl.CloseSelf = CloseSelf
UICitySkinSkillTipCtrl.Close = Close
return UICitySkinSkillTipCtrl
