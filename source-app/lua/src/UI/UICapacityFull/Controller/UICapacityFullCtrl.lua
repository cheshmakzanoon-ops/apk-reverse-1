local UICapacityFullCtrl = BaseClass("UICapacityFullCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local ItemType = {
  BuildBuilding = 50,
  UpgradeBuilding = 51,
  StationHero = 18,
  LevelUpHero = 19,
  SellGoods = 20,
  CommercialOrderComplete = 28,
  GolloesOrderComplete = 29,
  KonbiniOrderComplete = 30,
  Science = 31,
  MonthCard = 32,
  OpenCapacityWindow = 63
}
local CapacityFullResFlag = 100000

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityFull)
  if CS.SceneManager.World then
    CS.SceneManager.World:QuitFocus(LookAtFocusTime)
  end
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function CheckPreBuildingLevel(self)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_COLD_STORAGE)
  if buildTemplate ~= nil then
    return buildTemplate:IsPreBuildConditionValid()
  end
  return false
end

local function GetBuildState(self, buildId)
  local buildNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(tonumber(buildId))
  local maxNum = DataCenter.BuildManager:GetMaxBuildNum(buildId)
  local curMaxNum = DataCenter.BuildManager:GetCurMaxBuildNum(buildId)
  if buildNum >= maxNum then
    return false
  end
  if buildNum >= curMaxNum then
    return false
  end
  local list = DataCenter.BuildManager:GetFoldUpBuildByBuildId(buildId)
  if list ~= nil and table.count(list) > 0 then
    return true
  end
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    return buildTemplate:IsPreBuildConditionValid()
  end
  return false
end

local function GetIcon(self, icon, tip)
  local pic = icon or ""
  if string.IsNullOrEmpty(pic) then
    return pic
  end
  local tips = tip or 0
  local isBuildIcon = string.startswith(pic, "pic")
  if tips == 2 or tips == 4 or tips == 9 or isBuildIcon then
    return string.format(LoadPath.BuildIconOutCity, pic)
  end
  return string.format(LoadPath.ResLackIcons, pic)
end

local function GetBuildIcon(self, icon, buildId)
  if icon == "" then
    local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
    return template:GetBuildIconOutCity()
  else
    return string.format(LoadPath.BuildIconOutCity, icon)
  end
end

local function GetName(self, tips, para1, name)
  local names = ""
  if tips == 10 then
    local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(para1)
    if template ~= nil then
      return Localization:GetString(name, Localization:GetString(template.name))
    end
  else
    names = name or ""
    return Localization:GetString(names)
  end
end

local function GetBuildName(self, name, buildId)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if template ~= nil then
    return Localization:GetString(tostring(name), Localization:GetString(template.name))
  end
end

