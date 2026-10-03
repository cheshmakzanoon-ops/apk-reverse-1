local base = UIBaseContainer
local LWMaxAdListItemView = BaseClass("LWMaxAdListItemView", base)
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local titleTxt_path = "Title"
local scrollView_path = "Scroll"
local scrollViewContent_path = "Scroll/Viewport/Content"
local playBtn_path = "LW_Btn_Common_New"
local redDot_path = "LW_Btn_Common_New/RedDotWithoutNum"
local redDotNum_path = "LW_Btn_Common_New/RedDotWithoutNum/RedDotNum"
local playDescTxt_path = "PlayDesc"
local finishIcon_path = "FinishIcon"
local loadStateGo_path = "LW_Btn_Common_New/LoadState"
local loadTimerTxt_path = "LW_Btn_Common_New/LoadState/LoadTimer"
local btnNormalGo_path = "LW_Btn_Common_New/LW_Btn_Common_New_Base"

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
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.scrollView = self:AddComponent(UIBaseContainer, scrollView_path)
  self.scrollViewContent = self:AddComponent(UIBaseContainer, scrollViewContent_path)
  self.playBtn = self:AddComponent(UIButton, playBtn_path)
  self.redDot = self:AddComponent(UIBaseContainer, redDot_path)
  self.redDotNum = self:AddComponent(UIText, redDotNum_path)
  self.playDescTxt = self:AddComponent(UIText, playDescTxt_path)
  self.finishIcon = self:AddComponent(UIBaseContainer, finishIcon_path)
  self.loadStateGo = self:AddComponent(UIBaseContainer, loadStateGo_path)
  self.loadTimerTxt = self:AddComponent(UIText, loadTimerTxt_path)
  self.btnNormalGo = self:AddComponent(UIBaseContainer, btnNormalGo_path)
  self.playBtn:SetSafeClickMode(true)
  self.playBtn:SetOnClick(function()
    self:OnPlayBtnClick()
  end)
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
  self:ClearRewards()
  self.titleTxt = nil
  self.scrollView = nil
  self.scrollViewContent = nil
  self.playBtn = nil
  self.redDot = nil
  self.redDotNum = nil
  self.playDescTxt = nil
  self.finishIcon = nil
  self.loadStateGo = nil
  self.loadTimerTxt = nil
  self.btnNormalGo = nil
end

local function DataDefine(self)
  self.rewardObjList = {}
  self.loadAdTime = nil
end

local function DataDestroy(self)
  self.rewardObjList = {}
  self.loadAdTime = nil
end

function LWMaxAdListItemView:RefreshAdInfo()
  self:RefreshView(self.data)
end

function LWMaxAdListItemView:RefreshView(data, index)
  self.data = data
  self.serverData = data.serverData
  self.template = data.template
  self.rewardList = self.template:GetRewardData()
  self.titleTxt:SetLocalText(self.template.name)
  local count = self.template.times - self.serverData.rewardTimes
  self.redDotNum:SetText(count)
  self.playBtn:SetActive(0 < count)
  self.playDescTxt:SetActive(DataCenter.MaxAdManager:HasPrivilege() and 0 < count)
  self.finishIcon:SetActive(count == 0)
  self.redDot:SetActive(0 < count)
  self:RefreshLoadState()
  self:RefreshReward()
end

function LWMaxAdListItemView:RefreshLoadState()
  local nextCheckTime = DataCenter.MaxAdManager:GetCheckAdReadyTime()
  if nextCheckTime <= 0 then
    self.loadStateGo:SetActive(false)
    self.btnNormalGo:SetActive(true)
    return
  end
  self.loadStateGo:SetActive(true)
  self.btnNormalGo:SetActive(false)
  self.loadTimerTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(nextCheckTime))
end

function LWMaxAdListItemView:RefreshReward()
  self:ClearRewards()
  self.rewardItems = {}
  for i, v in ipairs(self.rewardList) do
    self.rewardItems[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local trans = go.transform
      trans:SetParent(self.scrollViewContent.transform)
      trans:Set_localScale(0.7, 0.7, 1)
      trans:Set_sizeDelta(100, 100)
      trans.pivot = Vector2.New(0, 0.5)
      go.name = "item" .. i
      local cell = self.scrollViewContent:AddComponent(UICommonResItem, go.name)
      cell:ReInit(v)
    end)
  end
end

function LWMaxAdListItemView:OnPlayBtnClick()
  local adUnitId = self.template:GetAdUnitId()
  DataCenter.MaxAdManager:CheckAdState(adUnitId)
  DataCenter.MaxAdManager:ShowAdsDetail(self.serverData.id)
end

function LWMaxAdListItemView:ClearRewards()
  self.scrollViewContent:RemoveComponents(UICommonResItem)
  if self.rewardItems then
    for k, v in pairs(self.rewardItems) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
end

LWMaxAdListItemView.OnCreate = OnCreate
LWMaxAdListItemView.OnDestroy = OnDestroy
LWMaxAdListItemView.OnEnable = OnEnable
LWMaxAdListItemView.OnDisable = OnDisable
LWMaxAdListItemView.ComponentDefine = ComponentDefine
LWMaxAdListItemView.ComponentDestroy = ComponentDestroy
LWMaxAdListItemView.DataDefine = DataDefine
LWMaxAdListItemView.DataDestroy = DataDestroy
return LWMaxAdListItemView
