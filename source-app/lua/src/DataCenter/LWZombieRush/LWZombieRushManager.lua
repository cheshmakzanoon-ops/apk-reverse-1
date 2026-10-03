local LWZombieRushManager = BaseClass("LWZombieRushManager")
local LWZombieRushRewardInfo = require("DataCenter.LWZombieRush.LWZombieRushRewardInfo")

function LWZombieRushManager:__init()
  self.openTime = 0
  self.buildingId = 0
  self.cdTime = 0
  self.pointId = 0
  self.maxDifficultyId = 0
  self.selectDifficultyId = 0
  self.id2RewardDict = {}
  self.round = 0
  self.stateEndTime = 0
  self.state = -1
  self.userState = -1
  self.isSearch = false
  self.isRequestServerData = false
  self.waveOfMonstersWaitingTime = {}
  self.zombiePlanOpenDay = nil
  self:AddListener()
end

function LWZombieRushManager:__delete()
  self.zombiePlanOpenDay = nil
  self.openTime = nil
  self.buildingId = nil
  self.cdTime = nil
  self.pointId = nil
  self.maxDifficultyId = nil
  self.selectDifficultyId = nil
  self.id2RewardDict = nil
  self.round = nil
  self.stateEndTime = nil
  self.state = nil
  self.userState = nil
  self.isSearch = nil
  self.isRequestServerData = nil
  self.waveOfMonstersWaitingTime = nil
  self:RemoveListener()
end

function LWZombieRushManager:AddListener()
  function self.AllianceApplySuccessCallBack()
    self:OnAllianceApplySuccess()
  end
  
  EventManager:GetInstance():AddListener(EventId.AllianceApplySuccess, self.AllianceApplySuccessCallBack)
  
  function self.AllianceCreateSuccessCallBack(isSuccess)
    self:OnCreateAllianceSuccess(isSuccess)
  end
  
  EventManager:GetInstance():AddListener(EventId.AllianceCreateSuccess, self.AllianceCreateSuccessCallBack)
end

function LWZombieRushManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.AllianceApplySuccess, self.AllianceApplySuccessCallBack)
  EventManager:GetInstance():RemoveListener(EventId.AllianceCreateSuccess, self.AllianceCreateSuccessCallBack)
end

function LWZombieRushManager:OnAllianceApplySuccess()
  self:SetRequestData(true)
end

function LWZombieRushManager:OnCreateAllianceSuccess(isSuccess)
  if isSuccess then
    self:SetRequestData(true)
  end
end

function LWZombieRushManager:SetRequestData(value)
  self.isRequestServerData = value
end

function LWZombieRushManager:CheckZombiePlanOpen()
  if not self.zombiePlanOpenDay then
    self.zombiePlanOpenDay = LuaEntry.DataConfig:TryGetNum("zombieRush_config", "k1")
  end
  local days = math.ceil(UITimeManager:GetInstance():GetServerOpenDays())
  return self.zombiePlanOpenDay and days >= self.zombiePlanOpenDay
end

function LWZombieRushManager:SendMsgZombieRushActInfo()
  self:SetRequestData(false)
  SFSNetwork.SendMessage(MsgDefines.ZombieRushActInfo)
  local allianceId = LuaEntry.Player:GetAllianceUid()
  if not string.IsNullOrEmpty(allianceId) then
    DataCenter.LWZombieRushPlanInfoManager:SendMsgZombieRushGetHistorySetInfo(allianceId)
  end
end

function LWZombieRushManager:SendMsgZombieRushSearch(templateId)
  SFSNetwork.SendMessage(MsgDefines.ZombieRushSearch, templateId)
end

function LWZombieRushManager:SendMsgZombieRushRewardInfo(templateId)
  if self.id2RewardDict[templateId] == nil then
    SFSNetwork.SendMessage(MsgDefines.ZombieRushRewardInfo, templateId)
  end
end

function LWZombieRushManager:UpdateActInfo(message)
  if message.openTime then
    self.openTime = message.openTime
  end
  if message.buildingId then
    self.buildingId = message.buildingId
  end
  if message.cdTime then
    self.cdTime = message.cdTime
  end
  if message.maxDifficultyId then
    self.maxDifficultyId = message.maxDifficultyId
  end
  if message.selectDifficultyId then
    self.selectDifficultyId = message.selectDifficultyId
  end
  if message.pointId then
    self.pointId = message.pointId
  end
  if message.state then
    self.state = message.state
  end
  if message.userState then
    self.userState = message.userState
  end
  if message.isSearch then
    self.isSearch = message.isSearch
  end
  if message.round then
    self.round = message.round
  end
  if message.stateEndTime then
    self.stateEndTime = message.stateEndTime
  end
  EventManager:GetInstance():Broadcast(EventId.GetZombieRushActInfoData)
  if self.pointId > 0 and self.buildingId > 0 and self.isSearch then
    self.isSearch = false
  end
end

function LWZombieRushManager:UpdateReward(message)
  if message.id then
    local templateId = message.id
    if self.id2RewardDict[templateId] == nil then
      local rewardInfo = LWZombieRushRewardInfo.New()
      rewardInfo:InitRewardMessage(message)
      self.id2RewardDict[templateId] = rewardInfo
    end
    EventManager:GetInstance():Broadcast(EventId.GetZombieRushRewardInfoData)
  end
end

function LWZombieRushManager:GetRewardInfoByTemplateId(templateId)
  if self.id2RewardDict[templateId] then
    return self.id2RewardDict[templateId]
  end
  return nil
end

function LWZombieRushManager:JumpToZombieRush()
  if not LuaEntry.Player:IsInSelfServer() then
    UIUtil.ShowTipsId("server_tips_002")
    return
  end
  if self.pointId > 0 and 0 < self.buildingId then
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World), nil, nil, function()
      UIUtil.OnClickWorldTroop(self.buildingId)
    end)
  end
end

function LWZombieRushManager:IsChallenging()
  if self.state == ZombieRushAllianceStatus.Ready or self.state == ZombieRushAllianceStatus.InBattle then
    return self.userState == ZombieRushUserStatus.Doing
  end
  return false
end

function LWZombieRushManager:IsCd()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return curTime < self.cdTime
end

function LWZombieRushManager:GetCdTime()
  return self.cdTime
end

function LWZombieRushManager:GetWaitingTimeByRound(round)
  if table.count(self.waveOfMonstersWaitingTime) then
    local str = LuaEntry.DataConfig:TryGetStr("zombieRush_config", "k3", "")
    if not string.IsNullOrEmpty(str) then
      local strArr = string.split(str, ";")
      local count = table.count(strArr)
      for i = 1, count do
        table.insert(self.waveOfMonstersWaitingTime, tonumber(strArr[i]))
      end
    end
  end
  local count = table.count(self.waveOfMonstersWaitingTime)
  if round <= count then
    return self.waveOfMonstersWaitingTime[round] * 1000
  end
  return 0
end

function LWZombieRushManager:GetRedDotCount()
  local curValue = 0
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData ~= nil then
    curValue = allianceData.zombieRushPoint
  end
  local maxValue = LuaEntry.DataConfig:TryGetNum("zombieRush_config", "k2")
  local pointsMeet = curValue >= maxValue
  local timeMeet = not self:IsCd() and UITimeManager:GetInstance():GetServerTime() >= self.openTime and 0 >= DataCenter.LWZombieRushPlanInfoManager:GetPlanTimeStamp()
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  return pointsMeet and timeMeet and isR4orR5 and 1 or 0
end

return LWZombieRushManager
