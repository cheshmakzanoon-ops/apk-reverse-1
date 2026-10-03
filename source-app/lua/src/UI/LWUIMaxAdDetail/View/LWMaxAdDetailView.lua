local base = UIBaseView
local LWMaxAdDetailView = BaseClass("LWMaxAdDetailView", base)
local LWMaxAdFirstPayView = require("UI.LWUIMaxAd.Component.LWMaxAdFirstPayView")
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local panelBtn_path = "panel"
local giftPackageItem_path = "Content/LWMaxAdFirstPay"
local playBtn_path = "Content/LW_Btn_Common_New"
local rewardContent_path = "Content/RewardContent"
local redDot_path = "Content/LW_Btn_Common_New/RedDotWithoutNum"
local redDotNum_path = "Content/LW_Btn_Common_New/RedDotWithoutNum/RedDotNum"
local loadStateGo_path = "Content/LW_Btn_Common_New/LoadState"
local loadTimerTxt_path = "Content/LW_Btn_Common_New/LoadState/LoadTimer"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  local adId = self:GetUserData()
  PostEventLog.Track(PostEventLog.Defines.ADEventOpen, {af_content_id = adId})
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.giftPackageItem = self:AddComponent(UIBaseContainer, giftPackageItem_path)
  self.playBtn = self:AddComponent(UIButton, playBtn_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.redDot = self:AddComponent(UIBaseContainer, redDot_path)
  self.redDotNum = self:AddComponent(UIText, redDotNum_path)
  self.loadStateGo = self:AddComponent(UIBaseContainer, loadStateGo_path)
  self.loadTimerTxt = self:AddComponent(UIText, loadTimerTxt_path)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.playBtn:SetOnClick(function()
    self:OnPlayBtnClick()
  end)
  self.gift_package_item = self:AddComponent(LWMaxAdFirstPayView, giftPackageItem_path)
  self.gift_package_item:SetActive(false)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.RefreshLoadState, self, false, false, true)
    self.timer:Start()
  end
end

local function ComponentDestroy(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  self.panelBtn = nil
  self.giftPackageItem = nil
  self.playBtn = nil
  self.rewardContent = nil
  self.redDot = nil
  self.redDotNum = nil
  self.loadStateGo = nil
  self.loadTimerTxt = nil
  self.gift_package_item = nil
end

local function DataDefine(self)
  self.rewardItems = {}
  local adId = self:GetUserData()
  local data = DataCenter.MaxAdManager:GetAdCollectionById(adId)
  self.serverData = data.serverData
  self.template = data.template
  self.rewardList = self.template and self.template:GetRewardData() or {}
end

local function DataDestroy(self)
  self.rewardItems = {}
  self.rewardList = {}
end

local function OnAddListener(self)
  base.OnAddListener(self)
  if not self or not self.__event_handlers then
    return
  end
  self:AddUIListener(EventId.UpdateFirstPayState, self.OnRefreshFirstPay)
  self:AddUIListener(EventId.MaxAd_RefreshAdInfo, self.RefreshView)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if not self or not self.__event_handlers then
    return
  end
  self:RemoveUIListener(EventId.UpdateFirstPayState, self.OnRefreshFirstPay)
  self:RemoveUIListener(EventId.MaxAd_RefreshAdInfo, self.RefreshView)
end

function LWMaxAdDetailView:RefreshView()
  if self.template == nil then
    return
  end
  self.rewardList = self.template:GetRewardData()
  self:RefreshReward()
  self:OnRefreshFirstPay()
  local count = self.template.times - self.serverData.rewardTimes
  self.redDot:SetActive(0 < count)
  self.redDotNum:SetText(count)
  self.playBtn:SetActive(0 < count)
  self:RefreshLoadState()
end

function LWMaxAdDetailView:RefreshLoadState()
  local nextCheckTime = DataCenter.MaxAdManager:GetCheckAdReadyTime()
  if nextCheckTime <= 0 then
    self.loadStateGo:SetActive(false)
    return
  end
  self.loadStateGo:SetActive(true)
  self.loadTimerTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(nextCheckTime))
end

function LWMaxAdDetailView:RefreshReward()
  self:ClearRewards()
  self.rewardItems = {}
  for i, v in ipairs(self.rewardList) do
    self.rewardItems[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local trans = go.transform
      trans:SetParent(self.rewardContent.transform)
      trans:Set_localScale(1, 1, 1)
      trans:Set_sizeDelta(100, 100)
      trans.pivot = Vector2.New(0.5, 0.5)
      go.name = "item" .. i
      local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
      cell:ReInit(v)
    end)
  end
end

function LWMaxAdDetailView:OnRefreshFirstPay()
  self.gift_package_item:SetActive(DataCenter.MaxAdManager:IsFirstPayConfigOpen() and not DataCenter.MaxAdManager:HasPrivilege())
  self.gift_package_item:RefreshView()
end

function LWMaxAdDetailView:OnPlayBtnClick()
  local adUnitId = self.template:GetAdUnitId()
  DataCenter.MaxAdManager:CheckAdState(adUnitId)
  DataCenter.MaxAdManager:ShowAdsDetail(self.serverData.id)
  self.ctrl:CloseSelf()
end

function LWMaxAdDetailView:ClearRewards()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardItems then
    for k, v in pairs(self.rewardItems) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
end

LWMaxAdDetailView.OnCreate = OnCreate
LWMaxAdDetailView.OnDestroy = OnDestroy
LWMaxAdDetailView.OnEnable = OnEnable
LWMaxAdDetailView.OnDisable = OnDisable
LWMaxAdDetailView.ComponentDefine = ComponentDefine
LWMaxAdDetailView.ComponentDestroy = ComponentDestroy
LWMaxAdDetailView.DataDefine = DataDefine
LWMaxAdDetailView.DataDestroy = DataDestroy
LWMaxAdDetailView.OnAddListener = OnAddListener
LWMaxAdDetailView.OnRemoveListener = OnRemoveListener
return LWMaxAdDetailView
