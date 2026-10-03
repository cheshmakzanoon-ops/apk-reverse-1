local UIDigRewardView = BaseClass("UIDigRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DigRewardItem = require("UI.UIDigReward.Component.DigRewardItem")
local title_path = "UICommonMidPopUpTitle/titleText"
local closeBtn_path = "UICommonMidPopUpTitle/CloseBtn"
local rewardSv_path = "ImgBg/svRewards"
local rewardContent_path = "ImgBg/svRewards/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:InitUI()
end

local function OnDestroy(self)
  self:ClearItemCell()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(372442)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.rewardSvN = self:AddComponent(UIBaseContainer, rewardSv_path)
  self.rewardContentN = self:AddComponent(GridInfinityScrollView, rewardContent_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.rewardContentN:Init(bindFunc1, bindFunc2, bindFunc3)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.rewardSvN = nil
  self.rewardContentN = nil
end

local function DataDefine(self)
  self.listGO = {}
end

local function DataDestroy(self)
  self.listGO = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitUI(self)
  self.activityId, self.level = self:GetUserData()
  self.rewardsList = DataCenter.DigActivityManager:GetPreviewRewardsList(self.activityId, self.level)
  self.rewardContentN:SetItemCount(#self.rewardsList)
end

local function OnInitScroll(self, go, index)
  local item = self.rewardSvN:AddComponent(DigRewardItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  go.name = tostring(index)
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  local luaIndex = index + 1
  cellItem:SetItem(self.rewardsList[luaIndex])
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearItemCell(self)
  self.rewardSvN:RemoveComponents(DigRewardItem)
  self.rewardContentN:DestroyChildNode()
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

UIDigRewardView.OnCreate = OnCreate
UIDigRewardView.OnDestroy = OnDestroy
UIDigRewardView.ComponentDefine = ComponentDefine
UIDigRewardView.ComponentDestroy = ComponentDestroy
UIDigRewardView.DataDefine = DataDefine
UIDigRewardView.DataDestroy = DataDestroy
UIDigRewardView.OnAddListener = OnAddListener
UIDigRewardView.OnRemoveListener = OnRemoveListener
UIDigRewardView.InitUI = InitUI
UIDigRewardView.RefreshRewards = RefreshRewards
UIDigRewardView.OnInitScroll = OnInitScroll
UIDigRewardView.OnUpdateScroll = OnUpdateScroll
UIDigRewardView.OnDestroyScrollItem = OnDestroyScrollItem
UIDigRewardView.ClearItemCell = ClearItemCell
UIDigRewardView.OnClickCloseBtn = OnClickCloseBtn
return UIDigRewardView
