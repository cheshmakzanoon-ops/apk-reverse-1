local GaleArenaRewardPreViewMessage = BaseClass("GaleArenaRewardPreViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.NewGaleArenaManager:NewArenaRewardPreViewHandler(t)
      EventManager:GetInstance():Broadcast(EventId.NewGaleArenaGetRewardPreview)
    else
      EventManager:GetInstance():Broadcast(EventId.NewGaleArenaGetMessageError)
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GaleArenaRewardPreViewMessage.OnCreate = OnCreate
GaleArenaRewardPreViewMessage.HandleMessage = HandleMessage
return GaleArenaRewardPreViewMessage
