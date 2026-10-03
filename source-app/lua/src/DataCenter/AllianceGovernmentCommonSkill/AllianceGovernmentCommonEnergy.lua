local AllianceGovernmentCommonEnergy = BaseClass("AllianceGovernmentCommonEnergy")

function AllianceGovernmentCommonEnergy:__init()
  self.currentEnergy = 0
  self.energyCap = 0
  self.donateInfo = nil
  self.syncServer = false
  self.energyItem = {id = 32002, type = 23}
end

function AllianceGovernmentCommonEnergy:__delete()
  self.currentEnergy = nil
  self.energyCap = nil
  self.donateInfo = nil
  self.syncServer = nil
  self.energyItem = nil
end

function AllianceGovernmentCommonEnergy:ParseServer(message)
  self.currentEnergy = message.currentEnergy or 0
  self.energyCap = message.energyCap or 0
  self.donateInfo = message.donateInfo
  self.syncServer = true
  EventManager:GetInstance():Broadcast(EventId.UpdateAllianceGovernmentCommonEnergyList)
end

function AllianceGovernmentCommonEnergy:IsSyncServer()
  return self.syncServer
end

function AllianceGovernmentCommonEnergy:GetCoverCountTime()
  return LuaEntry.DataConfig:TryGetNum("season_s6_alliance_skill_fish", "k1")
end

function AllianceGovernmentCommonEnergy:GetMaxDonateCount()
  return LuaEntry.DataConfig:TryGetNum("season_s6_alliance_skill_fish", "k2")
end

function AllianceGovernmentCommonEnergy:GetMaxEnergy()
  if self.energyCap ~= 0 then
    return self.energyCap
  end
  return LuaEntry.DataConfig:TryGetNum("season_s6_alliance_skill_fish", "k3")
end

function AllianceGovernmentCommonEnergy:IsMaxEnergy()
  return self.currentEnergy >= self:GetMaxEnergy()
end

function AllianceGovernmentCommonEnergy:GetDonateInfo()
  return self.donateInfo
end

function AllianceGovernmentCommonEnergy:GetCostIcon()
  return "Assets/Main/SeasonRes/S6/Sprites/AllianceSkill/FX_S6_lianmengjineng_nengliang.png"
end

return AllianceGovernmentCommonEnergy
