local UILWVIPRadarPanelView = BaseClass("UILWVIPRadarPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TextAlignmentOptions = CS.TMPro.TextAlignmentOptions
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local VIPRadarRewardUtil = require("UI.UILWVIPRadar.Main.VIPRadarRewardUtil")
local math_floor = math.floor
local math_min = math.min
local table_insert = table.insert
local Quality2BgPath = {
  [ItemColor.PURPLE] = "Assets/Main/Sprites/UI/UILWVIPRadar/wxy_leida_libao_ziseqipao.png",
  [ItemColor.GREEN] = "Assets/Main/Sprites/UI/UILWVIPRadar/wxy_leida_libao_ziseqipao_cheng.png",
  [ItemColor.GOLDEN] = "Assets/Main/Sprites/UI/UILWVIPRadar/wxy_leida_libao_ziseqipao_cheng.png"
}
local DefaultNoteBgPath = Quality2BgPath[ItemColor.GREEN] or Quality2BgPath[ItemColor.PURPLE] or Quality2BgPath[ItemColor.GOLDEN]
local CLAIM_REQUEST_TIMEOUT = 5
local AnimNames = {
  ENTER = "V_ui_UILWVIPRadarPanel_in",
  PAY = "V_ui_UILWVIPRadarPanel_pay",
  FINISH = "V_ui_UILWVIPRadarPanel_finish",
  EXIT = "CommonPopup_moveout"
}

local function render_reward_list(self, container, items, requestField, cellField, namePattern, options)
  options = options or {}
  if container then
    UIUtil.ClearReward(container, self[requestField])
  end
  local reqList = {}
  self[requestField] = reqList
  local cellList = {}
  self[cellField] = cellList
  if not (container and UIAssets) or not UIAssets.UICommonResItem then
    return
  end
  if not items or #items == 0 then
    return
  end
  local pattern = namePattern or "reward_%d"
  local hideCount = options.hideCount
  local hideRoot = options.hideRoot
  for index, reward in ipairs(items) do
    local rewardData = reward
    local idx = index
    local req
    req = container:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function()
      if not container then
        return
      end
      local go = req and req.gameObject or nil
      if not go then
        return
      end
      go.name = string.format(pattern, idx)
      go.transform:SetParent(container.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      local cell = container:AddComponent(UICommonResItem, go)
      cell:ReInit(rewardData)
      cellList[#cellList + 1] = cell
      if hideCount then
        cell:SetItemCountActive(false)
      end
      if hideRoot then
        cell:SetActive(false)
      end
      if options.onCellCreated then
        options.onCellCreated(cell, rewardData, idx, go)
      end
    end)
    if req then
      reqList[#reqList + 1] = req
    end
  end
end

function UILWVIPRadarPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local info = self:GetUserData()
  self.actId = tonumber(info.actId) or 0
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if not self.activityInfo then
    self.ctrl:CloseSelf()
    return
  end
  do
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.actId > 0 then
      local disappearTime = self.vipManager:GetDisappearTime(self.actId) or 0
      if disappearTime and 0 < disappearTime and curTime >= disappearTime then
        self.ctrl:CloseSelf()
        return
      end
      self.activityDisappearTime = disappearTime
    end
  end
  self:StartDisappearTimerIfNeeded()
  self:StartCountdownTimer()
  self:RefreshView()
end

function UILWVIPRadarPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWVIPRadarPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.info_btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.info_btn:SetOnClick(function()
    self:OnInfo_btnClick()
  end)
  self.close_btn = self.viewSkin:AddComponent(self, UIButton, 2)
  self.close_btn:SetOnClick(function()
    self:OnClose_btnClick()
  end)
  self.buy_btn_comp = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.noteTip_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.giftPackName_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.discount_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.packageReward_container = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.claimReward = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.todayState_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.limitState_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.claim_btn = self.viewSkin:AddComponent(self, UIButton, 11)
  self.claim_btn:SetOnClick(function()
    self:OnClaim_btnClick()
  end)
  self.extraReward = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.title_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.claim_btn_container = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.payState = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.finishState = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.note_btn = self.viewSkin:AddComponent(self, UIButton, 17)
  self.note_btn:SetOnClick(function()
    self:OnNote_btnClick()
  end)
  self.note_bg = self.viewSkin:AddComponent(self, UIImage, 18)
  self.noteItem_icon = self.viewSkin:AddComponent(self, UIImage, 19)
  self.discover_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.vipLvLimit_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.countdown_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  if self.vipLvLimit_txt then
    self.vipLvLimit_txt:SetActive(false)
  end
  self.buy_btn = self:AddComponent(LWBtnBuyRefundRemind, self.buy_btn_comp.gameObject)
  self.anim = self:AddComponent(UIAnimator, "")
end

function UILWVIPRadarPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.info_btn = nil
  self.close_btn = nil
  self.buy_btn_comp = nil
  self.noteTip_txt = nil
  self.giftPackName_txt = nil
  self.discount_txt = nil
  self.packageReward_container = nil
  self.claimReward = nil
  self.todayState_txt = nil
  self.limitState_txt = nil
  self.claim_btn = nil
  self.extraReward = nil
  self.title_txt = nil
  self.claim_btn_container = nil
  self.payState = nil
  self.finishState = nil
  self.note_btn = nil
  self.note_bg = nil
  self.noteItem_icon = nil
  self.discover_txt = nil
  self.vipLvLimit_txt = nil
  self.countdown_txt = nil
end

function UILWVIPRadarPanelView:DataDefine()
  self.actId = 0
  self.activityInfo = nil
  self.vipManager = DataCenter.VipGiftActDataManager or nil
  self.summary = nil
  self.currentGiftEntry = nil
  self.rewardReqs = {}
  self.claimRewardReqs = {}
  self.claimRewardCells = {}
  self.extraRewardReqs = {}
  self.extraRewardCells = {}
  self.claimRewardPending = false
  self.claimRewardTimeoutTimer = nil
  self.currentAnimState = nil
  self.closeAnimTimer = nil
  self.enterAnimTimer = nil
  self.programAnimationStartTimer = nil
  self.programAnimationTimers = {}
  self.delayPayAnimation = false
  self.pendingPayAnimation = nil
  self.programAnimationActive = false
  self.preClaimAnimationState = nil
  self.currentExtraSnapshot = nil
  self.currentFreeSnapshot = nil
  self.latestDiscountValue = nil
  self.discoverTextTimer = nil
  self.isClosing = false
  self.isPlayingEnter = false
  self.activityDisappearTime = nil
  self.countdownEndTime = nil
  self.lastCountdownUpdateTime = 0
end

function UILWVIPRadarPanelView:DataDestroy()
  self:ClearClaimRewardTimeout()
  self:StopCloseAnimationTimer()
  self:StopEnterAnimationTimer()
  UIUtil.ClearReward(self.packageReward_container, self.rewardReqs)
  UIUtil.ClearReward(self.claimReward, self.claimRewardReqs)
  UIUtil.ClearReward(self.extraReward, self.extraRewardReqs)
  self.rewardReqs = {}
  self.claimRewardReqs = {}
  self.claimRewardCells = {}
  self.extraRewardReqs = {}
  self.extraRewardCells = {}
  self.actId = 0
  self.activityInfo = nil
  self.summary = nil
  self.currentGiftEntry = nil
  self.claimRewardPending = false
  self.claimRewardTimeoutTimer = nil
  self.currentAnimState = nil
  self.enterAnimTimer = nil
  self:StopProgramAnimationTimers()
  self.programAnimationStartTimer = nil
  self.programAnimationTimers = {}
  self.delayPayAnimation = false
  self.pendingPayAnimation = nil
  self.programAnimationActive = false
  self.preClaimAnimationState = nil
  self.currentExtraSnapshot = nil
  self.currentFreeSnapshot = nil
  self.latestDiscountValue = nil
  self:StopDiscoverTextTimer()
  self.discoverTextTimer = nil
  self.isClosing = false
  self.isPlayingEnter = false
  self.countdownEndTime = nil
  self.lastCountdownUpdateTime = 0
end

function UILWVIPRadarPanelView:StartDisappearTimerIfNeeded()
  if not self.vipManager or self.actId <= 0 then
    return
  end
  local disappearTime = self.activityDisappearTime
  if not disappearTime or disappearTime <= 0 then
    disappearTime = self.vipManager:GetDisappearTime(self.actId) or 0
    self.activityDisappearTime = disappearTime
  end
  if not disappearTime or disappearTime <= 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if disappearTime <= curTime then
    if not self.isClosing then
      self:CloseWithAnimation()
    end
    return
  end
end

function UILWVIPRadarPanelView:StopCountdownTimer()
  self.countdownEndTime = nil
  self.lastCountdownUpdateTime = 0
  if self.countdown_txt then
    self.countdown_txt:SetActive(false)
  end
end

function UILWVIPRadarPanelView:StartCountdownTimer()
  if not self.countdown_txt then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = 0
  if 0 < self.actId then
    endTime = self.vipManager:GetDisappearTime(self.actId) or 0
  end
  if (not endTime or endTime <= 0) and self.activityInfo and self.activityInfo.GetShowEndTime then
    endTime = self.activityInfo:GetShowEndTime() or 0
  end
  if not endTime or endTime <= 0 or curTime >= endTime then
    self:StopCountdownTimer()
    return
  end
  self.activityDisappearTime = endTime
  self.countdownEndTime = endTime
  self.lastCountdownUpdateTime = 0
  UIUtil.SetLeftTimeText(self.countdown_txt, nil, endTime)
  self.countdown_txt:SetActive(true)
end

function UILWVIPRadarPanelView:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.vipManager and self.actId > 0 then
    local dispearTime = self.vipManager:GetDisappearTime(self.actId) or 0
    if dispearTime and 0 < dispearTime then
      self.activityDisappearTime = dispearTime
      if not self.isClosing and curTime >= dispearTime then
        self:CloseWithAnimation()
        return
      end
    end
  end
  if not self.countdown_txt then
    return
  end
  local endTime = self.countdownEndTime or self.activityDisappearTime
  if not endTime or endTime <= 0 then
    self:StopCountdownTimer()
    return
  end
  self.countdownEndTime = endTime
  if UIUtil.SetLeftTimeText(self.countdown_txt, nil, endTime) then
    self:StopCountdownTimer()
  end
end

function UILWVIPRadarPanelView:ClearClaimRewardTimeout()
  if self.claimRewardTimeoutTimer then
    self.claimRewardTimeoutTimer:Stop()
    self.claimRewardTimeoutTimer = nil
  end
end

function UILWVIPRadarPanelView:StopCloseAnimationTimer()
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
end

function UILWVIPRadarPanelView:StopEnterAnimationTimer()
  if self.enterAnimTimer then
    self.enterAnimTimer:Stop()
    self.enterAnimTimer = nil
  end
end

function UILWVIPRadarPanelView:StopDiscoverTextTimer()
  if self.discoverTextTimer then
    self.discoverTextTimer:Stop()
    self.discoverTextTimer = nil
  end
end

function UILWVIPRadarPanelView:StopProgramAnimationTimers()
  if self.programAnimationStartTimer then
    self.programAnimationStartTimer:Stop()
    self.programAnimationStartTimer = nil
  end
  if self.programAnimationTimers then
    for index = #self.programAnimationTimers, 1, -1 do
      local timer = self.programAnimationTimers[index]
      if timer and timer.Stop then
        timer:Stop()
      end
      self.programAnimationTimers[index] = nil
    end
  end
  self.programAnimationActive = false
  self.pendingPayAnimation = nil
end

function UILWVIPRadarPanelView:ScheduleProgramTimer(delay, callback)
  local mgr = TimerManager:GetInstance()
  if not mgr or not callback then
    return nil
  end
  local timer = mgr:DelayInvoke(function()
    callback()
  end, delay)
  if timer then
    self.programAnimationTimers[#self.programAnimationTimers + 1] = timer
  end
  return timer
end

function UILWVIPRadarPanelView:StartValueTween(duration, step, onUpdate, onComplete)
  local mgr = TimerManager:GetInstance()
  if not (mgr and duration) or duration <= 0 then
    if onUpdate then
      onUpdate(1)
    end
    if onComplete then
      onComplete()
    end
    return
  end
  step = step or 0.05
  if step <= 0 then
    step = 0.05
  end
  local elapsed = 0
  
  local function tick()
    elapsed = elapsed + step
    local progress = elapsed / duration
    if 1 < progress then
      progress = 1
    end
    if onUpdate then
      onUpdate(progress)
    end
    if 1 <= progress then
      if onComplete then
        onComplete()
      end
      return
    end
    local timer = mgr:DelayInvoke(tick, step)
    if timer then
      self.programAnimationTimers[#self.programAnimationTimers + 1] = timer
    end
  end
  
  if onUpdate then
    onUpdate(0)
  end
  local timer = mgr:DelayInvoke(tick, step)
  if timer then
    self.programAnimationTimers[#self.programAnimationTimers + 1] = timer
  end
end

function UILWVIPRadarPanelView:SetDiscoverText(key, alignment, sizeX)
  if not self.discover_txt then
    return
  end
  local align = alignment or TextAlignmentOptions and TextAlignmentOptions.Left or nil
  if align and self.discover_txt.SetAlignment then
    self.discover_txt:SetAlignment(align)
  end
  if sizeX and self.discover_txt then
    self.discover_txt:SetSizeDeltaX(sizeX)
  end
  if not key or key == "" then
    return
  end
  local text = Localization and Localization:GetString(key) or key
  if text and text ~= "" then
    self.discover_txt:SetText(text)
  end
end

local function get_pack_required_vip_level(entry)
  if not entry then
    return nil
  end
  local packId = entry.vipGiftId or entry.id
  if not packId or packId == "" then
    return nil
  end
  local required = DataCenter.VIPManager:GetPackVipLv(packId)
  if required == nil then
    return nil
  end
  required = tonumber(required) or required
  if required and 0 < required then
    return required
  end
  return nil
end

local function get_current_vip_level()
  local info = DataCenter.VIPManager:GetVipData()
  if not info or info.level == nil then
    return nil
  end
  local level = tonumber(info.level)
  if level ~= nil then
    return level
  end
  return info.level
end

function UILWVIPRadarPanelView:CaptureRewardSnapshot(items)
  local snapshot = {
    list = {},
    map = {}
  }
  local rewardsArray = VIPRadarRewardUtil.to_array(items)
  for index, reward in ipairs(rewardsArray) do
    local normalized = VIPRadarRewardUtil.normalize_reward_info(reward)
    if normalized then
      local count = VIPRadarRewardUtil.get_reward_quantity(reward)
      local entry = {
        index = index,
        key = VIPRadarRewardUtil.build_reward_key(normalized),
        reward = normalized,
        count = count
      }
      snapshot.list[index] = entry
      snapshot.map[entry.key] = entry
    end
  end
  return snapshot
end

function UILWVIPRadarPanelView:CloneSnapshot(snapshot)
  if not snapshot then
    return nil
  end
  local clone = {
    list = {},
    map = {}
  }
  for index, entry in ipairs(snapshot.list or {}) do
    local copy = {
      index = entry.index,
      key = entry.key,
      reward = entry.reward,
      count = entry.count,
      delta = entry.delta,
      from = entry.from,
      to = entry.to
    }
    clone.list[index] = copy
    if copy.key then
      clone.map[copy.key] = copy
    end
  end
  return clone
end

function UILWVIPRadarPanelView:ApplyExtraCountsSnapshot(snapshot)
  if not (snapshot and snapshot.list) or not self.extraRewardCells then
    return
  end
  for index, cell in ipairs(self.extraRewardCells) do
    local entry = snapshot.list[index]
    if entry and cell and cell.SetItemCount then
      cell:SetItemCount(entry.count or 0)
    end
  end
end

function UILWVIPRadarPanelView:AnimateExtraCounts(oldSnapshot, newSnapshot, duration)
  if not newSnapshot or not newSnapshot.list then
    return
  end
  if not self.extraRewardCells or #self.extraRewardCells == 0 then
    return
  end
  local entries = {}
  local oldMap = oldSnapshot and oldSnapshot.map or {}
  for index, entry in ipairs(newSnapshot.list) do
    local cell = self.extraRewardCells[index]
    if cell and cell.SetItemCount then
      local fromCount = 0
      local key = entry.key
      if key and oldMap[key] and oldMap[key].count ~= nil then
        fromCount = oldMap[key].count
      elseif oldSnapshot and oldSnapshot.list and oldSnapshot.list[index] and oldSnapshot.list[index].count ~= nil then
        fromCount = oldSnapshot.list[index].count
      end
      local targetCount = entry.count or 0
      if fromCount ~= targetCount then
        entries[#entries + 1] = {
          cell = cell,
          from = fromCount,
          to = targetCount,
          diff = targetCount - fromCount
        }
      end
    end
  end
  if #entries == 0 then
    return
  end
  
  local function apply(progress)
    if 1 <= progress then
      for _, info in ipairs(entries) do
        info.cell:SetItemCount(info.to)
      end
      return
    end
    for _, info in ipairs(entries) do
      local value = info.from + info.diff * progress
      if info.diff >= 0 then
        value = math_floor(value + 0.5)
        if value > info.to then
          value = info.to
        end
      else
        value = math_floor(value + 0.5)
        if value < info.to then
          value = info.to
        end
      end
      info.cell:SetItemCount(value)
    end
  end
  
  apply(0)
  self:StartValueTween(duration or 0.6, 0.05, function(progress)
    apply(progress)
  end, function()
    apply(1)
  end)
end

function UILWVIPRadarPanelView:ComputeExtraDiff(oldSnapshot, newSnapshot)
  local result = {}
  if not newSnapshot or not newSnapshot.map then
    return result
  end
  oldSnapshot = oldSnapshot or {
    map = {}
  }
  for key, newEntry in pairs(newSnapshot.map) do
    local oldEntry = oldSnapshot.map[key]
    local oldCount = oldEntry and oldEntry.count or 0
    local delta = (newEntry.count or 0) - oldCount
    if delta ~= 0 then
      result[#result + 1] = {
        key = key,
        reward = newEntry.reward,
        from = oldCount,
        to = newEntry.count or 0,
        delta = delta,
        index = newEntry.index
      }
    end
  end
  return result
end

function UILWVIPRadarPanelView:SnapshotCurrentState()
  return {
    extra = self:CloneSnapshot(self.currentExtraSnapshot),
    discount = self.latestDiscountValue,
    free = self:CloneSnapshot(self.currentFreeSnapshot)
  }
end

function UILWVIPRadarPanelView:CollectLatestClaimState()
  local summary
  if self.actId > 0 then
    summary = self.vipManager:GetSummary(self.actId)
  end
  local data = self.actId > 0 and self.vipManager:GetData(self.actId)
  local hasFree = summary and summary.hasFreeReward or false
  local dailyMax = summary and summary.dailyMax or 0
  local dailyCount = summary and summary.dailyCount or 0
  local dailyRewardsRaw = data and data.dailyReward or {}
  local overrideTotal
  if hasFree and summary and summary.dailyMax and 0 < summary.dailyMax then
    overrideTotal = summary.dailyMax
  end
  local displayDailyRewards = VIPRadarRewardUtil.build_daily_reward_display(dailyRewardsRaw, overrideTotal)
  local extraSource = {}
  local stage
  local selectedGift = self:SelectCurrentGift()
  if selectedGift and selectedGift.entry then
    stage = selectedGift.entry
    extraSource = stage.extraRewards or stage.rewards or stage.putBoxParam or {}
  end
  if not stage then
    extraSource = self:GetCurrentExtraRewardList(data)
  end
  local displayExtraRewards = {}
  if summary and stage and extraSource and next(extraSource) ~= nil then
    local addBoxList = stage.putBoxParam or {}
    local addBoxTotal = VIPRadarRewardUtil.sum_reward_quantities(addBoxList)
    local extraTotal = VIPRadarRewardUtil.sum_reward_quantities(extraSource)
    local putInCount = extraTotal
    if not summary.freeReceived and 0 < addBoxTotal then
      putInCount = putInCount - addBoxTotal
      if putInCount < 0 then
        putInCount = 0
      end
    end
    if putInCount <= 0 then
      local zeroList = {}
      local srcArray = VIPRadarRewardUtil.to_array(extraSource)
      for index, reward in ipairs(srcArray) do
        local copy = VIPRadarRewardUtil.deep_copy(reward)
        VIPRadarRewardUtil.set_reward_quantity(copy, 0)
        zeroList[index] = copy
      end
      displayExtraRewards = zeroList
    elseif not summary.freeReceived and 0 < addBoxTotal then
      displayExtraRewards = VIPRadarRewardUtil.build_daily_reward_display(extraSource, putInCount)
    else
      displayExtraRewards = extraSource
    end
  elseif summary and extraSource and next(extraSource) ~= nil then
    local putInCount = summary.accumulateCount or 0
    if 0 < putInCount then
      displayExtraRewards = VIPRadarRewardUtil.build_daily_reward_display(extraSource, putInCount)
    else
      displayExtraRewards = {}
    end
  end
  local discountValue
  if summary then
    local targetStage = selectedGift and selectedGift.entry or nil
    if not targetStage and data and data.extraRewardList and data.extraRewardList[1] then
      targetStage = data.extraRewardList[1]
    end
    if targetStage then
      local percent = self.vipManager:GetStageDiscountPercent(self.actId, targetStage, true)
      if percent and 0 < percent then
        discountValue = percent
      else
        discountValue = 0
      end
    end
  end
  return {
    summary = summary,
    free = self:CaptureRewardSnapshot(displayDailyRewards),
    extra = self:CaptureRewardSnapshot(displayExtraRewards),
    discount = discountValue
  }
end

function UILWVIPRadarPanelView:ApplyDiscountValue(value)
  if not self.discount_txt then
    return
  end
  if value == nil then
    self.discount_txt:SetActive(false)
    self.latestDiscountValue = nil
    return
  end
  self.discount_txt:SetActive(true)
  self.discount_txt:SetText(string.format("%d", math_floor(value + 0.5)))
  self.latestDiscountValue = value
end

function UILWVIPRadarPanelView:PlayPanelAnimation(animName, force)
  if not animName or animName == "" then
    return
  end
  if animName == AnimNames.PAY then
    self:StopDiscoverTextTimer()
    self:SetDiscoverText("activity_radarvipgift_desc5", TextAlignmentOptions and TextAlignmentOptions.Center or nil, 420)
  elseif animName == AnimNames.FINISH then
    self:StopDiscoverTextTimer()
    self:SetDiscoverText("activity_radarvipgift_desc4", TextAlignmentOptions and TextAlignmentOptions.Left or nil, 242)
  end
  if not self.anim or not self.anim:CanUse() then
    self.currentAnimState = animName
    return
  end
  if not force and self.currentAnimState == animName then
    return
  end
  if self.anim.SetSpeed then
    self.anim:SetSpeed(1)
  end
  self.currentAnimState = animName
  self.anim:SampleAnimationAtTime(animName, 0)
  self.anim:Play(animName)
end

function UILWVIPRadarPanelView:GetDesiredPanelAnim()
  if self:IsAllGiftBought() then
    return AnimNames.FINISH
  end
  local summary = self.summary
  if not summary and self.actId > 0 then
    summary = self.vipManager:GetSummary(self.actId)
    if summary then
      self.summary = summary
    end
  end
  if summary and summary.hasFreeReward then
    return nil
  end
  if summary then
    return AnimNames.PAY
  end
  return nil
end

function UILWVIPRadarPanelView:EvaluateAndPlayPanelState(force)
  if self.isClosing then
    return
  end
  if self.delayPayAnimation and not force then
    return
  end
  local target = self:GetDesiredPanelAnim()
  if self.isPlayingEnter and not force then
    return
  end
  if not target or target == "" then
    if not force and self.anim and self.anim:CanUse() and self.currentAnimState and self.currentAnimState ~= AnimNames.ENTER then
      self.anim:Rebind()
    end
    self.currentAnimState = nil
    if not self.discoverTextTimer then
      self:SetDiscoverText("activity_radarvipgift_desc4", TextAlignmentOptions and TextAlignmentOptions.Left or nil, 242)
    end
    return
  end
  local shouldForce = force and self.currentAnimState ~= target
  self:PlayPanelAnimation(target, shouldForce)
end

function UILWVIPRadarPanelView:StartEnterAnimation()
  if self.isClosing then
    return
  end
  if self.anim and self.anim.SetSpeed then
    self.anim:SetSpeed(1)
  end
  local target = self:GetDesiredPanelAnim()
  if target == AnimNames.PAY or target == AnimNames.FINISH then
    self:StopDiscoverTextTimer()
    if target == AnimNames.PAY then
      self:SetDiscoverText("activity_radarvipgift_desc5", TextAlignmentOptions and TextAlignmentOptions.Center or nil, 420)
    else
      self:SetDiscoverText("activity_radarvipgift_desc4", TextAlignmentOptions and TextAlignmentOptions.Left or nil, 242)
    end
    self.isPlayingEnter = false
    self:PlayPanelAnimation(target, true)
    return
  end
  self:SetDiscoverText("activity_radarvipgift_desc3", TextAlignmentOptions and TextAlignmentOptions.Left or nil, 242)
  self:StopDiscoverTextTimer()
  local textMgr = TimerManager and TimerManager:GetInstance() or nil
  if textMgr then
    self.discoverTextTimer = textMgr:DelayInvoke(function()
      self.discoverTextTimer = nil
      self:SetDiscoverText("activity_radarvipgift_desc4", TextAlignmentOptions and TextAlignmentOptions.Left or nil, 242)
    end, 1.1)
  end
  if not self.anim or not self.anim:CanUse() then
    self.isPlayingEnter = false
    self:EvaluateAndPlayPanelState(true)
    return
  end
  self.isPlayingEnter = true
  self.anim:SampleAnimationAtTime(AnimNames.ENTER, 0)
  local success, duration = self.anim:PlayAnimationReturnTime(AnimNames.ENTER)
  if success then
    self.currentAnimState = AnimNames.ENTER
    local mgr = TimerManager:GetInstance()
    if mgr and duration and 0 < duration then
      self:StopEnterAnimationTimer()
      self.enterAnimTimer = mgr:DelayInvoke(function()
        self.enterAnimTimer = nil
        self.isPlayingEnter = false
        self:EvaluateAndPlayPanelState(true)
      end, duration)
      return
    end
  end
  self.isPlayingEnter = false
  self:EvaluateAndPlayPanelState(true)
end

function UILWVIPRadarPanelView:CloseWithAnimation()
  if self.isClosing then
    return
  end
  self.isClosing = true
  self.isPlayingEnter = false
  self:StopEnterAnimationTimer()
  self:StopCloseAnimationTimer()
  local success, duration = false, 0
  if self.anim and self.anim:CanUse() then
    self.anim:SampleAnimationAtTime(AnimNames.EXIT, 0)
    success, duration = self.anim:PlayAnimationReturnTime(AnimNames.EXIT)
    if success and self.anim.SetSpeed then
      self.anim:SetSpeed(1)
    end
    self.currentAnimState = AnimNames.EXIT
  end
  if not success then
    self:DoCloseWindow()
    return
  end
  local mgr = TimerManager:GetInstance()
  if not (mgr and duration) or duration <= 0 then
    self:DoCloseWindow()
    return
  end
  self.closeAnimTimer = mgr:DelayInvoke(function()
    self.closeAnimTimer = nil
    self:DoCloseWindow()
  end, duration)
end

function UILWVIPRadarPanelView:DoCloseWindow()
  self.isClosing = false
  self.ctrl:CloseSelf()
end

function UILWVIPRadarPanelView:RestoreClaimButton(forceUnlock)
  self.claimRewardPending = false
  if self.claim_btn then
    local canClaim = forceUnlock or self.vipManager:HasFreeReward(self.actId)
    self.claim_btn:SetInteractable(canClaim)
  end
end

function UILWVIPRadarPanelView:StartClaimRewardTimeout()
  local mgr = TimerManager:GetInstance()
  if not mgr then
    return
  end
  self:ClearClaimRewardTimeout()
  self.claimRewardTimeoutTimer = mgr:DelayInvoke(function()
    self.claimRewardTimeoutTimer = nil
    if not self.claimRewardPending then
      return
    end
    self:RestoreClaimButton(true)
  end, CLAIM_REQUEST_TIMEOUT)
end

function UILWVIPRadarPanelView:OnClaim_btnClick()
  if self.vipManager:HasFreeReward(self.actId) then
    self:OnClaimRewardClick()
  end
end

function UILWVIPRadarPanelView:OnEnable()
  base.OnEnable(self)
  self:StartDisappearTimerIfNeeded()
  self:StartCountdownTimer()
  self:StartEnterAnimation()
  DataCenter.VipGiftActDataManager:SetVIPSurvivalTipHide(true)
  local vipLevel = get_current_vip_level() or 0
  PostEventLog.Track("vip_radar_panel_open", {i_para1 = vipLevel})
end

function UILWVIPRadarPanelView:OnDisable()
  self:ClearClaimRewardTimeout()
  self:StopEnterAnimationTimer()
  self:StopDiscoverTextTimer()
  self:StopProgramAnimationTimers()
  self.delayPayAnimation = false
  self.pendingPayAnimation = nil
  self.preClaimAnimationState = nil
  self.isPlayingEnter = false
  self:StopCountdownTimer()
  DataCenter.VipGiftActDataManager:SetVIPSurvivalTipHide(false)
  base.OnDisable(self)
end

function UILWVIPRadarPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurvivalVipGiftInfoUpdate, self.OnVipGiftInfoUpdate)
  self:AddUIListener(EventId.SurvivalVipGiftFreeReward, self.OnVipGiftFreeReward)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnGiftPackUpdated)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnGiftPackUpdated)
end

function UILWVIPRadarPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.SurvivalVipGiftInfoUpdate, self.OnVipGiftInfoUpdate)
  self:RemoveUIListener(EventId.SurvivalVipGiftFreeReward, self.OnVipGiftFreeReward)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnGiftPackUpdated)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnGiftPackUpdated)
  base.OnRemoveListener(self)
