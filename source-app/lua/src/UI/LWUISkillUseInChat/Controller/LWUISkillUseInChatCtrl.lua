local LWUISkillUseInChatCtrl = BaseClass("LWUISkillUseInChatCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISkillUseInChat, {anim = useAnimation})
end

LWUISkillUseInChatCtrl.CloseSelf = CloseSelf
return LWUISkillUseInChatCtrl
