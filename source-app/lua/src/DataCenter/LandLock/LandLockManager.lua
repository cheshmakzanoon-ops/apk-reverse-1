local LandLockManager = BaseClass("LandLockManager")
local ENABLE_VISUAL = true
local LandLockTemplate = require("DataCenter.LandLock.LandLockTemplate")
local LandLockData = require("DataCenter.LandLock.LandLockData")
local LandLockObject = require("Scene.CityZone.ZoneLockObject")
local LandLockReward = require("DataCenter.LandLock.LandLockReward")
local LandLockReceive = require("DataCenter.LandLock.LandLockReceive")
local LandLockBoard = require("DataCenter.LandLock.LandLockBoard")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UnlockEffectPrefabPath = "Assets/Main/Prefabs/BuildEffect/UnlockEffect.prefab"
local GroundSizeScale = 0.225

local function __init(self)
  self:RefreshEnableVisual()
  self.initServerData = false
  self.initGuide = false
  self.loadComplete = false
  self.templateDict = {}
  self.landLockDataDict = {}
  self.objectDict = {}
  self.noPutCountDict = {}
  self.rewardDict = {}
  self.zoneToLandDict = {}
  self.landEggs = nil
  local nextDict = {}
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.LandLock), function(_, line)
    local template = LandLockTemplate.New()
    template:InitData(line)
    self.templateDict[template.id] = template
    local data = LandLockData.New()
    data:InitByTemplate(template)
    self.landLockDataDict[template.id] = data
    if table.count(template.priorList) > 0 then
      for _, priorId in ipairs(template.priorList) do
        if nextDict[priorId] == nil then
          nextDict[priorId] = {}
        end
        table.insert(nextDict[priorId], template.id)
      end
    end
    self:SetLandLockState(data, LandLockState.Hide, true)
    if template.landToZone and 0 < template.landToZone then
      self.zoneToLandDict[template.landToZone] = template.id
    end
  end)
  for id, list in pairs(nextDict) do
    self.templateDict[id].nextList = list
    self.landLockDataDict[id].nextList = list
  end
  self:AddListeners()
end

local function __delete(self)
  self.landEggs = nil
  self.initServerData = nil
  self.initGuide = nil
  self.loadComplete = nil
  self.templateDict = nil
  self.landLockDataDict = nil
  self.objectDict = nil
  self.noPutCountDict = nil
  self.rewardDict = nil
  self.isInit = nil
  self:RemoveListeners()
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnPveLevelEnter)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnPveLevelExit)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.BuildLevelUp, self.OnBuildLevelUpOrMove)
  EventManager:GetInstance():AddListener(EventId.BuildMove, self.OnBuildLevelUpOrMove)
  EventManager:GetInstance():AddListener(EventId.RefreshLandlockDataAndReward, self.RefreshLandlockDataAndReward)
  EventManager:GetInstance():AddListener(EventId.GuideInitFinish, self.OnGuideInitFinish)
  EventManager:GetInstance():AddListener(EventId.MainTaskSuccess, self.OnUpdateTask)
  EventManager:GetInstance():AddListener(EventId.QuestRewardSuccess, self.OnUpdateTask)
  EventManager:GetInstance():AddListener(EventId.ChapterTask, self.OnUpdateTask)
  EventManager:GetInstance():AddListener(EventId.ChapterTaskGetReward, self.OnUpdateTask)
  EventManager:GetInstance():AddListener(EventId.DomeRangeChanged, self.OnDomeRangeChanged)
  EventManager:GetInstance():AddListener(EventId.LOAD_COMPLETE, self.OnLoadComplete)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnPveLevelEnter)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnPveLevelExit)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.BuildLevelUp, self.OnBuildLevelUpOrMove)
  EventManager:GetInstance():RemoveListener(EventId.BuildMove, self.OnBuildLevelUpOrMove)
  EventManager:GetInstance():RemoveListener(EventId.RefreshLandlockDataAndReward, self.RefreshLandlockDataAndReward)
  EventManager:GetInstance():RemoveListener(EventId.GuideInitFinish, self.OnGuideInitFinish)
  EventManager:GetInstance():RemoveListener(EventId.MainTaskSuccess, self.OnUpdateTask)
  EventManager:GetInstance():RemoveListener(EventId.QuestRewardSuccess, self.OnUpdateTask)
  EventManager:GetInstance():RemoveListener(EventId.ChapterTask, self.OnUpdateTask)
  EventManager:GetInstance():RemoveListener(EventId.ChapterTaskGetReward, self.OnUpdateTask)
  EventManager:GetInstance():RemoveListener(EventId.DomeRangeChanged, self.OnDomeRangeChanged)
  EventManager:GetInstance():RemoveListener(EventId.LOAD_COMPLETE, self.OnLoadComplete)
end

local function Enabled(self)
  return LuaEntry.DataConfig:CheckSwitch("land_lock")
end

local function RefreshAllData(self, isInit)
  if not self.isInit then
    if isInit then
      self.isInit = true
    else
      return
    end
  end
  for id, _ in pairs(self.landLockDataDict) do
    self:RefreshData(id, isInit)
  end
end

local function RefreshData(self, id, isInit)
  local data = self:GetLandLockDataById(id)
  if data.state == LandLockState.Hide then
    local hide = false
    for _, priorId in ipairs(data.priorList) do
      local priorData = self:GetLandLockDataById(priorId)
      if priorData ~= nil and priorData.state ~= LandLockState.Finished then
        hide = true
        break
      end
    end
    if not hide and (not data:CheckNeedBuild() or not data:CheckNeedChapter()) then
      hide = true
    end
    if not hide then
      self:SetLandLockState(data, LandLockState.Locked, isInit)
    end
  end
end