end

function UILWVIPRadarPanelView:OnVipGiftInfoUpdate(payload)
  local actId = type(payload) == "table" and payload.actId or payload
  if actId ~= self.actId then
    return
  end
  self:StopProgramAnimationTimers()
  self.summary = nil
  self:RefreshSummarySection()
  self:RefreshGiftSection()
end

function UILWVIPRadarPanelView:OnVipGiftFreeReward(payload)
  local actId = type(payload) == "table" and payload.actId or payload
  if actId ~= self.actId then
    return
  end
  self:ClearClaimRewardTimeout()
  local errCode = type(payload) == "table" and (payload.errCode or payload.errorCode) or nil
  if errCode ~= nil then
    self:RestoreClaimButton(true)
    self.delayPayAnimation = false
    self.pendingPayAnimation = nil
    return
  end
  self.delayPayAnimation = true
  local preState = self.preClaimAnimationState or self:SnapshotCurrentState()
  self:RestoreClaimButton()
  self.pendingPayAnimation = {pre = preState}
  local uiManager = UIManager:GetInstance()
  local data = self.vipManager:GetData(self.actId) or nil
  local freeRewards = data and data.dailyReward or {}
  local payRewards
  local selected = self:SelectCurrentGift()
  if selected and selected.entry and selected.entry.putBoxParam then
    payRewards = selected.entry.putBoxParam
  elseif data and data.extraRewardList and data.extraRewardList[1] and data.extraRewardList[1].putBoxParam then
    payRewards = data.extraRewardList[1].putBoxParam
  end
  local panelData = {
    actId = self.actId,
    freeRewards = freeRewards or {},
    payRewards = payRewards or {},
    onClosed = function(payload)
      if not self.actId or self.actId <= 0 then
        return
      end
      self:OnClaimPanelClosed(payload)
    end
  }
  if self.pendingPayAnimation then
    self.pendingPayAnimation.freeRewards = freeRewards
    self.pendingPayAnimation.payRewards = payRewards
  end
  self.preClaimAnimationState = nil
  uiManager:OpenWindow(UIWindowNames.UILWVIPRadarClaimPanel, {anim = false}, panelData)
