local SaveBobScene = BaseClass("SaveBobScene")
local all_timeline_path = "XS_save_bob_timeline_master_mov/XS_save_bob_timelin_mov"
local bob_anim_path = "XS_save_bob_timeline_master_mov/XS_save_bob_timelin_mov/A_Hero_feixingyuanqban/A_Hero_low_skin"
local StartTime = 0.0
local PlayTime = 2.0
local EndTime = 6.0
local CheckTime = 0.1

local function OnCreate(self, go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
  self.bob_anim = self.transform:Find(bob_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
end

local function ComponentDestroy(self)
  self.director = nil
  self.bob_anim = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimerCallBack()
  end
end

local function DataDestroy(self)
  self:DeleteTimer()
  self.param = nil
  self.timer = nil
  self.timer_action = nil
end

local function ReInit(self, param)
  self.param = param
  self.transform.position = self.param.pos
  self:RefreshState()
end

local function GotoTime(self, time)
end

local function ChangeParam(self, param)
  self.param = param
  self:RefreshState()
end

local function RefreshState(self)
  if self.param.state == SaveBobSceneState.NoSave then
    self.director.time = StartTime
    self.director:Play()
    self:AddTimer()
  elseif self.param.state == SaveBobSceneState.PlayTimeLine then
    self.bob_anim:SetTrigger("idle")
    self.director.time = PlayTime
    self.director:Play()
  elseif self.param.state == SaveBobSceneState.Saved then
    self.director.time = EndTime
    self.director:Play()
    self:AddTimer()
  end
end

local function ChangeState(self, state)
  self.param.state = state
  self:RefreshState()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(CheckTime, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

local function TimerCallBack(self)
  self:DeleteTimer()
  if self.param.state == SaveBobSceneState.NoSave then
    self.director:Stop()
    self.bob_anim:SetTrigger("sit")
  elseif self.param.state == SaveBobSceneState.Saved then
    self.director:Stop()
    self.bob_anim:SetTrigger("idle")
  end
end

SaveBobScene.OnCreate = OnCreate
SaveBobScene.OnDestroy = OnDestroy
SaveBobScene.ComponentDefine = ComponentDefine
SaveBobScene.ComponentDestroy = ComponentDestroy
SaveBobScene.DataDefine = DataDefine
SaveBobScene.DataDestroy = DataDestroy
SaveBobScene.ReInit = ReInit
SaveBobScene.GotoTime = GotoTime
SaveBobScene.ChangeParam = ChangeParam
SaveBobScene.RefreshState = RefreshState
SaveBobScene.ChangeState = ChangeState
SaveBobScene.DeleteTimer = DeleteTimer
SaveBobScene.AddTimer = AddTimer
SaveBobScene.TimerCallBack = TimerCallBack
return SaveBobScene
