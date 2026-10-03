local LWSeason5RewardView = BaseClass("LWSeason5RewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWSeason5RewardTabItem = require("UI.LWSeason5.LWSeason5Reward.Comp.LWSeason5RewardTabItem")
local personalReward = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonPersonalReward")
local battleReward = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonBattleFieldReward")
local s5AllianceReward = require("UI.LWSeason5.LWSeason5Reward.Comp.LWSeason5AllianceReward")
local btn_back_path = "Root/BottomBar/BtnBack"
local top_bar_path = "Root/TopBar"
local tab_path = "Root/TopBar/Tab"
local tab_item_path = "Root/TopBar/Tab/TabItem"
local content_path = "Root/Container/Content"

function LWSeason5RewardView:InitTabList()
  if self.panelType and self.panelType == 1 then
    self:RegisterTab(battleReward, "Assets/Main/Prefabs/UI/LWSeason/LWSeasonBattleFieldReward.prefab", "season_builders_alliance_UI_13", LWSeasonBattleFieldRewardPanelType.FamerReward)
    return
  end
  self:RegisterTab(s5AllianceReward, "Assets/Main/SeasonRes/S5/Prefabs/UI/AllianceReward/S5SeasonAllianceReward.prefab", "129046")
  if SeasonUtil.IsInSeasonDesertMode() then
    self:RegisterTab(personalReward, "Assets/Main/Prefabs/UI/LWSeason/LWSeasonPersonalReward.prefab", "393080")
  end
  local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
  if seasonConfig and not string.IsNullOrEmpty(seasonConfig.zone_reward) then
    self:RegisterTab(battleReward, "Assets/Main/Prefabs/UI/LWSeason/LWSeasonBattleFieldReward.prefab", "800941", LWSeasonBattleFieldRewardPanelType.BattleField)
  end
  if seasonConfig and not string.IsNullOrEmpty(seasonConfig.camp_reward) then
    self:RegisterTab(battleReward, "Assets/Main/Prefabs/UI/LWSeason/LWSeasonBattleFieldReward.prefab", "season_s2_rank_reward_1", LWSeasonBattleFieldRewardPanelType.Camp)
  end
end

function LWSeason5RewardView:OnCreate()
  base.OnCreate(self)
  local param, panelType = self:GetUserData()
  self.panelType = panelType
  self:ComponentDefine()
  self.initFinish = false
  self:InitTabList()
  self.top_bar:SetHorizontalNormalizedPosition(0)
  self.initFinish = true
  local activeIndex = 1
  local activeTab = self.tabList[1]
  if param ~= nil then
    local index = tonumber(param)
    if 0 < index and index < 4 then
      activeIndex = index
      activeTab = self.tabList[index]
    end
  end
  if activeTab then
    activeTab:SetIsOn(true)
    local count = #self.tabList
    if self.tabActive == nil then
      activeTab:OnSelectStatusChanged(true)
    end
    if 3 < count then
      self.top_bar:SetHorizontalNormalizedPosition((activeIndex - 1) / (count - 1))
    else
      self.top_bar:SetHorizontalNormalizedPosition(0)
    end
  end
end

function LWSeason5RewardView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeason5RewardView:OnAddListener()
  base.OnAddListener(self)
end

function LWSeason5RewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWSeason5RewardView:ComponentDefine()
  self.tabActive = nil
  self.tabList = {}
  self.panelList = {}
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.top_bar = self:AddComponent(UIScrollRect, top_bar_path)
  self.tab_item = self.transform:Find(tab_item_path).gameObject
  self.tab_item:SetActive(false)
  self.tab_item:GameObjectCreatePool()
  self.tab_root = self:AddComponent(UIBaseContainer, tab_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function LWSeason5RewardView:ComponentDestroy()
  self.TabWeekCard = nil
  self.tab_root:RemoveComponents(LWSeason5RewardTabItem)
  self.tab_item:GameObjectRecycleAll()
  for k, v in pairs(self.panelList) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self.tabList = {}
  self.panelList = {}
  self.btn_back = nil
end

function LWSeason5RewardView:RegisterTab(class, assetPath, tabName, param)
  local goItem = self.tab_item:GameObjectSpawn(self.tab_root.transform)
  local index = #self.tabList + 1
  goItem.name = "tab_" .. tabName
  goItem:SetActive(true)
  local theTabItem = self.tab_root:AddComponent(LWSeason5RewardTabItem, goItem.name)
  theTabItem:ReInit(index, class, assetPath, tabName, param)
  table.insert(self.tabList, theTabItem)
  return theTabItem
end

function LWSeason5RewardView:ShowTabItemAnim()
  if self.tabActive ~= nil then
    local tabTransform = self.tab_root.transform
    local x = tabTransform.anchoredPosition.x
    local min_x = 300 - 300 * self.tabActive.index
    local max_x = min_x + self.rectTransform.rect.width - 300
    if x < min_x then
      tabTransform:DOMove(tabTransform.position + Vector3(min_x - x, 0, 0), 0.2):SetEase(CS.DG.Tweening.Ease.InOutQuart)
    elseif x > max_x then
      tabTransform:DOMove(tabTransform.position + Vector3(max_x - x, 0, 0), 0.2):SetEase(CS.DG.Tweening.Ease.InOutQuart)
    end
  end
end

function LWSeason5RewardView:OnTabActive(tab)
  if not self.initFinish or self.tabActive == tab then
    return
  end
  DataCenter.LWSoundManager:PlaySound(1000103, false)
  local tempComp = self.tabActive and self.tabActive.content_ui or nil
  self.tabActive = tab
  if tab.assetPath and tab.class then
    local activityId = tab.activityId
    local cell = tab.content_ui
    if cell ~= nil and self.panelList[tab.index] then
      cell:SetActive(true)
      if tab.class.__cname == "LWSeasonPersonalReward" then
        local data = {}
        local panelData = {}
        panelData.type = SeasonScoreRewardPanelType.PersonalOccupyLand
        panelData.key = "393080"
        table.insert(data, panelData)
        cell:SetData(nil, data)
      else
        cell:SetData(tab.param)
      end
      self:ShowTabItemAnim()
      if tempComp then
        tempComp:SetActive(false)
      end
      return
    end
    self.panelList[tab.index] = self:GameObjectInstantiateAsync(tab.assetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      rectTransform:Set_offsetMin(0, 0)
      rectTransform:Set_offsetMax(0, 0)
      go.name = "tab_" .. tab.index
      local newCell = self.content:AddComponent(tab.class, go.name)
      if tab.class.__cname == "LWSeasonPersonalReward" then
        local data = {}
        local panelData = {}
        panelData.type = SeasonScoreRewardPanelType.PersonalOccupyLand
        panelData.key = "393080"
        table.insert(data, panelData)
        newCell:SetData(nil, data)
      else
        newCell:SetData(tab.param)
      end
      tab.content_ui = newCell
      if self.tabActive == tab then
        newCell:SetActive(true)
        self:ShowTabItemAnim()
        if tempComp then
          tempComp:SetActive(false)
        end
      else
        newCell:SetActive(false)
      end
    end)
  elseif tempComp then
    tempComp:SetActive(false)
  end
end

return LWSeason5RewardView
