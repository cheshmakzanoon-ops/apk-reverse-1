local ChampionDuelBattleLogInfoMessage = BaseClass("ChampionDuelBattleLogInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local MailInfo = require("DataCenter.MailData.MailInfo")

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local mailInfo = MailInfo.New()
  mailInfo:ParseBaseData(t)
  mailInfo.type = MailType.NEW_FIGHT
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelLogInfoRefresh, mailInfo)
end

ChampionDuelBattleLogInfoMessage.OnCreate = OnCreate
ChampionDuelBattleLogInfoMessage.HandleMessage = HandleMessage
return ChampionDuelBattleLogInfoMessage