local function RefreshDataByServer(self, serverData, isInit)
  local id = serverData.id or serverData.landId or 0
  local data = self.landLockDataDict[id]
  if data ~= nil then
    local template = self:GetTemplate(data.id)
    if serverData.state == 1 then
      data.paid = true
      if table.IsNullOrEmpty(data.pveList) then
        self:SetLandLockState(data, LandLockState.Unlocked, isInit)
      elseif data:GetCurPve() ~= 0 and not isInit then
        self:StartPve(id)
      end
    elseif serverData.state == 2 then
      self:SetLandLockState(data, LandLockState.Unlocked, isInit)
    elseif serverData.state == 3 then
      self:SetLandLockState(data, LandLockState.Finished, isInit)
    else
      self:SetLandLockState(data, LandLockState.Hide, isInit)
    end
    if serverData.finishLevels then
      for _, pve in ipairs(serverData.finishLevels) do
        data.pveFinishDict[pve] = true
      end
    end
    if serverData.reward and 0 < serverData.reward then
      data.rewardCount = template.rewardInitCount
    else
      data.rewardCount = 0
    end
    data.egg = serverData.egg
    self:RefreshReward(id, isInit)
  end
end

local function GetTemplate(self, id)
  return self.templateDict[tonumber(id)]
end

local function GetLandLockDataById(self, id)
  return self.landLockDataDict[id]
end

local function GetAlllandLockData(self)
  return self.landLockDataDict
end

local function GetLandLockDataByPointId(self, pointId)
  for _, data in pairs(self.landLockDataDict) do
    if data:GetPointId() == pointId then
      return data
    end
  end
  return nil
end

local function GetFinishLandLockData(self)
  local unlockLandId = {}
  for _, data in pairs(self.landLockDataDict) do
    if data.state == LandLockState.Finished then
      table.insert(unlockLandId, data.id)
    end
  end
  return unlockLandId
end

local function GetLandLockDataByPve(self, pve, fuzzy)
  for _, data in pairs(self.landLockDataDict) do
    if fuzzy then
      if data:HasPve(tonumber(pve)) then
        return data
      end
    elseif data:GetCurPve() == tonumber(pve) then
      return data
    end
  end
  return nil
end

local function GetLandLockDataListByState(self, state)
  if not self:Enabled() then
    return {}
  end
  local list = {}
  for _, data in pairs(self.landLockDataDict) do
    if state == LandLockState.Any or state == data.state then
      table.insert(list, data)
    end
  end
  return list
end

local function ClickLandLockById(self, id)
  local data = self:GetLandLockDataById(id)
  if data == nil then
    return
  end
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  local bubble = DataCenter.LandLockBubbleManager:GetLandLockBubble(id)
  if data.state == LandLockState.Unlocked then
    if #data.alters == 0 then
      self:FinishById(id)
    end
  elseif data.state == LandLockState.Locked then
    if bubble ~= nil and bubble.state == LandLockBubbleState.Locked then
      DataCenter.LandLockBubbleManager:OnClickBubble(id)
    end
    self:MoveCameraToLand(data)
  elseif data.state == LandLockState.Hide and bubble == nil then
    local object = self.objectDict[id]
    if object ~= nil and self:IsLandLockInDome(id) then
      DataCenter.LandLockBubbleManager:CreateBubble(id)
      self:MoveCameraToLand(data)
    end
    DataCenter.LandLockBubbleManager:ResetAllBubble(id)
  end
end

local function MoveCameraToLand(self, data)
  local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
  local touchCamera = CS.UnityEngine.Camera.main:GetComponent(typeof(MobileTouchCamera))
  local zoom = touchCamera.CamZoom
  local pos = data:GetCenterWorldPos()
  GoToUtil.GotoPos(pos, zoom, nil, nil, LuaEntry.Player:GetCurServerId())
end

local function EnterLandLockById(self, id)
  local data = self:GetLandLockDataById(id)
  if data == nil then
    return
  end
  local result, ret1, ret2 = self:CheckLandLockConditionById(id)
  if result == LandLockCondition.ToPay then
    SFSNetwork.SendMessage(MsgDefines.UnlockUserLand, id)
  elseif result == LandLockCondition.ToPve then
    self:StartPve(id)
  elseif result == LandLockCondition.ToFinish then
    if #data.alters == 0 then
      self:FinishById(id)
    end
  elseif result == LandLockCondition.NeedResource then
    local resourceType = ret1
    UIUtil.ShowTipsId(120020)
    local list = DataCenter.BuildManager:GetCanGetResourceBuildUuidByResourceType(resourceType)
    if list == nil then
      GoToUtil.GotoBuildListByBuildId()
    else
      GoToUtil.GotoCityByBuildUuid(list.uuid)
    end
  elseif result == LandLockCondition.NeedResourceItem then
    local resItemId = ret1
    local name = LocalController:instance():getValue(TableName.Aps_Resource_Item, resItemId, "name")
    UIUtil.ShowTips(Localization:GetString(126010, Localization:GetString(name)))
    GoToUtil.GotoColdStorage(resItemId)
  elseif result == LandLockCondition.NeedItem then
    UIUtil.ShowTipsId(120021)
  elseif result == LandLockCondition.NeedBuilding then
    UIUtil.ShowTipsId(130316)
  elseif result == LandLockCondition.NeedChapter then
    local chapter = ret1
    UIUtil.ShowTipsId(121356, chapter)
  end
end

local function CanBuildByPointId(self, pointId)
  if not self:Enabled() then
    return true
  end
  local x, y = self:ConvertPointIdToXY(pointId)
  return self:GetNoPutCountByXY(x, y) == 0
end

local function IsLandLockInDome(self, id)
  local data = self:GetLandLockDataById(id)
  if data == nil then
    return true
  end
  local pos = data:GetCenterWorldPos()
  local range = DataCenter.CityDomeManager:GetDomeRangeCache()
  local exRadius = LandLockDomeExRadius[range]
  return DataCenter.CityDomeManager:IsInDome(pos, exRadius)
end

