local ActMonsterTowerData = BaseClass("ActMonsterTowerData")
local ActMonsterTowerInfo = require("DataCenter.ActivityListData.ActMonsterTowerInfo")
local ActMonsterTemplate = require("DataCenter.ActivityListData.ActMonsterTemplate")
local ChallengeBossEffect = require("DataCenter.ActivityListData.ChallengeBossEffect")
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self.list = {}
  self.templateDict = {}
  LocalController:instance():visitTable(TableName.ActivityMonster, function(_, line)
    local template = ActMonsterTemplate.New()
    template:InitData(line)
    table.insert(self.templateDict, template)
  end)
  self.bossInfo = nil
  self.btnRedList = {}
  self.helpList = {}
  self.allEffect = nil
end

local function __delete(self)
  self.list = nil
end

local function SetActivityId(self, id)
  self.list[tonumber(id)] = {}
end

local function ParseActData(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] then
    local info = ActMonsterTowerInfo.New()
    if message.challengeInfo then
      info:ParseChallengeInfo(message.challengeInfo)
    end
    if message.challengeBoss then
      info:ParseChallengeBoss(message.challengeBoss)
    end
    if message.difficultyRewardArr then
      info:ParseDiffRewardArr(message.difficultyRewardArr)
    end
    if message.levelReward then
      info:ParseCurReward(message.levelReward)
    end
    info:ParseOther(message)
    self.list[message.activityId] = info
  end
  EventManager:GetInstance():Broadcast(EventId.ActMonTowerGetInfo)
end

local function GetInfoByActId(self, activityId)
  if self.list[activityId] then
    return self.list[activityId]
  end
  return nil
end

local function GetInfoActAll(self)
  return self.list
end

local function GetTemplate(self)
  return self.templateDict or nil
end

local function GetTemplateByIndex(self, index)
  if self.templateDict and self.templateDict[index] then
    return self.templateDict[index]
  end
  return nil
end

