local AllianceTrainKOFBattleDetailMessage = BaseClass("AllianceTrainKOFBattleDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainKOFBattleRecordDetail, message)
end

AllianceTrainKOFBattleDetailMessage.OnCreate = OnCreate
AllianceTrainKOFBattleDetailMessage.HandleMessage = HandleMessage
return AllianceTrainKOFBattleDetailMessage
