local PushAllianceJoinMessage = BaseClass("PushAllianceJoinMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassStage)
  DataCenter.AllyDrillDataManager:RecMsgPushAllianceJoin(t)
  DataCenter.LWAllyStationDataManager:RecMsgPushAllianceJoin(t)
end

PushAllianceJoinMessage.OnCreate = OnCreate
PushAllianceJoinMessage.HandleMessage = HandleMessage
return PushAllianceJoinMessage
