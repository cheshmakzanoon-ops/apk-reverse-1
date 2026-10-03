local S6MilitaryRewardView = BaseClass("S6MilitaryRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local S6MilitaryRewardItem = require("UI.LWSeason6.UILWSeasonMilitary.Reward.Comp.S6MilitaryRewardItem")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local RewardUtil = require("Util.RewardUtil")
local panel_path = "Panel"
local text_title_path = "safearea/TopBar/TextTitle"
local btn_close_path = "safearea/BtnClose"
local rank_scroll_view_path = "safearea/content/bg_2/MiddleBg/rankScrollView"
local toggle_list_path = "safearea/UICommonToggleList"
local p_content_hint_path = "safearea/content/p_content_hint"
local p_text_hint_path = "safearea/content/p_content_hint/p_text_hint"

function S6MilitaryRewardView:ComponentDefine()
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
  self.ScrollView = self:AddComponent(UILoopListViewSimple, rank_scroll_view_path)
  self.p_content_hint = self:AddComponent(UIBaseContainer, p_content_hint_path)
  self.p_text_hint = self:AddComponent(UITextMeshProUGUIEx, p_text_hint_path)
end

function S6MilitaryRewardView:ComponentDestroy()
  self.toggle_list = nil
  self.panel = nil
  self.text_title = nil
  self.btn_close = nil
  self.ScrollView = nil
  self.p_content_hint = nil
  self.p_text_hint = nil
end

function S6MilitaryRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit(self:GetUserData())
end

function S6MilitaryRewardView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6MilitaryRewardView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function S6MilitaryRewardView:InitData(data)
  self.DefaultIndex = data ~= nil and Mathf.Clamp(checknumber(data.DefaultIndex), 1, 2) or 1
  return true
end

function S6MilitaryRewardView:InitUi()
  self.ScrollView:Init(S6MilitaryRewardItem)
  self:InitToggleList()
end

function S6MilitaryRewardView:InitToggleList()
  self.selectData = nil
  local itemsDataList = {}
  table.insert(itemsDataList, self:GetDailyReward())
  table.insert(itemsDataList, self:GetFinalReward())
  local data = {}
  data.itemsDataList = itemsDataList
  
  function data.onItemSelect(index, itemData)
    self:OnSelectToggle(index, itemData)
  end
  
  data.isCanScroll = true
  data.defaultSelectIndex = self.DefaultIndex
  
  function data.isShowRed(index, itemData)
    return false
  end
  
  self.toggle_list:ReInit(data)
end

function S6MilitaryRewardView:OnSelectToggle(index, itemData)
  self.selectData = itemData
  if itemData.rewardList ~= nil then
    self.showDataList = itemData.rewardList
    self.moveTop = index == 1
    self:RefreshList()
  end
  self.p_text_hint:SetText(itemData.hint)
  self.p_content_hint:SetActive(not string.IsNullOrEmpty(itemData.hint))
end

function S6MilitaryRewardView:RefreshList()
  self.ScrollView:Clear()
  if self.showDataList and #self.showDataList > 0 then
    local level = DataCenter.SeasonMilitaryManager:GetCurLevel()
    local focusIndex = 0
    local index = 0
    for _, data in pairs(self.showDataList) do
      self.ScrollView:AddData(data)
      if data.level == level then
        focusIndex = index
      end
      index = index + 1
    end
    self.ScrollView:Show()
    self.ScrollView:MovePanelToItemIndex(self.moveTop and focusIndex or 0)
  end
end

function S6MilitaryRewardView:GetDailyReward()
  local item = {}
  item.name = Localization:GetString("season_military_daily_reward")
  item.hint = ""
  item.rewardList = {}
  local cells = DataCenter.SeasonMilitaryManager:GetLevelCells()
  if not table.IsNullOrEmpty(cells) then
    for _, cell in pairs(cells) do
      local cellData = {}
      cellData.title = CS.GameEntry.Localization:GetString(cell:GetName())
      cellData.rewards = RewardUtil.GetRewardItem(checknumber(cell.daily_salary))
      cellData.level = checknumber(cell.level)
      table.insert(item.rewardList, cellData)
    end
  end
  table.sort(item.rewardList, function(a, b)
    return a.level > b.level
  end)
  return item
end

function S6MilitaryRewardView:GetFinalReward()
  local item = {}
  item.name = Localization:GetString("season_military_settlement_rewards")
  item.hint = CS.GameEntry.Localization:GetString("season_military_settle_reward_desc")
  item.rewardList = {}
  local cells = DataCenter.SeasonMilitaryManager:GetLevelCells()
  if not table.IsNullOrEmpty(cells) then
    for _, cell in pairs(cells) do
      local cellData = {}
      cellData.title = CS.GameEntry.Localization:GetString(cell:GetName())
      cellData.rewards = cell:GetFinalRewards()
      cellData.level = checknumber(cell.level)
      table.insert(item.rewardList, cellData)
    end
  end
  table.sort(item.rewardList, function(a, b)
    return a.level > b.level
  end)
  return item
end

return S6MilitaryRewardView
