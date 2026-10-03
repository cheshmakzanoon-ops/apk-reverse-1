local LWUICommonRankMultipleRewardView = BaseClass("LWUICommonRankMultipleRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RewardItem = require("UI.LWUIWorldBossReward.Component.LWUIWorldBossRewardItem")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local panel_path = "Panel"
local text_title_path = "safearea/TopBar/TextTitle"
local btn_close_path = "safearea/BtnClose"
local rank_scroll_view_path = "safearea/content/bg_2/MiddleBg/rankScrollView"
local toggle_list_path = "safearea/UICommonToggleList"
local p_content_hint_path = "safearea/content/p_content_hint"
local p_text_hint_path = "safearea/content/p_content_hint/p_text_hint"

function LWUICommonRankMultipleRewardView:OnCreate()
  base.OnCreate(self)
  self.tabDataList = self:GetUserData()
  self.toggle_list = self:AddComponent(UICommonToggleListComponent, toggle_list_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText(302026)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, rank_scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.p_content_hint = self:AddComponent(UIBaseContainer, p_content_hint_path)
  self.p_text_hint = self:AddComponent(UITextMeshProUGUIEx, p_text_hint_path)
  self:InitToggleList()
end

function LWUICommonRankMultipleRewardView:OnDestroy()
  self:ClearScroll()
  self.toggle_list = nil
  self.panel = nil
  self.text_title = nil
  self.btn_close = nil
  self.ScrollView = nil
  self.p_content_hint = nil
  self.p_text_hint = nil
  base.OnDestroy(self)
end

function LWUICommonRankMultipleRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonRankRewardUpdate, self.OnRankRewardUpdate)
end

function LWUICommonRankMultipleRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWSeasonRankRewardUpdate, self.OnRankRewardUpdate)
end

function LWUICommonRankMultipleRewardView:InitToggleList()
  local data = {}
  local itemsDataList = {}
  self.selectData = nil
  for _, rankId in ipairs(self.tabDataList) do
    local cfg = LocalController:instance():getLine(TableName.LW_Season_rank, rankId)
    local item = {}
    item.name = Localization:GetString(cfg.name)
    item.rankId = toInt(rankId)
    if cfg.reward_description ~= nil and cfg.reward_description ~= "" then
      item.hintText = Localization:GetString(cfg.reward_description)
    else
      item.hintText = ""
    end
    table.insert(itemsDataList, item)
    if self.selectData == nil then
      self:OnSelectToggle(1, item)
    end
  end
  data.itemsDataList = itemsDataList
  
  function data.onItemSelect(index, itemData)
    self:OnSelectToggle(index, itemData)
  end
  
  data.isCanScroll = true
  data.defaultSelectIndex = 1
  
  function data.isShowRed(index, itemData)
    return false
  end
  
  self.toggle_list:ReInit(data)
end

function LWUICommonRankMultipleRewardView:OnRankRewardUpdate(data)
  if data == nil or data.rankId == nil then
    return
  end
  local rankReward = data.rankReward or data.rankRewardInfo
  if rankReward == nil or self.selectData == nil or self.selectData.rankId ~= toInt(data.rankId) then
    return
  end
  self.selectData.rankReward = rankReward
  self.showDataList = rankReward
  self:RefreshList()
end

function LWUICommonRankMultipleRewardView:OnSelectToggle(index, itemData)
  self.selectData = itemData
  if itemData.rankReward == nil then
    self:ClearScroll()
    if itemData.rankId then
      SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, itemData.rankId)
    end
  else
    self.showDataList = itemData.rankReward
    self:RefreshList()
  end
  local hasHint = not string.IsNullOrEmpty(itemData.hintText)
  self.p_content_hint:SetActive(hasHint)
  if hasHint then
    self.p_text_hint:SetText(itemData.hintText)
  end
end

function LWUICommonRankMultipleRewardView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RewardItem)
end

function LWUICommonRankMultipleRewardView:RefreshList()
  self:ClearScroll()
  if self.showDataList and #self.showDataList > 0 then
    self.ScrollView:SetTotalCount(#self.showDataList)
    self.ScrollView:RefillCells()
  end
end

function LWUICommonRankMultipleRewardView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(RewardItem, itemObj)
  if self.showDataList then
    cellItem:SetData(self.showDataList[index])
  end
end

function LWUICommonRankMultipleRewardView:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RewardItem)
end

return LWUICommonRankMultipleRewardView
