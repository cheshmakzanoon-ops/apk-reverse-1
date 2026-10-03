local NewArenaRewardPreViewMessage = BaseClass("NewArenaRewardPreViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.NewPeakArenaManager:NewArenaRewardPreViewHandler(t)
      EventManager:GetInstance():Broadcast(EventId.NewPeakArenaGetRewardPreview)
    else
      EventManager:GetInstance():Broadcast(EventId.NewPeakArenaGetMessageError)
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

NewArenaRewardPreViewMessage.OnCreate = OnCreate
NewArenaRewardPreViewMessage.HandleMessage = HandleMessage
return NewArenaRewardPreViewMessage