local function SetLandLockState(self, data, state, isInit)
  local oldState = data.state
  local template = self:GetTemplate(data.id)
  data.state = state
  if oldState == LandLockState.Finished and state ~= LandLockState.Finished then
    for _, tile in ipairs(template.tileList) do
      self:AddNoPutCountByXY(tile.x, tile.y)
    end
  end
  if oldState ~= LandLockState.Finished and state == LandLockState.Finished then
    for _, tile in ipairs(template.tileList) do
      self:SubNoPutCountByXY(tile.x, tile.y)
    end
    for _, nextId in ipairs(data.nextList) do
      self:RefreshData(nextId, isInit)
    end
    if not isInit then
    end
  end
  if not isInit and oldState ~= state and ENABLE_VISUAL then
    self:RefreshObject(data.id)
    EventManager:GetInstance():Broadcast(EventId.LandLockStateUpdate, data:GetPointId())
  end
  if state == LandLockState.Unlocked and (isInit or table.IsNullOrEmpty(data.pveList)) then
    self:FinishById(data.id)
  end
  if not isInit then
    EventManager:GetInstance():Broadcast(EventId.GF_land_lock_state_changed, {
      id = data.id,
      state = data.state
    })
  end
end

local function GetNoPutCountByXY(self, x, y)
  if self.noPutCountDict[x] == nil then
    return 0
  end
  return self.noPutCountDict[x][y] or 0
end

local function AddNoPutCountByXY(self, x, y)
  if self.noPutCountDict[x] == nil then
    self.noPutCountDict[x] = {}
  end
  if self.noPutCountDict[x][y] == nil then
    self.noPutCountDict[x][y] = 0
  end
  self.noPutCountDict[x][y] = self.noPutCountDict[x][y] + 1
end

local function SubNoPutCountByXY(self, x, y)
  if self.noPutCountDict[x] == nil or self.noPutCountDict[x][y] == nil then
    return
  end
  self.noPutCountDict[x][y] = self.noPutCountDict[x][y] - 1
  if self.noPutCountDict[x][y] <= 0 then
    self.noPutCountDict[x][y] = nil
  end
end

local function ConvertXYToPointId(self, x, y)
  local tilePos = {}
  tilePos.x = DataCenter.BuildManager.main_city_pos.x + x
  tilePos.y = DataCenter.BuildManager.main_city_pos.y + y
  return SceneUtils.TilePosToIndex(tilePos)
end

local function ConvertPointIdToXY(self, pointId)
  local tilePos = SceneUtils.IndexToTilePos(pointId)
  local x = tilePos.x - DataCenter.BuildManager.main_city_pos.x
  local y = tilePos.y - DataCenter.BuildManager.main_city_pos.y
  return x, y
end

local function CheckLandLockConditionById(self, id)
  local data = self:GetLandLockDataById(id)
  if data == nil then
    return LandLockCondition.Unknown
  end
  local template = self:GetTemplate(id)
  if data.state == LandLockState.Locked then
    for _, v in ipairs(template.needBuild) do
      local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(v.buildId, true)
      if buildData == nil or buildData.level < v.level then
        return LandLockCondition.NeedBuilding, v
      end
    end
    local curChapter = DataCenter.ChapterTaskManager:GetCurChapterId() or 0
    if curChapter < template.needChapter then
      return LandLockCondition.NeedChapter, template.needChapter
    end
    for _, priorId in ipairs(template.priorList) do
      local priorData = self:GetLandLockDataById(priorId)
      if priorData ~= nil and priorData.state ~= LandLockState.Finished then
        return LandLockCondition.NeedPrior, priorId
      end
    end
    if data.needPay and not data.paid then
      for resourceType, count in pairs(template.costResource) do
        local resCount = LuaEntry.Resource:GetCntByResType(resourceType)
        if count > resCount then
          return LandLockCondition.NeedResource, resourceType
        end
      end
      for itemId, count in pairs(template.costItem) do
        local itemData = DataCenter.ItemData:GetItemById(itemId)
        local itemCount = itemData and itemData.count or 0
        if count > itemCount then
          return LandLockCondition.NeedItem, itemId
        end
      end
      for itemId, count in pairs(template.costResourceItem) do
        local resItemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(itemId)
        local resItemCount = resItemData and resItemData.number or 0
        if count > resItemCount then
          return LandLockCondition.NeedResourceItem, itemId, count - resItemCount
        end
      end
      return LandLockCondition.ToPay
    elseif data:GetCurPve() ~= 0 then
      return LandLockCondition.ToPve
    end
  elseif data.state == LandLockState.Unlocked then
    return LandLockCondition.ToFinish
  end
  return LandLockCondition.Unknown
end

local function CheckLandLockPriorState(self, Id, state, isPve)
  local data
  if isPve then
    data = self:GetLandLockDataByPve(Id)
  else
    data = self:GetLandLockDataById(Id)
  end
  if data then
    for _, priorId in ipairs(data.priorList) do
      local priorData = self:GetLandLockDataById(priorId)
      if priorData ~= nil and priorData.state ~= state then
        return priorData
      end
    end
  end
  return data
end

local function StartPve(self, id)
  local data = self:GetLandLockDataById(id)
  if data == nil then
    return
  end
  local param = {}
  param.pveEntrance = PveEntrance.LandLock
  param.levelId = data:GetCurPve()
  param.id = id
  param.focusWorldPos = SceneUtils.TileIndexToWorld(data:GetCenterPointId())
  DataCenter.BattleLevel:Enter(param)
end

local function EnterPve(self, pve, abandon)
  local data = self:GetLandLockDataByPve(pve)
  if data == nil then
    return
  end
  local param = {}
  param.pveEntrance = PveEntrance.LandLock
  param.levelId = data:GetCurPve()
  param.id = data.id
  param.focusWorldPos = SceneUtils.TileIndexToWorld(data:GetCenterPointId())
  param.abandon = abandon
  DataCenter.BattleLevel:Enter(param)
