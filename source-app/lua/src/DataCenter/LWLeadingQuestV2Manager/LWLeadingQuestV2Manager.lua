local LWLeadingQuestV2Manager = BaseClass("LWLeadingQuestV2Manager")
local iconPath = "Assets/Main/Sprites/UI/LWUILeadingQuestWay/"

function LWLeadingQuestV2Manager:__init()
end

function LWLeadingQuestV2Manager:__delete()
  self.info = nil
  self.taskDic = nil
  self.wayIconMap = nil
  self.wayDescMap = nil
end

function LWLeadingQuestV2Manager:OnGetInfo(info)
  self.info = info
  self.taskDic = {}
  local tasks = self.info.taskArr
  for _, v in ipairs(tasks) do
    local taskId = v.taskId
    self.taskDic[taskId] = v
  end
  EventManager:GetInstance():Broadcast(EventId.OnLeadingQuestV2DataUpdated)
end

function LWLeadingQuestV2Manager:UpdateTaskInfo(msg)
  if self.info and msg.aid and tonumber(msg.aid) == tonumber(self.info.activityId) then
    table.walk(msg.a_task, function(k, v)
      local tmp = self.taskDic[v.id]
      if tmp then
        tmp.num = v.num
        tmp.state = v.state
      end
    end)
    EventManager:GetInstance():Broadcast(EventId.OnLeadingQuestV2TaskUpdated)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function LWLeadingQuestV2Manager:OnGetOneTaskReward(msg)
  if self.info and tonumber(self.info.activityId) == tonumber(msg.activityId) then
    for i, taskInfo in ipairs(self.info.taskArr) do
      if taskInfo and taskInfo.taskId == msg.taskId then
        taskInfo.state = TaskState.Received
      end
    end
    EventManager:GetInstance():Broadcast(EventId.OnLeadingQuestV2TaskUpdated)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function LWLeadingQuestV2Manager:GetRedCount()
  local num = 0
  if self.info then
    for i, taskInfo in ipairs(self.info.taskArr) do
      if taskInfo and taskInfo.state == 1 then
        num = num + 1
      end
    end
  end
  return num
end

function LWLeadingQuestV2Manager:GetWayIcon(way)
  if self.wayIconMap == nil then
    self.wayIconMap = {}
    self.wayDescMap = {}
    for i = 1, 6 do
      local k = LuaEntry.DataConfig:TryGetStr("act_powerupconfig", "k" .. i)
      if not string.IsNullOrEmpty(k) then
        local array = string.split(k, ";")
        if #array == 2 then
          local icon = array[1]
          local desc = array[2]
          if not string.IsNullOrEmpty(icon) and not string.IsNullOrEmpty(desc) then
            self.wayIconMap[i] = iconPath .. icon
            self.wayDescMap[i] = desc
          end
        end
      end
    end
  end
  return self.wayIconMap[way]
end

function LWLeadingQuestV2Manager:GetWayDesc(way)
  if self.wayDescMap == nil then
    self.wayIconMap = {}
    self.wayDescMap = {}
    for i = 1, 6 do
      local k = LuaEntry.DataConfig:TryGetStr("act_powerupconfig", "k" .. i)
      if not string.IsNullOrEmpty(k) then
        local array = string.split(k, ";")
        if #array == 2 then
          local icon = array[1]
          local desc = array[2]
          if not string.IsNullOrEmpty(icon) and not string.IsNullOrEmpty(desc) then
            self.wayIconMap[i] = iconPath .. icon
            self.wayDescMap[i] = desc
          end
        end
      end
    end
  end
  return self.wayDescMap[way]
end

function LWLeadingQuestV2Manager:GetConfig()
  local curLevel = DataCenter.BuildManager:GetMainLevel()
  local config = LocalController:instance():tryGetLine(LuaEntry.Player:GetABTestTableName(TableName.Activity_PowerUpConfig), curLevel)
  if config then
    return config
  end
  if self.maxLevel == nil then
    local max = 0
    LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.Activity_PowerUpConfig), function(id, lineData)
      if id > max then
        max = id
      end
    end)
    self.maxLevel = max
  end
  config = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Activity_PowerUpConfig), self.maxLevel)
  return config
end

