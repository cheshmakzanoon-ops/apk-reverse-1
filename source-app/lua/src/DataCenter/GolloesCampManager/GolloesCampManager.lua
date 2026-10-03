local GolloesCampManager = BaseClass("GolloesCampManager")
local ResourceManager = CS.GameEntry.Resource
local GolloesExploringTimeTip = require("DataCenter.GolloesCampManager.GolloesExploreTimeTip")

local function __init(self)
  self.explorerState = 0
  self.traderState = 0
  self.freeSpeedTime = 0
  self.golloesNumDic = {}
  self.golloesRewardNumDic = {}
  self.exploringTimeTipDic = {}
  self.freeExploringTimeTipList = {}
  self.loadingTimeTipDic = {}
  self.lastClaimFreeTime = 0
  self:AddListener()
end

local function __delete(self)
  self.explorerState = nil
  self.traderState = nil
  self.freeSpeedTime = nil
  self.golloesNumDic = nil
  self.golloesRewardNumDic = nil
  self.exploringTimeTipDic = nil
  self.freeExploringTimeTipList = nil
  self.loadingTimeTipDic = nil
  self.lastClaimFreeTime = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.GarbageCollectStart, self.RefreshAllExploringTime)
  EventManager:GetInstance():AddListener(EventId.MarchItemUpdateSelf, self.RefreshAllExploringTime)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnEnterPveLevel)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnExitPveLevel)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.GarbageCollectStart, self.RefreshAllExploringTime)
  EventManager:GetInstance():RemoveListener(EventId.MarchItemUpdateSelf, self.RefreshAllExploringTime)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnEnterPveLevel)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnExitPveLevel)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function UpdateGolloesInfo(self, t)
  if not t then
    return
  end
  if not t.golloesData then
    return
  end
  local msg = t.golloesData
  if msg.freeSpeedNum then
    self.golloesNumDic[GolloesType.Worker] = msg.freeSpeedNum
  end
  if msg.statusNum then
    self.golloesNumDic[GolloesType.Warrior] = msg.statusNum
  end
  if msg.spyNum then
    self.golloesNumDic[GolloesType.Explorer] = msg.spyNum
  end
  if msg.caravanNum then
    self.golloesNumDic[GolloesType.Trader] = msg.caravanNum
  end
  if msg.spyRewardNum then
    self.golloesRewardNumDic[GolloesType.Explorer] = msg.spyRewardNum
  end
  if msg.caravanRewardNum then
    self.golloesRewardNumDic[GolloesType.Trader] = msg.caravanRewardNum
  end
  if msg.spyState then
    self.explorerState = msg.spyState
  end
  if msg.caravanState then
    self.traderState = msg.caravanState
  end
  if msg.freeSpeedTime then
    self.freeSpeedTime = msg.freeSpeedTime
  end
  if msg.lastReceiveTime then
    self.lastClaimFreeTime = msg.lastReceiveTime
  end
  EventManager:GetInstance():Broadcast(EventId.GolloesDataChange)
end

local function GetGolloesRewardNum(self, golloesType)
  return self.golloesRewardNumDic[golloesType] or 0
end

local function GetGolloesExplorerState(self)
  return self.explorerState
end

local function CheckIfCanClaimFreeGolloes(self)
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_GROCERY_STORE) then
    return false
  end
  local hasFree = LuaEntry.Effect:GetGameEffect(EffectDefine.HAS_UNCLAIMED_FREE_GOLLOES)
  if hasFree == 1 then
    local lastTimeS = math.modf(self.lastClaimFreeTime / 1000)
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local todayClaimed = UITimeManager:GetInstance():IsSameDayForServer(lastTimeS, serverTime)
    if not todayClaimed then
      return true
    end
  end
  return false
end

local function GetGolloesTradeState(self)
  return self.traderState
end

local function GetGolloesCount(self, golloesType)
  return self.golloesNumDic[golloesType] or 0
end

local function GetFreeSpeedTime(self)
  return self.freeSpeedTime or 0
end

local function GetFreeFormationByGolloesType(self, golloesType)
  local tempMarchType = golloesType == GolloesType.Explorer and NewMarchType.GOLLOES_EXPLORE or NewMarchType.GOLLOES_TRADE
  local golloesFormationList = DataCenter.ArmyFormationDataManager:GetGolloesFormationList()
  local marchNum = 0
  local freeIndex
  for i, v in ipairs(golloesFormationList) do
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, v.uuid, LuaEntry.Player.allianceId)
    if march then
      if march:GetMarchType() == tempMarchType then
        marchNum = marchNum + 1
      end
    elseif not freeIndex then
      freeIndex = i
      break
    end
  end
  local limitNum = 0
  if golloesType == GolloesType.Explorer then
    limitNum = LuaEntry.DataConfig:TryGetNum("golloes_dispatch_para", "k12")
  elseif golloesType == GolloesType.Trader then
    limitNum = LuaEntry.DataConfig:TryGetNum("golloes_dispatch_para", "k13")
  end
  if marchNum < limitNum and freeIndex then
    return true, golloesFormationList[freeIndex]
  else
    return false
  end