end

local function CheckInitCompleted(self)
  if not (self.initServerData and self.initGuide) or not self.loadComplete then
    return
  end
  for id, _ in pairs(self.landLockDataDict) do
    local infoList = DataCenter.GuideTemplateManager:GetLandLockAlters(id)
    if infoList then
      local dict = {}
      for _, info in ipairs(infoList) do
        local guideId = info.guideId
        local alter = info.alter
        if guideId ~= 0 and DataCenter.GuideManager:IsDoneThisGuide(guideId) then
          local firstName = self:ParseAlter(alter)
          dict[firstName] = alter
        end
      end
      for firstName, alter in pairs(dict) do
        local _, secondName, options = self:ParseAlter(alter)
        if table.hasvalue(options, "next") then
          table.removebyvalue(options, "next")
          secondName = toInt(secondName + 1)
        end
        if not table.hasvalue(options, "hide") then
          self:DoAlterDetail(id, firstName, secondName, options)
        end
      end
    end
  end
  if ENABLE_VISUAL then
    self:RefreshAllObject()
  end
end

local function FinishById(self, id, ignoreState)
  local data = self:GetLandLockDataById(id)
  if data == nil or data.state ~= LandLockState.Unlocked and not ignoreState then
    return
  end
  if self.objectDict[id] ~= nil then
    self.objectDict[id]:PlayFinishAnim(function()
      if data.state ~= LandLockState.Finished then
        SFSNetwork.SendMessage(MsgDefines.FinishUserLand, id)
      end
    end)
  elseif data.state ~= LandLockState.Finished then
    SFSNetwork.SendMessage(MsgDefines.FinishUserLand, id)
  end
end

local function IsArmyEnough(self, id)
  local template = self:GetTemplate(id)
  if template == nil or template.needArmy == nil then
    return true
  end
  local haveCount = 0
  local data = DataCenter.ArmyManager:GetTotalMarchAndFreeArmyNum()
  if data ~= nil then
    for k, v in pairs(data) do
      if 0 < v then
        haveCount = haveCount + v
      end
    end
  end
  return haveCount >= template.needArmy.count
end

local function IsLandLockNeedLowestPower(self, id)
  local data = self:GetLandLockDataById(id)
  if data == nil then
    return false
  end
  local power = data:GetCurPveNeedPower()
  if power == 0 then
    return false
  end
  for _, tData in ipairs(self:GetLandLockDataListByState(LandLockState.Locked)) do
    local tPower = tData:GetCurPveNeedPower()
    if 0 < tPower and power > tPower then
      return false
    end
  end
  return true
end

local function PlayUnlockEffect(self, id)
  local data = self:GetLandLockDataById(id)
  local template = DataCenter.LandLockManager:GetTemplate(id)
  local pos = data:GetCenterWorldPos()
  local scaleX = (template.rect.right - template.rect.left + 1) * GroundSizeScale
  local scaleZ = (template.rect.top - template.rect.bottom + 1) * GroundSizeScale
  local req = Resource:InstantiateAsync(UnlockEffectPrefabPath)
  req:completed("+", function(req)
    if req.isError then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local tf = go.transform
    go:SetActive(true)
    tf.localScale = Vector3.New(scaleX, 1, scaleZ)
    tf.position = Vector3.New(pos.x, pos.y + 1, pos.z)
    TimerManager:GetInstance():DelayInvoke(function()
      if req then
        req:Destroy()
      end
    end, 2)
  end)
  if 4 < id then
    DataCenter.CityZoneMgr:UnlockZone(id)
  end
end

local function DoAlter(self, id, alter)
  print("beef DoAlter id: " .. id .. ", alter: " .. alter)
  local data = self:GetLandLockDataById(id)
  table.insert(data.alters, alter)
  if ENABLE_VISUAL then
    self:RefreshObject(id)
    EventManager:GetInstance():Broadcast(EventId.LandLockStateUpdate, data:GetPointId())
  end
end

local function DoAlterDetail(self, id, firstName, secondName, options)
  if table.IsNullOrEmpty(options) then
    self:DoAlter(id, firstName .. "_" .. secondName)
  else
    self:DoAlter(id, firstName .. "_" .. secondName .. "_" .. string.join(options, "_"))
  end
end

local function ParseAlter(self, alter)
  local spls = string.split(alter, "_")
  local firstName = spls[1]
  local secondName = spls[2]
  local options = {}
  if 3 <= #spls then
    for i = 3, #spls do
      table.insert(options, spls[i])
    end
  end
  return firstName, secondName, options
end

local function RefreshAll(self)
  self:RefreshAllObject()
  self:RefreshAllReward(false)
end

local function DestroyAll(self)
  self:DestroyAllObject()
  self:DestroyAllReward()
end

local function CanShowObject(self)
  return not DataCenter.CityPioneerManager:IsBeforePrologue() and DataCenter.CityDomeManager:GetDomeRangeCache() ~= DomeRange.Zero and CS.SceneManager.IsInCity() and CS.SceneManager.World ~= nil
end

local function RefreshAllObject(self)
  if not ENABLE_VISUAL then
    return
  end
  for id, _ in pairs(self.landLockDataDict) do
    self:RefreshObject(id)
  end
end

local function DestroyAllObject(self)
  for id, _ in pairs(self.objectDict) do
    self:DestroyObject(id)
  end
end

