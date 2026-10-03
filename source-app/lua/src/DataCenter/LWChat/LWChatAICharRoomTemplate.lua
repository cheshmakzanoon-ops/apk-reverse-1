local LWChatAICharRoomTemplate = BaseClass("LWChatAICharRoomTemplate")
local Localization = CS.GameEntry.Localization

function LWChatAICharRoomTemplate:__init()
  self.id = nil
  self.group = 1
  self.character_id = 0
  self.action_type = 0
  self.action_type_para = 0
  self.send_msg = ""
  self.emo_on = 0
  self.need_user = 0
  self.switch_id = 0
end

function LWChatAICharRoomTemplate:__delete()
  self.id = nil
  self.group = nil
  self.character_id = nil
  self.action_type = nil
  self.emo_on = nil
  self.need_user = nil
  self.switch_id = nil
end

function LWChatAICharRoomTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id")
  self.group = row:getIntValue("group")
  self.character_id = row:getIntValue("character_id")
  self.action_type = row:getIntValue("action_type")
  self.emo_on = row:getIntValue("emo_on")
  self.need_user = row:getIntValue("need_user")
  self.switch_id = row:getValue("switch_id")
  self.jump_ui_name = row:getValue("jump_ui_name")
  if self.jump_ui_name == nil or self.jump_ui_name == "" then
    self.jump_ui_name = nil
    self.jump_ui_para = nil
    self.jump_tips = nil
  else
    self.jump_ui_para = row:getValue("jump_ui_para")
    self.jump_tips = row:getValue("jump_tips")
  end
end

function LWChatAICharRoomTemplate:GetGroup()
  return self.group
end

function LWChatAICharRoomTemplate:GetCharacterId()
  return self.character_id
end

function LWChatAICharRoomTemplate:GetActionType()
  return self.action_type
end

function LWChatAICharRoomTemplate:IsEmojiOn()
  return self.emo_on == 1
end

function LWChatAICharRoomTemplate:GetSwitchId()
  return self.switch_id
end

function LWChatAICharRoomTemplate:SwitchOn()
  if self.switch_id == nil or self.switch_id == "" then
    return true
  end
  if self.switch_id:find("|") ~= nil then
    local arr = string.split(self.switch_id, "|")
    for _, v in ipairs(arr) do
      local config = DataCenter.LWChatAIManager:GetSwitchRecvById(v)
      if config ~= nil and not Setting:GetBool("ai.chat.push." .. v, true) then
        return false
      end
    end
    return true
  end
  return Setting:GetBool("ai.chat.push." .. self.switch_id, true)
end

function LWChatAICharRoomTemplate:SetCharacterData(value)
  self.theCharacterData = value
end

function LWChatAICharRoomTemplate:GetCharacterData()
  return self.theCharacterData
end

return LWChatAICharRoomTemplate
