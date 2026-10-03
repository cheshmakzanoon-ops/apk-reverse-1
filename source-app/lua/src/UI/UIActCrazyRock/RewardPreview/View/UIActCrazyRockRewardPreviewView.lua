local UIActCrazyRockRewardPreviewView = BaseClass("UIActCrazyRockRewardPreviewView", UIBaseView)
local base = UIBaseView
local base64 = require("Framework.Common.base64")
local Localization = CS.GameEntry.Localization
local M = UIActCrazyRockRewardPreviewView
local UIActCrazyRockRewardPreviewItem = require("UI.UIActCrazyRock.RewardPreview.Component.UIActCrazyRockRewardPreviewItem")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local ChannelType = {RewardPreview = 1, GamePlay = 2}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  self:InitView()
end

function M:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.toggleTabItem1 = self.viewSkin:AddComponent(self, UIToggle, 2)
  self.toggleTabItem2 = self.viewSkin:AddComponent(self, UIToggle, 3)
  self.textTabItemText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTabItemText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compTabItemSelect1 = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compTabItemUnSelect1 = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compTabItemSelect2 = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compTabItemUnSelect2 = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.compIntroTextArea = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compRewardNode = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textPlay = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.rewardScroll = self.viewSkin:AddComponent(self, UILoopListView2, 13)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.textReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.rewardScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.textPlay:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetTitle("activity_concert_21")
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.commonActivityPopUpBgPart:SetToggleText(ChannelType.RewardPreview, Localization:GetString("activity_concert_22"))
  self.commonActivityPopUpBgPart:SetToggleText(ChannelType.GamePlay, Localization:GetString("activity_concert_21_1"))
  self.commonActivityPopUpBgPart:SetSelectCallback(function(index)
    self:OnTabChanged(index)
  end)
end

function M:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.toggleTabItem1 = nil
  self.toggleTabItem2 = nil
  self.textTabItemText1 = nil
  self.textTabItemText2 = nil
  self.compTabItemSelect1 = nil
  self.compTabItemUnSelect1 = nil
  self.compTabItemSelect2 = nil
  self.compTabItemUnSelect2 = nil
  self.compIntroTextArea = nil
  self.compRewardNode = nil
  self.textPlay = nil
  self.rewardScroll = nil
  self.compContent = nil
  self.textReward = nil
end

function M:DataDefine()
  self.curChannel = ChannelType.RewardPreview
  self.rewardConfig = {}
  self.itemIndex = 0
  self.activityId = 0
  self.showConfig = {}
end

function M:DataDestroy()
  self.curChannel = nil
  self.rewardConfig = nil
  self.itemIndex = nil
  self.activityId = 0
  self.showConfig = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function M:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function M:InitView()
  self.textTabItemText1:SetLocalText("activity_concert_22")
  self.textTabItemText2:SetLocalText("activity_concert_21_1")
  self.textReward:SetLocalText("activity_concert_22_1")
  self:ModifyPanelPacking()
  self:InitTab()
  self:InitScroll()
  self:InitPlayText()
end

function M:InitTab()
  self.commonActivityPopUpBgPart:SetSelectIndex(self.curChannel)
  self:OnTabChanged(self.curChannel)
end

function M:InitPlayText()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.textPlay:SetLocalText(activityInfo.story)
end

function M:InitScroll()
  self.rewardConfig = DataCenter.ActCrazyRockDataManager:GetCrazyRockActRewardConfig(self.activityId)
  if self.rewardConfig == nil then
    Logger.LogError("rewardConfig is empty")
    return
  end
  if self.rewardScroll == nil or #self.rewardConfig == 0 then
    self.rewardScroll:SetActive(false)
  else
    self.rewardScroll:SetActive(true)
    self.rewardScroll:SetListItemCount(#self.rewardConfig, false, false)
    self.rewardScroll:RefreshAllShownItem()
  end
end

function M:OnTabChanged(tab)
  self.compTabItemSelect1:SetActive(tab == ChannelType.RewardPreview)
  self.compTabItemUnSelect1:SetActive(tab ~= ChannelType.RewardPreview)
  self.compTabItemSelect2:SetActive(tab == ChannelType.GamePlay)
  self.compTabItemUnSelect2:SetActive(tab ~= ChannelType.GamePlay)
  self.curChannel = tab
  self.compRewardNode:SetActive(tab == ChannelType.RewardPreview)
  self.compIntroTextArea:SetActive(tab == ChannelType.GamePlay)
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rewardConfig then
    return nil
  end
  local rewardInfo = self.rewardConfig[index]
  local item = loopScroll:NewListViewItem("ItemContent")
  local script = self.compContent:GetComponent(item.gameObject.name, UIActCrazyRockRewardPreviewItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(UIActCrazyRockRewardPreviewItem, objectName)
  end
  script:SetActive(true)
  script:SetData(rewardInfo, self.activityId, self.showConfig)
  return item
end

function M:ClearScroll()
  self.compContent:RemoveComponents(UIActCrazyRockRewardPreviewItem)
  self.rewardScroll:ClearAllItems()
end

function M:ModifyPanelPacking()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo == nil then
    return
  end
  if activityInfo:GetFestivalInterfaceCfgId() then
    local festivalInterfaceCfgId = activityInfo:GetFestivalInterfaceCfgId()
    local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
    if lineData == nil then
      Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
      return
    end
    self.showConfig = lineData
    self.commonActivityPopUpBgPart:ModifyPanelPacking(lineData, "", self.activityId)
  end
end

function UIActCrazyRockRewardPreviewView:OnPointerClick(clickPos)
  if self.textPlay == nil then
    return
  end
  local linkId = self.textPlay:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if string.find(linkId, "http:") or string.find(linkId, "https:") then
    local language = Localization:GetLanguageName()
    if string.find(linkId, "{0}", 1, true) then
      linkId = string.gsub(linkId, "{0}", language, 1)
    end
    CS.SDKManager.OpenURL(linkId)
  else
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    GoToUtil.TryJumpToWorld(linkMsg)
  end
end

return UIActCrazyRockRewardPreviewView
