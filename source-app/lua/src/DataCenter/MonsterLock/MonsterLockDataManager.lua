local MonsterLockDataManager = BaseClass("MonsterLockDataManager")
local MonsterLockData = require("DataCenter.MonsterLock.MonsterLockData")
local LandLockReward = require("DataCenter.LandLock.LandLockReward")
local LandLockReceive = require("DataCenter.LandLock.LandLockReceive")
local LandLockBoard = require("DataCenter.LandLock.LandLockBoard")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.allMonster = {}
  self.chestDict = {}
  self:AddListeners()
end

local function __delete(self)
  self.allMonster = nil
  self.chestDict = nil
  self:RemoveListeners()
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnPveLevelEnter)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnPveLevelExit)
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.OnUpdateBuildData)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.OnUpdateLod)
  EventManager:GetInstance():AddListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
  EventManager:GetInstance():AddListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
  EventManager:GetInstance():AddListener(EventId.OnQuitCrossServer, self.OnQuitCrossServer)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnPveLevelEnter)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnPveLevelExit)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.OnUpdateBuildData)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.OnUpdateLod)
  EventManager:GetInstance():RemoveListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.OnEnterCrossServer)
  EventManager:GetInstance():RemoveListener(EventId.OnQuitCrossServer, self.OnQuitCrossServer)
end

local function OnPveLevelEnter(levelId)
  DataCenter.MonsterLockDataManager:DestroyAllChest()
end

local function GetMosnterLockDataByPve(self, levelId)
  for k, data in pairs(self.allMonster) do
    local template = DataCenter.MonsterLockTemplateManager:GetTemplate(k)
    if template.pve == tonumber(levelId) then
      return data
    end
  end
  return nil
end

local function OnPveLevelExit(levelId)
  local data = DataCenter.MonsterLockDataManager:GetMosnterLockDataByPve(levelId)
  if data ~= nil then
    local pointId = data.pointId
    local pos = SceneUtils.TileIndexToWorld(pointId)
    GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, 0)
  end
  DataCenter.MonsterLockDataManager:RefreshAllChest(false)
end

local function OnUpdateBuildData(bUuid)
end

local function OnUpdateLod(lod)
  if lod <= 1 then
    DataCenter.MonsterLockDataManager:RefreshAllChest(false)
  else
    DataCenter.MonsterLockDataManager:DestroyAllChest()
  end
end

local function InitDatas(self, message)
  self.allMonster = {}
  self:UpdateAllMonster(message)
  DataCenter.MonsterLockBubbleManager:Startup()
end

local function UpdateAllMonster(self, message)
  if message.pveMonsters ~= nil then
    table.walk(message.pveMonsters, function(_, v)
      self:UpdateOneMonster(v)
    end)
    EventManager:GetInstance():Broadcast(EventId.MonsterLockStateUpdate)
  end
end

local function UpdateOneMonster(self, data)
  if data == nil or data.pveMonsterId == nil then
    return
  end
  local pveMonsterId = data.pveMonsterId
  if self.allMonster[pveMonsterId] == nil then
    self.allMonster[pveMonsterId] = MonsterLockData.New()
  end
  self.allMonster[pveMonsterId]:ParseData(data)
end

local function GetMonsterData(self, pveMonsterId)
  return self.allMonster[pveMonsterId]
end

local function GetMonsterDataByPointIndex(self, pointId)
  if pointId == 0 then
    return nil
  end
  local pt = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  for _, v in pairs(self.allMonster) do
    local template = DataCenter.MonsterLockTemplateManager:GetTemplate(v.monsterId)
    local indexX = 0
    local vec = {}
    while indexX < template.sizeX do
      local indexY = 0
      while indexY < template.sizeY do
        table.insert(vec, SceneUtils.TileXYToIndex(pt.x + indexX, pt.y + indexY))
        indexY = indexY + 1
      end
      indexX = indexX + 1
    end
    for _, k in pairs(vec) do
      if v.pointId == k then
        if k ~= pointId and v.state == MonsterLockState.Finished and v.rewardRemain ~= nil and 0 < v.rewardRemain then
          return nil
        end
        if v.state == MonsterLockState.Finished and (v.rewardRemain == nil or 0 >= v.rewardRemain) then
          return nil
        end
        return v
      end
    end
  end
  return nil
end

local function GetAllMonsterData(self)
  return self.allMonster
end

local function EnterLandLockById(self, id)
  local data = self:GetMonsterData(id)
  if data == nil then
    return
  end
  local result, ret1, ret2 = self:CheckLandLockConditionById(id)
  if result == LandLockCondition.ToPve then
    self:StartPve(id)
  elseif result == LandLockCondition.NeedResourceItem then
    local resItemId = ret1
    local name = LocalController:instance():getValue(TableName.Aps_Resource_Item, resItemId, "name")
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Item
    param.itemId = ret1
    param.targetNum = ret2
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
    UIUtil.ShowTips(Localization:GetString(126002, Localization:GetString(name)))
  end
end

