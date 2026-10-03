local FlowerTrainCheerActor = BaseClass("FlowerTrainCheerActor")
local Resource = CS.GameEntry.Resource
local FlowerTrainConstant = require("DataCenter.FlowerTrain.FlowerTrainConstant")
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local FAR_AWAY = Vector3.New(10000, 10000, 10000)
local Actor_Prefab_Path = "Assets/Main/Prefabs/World/FlowerTrain_World_Prefab/A_Hero_bubing02.prefab"
local rotate_root_path = "RotateRoot"
local player_icon_info_path = "PlayerIconInfo"
local head_icon_path = "PlayerIconInfo/Transform/HeadIcon"
local foreground_path = "PlayerIconInfo/Transform/Foreground"
local CheerActorState = {
  Drop = 0,
  DropWait = 1,
  Move = 2,
  Cheer = 3
}

function FlowerTrainCheerActor:__init()
end

function FlowerTrainCheerActor:__delete()
  self:Destroy()
end

function FlowerTrainCheerActor:Destroy()
  if self.actorReq then
    self.actorReq:Destroy()
    self.actorReq = nil
  end
  self:StopAllTimerAndTween()
  self.isLoadFinish = nil
end

function FlowerTrainCheerActor:Init(parentTrans, carPointTrans, data)
  self.parentTrans = parentTrans
  self.carPointTrans = carPointTrans
  self.prefabPath = data.actorPrefabPath or Actor_Prefab_Path
  self.displayLv = DisplaySettings.GetCurrentDisplayLevel()
  self.lod = CS.SceneManager.World:GetLodLevel()
  self.showState = true
  self:UpdateData(data)
  if self.actorReq then
    self.actorReq:Destroy()
    self.actorReq = nil
  end
  self:CreateActorPrefab()
  self.isLoadFinish = false
end

function FlowerTrainCheerActor:CreateActorPrefab()
  if not self.parentTrans or not self.carPointTrans then
    return
  end
  if self.actorReq then
    return
  end
  self.actorReq = Resource:InstantiateAsync(self.prefabPath)
  self.actorReq:completed("+", function(request)
    self.actorObj = request.gameObject
    self.actorTrans = request.gameObject.transform
    self.actorTrans:SetParent(self.parentTrans)
    self.actorTrans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.actorTrans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.actorTrans:Set_localPosition(0, 0, 0)
    self.simpleAni = self.actorTrans:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self:OnActorLoadFinish()
  end)
end

function FlowerTrainCheerActor:OnActorLoadFinish()
  if not self.actorTrans then
    return
  end
  self.actorTrans:Set_position(self.fromPos.x, self.fromPos.y, self.fromPos.z)
  self.actorTrans.rotation = self.targetRot or Quaternion.identity
  self.rotateRoot = self.actorTrans:Find(rotate_root_path)
  self.rotateRoot.localRotation = Quaternion.identity
  if self.simpleAni then
    self.simpleAni:Stop()
  end
  self.isLoadFinish = true
  self:PlayAniByState()
  self:BlindHeadCpt()
  self:UpdatePlayerHead()
  if not self.showState then
    self:Hide()
  end
end

