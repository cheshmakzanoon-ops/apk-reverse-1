local IChatItemPost = BaseClass("IChatItemPost", UIBaseContainer)
local base = UIBaseContainer

function IChatItemPost:OnCreate()
  base.OnCreate(self)
  self.chatItemPostLayoutCS = self.gameObject:GetComponentInChildren(typeof(CS.ChatItemPostLayout))
  self.hideTranslation = false
end

function IChatItemPost:Loaded(frame)
  self.frame = frame
end

function IChatItemPost:Recycle()
  self.frame = nil
end

function IChatItemPost:ChatData()
  if self.frame ~= nil then
    return self.frame._chatData
  end
  return nil
end

function IChatItemPost:UpdateContent()
end

function IChatItemPost:OnLoaded()
end

function IChatItemPost:OnRecycle()
end

function IChatItemPost:UpdateSize()
  if self.chatItemPostLayoutCS == nil then
    return
  end
  self.frame:RefreshItemSize()
end

function IChatItemPost:HandleClick()
  return false
end

function IChatItemPost:HandleLongPress()
  return false
end

function IChatItemPost:HandleChatHeadLongPress()
  return false
end

return IChatItemPost
