local MonopolyPlacealityData = BaseClass("MonopolyPlacealityData")

function MonopolyPlacealityData:__init()
  self.eventType = MonopolyEventType.Parkour
  self.state = MonopolyPlacealityType.ArrivalBefore
end

function MonopolyPlacealityData:__delete()
end

function MonopolyPlacealityData:InitByTemplate(template)
  self.id = tonumber(template.id)
  self.prefabName = template.prefabName or ""
  self.pos = template.pos or {x = 0, y = 0}
  self.pad_before = template.pad_before
  self.pad_after = template.pad_after
  self.showCondition = tonumber(template.showCondition)
  self.plot_after = tonumber(template.plot_after)
  self.polot_type = template.polot_type
  self.eventType = tonumber(template.type)
  self.plot_before = tonumber(template.plot_before)
  self.pawn_before = template.pawn_before
  self.pawn_after = template.pawn_after
  self.reward = template.reward
  self.land_lock = template.land_lock
  self.tileList = template.tileList
  self.type_para = template.type_para
  self.pawn_show = template.pawn_show
  self.skip_id = template.skip_id
  self.initInvisible = template.initInvisible
  self.name = template.name
  self.desc = template.desc
  self.icon = template.icon
  self.image = template.image
  self.reward_show = template.reward_show
  self.variantPatch = template.variantPatch
  self.playerGoCameraFollow = template.playerGoCameraFollow
  self.isRotate = template.pawn_unrotate
  self.chapter_quest_condition = template.chapter_quest_condition
  self.polotInfo = string.split(template.plot_type, "|")
  self.needBuild = {}
  self.soundId = template.soundId
  local abTestNeedBuilds = template.building_condition
  if abTestNeedBuilds ~= nil then
    local needBuildStrs = string.split(abTestNeedBuilds, ";")
    for _, str in ipairs(needBuildStrs) do
      local n = tonumber(str)
      if n ~= nil then
        local buildId = n // BuildLevelCap * BuildLevelCap
        local level = n % BuildLevelCap
        table.insert(self.needBuild, {buildId = buildId, level = level})
      end
    end
  end
  for i = 1, #self.polotInfo do
    if not string.IsNullOrEmpty(self.polotInfo[i]) then
      self.polotInfo[i] = string.split(self.polotInfo[i], ";")
    end
  end
  self.curLandlockId = 0
  self.rankStageId = template.rankStageId
  self.lock_module_key = template.lock_module_key
  self.lock_module_tips_key = template.lock_module_tips_key
  self.hasLockModule = template.hasLockModule
  self.tryHeroes = template.tryHeroes
  self.base_land_type = template.base_land_type
  self.event_plot_id = template.event_plot_id
  self.eventPlotIdCount = #self.event_plot_id
  self.event_display_id = tonumber(template.event_display_id) or 0
  self.soldier_num = template.soldier_num
  self.soldier_lan_num = template.soldier_lan_num
  self.bornEffect = template.bornEffect
  self.openSeasonId = template.openSeasonId
  self.openSeasonPassDay = template.openSeasonPassDay
  self.headPath = template.headPath
  self.textKey = template.textKey
  self.event_reward_show = template.event_reward_show
  self.stage_feature_building_id = template.stage_feature_building_id
  self.show_condition_param = template.show_condition_param
  if self.showCondition == MonplolyObstacleShowCondition.MainLv then
    self.showConditionMainLv = tonumber(self.show_condition_param) or 0
  end
  self.sound_id_born = template.sound_id_born
  self.top_effect_path = template.top_effect_path
end

function MonopolyPlacealityData:IsRotate()
  if self.isRotate == 0 or string.IsNullOrEmpty(self.isRotate) then
    return true
  end
end

function MonopolyPlacealityData:SetStateByCurId(curId)
  if curId > self.id then
    self.state = MonopolyPlacealityType.Leave
  elseif self.id == curId then
    self.state = MonopolyPlacealityType.Arrive
  else
    self.state = MonopolyPlacealityType.ArrivalBefore
  end
end