local function ClickMonsterLockById(self, id)
  local data = self:GetMonsterData(id)
  if data == nil or data.state == 2 then
    return
  end
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  local bubble = DataCenter.MonsterLockBubbleManager:GetMonsterLockBubble(id)
  if bubble == nil then
    DataCenter.MonsterLockBubbleManager:CreateBubble(id)
  end
  DataCenter.MonsterLockBubbleManager:OnClickBubble(id)
end

local function CheckLandLockConditionById(self, id)
  local data = self:GetMonsterData(id)
  if data == nil then
    return LandLockCondition.Unknown
  end
  local template = DataCenter.MonsterLockTemplateManager:GetTemplate(id)
  if data.state == MonsterLockState.NOT_BUY then
    if data.needPay then
      for itemId, count in pairs(template.costResourceItem) do
        local resItemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(itemId)
        local resItemCount = resItemData and resItemData.number or 0
        if count > resItemCount then
          return LandLockCondition.NeedResourceItem, itemId, count - resItemCount
        end
      end
      return LandLockCondition.ToPve
    else
      return LandLockCondition.ToPve
    end
  elseif data.state == MonsterLockState.BUY then
    return LandLockCondition.ToPve
  end
  return LandLockCondition.Unknown
end

local function StartPve(self, id)
  local data = self:GetMonsterData(id)
  if data == nil then
    return
  end
  local template = DataCenter.MonsterLockTemplateManager:GetTemplate(id)
  local param = {}
  param.pveEntrance = PveEntrance.MonsterLock
  param.levelId = template.pve
  param.id = id
  Logger.Log("MonsterLockDataManager StartPve|", param.levelId)
  DataCenter.BattleLevel:Enter(param)
end

local function DoWhenReceiveMonsterRewardBack(self, message)
  if message.errorCode ~= nil then
    return
  end
  if message.pveMonsterId ~= nil then
    local id = message.pveMonsterId
    local data = self:GetMonsterData(id)
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

local function RefreshChest(self, id, isInit)
  local data = self:GetMonsterData(id)
  if data == nil then
    return
  end
  if data.state == MonsterLockState.Finished and data.rewardRemain > 0 then
    self:CreateChest(id)
  else
    self:DestroyChest(id)
  end
end

local function CreateChest(self, id)
  if self.chestDict[id] ~= nil then
    return
  end
  local data = self:GetMonsterData(id)
  if data == nil then
    return
  end
  local pointId = data.pointId
  if pointId == nil then
    return
  end
  local template = DataCenter.MonsterLockTemplateManager:GetTemplate(id)
  if template == nil then
    return
  end
  local chest = LandLockReward.New()
  local prefab = self:GetRewardPrefabPath(template.rewardType)
  local req = Resource:InstantiateAsync(prefab)
  req:completed("+", function()
    if req.isError then
      req:Destroy()
      self.reqDict[id] = nil
      return
    end
    local go = req.gameObject
    local tf = go.transform
    go:SetActive(true)
    go.name = "MonsterLockChest_" .. id
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    tf.position = SceneUtils.TileIndexToWorld(pointId)
    chest:OnCreate(template.rewardType)
  end)
  chest:Init(id)
  chest:SetReq(req)
  chest:SetOnClick(function()
    self:ClickChest(id)
  end)
  self.chestDict[id] = chest
end

local function DestroyChest(self, id)
  local chest = self.chestDict[id]
  if chest ~= nil then
    chest:OnDestroy()
    self.chestDict[id] = nil
  end
end

local function ClickChest(self, id)
  local data = self:GetMonsterData(id)
  local template = DataCenter.MonsterLockTemplateManager:GetTemplate(id)
  if data.rewardRemain == template.rewardInitCount then
    SFSNetwork.SendMessage(MsgDefines.ReceivePveMonsterReward, id)
  else
    self:PlayReceive(id)
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
    go.name = "MonsterLockBoard"
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
  local data = self:GetMonsterData(id)
  local receiveItem = LandLockReceive.New()
  if rewardType == RewardType.ARM then
    receiveItem:Init(id, data.pointId, LandLockRewardType.CallSoldier)
  else
    receiveItem:Init(id, data.pointId, LandLockRewardType.CallChest)
  end
  receiveItem:PlayFall()
end

local function RefreshAllChest(self, isInit)
  for id, _ in pairs(self.allMonster) do
    self:RefreshChest(id, isInit)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
end

local function DestroyAllChest(self)
  for id, _ in pairs(self.chestDict) do
    self:DestroyChest(id)
  end
end

local function GetAllMonsterExceptRewardData(self)
  local result = {}
  if CrossServerUtil:GetIsCrossServer() then
    return {}
  end
  table.walk(self.allMonster, function(k, v)
    if v.state ~= 2 then
      result[k] = v
    end
  end)
  return result
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

local function RemoveLockData(self, id)
  if self.allMonster[id] ~= nil then
    DataCenter.MonsterLockBubbleManager:DestroyBubble(id)
    self.allMonster[id] = nil
    EventManager:GetInstance():Broadcast(EventId.MonsterLockStateUpdate)
  end