end

function UILWVIPRadarPanelView:OnClaimPanelClosed(payload)
  if self.isClosing then
    self.delayPayAnimation = false
    self.pendingPayAnimation = nil
    return
  end
  local pending = self.pendingPayAnimation
  if not pending then
    self.delayPayAnimation = false
    self:EvaluateAndPlayPanelState(true)
    return
  end
  local preState = pending.pre or self:SnapshotCurrentState()
  local postState = self:CollectLatestClaimState()
  pending.post = postState
  pending.extraDiff = self:ComputeExtraDiff(preState and preState.extra or nil, postState and postState.extra or nil)
  pending.discountFrom = preState and preState.discount or nil
  pending.discountTo = postState and postState.discount or nil
  self.pendingPayAnimation = pending
  pending.closePayload = payload
  self:StartPayAnimationWithProgram(pending)
end

local function get_cell_world_position(cell)
  return cell and cell:GetPosition() or nil
end

function UILWVIPRadarPanelView:ResolveFreeStartPosition(payload)
  if payload and payload.freeStartPos then
    return payload.freeStartPos
  end
  if self.claimRewardCells and self.claimRewardCells[1] then
    return get_cell_world_position(self.claimRewardCells[1])
  end
  if self.claimReward then
    return self.claimReward:GetPosition()
  end
  return nil
