local base = UIBaseContainer
local LWUIBerserkBossTotalPersonalDamageRankPage = BaseClass("LWUIBerserkBossTotalPersonalDamageRankPage", base)
local Localization = CS.GameEntry.Localization
local LWUIBerserkBossRankItemRender = require("UI.LWUIBerserkBossRank.Component.LWUIBerserkBossRankItemRender")
local LWUIBerserkBossRankTipsItemRender = require("UI.LWUIBerserkBossRank.Component.LWUIBerserkBossRankTipsItemRender")
local LWUIBerserkBossTopThreeRankItemRender = require("UI.LWUIBerserkBossRank.Component.LWUIBerserkBossTopThreeRankItemRender")
local LWUIBerserkBossRankRewardPreviewItemRender = require("UI.LWUIBerserkBossRank.Component.LWUIBerserkBossRankRewardPreviewItemRender")
local RankViewData = {des = "", personalRankInfo = nil}
local OneData = DataClass("OneData", RankViewData)
local rewardBtn_path = "RewardBtn"
local rewardBtnText_path = "RewardBtn/RewardBtnText"
local topOne_path = "TopOne"
local topTwo_path = "TopTwo"
local topThree_path = "TopThree"
local rankLoopListView_path = "RankScrollView"
local rankScrollContent_path = "RankScrollView/Viewport/RankScrollContent"
local rankRewardPreviewContent_path = "LWUIBerserkBossRankRewardPreviewContent"
local closeRankRewardPreviewBtn_path = "LWUIBerserkBossRankRewardPreviewContent"
local rankRewardContent_path = "LWUIBerserkBossRankRewardPreviewContent/Content/RankRewardPreviewContent"
local rankRewardObj_path = "LWUIBerserkBossRankRewardPreviewContent/Content/LWUIBerserkBossRankRewardPreviewItemRender"
local rankRewardTipsText_path = "LWUIBerserkBossRankRewardPreviewContent/Content/RankRewardTipsText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearRankLoopView()
  self:ClearRankRewardCell()
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
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.rewardBtnText = self:AddComponent(UIText, rewardBtnText_path)
  self.topOne = self:AddComponent(UIBaseContainer, topOne_path)
  self.topTwo = self:AddComponent(UIBaseContainer, topTwo_path)
  self.topThree = self:AddComponent(UIBaseContainer, topThree_path)
  self.rankLoopListView = self:AddComponent(UILoopListView2, rankLoopListView_path)
  self.rankScrollContent = self:AddComponent(UIBaseContainer, rankScrollContent_path)
  self.rankRewardPreviewContent = self:AddComponent(UIBaseContainer, rankRewardPreviewContent_path)
  self.closeRankRewardPreviewBtn = self:AddComponent(UIButton, closeRankRewardPreviewBtn_path)
  self.rankRewardContent = self:AddComponent(UIBaseContainer, rankRewardContent_path)
  self.rankRewardObj = self:AddComponent(UIBaseContainer, rankRewardObj_path)
  self.rankRewardTipsText = self:AddComponent(UIText, rankRewardTipsText_path)
  self.rewardBtnText:SetLocalText("456066")
  self.rewardBtn:SetOnClick(function()
    self:RewardBtnClick()
  end)
  self.topThreeRankItemViews = {
    self:AddComponent(LWUIBerserkBossTopThreeRankItemRender, topOne_path),
    self:AddComponent(LWUIBerserkBossTopThreeRankItemRender, topTwo_path),
    self:AddComponent(LWUIBerserkBossTopThreeRankItemRender, topThree_path)
  }
  self.rankLoopListView:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
  self.rankRewardTipsText:SetLocalText("activity_berserkboss_title_13")
  self.rankRewardPreviewContent:SetActive(false)
  self.rankRewardItem = self.transform:Find(rankRewardObj_path).gameObject
  self.rankRewardItem:GameObjectCreatePool()
  self.closeRankRewardPreviewBtn:SetOnClick(function()
    self.rankRewardPreviewContent:SetActive(false)
  end)
