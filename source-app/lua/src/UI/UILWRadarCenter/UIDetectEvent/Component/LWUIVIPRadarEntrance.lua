local base = UIAsyncContainer
local LWUIVIPRadarEntrance = BaseClass("LWUIVIPRadarEntrance", base)
local Localization = CS.GameEntry.Localization
local DownloadResGroupCommonManager = CS.DownloadResGroupCommonManager
local GiftPackageData = _ENV.GiftPackageData
local Quality2IconPath = {
  [ItemColor.PURPLE] = "Assets/Main/Sprites/UI/UILWVIPRadarDownload/wxy_leida_libao_rukou.png",
  [ItemColor.ORANGE] = "Assets/Main/Sprites/UI/UILWVIPRadarDownload/wxy_leida_libao_rukou2.png",
  [ItemColor.GOLDEN] = "Assets/Main/Sprites/UI/UILWVIPRadarDownload/wxy_leida_libao_rukou2.png"
}
local complete_path = "complete"
local btn_path = "complete/btn"
local redDot_path = "complete/redDot"
local countdown_txt_path = "complete/countdown_txt"
local download_path = "download"
local download_btn_path = "download/download_btn"
local downloading_container_path = "download/downloading"
local downloading_progress_path = "download/downloading/bg/downloading_progress"
local downloading_numTxt_path = "download/downloading/downloadPercent_txt"
local downloadState_txt_path = "download/downloadState_txt"
local RewardUtil = require("Util.RewardUtil")

local function resolve_reward_icon(reward)
  if not reward then
    return nil
  end
  if reward.icon and reward.icon ~= "" then
    return reward.icon
  end
  local itemId = not (not reward.itemId and reward.value) or reward.value.itemId or reward.value.id or reward.value.goodsId
  local rewardType = reward.rewardType or reward.type
  if rewardType and itemId and RewardUtil and RewardUtil.GetPic then
    local pic = RewardUtil.GetPic(rewardType, itemId)
    if pic and pic ~= "" then
      return pic
    end
  end
  return nil
end