end

function UILWVIPRadarPanelView:ResolveExtraStartPosition(payload, index)
  if payload and payload.payStartPosList and payload.payStartPosList[index] then
    return payload.payStartPosList[index]
  end
  if self.extraRewardCells and self.extraRewardCells[index] then
    return get_cell_world_position(self.extraRewardCells[index])
  end
  if self.extraReward then
    return self.extraReward:GetPosition()
  end
  return nil
end

function UILWVIPRadarPanelView:PlayPostClaimFlyEffects(data)
  if not data or data.flyEffectsPlayed then
    return
  end
  data.flyEffectsPlayed = true
  local payload = data.closePayload or {}
  local preState = data.pre or {}
  local extraDiff = data.extraDiff or {}
  local freeStartPos = self:ResolveFreeStartPosition(payload)
  local freeRewardEntry = preState.free and preState.free.list and preState.free.list[1] or nil
  if not freeRewardEntry and data.freeRewards then
    local normalized = VIPRadarRewardUtil.normalize_reward_info(VIPRadarRewardUtil.to_array(data.freeRewards)[1])
    if normalized then
      freeRewardEntry = {reward = normalized}
    end
  end
  if freeStartPos and freeRewardEntry and freeRewardEntry.reward then
    local rewardInfo = freeRewardEntry.reward
    local iconPath = DataCenter.RewardManager:GetPicByType(rewardInfo.rewardType, rewardInfo.itemId)
    if iconPath and iconPath ~= "" then
      local rewardType = rewardInfo.rewardType or RewardType.GOODS
      rewardType = RewardType and type(rewardType) == "string" and (tonumber(rewardType) or RewardType[rewardType]) or rewardType
      UIUtil.DoFlyStraight(rewardType or RewardType.GOODS, 1, iconPath, freeStartPos, Vector3.New(0, 0, 0), nil, nil, nil, true, 0.15)
    end
  end
  if extraDiff and 0 < #extraDiff then
    for _, entry in ipairs(extraDiff) do
      if entry.delta and 0 < entry.delta then
        local index = entry.index or 1
        local cell = self.extraRewardCells and self.extraRewardCells[index] or nil
        local destPos = cell and get_cell_world_position(cell) or nil
        if not destPos and self.extraReward then
          destPos = self.extraReward:GetPosition()
        end
        if destPos then
          local startPos = self:ResolveExtraStartPosition(payload, index) or destPos
          local rewardInfo = entry.reward
          local iconPath = DataCenter.RewardManager:GetPicByType(rewardInfo.rewardType, rewardInfo.itemId)
          if iconPath and iconPath ~= "" then
            local count = math.abs(entry.delta)
            local rewardType = rewardInfo.rewardType or RewardType.GOODS
            rewardType = RewardType and type(rewardType) == "string" and (tonumber(rewardType) or RewardType[rewardType]) or rewardType
            UIUtil.DoFlyStraight(rewardType or RewardType.GOODS, math.min(count, 3), iconPath, startPos, destPos, nil, nil, nil, true, 0.15)
          end
        end
      end
    end
  end