end

local function ComponentDestroy(self)
  self.rewardBtn = nil
  self.rewardBtnText = nil
  self.topOne = nil
  self.topTwo = nil
  self.topThree = nil
  self.rankLoopListView = nil
  self.rankScrollContent = nil
  self.rankRewardPreviewContent = nil
  self.closeRankRewardPreviewBtn = nil
  self.rankRewardContent = nil
  self.rankRewardObj = nil
  self.rankRewardTipsText = nil
  self.rankRewardItem = nil
end

local function DataDefine(self)
  self.rankViewList = {}
end

local function DataDestroy(self)
  self.rankViewList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetBerserkBossRankRewardInfoData, self.OnGetBerserkBossRankRewardInfoData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetBerserkBossRankRewardInfoData, self.OnGetBerserkBossRankRewardInfoData)
  base.OnRemoveListener(self)
end

local function OnGetBerserkBossRankRewardInfoData(self)
  if self.rankRewardPreviewContent and self.rankRewardPreviewContent:GetActive() then
    self:ShowRankRewardPreview()
  end
end

local function RefreshViewData(self, rankDataDict, isPlayRankAni)
  local rankDataListCount = table.count(rankDataDict)
  for i = 1, table.count(self.topThreeRankItemViews) do
    if i <= rankDataListCount then
      local rankData = rankDataDict[i]
      self.topThreeRankItemViews[i]:InitData(i, rankData, isPlayRankAni)
    else
      self.topThreeRankItemViews[i]:InitData(i, nil, isPlayRankAni)
    end
  end
  self.rankViewList = {}
  if 4 <= rankDataListCount then
    for rank, personalRankInfo in pairs(rankDataDict) do
      if 4 <= rank then
        if rank == 4 then
          local oneData = OneData.New()
          oneData.des = Localization:GetString("activity_berserkboss_title_14", "4-10")
          table.insert(self.rankViewList, oneData)
        end
        if rank == 11 then
          local oneData = OneData.New()
          oneData.des = Localization:GetString("activity_berserkboss_title_14", "11-50")
          table.insert(self.rankViewList, oneData)
        end
        if rank == 51 then
          local oneData = OneData.New()
          oneData.des = Localization:GetString("activity_berserkboss_title_14", "51-100")
          table.insert(self.rankViewList, oneData)
        end
        local rankInfoData = OneData.New()
        rankInfoData.personalRankInfo = personalRankInfo
        table.insert(self.rankViewList, rankInfoData)
      end
    end
  end
  local showCount = table.count(self.rankViewList)
  if 0 < showCount then
    self.rankLoopListView:SetListItemCount(showCount, false, false)
    self.rankLoopListView:RefreshAllShownItem()
  end
end