local function ChooseDiffHandle(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    if message.challengeInfo then
      data:ParseChallengeInfo(message.challengeInfo)
    end
    if message.levelReward then
      data:ParseCurReward(message.levelReward)
    end
    data:ParseOther(message)
  end
  EventManager:GetInstance():Broadcast(EventId.ActMonTowerChoiceDiff)
end

local function CallBossHandle(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    local challengeBoss = message.challengeBoss
    if challengeBoss then
      data:ParseChallengeBoss(challengeBoss)
      self.bossInfo = challengeBoss
      GoToUtil.CloseAllWindows()
      local pointId = challengeBoss.pointId
      local serverId = challengeBoss.serverId or LuaEntry.Player:GetSelfServerId()
      local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
      GoToUtil.GotoWorldPos(pos, nil, nil, function()
        self:ShowEffect(pointId, serverId)
      end, serverId)
    end
  end
end

local function ShowEffect(self, pointId, serverId)
  local request = ResourceManager:InstantiateAsync(UIAssets.ChallengeBossEffect)
  local par = {}
  local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
  par.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(false)
    request.gameObject.name = "challengeBoss_" .. pointId
    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    request.gameObject.transform.position = Vector3.New(worldPos.x, 5, worldPos.z)
    local effect = ChallengeBossEffect.New()
    effect:OnCreate(request)
    effect:ReInit(function()
      self:RemoveEffect()
    end)
    par.script = effect
    self.allEffect = par
  end)
end

local function RemoveEffect(self)
  if self.allEffect ~= nil then
    local request = self.allEffect.request
    self.allEffect.script:OnDestroy()
    request:Destroy()
  end
  self.allEffect = nil
end

local function ClearBossInfo(self)
  self.bossInfo = nil
end

local function CallBossHelpHandle(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) and message.challengeInfo then
    data:ParseChallengeInfo(message.challengeInfo)
    data.challengeBoss.callHelp = 1
  end
end

local function GetMemberInfoHandle(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    data:ParseMemberInfo(message)
  end
  EventManager:GetInstance():Broadcast(EventId.ActMonTowerGetRank)
end

local function PushCallHelpHandel(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) and message then
    if self.helpList then
      self.helpList[message.activityId] = true
    else
      self.helpList = {}
      self.helpList[message.activityId] = true
    end
    data:RefreshHelp(message)
    EventManager:GetInstance():Broadcast(EventId.ActMonTowerCallHelp)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

local function GetHelpLisByActId(self, id)
  if self.helpList and self.helpList[id] then
    return self.helpList[id]
  end
  return nil
end

local function SetHelpLisByActId(self, id)
  self.helpList[id] = false
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetActRewardInfoHandle(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    if message then
      data:RefreshReward(message.levelRewardArr)
    end
    EventManager:GetInstance():Broadcast(EventId.ActMonTowerGetReward)
  end
end

local function GetActTaskInfoHandle(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    if message then
      data:RefreshTask(message.taskArr)
    end
    EventManager:GetInstance():Broadcast(EventId.ActMonTowerGetTask)
  end
end

local function GetTaskRewardHandle(self, message)
  DataCenter.RewardManager:ShowCommonReward(message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    data:UpdateTask(message)
    EventManager:GetInstance():Broadcast(EventId.ActMonTowerGetTask)
  end
end

local function PushBossKilledHandel(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    if message.curLevel < data.maxLevel then
      self.btnRedList[message.activityId] = true
    else
      self.btnRedList[message.activityId] = false
    end
    EventManager:GetInstance():Broadcast(EventId.ActMonTowerBossKilled, message.curLevel)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

local function GetBtnRedByActId(self, id)
  if self.btnRedList[id] then
    return self.btnRedList[id]
  end
  return false
end

local function SetBtnRedByActId(self, id)
  self.btnRedList[id] = false
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetActRed(self, id)
  local retRed = 0
  local data = self:GetInfoByActId(id)
  if data and next(data) then
    retRed = data:GetActRed()
  end
  return retRed
end

ActMonsterTowerData.__init = __init
ActMonsterTowerData.__delete = __delete
ActMonsterTowerData.SetActivityId = SetActivityId
ActMonsterTowerData.ParseActData = ParseActData
ActMonsterTowerData.GetInfoByActId = GetInfoByActId
ActMonsterTowerData.GetInfoActAll = GetInfoActAll
ActMonsterTowerData.GetTemplate = GetTemplate
ActMonsterTowerData.GetTemplateByIndex = GetTemplateByIndex
ActMonsterTowerData.ChooseDiffHandle = ChooseDiffHandle
ActMonsterTowerData.CallBossHandle = CallBossHandle
ActMonsterTowerData.ShowEffect = ShowEffect
ActMonsterTowerData.RemoveEffect = RemoveEffect
ActMonsterTowerData.ClearBossInfo = ClearBossInfo
ActMonsterTowerData.CallBossHelpHandle = CallBossHelpHandle
ActMonsterTowerData.GetMemberInfoHandle = GetMemberInfoHandle
ActMonsterTowerData.PushCallHelpHandel = PushCallHelpHandel
ActMonsterTowerData.GetHelpLisByActId = GetHelpLisByActId
ActMonsterTowerData.SetHelpLisByActId = SetHelpLisByActId
ActMonsterTowerData.GetActRewardInfoHandle = GetActRewardInfoHandle
ActMonsterTowerData.GetActTaskInfoHandle = GetActTaskInfoHandle
ActMonsterTowerData.GetTaskRewardHandle = GetTaskRewardHandle
ActMonsterTowerData.PushBossKilledHandel = PushBossKilledHandel
ActMonsterTowerData.GetBtnRedByActId = GetBtnRedByActId
ActMonsterTowerData.SetBtnRedByActId = SetBtnRedByActId
ActMonsterTowerData.GetActRed = GetActRed
return ActMonsterTowerData
