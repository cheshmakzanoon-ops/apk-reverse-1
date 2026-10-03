local base = require("Scene.Monopoly.Base.BaseObject")
local MapDecorateEvent = BaseClass("MapDecorateEvent", base)
local anchor = Vector3.New(0, 3, 0)
local ResourceManager = CS.GameEntry.Resource
local Const = require("Scene.Monopoly.Const")

function MapDecorateEvent:OnDelete()
  if self.originChildrenVisible then
    for k, v in pairs(self.originChildrenVisible) do
      local child = self.gameObject.transform:Find(k)
      if not IsNull(child) then
        child.gameObject:SetActive(v)
      end
    end
  end
  self.originChildrenVisible = nil
  self.visible = nil
  self.childrenVisible = nil
  self:ClearBornEffect()
  if self.res then
    self.res:Destroy()
    self.res = nil
    self.gameObject = nil
    self.effectNode = nil
    self.mainNode = nil
  end
  if self.resBubble then
    self.resBubble:Destroy()
    self.resBubble = nil
    self.gameObjectBubble = nil
  end
  self:ClearDelay()
  self.anim = nil
  self.curPlotId = nil
  self.fingerHandle = nil
end

function MapDecorateEvent:ArrivalBefore()
  local curLand = self.mgr:GetCurrentLandLock()
  if DataCenter.LWCivilizationSparkExtend:MonopolyManager_getLandLockIdDiff(curLand, self.data.event_display_id) < 0 then
    return
  end
  self:LoadEvent()
end

function MapDecorateEvent:LoadEvent()
  if not IsNull(self.res) then
    return
  end
  self.res = self:CreateObject(string.format(UIAssets.MonopolyTiles, self.data.pad_before), function(req)
    local pos = self.data:GetLeftLowerWorldPos()
    req.gameObject.transform:Set_position(pos.x + 1, pos.y, pos.z - 1)
    if self.mgr.parent.transform then
      req.gameObject.transform:SetParent(self.mgr.parent.transform)
    end
    self.gameObject = req.gameObject
    if self.visible == nil then
      self.gameObject:SetActive(true)
    else
      self.gameObject:SetActive(self.visible)
    end
    if self.childrenVisible then
      for k, v in pairs(self.childrenVisible) do
        local child = self.gameObject.transform:Find(k)
        if not IsNull(child) then
          child.gameObject:SetActive(v)
        end
      end
    end
    local transform = self.gameObject.transform
    self.effectNode = transform:Find("EffectNode")
    local curLandLock = DataCenter.MonopolyManager:GetCurrentLandLock()
    local diff = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getLandLockIdDiff(self.data.land_lock, curLandLock)
    local show = 0 <= diff and diff <= 1
    if not IsNull(self.effectNode) then
      self.effectNode.gameObject:SetActive(show)
    end
    local zombieNodeTransform = transform:Find("ZombieNode")
    if zombieNodeTransform then
      self.zombieNode = zombieNodeTransform.gameObject
    end
    local mainNode = transform:Find("MainNode")
    self.mainNode = mainNode
    if not IsNull(mainNode) then
      self.anim = mainNode:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    end
    if not IsNull(self.anim) then
      self.anim.cullingMode = CS.UnityEngine.AnimatorCullingMode.AlwaysAnimate
    end
    self.trigger = req.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
    self.triggerBubbleNode = transform:Find("LandLockBubble_mono_Event")
    if self.triggerBubbleNode then
      self.triggerBubbleNode.gameObject:SetActive(false)
    end
    if self.triggerBubbleNode and self.data.headPath and self.data.textKey then
      self.triggerBubble = self.triggerBubbleNode.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
      if self.triggerBubble then
        function self.triggerBubble.onPointerClick()
          self:OnTriggerBubbleClick()
        end
      end
      if self.trigger then
        function self.trigger.onPointerClick()
          self:OnTriggerBubbleClick()
        end
      end
    elseif self.trigger then
      function self.trigger.onPointerClick()
        self:OnTriggerClick()
      end
    end
    if self.bornEvent then
      local clipLength = self:GetAnimLength("born")
      if 0 < clipLength then
        self:ClearDelay()
        self.bornDelay = TimerManager:GetInstance():DelayInvoke(function()
          self:OnBornAfter(true)
        end, clipLength)
        self:PlaySimpleAnim("born")
        if self.data.sound_id_born and 0 < self.data.sound_id_born then
          DataCenter.LWSoundManager:PlaySound(self.data.sound_id_born, false)
        end
        if self.zombieNode then
          self.zombieNode:SetActive(false)
        end
      end
      return
    end
    self:OnBornAfter()
  end)
end

function MapDecorateEvent:OnBornAfter(showEffect)
  self:PlaySimpleAnim("Default")
  local curLandLock = DataCenter.MonopolyManager:GetCurrentLandLock()
  local unlock = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getLandLockIdDiff(curLandLock, self.data.land_lock) > 0
  if unlock then
    if DataCenter.MonopolyManager:IsLeaveLand(self.data.land_lock) then
      self:OnUnLandLock()
    elseif self.zombieNode then
      self.zombieNode:SetActive(true)
    end
  elseif self.zombieNode then
    self.zombieNode:SetActive(true)
  end
  if self.triggerBubbleNode and self.data.headPath and self.data.textKey then
    self.triggerBubbleNode.gameObject:SetActive(not unlock)
  else
    self:PlayPlot()
  end
  if showEffect then
    self:ShowBornEffect()
  end