end

local function BuildMainZeroUpgradeSuccessSignal()
  local allMonster = DataCenter.MonsterLockDataManager:GetAllMonsterData()
  table.walk(allMonster, function(k, v)
    if v ~= nil then
      v:ReCalculatePointIndex()
      DataCenter.MonsterLockBubbleManager.OnMonsterUpdate(k)
    end
  end)
  TimerManager:DelayInvoke(function()
    EventManager:GetInstance():Broadcast(EventId.MonsterLockStateUpdate)
  end, 1.0)
end

local function PlayReceive(self, id)
  local data = self:GetMonsterData(id)
  local template = DataCenter.MonsterLockTemplateManager:GetTemplate(id)
  if data.rewardRemain <= 0 then
    return
  end
  local rewardDelay = 0.1
  if template.rewardType == LandLockRewardType.Call then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(data.rewardCache) or {}
    local list = {}
    local totalNum = 0
    for _, v in ipairs(rewardList) do
      totalNum = totalNum + v.count
    end
    local gotCount = template.rewardInitCount - data.rewardRemain
    local perNum = totalNum // template.rewardInitCount
    local gotNum = perNum * gotCount
    local curNum = data.rewardRemain > 1 and perNum or totalNum - gotNum
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
        param.pointId = data.pointId
        param.rewardInfo = rewardInfo
        TimerManager:GetInstance():DelayInvoke(function()
          self:CreateBoard(param)
        end, 0.5 * (i - 1))
      end
      rewardDelay = 3
    end
  end
  data.rewardRemain = data.rewardRemain - 1
  self:RefreshChest(id, false)
  if data.rewardRemain == 0 then
    self:RemoveLockData(id)
    TimerManager:GetInstance():DelayInvoke(function()
      if not CS.SceneManager.IsInPVE() then
        DataCenter.RewardManager:ShowGiftReward({
          reward = data.rewardCache
        }, Localization:GetString("128027"))
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.LandLockReceiveReward, tostring(id))
      end
    end, rewardDelay)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_call_reward, false)
end

local function OnEnterCrossServer()
  DataCenter.MonsterLockDataManager:DestroyAllChest()
end

local function OnQuitCrossServer()
  DataCenter.MonsterLockDataManager:RefreshAllChest(false)
end

MonsterLockDataManager.__init = __init
MonsterLockDataManager.__delete = __delete
MonsterLockDataManager.UpdateOneMonster = UpdateOneMonster
MonsterLockDataManager.GetMonsterData = GetMonsterData
MonsterLockDataManager.GetAllMonsterData = GetAllMonsterData
MonsterLockDataManager.InitDatas = InitDatas
MonsterLockDataManager.UpdateAllMonster = UpdateAllMonster
MonsterLockDataManager.GetMonsterDataByPointIndex = GetMonsterDataByPointIndex
MonsterLockDataManager.EnterLandLockById = EnterLandLockById
MonsterLockDataManager.CheckLandLockConditionById = CheckLandLockConditionById
MonsterLockDataManager.StartPve = StartPve
MonsterLockDataManager.ClickMonsterLockById = ClickMonsterLockById
MonsterLockDataManager.DoWhenReceiveMonsterRewardBack = DoWhenReceiveMonsterRewardBack
MonsterLockDataManager.CreateChest = CreateChest
MonsterLockDataManager.DestroyChest = DestroyChest
MonsterLockDataManager.ClickChest = ClickChest
MonsterLockDataManager.CreateBoard = CreateBoard
MonsterLockDataManager.CreateReceive = CreateReceive
MonsterLockDataManager.RefreshAllChest = RefreshAllChest
MonsterLockDataManager.DestroyAllChest = DestroyAllChest
MonsterLockDataManager.RefreshChest = RefreshChest
MonsterLockDataManager.AddListeners = AddListeners
MonsterLockDataManager.RemoveListeners = RemoveListeners
MonsterLockDataManager.OnPveLevelEnter = OnPveLevelEnter
MonsterLockDataManager.OnPveLevelExit = OnPveLevelExit
MonsterLockDataManager.OnUpdateBuildData = OnUpdateBuildData
MonsterLockDataManager.OnUpdateLod = OnUpdateLod
MonsterLockDataManager.GetMosnterLockDataByPve = GetMosnterLockDataByPve
MonsterLockDataManager.GetAllMonsterExceptRewardData = GetAllMonsterExceptRewardData
MonsterLockDataManager.GetRewardPrefabPath = GetRewardPrefabPath
MonsterLockDataManager.RemoveLockData = RemoveLockData
MonsterLockDataManager.BuildMainZeroUpgradeSuccessSignal = BuildMainZeroUpgradeSuccessSignal
MonsterLockDataManager.PlayReceive = PlayReceive
MonsterLockDataManager.OnEnterCrossServer = OnEnterCrossServer
MonsterLockDataManager.OnQuitCrossServer = OnQuitCrossServer
return MonsterLockDataManager
