local NewArenaPromoteMessage = BaseClass("NewArenaPromoteMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      SFSNetwork.SendMessage(MsgDefines.GetPVPArenaInfo)
    else
      EventManager:GetInstance():Broadcast(EventId.NewPeakArenaGetMessageError)
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

NewArenaPromoteMessage.OnCreate = OnCreate
NewArenaPromoteMessage.HandleMessage = HandleMessage
return NewArenaPromoteMessage
