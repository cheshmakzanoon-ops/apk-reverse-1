local TriggerPointShowModel = BaseClass("TriggerPointShowModel")
local state_path = "state"
local MaxStateNum = 5
local AnimName = {
  Init = "init",
  Idle = "idle",
  Switch = "switch"
}

function TriggerPointShowModel:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function TriggerPointShowModel:Destroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function TriggerPointShowModel:ComponentDefine()
  self.stateModel = {}
  for i = 0, MaxStateNum do
    local stateTra = self.transform:Find(state_path .. i, true)
    if stateTra ~= nil then
      local param = {}
      param.gameObject = stateTra.gameObject
      param.gameObject:SetActive(false)
      param.modelAnim = stateTra:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      param.director = stateTra:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
      if param.director ~= nil then
        param.director.time = 0
        param.director:Stop()
        param.directorAllTime = param.director.duration
      end
      param.effectGo = {}
      for k, v in pairs(AnimName) do
        local effectGo = stateTra:Find("effect_" .. v, true)
        if effectGo ~= nil then
          effectGo.gameObject:SetActive(false)
          param.effectGo[v] = effectGo
        end
      end
      self.stateModel[i] = param
    end
  end
  if #self.stateModel == 0 then
    local param = {}
    param.gameObject = self.gameObject
    param.gameObject:SetActive(false)
    param.modelAnim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    param.director = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
    if param.director ~= nil then
      param.director.time = 0
      param.director:Stop()
      param.directorAllTime = param.director.duration
    end
    param.effectGo = {}
    for k, v in pairs(AnimName) do
      local effectGo = self.transform:Find("effect_" .. v, true)
      if effectGo ~= nil then
        effectGo.gameObject:SetActive(false)
        param.effectGo[v] = effectGo
      end
    end
    self.stateModel[1] = param
  end
end

function TriggerPointShowModel:ComponentDestroy()
  self.stateModel = {}
  self.gameObject = nil
  self.transform = nil
end

function TriggerPointShowModel:DataDefine()
  self.param = {}
  self.curState = 1
  
  function self.switch_timer_action()
    self:SwitchAnimCallBack()
  end
  
  function self.switch_timeline_timer_action()
    self:SwitchTimelineCallBack()
  end
end

function TriggerPointShowModel:DataDestroy()
  self:DeleteIdleTimer()
  self:DeleteTimelineTimer()
  self.param = {}
  self.curState = 1
  self.switch_timer_action = nil
  self.switch_timeline_timer_action = nil
end

function TriggerPointShowModel:ReInit(param)
  self.param = param
  self.transform:Set_position(param.pos.x, param.pos.y, param.pos.z)
  self.transform.localRotation = Quaternion.Euler(0, 0, 0)
  if not self.param.isPreOk then
    self.curState = 0
  else
    self.curState = 1
  end
  if self.stateModel[self.curState] ~= nil then
    self.stateModel[self.curState].gameObject:SetActive(true)
    self:PlayModelAnim(AnimName.Idle)
  end
  if self.param.isInitFinish then
    self:DeleteIdleTimer()
    self:DeleteTimelineTimer()
    self:SwitchNext()
  end
end

function TriggerPointShowModel:PlayModelAnim(animName)
  local timelineTime = 0
  local time = 0
  if self.stateModel[self.curState] ~= nil then
    local anim = self.stateModel[self.curState].modelAnim
    if anim ~= nil then
      time = anim:GetClipLength(animName)
      if 0 < time then
        if anim:IsPlaying(animName) then
          anim:Rewind(animName)
        else
          anim:Play(animName)
        end
      end
    end
    if animName == AnimName.Switch then
      local director = self.stateModel[self.curState].director
      if director ~= nil and director.time == 0 then
        director:Play()
        timelineTime = self.stateModel[self.curState].directorAllTime
      end
    end
  end
  self:PlayEffect(animName)
  return time, timelineTime
end

function TriggerPointShowModel:AddIdleTimer(time, callBack)
  self:DeleteIdleTimer()
  self.idleTimer = TimerManager:GetInstance():GetTimer(time, callBack, self, true, false, false)
  self.idleTimer:Start()
end

function TriggerPointShowModel:DeleteIdleTimer()
  if self.idleTimer then
    self.idleTimer:Stop()
    self.idleTimer = nil
  end
end

function TriggerPointShowModel:SwitchAnimCallBack()
  self:DeleteIdleTimer()
  self:SwitchNext()
end

function TriggerPointShowModel:SwitchNextState()
  local time, timelineTime = self:PlayModelAnim(AnimName.Switch)
  if 0 < time or 0 < timelineTime then
    if 0 < time then
      self:AddIdleTimer(time, self.switch_timer_action)
    end
    if 0 < timelineTime then
      self:AddTimelineTimer(timelineTime, self.switch_timeline_timer_action)
    end
  else
    self:DeleteIdleTimer()
    self:DeleteTimelineTimer()
    self:SwitchNext()
  end
end

function TriggerPointShowModel:PlayEffect(animName)
  if self.stateModel[self.curState] ~= nil then
    local effectGo = self.stateModel[self.curState].effectGo
    if effectGo ~= nil and effectGo[animName] ~= nil then
      effectGo[animName].gameObject:SetActive(true)
    end
  end
end

function TriggerPointShowModel:AddTimelineTimer(time, callBack)
  self:DeleteTimelineTimer()
  self.timelineTimer = TimerManager:GetInstance():GetTimer(time, callBack, self, true, false, false)
  self.timelineTimer:Start()
end

function TriggerPointShowModel:DeleteTimelineTimer()
  if self.timelineTimer then
    self.timelineTimer:Stop()
    self.timelineTimer = nil
  end
end

function TriggerPointShowModel:SwitchTimelineCallBack()
  self:DeleteTimelineTimer()
  self:SwitchNext()
end

function TriggerPointShowModel:SwitchNext()
  if self.idleTimer == nil and self.timelineTimer == nil then
    if self.stateModel[self.curState] ~= nil then
      self.stateModel[self.curState].gameObject:SetActive(false)
    end
    self.curState = self.curState + 1
    if self.stateModel[self.curState] == nil then
      self.param.triggerData:SetVisible(false)
    else
      self.stateModel[self.curState].gameObject:SetActive(true)
      if not self.param.isInitFinish then
        self:PlayEffect(AnimName.Init)
      end
      self:PlayModelAnim(AnimName.Idle)
    end
  end
end

return TriggerPointShowModel