end

local function GetGolloesMarchByType(self, golloesType)
  local golloesFormationList = DataCenter.ArmyFormationDataManager:GetGolloesFormationList()
  if not golloesFormationList or #golloesFormationList == 0 then
    return
  end
  local freeFormationIndex = -1
  local tempMarchType = golloesType == GolloesType.Explorer and NewMarchType.GOLLOES_EXPLORE or NewMarchType.GOLLOES_TRADE
  for i, v in ipairs(golloesFormationList) do
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, v.uuid, LuaEntry.Player.allianceId)
    if march then
      if march:GetMarchType() == tempMarchType then
        return march, v
      end
    elseif freeFormationIndex == -1 then
      freeFormationIndex = i
    end
  end
  return nil, golloesFormationList[freeFormationIndex]
end

local function GetGolloesMarchEndTime(self, golloesType)
  local march = self:GetGolloesMarchByType(golloesType)
  if march then
    return march.endTime
  end
end

local function RefreshAllExploringTime()
  local self = DataCenter.GolloesCampManager
  local golloesFormationList = DataCenter.ArmyFormationDataManager:GetGolloesFormationList()
  for i, v in ipairs(golloesFormationList) do
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, v.uuid, LuaEntry.Player.allianceId)
    if march then
      if march:GetMarchStatus() == MarchStatus.GOLLOES_EXPLORING then
        self:AddOrUpdateOneExploringTime(march)
      else
        self:DelOneExploringTimeTip(v.uuid)
      end
    else
      self:DelOneExploringTimeTip(v.uuid)
    end
  end
end

local function AddOrUpdateOneExploringTime(self, worldMarch)
  EventManager:GetInstance():Broadcast(EventId.HideTroopHead, worldMarch.uuid)
  EventManager:GetInstance():Broadcast(EventId.HideTroopName, worldMarch.uuid)
  if self.exploringTimeTipDic[worldMarch.ownerFormationUuid] then
    self.exploringTimeTipDic[worldMarch.ownerFormationUuid]:Refresh(worldMarch)
    return
  end
  local freeTimeTip = self:GetOneFreeTimeTip()
  if freeTimeTip then
    freeTimeTip:SetTime(worldMarch)
    self.exploringTimeTipDic[worldMarch.ownerFormationUuid] = freeTimeTip
  else
    if self.loadingTimeTipDic[worldMarch.ownerFormationUuid] then
      return
    end
    local request = ResourceManager:InstantiateAsync(CS.GameDefines.EntityAssets.CollectGarbageUI)
    self.loadingTimeTipDic[worldMarch.ownerFormationUuid] = request
    request:completed("+", function()
      if request.isError then
        return
      end
      self.loadingTimeTipDic[worldMarch.ownerFormationUuid] = nil
      request.gameObject:SetActive(false)
      local newTip = GolloesExploringTimeTip.New()
      newTip:Init(request)
      newTip:SetTime(worldMarch)
      self.exploringTimeTipDic[worldMarch.ownerFormationUuid] = newTip
    end)
  end
end

local function DelOneExploringTimeTip(self, formationId)
  if self.exploringTimeTipDic[formationId] then
    self.exploringTimeTipDic[formationId]:Recycle()
    table.insert(self.freeExploringTimeTipList, self.exploringTimeTipDic[formationId])
    self.exploringTimeTipDic[formationId] = nil
  end
end

