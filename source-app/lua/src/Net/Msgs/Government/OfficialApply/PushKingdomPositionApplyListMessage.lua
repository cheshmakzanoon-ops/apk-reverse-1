local PushKingdomPositionApplyListMessage = BaseClass("PushKingdomPositionApplyListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.OfficialApplyManager:RefreshApplyList(t)
      EventManager:GetInstance():Broadcast(EventId.OfficialApplyDownRefresh)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

PushKingdomPositionApplyListMessage.OnCreate = OnCreate
PushKingdomPositionApplyListMessage.HandleMessage = HandleMessage
return PushKingdomPositionApplyListMessage
