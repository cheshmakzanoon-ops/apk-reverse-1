local PveDropRewardBubble = BaseClass("PveDropRewardBubble")
local Resource = CS.GameEntry.Resource
local touch_collider_path = "BubbleAnim/BubbleRotation/BubbleTrigger"
local bubble_anim_path = "BubbleAnim"
local bubble_rotation_path = "BubbleAnim/BubbleRotation"
local progress_path = "CollectGarbageUI"
local BubbleShowRange = 2
local InteractTime = 2000
local AnimName = {
  Enter = "EnterBubble",
  Hide = "HideBubble",
  Normal = "NormalBubble",
  Default = "Default",
  ClickBubble = "ClickBubble",
  Stop = "StopBubble",
  Interact = "InteractBubble"
}

function PveDropRewardBubble:__init()
  self:DataDefine()
  self:OnCreate()
end

function PveDropRewardBubble:Destroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self.transform = nil
  self.gameObject = nil
end

function PveDropRewardBubble:OnCreate()
  if self.req == nil then
    self.req = Resource:InstantiateAsync(UIAssets.PveDropRewardBubble)
    self.req:completed("+", function()
      self.gameObject = self.req.gameObject
      self.transform = self.req.gameObject.transform
      self:ComponentDefine()
      self:ReInit(self.param)
    end)
  end
end

