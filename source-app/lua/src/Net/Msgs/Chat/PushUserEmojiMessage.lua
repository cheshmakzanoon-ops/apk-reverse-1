local PushUserEmojiMessage = BaseClass("PushUserEmojiMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ChatEmojiTemplateManager:SetEmojiShowList(t.emoji or {})
end

PushUserEmojiMessage.HandleMessage = HandleMessage
return PushUserEmojiMessage