function FlowerTrainCheerActor:BlindHeadCpt()
  if not self.actorTrans then
    return
  end
  self.headRoot = self.actorTrans:Find(player_icon_info_path).gameObject
  self.headIcon = self.actorTrans:Find(head_icon_path):GetComponent(typeof(CS.UIPlayerHead))
  self.foreground = self.actorTrans:Find(foreground_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
end

function FlowerTrainCheerActor:IsLoadFinish()
  return self.isLoadFinish
end

function FlowerTrainCheerActor:Hide()
  self:StopAllTimerAndTween()
  if not self.actorTrans then
    return
  end
  self.actorTrans:Set_position(FAR_AWAY.x, FAR_AWAY.y, FAR_AWAY.z)
end

function FlowerTrainCheerActor:PlayAniByState()
  self.curState = self:GetCurStateByRemainTime()
  if not self.curState then
    return
  end
  if self.curState == CheerActorState.Drop then
    self:StartDrop()
  elseif self.curState == CheerActorState.DropWait then
    self:StartDropGroundWait()
  elseif self.curState == CheerActorState.Move then
    self:StartMoveTarget()
  elseif self.curState == CheerActorState.Cheer then
    self:StartCheer()
  end
end

function FlowerTrainCheerActor:StartDrop()
  self.curState = CheerActorState.Drop
  if self.moveTween then
    self.moveTween:Kill()
    self.moveTween = nil
  end
  self:PlayAni("down", 0.6)
  self.rotateRoot.localRotation = Quaternion.identity
  self.actorTrans:Set_position(self.fromPos.x, self.fromPos.y + FlowerTrainConstant.FlowerTrainDropDis, self.fromPos.z)
  local endY = self.fromPos.y
  self.moveTween = self.actorTrans:DOMoveY(endY, FlowerTrainConstant.FlowerTrainDropTime):OnComplete(function()
    self:StartDropGroundWait()
  end)
end

function FlowerTrainCheerActor:StartDropGroundWait()
  self.curState = CheerActorState.DropWait
  if self.moveTween then
    self.moveTween:Kill()
    self.moveTween = nil
  end
  self.rotateRoot.localRotation = Quaternion.identity
  self.actorTrans:Set_position(self.fromPos.x, self.fromPos.y, self.fromPos.z)
  self.dropWaitTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:StartMoveTarget()
  end, FlowerTrainConstant.DropWaitTime)
end

function FlowerTrainCheerActor:StartMoveTarget()
  self.curState = CheerActorState.Move
  if self.moveTween then
    self.moveTween:Kill()
    self.moveTween = nil
  end
  self.rotateRoot.localRotation = Quaternion.identity
  self.actorTrans:Set_position(self.fromPos.x, self.fromPos.y, self.fromPos.z)
  self:PlayAni("run")
  local endPos = Vector3(self.targetPos.x, self.targetPos.y, self.targetPos.z)
  self.moveTween = self.actorTrans:DOMove(endPos, FlowerTrainConstant.FlowerTrainCheerRunTime):OnComplete(function()
    self:StartCheer()
  end)
end

function FlowerTrainCheerActor:StartCheer()
  self.curState = CheerActorState.Cheer
  if self.moveTween then
    self.moveTween:Kill()
    self.moveTween = nil
  end
  self.actorTrans:Set_position(self.targetPos.x, self.targetPos.y, self.targetPos.z)
  local index = math.random(1, 5)
  local time = self:PlayAni("happy0" .. index)
  if time and 0 < time then
    self.cheerTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:StartCheer()
    end, time)
  end
end

function FlowerTrainCheerActor:UpdateData(data)
  if not data then
    return
  end
  self.data = data
  self.uid = data.uid
  self.cheerTime = data.cheerTime
  self.pic = data.pic
  self.picVer = data.picVer
  self.headSkinId = data.headSkinId
  self.headSkinET = data.headSkinET
  self.disappearTime = data.disappearTime
  self.isSelf = data.isSelf
  local moveData = data.moveData
  self.fromPos = moveData.fromPos
  self.targetPos = moveData.targetPos
  self.targetRot = moveData.targetRot
end

function FlowerTrainCheerActor:UpdatePlayerHead()
  if IsNull(self.headRoot) then
    return
  end
  self.headRoot:SetActive(false)
  if not self.pic and not self.picVer then
    return
  end
  self.headRoot:SetActive(true)
  self.headIcon:SetData(self.uid, tostring(self.pic), self.picVer, false)
  self.headIcon:SetCustomLoadCallback(function()
    if self.headIcon ~= nil and self.headIcon.transform ~= nil and not IsNull(self.headIcon.transform) then
      local icon = self.headIcon.transform:GetComponent(typeof(SpriteRenderer))
      if not IsNull(icon) then
        icon:Set_size(1, 1)
      end
    end
  end)
