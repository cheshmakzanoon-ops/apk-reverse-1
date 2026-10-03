local KingdomPositionHistoryListMessage = BaseClass("KingdomPositionHistoryListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, positionId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("positionId", positionId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.OfficialApplyManager:InitAppointsLogList(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

KingdomPositionHistoryListMessage.OnCreate = OnCreate
KingdomPositionHistoryListMessage.HandleMessage = HandleMessage
return KingdomPositionHistoryListMessage
