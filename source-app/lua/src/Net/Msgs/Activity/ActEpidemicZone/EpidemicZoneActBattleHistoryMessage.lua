local EpidemicZoneActBattleHistoryMessage = BaseClass("EpidemicZoneActBattleHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, time)
  base.OnCreate(self)
  self.sfsObj:PutLong("time", time)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleActivityBattleHistory(t)
end

EpidemicZoneActBattleHistoryMessage.OnCreate = OnCreate
EpidemicZoneActBattleHistoryMessage.HandleMessage = HandleMessage
return EpidemicZoneActBattleHistoryMessage