end

function FlowerTrainCheerActor:UpdateDisappearTime(disappearTime)
  self.disappearTime = disappearTime
end

function FlowerTrainCheerActor:IsExpire()
  if not self.disappearTime then
    return true
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now > self.disappearTime
end

function FlowerTrainCheerActor:GetUid()
  return self.uid
end

function FlowerTrainCheerActor:PlayAni(aniName, progress)
  if not self.simpleAni or not aniName then
    return
  end
  if not progress or progress <= 0 then
    if self.simpleAni:IsPlaying(aniName) then
      self.simpleAni:Rewind(aniName)
    else
      self.simpleAni:Play(aniName)
      local time = self.simpleAni:GetClipLength(aniName)
      return time or 1
    end
  else
    self.simpleAni:Stop()
    self.simpleAni:SampleAnimationAtTime(aniName, progress)
    self.simpleAni:Play(aniName)
  end
end

function FlowerTrainCheerActor:StopAllTimerAndTween()
  if self.cheerTimer then
    self.cheerTimer:Stop()
    self.cheerTimer = nil
  end
  if self.moveTween then
    self.moveTween:Kill()
    self.moveTween = nil
  end
  if self.dropWaitTimer then
    self.dropWaitTimer:Stop()
    self.dropWaitTimer = nil
  end
end

function FlowerTrainCheerActor:OnChangeCameraLod(lod)
  local lastLod = self.lod == 1
  self.lod = lod
  if lastLod == self.lod then
    return
  end
  local showState = self.lod == 1
  self:CheckShowHideState(showState)
end

function FlowerTrainCheerActor:OnDisplayModeUpdate(displayLv)
  local lastDisplayLv = self.displayLv
  self.displayLv = displayLv
  local isChange = lastDisplayLv ~= self.displayLv
  if not isChange then
    return
  end
  local showState = self.displayLv >= 0
  self:CheckShowHideState(showState)
end

function FlowerTrainCheerActor:CheckShowHideState(showState)
  local lastShowState = self.showState
  self.showState = showState
  if lastShowState == self.showState then
    return
  end
  if self.showState then
    self:PlayAniByState()
  else
    self:Hide()
  end
end

function FlowerTrainCheerActor:GetCurStateByRemainTime()
  if not self.disappearTime then
    return CheerActorState.Drop
  end
  local remainTime = self.disappearTime - UITimeManager:GetInstance():GetServerTime()
  local step1_4_time = FlowerTrainConstant.FlowerTrainDropTime + FlowerTrainConstant.DropWaitTime + FlowerTrainConstant.FlowerTrainCheerRunTime + FlowerTrainConstant.FlowerTrainCheerAniTime
  local step2_4_time = FlowerTrainConstant.DropWaitTime + FlowerTrainConstant.FlowerTrainCheerRunTime + FlowerTrainConstant.FlowerTrainCheerAniTime
  local step3_4_time = FlowerTrainConstant.FlowerTrainCheerRunTime + FlowerTrainConstant.FlowerTrainCheerAniTime
  local step4Time = FlowerTrainConstant.FlowerTrainCheerAniTime
  if remainTime <= step4Time * 1000 then
    return CheerActorState.Cheer
  elseif remainTime <= step3_4_time * 1000 then
    return CheerActorState.Move
  elseif remainTime <= step2_4_time * 1000 then
    return CheerActorState.DropWait
  else
    return CheerActorState.Drop
  end
end

function FlowerTrainCheerActor:Update1000MS()
  if not self.showState then
    return
  end
  if not self.carPointTrans or not self.rotateRoot then
    return
  end
  if self.curState == CheerActorState.Cheer then
    local dirVec = self.carPointTrans.position - self.actorTrans.position
    local targetRotation = Quaternion.LookRotation(Vector3.New(dirVec.x, dirVec.y, dirVec.z))
    self.rotateRoot.rotation = targetRotation or Quaternion.identity
  end
end

return FlowerTrainCheerActor