end

function UILWVIPRadarPanelView:StartPayAnimationWithProgram(data)
  self:StopProgramAnimationTimers()
  self.programAnimationActive = true
  self.pendingPayAnimation = data
  self:PlayPanelAnimation(AnimNames.PAY)
  local flyDelay = 0.3
  local flyTimer = self:ScheduleProgramTimer(flyDelay, function()
    self:PlayPostClaimFlyEffects(data)
  end)
  if not flyTimer then
    self:PlayPostClaimFlyEffects(data)
  end
  local startDelay = 0.6
  self.programAnimationStartTimer = self:ScheduleProgramTimer(startDelay, function()
    self.programAnimationStartTimer = nil
    self:RunPostClaimProgramAnimation(data)
  end)
  if not self.programAnimationStartTimer then
    self:RunPostClaimProgramAnimation(data)
  end
end

function UILWVIPRadarPanelView:RunPostClaimProgramAnimation(data)
  if not data then
    self.programAnimationActive = false
    self.pendingPayAnimation = nil
    return
  end
  local payload = data.closePayload or {}
  local preState = data.pre or {}
  local postState = data.post or {}
  local extraDiff = data.extraDiff or {}
  if postState and postState.summary then
    self.summary = postState.summary
  end
  self:PlayPostClaimFlyEffects(data)
  local duration = 0.6
  local hasExtraIncrease = false
  if extraDiff and 0 < #extraDiff then
    for _, entry in ipairs(extraDiff) do
      if entry.delta and 0 < entry.delta then
        hasExtraIncrease = true
        break
      end
    end
  end
  local hasExtraChange = extraDiff and 0 < #extraDiff
  local discountFrom = data.discountFrom
  local discountTo = data.discountTo
  local hasDiscountTween = discountFrom ~= nil and discountTo ~= nil and discountFrom ~= discountTo
  if hasExtraChange then
    if self.extraRewardCells then
      for _, cell in ipairs(self.extraRewardCells) do
        cell:SetActive(true)
      end
    end
    self:AnimateExtraCounts(preState and preState.extra or nil, postState and postState.extra or nil, duration)
  end
  
  local function finalize()
    if postState and postState.summary then
      self.summary = postState.summary
    else
      self.summary = nil
    end
    self:RefreshSummarySection()
    self:RefreshGiftSection()
    self.delayPayAnimation = false
    self:EvaluateAndPlayPanelState()
    if postState.discount ~= nil then
      self:ApplyDiscountValue(postState.discount)
    end
    self.programAnimationActive = false
    self.pendingPayAnimation = nil
  end
  
  if hasDiscountTween then
    self:StartValueTween(duration, 0.05, function(progress)
      local value = (discountFrom or 0) + (discountTo - discountFrom) * progress
      self:ApplyDiscountValue(value)
    end, function()
      finalize()
    end)
  elseif hasExtraChange then
    local timer = self:ScheduleProgramTimer(duration, function()
      finalize()
    end)
    if not timer then
      finalize()
    end
  else
    finalize()
  end