local function build_display_data(snapshot, manager, actId)
  snapshot.count = 0
  snapshot.icon = nil
  snapshot.hasFree = false
  snapshot.bubbleReward = nil
  if not (manager and actId) or actId <= 0 then
    return snapshot
  end
  local summary = manager:GetSummary(actId)
  if summary then
    snapshot.hasFree = summary.hasFreeReward
  else
    snapshot.hasFree = manager:HasFreeReward(actId)
  end
  local data = manager:GetData(actId)
  snapshot.count = 0
  local stageEntry
  local qualityId = ItemColor.GREEN
  if stageEntry and stageEntry.bubbleQualityId then
    qualityId = stageEntry.bubbleQualityId
  elseif data and data.extraRewardList and data.extraRewardList[1] and data.extraRewardList[1].bubbleQualityId then
    qualityId = data.extraRewardList[1].bubbleQualityId
  else
    local config = manager:GetActivityConfig(actId)
    if config and config.stageList and config.stageList[1] and config.stageList[1].bubbleQualityId then
      qualityId = config.stageList[1].bubbleQualityId
    end
  end
  snapshot.icon = Quality2IconPath[qualityId] or Quality2IconPath[ItemColor.GREEN]
  return snapshot
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:UpdateData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.completeRoot = self:AddComponent(UIBaseComponent, complete_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btnImage = self:AddComponent(UIImage, btn_path)
  self.redDot = self:AddComponent(UIBaseComponent, redDot_path)
  self.countdownTxt = self:AddComponent(UITextMeshProUGUIEx, countdown_txt_path)
  self.downloadRoot = self:AddComponent(UIBaseComponent, download_path)
  self.downloadBtn = self:AddComponent(UIButton, download_btn_path)
  self.downloadingContainer = self:AddComponent(UIBaseComponent, downloading_container_path)
  self.downloadProgressImg = self:AddComponent(UIImage, downloading_progress_path)
  self.downloadPercentTxt = self:AddComponent(UITextMeshProUGUIEx, downloading_numTxt_path)
  self.downloadStateTxt = self:AddComponent(UITextMeshProUGUIEx, downloadState_txt_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.downloadBtn:SetOnClick(function()
    self:OnDownloadBtnClick()
  end)
  if self.countdownTxt then
    self.countdownTxt:SetActive(false)
  end
  if self.downloadStateTxt then
    self.downloadStateTxt:SetLocalText("radar_vipgift_entrance_loading_tips1")
  end
  if self.downloadPercentTxt then
    self.downloadPercentTxt:SetText("0%")
  end
  if self.downloadProgressImg then
    self.downloadProgressImg:SetFillAmount(0)
  end
  if self.downloadingContainer then
    self.downloadingContainer:SetActive(false)
  end
end

local function ComponentDestroy(self)
  self.completeRoot = nil
  self.btn = nil
  self.btnImage = nil
  self.redDot = nil
  self.downloadRoot = nil
  self.downloadBtn = nil
  self.downloadingContainer = nil
  self.downloadProgressImg = nil
  self.downloadPercentTxt = nil
  self.downloadStateTxt = nil
end

local function DataDefine(self)
  self.actId = 0
  self.activityInfo = nil
  self.displayData = {
    count = 0,
    icon = nil,
    hasFree = false,
    bubbleReward = nil
  }
  self.currentIconPath = nil
  self.lastRequestTime = 0
  self.activityEndTime = nil
end

local function DataDestroy(self)
  self.actId = nil
  self.activityInfo = nil
  self.displayData = nil
  self.currentIconPath = nil
  self.lastRequestTime = nil
  self.activityEndTime = nil
end

function LWUIVIPRadarEntrance:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  self:AddUIListener(EventId.OnPassDay, self.OnVipRadarPassDayRefresh)
  self:AddUIListener(EventId.SurvivalVipGiftInfoUpdate, self.UpdateData)
  self:AddUIListener(EventId.SurvivalVipGiftFreeReward, self.UpdateData)
end

function LWUIVIPRadarEntrance:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  self:RemoveUIListener(EventId.OnPassDay, self.OnVipRadarPassDayRefresh)
  self:RemoveUIListener(EventId.SurvivalVipGiftInfoUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.SurvivalVipGiftFreeReward, self.UpdateData)
  base.OnRemoveListener(self)
end

function LWUIVIPRadarEntrance:ReInit(data)
  self.data = data or {}
  if self.data.actId then
    self.actId = tonumber(self.data.actId) or 0
  end
  self:UpdateData()
end

function LWUIVIPRadarEntrance:UpdateData()
  local vipManager = DataCenter.VipGiftActDataManager
  local canShow, activityInfo = false
  if vipManager.CanShowRadarEntrance then
    canShow, activityInfo = vipManager:CanShowRadarEntrance()
  end
  if not activityInfo then
    self.actId = 0
    self.activityInfo = nil
    self.activityEndTime = nil
    if self.displayData then
      self.displayData.count = 0
      self.displayData.icon = nil
      self.displayData.hasFree = false
      self.displayData.bubbleReward = nil
    end
    self:SetActive(false)
    return
  end
  self.activityInfo = activityInfo
  self.actId = tonumber(activityInfo.id or activityInfo.activityId) or 0
  self.activityEndTime = nil
  if self.actId <= 0 then
    if self.displayData then
      self.displayData.count = 0
      self.displayData.icon = nil
      self.displayData.hasFree = false
      self.displayData.bubbleReward = nil
    end
    self:SetActive(false)
    return
  end
  local info = vipManager:GetData(self.actId)
  if not info then
    local now = UITimeManager:GetInstance():GetServerTime()
    local REQUEST_INTERVAL_MS = 3000
    if not (self.lastRequestTime and now) or now <= 0 or REQUEST_INTERVAL_MS <= now - self.lastRequestTime then
      self.lastRequestTime = now or 0
      vipManager:SendGetInfo(self.actId, true)
    end
    self:SetActive(false)
    return
  end
  if info.isShow == false or not canShow then
    self:SetActive(false)
    return
  end
  self:UpdateDownloadUIState("complete", 1)
  local endTime = DataCenter.VipGiftActDataManager:GetDisappearTime(self.actId)
  local curTimeForEnd = UITimeManager:GetInstance():GetServerTime()
  if endTime and curTimeForEnd and endTime > curTimeForEnd then
    local thresholdHour = LuaEntry.DataConfig:TryGetNum("worker_gift_entry_time", "k1", 72)
    local thresholdMs = (thresholdHour or 0) * 60 * 60 * 1000
    if 0 < thresholdMs and thresholdMs >= endTime - curTimeForEnd then
      self.activityEndTime = endTime
    end
  end
  if self.displayData then
    build_display_data(self.displayData, vipManager, self.actId)
  end
  self:SetActive(true)
  self:RefreshView()
end

function LWUIVIPRadarEntrance:OnVipRadarPassDayRefresh()
  DataCenter.VipGiftActDataManager:SendGetInfo(self.actId, true)
end

function LWUIVIPRadarEntrance:IsDownloadReady()
  return true
end

function LWUIVIPRadarEntrance:UpdateDownloadUIState(state, progress)
  if self.downloadRoot then
    self.downloadRoot:SetActive(false)
  end
  if self.completeRoot then
    self.completeRoot:SetActive(true)
    self.completeRoot:SetLocalScaleXYZ(1, 1, 1)
  end
  if self.btn then
    self.btn:SetActive(true)
  end
  if self.downloadStateTxt then
    self.downloadStateTxt:SetActive(false)
  end
  if self.downloadingContainer then
    self.downloadingContainer:SetActive(false)
  end
  if self.downloadBtn then
    self.downloadBtn:SetActive(false)
  end
  if self.downloadProgressImg then
    self.downloadProgressImg:SetFillAmount(1)
  end
  if self.downloadPercentTxt then
    self.downloadPercentTxt:SetText("100%")
  end
end

function LWUIVIPRadarEntrance:RefreshView()
  if not self:GetActiveInHierarchy() then
    return
  end
  local snapshot = self.displayData
  if not snapshot then
    return
  end
  local vipManager = DataCenter.VipGiftActDataManager
  build_display_data(snapshot, vipManager, self.actId)
  local ready = self:IsDownloadReady()
  if self.redDot then
    self.redDot:SetActive(ready and snapshot.hasFree)
  end
  if ready then
    local iconPath = snapshot.icon or resolve_reward_icon(snapshot.bubbleReward)
    if iconPath and iconPath ~= "" and iconPath ~= self.currentIconPath then
      self.currentIconPath = iconPath
      self.btnImage:LoadSpriteAsync(iconPath)
    end
  end
  local hasCountdown = self.activityEndTime and self.activityEndTime > 0
  if self.countdownTxt then
    if hasCountdown then
      self.countdownTxt:SetActive(true)
      self:Update1000MS()
    else
      self.countdownTxt:SetActive(false)
    end
  end
  if self.completeRoot and self.completeRoot.SetSizeDeltaY then
    if hasCountdown then
      self.completeRoot:SetSizeDeltaY(120)
    else
      self.completeRoot:SetSizeDeltaY(100)
    end
  end
end

function LWUIVIPRadarEntrance:Update1000MS()
  if not (self.countdownTxt and self.activityEndTime) or self.activityEndTime <= 0 then
    return
  end
  if UIUtil and UIUtil.SetLeftTimeText and UIUtil.SetLeftTimeText(self.countdownTxt, nil, self.activityEndTime) then
    self.activityEndTime = nil
    self.countdownTxt:SetActive(false)
  end
end

function LWUIVIPRadarEntrance:OnBtnClick()
  if not self:IsDownloadReady() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWVIPRadarPanel, {anim = true}, {
    actId = self.actId
  })
end

function LWUIVIPRadarEntrance:OnDownloadBtnClick()
end

LWUIVIPRadarEntrance.OnCreate = OnCreate
LWUIVIPRadarEntrance.OnDestroy = OnDestroy
LWUIVIPRadarEntrance.OnEnable = OnEnable
LWUIVIPRadarEntrance.OnDisable = OnDisable
LWUIVIPRadarEntrance.ComponentDefine = ComponentDefine
LWUIVIPRadarEntrance.ComponentDestroy = ComponentDestroy
LWUIVIPRadarEntrance.DataDefine = DataDefine
LWUIVIPRadarEntrance.DataDestroy = DataDestroy
return LWUIVIPRadarEntrance