local function OnClickFun(self, param)
  if param.type == ItemType.StationHero then
    if CS.SceneManager.IsInPVE() then
      DataCenter.BattleLevel:Exit(function()
        UIUtil.OpenHeroStationByEffectType(HeroStationEffectType.StorageLimit)
      end)
    else
      UIUtil.OpenHeroStationByEffectType(HeroStationEffectType.StorageLimit)
    end
  elseif param.type == ItemType.LevelUpHero then
    if CS.SceneManager.IsInPVE() then
      DataCenter.BattleLevel:Exit(function()
        UIUtil.OpenHeroStationByEffectType(HeroStationEffectType.StorageLimit, nil, true)
      end)
    else
      UIUtil.OpenHeroStationByEffectType(HeroStationEffectType.StorageLimit, nil, true)
    end
  elseif param.type == ItemType.SellGoods or param.type == ItemType.OpenCapacityWindow then
    local itemId
    if param.type == ItemType.OpenCapacityWindow then
      itemId = DataCenter.ResourceItemDataManager:GetMaxNumItem()
    end
    if CS.SceneManager.IsInPVE() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTable, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        hideTop = true
      }, UICapacityTableTab.Farming, itemId)
    else
      GoToUtil.GotoOpenView(UIWindowNames.UICapacityTable, UICapacityTableTab.Farming, itemId)
    end
  elseif param.type == ItemType.Science then
    if CS.SceneManager.IsInPVE() then
      DataCenter.BattleLevel:Exit(function()
        GoToUtil.GotoScience(tonumber(param.scienceId))
      end)
    else
      GoToUtil.GotoScience(tonumber(param.scienceId))
    end
  elseif param.type == ItemType.CommercialOrderComplete then
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
    if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
      local posEnd = buildList[1].pointId
      if CS.SceneManager.IsInPVE() then
        DataCenter.BattleLevel:Exit(function()
          GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            local isArrow = 1
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIBusinessCenter, isArrow)
          end)
        end)
      else
        GoToUtil.CloseAllWindows()
        self:GoTo(function()
          GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            local isArrow = 1
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIBusinessCenter, isArrow)
          end)
        end)
      end
    elseif CS.SceneManager.IsInPVE() then
      DataCenter.BattleLevel:Exit(function()
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
      end)
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
    end
  elseif param.type == ItemType.GolloesOrderComplete then
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_GROCERY_STORE)
    if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
      local posEnd = buildList[1].pointId
      if CS.SceneManager.IsInPVE() then
        DataCenter.BattleLevel:Exit(function()
          GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            local isArrow = 1
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGroceryStore, isArrow)
          end)
        end)
      else
        self:GoTo(function()
          GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            local isArrow = 1
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGroceryStore, isArrow)
          end)
        end)
      end
    elseif CS.SceneManager.IsInPVE() then
      DataCenter.BattleLevel:Exit(function()
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_GROCERY_STORE)
      end)
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_GROCERY_STORE)
    end
  elseif param.type == ItemType.KonbiniOrderComplete then
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_KONBINI)
    if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
      local posEnd = buildList[1].pointId
      if CS.SceneManager.IsInPVE() then
        DataCenter.BattleLevel:Exit(function()
          GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, nil, 1)
          end)
        end)
      else
        GoToUtil.CloseAllWindows()
        self:GoTo(function()
          GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, nil, 1)
          end)
        end)
      end
    elseif CS.SceneManager.IsInPVE() then
      DataCenter.BattleLevel:Exit(function()
        GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_KONBINI)
      end)
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_KONBINI)
    end
  elseif param.type == ItemType.MonthCard then
    if CS.SceneManager.IsInPVE() then
      DataCenter.BattleLevel:Exit(function()
        GoToUtil.GoToMonthCard()
      end)
    else
      GoToUtil.GoToMonthCard()
    end
  elseif param.type == ItemType.UpgradeBuilding then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.buildUuid)
    if CS.SceneManager.IsInPVE() then
      DataCenter.BattleLevel:Exit(function()
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City), nil, nil, function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          }, buildData.uuid)
        end)
      end)
    else
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City), nil, nil, function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, buildData.uuid)
      end)
    end
  elseif param.type == ItemType.BuildBuilding then
    if CS.SceneManager.IsInPVE() then
      DataCenter.BattleLevel:Exit(function()
        GoToUtil.GotoBuildListByBuildId(param.buildId)
      end)
    else
      GoToUtil.GotoBuildListByBuildId(param.buildId)
    end
  end
end

local function GoTo(self, createAction)
  SceneUtils.ChangeToCity(createAction)
end

