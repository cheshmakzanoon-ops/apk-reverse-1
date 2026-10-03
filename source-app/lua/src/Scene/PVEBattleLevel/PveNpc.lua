local PveNpc = BaseClass("PveNpc")
local NpcFollowState = require("Scene.PVEBattleLevel.PveNpcState.NpcFollowState")
local NpcIdleState = require("Scene.PVEBattleLevel.PveNpcState.NpcIdleState")
local NpcMoveState = require("Scene.PVEBattleLevel.PveNpcState.NpcMoveState")
local NpcRotationState = require("Scene.PVEBattleLevel.PveNpcState.NpcRotationState")
local talk_pos_path = "TalkPos"
local EnterDistance = 1.5
local weapon_path = "A_Hero_low/A_Hero_low_skin/To_unity/DeformationSystem/Root/guadian/WeaponGo"
PveNpc.AnimName = {
  Idle = "idle",
  Walk = "walk",
  Coma = "coma",
  WakeUp = "wakeup",
  Attack = "attack"
}
local AnimName = PveNpc.AnimName
PveNpc.State = {
  Idle = "Idle",
  Follow = "Follow",
  Move = "Move",
  Rotation = "Rotation"
}
local State = PveNpc.State

function PveNpc:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function PveNpc:OnDestroy()
  EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
    target = self.transform
  })
  self:ComponentDestroy()
  self:DataDestroy()
end

function PveNpc:ComponentDefine()
  self.anim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  self.pos_go = self.transform:Find(talk_pos_path)
  self.weapon_go = self.transform:Find(weapon_path)
end

function PveNpc:ComponentDestroy()
  if self.trigger then
    self.trigger.OnTriggerEnterAction = nil
    self.trigger.OnTriggerExitAction = nil
    self.trigger = nil
  end
  self.weapon_go = nil
  self.pos_go = nil
  self.anim = nil
  self.gameObject = nil
  self.transform = nil
end

function PveNpc:DataDefine()
  self.param = nil
  self.position = Vector3.New(0, 0, 0)
  self.rotation = Quaternion.New(0, 0, 0, 0)
  self.isFollow = false
  if self.pos_go ~= nil then
    self.talk_pos = self.pos_go.transform.position - self.transform.position
  end
  self.enterTrigger = nil
  
  function self.anim_timer_action()
    self:AnimTimerCallBack()
  end
  
  self.state = State.Idle
  self.stateList = {}
  self.stateList[State.Follow] = NpcFollowState.New(self)
  self.stateList[State.Idle] = NpcIdleState.New(self)
  self.stateList[State.Move] = NpcMoveState.New(self)
  self.stateList[State.Rotation] = NpcRotationState.New(self)
end

function PveNpc:DataDestroy()
  self:DeleteAnimTimer()
  self.param = nil
  self.position = Vector3.New(0, 0, 0)
  self.rotation = Quaternion.New(0, 0, 0, 0)
  self.isFollow = false
  self.talk_pos = nil
  self.enterTrigger = nil
  self.state = State.Idle
  self.stateList = {}
end

function PveNpc:ReInit(param)
  self.param = param
  self:ShowPanel()
  self:RefreshFollow()
end

function PveNpc:ShowPanel()
  if self.param.posArr ~= nil then
    local count = table.count(self.param.posArr)
    if count <= 1 then
      self:SetPosition(SceneUtils.TileToWorld(self.param.posArr[1]))
      self:ChangeState(State.Idle)
      self:CheckNext()
    else
      self:ChangeState(State.Move, self.param)
    end
  end
  if self.param ~= nil then
    if self.param.angle ~= nil and self.state == State.Idle then
      self:ChangeState(State.Rotation, self.param)
    end
    if self.param.isFollow then
      local index = self.param.mgr:GetFollowNpcCount()
      self.param.extraPos = self.param.mgr:GetExtraFollowNpcPos(index)
      self:ChangeState(State.Follow, self.param)
    end
    self:RefreshAnim()
  end
end

function PveNpc:ChangeAnim(animName)
  self.param.animName = animName
  self:RefreshAnim()
end

