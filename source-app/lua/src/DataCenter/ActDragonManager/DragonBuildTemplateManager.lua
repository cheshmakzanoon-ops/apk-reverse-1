local DragonBuildTemplateManager = BaseClass("DragonBuildTemplateManager", BattlefieldTemplateMgrBase)
local DesertBuildingType = {
  Idle = 1,
  Strongest_Eight = 2,
  Strongest_Four = 3,
  Strongest_Two = 4,
  Strongest_King = 5,
  Lock = 6
}
local DesertHospitalBuildingType = {
  HospitalBuilding1 = 10050,
  HospitalBuilding2 = 10060,
  HospitalBuilding3 = 10070,
  HospitalBuilding4 = 10080
}

function DragonBuildTemplateManager:OnInit()
  self.bfType = BattleFieldType.Desert
end

function DragonBuildTemplateManager:GetDragonMiniMapSpritePath(detailInfo, bSp)
  if not detailInfo then
    return ""
  end
  local buildId = detailInfo.BuildId or detailInfo.ItemId
  local config = self:GetTemplate(buildId)
  if config == nil then
    return ""
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local myAllianceId = LuaEntry.Player.allianceId
  local sprite_status = DesertBuildingType.Lock
  if string.IsNullOrEmpty(config.coordinate) then
    sprite_status = 1
  elseif detailInfo.State == 0 then
    if curTime < detailInfo.OpenTime then
      sprite_status = DesertBuildingType.Lock
    else
      sprite_status = DesertBuildingType.Idle
    end
  elseif detailInfo.State == 3 then
    if detailInfo.AllianceId == myAllianceId then
      sprite_status = DesertBuildingType.Strongest_Four
    else
      sprite_status = DesertBuildingType.Strongest_Eight
    end
  elseif detailInfo.AllianceId == myAllianceId then
    sprite_status = DesertBuildingType.Strongest_King
  else
    sprite_status = DesertBuildingType.Strongest_Two
  end
  return self:GetDragonMiniMapSpritePathByStatus(buildId, sprite_status)
end

function DragonBuildTemplateManager:GetDragonMiniMapSpritePathByStatus(buildId, status)
  local config = self:GetTemplate(buildId)
  if config == nil then
    return ""
  end
  local sprite_path = string.format(LoadPath.LWBattleFieldPath, config.small_map_icon .. status)
  return sprite_path
end

function DragonBuildTemplateManager:MyOccupyingHospitalBuilding(detailInfo)
  if not detailInfo then
    return false
  end
  local buildId = detailInfo.BuildId or detailInfo.ItemId
  local myAllianceId = LuaEntry.Player.allianceId
  if detailInfo.State == 1 and self:IsHospitalBuilding(buildId) and detailInfo.AllianceId == myAllianceId then
    return true
  end
  return false
end

function DragonBuildTemplateManager:IsHospitalBuilding(buildId)
  if buildId == DesertHospitalBuildingType.HospitalBuilding1 or buildId == DesertHospitalBuildingType.HospitalBuilding2 or buildId == DesertHospitalBuildingType.HospitalBuilding3 or buildId == DesertHospitalBuildingType.HospitalBuilding4 then
    return true
  end
  return false
end

function DragonBuildTemplateManager:GetItemValue(key, default, bStr)
  local config = "dragon_war"
  if bStr then
    return LuaEntry.DataConfig:TryGetStr(config, key, default)
  end
  return LuaEntry.DataConfig:TryGetNum(config, key, default)
end

return DragonBuildTemplateManager
