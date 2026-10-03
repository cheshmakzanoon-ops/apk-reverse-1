local ChatSoundManager = BaseClass("ChatSoundManager")

function ChatSoundManager:__init()
  self:AddListeners()
end

function ChatSoundManager:__delete()
  self:RemoveListeners()
end

function ChatSoundManager:AddListeners()
  EventManager:GetInstance():AddListener(EventId.CHAT_ONPUSH_MENTION, self.OnAtMessage)
end

function ChatSoundManager:RemoveListeners()
  EventManager:GetInstance():RemoveListener(EventId.CHAT_ONPUSH_MENTION, self.OnAtMessage)
end

function ChatSoundManager:OnAtMessage()
  local soundId = LuaEntry.DataConfig:TryGetNum("chat_sound", "k1")
  if soundId then
    DataCenter.LWSoundManager:PlaySound(soundId, false)
  end
end

return ChatSoundManager