local function OnGetItemByIndex(self, listView, index)
  local count = table.count(self.rankViewList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local prefabName = self:GetPrefabName(index)
  if prefabName == "" then
    return nil
  end
  local item = listView:NewListViewItem(prefabName)
  local scriptName = self:GetItemScriptName(index)
  local script = self.rankScrollContent:GetComponent(item.gameObject.name, scriptName)
  if script == nil then
    NameCount = NameCount + 1
    local objName = "item_" .. tostring(NameCount)
    item.gameObject.name = objName
    script = self.rankScrollContent:AddComponent(scriptName, item.gameObject.name)
  end
  script:SetActive(true)
  local rankViewData = self.rankViewList[index]
  if rankViewData.personalRankInfo ~= nil then
    script:InitData(LWUIBerserkBossRankType.Personal, rankViewData.personalRankInfo, LWUIBerserkBossRankTabType.TotalPersonalDamage)
  else
    script:InitData(rankViewData.des)
  end
  return item
end

local function ClearRankLoopView(self)
  self.rankScrollContent:RemoveComponents(LWUIBerserkBossRankItemRender)
  self.rankScrollContent:RemoveComponents(LWUIBerserkBossRankTipsItemRender)
  self.rankLoopListView:ClearAllItems()
end

local function GetPrefabName(self, index)
  local rankViewData = self.rankViewList[index]
  if rankViewData ~= nil then
    if rankViewData.personalRankInfo ~= nil then
      return "LWUIBerserkBossRankItemRender"
    else
      return "LWUIBerserkBossRankTipsItemRender"
    end
  end
  return ""
end

local function GetItemScriptName(self, index)
  local rankViewData = self.rankViewList[index]
  if rankViewData ~= nil then
    if rankViewData.personalRankInfo ~= nil then
      return LWUIBerserkBossRankItemRender
    else
      return LWUIBerserkBossRankTipsItemRender
    end
  end
  return ""
end

local function ShowRankRewardPreview(self)
  self:ClearRankRewardCell()
  local selfCurRank = 0
  local selfRankInfo = DataCenter.LWBerserkBossManager:GetSelfRankInfo()
  if selfRankInfo ~= nil then
    selfCurRank = selfRankInfo.rank
  end
  local rankRewardList = DataCenter.LWBerserkBossManager:GetBerserkBossRankRewardData()
  local count = table.count(rankRewardList)
  for i = 1, count do
    local go = self.rankRewardItem:GameObjectSpawn(self.rankRewardContent.transform)
    go.name = "item_" .. i
    go:SetActive(true)
    local itemRender = self.rankRewardContent:AddComponent(LWUIBerserkBossRankRewardPreviewItemRender, go.name)
    itemRender:InitData(rankRewardList[i], selfCurRank)
  end
end

local function ClearRankRewardCell(self)
  self.rankRewardContent:RemoveComponents(LWUIBerserkBossRankRewardPreviewItemRender)
  self.rankRewardItem:GameObjectRecycleAll()
end

local function RewardBtnClick(self)
  self.rankRewardPreviewContent:SetActive(true)
  DataCenter.LWBerserkBossManager:RequestBerserkBossRankRewardInfo()
  self:ShowRankRewardPreview()
end

LWUIBerserkBossTotalPersonalDamageRankPage.OnCreate = OnCreate
LWUIBerserkBossTotalPersonalDamageRankPage.OnDestroy = OnDestroy
LWUIBerserkBossTotalPersonalDamageRankPage.OnEnable = OnEnable
LWUIBerserkBossTotalPersonalDamageRankPage.OnDisable = OnDisable
LWUIBerserkBossTotalPersonalDamageRankPage.ComponentDefine = ComponentDefine
LWUIBerserkBossTotalPersonalDamageRankPage.ComponentDestroy = ComponentDestroy
LWUIBerserkBossTotalPersonalDamageRankPage.DataDefine = DataDefine
LWUIBerserkBossTotalPersonalDamageRankPage.DataDestroy = DataDestroy
LWUIBerserkBossTotalPersonalDamageRankPage.OnAddListener = OnAddListener
LWUIBerserkBossTotalPersonalDamageRankPage.OnRemoveListener = OnRemoveListener
LWUIBerserkBossTotalPersonalDamageRankPage.RefreshViewData = RefreshViewData
LWUIBerserkBossTotalPersonalDamageRankPage.RewardBtnClick = RewardBtnClick
LWUIBerserkBossTotalPersonalDamageRankPage.OnGetItemByIndex = OnGetItemByIndex
LWUIBerserkBossTotalPersonalDamageRankPage.GetPrefabName = GetPrefabName
LWUIBerserkBossTotalPersonalDamageRankPage.GetItemScriptName = GetItemScriptName
LWUIBerserkBossTotalPersonalDamageRankPage.ShowRankRewardPreview = ShowRankRewardPreview
LWUIBerserkBossTotalPersonalDamageRankPage.ClearRankRewardCell = ClearRankRewardCell
LWUIBerserkBossTotalPersonalDamageRankPage.OnGetBerserkBossRankRewardInfoData = OnGetBerserkBossRankRewardInfoData
LWUIBerserkBossTotalPersonalDamageRankPage.ClearRankLoopView = ClearRankLoopView
return LWUIBerserkBossTotalPersonalDamageRankPage