local function RefreshObject(self, id)
  if not ENABLE_VISUAL then
    return
  end
  if not self:CanShowObject() then
    return
  end
  if id == SEASON_BUILD_GROUND_ID then
    return
  end
  local data = self:GetLandLockDataById(id)
  local template = self:GetTemplate(id)
  if template.domeRange <= DataCenter.CityDomeManager:GetDomeLevel() then
    if self.objectDict[id] ~= nil then
      if data.state == LandLockState.Hide or data.state == LandLockState.Locked or data.state == LandLockState.Unlocked then
        self.objectDict[id]:Refresh()
        EventManager:GetInstance():Broadcast(EventId.LandLockInView, id)
      elseif data.state == LandLockState.Finished then
        self:DestroyObject(id)
      end
    elseif data.state == LandLockState.Hide or data.state == LandLockState.Locked or data.state == LandLockState.Unlocked then
      self:CreateObject(id)
      EventManager:GetInstance():Broadcast(EventId.LandLockInView, id)
    end
  else
    self:DestroyObject(id)
  end
end

local function CreateObject(self, id)
  if not ENABLE_VISUAL then
    return
  end
  if self.objectDict[id] ~= nil then
    return
  end
  local data = self:GetLandLockDataById(id)
  local template = self:GetTemplate(id)
  local req = Resource:InstantiateAsync(string.format(ObjectPrefabPath, template.prefabName))
  req:completed("+", function()
    if req.isError or not self:CanShowObject() then
      req:Destroy()
      self.objectDict[id] = nil
      return
    end
    local tilePos = data.pos + DataCenter.BuildManager.main_city_pos
    local go = req.gameObject
    if not go then
      return
    end
    local tf = go.transform
    go:SetActive(true)
    go.name = string.format("LandLock_%02d", id)
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    tf.position = SceneUtils.TileToWorld(tilePos)
    self.objectDict[id]:Create(data)
  end)
  local obj = LandLockObject.New(req)
  self.objectDict[id] = obj
end

local function DestroyObject(self, id)
  if self.objectDict[id] == nil then
    return
  end
  self.objectDict[id]:Destroy()
  self.objectDict[id] = nil
  EventManager:GetInstance():Broadcast(EventId.LandLockOutView, id)
end

local function RefreshAllReward(self, isInit)
  if not ENABLE_VISUAL then
    return
  end
  for id, _ in pairs(self.landLockDataDict) do
    self:RefreshReward(id, isInit)
  end
end

local function DestroyAllReward(self)
  for id, _ in pairs(self.rewardDict) do
    self:DestroyReward(id)
  end
end

local function RefreshReward(self, id, isInit)
  if not ENABLE_VISUAL then
    return
  end
  if CS.SceneManager.IsInPVE() or CS.SceneManager.World == nil then
    return
  end
  local data = self:GetLandLockDataById(id)
  if data == nil then
    local param = {}
    param.id = id
    DataCenter.GuideManager:SetCompleteNeedParam(param)
    DataCenter.GuideManager:CheckGuideComplete()
    return
  end
  if data:HasReward(LandLockRewardType.Chest) then
    local autoOpen = false
    if not isInit then
      if CS.SceneManager:IsInCity() then
        local pointType = DataCenter.CityPointManager:GetPointType(data:GetPointId())
        if pointType == CityPointType.Building then
          autoOpen = true
        end
      else
        local pointType = CS.SceneManager.World:GetPointType(data:GetPointId())
        if pointType == WorldPointType.PlayerBuilding then
          autoOpen = true
        end
      end
    end
    if autoOpen then
      SFSNetwork.SendMessage(MsgDefines.ReceiveLandReward, id)
      self:DestroyReward(id)
    else
      self:CreateReward(id)
    end
  elseif data:HasReward(LandLockRewardType.Call) then
    self:CreateReward(id)
  else
    local param = {}
    param.id = id
    DataCenter.GuideManager:SetCompleteNeedParam(param)
    DataCenter.GuideManager:CheckGuideComplete()
    self:DestroyReward(id)
  end
end

local function CreateReward(self, id)
  if not ENABLE_VISUAL then
    return
  end
  do return end
  local data = self:GetLandLockDataById(id)
  local pointId = data:GetPointId()
  local prefab = self:GetRewardPrefabPath(data.rewardType)
  local rewardItem = LandLockReward.New()
  local req = Resource:InstantiateAsync(prefab)
  req:completed("+", function()
    if req.isError then
      req:Destroy()
      self.rewardDict[id] = nil
      return
    end
    local go = req.gameObject
    local tf = go.transform
    go:SetActive(true)
    go.name = "LandLockReward_" .. id
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    tf.position = SceneUtils.TileIndexToWorld(pointId)
    rewardItem:OnCreate(data.rewardType)
  end)
  rewardItem:Init(id)
  rewardItem:SetReq(req)
  rewardItem:SetOnClick(function()
    self:ClickReward(id)
  end)
  self.rewardDict[id] = rewardItem
end

local function DestroyReward(self, id)
  local rewardItem = self.rewardDict[id]
  if rewardItem ~= nil then
    rewardItem:OnDestroy()
    self.rewardDict[id] = nil
  end
end

local function ClickReward(self, id)
  print("Beef ClickReward " .. id)
  local data = self:GetLandLockDataById(id)
  local template = self:GetTemplate(id)
  local resItemCount = 0
  for _, reward in ipairs(template.showRewards) do
    if reward.type == RewardType.RESOURCE_ITEM then
      resItemCount = resItemCount + reward.count
    end
  end
  if 0 < resItemCount and DataCenter.ResourceItemDataManager:CheckIsStorageFull(resItemCount) then
    GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
    return
  end
  if data.rewardCount == template.rewardInitCount then
    SFSNetwork.SendMessage(MsgDefines.ReceiveLandReward, id)
  else
    self:PlayReceive(id)
  end
end

local function GetRewardGameObject(self, id)
  if self.rewardDict[id] ~= nil then
    return self.rewardDict[id]:GetGameObject()
  end
end

local function GetReward(self, id)
  return self.rewardDict[id]
end

local function GetRewardPrefabPath(self, rewardType)
  if rewardType == LandLockRewardType.Chest then
    return "Assets/Main/Prefabs/World/LandLockChest.prefab"
  elseif rewardType == LandLockRewardType.Call then
    return "Assets/Main/Prefabs/World/LandLockCall.prefab"
  else
    return nil
  end
