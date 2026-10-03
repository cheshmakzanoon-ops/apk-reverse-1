local UIAttackCityS0RecordDetailPopView = BaseClass("UIAttackCityS0RecordDetailPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIAttackCityS0RankWinner = require("UI.LWCityAttackS0.RankList.Component.UIAttackCityS0RankWinner")
local UIAttackCityS0RankViewItem = require("UI.LWCityAttackS0.RankList.Component.UIAttackCityS0RankViewItem")
local AllianceVSComponent = require("UI.LWCityAttackS0.RankList.Component.AllianceVSComponent")
local bg_path = "panel"
local txt_title_path = "panel/bg/txtTitle"
local close_btn_path = "panel/bg/CloseBtn"
local gold_path = "panel/bg/winners/gold"
local silver_path = "panel/bg/winners/silver"
local bronze_path = "panel/bg/winners/bronze"
local scroll_rank_path = "panel/bg/scrollRank"
local self_rank_path = "panel/bg/selfRank"
local empty_tip_path = "panel/bg/emptyTip"
local alliance_path = "panel/bg/rectAlliance"

function UIAttackCityS0RecordDetailPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIAttackCityS0RecordDetailPopView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0RecordDetailPopView:ComponentDefine()
  self.activityId = self:GetUserData() or 0
  self.bg = self:AddComponent(UIButton, bg_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.txt_title:SetText(Localization:GetString("activity_breakthrough_tips_3"))
  self.bg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.gold = self:AddComponent(UIAttackCityS0RankWinner, gold_path)
  self.silver = self:AddComponent(UIAttackCityS0RankWinner, silver_path)
  self.bronze = self:AddComponent(UIAttackCityS0RankWinner, bronze_path)
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
  self.self_rank = self:AddComponent(UIAttackCityS0RankViewItem, self_rank_path)
  self.empty_tip = self:AddComponent(UITextMeshProUGUIEx, empty_tip_path)
  self.empty_tip:SetActive(false)
  self.allianceComp = self:AddComponent(AllianceVSComponent, alliance_path)
end

function UIAttackCityS0RecordDetailPopView:OnItemCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scroll_rank:AddComponent(UIAttackCityS0RankViewItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local rankData = self.rankDatas[index]
  item:Refresh(rankData)
end

function UIAttackCityS0RecordDetailPopView:OnItemDeleteCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if item then
    self.scroll_rank:RemoveComponent(itemObj)
  end
end

function UIAttackCityS0RecordDetailPopView:DataDefine()
end

function UIAttackCityS0RecordDetailPopView:ComponentDestroy()
  self.scroll_rank:ClearCells()
  self.scroll_rank:RemoveComponents(UIAttackCityS0RankViewItem)
  self.scrollCellPool = {}
  self.bg = nil
  self.txt_title = nil
  self.close_btn = nil
  self.gold = nil
  self.silver = nil
  self.bronze = nil
  self.scroll_rank = nil
  self.self_rank = nil
  self.empty_tip = nil
  self.allianceComp = nil
end

function UIAttackCityS0RecordDetailPopView:DataDestroy()
  self.rankDatas = nil
  self.rankList = nil
  self.rankInfo = nil
end

function UIAttackCityS0RecordDetailPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AttackCityRankDetailList, self.UpdateData)
  self:AddUIListener(EventId.AttackCityThumbsUpRewardRefresh, self.UpdateData)
end

function UIAttackCityS0RecordDetailPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.AttackCityRankDetailList, self.UpdateData)
  self:RemoveUIListener(EventId.AttackCityThumbsUpRewardRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIAttackCityS0RecordDetailPopView:ReInit()
  self.cityId = self:GetUserData()
  DataCenter.AttackCityS0DataManager:GetAllianceRankDetailMsg(self.cityId)
end

function UIAttackCityS0RecordDetailPopView:UpdateData()
  self.rankInfo = DataCenter.AttackCityS0DataManager:GetAllianceRankDetailInfo(self.cityId)
  self:Refresh()
end

function UIAttackCityS0RecordDetailPopView:Refresh()
  if self.rankInfo == nil then
    return
  end
  self.rankList = self.rankInfo.rankList
  self.allianceComp:Refresh(self.cityId, self.rankInfo.selfAllianceInfo, self.rankInfo.targetAllianceInfo, self.rankInfo.battleResult)
  local count = 0
  if not self.rankList or #self.rankList == 0 then
    for i, v in ipairs(self.winnerComps) do
      v:SetActive(false)
    end
    self.empty_tip:SetActive(true)
    self.empty_tip:SetText(Localization:GetString("activity_breakthrough_tips_34"))
    self.scroll_rank:SetActive(false)
  else
    self.empty_tip:SetActive(false)
    count = #self.rankList
    local rankList = self.rankList
    for i = 1, 3 do
      local data = rankList[i]
      if data then
        self.winnerComps[i]:SetActive(true)
        self.winnerComps[i]:Refresh(data, self.cityId)
      else
        self.winnerComps[i]:SetActive(false)
      end
    end
    self.rankDatas = {}
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
  if self.rankInfo and self.rankInfo.selfRank then
    local selfData = self.rankInfo.selfRank
    local selfRank = -1
    local selfScore = 0
    if selfData then
      selfRank = selfData.rank or -1
      selfScore = selfData.score or 0
    end
    self.self_rank:RefreshSelf(selfRank, selfScore, selfData)
    self.self_rank:SetActive(true)
  end
end

return UIAttackCityS0RecordDetailPopView
