local base = require("Scene.Monopoly.Performance.Performance.MonopolyPerBase")
local MonopolyPerEasterEgg = BaseClass("MonopolyPerEasterEgg", base)
local RewardUtil = require("Util.RewardUtil")
local triggerPath = "root"
local targetPosPath = "targetPos"
local oldManTrackName = "fenglaotouTrack"
local zombieTrackName = "zombieTrack"
local runAnimName = "run"
local rewardAnimName = "reward"
local deadAnimName = "dead"
local walkDuration = 0.5
local flyDelay = 3.3
local smilingFaceDelay = 2.5

function MonopolyPerEasterEgg:__init(mgr, id, lineData)
  self.landId = tonumber(lineData:getValue("land_id"))
  self.director = nil
  self.oldManTrans = nil
  self.modelTrigger = nil
  self.zombieHideTimer = nil
  self.smilingFaceHideTimer = nil
  self.rewardTimer = nil
  self.walkTweener = nil
  self.handleTrans = nil
  self.clicked = false
  self.zombieList = nil
  self.uiRootTrans = nil
  self.autoFaceObj = nil
  self.autoFaceComponent = nil
  self.smilingFaceIconObj = nil
  self.questionIconObj = nil
end

function MonopolyPerEasterEgg:__delete()
end

function MonopolyPerEasterEgg:OnDestroy()
  if self.zombieList and self.zombieList.Count > 0 then
    for i = 0, self.zombieList.Count - 1 do
      local zombie = self.zombieList[i]
      if not IsNull(zombie) then
        zombie:SetActive(true)
      end
    end
  end
  if self.zombieHideTimer then
    self.zombieHideTimer:Stop()
    self.zombieHideTimer = nil
  end
  if self.smilingFaceHideTimer then
    self.smilingFaceHideTimer:Stop()
    self.smilingFaceHideTimer = nil
  end
  if self.rewardTimer then
    self.rewardTimer:Stop()
    self.rewardTimer = nil
  end
  if self.flyTimer then
    self.flyTimer:Stop()
    self.flyTimer = nil
  end
  if self.walkTweener then
    self.walkTweener:Kill()
    self.walkTweener = nil
  end
  if self.modelTrigger then
    self.modelTrigger.onPointerClick = nil
  end
  self.landId = nil
  self.oldManTrans = nil
  self.modelTrigger = nil
  self.handleTrans = nil
  self.zombieList = nil
  self.uiRootTrans = nil
  self.iconBgObj = nil
  self.autoFaceObj = nil
  self.autoFaceComponent = nil
  self.smilingFaceIconObj = nil
  self.questionIconObj = nil
  base.OnDestroy(self)
end

function MonopolyPerEasterEgg:Begin()
  base.Begin(self)
end

function MonopolyPerEasterEgg:OnResLoaded(handle)
  base.OnResLoaded(self, handle)
  local director = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
  handle.gameObject.transform.position = Vector3.zero
  self.director = director
  self.handleTrans = handle.gameObject.transform
  local triggerTrans = handle.gameObject.transform:Find(triggerPath)
  if triggerTrans then
    self.modelTrigger = triggerTrans.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
    if self.modelTrigger then
      function self.modelTrigger.onPointerClick()
        self:OnTriggerClick()
      end
    end
  end
  local oldManObj = CS.TimelineHelper.GetGenericBindingByTrackName(self.director, oldManTrackName)
  if oldManObj then
    self.oldManTrans = oldManObj.transform
    self.uiRootTrans = self.oldManTrans:Find("UI")
    self.autoFaceObj = nil
    self.autoFaceComponent = nil
    self.iconBgObj = nil
    self.smilingFaceIconObj = nil
    self.questionIconObj = nil
    if not IsNull(self.uiRootTrans) then
      self.uiRootTrans.gameObject:SetActive(true)
      local autoFaceTrans = self.uiRootTrans:Find("TipRoot")
      if autoFaceTrans then
        self.autoFaceObj = autoFaceTrans.gameObject
        self.autoFaceComponent = self.autoFaceObj:GetComponent(typeof(CS.AutoFaceToCamera))
        if self.autoFaceComponent then
          self.autoFaceComponent.IgnoreCacheRotation = true
        end
      end
      local iconBgTrans = self.uiRootTrans:Find("TipRoot/Icon")
      if iconBgTrans then
        self.iconBgObj = iconBgTrans.gameObject
        self.iconBgObj:SetActive(true)
      end
      local smileTrans = self.uiRootTrans:Find("TipRoot/Icon/SmilingFaceIcon")
      if smileTrans then
        self.smilingFaceIconObj = smileTrans.gameObject
        self.smilingFaceIconObj:SetActive(false)
      end
      local questionTrans = self.uiRootTrans:Find("TipRoot/Icon/QuestionIcon")
      if questionTrans then
        self.questionIconObj = questionTrans.gameObject
        self.questionIconObj:SetActive(true)
      end
    end
  end
  if not IsNull(director) then
    director:Play()
  end
end