end

local function CreateBoard(self, param)
  local pointId = param.pointId
  local req = Resource:InstantiateAsync(UIAssets.LandLockBoard)
  req:completed("+", function()
    if req.isError then
      req:Destroy()
      return
    end
    go = req.gameObject
    tf = go.transform
    go:SetActive(true)
    go.name = "LandLockBoard"
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    tf.position = SceneUtils.TileIndexToWorld(pointId) + Vector3.New(0, 6, 0)
    local boardItem = LandLockBoard.New()
    boardItem:OnCreate(req)
    boardItem:SetParam(param.rewardInfo)
    boardItem:Fly()
  end)
end

local function CreateReceive(self, id, rewardType)
  local data = self:GetLandLockDataById(id)
  local receiveItem = LandLockReceive.New()
  if rewardType == RewardType.ARM then
    receiveItem:Init(id, data:GetPointId(), LandLockRewardType.CallSoldier)
  else
    receiveItem:Init(id, data:GetPointId(), LandLockRewardType.CallChest)
  end
  receiveItem:PlayFall()
end

local function PlayReceive(self, id)
  local data = self:GetLandLockDataById(id)
  local template = self:GetTemplate(id)
  if data.rewardCount <= 0 then
    return
  end
  local rewardDelay = 0.1
  if data.rewardType == LandLockRewardType.Call then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(data.rewardCache) or {}
    local list = {}
    local totalNum = 0
    for _, v in ipairs(rewardList) do
      totalNum = totalNum + v.count
    end
    local gotCount = template.rewardInitCount - data.rewardCount
    local perNum = totalNum // template.rewardInitCount
    local gotNum = perNum * gotCount
    local curNum = data.rewardCount > 1 and perNum or totalNum - gotNum
    for _, v in ipairs(rewardList) do
      local num = v.count
      if 0 < gotNum then
        local consumeNum = math.min(num, gotNum)
        num = num - consumeNum
        gotNum = gotNum - consumeNum
      end
      if 0 < num then
        local consumeNum = math.min(num, curNum)
        num = num - consumeNum
        curNum = curNum - consumeNum
        local u = DeepCopy(v)
        u.count = consumeNum
        table.insert(list, u)
      end
      if curNum <= 0 then
        break
      end
    end
    if not table.IsNullOrEmpty(list) then
      for i, rewardInfo in ipairs(list) do
        local count = 1
        local countStrs = string.split(LuaEntry.DataConfig:TryGetStr("land_unlock", "k6") or "", ";")
        if #countStrs == 2 then
          local min = tonumber(countStrs[1]) or 0
          local max = tonumber(countStrs[2]) or 0
          if min <= max then
            count = math.random(min, max)
          end
        end
        if i == 1 then
          for j = 1, count do
            self:CreateReceive(id, rewardInfo.rewardType)
          end
        end
        local param = {}
        param.pointId = data:GetPointId()
        param.rewardInfo = rewardInfo
        TimerManager:GetInstance():DelayInvoke(function()
          self:CreateBoard(param)
        end, 0.5 * (i - 1))
      end
      rewardDelay = 3
    end
  end
  data.rewardCount = data.rewardCount - 1
  if data.rewardCount == 0 then
    TimerManager:GetInstance():DelayInvoke(function()
      if not CS.SceneManager.IsInPVE() then
        DataCenter.RewardManager:ShowGiftReward({
          reward = data.rewardCache
        }, Localization:GetString("128027"))
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.LandLockReceiveReward, tostring(id))
      end
    end, rewardDelay)
  end
  self:RefreshReward(id, false)
  EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_call_reward, false)
end

local function OnPveLevelEnter(levelId)
  DataCenter.LandLockManager:DestroyAll()
end

local function OnPveLevelExit(levelId)
  if levelId ~= nil then
    local old_land_id = math.floor(levelId / 1000) + 4
    local data = DataCenter.LandLockManager:GetLandLockDataById(old_land_id)
    if data ~= nil then
      local pointId = data:GetCenterPointId()
      local pos = SceneUtils.TileIndexToWorld(pointId)
      GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, 0)
      local new_land_id = math.floor(DataCenter.StageManager.stageId / 1000) + 4
      if old_land_id ~= new_land_id then
        DataCenter.LandLockManager:RefreshAll()
        DataCenter.LandLockManager:HideLandLockBubble(old_land_id)
        TimerManager:GetInstance():DelayInvoke(function()
        end, 2)
        return
      end
    end
  end
  DataCenter.LandLockManager:RefreshAll()
end

local function OnEnterCity()
  DataCenter.LandLockManager:RefreshAll()
end

local function RefreshLandlockDataAndReward()
  DataCenter.LandLockManager:RefreshAllData(false)
  DataCenter.LandLockManager:RefreshAllReward(false)
end

local function OnBuildLevelUpOrMove(info)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(info.uuid)
  if buildData then
    local buildId = buildData.itemId
    if not info.fromReload then
      DataCenter.LandLockManager:RefreshAllData(false)
      DataCenter.LandLockManager:RefreshAllReward(false)
    end
    DataCenter.LandLockBubbleManager:OnBuildLevelUpOrMove(buildId)
  end
end

local function OnUpdateTask()
  if CS.SceneManager.World == nil then
    return
  end
  DataCenter.LandLockManager:RefreshAllData(false)
  DataCenter.LandLockManager:RefreshAllReward(false)
  DataCenter.LandLockBubbleManager:OnTaskUpdate()
end

local function OnGuideInitFinish()
  DataCenter.LandLockManager.initGuide = true
  DataCenter.LandLockManager:CheckInitCompleted()
end

