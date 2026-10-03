local PushKingdomPositionApplyTimeMessage = BaseClass("PushKingdomPositionApplyTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.OfficialApplyManager:RefreshOwnApplyTime(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

PushKingdomPositionApplyTimeMessage.OnCreate = OnCreate
PushKingdomPositionApplyTimeMessage.HandleMessage = HandleMessage
return PushKingdomPositionApplyTimeMessage