end

function UILWVIPRadarPanelView:OnGiftPackUpdated()
  self:StopProgramAnimationTimers()
  self:RefreshSummarySection()
  self:RefreshGiftSection()
end

function UILWVIPRadarPanelView:RefreshView()
  if self.title_txt then
    self.title_txt:SetLocalText(self.activityInfo.name)
  end
  self:RefreshSummarySection()
  self:RefreshGiftSection()
end

function UILWVIPRadarPanelView:GetCurrentExtraRewardList(data)
  local current = self.currentGiftEntry and self.currentGiftEntry.entry or nil
  if current then
    local extra = current.extraRewards or current.rewards or current.putBoxParam
    if extra and next(extra) ~= nil then
      return extra
    end
  end
  local selected = self:SelectCurrentGift()
  if selected and selected.entry then
    self.currentGiftEntry = selected
    local entry = selected.entry
    local extra = entry.extraRewards or entry.rewards or entry.putBoxParam
    if extra and next(extra) ~= nil then
      return extra
    end
  end
  if data and data.extraRewardList then
    for _, stage in ipairs(data.extraRewardList) do
      local extra = stage.extraRewards or stage.rewards or stage.putBoxParam
      if extra and next(extra) ~= nil then
        return extra
      end
    end
  end
  return {}
end

function UILWVIPRadarPanelView:UpdateVipLimitState(selected, canShowBuy)
  if canShowBuy == nil then
    canShowBuy = true
  end
  local showBuy = canShowBuy
  if not selected then
    showBuy = false
  end
  if selected and selected.isBought then
    showBuy = false
  end
  local requiredVip
  local locked = false
  if selected and selected.entry and showBuy then
    requiredVip = get_pack_required_vip_level(selected.entry)
    if requiredVip then
      local currentVip = get_current_vip_level() or 0
      if requiredVip > currentVip then
        locked = true
      end
    end
  end
  if self.buy_btn_comp then
    if locked then
      self.buy_btn_comp:SetActive(false)
    else
      self.buy_btn_comp:SetActive(showBuy)
    end
  end
  if self.vipLvLimit_txt then
    if locked and requiredVip then
      self.vipLvLimit_txt:SetActive(true)
      if self.vipLvLimit_txt.SetLocalText then
        self.vipLvLimit_txt:SetLocalText(320297, requiredVip)
      else
        self.vipLvLimit_txt:SetText(Localization:GetString(320297, requiredVip))
      end
    else
      self.vipLvLimit_txt:SetActive(false)
    end
  end
  self.vipLimitLocked = locked
  self.vipLimitRequiredLevel = requiredVip
end

