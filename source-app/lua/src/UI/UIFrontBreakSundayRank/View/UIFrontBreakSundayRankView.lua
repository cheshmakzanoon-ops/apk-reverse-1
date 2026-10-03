local UIFrontBreakSundayRankView = BaseClass("UIFrontBreakSundayRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIFrontBreakSundayRankWinner = require("UI.UIFrontBreakSundayRank.Component.UIFrontBreakSundayRankWinner")
local UIFrontBreakSundayRankViewItem = require("UI.UIFrontBreakSundayRank.Component.UIFrontBreakSundayRankViewItem")
local bg_path = "panel"
local txt_title_path = "panel/bg/txtTitle"
local close_btn_path = "panel/bg/CloseBtn"
local tab_top_off_path = "panel/bg/tabs/tabTop/tabTop_off"
local txt_tab_top_off_path = "panel/bg/tabs/tabTop/tabTop_off/txtTabTop_off"
local tab_top_on_path = "panel/bg/tabs/tabTop/tabTop_on"
local txt_tab_top_on_path = "panel/bg/tabs/tabTop/tabTop_on/txtTabTop_on"
local tab_alliance_off_path = "panel/bg/tabs/tabAlliance/tabAlliance_off"
local txt_tab_alliance_off_path = "panel/bg/tabs/tabAlliance/tabAlliance_off/txtTabAlliance_off"
local tab_alliance_on_path = "panel/bg/tabs/tabAlliance/tabAlliance_on"
local txt_tab_alliance_on_path = "panel/bg/tabs/tabAlliance/tabAlliance_on/txtTabAlliance_on"
local tab_server_off_path = "panel/bg/tabs/tabServer/tabServer_off"
local txt_tab_server_off_path = "panel/bg/tabs/tabServer/tabServer_off/txtTabServer_off"
local tab_server_on_path = "panel/bg/tabs/tabServer/tabServer_on"
local txt_tab_server_on_path = "panel/bg/tabs/tabServer/tabServer_on/txtTabServer_on"
local gold_path = "panel/bg/winners/gold"
local silver_path = "panel/bg/winners/silver"
local bronze_path = "panel/bg/winners/bronze"
local scroll_rank_path = "panel/bg/scrollRank"
local self_rank_path = "panel/bg/selfRank"
local empty_tip_path = "panel/bg/emptyTip"
local gift_btn_path = "panel/bg/winners/GiftBtn"
local gift_btn_label_path = "panel/bg/winners/GiftBtn/GiftLabel"
local rank_Criteria_label_path = "panel/bg/winners/RankCriteriaLabel"
local rank_Criteria_content_path = "panel/bg/winners/RankCriteria"
local rank_Criteria_stage_label_path = "panel/bg/winners/RankCriteria/CriteriaStageLabel"
local rank_Criteria_solider_label_path = "panel/bg/winners/RankCriteria/CriteriaRemainSolider"
local RankType = {
  ServerRank = 1,
  AllianceRank = 2,
  TopRank = 3
}

function UIFrontBreakSundayRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIFrontBreakSundayRankView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIFrontBreakSundayRankView:ComponentDefine()
  self.activityId = self:GetUserData() or 0
  self.bg = self:AddComponent(UIButton, bg_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.tab_top_off = self:AddComponent(UIButton, tab_top_off_path)
  self.txt_tab_top_off = self:AddComponent(UITextMeshProUGUIEx, txt_tab_top_off_path)
  self.tab_top_on = self:AddComponent(UIImage, tab_top_on_path)
  self.txt_tab_top_on = self:AddComponent(UITextMeshProUGUIEx, txt_tab_top_on_path)
  self.tab_alliance_off = self:AddComponent(UIButton, tab_alliance_off_path)
  self.txt_tab_alliance_off = self:AddComponent(UITextMeshProUGUIEx, txt_tab_alliance_off_path)
  self.tab_alliance_on = self:AddComponent(UIImage, tab_alliance_on_path)
  self.txt_tab_alliance_on = self:AddComponent(UITextMeshProUGUIEx, txt_tab_alliance_on_path)
  self.tab_server_off = self:AddComponent(UIButton, tab_server_off_path)
  self.txt_tab_server_off = self:AddComponent(UITextMeshProUGUIEx, txt_tab_server_off_path)
  self.tab_server_on = self:AddComponent(UIImage, tab_server_on_path)
  self.txt_tab_server_on = self:AddComponent(UITextMeshProUGUIEx, txt_tab_server_on_path)
  self.txt_title:SetText(Localization:GetString("activity_breakthrough_tips_3"))
  local alncTabKey = Localization:GetString("activity_breakthrough_tips_13")
  self.txt_tab_alliance_off:SetText(alncTabKey)
  self.txt_tab_alliance_on:SetText(alncTabKey)
  local serverTabKey = Localization:GetString("activity_breakthrough_tips_14")
  self.txt_tab_server_off:SetText(serverTabKey)
  self.txt_tab_server_on:SetText(serverTabKey)
  local topTabKey = Localization:GetString("activity_breakthrough_tips_37")
  self.txt_tab_top_off:SetText(topTabKey)
  self.txt_tab_top_on:SetText(topTabKey)
  self.tab_alliance_off:SetOnClick(function()
    self:SwitchTab(RankType.AllianceRank)
  end)
  self.tab_server_off:SetOnClick(function()
    self:SwitchTab(RankType.ServerRank)
  end)
  self.tab_top_off:SetOnClick(function()
    self:SwitchTab(RankType.TopRank)
  end)
  self.tabsOn = {
    [RankType.AllianceRank] = self.tab_alliance_on,
    [RankType.ServerRank] = self.tab_server_on,
    [RankType.TopRank] = self.tab_top_on
  }
  self.tabsOff = {
    [RankType.AllianceRank] = self.tab_alliance_off,
    [RankType.ServerRank] = self.tab_server_off,
    [RankType.TopRank] = self.tab_top_off
  }
  self.bg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.gold = self:AddComponent(UIFrontBreakSundayRankWinner, gold_path)
  self.silver = self:AddComponent(UIFrontBreakSundayRankWinner, silver_path)
  self.bronze = self:AddComponent(UIFrontBreakSundayRankWinner, bronze_path)
  self.winnerComps = {
    self.gold,
    self.silver,
    self.bronze
  }
  self.scroll_rank = self:AddComponent(UIScrollView, scroll_rank_path)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scroll_rank:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemCreateCell(itemObj, index)
  end)
  self.scroll_rank:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemDeleteCell(itemObj, index)
  end)
  self.self_rank = self:AddComponent(UIFrontBreakSundayRankViewItem, self_rank_path)
  self.empty_tip = self:AddComponent(UITextMeshProUGUIEx, empty_tip_path)
  self.empty_tip:SetActive(false)
  self.giftBtn = self:AddComponent(UIButton, gift_btn_path)
  self.giftBtn:SetOnClick(function()
    local type = self.curTab and self.curTab - 1 or 0
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFrontBreakSundayRankReward, {anim = true}, type)
  end)
  self.giftBtnLabel = self:AddComponent(UITextMeshProUGUIEx, gift_btn_label_path)
  self.giftBtnLabel:SetLocalText("activity_breakthrough_tips_39")
  self.rankCriteriaLabel = self:AddComponent(UITextMeshProUGUIEx, rank_Criteria_label_path)
  self.rankCriteriaLabel:SetLocalText("activity_breakthrough_tips_38")
  self.rankCriteriaContent = self:AddComponent(UIBaseContainer, rank_Criteria_content_path)
  local criteriaStage = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaStage(self.activityId)
  self.rankCriteriaStageLabel = self:AddComponent(UITextMeshProUGUIEx, rank_Criteria_stage_label_path)
  self.rankCriteriaStageLabel:SetLocalText("activity_breakthrough_tips_15", criteriaStage)
  local criteriaRemainSolider = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaRemainSolider(self.activityId)
  self.rankCriteriaRemainSoliderLabel = self:AddComponent(UITextMeshProUGUIEx, rank_Criteria_solider_label_path)
  self.rankCriteriaRemainSoliderLabel:SetText(string.format("x%d", criteriaRemainSolider))
  self:SwitchTab(RankType.AllianceRank)