function PveDropRewardBubble:ComponentDefine()
  self.bubble_anim = self.transform:Find(bubble_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.bubble_rotation = self.transform:Find(bubble_rotation_path)
  self:AddTouchTrigger()
  self.progress = self.transform:Find(progress_path)
  if self.progress ~= nil then
    self.icon_Circle = self.progress.transform:GetComponent(typeof(CS.ChangeSceneCircleSlider))
    self.time_text = self.progress.transform:Find("PosGo/TimeText"):GetComponent(typeof(CS.SuperTextMesh))
    self.progress.gameObject:SetActive(false)
  end
end

function PveDropRewardBubble:ComponentDestroy()
  self.bubble_anim = nil
  self.cost_text = nil
  self.cost_bg = nil
  self:RemoveTouchTrigger()
  self.gameObject = nil
  self.transform = nil
  self.time_action = nil
  self.progress = nil
  self.icon_Circle = nil
  self.time_text = nil
end

function PveDropRewardBubble:DataDefine()
  self.req = nil
  self.gameObject = nil
  self.transform = nil
  self.param = {}
  self.enterShowBubble = nil
  self.isOnInteract = false
  
  function self.hide_timer_callback()
    self:HideTimerCallBack()
  end
end

function PveDropRewardBubble:DataDestroy()
  self:RemoveHideTimer()
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self.param = {}
  self.enterShowBubble = nil
  self.isOnInteract = false
  self.hide_timer_callback = nil
end

function PveDropRewardBubble:ReInit(param)
  self.param = param
  if self.transform ~= nil and param ~= nil then
    self.transform.position = self.param.position
    self:PlayAnim(AnimName.Default)
    self.gameObject:SetActive(self.param.visible)
    self:RefreshCameraRotation(self.param.rotation)
    self:OnPlayerMoveSignal(DataCenter.BattleLevel:GetPosition())
    self:StopCollectAnimation()
  end
end

function PveDropRewardBubble:RemoveTouchTrigger()
  if self.touchBubble ~= nil then
    self.touchBubble.onPointerClick = nil
    self.touchBubble = nil
  end
end

function PveDropRewardBubble:AddTouchTrigger()
  if self.touchBubble == nil then
    self.touchBubble = self.transform:Find(touch_collider_path):GetComponent(typeof(CS.UIEventTrigger))
    if self.touchBubble ~= nil then
      function self.touchBubble.onPointerClick()
        self:OnTouchBubbleClick()
      end
    end
  end
end

function PveDropRewardBubble:OnTouchBubbleClick()
  self:PlayAnim(AnimName.ClickBubble)
  local resourceItemNum = 0
  if self.param.info.resArr ~= nil then
    for k, v in ipairs(self.param.info.resArr) do
      resourceItemNum = resourceItemNum + v.num
    end
  end
  if 0 < resourceItemNum and DataCenter.ResourceItemDataManager:CheckIsStorageFull(resourceItemNum) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
  else
    self:ShowCollectAnimation()
  end
end

function PveDropRewardBubble:SetVisible(visible)
  if self.param.visible ~= visible then
    self.param.visible = visible
    if self.gameObject ~= nil then
      self.gameObject:SetActive(visible)
      if visible then
        self:RefreshCameraRotation(self.param.rotation)
        self:OnPlayerMoveSignal(DataCenter.BattleLevel:GetPosition())
      end
    end
  end
end

function PveDropRewardBubble:RefreshCameraRotation(rotation)
  self.param.rotation = rotation
  if self.param.visible and self.transform ~= nil then
    self.bubble_rotation.transform.rotation = rotation
  end
end

function PveDropRewardBubble:PlayAnim(animName)
  if self.bubble_anim:IsPlaying(animName) then
    self.bubble_anim:Rewind(animName)
  else
    self.bubble_anim:Play(animName)
  end
end

function PveDropRewardBubble:DoHideAnim()
  self:PlayAnim(AnimName.Hide)
end

function PveDropRewardBubble:OnPlayerMoveSignal(pos)
  if self.param.visible and self.transform ~= nil then
    local distance = Vector3.Distance(pos, self.param.position)
    if DataCenter.BattleLevel.selectionMgr:Enabled() then
      if distance <= BubbleShowRange then
        DataCenter.BattleLevel.selectionMgr:Add(PveSelectionType.DropReward, self.param.info.uuid)
      else
        DataCenter.BattleLevel.selectionMgr:Remove(PveSelectionType.DropReward, self.param.info.uuid)
        self:Show(false)
      end
    else
      self:Show(distance <= BubbleShowRange)
    end
  end
end

function PveDropRewardBubble:Show(show)
  if not self.param.visible or self.transform == nil then
    return
  end
  if self.enterShowBubble ~= show then
    self.enterShowBubble = show
    self:PlayAnim(show and AnimName.Enter or AnimName.Hide)
  end
end

function PveDropRewardBubble:GetGuideTrigger()
  return self.touchBubble
end

function PveDropRewardBubble:ShowCollectAnimation()
  if self.progress == nil or self.isOnInteract then
    return
  end
  self.isOnInteract = true
  self.bubble_anim.gameObject:SetActive(false)
  self.progress.gameObject:SetActive(true)
  self.startTime = math.floor(UITimeManager:GetInstance():GetServerTime())
  local gapTime = InteractTime
  self.endTime = self.startTime + gapTime
  self.icon_Circle:Init(self.startTime, self.endTime)
  self:AddHideTimer(gapTime / 1000)
  DataCenter.BattleLevel:TurnToPos(self.param.position)
  DataCenter.BattleLevel:PlayInterActAnim("interact", gapTime, nil)
end

function PveDropRewardBubble:StopCollectAnimation()
  if self.progress == nil then
    return
  end
  self.isOnInteract = false
  self.bubble_anim.gameObject:SetActive(true)
  self.progress.gameObject:SetActive(false)
end

function PveDropRewardBubble:AddHideTimer(timeDelay)
  self:RemoveHideTimer()
  if self.hideTimer == nil then
    self.hideTimer = TimerManager:GetInstance():GetTimer(timeDelay, self.hide_timer_callback, self, true, false, false)
  end
  self.hideTimer:Start()
end

function PveDropRewardBubble:HideTimerCallBack()
  self:RemoveHideTimer()
  self:FlyReward()
  self:SetVisible(false)
  local param = {}
  param.level = self.param.levelId
  param.uuid = self.param.info.uuid
  DataCenter.PveDropRewardInfoManager:SendReceiveDropItem(param)
end

function PveDropRewardBubble:RemoveHideTimer()
  if self.hideTimer ~= nil then
    self.hideTimer:Stop()
    self.hideTimer = nil
  end
end

function PveDropRewardBubble:FlyReward()
  if self.param.info.resArr ~= nil then
    local srcPos = DataCenter.BattleLevel:WorldToScreenPoint(self.param.position)
    local rewardType = RewardType.RESOURCE_ITEM
    local targetPos = DataCenter.BattleLevel:GetRewardFlyPos(rewardType)
    for k, v in ipairs(self.param.info.resArr) do
      local pic = DataCenter.RewardManager:GetPicByType(rewardType, v.id)
      local tmp = DataCenter.RewardManager:GetRewardNumsInPveScene(v.num, false, rewardType)
      UIUtil.DoJumpFly(pic, tmp, srcPos, targetPos)
    end
  end
end

return PveDropRewardBubble
