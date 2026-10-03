local AddSoldiersMarchData = BaseClass("AddSoldiersMarchData")
local FakeMarchState = {
  FAKE_MARCH_STATE_NULL = 0,
  FAKE_MARCH_TO_GARBAGE = 1,
  FAKE_MARCH_COLLECT_GARBAGE = 2,
  FAKE_MARCH_GO_HOME = 3,
  FAKE_MARCH_ARRIVE_HOME = 4
}

local function __init(self)
  self.startIndex = 0
  self.endIndex = 0
  self.startTime = 0
  self.GarbageStartTime = 0
  self.backHomeTime = 0
  self.arriveHomeTime = 0
  self.getRewardTime = 0
  self.curState = FakeMarchState.FAKE_MARCH_STATE_NULL
end

local function __delete(self)
  self.startIndex = nil
  self.endIndex = nil
  self.startTime = nil
  self.GarbageStartTime = nil
  self.backHomeTime = nil
  self.arriveHomeTime = nil
end

local function SetStartAndEndIndex(self, pointIndex, startIndex, endIndex, eventUuid_)
  self.pointIndex = pointIndex
  self.startIndex = startIndex
  self.endIndex = endIndex
  self.eventUuid = eventUuid_
  local data = CS.SceneManager.World:GetPointInfo(self.pointIndex)
  if data then
    self.pointUid = data.uuid
    self.uuid = data.uuid
  end
end

local function UpdateState(self, curTime)
  if self.curState == FakeMarchState.FAKE_MARCH_STATE_NULL then
    self:StartMarch()
  elseif self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE and curTime >= self.GarbageStartTime then
    self:CheckAndStartCollectGarbage(curTime)
  elseif self.curState == FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE and curTime >= self.backHomeTime then
    self:CheckAndGoBack(curTime)
  elseif self.curState == FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.arriveHomeTime then
    self:CheckBackHome(curTime)
  end
  self:SendPickEndMessage()
end

local function StartMarch(self)
  if self.curState == FakeMarchState.FAKE_MARCH_STATE_NULL then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.curState = FakeMarchState.FAKE_MARCH_TO_GARBAGE
    self.startTime = math.ceil(curTime)
    local marchTime = self:CalculateMarchTime()
    self.GarbageStartTime = math.ceil(curTime + marchTime)
    self.backHomeTime = math.ceil(self.GarbageStartTime + 200)
    self.arriveHomeTime = math.ceil(self.backHomeTime + marchTime + 200)
    self.getRewardTime = math.ceil(self.backHomeTime + 3500)
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.NORMAL_FAKE_MARCH)
    end
  end
end

local function CheckAndStartCollectGarbage(self, curTime)
  if self.curState ~= FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE and curTime >= self.GarbageStartTime then
    self.curState = FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE
    if CS.SceneManager:IsInWorld() then
    end
  end
end

local function CheckAndGoBack(self, curTime)
  if self.curState ~= FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.backHomeTime then
    self.curState = FakeMarchState.FAKE_MARCH_GO_HOME
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:UpdateFakeSampleMarchDataWhenBack(self.endIndex, self.backHomeTime, self.arriveHomeTime)
      self:SendPickEndMessage()
    end
  end
end

local function SendPickEndMessage(self)
  if self.curState == FakeMarchState.FAKE_MARCH_GO_HOME or self.curState == FakeMarchState.FAKE_MARCH_ARRIVE_HOME then
    if self.eventUuid == nil then
      return
    end
    local eventUuid = self.eventUuid
    local detectData = DataCenter.AddSoldiersMarchManager:GetDetectEventInfo(eventUuid)
    if detectData == nil then
      return
    end
    if detectData.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
      detectData.state = DetectEventState.DETECT_EVENT_STATE_FINISHED
      self:PlayGetAnim(detectData)
      return
    end
    if detectData.state ~= DetectEventState.DETECT_EVENT_STATE_FINISHED or UITimeManager:GetInstance():GetServerTime() >= self.getRewardTime then
    elseif UITimeManager:GetInstance():GetServerTime() >= self.arriveHomeTime then
      detectData.state = DetectEventState.DETECT_EVENT_STATE_REWARDED
    end
  end
end

local function PlayGetAnim(self, detectData)
  if CS.SceneManager.World and self.uuid == nil then
    local data = CS.SceneManager.World:GetPointInfo(self.pointIndex)
    if data then
      self.uuid = data.uuid
    end
  end
  if self.uuid ~= nil then
    local playerInfo
    if detectData.helpInfo then
      playerInfo = {
        uid = detectData.helpInfo.uid,
        pic = detectData.helpInfo.pic,
        picVer = detectData.helpInfo.picVer
      }
    else
      playerInfo = {
        uid = detectData.uid
      }
    end
    if LuaEntry.Player.uid ~= detectData.uid then
      local plotId = detectData.baseNum > 0 and 2313 or 2314
      EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubblePlot, {
        bUuid = self.uuid,
        plotId = plotId,
        playerInfo = playerInfo
      })
    end
    EventManager:GetInstance():Broadcast(EventId.HelpDetectEndEffectBubbleShow, {
      bUuid = self.uuid
    })
    if detectData.baseNum > 0 then
      self:ShowAddSolderPopUI(self.pointIndex, detectData.baseNum, detectData.randomNum, detectData.armyId)
    end
  end