local function GetOneFreeTimeTip(self)
  if self.freeExploringTimeTipList and #self.freeExploringTimeTipList > 0 then
    local cache = self.freeExploringTimeTipList[#self.freeExploringTimeTipList]
    table.remove(self.freeExploringTimeTipList, #self.freeExploringTimeTipList)
    return cache
  end
  return nil
end

local function CheckIfShowMcBubble(self)
  local isInCity = CS.SceneManager:IsInCity()
  if isInCity then
    return false
  end
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_GROCERY_STORE) then
    return false
  end
  local isAvailable = DataCenter.MonthCardNewManager:CheckIfGolloesMonthCardAvailable()
  if not isAvailable then
    return false
  end
  local hasMonthCard = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
  if hasMonthCard then
    return false
  else
    local strK = "GolloesMcBubble_" .. LuaEntry.Player.uid
    local lastOpenTime = CS.GameEntry.Setting:GetInt(strK, 0)
    local serverTime = UITimeManager:GetInstance():GetServerTime() / 1000
    serverTime = math.modf(serverTime)
    local todayOpened = UITimeManager:GetInstance():IsSameDayForServer(lastOpenTime, serverTime)
    return not todayOpened
  end
end

local function CheckIfHasUnclaimedRewards(self)
  if not DataCenter.BuildManager:HasBuilding(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR) then
    return false
  end
  if DataCenter.MonthCardNewManager:CheckIfHasGolloesGift() then
    return true
  else
    for i, v in pairs(self.golloesRewardNumDic) do
      if 0 < v then
        return true
      end
    end
  end
  return false
end

local function CheckIfHasMarch(self, golloesType)
  local march = self:GetGolloesMarchByType(golloesType)
  if march then
    return true
  else
    return false
  end
end

local function ReInitAll()
  local self = DataCenter.GolloesCampManager
  self.exploringTimeTipDic = {}
  self.freeExploringTimeTipList = {}
  self.loadingTimeTipDic = {}
  self.RefreshAllExploringTime()
end

local function DestroyAll()
  local self = DataCenter.GolloesCampManager
  if self.loadingTimeTipDic and table.count(self.loadingTimeTipDic) > 0 then
    for i, v in pairs(self.loadingTimeTipDic) do
      v:Destroy()
    end
  end
  for i, v in pairs(self.exploringTimeTipDic) do
    v:DelGolloesExploreTimer()
  end
  self.exploringTimeTipDic = {}
  self.freeExploringTimeTipList = {}
  self.loadingTimeTipDic = {}
end

local function OnEnterWorld()
  local self = DataCenter.GolloesCampManager
  self.ReInitAll()
end

local function OnEnterCity()
  local self = DataCenter.GolloesCampManager
  self.DestroyAll()
end

local function OnEnterPveLevel()
  local self = DataCenter.GolloesCampManager
  self.DestroyAll()
end

local function OnExitPveLevel()
  local self = DataCenter.GolloesCampManager
  self.ReInitAll()
end

GolloesCampManager.__init = __init
GolloesCampManager.__delete = __delete
GolloesCampManager.UpdateGolloesInfo = UpdateGolloesInfo
GolloesCampManager.GetGolloesExplorerState = GetGolloesExplorerState
GolloesCampManager.GetGolloesMarchByType = GetGolloesMarchByType
GolloesCampManager.GetGolloesMarchEndTime = GetGolloesMarchEndTime
GolloesCampManager.GetGolloesTradeState = GetGolloesTradeState
GolloesCampManager.GetGolloesCount = GetGolloesCount
GolloesCampManager.GetFreeSpeedTime = GetFreeSpeedTime
GolloesCampManager.AddListener = AddListener
GolloesCampManager.RemoveListener = RemoveListener
GolloesCampManager.ShowExploringTime = ShowExploringTime
GolloesCampManager.HideExploringTime = HideExploringTime
GolloesCampManager.AddGolloesExploreTimer = AddGolloesExploreTimer
GolloesCampManager.SetGolloesExploreTime = SetGolloesExploreTime
GolloesCampManager.DelGolloesExploreTimer = DelGolloesExploreTimer
GolloesCampManager.CheckIfHasUnclaimedRewards = CheckIfHasUnclaimedRewards
GolloesCampManager.GetGolloesRewardNum = GetGolloesRewardNum
GolloesCampManager.CheckIfHasMarch = CheckIfHasMarch
GolloesCampManager.CheckIfShowMcBubble = CheckIfShowMcBubble
GolloesCampManager.GetFreeFormationByGolloesType = GetFreeFormationByGolloesType
GolloesCampManager.RefreshAllExploringTime = RefreshAllExploringTime
GolloesCampManager.AddOrUpdateOneExploringTime = AddOrUpdateOneExploringTime
GolloesCampManager.DelOneExploringTimeTip = DelOneExploringTimeTip
GolloesCampManager.GetOneFreeTimeTip = GetOneFreeTimeTip
GolloesCampManager.OnEnterPveLevel = OnEnterPveLevel
GolloesCampManager.OnExitPveLevel = OnExitPveLevel
GolloesCampManager.CheckIfCanClaimFreeGolloes = CheckIfCanClaimFreeGolloes
GolloesCampManager.DestroyAll = DestroyAll
GolloesCampManager.ReInitAll = ReInitAll
GolloesCampManager.OnEnterWorld = OnEnterWorld
GolloesCampManager.OnEnterCity = OnEnterCity
return GolloesCampManager
