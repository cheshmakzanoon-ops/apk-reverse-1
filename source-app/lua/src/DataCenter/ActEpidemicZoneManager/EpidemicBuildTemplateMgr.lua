local EpidemicBuildTemplateMgr = BaseClass("EpidemicBuildTemplateMgr", BattlefieldTemplateMgrBase)
local SCORE_BUILD_ICON = "zyf_jianzhuzhandouzhuangtai_jifen_icon.png"
local RES_BUILD_ICON = "zyf_xgfb_xiaoditu_icon25.png"
local BUILD_RES_ID = 10701
EpidemicBuildTemplateMgr.BUILD_RES_ID = BUILD_RES_ID
local BUILD_SCORE_ID = 10801
EpidemicBuildTemplateMgr.BUILD_SCORE_ID = BUILD_SCORE_ID

function EpidemicBuildTemplateMgr:OnInit()
  self.bfType = BattleFieldType.EpidemicZone
end

function EpidemicBuildTemplateMgr:GetMiniState(role, state, openTime)
  local myRole = DataCenter.ActEpidemicZoneManager:GetCurRole()
  local sprite_status = BattleFieldMiniState.Normal
  if state == 1 and openTime ~= nil and openTime > UITimeManager:GetInstance():GetServerSeconds() then
    sprite_status = BattleFieldMiniState.Fixing
  elseif state == 2 then
    sprite_status = role ~= myRole and BattleFieldMiniState.Occupied_Red or BattleFieldMiniState.Occupied_Blue
  end
  return sprite_status
end

function EpidemicBuildTemplateMgr:GetMiniMapSpritePath(detailInfo, bSp)
  if detailInfo == nil then
    return "", BattleFieldMiniState.Normal
  end
  return self:GetMiniMapSpritePathByBuildId(detailInfo.BuildId, detailInfo.Role, detailInfo.State, detailInfo.OpenTime, bSp)
end

function EpidemicBuildTemplateMgr:GetMiniMapSpritePathByBuildId(buildId, role, state, openTime, bSp)
  local config = DataCenter.EpidemicBuildTemplateMgr:GetTemplate(buildId)
  if config == nil then
    return "", BattleFieldMiniState.Normal
  end
  local sprite_status = self:GetMiniState(role, state, openTime)
  if bSp then
    if self:IsScoreBox(buildId) then
      return string.format(LoadPath.LWCommonPath, SCORE_BUILD_ICON), sprite_status
    elseif self:IsRes(buildId) then
      return string.format(LoadPath.LWBattleFieldPath, RES_BUILD_ICON), sprite_status
    end
  end
  local path = ""
  local MyStrEnd = string.endswith
  if MyStrEnd(config.small_map_icon, "_") then
    path = config.small_map_icon .. sprite_status
  else
    path = config.small_map_icon
  end
  local MyStrStart = string.startswith
  if MyStrStart(path, "Assets") then
    return path, sprite_status
  end
  if MyStrStart(path, "mjc_ybjq_") then
    return string.format(LoadPath.LWBattleFieldEpidemicDetailPath, path), sprite_status
  end
  return string.format(LoadPath.LWBattleFieldPath, path), sprite_status
end

function EpidemicBuildTemplateMgr:CheckType(buildId, checkType)
  local template = self:GetTemplate(buildId)
  return template ~= nil and template.type == checkType
end

function EpidemicBuildTemplateMgr:IsScoreBox(buildId)
  return self:CheckType(buildId, BattleFieldBuildType.SCORE)
end

function EpidemicBuildTemplateMgr:IsRes(buildId)
  return self:CheckType(buildId, BattleFieldBuildType.RES)
end

function EpidemicBuildTemplateMgr:IsPowerTower(buildId)
  return self:CheckType(buildId, BattleFieldBuildType.POWER)
end

function EpidemicBuildTemplateMgr:IsDefence(buildId)
  return self:CheckType(buildId, BattleFieldBuildType.DEFENCE)
end

function EpidemicBuildTemplateMgr:IsBuff(buildId)
  return self:CheckType(buildId, BattleFieldBuildType.BUFF)
end

function EpidemicBuildTemplateMgr:IsBuild(buildId)
  local template = self:GetTemplate(buildId)
  return template ~= nil and template.type ~= BattleFieldBuildType.SCORE and template.type ~= BattleFieldBuildType.RES
end

function EpidemicBuildTemplateMgr:GetResBuildTemplate()
  return self:GetTemplate(BUILD_RES_ID)
end

function EpidemicBuildTemplateMgr:GetGatherResourceId()
  local template = self:GetTemplate(BUILD_RES_ID)
  local grId = template.special_effect_number
  return grId
end

function EpidemicBuildTemplateMgr:GetGatherResourceType()
  local grId = self:GetGatherResourceId()
  local type = GetTableData(TableName.GatherResource, grId, "resource_type")
  return type
end

return EpidemicBuildTemplateMgr
