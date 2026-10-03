local base = require("Scene.Monopoly.Base.BaseObstacle")
local PickBoxObstacle = BaseClass("PickBoxObstacle", base)
local Const = require("Scene.Monopoly.Const")

function PickBoxObstacle:__delete()
  if self.obstacleRes then
    self.obstacleRes:Destroy()
    self.obstacleRes = nil
    self.obstacle = nil
  end
  if self.boxObjRes then
    self.boxObjRes:Destroy()
    self.boxObj = nil
  end
  if self.placeality then
    self.placeality:Delete()
    self.placeality = nil
  end
  if self.boxEffectRes then
    self.boxEffectRes:Destroy()
    self.boxEffect = nil
  end
  if not IsNull(self.boxObjTrigger) then
    self.boxObjTrigger.onPointerClick = nil
    self.boxObjTrigger = nil
  end
  if self.effectDelay then
    self.effectDelay:Stop()
    self.effectDelay = nil
  end
  self.effectNode = nil
  self.SBattle = nil
  self.isShowBox = nil
  self.plotPlayed = nil
end

function PickBoxObstacle:__init()
  self.isShowBox = false
  self.boxObj = nil
  self.transform = nil
  self.boxAnim = nil
end

function PickBoxObstacle:OnTriggerClick()
  base.OnTriggerClick(self)
end

function PickBoxObstacle:Fire()
  if self.isShowBox or string.IsNullOrEmpty(self.data.variantPatch) then
    self:OnBoxClick()
    if not IsNull(self.boxObjTrigger) then
      self.boxObjTrigger.onPointerClick = nil
      self.boxObjTrigger = nil
    end
    if not IsNull(self.battleEffectTrigger) then
      self.battleEffectTrigger.onPointerClick = nil
    end
    return
  end
  if self.obstacleRes then
    self.obstacleRes:Destroy()
    self.obstacleRes = nil
    self.obstacle = nil
  end
  self.obstacleRes = self:CreateObject(string.format(UIAssets.MonopolyObstacle, self.data.variantPatch), function(req)
    if IsNull(req) or IsNull(req.gameObject) then
      return
    end
    self.isShowBox = true
    self.obstacle = req.gameObject
    local pos = self.data:GetCenterWorldPos()
    self.obstacle.transform:Set_position(pos.x, pos.y + 0.3, pos.z)
    self.modelTrigger = self.obstacle:GetComponent(typeof(CS.TouchObjectEventTrigger))
    if self.modelTrigger then
      function self.modelTrigger.onPointerClick()
        self:OnBoxClick()
      end
    end
    local id = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(self.data.id)
    local data = DataCenter.MonopolyManager:GetPlacealityDataById(id)
    if data and self.data:IsRotate() then
      local pos1 = data:GetCenterWorldPos()
      local lookRot = Vector3.Normalize(pos1 - pos)
      if lookRot ~= Vector3.zero then
        lookRot = Quaternion.LookRotation(lookRot, Vector3.up)
      end
      if not IsNull(self.obstacle.transform) then
        self.obstacle.transform.rotation = lookRot
      end
    end
    self.simpleAnim = self.obstacle.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if not IsNull(self.simpleAnim) then
      self.simpleAnim.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
    end
    self.simpleAnim:Play(Const.animNames.idle)
    if self.SBattle then
      self:OnBoxClick()
    end
  end)
end

function PickBoxObstacle:OnEventEnd()
  local pos = self.data:GetCenterWorldPos()
  local effectPos = Vector3.New(pos.x, pos.y + 2, pos.z)
  self.mgr.effectMgr:ShowEffectObj(Const.boxOpenEffectPath, effectPos)
  if self.tileEffectRes then
    self.tileEffectRes:Destroy()
  end
  if self.battleEffectRes then
    self.battleEffectRes:Destroy()
  end
  self:DestroyObstacleRes()
  self:ClearBubble()
  self.isShowBox = false
  DataCenter.MonopolyManager:PlayerGo()
  EventManager:GetInstance():Broadcast(EventId.GF_monopoly_box_opened, self.data.id)
end

function PickBoxObstacle:OnBattleEffectTriggerClick()
  if self:IsLock() then
    return
  end
  if self.data.plot_before ~= nil and not string.IsNullOrEmpty(tostring(self.data.plot_before)) and not self.isShowBox then
    if self.plotPlayed then
      return
    end
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = tonumber(self.data.plot_before),
      hideMainUI = true
    })
    self.plotPlayed = true
  else
    self:Fire()
  end
end

function PickBoxObstacle:OnBoxClick()
  if self.simpleAnim then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Novice_Chest_Open, false)
    local time = self.simpleAnim:GetClipLength(Const.animNames.quickOpen)
    if 0 < time then
      self.simpleAnim:Play(Const.animNames.quickOpen)
      self.effectDelay = TimerManager:GetInstance():DelayInvoke(function()
        self:PlayerGoNext()
      end, time)
    else
      self:PlayerGoNext()
    end
  else
    self:PlayerGoNext()
  end
end

function PickBoxObstacle:PlayerGoNext()
  if self.data.state == MonopolyPlacealityType.Arrive then
    DataCenter.MonopolyManager:UnLockCurMonopolyAndSave()
  end
end

function PickBoxObstacle:TryShowIconBorn()
  if not IsNull(self.transform) then
    local goodsIcon = self.transform:Find("MonopolyGoodsIcon")
    if not IsNull(goodsIcon) then
      local iconSimpleAnim = goodsIcon:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      if not IsNull(iconSimpleAnim) then
        local state = iconSimpleAnim:GetState("EnterBubble")
        if state ~= nil then
          iconSimpleAnim:SampleAnimationAtTime("EnterBubble", 0)
          iconSimpleAnim:Play("EnterBubble")
          iconSimpleAnim:PlayQueued("Default")
        end
      end
    end
  end
end

return PickBoxObstacle
