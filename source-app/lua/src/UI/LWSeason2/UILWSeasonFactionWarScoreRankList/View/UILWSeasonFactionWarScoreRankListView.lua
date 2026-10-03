local UILWSeasonFactionWarScoreRankListView = BaseClass("UILWSeasonFactionWarScoreRankListView", UIBaseView)
local base = UIBaseView
local theHistoryData
local RankListItem = require("UI.LWSeason2.UILWSeasonFactionWarScoreRankList.Component.UILWSeasonFactionWarScoreRankListItem")
local btn_back_white_path = "safeArea/BottomBar/BtnBackWhite"
local scroll_view_path = "safeArea/panelContainer/ScrollView"
local rank_item_path = "safeArea/panelContainer/RankItem"
local show_my_btn_path = "safeArea/BottomBar/txt/ShowMyBtn"
local checkbox_path = "safeArea/BottomBar/txt/checkbox"

function UILWSeasonFactionWarScoreRankListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  if theHistoryData then
    self:OnScoreRankData(theHistoryData)
  end
  SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionBattleUserScoreRank)
end

function UILWSeasonFactionWarScoreRankListView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonFactionWarScoreRankListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionBattleScoreRank, self.OnScoreRankData)
end

function UILWSeasonFactionWarScoreRankListView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionBattleScoreRank, self.OnScoreRankData)
  base.OnRemoveListener(self)
end

function UILWSeasonFactionWarScoreRankListView:ComponentDefine()
  self.btn_back_white = self:AddComponent(UIButton, btn_back_white_path)
  self.btn_back_white:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.rank_item = self:AddComponent(RankListItem, rank_item_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.checkbox = self:AddComponent(UIToggle, checkbox_path)
  self.rank_item:SetActive(false)
  self.show_my_btn = self:AddComponent(UIButton, show_my_btn_path)
  self.show_my_btn:SetOnClick(function()
    local status = self.checkbox:GetIsOn()
    self.checkbox:SetIsOn(not status)
    self.justShowMyAlliance = not status
    self:OnScoreRankData(theHistoryData)
  end)
  self.checkbox:SetIsOn(false)
  self.justShowMyAlliance = false
end

function UILWSeasonFactionWarScoreRankListView:ComponentDestroy()
  self:ClearScroll()
  self.btn_back_white = nil
  self.rank_item = nil
  self.ScrollView = nil
  self.show_my_btn = nil
  self.checkbox = nil
end

function UILWSeasonFactionWarScoreRankListView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(RankListItem, itemObj)
  if cellItem ~= nil then
    local data = self.rankList[index]
    cellItem:ReInit(data.rank, data.score, false, data)
  end
end

function UILWSeasonFactionWarScoreRankListView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RankListItem)
end

function UILWSeasonFactionWarScoreRankListView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RankListItem)
end

function UILWSeasonFactionWarScoreRankListView:OnScoreRankData(data)
  if data and theHistoryData ~= data then
    theHistoryData = data
  end
  if data and data.list and #data.list > 0 then
    if self.justShowMyAlliance then
      local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      local dataList = {}
      local myAbbr
      if allianceData then
        myAbbr = allianceData.abbr
      end
      for k, v in ipairs(data.list) do
        if v.abbr == myAbbr then
          table.insert(dataList, v)
        end
      end
      if #dataList == 0 then
        self:ClearScroll()
        return
      end
      self.rankList = dataList
    else
      self.rankList = data.list
    end
    table.sort(self.rankList, function(a, b)
      return a.rank < b.rank
    end)
    self.ScrollView:SetTotalCount(#self.rankList)
    self.ScrollView:RefillCells()
  end
  if data and data.self then
    self.rank_item:SetActive(true)
    self.rank_item:ReInit(data.self.rank, data.self.score, true, LuaEntry.Player)
  else
    self.rank_item:SetActive(false)
  end
end

return UILWSeasonFactionWarScoreRankListView
