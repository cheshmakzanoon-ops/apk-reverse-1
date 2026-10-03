local LWChatAICharacterTemplate = BaseClass("LWChatAICharacterTemplate")
local Localization = CS.GameEntry.Localization

function LWChatAICharacterTemplate:__init()
  self.id = 0
  self.name = ""
  self.desc = ""
  self.icon1 = ""
  self.icon2 = ""
  self.image = ""
  self.chat_bg = ""
end

function LWChatAICharacterTemplate:__delete()
  self.id = nil
  self.name = nil
  self.desc = nil
  self.icon1 = nil
  self.icon2 = nil
  self.image = nil
  self.chat_bg = nil
  self.imageShort = nil
  self.imageLong = nil
end

function LWChatAICharacterTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id")
  self.name = row:getValue("name") or ""
  self.desc = row:getValue("desc") or ""
  self.icon1 = row:getValue("icon1") or ""
  self.icon2 = row:getValue("icon2") or ""
  self.image = row:getValue("image") or ""
  self.chat_bg = row:getValue("chat_bg") or ""
  self.imageShort = self.image
  self.imageLong = self.image
  if string.find(self.image, "%|") ~= nil then
    local subList = string.split(tostring(self.image), "|")
    if 2 <= #subList then
      self.imageShort = subList[1]
      self.imageLong = subList[2] == "" and subList[1] or subList[2]
    end
  end
end

function LWChatAICharacterTemplate:GetHeadIconPath()
  return string.format("Assets/Main/Sprites/UI/UIChatAI/%s.png", self.icon1)
end

function LWChatAICharacterTemplate:GetRoomIconPath()
  return string.format("Assets/Main/Sprites/UI/UIChatAI/%s.png", self.icon2)
end

function LWChatAICharacterTemplate:GetMessageSmallIconPath()
  return string.format("Assets/Main/Sprites/UI/UIChatAI/%s.png", self.imageShort)
end

function LWChatAICharacterTemplate:GetMessageBigIconPath()
  return string.format("Assets/Main/Sprites/UI/UIChatAI/%s.png", self.imageLong)
end

function LWChatAICharacterTemplate:GetMessageBgPath()
  return string.format("Assets/Main/Sprites/UI/UIChatAI/%s.png", self.chat_bg)
end

function LWChatAICharacterTemplate:GetMessageBg()
  return self.chat_bg
end

function LWChatAICharacterTemplate:GetName()
  return Localization:GetString(self.name)
end

return LWChatAICharacterTemplate
