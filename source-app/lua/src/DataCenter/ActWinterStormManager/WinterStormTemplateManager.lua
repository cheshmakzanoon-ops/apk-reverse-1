local WinterStormTemplateManager = BaseClass("WinterStormTemplateManager", BattlefieldTemplateMgrBase)
local MyStrEnd = string.endswith

function WinterStormTemplateManager:OnInit()
  self.bfType = BattleFieldType.WinterStorm
  self.dataK30 = nil
end

function WinterStormTemplateManager:OnDelete()
  self.dataK30 = nil
end

function WinterStormTemplateManager:GetK30()
  if self.dataK30 == nil then
    local groups = LuaEntry.DataConfig:TryGetStr("winter_battlefield", "k30")
    self.dataK30 = string.string2array_i_oneSep(groups, ";")
  end
  return self.dataK30
end

function WinterStormTemplateManager:GetCenterType()
  return 205
end

function WinterStormTemplateManager:GetMiniState(side, state)
  local mySide = DataCenter.ActWinterStormManager:GetMySide()
  local sprite_status = BattleFieldMiniState.Normal
  if state == WinterEntityState.Fixing then
    sprite_status = BattleFieldMiniState.Fixing
  elseif state == WinterEntityState.Occupying then
    sprite_status = side ~= mySide and BattleFieldMiniState.Occupying_Red or BattleFieldMiniState.Occupying_Blue
  elseif state == WinterEntityState.Occupied then
    sprite_status = side ~= mySide and BattleFieldMiniState.Occupied_Red or BattleFieldMiniState.Occupied_Blue
  elseif state == WinterEntityState.Waiting and side ~= 0 then
    sprite_status = side ~= mySide and BattleFieldMiniState.Occupying_Red or BattleFieldMiniState.Occupying_Blue
  end
  return sprite_status
end

function WinterStormTemplateManager:GetWinterEntityMiniMapSpritePath(detailInfo, bSp)
  if detailInfo == nil then
    return "", BattleFieldMiniState.Normal
  end
  return self:GetWinterEntityMiniMapSpritePathByBuildId(detailInfo.BuildId, detailInfo.Side, detailInfo.State)
end

function WinterStormTemplateManager:GetWinterEntityMiniMapSpritePathByBuildId(buildId, side, state)
  local config = DataCenter.WinterStormTemplateManager:GetTemplate(buildId)
  if config == nil then
    return "", BattleFieldMiniState.Normal
  end
  local sprite_status = self:GetMiniState(side, state)
  local path = ""
  if MyStrEnd(config.small_map_icon, "_") then
    path = string.format(LoadPath.LWBattleFieldPath, config.small_map_icon .. sprite_status)
  else
    path = string.format(LoadPath.LWBattleFieldPath, config.small_map_icon)
  end
  return path, sprite_status
end

return WinterStormTemplateManager
