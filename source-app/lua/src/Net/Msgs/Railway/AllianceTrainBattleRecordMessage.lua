local AllianceTrainBattleRecordMessage = BaseClass("AllianceTrainBattleRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, trainUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("trainUuid", trainUuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainBattleRecordList, message)
end

AllianceTrainBattleRecordMessage.OnCreate = OnCreate
AllianceTrainBattleRecordMessage.HandleMessage = HandleMessage
return AllianceTrainBattleRecordMessage