function UILWVIPRadarPanelView:RefreshSummarySection()
  if self.actId <= 0 then
    if self.todayState_txt then
      self.todayState_txt:SetText("--/--")
    end
    if self.limitState_txt then
      self.limitState_txt:SetText("--/--")
    end
    if self.noteTip_txt then
      self.noteTip_txt:SetText("")
    end
    self:RefreshClaimRewardItems(nil)
    self:RefreshExtraRewardItems(nil)
    self:UpdateVipLimitState(nil, false)
    self:EvaluateAndPlayPanelState()
    return
  end
  local summary = self.summary or self.vipManager:GetSummary(self.actId)
  self.summary = summary
  if not summary then
    if self.todayState_txt then
      self.todayState_txt:SetText("--/--")
    end
    if self.limitState_txt then
      self.limitState_txt:SetText("--/--")
    end
    if self.noteTip_txt then
      self.noteTip_txt:SetText("")
    end
    self:RefreshClaimRewardItems(nil)
    self:RefreshExtraRewardItems(nil)
    self:UpdateVipLimitState(nil, false)
    self:EvaluateAndPlayPanelState()
    return
  end
  local currentDay = summary.currentDay or 0
  local maxDay = summary.maxDay or 0
  local exceedDayLimit = 0 < maxDay and currentDay > maxDay
  local hasFree = summary.hasFreeReward
  local canShowClaim = hasFree and not exceedDayLimit
  self.claim_btn_container:SetActive(canShowClaim)
  self.buy_btn_comp:SetActive(not canShowClaim)
  local data = self.vipManager:GetData(self.actId)
  local dailyRewardsRaw = data and data.dailyReward or {}
  local overrideTotal
  if canShowClaim and summary.dailyMax and 0 < summary.dailyMax then
    overrideTotal = summary.dailyMax
  end
  local displayDailyRewards, dailyRewardOriginalTotal = VIPRadarRewardUtil.build_daily_reward_display(dailyRewardsRaw, overrideTotal)
  self:RefreshClaimRewardItems(displayDailyRewards, {
    hideCount = not hasFree
  })
  local selectedForSummary = self:SelectCurrentGift()
  if selectedForSummary then
    self.currentGiftEntry = selectedForSummary
  end
  local stage = self.currentGiftEntry and self.currentGiftEntry.entry or nil
  local dailyReceived, dailyTotal = 0, 0
  local putInCount, putInMax = 0, 0
  local addBoxTotal, extraTotal = 0, 0
  local extraSource
  if stage then
    extraSource = stage.extraRewards or stage.rewards or stage.putBoxParam or {}
  else
    extraSource = self:GetCurrentExtraRewardList(data)
  end
  if stage then
    local addBoxList = stage.putBoxParam or {}
    addBoxTotal = VIPRadarRewardUtil.sum_reward_quantities(addBoxList)
    extraTotal = VIPRadarRewardUtil.sum_reward_quantities(extraSource)
    local maxAddBox = tonumber(stage.maxAddBox) or 0
    dailyTotal = addBoxTotal
    if summary.freeReceived then
      dailyReceived = addBoxTotal
    else
      dailyReceived = 0
    end
    putInMax = maxAddBox
    putInCount = extraTotal
    if not summary.freeReceived and 0 < addBoxTotal then
      putInCount = putInCount - addBoxTotal
      if putInCount < 0 then
        putInCount = 0
      end
    end
  else
    local dailyMax = 0 < summary.dailyMax and summary.dailyMax or summary.dailyCount
    dailyTotal = dailyMax
    dailyReceived = summary.dailyCount
    local accumulateMax = 0 < summary.accumulateLimit and summary.accumulateLimit or summary.accumulateCount
    putInCount = summary.accumulateCount
    putInMax = accumulateMax
  end
  if self.todayState_txt then
    self.todayState_txt:SetText(Localization:GetString("activity_radarvipgift_desc1", string.GetFormattedSeperatorNum(dailyReceived or 0), string.GetFormattedSeperatorNum(dailyTotal or 0)))
  end
  if self.limitState_txt then
    self.limitState_txt:SetText(Localization:GetString("activity_radarvipgift_desc2", string.GetFormattedSeperatorNum(putInCount or 0), string.GetFormattedSeperatorNum(putInMax or 0)))
  end
  local displayExtraRewards = {}
  local hideRoot = false
  if extraSource and next(extraSource) ~= nil then
    if putInCount <= 0 then
      local zeroList = {}
      local srcArray = VIPRadarRewardUtil.to_array(extraSource)
      for index, reward in ipairs(srcArray) do
        local copy = VIPRadarRewardUtil.deep_copy(reward)
        VIPRadarRewardUtil.set_reward_quantity(copy, 0)
        zeroList[index] = copy
      end
      displayExtraRewards = zeroList
      hideRoot = true
    elseif stage and not summary.freeReceived and 0 < addBoxTotal then
      displayExtraRewards = VIPRadarRewardUtil.build_daily_reward_display(extraSource, putInCount)
    else
      displayExtraRewards = extraSource
    end
  end
  if hideRoot then
    self:RefreshExtraRewardItems(displayExtraRewards, {hideRoot = true})
  else
    self:RefreshExtraRewardItems(displayExtraRewards)
  end
  self:RefreshNoteHint(self.currentGiftEntry)
  self.noteTip_txt:SetLocalText(self.activityInfo.para)
  local allBought = self:IsAllGiftBought()
  local canShowBuy = not canShowClaim and not allBought
  self:UpdateVipLimitState(self.currentGiftEntry, canShowBuy)
  self.claimRewardPending = self.claimRewardPending and not canShowClaim
  if self.claim_btn then
    self.claim_btn:SetInteractable(canShowClaim and not self.claimRewardPending)
  end
  self:EvaluateAndPlayPanelState()
end

function UILWVIPRadarPanelView:RefreshGiftSection()
  if not self.buy_btn then
    self:UpdateVipLimitState(self.currentGiftEntry, false)
    self:EvaluateAndPlayPanelState()
    return
  end
  local allBought = self:IsAllGiftBought()
  self:ApplyPurchaseState(allBought)
  local selected = self:SelectCurrentGift()
  self.currentGiftEntry = selected
  self:RefreshNoteHint(selected)
  local canShowBuy = not allBought
  if self.summary and self.summary.hasFreeReward ~= nil and self.summary.hasFreeReward then
    canShowBuy = false
  end
  if not selected or not selected.package then
    if self.giftPackName_txt then
      local activityName = not self.activityInfo or self.activityInfo.name or self.activityInfo.activityName
      if activityName and activityName ~= "" then
        self.giftPackName_txt:SetText(Localization:GetString(activityName))
      else
        self.giftPackName_txt:SetText(Localization:GetString("activity_radarvipgift_name"))
      end
    end
    if self.discount_txt then
      self.discount_txt:SetActive(false)
    end
    self.latestDiscountValue = nil
    if self.buy_btn.btnBuy then
      self.buy_btn.btnBuy:SetInteractable(false)
    end
    UIUtil.ClearReward(self.packageReward_container, self.rewardReqs)
    self.rewardReqs = {}
    self:UpdateVipLimitState(nil, false)
    self:EvaluateAndPlayPanelState()
    return
  end
  local package = selected.package
  if self.giftPackName_txt then
    self.giftPackName_txt:SetText(package:getNameText())
  end
  local ratioText = self:_formatRebateText(selected.entry)
  if self.discount_txt then
    if ratioText and ratioText ~= "" then
      self.discount_txt:SetText(ratioText)
      self.discount_txt:SetActive(true)
      self.latestDiscountValue = tonumber(ratioText) or 0
    else
      self.discount_txt:SetActive(false)
      self.latestDiscountValue = nil
    end
  elseif ratioText and ratioText ~= "" then
    self.latestDiscountValue = tonumber(ratioText) or 0
  else
    self.latestDiscountValue = nil
  end
  self.buy_btn:Init(package)
  self.buy_btn:RefreshPoint()
  if self.buy_btn.btnBuy then
    self.buy_btn.btnBuy:SetInteractable(not selected.isBought)
  end
  self.buy_btn:SetBuyClickCallBack(function()
    local packId
    if selected and selected.package and selected.package.getID then
      packId = selected.package:getID()
    elseif selected and selected.entry then
      packId = selected.entry.vipGiftId or selected.entry.id
    end
    PostEventLog.Track("vip_pack_buy_click", {
      source_type = "vip_radar_panel",
      packageid = tostring(packId)
    })
    self:OnBuyCompleted()
  end)
  local items = package:getItems(true)
  self:RefreshRewardItems(items)
  self:UpdateVipLimitState(selected, canShowBuy)
  self:EvaluateAndPlayPanelState()
end

