local AnimalModel = BaseClass("AnimalModel")
local box_collider_path = "GameObject"
local Localization = CS.GameEntry.Localization
local feedTime = 2000
local moveTime = 2000
local Animation = {
  starve = "starve",
  lie = "lie",
  idle1 = "idle_01",
  idle2 = "idle_02",
  idle3 = "idle_03",
  gain = "gain",
  gaining = "gaining",
  show = "show"
}
local select_effect_path = "GameObject/VFX_dongwu_xuanzhong"
local feed_effect_path = "GameObject/VFX_dongwu_feed"

local function OnCreate(self, go, animalName, pointId)
  if go ~= nil then
    self.pointId = pointId
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:DataDefine()
  self:ComponentDefine(animalName)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  if self.request ~= nil then
    self.request:Destroy()
    self.request = nil
  end
end

local function GetPointId(self)
  return self.pointId
end

local function ComponentDefine(self, animalName)
  local ani_path = "GameObject/A_animal_" .. animalName .. "/A_animal@" .. animalName .. "_skin"
  self.box = self.transform:Find(box_collider_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.box.onPointerClick()
    self:OnClick()
  end
  
  function self.box.onPointerEnter()
    self:OnTouch()
  end
  
  function self.box.onBeginLongTab()
    self:OnBeginLongTab()
  end
  
  function self.box.onEndLongTab()
    self:OnEndLongTab()
  end
  
  self.gpuAnim = self.transform:GetComponentInChildren(typeof(CS.GPUSkinningAnimator), true)
  self.simpleAnim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  self.selectEffect = self.transform:Find(select_effect_path).gameObject
  self.selectEffect:SetActive(false)
  self.feedEffect = self.transform:Find(feed_effect_path).gameObject
  self.feedEffect:SetActive(false)
end

local function ComponentDestroy(self)
  self.box.onPointerClick = nil
  self.box.onPointerEnter = nil
  self.box.onBeginLongTab = nil
  self.box.onEndLongTab = nil
  self.box = nil
  self.selectEffect = nil
  self.feedEffect = nil
end

local function DataDefine(self)
  self.queueUuid = 0
  self.bUuid = 0
  self.curState = AnimalAnimationState.None
  
  function self.__update_handle()
    self:Update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
  self.startTime = 0
  self.endTime = 0
  self.actEndTimeVector = {}
  self.actEndPosVector = {}
end

local function DataDestroy(self)
  UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
  self.__update_handle = nil
end

local function ReInitState(self, uuid)
  self.curState = AnimalAnimationState.None
  self:SetData(uuid)
end

local function SetData(self, uuid)
  self.queueUuid = uuid
  local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.queueUuid)
  if queueData ~= nil then
    self.bUuid = queueData.funcUuid
  end
  self:CheckAnimalState()
  self:RefreshSelectAndFeedEffect()
end

local function OnClick(self)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.bUuid)
  if buildData ~= nil and DataCenter.RecommendShowManager:IsCanClickBuild(buildData.itemId, buildData) then
    GoToUtil.CloseAllWindows()
    local onComplete
    local pos, needMove = UIUtil.ClickFarmAdjustPos(SceneUtils.TileIndexToWorld(buildData.pointId), PastureAdjust)
    
    function onComplete()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPasture, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, self.bUuid)
    end
    
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.queueUuid)
    if queueData:GetQueueState() == NewQueueState.Work then
      local signal = SFSObject.New()
      signal:PutLong("bUuid", self.bUuid)
      signal:PutLong("queueUuid", self.queueUuid)
      EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShow, signal)
    end
    if needMove == true then
      CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
    else
      CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
    end
    self:CheckClickBuildGuide(buildData.itemId)
  end
end

local function OnTouch(self)
  local bUuid = PastureAnimalManager:GetInstance():GetSelectBUuid()
  if bUuid ~= nil and self.bUuid == bUuid then
    PastureAnimalManager:GetInstance():DoWhenAnimalTouchOver(self.queueUuid)
  end
end

local function GetRequest(self)
  return self.request
end

local function CheckAnimalState(self)
  if self.curState == AnimalAnimationState.Walk and table.count(self.actEndPosVector) > 0 then
    return
  end
  self.actEndPosVector = {}
  self.actEndTimeVector = {}
  local oldState = self.curState
  local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.queueUuid)
  if queueData ~= nil then
    if queueData:GetParaState() == QueueProductState.PASTURE_MATURE then
      if queueData:GetQueueState() == NewQueueState.Work then
        self.startTime = queueData.startTime
        self.endTime = queueData.endTime
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime >= self.endTime then
          self.curState = AnimalAnimationState.Feed
        elseif self.curState == AnimalAnimationState.Feed then
          self.curState = AnimalAnimationState.Walk
        elseif self.curState == AnimalAnimationState.Walk then
          self.curState = AnimalAnimationState.Feed
          table.insert(self.actEndTimeVector, curTime + feedTime)
        else
          self.curState = AnimalAnimationState.Feed
        end
      elseif queueData:GetQueueState() == NewQueueState.Finish then
        self.curState = AnimalAnimationState.Finish
      else
        self.curState = AnimalAnimationState.Free
      end
    else
      self.curState = AnimalAnimationState.Free
    end
  else
    self.curState = AnimalAnimationState.Free
  end
  self:OnChangeStateShow(oldState)