local function GetShowList(self, capacity)
  local mainLv = DataCenter.BuildManager.MainLv
  local playerLv = DataCenter.PlayerLevelManager:GetLevel()
  local lackResource = {}
  for _, type in pairs(ItemType) do
    LocalController:instance():visitTable(TableName.Res_Lack_Tips, function(_, line)
      local lineType = tonumber(line:getValue("tips"))
      if lineType == type then
        local item = {}
        item.type = type
        item.order = tonumber(line:getValue("order"))
        item.group = line:getValue("group") or ""
        item.icon = self:GetIcon(line:getValue("pic") or "", lineType)
        item.name = self:GetName(lineType, line:getValue("para1"), line:getValue("name"))
        item.active_show = tonumber(line:getValue("active_show"))
        item.btnName = Localization:GetString(line:getValue("btn_name"))
        if type ~= ItemType.SellGoods then
          local baseLevel = line:getValue("base")
          local level = line:getValue("level")
          local baseLevelOk = true
          local playerLevelOk = true
          local baseLevelArray = string.split(baseLevel, "-")
          local res = tonumber(line:getValue("res"))
          if table.count(baseLevelArray) == 2 then
            local minLevel = tonumber(baseLevelArray[1])
            local maxLevel = tonumber(baseLevelArray[2])
            if minLevel > mainLv or maxLevel < mainLv then
              baseLevelOk = false
            end
          end
          local levelList = string.split(level, "-")
          if table.count(levelList) == 2 then
            local minLevel = tonumber(levelList[1])
            local maxLevel = tonumber(levelList[2])
            if minLevel > playerLv or maxLevel < playerLv then
              playerLevelOk = false
            end
          end
          if baseLevelOk and playerLevelOk then
            if type == ItemType.Science then
              item.scienceId = line:getValue("para1")
              local hasScience = DataCenter.ScienceManager:HasScienceByIdAndLevel(tonumber(item.scienceId), 1)
              if not hasScience then
                table.insert(lackResource, item)
              end
            elseif type == ItemType.OpenCapacityWindow then
              table.insert(lackResource, item)
            elseif type == ItemType.CommercialOrderComplete then
              local list = DataCenter.ResidentOrderDataManager:GetOrderList()
              for i, v in pairs(list) do
                if v.id > 0 then
                  local state = DataCenter.ResidentOrderDataManager:GetOrderStateByOrderUuid(v.uuid)
                  if state == ResidentOrderState.Yes then
                    table.insert(lackResource, item)
                    break
                  end
                end
              end
            elseif type == ItemType.GolloesOrderComplete then
              local list = DataCenter.GroceryStoreOrderDataManager.groceryStoreOrderDic
              for i, v in pairs(list) do
                if v:CanSend() then
                  table.insert(lackResource, item)
                  break
                end
              end
            elseif type == ItemType.KonbiniOrderComplete then
              local list = DataCenter.StorageShopManager:GetSelfSlotsInfo()
              for i, v in pairs(list) do
                if v.state == StorageShopSlotState.Empty then
                  table.insert(lackResource, item)
                  break
                end
              end
            elseif type == ItemType.StationHero then
              local heroStationEnabled = DataCenter.HeroStationManager:Enabled()
              local skillId = DataCenter.HeroStationManager:GetSkillIdByEffectType(HeroStationEffectType.StorageLimit)
              local stationId = DataCenter.HeroStationManager:GetStationIdBySkillId(skillId)
              local hasAvailableHero = DataCenter.HeroStationManager:HasAvailableHero(stationId)
              local hasAvailableSlot = DataCenter.HeroStationManager:HasAvailableSlot(stationId)
              local showStationHero = heroStationEnabled and hasAvailableHero and hasAvailableSlot
              if showStationHero then
                table.insert(lackResource, item)
              end
            elseif type == ItemType.LevelUpHero then
              local heroStationEnabled = DataCenter.HeroStationManager:Enabled()
              if heroStationEnabled then
                table.insert(lackResource, item)
              end
            elseif type == ItemType.MonthCard then
              if not DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
                table.insert(lackResource, item)
              end
            elseif type == ItemType.BuildBuilding then
              local buildId = line:getValue("para1")
              if string.IsNullOrEmpty(buildId) then
                return false
              end
              local str = string.split(buildId, "|")
              for i = 1, table.count(str) do
                if self:GetBuildState(str[i]) then
                  item.name = self:GetBuildName(line:getValue("name"), str[i])
                  item.icon = self:GetBuildIcon(line:getValue("pic") or "", tonumber(str[i]))
                  item.buildId = tonumber(str[i])
                  table.insert(lackResource, item)
                  break
                end
              end
            elseif type == ItemType.UpgradeBuilding and res == CapacityFullResFlag then
              local buildUuid, buildId
              local str = line:getValue("para1")
              if str ~= "" then
                local arr = string.split(str, "|")
                local lv = 9999
                for i = 1, table.count(arr) do
                  local value = string.split(arr[i], ";")
                  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(value[1]))
                  if list and table.count(list) > 0 then
                    for _, buildInfo in pairs(list) do
                      if value[2] and buildInfo.level == tonumber(value[2]) then
                        buildUuid = buildInfo.uuid
                        buildId = value[1]
                        break
                      elseif lv > buildInfo.level then
                        lv = buildInfo.level
                        buildId = value[1]
                        buildUuid = buildInfo.uuid
                      end
                    end
                  end
                end
              else
                local buildIdList = DataCenter.BuildManager:GetAllBuildUuid()
                local list = table.againObtain(buildIdList)
                for i, v in pairs(list) do
                  local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(v)
                  local isUpgrade = false
                  for k, n in ipairs(ret.needResItem) do
                    local value = DataCenter.ResourceItemDataManager:GetCountByItemId(n.itemId)
                    if value >= n.count then
                      isUpgrade = true
                    end
                  end
                  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
                  if isUpgrade and ret.buildId ~= BuildingTypes.FUN_BUILD_WATER_STORAGE and not buildData:IsUpgradeFinish() and not buildData:IsUpgrading() and not buildData:IsInFix() then
                    buildUuid = v
                    buildId = ret.buildId
                    break
                  end
                end
              end
              if buildUuid then
                item.name = self:GetBuildName(line:getValue("name"), buildId)
                item.icon = self:GetBuildIcon(line:getValue("pic") or "", tonumber(buildId))
                item.buildUuid = buildUuid
                table.insert(lackResource, item)
              end
            end
          end
        else
          table.insert(lackResource, item)
        end
      end
    end)
  end
  local _lack_listNew = {}
  local lackGroupList = {}
  for i, v in ipairs(lackResource) do
    local a = v.group
    if a ~= "" then
      if lackGroupList[tonumber(v.group)] == nil then
        lackGroupList[tonumber(v.group)] = {}
      end
      table.insert(lackGroupList[tonumber(v.group)], v)
    else
      table.insert(_lack_listNew, v)
    end
  end
  for k, v in pairs(lackGroupList) do
    table.sort(v, function(a, b)
      return a.order < b.order
    end)
  end
  for i, v in pairs(lackGroupList) do
    table.insert(_lack_listNew, v[1])
  end
  table.sort(_lack_listNew, function(a, b)
    if a.order < b.order then
      return true
    end
    return false
  end)
  if capacity then
    for i = #_lack_listNew, 1, -1 do
      if not _lack_listNew[i].active_show or _lack_listNew[i].active_show ~= 1 then
        table.remove(_lack_listNew, i)
      end
    end
  end
  if 3 < #_lack_listNew then
    for i = #_lack_listNew, 4, -1 do
      table.remove(_lack_listNew, i)
    end
  end
  return _lack_listNew
end

UICapacityFullCtrl.CloseSelf = CloseSelf
UICapacityFullCtrl.Close = Close
UICapacityFullCtrl.GetBuildState = GetBuildState
UICapacityFullCtrl.CheckPreBuildingLevel = CheckPreBuildingLevel
UICapacityFullCtrl.GoTo = GoTo
UICapacityFullCtrl.GetIcon = GetIcon
UICapacityFullCtrl.GetName = GetName
UICapacityFullCtrl.GetBuildName = GetBuildName
UICapacityFullCtrl.GetShowList = GetShowList
UICapacityFullCtrl.OnClickFun = OnClickFun
UICapacityFullCtrl.GetBuildIcon = GetBuildIcon
return UICapacityFullCtrl
