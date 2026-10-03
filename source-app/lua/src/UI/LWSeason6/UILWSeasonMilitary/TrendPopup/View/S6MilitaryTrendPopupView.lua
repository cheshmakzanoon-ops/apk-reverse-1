local UILWSeasonMilitaryTrendPopupCell = require("UI.LWSeason6.UILWSeasonMilitary.TrendPopup.Comp.UILWSeasonMilitaryTrendPopupCell")
local base = UIBaseView
local S6MilitaryTrendPopupView = BaseClass("S6MilitaryTrendPopupView", UIBaseView)

function S6MilitaryTrendPopupView:ComponentDefine()
  local u_i_common_black_mask_path = "UICommonBlackMask"
  local close_btn_path = "PanelRoot/CloseBtn"
  local p_text_time_path = "PanelRoot/p_text_time"
  local p_text_desc_path = "PanelRoot/ContentScroll/Viewport/p_text_desc"
  local p_scroll_view_path = "PanelRoot/Content/content_rank/p_list_view"
  local p_comp_cur_path = "PanelRoot/Content/content_rank/p_comp_cur"
  local p_text_empty_path = "PanelRoot/Content/p_text_empty"
  self.u_i_common_black_mask = self:AddComponent(UIButton, u_i_common_black_mask_path)
  self.u_i_common_black_mask:SetOnClick(BindCallback(self, self.OnBlankClicked))
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_time = self:AddComponent(UITextMeshProUGUIEx, p_text_time_path)
  self.p_text_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_desc_path)
  self.p_scroll_view = self:AddComponent(UILoopListViewSimple, p_scroll_view_path)
  self.p_comp_cur = self:AddComponent(UILWSeasonMilitaryTrendPopupCell, p_comp_cur_path)
  self.p_text_empty = self:AddComponent(UITextMeshProUGUIEx, p_text_empty_path)
end

function S6MilitaryTrendPopupView:ComponentDestroy()
  self.u_i_common_black_mask = nil
  self.close_btn = nil
  self.p_text_time = nil
  self.p_text_desc = nil
  self.p_scroll_view = nil
  self.p_comp_cur = nil
  self.p_text_empty = nil
end

function S6MilitaryTrendPopupView:DataDefine()
  self.RankType = DataCenter.SeasonMilitaryEliteManager.RankType.Person_All
  self.PeriodType = DataCenter.SeasonMilitaryEliteManager.PeriodType.Total
  self.RankMode = DataCenter.SeasonMilitaryEliteManager.RankMode.Full
end

function S6MilitaryTrendPopupView:DataDestroy()
  self.Data = nil
end

function S6MilitaryTrendPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function S6MilitaryTrendPopupView:OnDestroy()
  DataCenter.SeasonMilitaryManager:ClearTrendSettlementCache()
  DataCenter.SeasonMilitaryEliteManager:ClearRankData()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6MilitaryTrendPopupView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMilitaryEliteRankUpdate, self.OnRankUpdate)
  self:AddUIListener(EventId.SeasonMilitaryTrendSettlementUpdate, self.OnSettlementUpdate)
end

function S6MilitaryTrendPopupView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMilitaryEliteRankUpdate, self.OnRankUpdate)
  self:RemoveUIListener(EventId.SeasonMilitaryTrendSettlementUpdate, self.OnSettlementUpdate)
  base.OnRemoveListener(self)
end

function S6MilitaryTrendPopupView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
  end
end

function S6MilitaryTrendPopupView:InitData(data)
  self.OpenTime = UITimeManager:GetInstance():GetServerTime()
  return true
end

function S6MilitaryTrendPopupView:InitUi()
  self.p_scroll_view:Init(UILWSeasonMilitaryTrendPopupCell)
  self.p_scroll_view:Clear()
  self.p_scroll_view:SetActive(false)
  self.p_comp_cur:SetActive(false)
  self.p_text_empty:SetActive(true)
end

function S6MilitaryTrendPopupView:UpdateData()
  self.TrendState = DataCenter.SeasonMilitaryManager:GetTrendSettlementState()
  self.TickAct = self.TrendState == DataCenter.SeasonMilitaryManager.TrendSettlementState.Rank
  return true