end

local function CheckBackHome(self, curTime)
  if self.curState == FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.arriveHomeTime then
    self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
    DataCenter.AddSoldiersMarchManager:RemoveMarchIndex(self.eventUuid)
  end
end

local function CalculateMarchTime(self)
  local startPt = SceneUtils.IndexToTilePos(self.startIndex)
  local endPt = SceneUtils.IndexToTilePos(self.endIndex)
  local dis = Vector2.Distance(startPt, endPt)
  local speed = 3
  local time = dis * 1000 / speed
  local maxTime = 10000
  if time > maxTime then
    time = maxTime
  end
  return time
end

local function Remove(self)
  if CS.SceneManager:IsInWorld() then
    CS.SceneManager.World:RemoveFakeSampleMarchData(self.endIndex)
  end
end

local function NeedRemove(self)
  if self.curState == FakeMarchState.FAKE_MARCH_ARRIVE_HOME and DataCenter.AddSoldiersMarchManager:NeedRemove(self.eventUuid) then
    return true
  end
  return false
end

local function IsEventDoing(self)
  return self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE or self.curState == FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE
end

local function DoWhenBackToWorld(self)
  if CS.SceneManager.World:ExistMarch(self.endIndex) then
    return
  end
  if self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE then
    CS.SceneManager.World:RemoveFakeSampleMarchData(self.endIndex)
    CS.SceneManager.World:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.NORMAL_FAKE_MARCH)
  else
    self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
    self:UpdateState(UITimeManager:GetInstance():GetServerTime())
  end
end

local function ShowAddSolderPopUI(self, pointId, param1, param2, armyId)
  local prefabPath = string.format(LoadPath.UISeason3ComponentPath, "AddSoldersMessageTip.prefab")
  param1 = param1 or 0
  param2 = param2 or 0
  local bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(prefabPath)
  bubbleHandle:completed("+", function(req)
    if req.isError then
      return
    end
    if not SceneUtils.GetIsInWorld() then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local animRoot = go.transform:Find("bg")
    local txt = go.transform:Find("bg/txt")
    local icon = go.transform:Find("bg/icon")
    local anim = go:GetComponent(typeof(CS.SimpleAnimation))
    local unity_txt = txt.gameObject:GetComponent(typeof(CS.TextMeshProEx))
    local unity_icon = icon.gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    go.name = string.format("AddSolders_%s", pointId)
    go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    position.y = position.y + 2.5
    go.transform.position = position
    animRoot.gameObject:SetActive(true)
    if anim:IsPlaying("Default") then
      anim:Rewind("Default")
    else
      anim:Play("Default")
    end
    TimerManager:GetInstance():DelayInvoke(function()
      if req ~= nil then
        req:Destroy()
      end
    end, 4)
    if unity_txt then
      unity_txt.text = string.format("+%s", param1)
    end
    if unity_icon and armyId then
      local temp = DataCenter.SoldierDataManager:GetTemplate(armyId)
      if temp then
        if not string.IsNullOrEmpty(temp.bubble_icon) then
          unity_icon:LoadSprite(string.format(LoadPath.UIMainBubble, temp.bubble_icon))
        elseif not string.IsNullOrEmpty(temp.icon) then
          unity_icon:LoadSprite(string.format(LoadPath.ItemPath, temp.icon))
        end
      end
    end
  end)
end

AddSoldiersMarchData.__init = __init
AddSoldiersMarchData.__delete = __delete
AddSoldiersMarchData.SetStartAndEndIndex = SetStartAndEndIndex
AddSoldiersMarchData.StartMarch = StartMarch
AddSoldiersMarchData.CheckAndStartCollectGarbage = CheckAndStartCollectGarbage
AddSoldiersMarchData.CheckAndGoBack = CheckAndGoBack
AddSoldiersMarchData.CalculateMarchTime = CalculateMarchTime
AddSoldiersMarchData.UpdateState = UpdateState
AddSoldiersMarchData.Remove = Remove
AddSoldiersMarchData.CheckBackHome = CheckBackHome
AddSoldiersMarchData.SendPickEndMessage = SendPickEndMessage
AddSoldiersMarchData.NeedRemove = NeedRemove
AddSoldiersMarchData.IsEventDoing = IsEventDoing
AddSoldiersMarchData.DoWhenBackToWorld = DoWhenBackToWorld
AddSoldiersMarchData.ShowAddSolderPopUI = ShowAddSolderPopUI
AddSoldiersMarchData.PlayGetAnim = PlayGetAnim
return AddSoldiersMarchData