function MonopolyPlacealityData:IsUnLockPlaceality()
  if self.needBuild ~= nil then
    for _, v in ipairs(self.needBuild) do
      if not DataCenter.BuildManager:HasBuildByIdAndLevel(v.buildId, v.level) then
        return false, v.buildId, v.level
      end
    end
  end
  return true, 0, 0
end

function MonopolyPlacealityData:GetIsUn()
  local data = DataCenter.LandLockManager:GetLandLockDataById(self.land_lock)
  if data then
    return data.state == LandLockState.Finished
  end
end

function MonopolyPlacealityData:GetCenterPointId()
  local template = DataCenter.MonopolyManager:GetTemplate(self.id)
  local sumX = 0
  local sumY = 0
  for _, tile in ipairs(template.tileList) do
    sumX = sumX + tile.x
    sumY = sumY + tile.y
  end
  local x = Mathf.Round(sumX / #template.tileList)
  local y = Mathf.Round(sumY / #template.tileList)
  local tilePosX = DataCenter.BuildManager.main_city_pos.x + x
  local tilePosY = DataCenter.BuildManager.main_city_pos.y + y
  return SceneUtils.TileXYToIndex(tilePosX, tilePosY, ForceChangeScene.City)
end

function MonopolyPlacealityData:GetLeftLowerWorldPos()
  local xMin, xMax, yMin, yMax = IntMaxValue, IntMinValue, IntMaxValue, IntMinValue
  for _, tile in ipairs(self.tileList) do
    xMin = math.min(xMin, tile.x)
    xMax = math.max(xMax, tile.x)
    yMin = math.min(yMin, tile.y)
    yMax = math.max(yMax, tile.y)
  end
  local tilePosMin = DataCenter.BuildManager.main_city_pos + Vector2.New(xMin, yMin)
  local tilePosMax = DataCenter.BuildManager.main_city_pos + Vector2.New(xMax, yMax)
  local worldPosMin = SceneUtils.TileToWorld(tilePosMin)
  local worldPosMax = SceneUtils.TileToWorld(tilePosMax)
  return Vector3.New(worldPosMax.x, 0, worldPosMin.z)
end

function MonopolyPlacealityData:GetCenterWorldPos()
  local xMin, xMax, yMin, yMax = IntMaxValue, IntMinValue, IntMaxValue, IntMinValue
  for _, tile in ipairs(self.tileList) do
    xMin = math.min(xMin, tile.x)
    xMax = math.max(xMax, tile.x)
    yMin = math.min(yMin, tile.y)
    yMax = math.max(yMax, tile.y)
  end
  local tilePosMin = DataCenter.BuildManager.main_city_pos + Vector2.New(xMin, yMin)
  local tilePosMax = DataCenter.BuildManager.main_city_pos + Vector2.New(xMax, yMax)
  local worldPosMin = SceneUtils.TileToWorld(tilePosMin)
  local worldPosMax = SceneUtils.TileToWorld(tilePosMax)
  return Vector3.New((worldPosMin.x + worldPosMax.x) / 2, 0, (worldPosMin.z + worldPosMax.z) / 2)
end

function MonopolyPlacealityData:GetRandomEventPlotId(cur)
  if self.eventPlotIdCount == 0 then
    return 0
  end
  if self.eventPlotIdCount == 1 then
    return self.event_plot_id[1]
  end
  local random = math.random(1, self.eventPlotIdCount)
  local id = self.event_plot_id[random]
  cur = cur or 0
  if id == cur then
    random = random + 1
    if random > self.eventPlotIdCount then
      random = 1
    end
  end
  return self.event_plot_id[random]
end

function MonopolyPlacealityData:CheckSeasonOpenCondition()
  if not self.openSeasonId or not self.openSeasonPassDay then
    return true
  end
  local curSeasonId = SeasonUtil.GetSeason()
  if curSeasonId > self.openSeasonId then
    return true
  elseif curSeasonId < self.openSeasonId then
    return false, self.openSeasonId, self.openSeasonPassDay
  end
  local curSeasonDay = SeasonUtil.GetSeasonDay()
  if curSeasonDay < self.openSeasonPassDay then
    return false, self.openSeasonId, self.openSeasonPassDay
  end
  return true
end

return MonopolyPlacealityData
