local LWChatAIFaqTemplate = BaseClass("LWChatAIFaqTemplate")
local Localization = CS.GameEntry.Localization

function LWChatAIFaqTemplate:__init()
end

function LWChatAIFaqTemplate:__delete()
  self.ui_key = nil
  self.ui_name = nil
  self.ui_para = nil
  self.error_tips = nil
  self.switch_on = nil
end

function LWChatAIFaqTemplate:InitData(ui_key, ui_name, ui_para, error_tips, switch_on)
  self.ui_key = ui_key
  self.ui_name = ui_name
  self.ui_para = ui_para
  self.error_tips = error_tips
  self.switch_on = switch_on
end

function LWChatAIFaqTemplate:CanUse()
  return self.switch_on
end

function LWChatAIFaqTemplate:GetUIName()
  return self.ui_name
end

function LWChatAIFaqTemplate:GetKey()
  return Localization:GetString(self.ui_key)
end

function LWChatAIFaqTemplate:OpenUI()
  return DataCenter.LWChatAIManager:DoJump(self.ui_name, self.ui_para, self.error_tips)
end

return LWChatAIFaqTemplate