end

function UIFrontBreakSundayRankView:OnItemCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scroll_rank:AddComponent(UIFrontBreakSundayRankViewItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local rankData = self.rankDatas[index]
  item:Refresh(rankData, self.curTab, #self.rankDatas)
end

function UIFrontBreakSundayRankView:OnItemDeleteCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if item then
    self.scroll_rank:RemoveComponent(itemObj)
  end
end

function UIFrontBreakSundayRankView:DataDefine()
end

function UIFrontBreakSundayRankView:ComponentDestroy()
  self.scroll_rank:ClearCells()
  self.scroll_rank:RemoveComponents(UIFrontBreakSundayRankViewItem)
  self.scrollCellPool = {}
  self.bg = nil
  self.txt_title = nil
  self.close_btn = nil
  self.tab_top_off = nil
  self.txt_tab_top_off = nil
  self.tab_top_on = nil
  self.txt_tab_top_on = nil
  self.tab_alliance_off = nil
  self.txt_tab_alliance_off = nil
  self.tab_alliance_on = nil
  self.txt_tab_alliance_on = nil
  self.tab_server_off = nil
  self.txt_tab_server_off = nil
  self.tab_server_on = nil
  self.txt_tab_server_on = nil
  self.rankCriteriaLabel = nil
  self.rankCriteriaStageLabel = nil
  self.rankCriteriaRemainSoliderLabel = nil
  self.rankCriteriaContent = nil
  self.gold = nil
  self.silver = nil
  self.bronze = nil
  self.scroll_rank = nil
  self.self_rank = nil
  self.empty_tip = nil
end

function UIFrontBreakSundayRankView:DataDestroy()
end

function UIFrontBreakSundayRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FrontBreakSundayGetRank, self.OnFrontBreakSundayRankGetRank)
end

function UIFrontBreakSundayRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.FrontBreakSundayGetRank, self.OnFrontBreakSundayRankGetRank)
  base.OnRemoveListener(self)
