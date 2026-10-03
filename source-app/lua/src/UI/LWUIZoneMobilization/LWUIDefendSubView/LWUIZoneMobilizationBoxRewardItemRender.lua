local base = UIBaseContainer
local LWUIZoneMobilizationBoxRewardItemRender = BaseClass("LWUIZoneMobilizationBoxRewardItemRender", base)
local BoxRewardPreviewView = require("UI.LWUIZoneMobilization.LWUIBoxRewardPreview.View.LWUIZoneMobilizationBoxRewardPreviewView")
local normalState_path = "NormalState"
local openState_path = "OpenState"
local redPoint_path = "RedPoint"
local numText_path = "NumText"
local btn_path = "Btn"

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
  self.normalState = self:AddComponent(UIBaseContainer, normalState_path)
  self.openState = self:AddComponent(UIBaseContainer, openState_path)
  self.redPoint = self:AddComponent(UIBaseContainer, redPoint_path)
  self.numText = self:AddComponent(UIText, numText_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:BtnClick()
  end)
end

local function ComponentDestroy(self)
  self.normalState = nil
  self.openState = nil
  self.redPoint = nil
  self.numText = nil
  self.btn = nil
end

local function DataDefine(self)
  self.index = 0
  self.data = nil
  self.surplusHpPercent = 0
end

local function DataDestroy(self)
  self.index = nil
  self.data = nil
  self.surplusHpPercent = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReceiveDefendRewardSuccess, self.OnReceiveRewardSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReceiveDefendRewardSuccess, self.OnReceiveRewardSuccess)
  base.OnRemoveListener(self)
end

local function OnReceiveRewardSuccess(self, index)
  if self.index == index then
    self:RefreshReceiveRewardState()
    self:RefreshRedPoint()
  end
end

local function InitData(self, index, data, surplusHpPercent)
  self.rewardData = data
  self.index = index
  self.surplusHpPercent = surplusHpPercent
  self.numText:SetText(self.rewardData.targetValue .. "%")
  self:RefreshReceiveRewardState()
  self:RefreshRedPoint()
end

local function RefreshReceiveRewardState(self)
  self.normalState:SetActive(not self.rewardData.rewarded)
  self.openState:SetActive(self.rewardData.rewarded)
end

local function RefreshRedPoint(self)
  local isCanReceive = self:IsCanReceiveReward()
  self.redPoint:SetActive(isCanReceive)
end

local function IsCanReceiveReward(self)
  if self.surplusHpPercent <= self.rewardData.targetValue and not self.rewardData.rewarded then
    return true
  end
  return false
end

local function BtnClick(self)
  local isCanReceive = self:IsCanReceiveReward()
  if isCanReceive then
    SFSNetwork.SendMessage(MsgDefines.ZoneMobilizationClaimDefendReward, self.index)
  else
    local param = BoxRewardPreviewView.ParamDataClass.New()
    param.position = self.btn.transform.position
    param.arrowDeltaY = 30
    param.showRewardList = self.rewardData.rewardList
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationBoxRewardPreview, {anim = false}, param)
  end
end

LWUIZoneMobilizationBoxRewardItemRender.OnCreate = OnCreate
LWUIZoneMobilizationBoxRewardItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationBoxRewardItemRender.OnEnable = OnEnable
LWUIZoneMobilizationBoxRewardItemRender.OnDisable = OnDisable
LWUIZoneMobilizationBoxRewardItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationBoxRewardItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationBoxRewardItemRender.DataDefine = DataDefine
LWUIZoneMobilizationBoxRewardItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationBoxRewardItemRender.OnAddListener = OnAddListener
LWUIZoneMobilizationBoxRewardItemRender.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationBoxRewardItemRender.OnReceiveRewardSuccess = OnReceiveRewardSuccess
LWUIZoneMobilizationBoxRewardItemRender.InitData = InitData
LWUIZoneMobilizationBoxRewardItemRender.RefreshReceiveRewardState = RefreshReceiveRewardState
LWUIZoneMobilizationBoxRewardItemRender.RefreshRedPoint = RefreshRedPoint
LWUIZoneMobilizationBoxRewardItemRender.IsCanReceiveReward = IsCanReceiveReward
LWUIZoneMobilizationBoxRewardItemRender.BtnClick = BtnClick
return LWUIZoneMobilizationBoxRewardItemRender