end

function S6MilitaryTrendPopupView:UpdateUi()
  self.p_scroll_view:SetActive(false)
  self.p_comp_cur:SetActive(false)
  self.p_text_empty:SetActive(true)
  if self.TrendState == DataCenter.SeasonMilitaryManager.TrendSettlementState.Rank then
    self.p_text_desc:SetLocalText("season_military_sp_reward_desc_1")
    self.EndTime = DataCenter.SeasonMilitaryManager:GetTrendSettlementTime()
    if self:UpdateRankData() then
      self:UpdateRankUi()
    else
      DataCenter.SeasonMilitaryEliteManager:SendGetRank(self.RankType, self.PeriodType, self.RankMode, true)
    end
  elseif self.TrendState == DataCenter.SeasonMilitaryManager.TrendSettlementState.Settlement then
    self.p_text_time:SetLocalText("season_military_sp_reward_time_2")
    self.p_text_desc:SetLocalText("season_military_sp_reward_desc_2")
    if self:UpdateResultData() then
      self:UpdateRankUi()
    else
      DataCenter.SeasonMilitaryManager:SendGetTrendSettlement()
    end
  end
end

function S6MilitaryTrendPopupView:UpdateRankData()
  local rankPayload = DataCenter.SeasonMilitaryEliteManager:GetCacheRankData(self.RankType, self.PeriodType, self.RankMode)
  self.RankList = self.ctrl:GetRankList(rankPayload)
  return not table.IsNullOrEmpty(self.RankList)
end

function S6MilitaryTrendPopupView:UpdateRankUi()
  self.p_scroll_view:Clear()
  if not table.IsNullOrEmpty(self.RankList) then
    self.p_scroll_view:SetActive(true)
    self.p_text_empty:SetActive(false)
    local selfData
    for _, rankData in pairs(self.RankList) do
      if rankData.Uid == LuaEntry.Player.uid then
        rankData.IsSelf = true
        selfData = DeepCopy(rankData)
      end
      self.p_scroll_view:AddData(rankData)
    end
    self.p_scroll_view:Show()
    if selfData ~= nil then
      selfData.IsSelf = true
      self.p_comp_cur:SetActive(true)
      self.p_comp_cur:ReInit(selfData)
    else
      self.p_comp_cur:SetActive(false)
    end
  else
    self.p_scroll_view:SetActive(false)
    self.p_comp_cur:SetActive(false)
    self.p_text_empty:SetActive(true)
  end
end

function S6MilitaryTrendPopupView:UpdateResultData()
  local resultPayload = DataCenter.SeasonMilitaryManager:GetCacheTrendSettlementData()
  self.RankList = self.ctrl:GetSettlementRankList(resultPayload)
  return not table.IsNullOrEmpty(self.RankList)
end

function S6MilitaryTrendPopupView:UpdateResultUi()
end

function S6MilitaryTrendPopupView:Update1000MS()
  if self.TickAct then
    local leftTime = self.EndTime - UITimeManager:GetInstance():GetServerTime()
    if leftTime < 0 then
      self.TickAct = false
      if self:UpdateData() then
        self:UpdateUi()
      end
    else
      self.p_text_time:SetLocalText("season_military_sp_reward_time_1", UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    end
  end
end

function S6MilitaryTrendPopupView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

function S6MilitaryTrendPopupView:OnBlankClicked()
  if UITimeManager:GetInstance():GetServerTime() - checknumber(self.OpenTime) <= 2000 then
    return
  end
  self:OnCloseClicked()
end

function S6MilitaryTrendPopupView:OnRankUpdate(evtData)
  if evtData ~= nil and evtData.RankType == self.RankType and evtData.PeriodType == self.PeriodType and evtData.RankMode == self.RankMode and self:UpdateRankData() then
    self:UpdateRankUi()
  end
end

function S6MilitaryTrendPopupView:OnSettlementUpdate(evtData)
  if evtData ~= nil and self:UpdateResultData() then
    self:UpdateRankUi()
  end
end

return S6MilitaryTrendPopupView
