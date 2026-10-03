local SeasonDesertShopTemplate = BaseClass("SeasonDesertShopTemplate")
local Localization = CS.GameEntry.Localization
local ConditionType = {CareerLv = 1, BuildingLv = 2}

function SeasonDesertShopTemplate:__init(info)
  self.id = info.id
  self.shop_id = info.shop_id
  self.cost = info.cost
  self.commodity = info.commodity
  self.commodity_num = info.commodity_num
  self.cycle_times = info.cycle_times
  self.order = info.order
  self.currency_id = info.currency_id
  self.special_show_dialog = info.special_show_dialog
  local conditionType = info.condition_type or ""
  local conditionTypes = string.split(conditionType, ";")
  self.condition_type = {}
  for _, v in ipairs(conditionTypes) do
    table.insert(self.condition_type, tonumber(v) or 0)
  end
  local conditionPara = info.condition_para or ""
  local conditionParas = string.split(conditionPara, ";")
  self.condition_para = {}
  for _, v in ipairs(conditionParas) do
    if v ~= "" then
      table.insert(self.condition_para, string.split(v, "|"))
    else
      table.insert(self.condition_para, {})
    end
  end
  self.condition_show = string.split(info.condition_show or "", ";")
end

function SeasonDesertShopTemplate:__delete(self)
  self.id = nil
  self.shop_id = nil
  self.cost = nil
  self.commodity = nil
  self.commodity_num = nil
  self.cycle_times = nil
  self.order = nil
  self.currency_id = nil
  self.special_show_dialog = nil
end

function SeasonDesertShopTemplate:CheckConditions()
  if not self.condition_type or #self.condition_type == 0 then
    return true
  end
  for i, conditionType in ipairs(self.condition_type) do
    local conditionPara = self.condition_para[i] or {}
    local canBuy, tips = self:CheckCondition(conditionType, conditionPara, self.condition_show[i])
    if not canBuy then
      return false, tips
    end
  end
  return true
end

function SeasonDesertShopTemplate:CheckCondition(conditionType, conditionPara, conditionShow)
  if conditionType == 0 then
    return true
  elseif conditionType == ConditionType.CareerLv then
    local data = DataCenter.MasteryManager:GetData()
    local careerLv = data and data.level or LuaEntry.Player.careerLv or 0
    local condCareerLv = tonumber(conditionPara[1]) or 0
    if careerLv < condCareerLv then
      return false, conditionShow and Localization:GetString(conditionShow, careerLv, condCareerLv)
    end
  elseif conditionType == ConditionType.BuildingLv then
    local condBuildingId = tonumber(conditionPara[1]) or 0
    local condBuildLevel = tonumber(conditionPara[2]) or 0
    if condBuildingId <= 0 or condBuildLevel <= 0 then
      return true
    end
    local buildingLevel = self:GetCurBuildingLevel(condBuildingId)
    if condBuildLevel > buildingLevel then
      return false, conditionShow and Localization:GetString(conditionShow, buildingLevel, condBuildLevel)
    end
  end
  return true
end

function SeasonDesertShopTemplate:GotoConditionTips()
  if not self.condition_type or #self.condition_type == 0 then
    return
  end
  for i, conditionType in ipairs(self.condition_type) do
    local conditionPara = self.condition_para[i] or {}
    if not self:CheckCondition(conditionType, conditionPara) then
      if conditionType == ConditionType.CareerLv then
        local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.SEASON_CAREER_BUILD)
        if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
          GoToUtil.GotoBuildListByBuildId(BuildingTypes.SEASON_CAREER_BUILD)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMastery, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          })
        end
        return true
      elseif conditionType == ConditionType.BuildingLv then
        local condBuildingId = tonumber(conditionPara[1]) or 0
        local buildType = DataCenter.BuildManager:GetBuildId(condBuildingId) or 0
        local builds = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildType)
        if builds and builds[1] then
          GoToUtil.CloseAllWindows()
          GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(builds[1].pointId, ForceChangeScene.City), nil, nil, function()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, {
              anim = true,
              UIMainAnim = UIMainAnimType.AllHide
            }, builds[1].uuid)
          end)
        else
          GoToUtil.GotoBuildListByBuildId(condBuildingId)
        end
        return true
      end
    end
  end
  return false
end

function SeasonDesertShopTemplate:GetCurBuildingLevel(condBuildingId)
  if not condBuildingId or condBuildingId <= 0 then
    return 0
  end
  local buildType = DataCenter.BuildManager:GetBuildId(condBuildingId) or 0
  local buildingLevel = 0
  local builds = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildType)
  for _, buildData in ipairs(builds) do
    if buildData and buildData.level and buildingLevel < buildData.level then
      buildingLevel = buildData.level
    end
  end
  return buildingLevel
end

return SeasonDesertShopTemplate
