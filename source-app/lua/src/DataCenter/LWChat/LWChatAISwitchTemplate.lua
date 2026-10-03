local LWChatAISwitchTemplate = BaseClass("LWChatAISwitchTemplate")
local Localization = CS.GameEntry.Localization

function LWChatAISwitchTemplate:__init()
  self.id = 0
  self.switch_type = ""
  self.switch_title = ""
  self.switch_des = ""
end

function LWChatAISwitchTemplate:__delete()
  self.id = nil
  self.switch_type = nil
  self.switch_title = nil
  self.switch_des = nil
end

function LWChatAISwitchTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id")
  self.switch_type = row:getIntValue("switch_type")
  self.switch_title = row:getValue("switch_title") or ""
  self.switch_des = row:getValue("switch_des") or ""
end

function LWChatAISwitchTemplate:GetTitle()
  return Localization:GetString(self.switch_title)
end

function LWChatAISwitchTemplate:GetDetail()
  return Localization:GetString(self.switch_des)
end

function LWChatAISwitchTemplate:GetType()
  return self.switch_type
end

return LWChatAISwitchTemplate