end

local function Update(self)
  if self.curState == AnimalAnimationState.Walk then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if table.count(self.actEndTimeVector) > 1 then
      local startTime = self.actEndTimeVector[1]
      local startPos = self.actEndPosVector[1]
      local endTime = self.actEndTimeVector[2]
      local endPos = self.actEndPosVector[2]
      local percent = (curTime - startTime) / (endTime - startTime)
      percent = Mathf.Clamp(percent, 0, 1)
      local currentPos = Vector3.Lerp(startPos, endPos, percent)
      self.transform:Set_position(currentPos.x, currentPos.y, currentPos.z)
      local angle = self:getAngleByPos(startPos, endPos)
      self.transform:Set_eulerAngles(0, angle, 0)
      if curTime >= endTime then
        table.remove(self.actEndTimeVector, 1)
        table.remove(self.actEndPosVector, 1)
      end
    end
    if table.count(self.actEndTimeVector) == 1 then
      table.remove(self.actEndTimeVector, 1)
      table.remove(self.actEndPosVector, 1)
    end
    if table.count(self.actEndTimeVector) == 0 then
      self:CheckAnimalState()
    end
  end
end

local function getAngleByPos(self, p1, p2)
  local p_x = p2.x - p1.x
  local p_y = p2.z - p1.z
  local r = 270 - math.atan(p_y, p_x) * 180 / math.pi + 720
  r = math.fmod(r, 360)
  return r
end

local function UpdateState(self)
  if self.curState == AnimalAnimationState.Walk and table.count(self.actEndTimeVector) == 0 then
    self:CheckAnimalState()
  end
  if self.curState == AnimalAnimationState.Feed then
    if table.count(self.actEndTimeVector) >= 1 then
      local time = self.actEndTimeVector[1]
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if time <= curTime then
        table.remove(self.actEndTimeVector, 1)
      end
    end
    if table.count(self.actEndTimeVector) == 0 then
      self:CheckAnimalState()
    end
  end
end

local function NeedCalculateWalkPath(self)
  return self.curState == AnimalAnimationState.Walk and table.count(self.actEndPosVector) == 0
end

local function GetPositionAndTime(self)
  if self.actEndPosVector ~= nil and table.count(self.actEndPosVector) > 0 then
    return self.actEndPosVector, self.actEndTimeVector
  end
  return {
    self.transform.position
  }, nil
end

local function GetCurrentPos(self)
  return self.transform.position
end

local function SetEndPos(self, endPosVector)
  if table.count(self.actEndPosVector) == 0 and table.count(endPosVector) > 0 then
    local currentPos = self.transform.position
    table.insert(self.actEndPosVector, Vector3.New(currentPos.x, currentPos.y, currentPos.z))
    for k, v in ipairs(endPosVector) do
      table.insert(self.actEndPosVector, v)
    end
  end
  if table.count(self.actEndPosVector) > 0 and table.count(self.actEndTimeVector) == 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    table.insert(self.actEndTimeVector, curTime)
    local posSize = table.count(self.actEndPosVector)
    local i = 1
    while posSize > i do
      table.insert(self.actEndTimeVector, curTime + moveTime * i)
      i = i + 1
    end
  end
end

local function OnFingerClick(self)
  self:PlayAnim(Animation.idle3)
  if self.curState == AnimalAnimationState.Walk then
    self:PlayAnimQueued(Animation.idle2)
  elseif self.curState == AnimalAnimationState.Feed then
    self:PlayAnimQueued(Animation.idle1)
  elseif self.curState == AnimalAnimationState.Finish then
    self:PlayAnimQueued(Animation.gain)
  elseif self.curState == AnimalAnimationState.Free then
    self:PlayAnimQueued(Animation.starve)
  end
end

local function OnChangeStateShow(self, oldState)
  if oldState ~= self.curState then
    if self.curState == AnimalAnimationState.Walk then
      self:PlayAnim(Animation.idle2)
    elseif self.curState == AnimalAnimationState.Feed then
      self:PlayAnim(Animation.idle1)
    elseif self.curState == AnimalAnimationState.Finish then
      if oldState == AnimalAnimationState.Feed or oldState == AnimalAnimationState.Walk then
        self:PlayAnim(Animation.lie)
        self:PlayAnimQueued(Animation.gain)
      else
        self:PlayAnim(Animation.gain)
      end
    elseif self.curState == AnimalAnimationState.Free then
      if oldState == AnimalAnimationState.Finish then
        self:PlayAnim(Animation.gaining)
        self:PlayAnimQueued(Animation.starve)
      elseif oldState == AnimalAnimationState.GuideShow then
        self:PlayAnim(Animation.show)
        self:PlayAnimQueued(Animation.starve)
      else
        self:PlayAnim(Animation.starve)
      end
    end
  end
