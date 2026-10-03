local EpidemicZoneActChangeBattleTimeMessage = BaseClass("EpidemicZoneActChangeBattleTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group, battlePeriod)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("battlePeriod", battlePeriod)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleActChangeBattleTimeMessage(t)
end

EpidemicZoneActChangeBattleTimeMessage.OnCreate = OnCreate
EpidemicZoneActChangeBattleTimeMessage.HandleMessage = HandleMessage
return EpidemicZoneActChangeBattleTimeMessage