local function OnLandLockTimeLineFinish(self, id, alter)
  print("beef OnLandLockTimeLineFinish id: " .. id .. ", alter: " .. alter)
  local data = self:GetLandLockDataById(id)
  local firstName, secondName, options = self:ParseAlter(alter)
  if table.hasvalue(options, "finish") then
    if data.state == LandLockState.Unlocked then
      self:FinishById(id)
    end
  elseif table.hasvalue(options, "next") then
    table.removebyvalue(options, "next")
    self:DoAlterDetail(id, firstName, toInt(secondName + 1), options)
  elseif table.hasvalue(options, "hide") then
    self:DoAlterDetail(id, firstName, -1)
  end
end

local function OnDomeRangeChanged()
  DataCenter.LandLockManager:RefreshAll()
end

local function OnLoadComplete()
  DataCenter.LandLockManager.loadComplete = true
  DataCenter.LandLockManager:CheckInitCompleted()
end

local function OnFinishPve(self, pve)
  local data = self:GetLandLockDataByPve(pve)
  if data == nil then
    return
  end
  data.pveFinishDict[pve] = true
end

local function InitHandle(self, message)
  self:RefreshEnableVisual()
  if message.lands then
    for _, serverData in ipairs(message.lands) do
      self:RefreshDataByServer(serverData, true)
    end
    EventManager:GetInstance():Broadcast(EventId.LandLockInit)
  end
  self.landEggs = message.landEggs
  self:RefreshAllData(true)
  self.initServerData = true
  self:CheckInitCompleted()
end

local function UnlockHandle(self, message)
  if message.landId then
    local serverData = message
    self:RefreshDataByServer(serverData, false)
    EventManager:GetInstance():Broadcast(EventId.GF_land_unlock_done, message.landId)
  end
end

local function FinishHandle(self, message)
  if message.landId then
    local id = message.landId
    local serverData = message
    self:RefreshDataByServer(serverData, false)
    for _, data in ipairs(self.landLockDataDict) do
      if DataCenter.LandLockBubbleManager:CanShowBubbleStateHide(data.id) then
        DataCenter.LandLockBubbleManager:CreateBubble(data.id)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
    EventManager:GetInstance():Broadcast(EventId.Unlandlock, id)
    local workerList = {}
    local rewardMessage = message.rewardArr
    if rewardMessage ~= nil then
      for i = #rewardMessage, 1, -1 do
        local messageType = rewardMessage[i].type
        if messageType == RewardType.WORKER then
          table.insert(workerList, rewardMessage[i].value.workerUid)
          table.remove(rewardMessage, i)
        elseif messageType == RewardType.VISITOR then
          table.remove(rewardMessage, i)
        end
      end
    end
    DataCenter.GainWorkerManager:ShowLandLockWorker(workerList, self:GetLandLockDataById(id):GetCenterWorldPos())
    UIUtil.ShowTipsId(120093)
    self:PlayUnlockEffect(id)
    if rewardMessage and 0 < #rewardMessage then
      DataCenter.RewardManager:AddRewardsAndRes({reward = rewardMessage})
      if not self.landLockDataDict[id].hideRewardPop then
        DataCenter.RewardManager:ShowCommonReward({reward = rewardMessage})
      end
    end
    DataCenter.MonopolyManager.performanceManager:RunTrigger(MonopolyPerformanceTriggerEvent.ClaimLandReward, id)
  end
end

local function PushUnlockHandle(self, message)
  if message.lands then
    for _, serverData in ipairs(message.lands) do
      self:RefreshDataByServer(serverData, false)
    end
  end
end

local function ReceiveLandRewardHandle(self, message)
  if message.landId then
    local id = message.landId
    local data = self:GetLandLockDataById(id)
    if message.rewardArr then
      DataCenter.RewardManager:AddRewards(message.rewardArr)
    end
    if message.rewardInfo then
      for _, info in ipairs(message.rewardInfo) do
        if info.type == RewardType.HERO and info.value ~= nil and info.value.id ~= nil and info.value.uuid == nil then
          info.value.uuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(info.value.id)
        end
      end
      data.rewardCache = message.rewardInfo
    end
    self:PlayReceive(id)
  end
end

local function GetLandLockObj(self, id)
  return self.objectDict[id]
end

local function GetCurrentToBeUnlockedId(self)
  for id, data in pairs(self.landLockDataDict) do
    if data.state == LandLockState.Locked then
      return id
    end
  end
end

local function HideLandLockBubble(self, id)
  if self.objectDict[id] then
    self.objectDict[id]:HideBubbleTf()
  end
end

local function DebugClick(self, pointId)
  local x, y = self:ConvertPointIdToXY(pointId)
  print("Tile x: " .. x .. ", y: " .. y .. ", \231\166\129\230\148\190\229\187\186\231\173\145\232\174\161\230\149\176: " .. self:GetNoPutCountByXY(x, y))
  for _, template in pairs(self.templateDict) do
    local id = template.id
    local data = self:GetLandLockDataById(id)
    for _, tile in ipairs(template.tileList) do
      if tile.x == x and tile.y == y then
        print("land lock id: " .. data.id .. ", state = " .. data.state)
      end
    end
  end
end

local function DebugPrint(self)
  local hideList = {}
  local lockedList = {}
  local unlockedList = {}
  local finishedList = {}
  for _, data in pairs(self.landLockDataDict) do
    if data.state == LandLockState.Hide then
      table.insert(hideList, data.id)
    elseif data.state == LandLockState.Locked then
      table.insert(lockedList, data.id)
    elseif data.state == LandLockState.Unlocked then
      table.insert(unlockedList, data.id)
    elseif data.state == LandLockState.Finished then
      table.insert(finishedList, data.id)
    end
  end
  table.sort(hideList)
  table.sort(lockedList)
  table.sort(unlockedList)
  table.sort(finishedList)
  self:GetCurrentToBeUnlockedId()
  print("beef Hide: " .. string.join(hideList, ", "))
  print("beef Locked: " .. string.join(lockedList, ", "))
  print("beef Unlocked: " .. string.join(unlockedList, ", "))
  print("beef Finished: " .. string.join(finishedList, ", "))