end

local function OnGatherAnimal(self)
  self.curState = AnimalAnimationState.Free
  self:OnChangeStateShow(AnimalAnimationState.Finish)
  self:RefreshSelectAndFeedEffect()
end

local function PlayAnim(self, animName)
  if self.gpuAnim ~= nil then
    self.gpuAnim:Play(animName)
  elseif self.simpleAnim ~= nil then
    self.simpleAnim:Play(animName)
  end
end

local function PlayAnimQueued(self, animName)
  if self.gpuAnim ~= nil then
    self.gpuAnim:PlayQueued(animName)
  elseif self.simpleAnim ~= nil then
    self.simpleAnim:PlayQueued(animName)
  end
end

local function CheckClickBuildGuide(self, buildId)
  if DataCenter.GuideManager:InGuide() then
    local guideTemplate = DataCenter.GuideManager:GetCurTemplate()
    if guideTemplate ~= nil and guideTemplate.type == GuideType.ClickBuild and guideTemplate.para1 == tostring(buildId) then
      DataCenter.GuideManager:DoNext()
    end
  end
end

local function OnBeginLongTab(self)
  if CS.SceneManager.World ~= nil then
    local city = CS.SceneManager.World:GetBuildingByPoint(self.pointId)
    if city ~= nil then
      city:OnBeginLongTap()
    end
  end
end

local function OnEndLongTab(self)
  if CS.SceneManager.World ~= nil then
    local city = CS.SceneManager.World:GetBuildingByPoint(self.pointId)
    if city ~= nil then
      city:OnEndLongTap()
    end
  end
end

local function OnUpdatePosition(self, pointId, pos)
  self.transform.position = pos
  self.pointId = pointId
end

local function DoGuideShowAnim(self)
  self.curState = AnimalAnimationState.Free
  self:OnChangeStateShow(AnimalAnimationState.GuideShow)
  return self:GetClipTime(Animation.show)
end

local function GetClipTime(self, animName)
  if self.gpuAnim ~= nil then
    return self.gpuAnim:GetClipLength(animName)
  elseif self.simpleAnim ~= nil then
    return self.simpleAnim:GetClipLength(animName)
  end
end

local function OnAnimalSelect(self, param)
  self:RefreshSelectAndFeedEffect(param)
end

local function RefreshSelectAndFeedEffect(self, selectPara)
  local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.queueUuid)
  local showFeedEffectFlag = false
  local showSelectEffectFlag = false
  if queueData ~= nil then
    if queueData:CheckIfIrrigated() then
      showFeedEffectFlag = true
    else
      showSelectEffectFlag = selectPara ~= nil and selectPara.bUuid == self.bUuid and selectPara.queueUuid == self.queueUuid
    end
  end
  if self.selectEffect ~= nil then
    self.selectEffect:SetActive(showSelectEffectFlag)
  end
  if self.feedEffect ~= nil then
    self.feedEffect:SetActive(showFeedEffectFlag)
  end
end

AnimalModel.OnCreate = OnCreate
AnimalModel.OnDestroy = OnDestroy
AnimalModel.ComponentDefine = ComponentDefine
AnimalModel.ComponentDestroy = ComponentDestroy
AnimalModel.DataDefine = DataDefine
AnimalModel.DataDestroy = DataDestroy
AnimalModel.OnClick = OnClick
AnimalModel.OnTouch = OnTouch
AnimalModel.SetData = SetData
AnimalModel.GetRequest = GetRequest
AnimalModel.UpdateState = UpdateState
AnimalModel.OnChangeStateShow = OnChangeStateShow
AnimalModel.OnGatherAnimal = OnGatherAnimal
AnimalModel.OnFingerClick = OnFingerClick
AnimalModel.CheckAnimalState = CheckAnimalState
AnimalModel.GetPositionAndTime = GetPositionAndTime
AnimalModel.SetEndPos = SetEndPos
AnimalModel.NeedCalculateWalkPath = NeedCalculateWalkPath
AnimalModel.GetCurrentPos = GetCurrentPos
AnimalModel.GetPointId = GetPointId
AnimalModel.Update = Update
AnimalModel.getAngleByPos = getAngleByPos
AnimalModel.PlayAnim = PlayAnim
AnimalModel.PlayAnimQueued = PlayAnimQueued
AnimalModel.CheckClickBuildGuide = CheckClickBuildGuide
AnimalModel.OnBeginLongTab = OnBeginLongTab
AnimalModel.OnEndLongTab = OnEndLongTab
AnimalModel.OnUpdatePosition = OnUpdatePosition
AnimalModel.DoGuideShowAnim = DoGuideShowAnim
AnimalModel.GetClipTime = GetClipTime
AnimalModel.OnAnimalSelect = OnAnimalSelect
AnimalModel.ReInitState = ReInitState
AnimalModel.RefreshSelectAndFeedEffect = RefreshSelectAndFeedEffect
return AnimalModel