function PveNpc:RefreshAnim()
  if self.state == State.Move then
    self.anim:Play(AnimName.Walk)
    self:SetWeaponVisible(false)
  elseif self.state == State.Rotation then
    self.anim:Play(AnimName.Idle)
    self:SetWeaponVisible(false)
  elseif self.state == State.Follow then
    self.anim:Play(self.stateList[self.state]:GetAnimName())
    self:SetWeaponVisible(false)
  elseif self.param.animName ~= nil and self.param.animName ~= "" then
    self.anim:Play(self.param.animName)
    local time = self.anim:GetClipLength(self.param.animName)
    if self.param.animName == AnimName.Coma then
      self:SetWeaponVisible(false)
    elseif self.param.animName == AnimName.Attack then
      self:SetWeaponVisible(true)
      self:AddAnimTimer(time)
    else
      self:SetWeaponVisible(false)
      self:AddAnimTimer(time)
    end
  else
    self:SetWeaponVisible(false)
    self.anim:Play(AnimName.Idle)
  end
end

function PveNpc:Update()
  if self.stateList[self.state] ~= nil then
    self.stateList[self.state]:OnUpdate(Time.deltaTime)
  end
  if self.isFollow then
    DataCenter.BattleLevel:Lookat(self:GetPosition())
  end
end

function PveNpc:RefreshFollow()
  if self.param ~= nil then
    self.isFollow = self.param.follow
  end
end

function PveNpc:CheckNext()
  if self.param.nextType == GuideNpcDoNextType.WaitWalk then
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil and template.type == GuideType.PrologueShowNpc and template.para2 == self.param.modelName then
      DataCenter.GuideManager:DoNext()
    end
  elseif self.param.nextType == GuideNpcDoNextType.WaitWalkDelete then
    DataCenter.BattleLevel:RemoveOneNpc(self.param.modelName)
  end
end

function PveNpc:OnPlayerMoveSignal(pos)
  if self.param.dialogId ~= nil then
    local distance = Vector3.Distance(pos, self:GetPosition())
    if distance <= EnterDistance then
      if self.enterTrigger ~= true then
        self.enterTrigger = true
        local talkParam = {}
        talkParam.talkType = NpcTalkType.Right
        talkParam.target = self.transform
        talkParam.dialogId = self.param.dialogId
        talkParam.offset = self.talk_pos or Vector3.New(0, 2, 0)
        EventManager:GetInstance():Broadcast(EventId.ShowTalkBubble, talkParam)
      end
    elseif self.enterTrigger ~= false then
      self.enterTrigger = false
      EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
        target = self.transform
      })
    end
  end
  if self.state == State.Follow then
    self.stateList[self.state]:OnPlayerMoveSignal(pos)
  end
end

function PveNpc:ChangeState(state, param)
  if self.state ~= state then
    if self.state ~= nil then
      self.stateList[self.state]:OnExit()
    end
    self.state = state
    self.stateList[self.state]:OnEnter(param)
    self:RefreshAnim()
  end
end

function PveNpc:SetPosition(pos)
  if self.position.x ~= pos.x or self.position.z ~= pos.z then
    self.position = pos
    self.transform.position = pos
  end
end

function PveNpc:GetPosition()
  return self.position
end

function PveNpc:SetRotation(rotation)
  if self.rotation.x ~= rotation.x or self.rotation.y ~= rotation.y or self.rotation.z ~= rotation.z or self.rotation.w ~= rotation.w then
    self.rotation = rotation
    self.transform.rotation = rotation
  end
end

function PveNpc:GetRotation()
  return self.rotation
end

function PveNpc:SetWeaponVisible(visible)
  if self.weapon_go ~= nil then
    self.weapon_go.gameObject:SetActive(visible)
  end
end

function PveNpc:AddAnimTimer(time)
  self:DeleteAnimTimer()
  if self.animTimer == nil then
    self.animTimer = TimerManager:GetInstance():GetTimer(time, self.anim_timer_action, self, true, false, false)
  end
  self.animTimer:Start()
end

function PveNpc:DeleteAnimTimer()
  if self.animTimer ~= nil then
    self.animTimer:Stop()
    self.animTimer = nil
  end
end

function PveNpc:AnimTimerCallBack()
  self:DeleteAnimTimer()
  self.anim:Play(AnimName.Idle)
  self:SetWeaponVisible(false)
end

return PveNpc
