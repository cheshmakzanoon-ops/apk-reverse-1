local KingdomPositionApplyDeleteMessage = BaseClass("KingdomPositionApplyDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, positionId, uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("positionId", positionId)
  self.sfsObj:PutUtfString("uid", uid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      EventManager:GetInstance():Broadcast(EventId.KingdomPositionInfoUpdate)
      EventManager:GetInstance():Broadcast(EventId.OfficialApplyDownRefresh)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

KingdomPositionApplyDeleteMessage.OnCreate = OnCreate
KingdomPositionApplyDeleteMessage.HandleMessage = HandleMessage
return KingdomPositionApplyDeleteMessage