end

function UIFrontBreakSundayRankView:ReInit()
end

function UIFrontBreakSundayRankView:SwitchTab(type)
  if self.curTab == type then
    return
  end
  self.curTab = type
  for k, v in pairs(self.tabsOn) do
    v:SetActive(k == type)
  end
  for k, v in pairs(self.tabsOff) do
    v:SetActive(k ~= type)
  end
  self.giftBtn:SetActive(self.curTab ~= RankType.AllianceRank)
  self.rankCriteriaLabel:SetActive(self.curTab == RankType.TopRank)
  self.rankCriteriaContent:SetActive(self.curTab == RankType.TopRank)
  self:RefreshView()
end

function UIFrontBreakSundayRankView:RefreshView()
  if self.curTab == RankType.AllianceRank and not LuaEntry.Player:IsInAlliance() then
    self.empty_tip:SetText(Localization:GetString("multiply_door_tips_027"))
    self.empty_tip:SetActive(true)
    for i, v in ipairs(self.winnerComps) do
      v:SetActive(false)
    end
    self.self_rank:SetActive(false)
    self.scroll_rank:SetActive(false)
    return
  end
  local totalCount = 100
  local requestCode = 0
  if self.curTab == RankType.AllianceRank then
    requestCode = 1
  elseif self.curTab == RankType.ServerRank then
    requestCode = 0
  elseif self.curTab == RankType.TopRank then
    requestCode = 2
    totalCount = 1000
  end
  SFSNetwork.SendMessage(MsgDefines.FrontBreakSundayGetRankInfo, requestCode, 1, totalCount)
end

function UIFrontBreakSundayRankView:OnFrontBreakSundayRankGetRank(info)
  if not info then
    return
  end
  self:Refresh(info)
end

function UIFrontBreakSundayRankView:Refresh(info)
  local count = 0
  if not (info and info.ranks) or #info.ranks == 0 then
    for i, v in ipairs(self.winnerComps) do
      v:SetActive(false)
    end
    self.empty_tip:SetActive(true)
    self.empty_tip:SetText(Localization:GetString("activity_breakthrough_tips_34"))
    self.scroll_rank:SetActive(false)
  else
    self.empty_tip:SetActive(false)
    self.rankDatas = {}
    count = #info.ranks
    local rankList = info.ranks
    for i = 1, 3 do
      local data = rankList[i]
      if data then
        self.winnerComps[i]:SetActive(true)
        self.winnerComps[i]:Refresh(data, self.curTab)
      else
        self.winnerComps[i]:SetActive(false)
      end
    end
    for i = 4, count do
      table.insert(self.rankDatas, rankList[i])
    end
    local rankCount = #self.rankDatas
    if 0 < rankCount then
      self.scroll_rank:SetActive(true)
      self.scroll_rank:SetTotalCount(rankCount)
      self.scroll_rank:RefillCells()
    else
      self.scroll_rank:SetActive(false)
    end
  end
  if info and info.self then
    local selfData = info.self
    local selfRank = -1
    local selfScore = 0
    if selfData then
      selfRank = selfData.rank or -1
      selfScore = selfData.score or 0
    end
    self.self_rank:RefreshSelf(selfRank, selfScore, self.curTab, count)
    self.self_rank:SetActive(true)
  end
end

return UIFrontBreakSundayRankView
