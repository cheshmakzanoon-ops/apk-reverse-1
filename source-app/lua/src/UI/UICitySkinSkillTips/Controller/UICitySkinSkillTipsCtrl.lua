local UICitySkinSkillTipsCtrl = BaseClass("UICitySkinSkillTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICitySkinSkillTips)
end

UICitySkinSkillTipsCtrl.CloseSelf = CloseSelf
return UICitySkinSkillTipsCtrl