end

function LandLockManager:GetLandLockDataByCityZoneId(zoneId)
  local id = self.zoneToLandDict[zoneId]
  if id then
    return self.landLockDataDict[id]
  end
  return nil
end

function LandLockManager:OnReceiveLandEggReward(landId)
  if self.landEggs == nil then
    self.landEggs = {}
  end
  table.insert(self.landEggs, landId)
end

function LandLockManager:CanGetLandEggReward(landId)
  if self.landEggs then
    for i, v in ipairs(self.landEggs) do
      if v == landId then
        return false
      end
    end
  end
  return true
end

function LandLockManager:RefreshEnableVisual()
  if DataCenter.LWCivilizationSparkExtend:UseCivilizationSparkGuide() then
    ENABLE_VISUAL = false
  else
    ENABLE_VISUAL = true
  end
end

LandLockManager.__init = __init
LandLockManager.__delete = __delete
LandLockManager.AddListeners = AddListeners
LandLockManager.RemoveListeners = RemoveListeners
LandLockManager.Enabled = Enabled
LandLockManager.RefreshAllData = RefreshAllData
LandLockManager.RefreshData = RefreshData
LandLockManager.RefreshDataByServer = RefreshDataByServer
LandLockManager.GetTemplate = GetTemplate
LandLockManager.GetLandLockDataById = GetLandLockDataById
LandLockManager.GetLandLockDataByPointId = GetLandLockDataByPointId
LandLockManager.GetLandLockDataByPve = GetLandLockDataByPve
LandLockManager.GetLandLockDataListByState = GetLandLockDataListByState
LandLockManager.ClickLandLockById = ClickLandLockById
LandLockManager.EnterLandLockById = EnterLandLockById
LandLockManager.CanBuildByPointId = CanBuildByPointId
LandLockManager.IsLandLockInDome = IsLandLockInDome
LandLockManager.SetLandLockState = SetLandLockState
LandLockManager.GetNoPutCountByXY = GetNoPutCountByXY
LandLockManager.AddNoPutCountByXY = AddNoPutCountByXY
LandLockManager.SubNoPutCountByXY = SubNoPutCountByXY
LandLockManager.ConvertXYToPointId = ConvertXYToPointId
LandLockManager.ConvertPointIdToXY = ConvertPointIdToXY
LandLockManager.CheckLandLockConditionById = CheckLandLockConditionById
LandLockManager.CheckLandLockPriorState = CheckLandLockPriorState
LandLockManager.StartPve = StartPve
LandLockManager.EnterPve = EnterPve
LandLockManager.CheckInitCompleted = CheckInitCompleted
LandLockManager.FinishById = FinishById
LandLockManager.IsArmyEnough = IsArmyEnough
LandLockManager.IsLandLockNeedLowestPower = IsLandLockNeedLowestPower
LandLockManager.MoveCameraToLand = MoveCameraToLand
LandLockManager.PlayUnlockEffect = PlayUnlockEffect
LandLockManager.GetAlllandLockData = GetAlllandLockData
LandLockManager.GetLandLockObj = GetLandLockObj
LandLockManager.GetCurrentToBeUnlockedId = GetCurrentToBeUnlockedId
LandLockManager.HideLandLockBubble = HideLandLockBubble
LandLockManager.GetFinishLandLockData = GetFinishLandLockData
LandLockManager.DoAlter = DoAlter
LandLockManager.DoAlterDetail = DoAlterDetail
LandLockManager.ParseAlter = ParseAlter
LandLockManager.RefreshAll = RefreshAll
LandLockManager.DestroyAll = DestroyAll
LandLockManager.CanShowObject = CanShowObject
LandLockManager.RefreshAllObject = RefreshAllObject
LandLockManager.DestroyAllObject = DestroyAllObject
LandLockManager.RefreshObject = RefreshObject
LandLockManager.CreateObject = CreateObject
LandLockManager.DestroyObject = DestroyObject
LandLockManager.RefreshAllReward = RefreshAllReward
LandLockManager.DestroyAllReward = DestroyAllReward
LandLockManager.RefreshReward = RefreshReward
LandLockManager.CreateReward = CreateReward
LandLockManager.DestroyReward = DestroyReward
LandLockManager.ClickReward = ClickReward
LandLockManager.GetRewardGameObject = GetRewardGameObject
LandLockManager.GetReward = GetReward
LandLockManager.GetRewardPrefabPath = GetRewardPrefabPath
LandLockManager.CreateBoard = CreateBoard
LandLockManager.CreateReceive = CreateReceive
LandLockManager.PlayReceive = PlayReceive
LandLockManager.OnPveLevelEnter = OnPveLevelEnter
LandLockManager.OnPveLevelExit = OnPveLevelExit
LandLockManager.OnEnterCity = OnEnterCity
LandLockManager.RefreshLandlockDataAndReward = RefreshLandlockDataAndReward
LandLockManager.OnBuildLevelUpOrMove = OnBuildLevelUpOrMove
LandLockManager.OnUpdateTask = OnUpdateTask
LandLockManager.OnGuideInitFinish = OnGuideInitFinish
LandLockManager.OnLandLockTimeLineFinish = OnLandLockTimeLineFinish
LandLockManager.OnDomeRangeChanged = OnDomeRangeChanged
LandLockManager.OnLoadComplete = OnLoadComplete
LandLockManager.OnFinishPve = OnFinishPve
LandLockManager.InitHandle = InitHandle
LandLockManager.UnlockHandle = UnlockHandle
LandLockManager.FinishHandle = FinishHandle
LandLockManager.PushUnlockHandle = PushUnlockHandle
LandLockManager.ReceiveLandRewardHandle = ReceiveLandRewardHandle
LandLockManager.DebugClick = DebugClick
LandLockManager.DebugPrint = DebugPrint
return LandLockManager
