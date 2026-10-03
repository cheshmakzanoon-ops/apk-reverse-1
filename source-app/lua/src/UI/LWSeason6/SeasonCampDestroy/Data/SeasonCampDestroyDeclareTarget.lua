local SeasonCampDestroyDeclareTarget = BaseClass("SeasonCampDestroyDeclareTarget")

function SeasonCampDestroyDeclareTarget:__init()
  self.cityId = 0
  self.pointId = 0
  self.serverId = 0
  self.defenderAllianceId = ""
  self.attackerAllianceId = ""
  self.startTime = 0
  self.endTime = 0
  self.result = 0
  self.firstReward = false
  self.durability = 0
  self.lastDurabilityTime = 0
  self.atk = nil
  self.def = nil
end

function SeasonCampDestroyDeclareTarget:Update(info)
  if not info then
    return
  end
  self.cityId = info.cityId or 0
  self.pointId = info.pointId or 0
  self.serverId = info.serverId or 0
  self.defenderAllianceId = info.defenderAllianceId or ""
  self.attackerAllianceId = info.attackerAllianceId or ""
  self.startTime = info.startTime or 0
  self.endTime = info.endTime or 0
  self.result = info.result or 0
  self.firstReward = info.firstReward or false
  self.durability = info.durability or 0
  self.lastDurabilityTime = info.lastDurabilityTime or 0
  self.atk = info.atk
  self.def = info.def
  if self.atk then
    self.atk.allianceId = self.atk.allianceId or self.atk.aid
  end
  if self.def then
    self.def.allianceId = self.def.allianceId or self.def.aid
  end
end

function SeasonCampDestroyDeclareTarget:Description()
  local atkName = self.atk and self.atk.name or "N/A"
  local defName = self.def and self.def.name or "N/A"
  local timeMgr = UITimeManager:GetInstance()
  local endTimeStr = timeMgr:TimeStampToTimeForLocal(self.endTime)
  return string.format("City:%s Server:%s Result:%s End:%s Atk:%s Def:%s", self.cityId, self.serverId, self.result, endTimeStr, atkName, defName)
end

return SeasonCampDestroyDeclareTarget