end

function MapDecorateEvent:ClearDelay()
  if self.bornDelay then
    self.bornDelay:Stop()
    self.bornDelay = nil
  end
end

function MapDecorateEvent:OnUnLandLock()
  if self.zombieNode then
    self.zombieNode:SetActive(false)
  end
end

function MapDecorateEvent:OnBorn(landId)
  if self.data.event_display_id == landId then
    self.bornEvent = true
    self:LoadEvent()
  end
end

function MapDecorateEvent:PlaySimpleAnim(anim)
  if self.anim then
    self.anim:Play(anim)
  end
end

function MapDecorateEvent:PlayQueued(anim)
  if self.anim then
    self.anim:PlayQueued(anim)
  end
end

function MapDecorateEvent:GetAnimLength(name)
  if self.anim then
    self.anim:SetStateSpeed(name, 1)
    return self.anim:GetClipLength(name)
  else
    return 0
  end
end

function MapDecorateEvent:OnTriggerClick()
  self:PlayPlot()
  self.fingerHandle = DataCenter.LWGuideVFXManager:InstantiateAsync("Assets/Main/Prefabs/LWOpeningStage/finger_click.prefab", self.OnVfxLoaded, self, 2, GuideVFXPriority.Low, self.fingerHandle)
end

function MapDecorateEvent:OnTriggerBubbleClickHandle(id)
  SceneUtils.ChangeToCity(function()
    local data = DataCenter.MonopolyManager:GetPlacealityDataById(tonumber(id))
    GoToUtil.GotoPos(data:GetCenterWorldPos(), CS.SceneManager.World.InitZoom, 0.5, function()
      local param = {}
      param.position = CS.CSUtils.WorldPositionToUISpacePosition(data:GetCenterWorldPos())
      param.arrowType = ArrowType.Building
      param.positionType = PositionType.Screen
      DataCenter.ArrowManager:ShowArrow(param)
    end)
  end)
end

function MapDecorateEvent:OnTriggerBubbleClick()
  if self.data and self.data.headPath and self.data.textKey then
    local param = {
      headPath = self.data.headPath,
      textKey = self.data.textKey,
      reward_show = self.data.event_reward_show,
      func = function()
        self:OnTriggerBubbleClickHandle(DataCenter.MonopolyManager.player.curId)
      end
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWNewbieEventPopView, {anim = true}, param)
  end
end

function MapDecorateEvent:PlayPlot()
  local cur = self.curPlotId or 0
  if 0 < cur then
    EventManager:GetInstance():Broadcast(EventId.RemovePlotBubbleById, cur)
    self.curPlotId = 0
  end
  if self.data then
    local newPlot = self.data:GetRandomEventPlotId(cur)
    if 0 < newPlot then
      local bubbleParams = {}
      bubbleParams.plotId = newPlot
      local targetPos = self.data:GetCenterWorldPos()
      targetPos.y = targetPos.y + 3
      bubbleParams.anchor = targetPos
      bubbleParams.mode = "3D"
      self.curPlotId = newPlot
      EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleOnlyId, bubbleParams)
    end
  end
end

function MapDecorateEvent:OnVfxLoaded(handle)
  if handle.isError then
    return
  end
  local gameObject = handle.gameObject
  local curObs = DataCenter.MonopolyManager:GetCurObstacle()
  if curObs and curObs.data and curObs.modelHeight then
    local transform = gameObject.transform
    local pos = curObs.data:GetCenterWorldPos()
    transform:SetParent(self.mgr.parent.transform, false)
    transform:Set_localPosition(pos.x, pos.y + curObs.modelHeight + 2.5, pos.z)
    transform:Set_localScale(2, 2, 2)
  else
    gameObject:SetActive(false)
  end
end

function MapDecorateEvent:ShowBornEffect()
  self:ClearBornEffect()
  local path = self.data.bornEffect
  if string.IsNullOrEmpty(path) then
    return
  end
  self.bornEffectReq = ResourceManager:InstantiateAsync(path)
  self.bornEffectReq:completed("+", function(handle)
    if handle.isError then
      self:ClearBornEffect()
      return
    end
    if IsNull(self.mainNode) then
      self:ClearBornEffect()
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(self.mainNode)
    transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  end)
end

function MapDecorateEvent:ClearBornEffect()
  if self.bornEffectReq then
    self.bornEffectReq:Destroy()
    self.bornEffectReq = nil
  end
end

function MapDecorateEvent:SetVisible(visible)
  self.visible = visible
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(visible)
  end
end

function MapDecorateEvent:SetChildVisible(visible, childPath)
  if self.originChildrenVisible == nil then
    self.originChildrenVisible = {}
  end
  if self.childrenVisible == nil then
    self.childrenVisible = {}
  end
  self.childrenVisible[childPath] = visible
  if not IsNull(self.gameObject) then
    local child = self.gameObject.transform:Find(childPath)
    if not IsNull(child) then
      if self.originChildrenVisible[childPath] == nil then
        self.originChildrenVisible[childPath] = child.gameObject.activeSelf
      end
      child.gameObject:SetActive(visible)
    end
  end
end

return MapDecorateEvent
