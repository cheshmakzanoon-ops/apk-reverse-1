local EpidemicZoneBattleFreeSpeedMarchMessage = BaseClass("EpidemicZoneBattleFreeSpeedMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneBattleFreeSpeedMarchMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function EpidemicZoneBattleFreeSpeedMarchMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleFreeSpeed(t)
end

return EpidemicZoneBattleFreeSpeedMarchMessage