function LWLeadingQuestV2Manager:GetCurPower(way)
  local power = 0
  if way == LeadingQuestPowerUpType.Building then
    if LuaEntry.Player and LuaEntry.Player.buildingPower then
      power = LuaEntry.Player.buildingPower
    end
  elseif way == LeadingQuestPowerUpType.Hero then
    if LuaEntry.Player and LuaEntry.Player.heroPower then
      power = LuaEntry.Player.heroPower
    end
  elseif way == LeadingQuestPowerUpType.Science then
    if LuaEntry.Player and LuaEntry.Player.sciencePower then
      power = LuaEntry.Player.sciencePower
    end
  elseif way == LeadingQuestPowerUpType.Army then
    if LuaEntry.Player and LuaEntry.Player.armyPower then
      power = LuaEntry.Player.armyPower
    end
  elseif way == LeadingQuestPowerUpType.SquadEquip and LuaEntry.Player and LuaEntry.Player.squadEquipPower then
    power = LuaEntry.Player.squadEquipPower
  end
  return power
end

function LWLeadingQuestV2Manager:GoTo(way)
  if way == LeadingQuestPowerUpType.Building then
    self:GuideToUpgradeBuilding()
  elseif way == LeadingQuestPowerUpType.Hero then
    self:GuideToHero()
  elseif way == LeadingQuestPowerUpType.Science then
    self:GuideToScience()
  elseif way == LeadingQuestPowerUpType.Army then
    self:GuideToSoldierTrain()
  elseif way == LeadingQuestPowerUpType.SquadEquip then
    self:GuideToTacticalCenter()
  end
end

function LWLeadingQuestV2Manager:GuideToUpgradeBuilding()
  local list = DataCenter.BuildManager:GetCanUpgradeBuildUuidListFilterd()
  if table.count(list) > 0 then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(list[1])
    if buildData ~= nil then
      GoToUtil.GotoCityByBuildId(buildData.itemId, WorldTileBtnType.City_Upgrade)
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
    end
  else
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
  end
end

function LWLeadingQuestV2Manager:GuideToScience()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_SCIENE)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.FUN_BUILD_SCIENE)
    return
  end
  GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SCIENE, WorldTileBtnType.City_Science)
end

function LWLeadingQuestV2Manager:GuideToSoldierTrain()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_MILITARY_CAMP)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_MILITARY_CAMP)
    return
  end
  GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_MILITARY_CAMP, WorldTileBtnType.Train_Soldier)
end

function LWLeadingQuestV2Manager:GuideToTacticalCenter()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_TACTICAL_CENTER)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_TACTICAL_CENTER)
    return
  end
  local targetBuilding = buildList[1]
  GoToUtil.CloseAllWindows()
  self:SwitchToCity(function()
    GoToUtil.GotoPos(targetBuilding:GetCenterVec(), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      local effectPos = targetBuilding:GetCenterVec()
      effectPos.y = effectPos.y + 5
      WorldArrowManager:GetInstance():ShowArrowEffect(0, effectPos, ArrowType.Normal)
    end)
  end)
end

function LWLeadingQuestV2Manager:GuideToHero()
  GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

function LWLeadingQuestV2Manager:SwitchToCity(callback)
  if BattleFieldUtil.InBattleField() then
    CrossServerUtil.OnBackSelfServerFromDragonWorld()
    SceneUtils.ChangeToCity(callback)
  elseif not CS.SceneManager:IsInCity() then
    SceneUtils.ChangeToCity(callback)
  elseif callback then
    callback()
  end
end

function LWLeadingQuestV2Manager:GetIndexedTasks()
  if not self.info then
    return
  end
  if self.rawTaskList then
    return self.rawTaskList
  end
  self.rawTaskList = DeepCopy(self.info.taskArr)
  table.sort(self.rawTaskList, function(a, b)
    return tonumber(a.taskId) < tonumber(b.taskId)
  end)
  return self.rawTaskList
end

function LWLeadingQuestV2Manager:GetPowerSep(power)
  if not self.info then
    return
  end
  power = power or LuaEntry.Player.power
  local list = self:GetIndexedTasks()
  local leftPower = 0
  local rightPower = 0
  for i, v in ipairs(list) do
    local taskId = tonumber(v.taskId)
    local taskTemplate = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(taskId)
    local p = taskTemplate.para2
    if power < p then
      rightPower = p
      break
    else
      leftPower = p
    end
  end
  return leftPower, rightPower
end

return LWLeadingQuestV2Manager
