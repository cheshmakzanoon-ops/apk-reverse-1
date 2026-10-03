local CityPrologueBuildFinal = BaseClass("CityPrologueBuildFinal")
local npc_go_anim_path = "NpcGo"
local npc_anim_path = "NpcGo/A_Hero_nvzhuboqban01/A_Hero_nvzhuboqban_skin"
local NpcAnimName = {Walk = "walk", Idle = "idle"}
local NpcGoAnimName = {Walk = "walk", Idle = "idle"}
local BuildAnimName = {
  Walk = "walk",
  ShowBubble = "show_bubble",
  HideBubble = "hide_bubble"
}

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
  self.animTimer = nil
end

local function DeleteAniTimer(self)
  if self.animTimer ~= nil then
    self.animTimer:Stop()
    self.animTimer = nil
  end
end

local function OnDestroy(self)
  EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
    target = self.npc_anim.transform
  })
  self:DeleteAniTimer()
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.npc_go_anim = self.transform:Find(npc_go_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.npc_anim = self.transform:Find(npc_anim_path):GetComponent(typeof(CS.SimpleAnimation))
end

local function ComponentDestroy(self)
  self.npc_go_anim = nil
  self.npc_anim = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  
  function self.npc_anim_call_back()
    self:NpcAnimCallBack()
  end
end

local function DataDestroy(self)
  self.param = nil
  self.npc_anim_call_back = nil
end

local function ReInit(self, param)
  self.param = param
  self:RefreshState()
end

local function RefreshState(self)
  if self.param.aniName == BuildAnimName.Walk then
    local time = self.npc_go_anim:GetClipLength(NpcGoAnimName.Walk)
    if time ~= nil and 0 < time then
      self.npc_go_anim:Play(NpcGoAnimName.Walk)
      self.npc_anim:Play(NpcAnimName.Walk)
    end
    self:AddTimer(time)
  elseif self.param.aniName == BuildAnimName.ShowBubble then
    self.npc_go_anim:Play(NpcGoAnimName.Idle)
    self.npc_anim:Play(NpcAnimName.Idle)
    local talkParam = {}
    talkParam.talkType = NpcTalkType.Right
    talkParam.target = self.npc_anim.transform
    talkParam.dialogId = tonumber(GameDialogDefine.PROLOGUE_CITY_FEILIN_NPC_DES)
    talkParam.offset = Vector3.New(0, 2, 0)
    EventManager:GetInstance():Broadcast(EventId.ShowTalkBubble, talkParam)
    CitySpaceMan:GetInstance():LookAtPos(self.npc_anim.transform.position)
    self.npc_anim.transform:LookAt(CitySpaceMan:GetInstance():GetPosition())
  elseif self.param.aniName == BuildAnimName.HideBubble then
    self.npc_go_anim:Play(NpcGoAnimName.Idle)
    self.npc_anim:Play(NpcAnimName.Idle)
    EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
      target = self.npc_anim.transform
    })
  end
end

local function AddTimer(self, time)
  self:DeleteAniTimer()
  self.animTimer = TimerManager:GetInstance():GetTimer(time, self.npc_anim_call_back, self, true, false, false)
  self.animTimer:Start()
end

local function NpcAnimCallBack(self)
  self.npc_go_anim:Play(NpcGoAnimName.Idle)
  self.npc_anim:Play(NpcAnimName.Idle)
  CitySpaceMan:GetInstance():LookAtPos(self.npc_anim.transform.position)
  self.npc_anim.transform:LookAt(CitySpaceMan:GetInstance():GetPosition())
end

local function ChangeState(self, state)
  if self.param.state ~= state then
    self.param.state = state
    self:RefreshState()
  end
end

local function PlayAnimation(self)
  self:RefreshState()
end

CityPrologueBuildFinal.OnCreate = OnCreate
CityPrologueBuildFinal.OnDestroy = OnDestroy
CityPrologueBuildFinal.ComponentDefine = ComponentDefine
CityPrologueBuildFinal.ComponentDestroy = ComponentDestroy
CityPrologueBuildFinal.DataDefine = DataDefine
CityPrologueBuildFinal.DataDestroy = DataDestroy
CityPrologueBuildFinal.ReInit = ReInit
CityPrologueBuildFinal.RefreshState = RefreshState
CityPrologueBuildFinal.DeleteAniTimer = DeleteAniTimer
CityPrologueBuildFinal.AddTimer = AddTimer
CityPrologueBuildFinal.NpcAnimCallBack = NpcAnimCallBack
CityPrologueBuildFinal.ChangeState = ChangeState
CityPrologueBuildFinal.PlayAnimation = PlayAnimation
return CityPrologueBuildFinal