function MonopolyPerEasterEgg:End()
  base.End(self)
end

function MonopolyPerEasterEgg:OnTriggerClick()
  if self.clicked then
    return
  end
  self.clicked = true
  self.director:Stop()
  SFSNetwork.SendMessage(MsgDefines.ReceiveLandEggReward, self.landId)
  if self.oldManTrans == nil then
    self.mgr:TryTriggerPerformanceEnd(self.id)
    return
  end
  local oldManTrans = self.oldManTrans
  local targetTrans = self.handleTrans:Find(targetPosPath)
  if not targetTrans then
    self.mgr:TryTriggerPerformanceEnd(self.id)
    return
  end
  local targetPos = self:GetTargetPos(targetTrans, oldManTrans)
  if targetPos == nil then
    self.mgr:TryTriggerPerformanceEnd(self.id)
    return
  end
  if self.iconBgObj then
    self.iconBgObj:SetActive(false)
    self.iconBgObj:SetActive(true)
  end
  if self.smilingFaceIconObj then
    self.smilingFaceIconObj:SetActive(true)
  end
  if self.questionIconObj then
    self.questionIconObj:SetActive(false)
  end
  local zombieList = CS.TimelineHelper.GetGenericBindingListByTrackName(self.director, zombieTrackName)
  self.zombieList = zombieList
  local deadDuration = 0
  if zombieList and 0 < zombieList.Count then
    for i = 0, zombieList.Count - 1 do
      local zombie = zombieList[i]
      if not IsNull(zombie) then
        local simpleAni = zombie:GetComponent(typeof(CS.SimpleAnimation))
        if simpleAni then
          simpleAni:Play(deadAnimName)
          if i == 0 then
            deadDuration = simpleAni:GetClipLength(deadAnimName)
          end
        end
      end
    end
  end
  if 0 < deadDuration then
    self.zombieHideTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.zombieHideTimer = nil
      if self.state == base.State.Destroy then
        return
      end
      if self.zombieList and self.zombieList.Count > 0 then
        for i = 0, self.zombieList.Count - 1 do
          local zombie = self.zombieList[i]
          if not IsNull(zombie) then
            zombie:SetActive(false)
          end
        end
      end
    end, deadDuration)
  end
  local simpleAni = oldManTrans:GetComponent(typeof(CS.SimpleAnimation))
  if simpleAni then
    simpleAni:Play(runAnimName)
  end
  oldManTrans:LookAt(targetPos)
  self.walkTweener = oldManTrans:DOMove(targetPos, walkDuration):OnComplete(function()
    self.walkTweener = nil
    if self.state == base.State.Destroy then
      return
    end
    oldManTrans.forward = -Vector3.forward
    if simpleAni then
      simpleAni:Play(rewardAnimName)
      local clipLength = simpleAni:GetClipLength(rewardAnimName)
      self.smilingFaceHideTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.smilingFaceHideTimer = nil
        if self.state == base.State.Destroy then
          return
        end
        if self.uiRootTrans then
          self.uiRootTrans.gameObject:SetActive(false)
        end
      end, smilingFaceDelay)
      self.flyTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.flyTimer = nil
        if self.state == base.State.Destroy then
          return
        end
        self:PlayRewardFly()
      end, flyDelay)
      self.rewardTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.rewardTimer = nil
        if self.state == base.State.Destroy then
          return
        end
        self.mgr:TryTriggerPerformanceEnd(self.id)
      end, clipLength)
    else
      self:PlayRewardFly()
      self.mgr:TryTriggerPerformanceEnd(self.id)
    end
  end):SetEase(CS.DG.Tweening.Ease.InQuad)
end

function MonopolyPerEasterEgg:GetTargetPos(targetParent, oldManTrans)
  local closestTrans
  local closestDistSq = math.huge
  local oldManPos = oldManTrans.position
  local childCount = targetParent.childCount
  for i = 0, childCount - 1 do
    local child = targetParent:GetChild(i)
    if child then
      local offset = child.position - oldManPos
      local distSq = offset.sqrMagnitude
      if closestDistSq > distSq then
        closestDistSq = distSq
        closestTrans = child
      end
    end
  end
  if not closestTrans then
    return
  end
  return closestTrans.position
end

function MonopolyPerEasterEgg:PlayRewardFly()
  local reward = self.mgr:ConsumeLandEggReward(self.landId)
  if not reward then
    return
  end
  local oldManPos = self.oldManTrans.position + Vector3(-0.8, 6.6, 0.4)
  local srcPos = CS.CSUtils.WorldPositionToUISpacePosition(oldManPos)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if window and window.Ctrl:IsVisible() then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(reward) or {}
    for i, v in ipairs(rewardList) do
      local tempType = v.rewardType
      local tempId = v.itemId
      local pic = RewardUtil.GetPic(tempType, tempId)
      UIUtil.DoFly(tonumber(tempType), 5, pic, srcPos, UIUtil.GetFlyTargetByRewardType(tonumber(tempType)))
    end
  end
end

return MonopolyPerEasterEgg