function UILWVIPRadarPanelView:RefreshRewardItems(items)
  local container = self.packageReward_container
  if not container then
    return
  end
  if not UIAssets or not UIAssets.UICommonResItem then
    return
  end
  UIUtil.ClearReward(container, self.rewardReqs)
  self.rewardReqs = {}
  if not items or #items == 0 then
    return
  end
  local index = 0
  for _, reward in ipairs(items) do
    index = index + 1
    local prefabPath = UIAssets.UICommonResItem
    local name = string.format("vip_radar_reward_%d", index)
    if container.GameObjectInstantiateAsync then
      do
        local req
        req = container:GameObjectInstantiateAsync(prefabPath, function()
          if not self.packageReward_container then
            return
          end
          local go = req and req.gameObject or nil
          if not go then
            return
          end
          go.name = name
          local transform = go.transform
          transform:SetParent(self.packageReward_container.transform)
          transform:Set_localScale(0.8, 0.8, 0.8)
          transform:Set_pivot(0.5, 0.5)
          transform:Set_localPosition(0, 0, 0)
          local cell = self.packageReward_container:AddComponent(UICommonResItem, go)
          cell:ReInit(reward)
        end)
        table_insert(self.rewardReqs, req)
      end
    end
  end
end

function UILWVIPRadarPanelView:RefreshClaimRewardItems(items, options)
  render_reward_list(self, self.claimReward, items, "claimRewardReqs", "claimRewardCells", "vip_radar_claim_reward_%d", options or {})
  self.currentFreeSnapshot = self:CaptureRewardSnapshot(items)
end

function UILWVIPRadarPanelView:RefreshExtraRewardItems(items, options)
  render_reward_list(self, self.extraReward, items, "extraRewardReqs", "extraRewardCells", "vip_radar_extra_reward_%d", options or {})
  self.currentExtraSnapshot = self:CaptureRewardSnapshot(items)
end

function UILWVIPRadarPanelView:RefreshNoteHint(selected)
  if not self.note_btn then
    return
  end
  local entry = selected and (selected.entry or selected) or nil
  local reward
  
  local function resolve_stage(candidate)
    if type(candidate) ~= "table" then
      return nil
    end
    if candidate.bubbleBoxItemId and candidate.bubbleBoxItemId > 0 then
      return candidate
    end
    if candidate.config and candidate.config.bubbleBoxItemId and 0 < candidate.config.bubbleBoxItemId then
      return candidate.config
    end
    return nil
  end
  
  local stage = resolve_stage(entry)
  if stage then
    local bubbleItemId = stage.bubbleBoxItemId
    if bubbleItemId and 0 < bubbleItemId then
      local goodsType = RewardType and RewardType.GOODS or nil
      local quality = stage.bubbleQualityId
      local rawReward = {
        rewardType = goodsType,
        itemId = bubbleItemId,
        count = 1
      }
      if quality and 0 < quality then
        rawReward.itemColor = quality
        rawReward.quality = quality
      end
      reward = VIPRadarRewardUtil.normalize_reward_info(rawReward)
    end
  end
  self.noteRewardData = reward
  if not reward then
    self.note_btn:SetActive(false)
    return
  end
  self.note_btn:SetActive(true)
  if self.noteItem_icon then
    local iconPath = DataCenter.RewardManager:GetPicByType(reward.rewardType, reward.itemId)
    if not string.IsNullOrEmpty(iconPath) then
      self.noteItem_icon:LoadSprite(iconPath)
      self.noteItem_icon:SetActive(true)
    else
      self.noteItem_icon:SetActive(false)
    end
  end
  if self.note_bg then
    local quality
    if stage and stage.bubbleQualityId and 0 < stage.bubbleQualityId then
      quality = stage.bubbleQualityId
    else
      local template = DataCenter.ItemTemplateManager:GetItemTemplate(reward.itemId)
      if template then
        quality = template.quality or template.itemColor or template.color
      end
    end
    local bgPath = quality and Quality2BgPath[quality] or DefaultNoteBgPath
    if not string.IsNullOrEmpty(bgPath) then
      self.note_bg:LoadSprite(bgPath)
      self.note_bg:SetActive(true)
    else
      self.note_bg:SetActive(false)
    end
  end
end

function UILWVIPRadarPanelView:ApplyPurchaseState(allBought)
  local finished = allBought == true
  if self.payState then
    self.payState:SetActive(not finished)
  end
  if self.finishState then
    self.finishState:SetActive(finished)
  end
end

function UILWVIPRadarPanelView:IsAllGiftBought()
  if self.actId <= 0 then
    return false
  end
  local list = self.vipManager:GetGiftExtraInfo(self.actId)
  if type(list) ~= "table" or #list == 0 then
    return false
  end
  local hasPackage = false
  for _, entry in ipairs(list) do
    local packId = entry.vipGiftId or entry.id
    if packId and 0 < packId then
      hasPackage = true
      local pack = GiftPackageData.get(tostring(packId))
      if not pack or not pack:isBought() then
        return false
      end
    end
  end
  return hasPackage
end

function UILWVIPRadarPanelView:SelectCurrentGift()
  if self.actId <= 0 then
    return nil
  end
  local list = self.vipManager:GetGiftExtraInfo(self.actId)
  if not list or #list == 0 then
    return nil
  end
  local selected
  for _, entry in ipairs(list) do
    local packId = entry.vipGiftId or entry.id
    if packId and 0 < packId then
      local pack = GiftPackageData.get(tostring(packId))
      if pack then
        local price = tonumber(pack:getPrice()) or 0
        local bought = pack:isBought()
        if not bought then
          if not selected or selected.isBought or price < selected.price then
            selected = {
              entry = entry,
              package = pack,
              price = price,
              isBought = bought
            }
          end
        else
          selected = selected or {
            entry = entry,
            package = pack,
            price = price,
            isBought = bought
          }
        end
      end
    end
  end
  return selected
end

function UILWVIPRadarPanelView:_formatRebateText(entry)
  if not entry or self.actId <= 0 then
    return ""
  end
  local percent = self.vipManager:GetStageDiscountPercent(self.actId, entry, true)
  if not percent or percent <= 0 then
    return ""
  end
  return string.format("%d", math_floor(percent + 0.5))
end

function UILWVIPRadarPanelView:OnClaimRewardClick()
  if self.actId <= 0 then
    return
  end
  if not self.vipManager:HasFreeReward(self.actId) then
    if self.claim_btn then
      self.claim_btn:SetInteractable(false)
    end
    return
  end
  self.preClaimAnimationState = self:SnapshotCurrentState()
  self.pendingPayAnimation = nil
  if self.claim_btn then
    self.claim_btn:SetInteractable(false)
  end
  self.claimRewardPending = true
  self.vipManager:SendReceiveFree(self.actId)
  self:StartClaimRewardTimeout()
end

function UILWVIPRadarPanelView:OnBuyCompleted()
  self:RefreshGiftSection()
end

function UILWVIPRadarPanelView:OnNote_btnClick()
  if not self.noteRewardData or not self.note_btn then
    return
  end
  local reward = self.noteRewardData
  local itemId = reward.itemId
  local alignObject = self.note_btn
  local uiManager = UIManager:GetInstance()
  local param = {}
  param.itemId = itemId
  param.alignObject = alignObject
  uiManager:OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UILWVIPRadarPanelView:OnInfo_btnClick()
  local title = Localization:GetString("radar_vipgift_info_title")
  local descKey = self.activityInfo.story
  local desc = descKey and Localization:GetString(descKey) or ""
  UIUtil.ShowIntro(title, "", desc)
end

function UILWVIPRadarPanelView:OnClose_btnClick()
  self:CloseWithAnimation()
end

return UILWVIPRadarPanelView
