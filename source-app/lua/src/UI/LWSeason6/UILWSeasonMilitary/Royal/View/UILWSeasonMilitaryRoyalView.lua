local p_comp_level_path = "safeArea/Mid/p_comp_level"
local p_listview_rank_path = "safeArea/Mid/content_rank/p_listview_rank"
local p_comp_rank_cur_path = "safeArea/Mid/content_rank/p_comp_rank_cur"
local p_btn_back_path = "safeArea/Bottom/p_btn_back"
local p_text_no_content_path = "safeArea/Mid/content_rank/p_text_no_content"
local UILWSeasonMilitaryRankCell = require("UI.LWSeason6.UILWSeasonMilitary.Cell.UILWSeasonMilitaryRankCell")
local UILWSeasonMilitaryLevelPreviewComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryLevelPreviewComp")
local base = UIBaseView
local UILWSeasonMilitaryRoyalView = BaseClass("UILWSeasonMilitaryRoyalView", UIBaseView)

function UILWSeasonMilitaryRoyalView:ComponentDefine()
  self.p_comp_level = self:AddComponent(UILWSeasonMilitaryLevelPreviewComp, p_comp_level_path)
  self.p_listview_rank = self:AddComponent(UILoopListViewSimple, p_listview_rank_path)
  self.p_comp_rank_cur = self:AddComponent(UILWSeasonMilitaryRankCell, p_comp_rank_cur_path)
  self.p_btn_back = self:AddComponent(UIButton, p_btn_back_path)
  self.p_btn_back:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_no_content = self:AddComponent(UITextMeshProUGUIEx, p_text_no_content_path)
end

function UILWSeasonMilitaryRoyalView:ComponentDestroy()
  self.p_comp_level = nil
  self.p_listview_rank = nil
  self.p_comp_rank_cur = nil
  self.p_btn_back = nil
  self.p_text_no_content = nil
end

function UILWSeasonMilitaryRoyalView:DataDefine()
end

function UILWSeasonMilitaryRoyalView:DataDestroy()
  self.Data = nil
end

function UILWSeasonMilitaryRoyalView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInIt(self:GetUserData())
end

function UILWSeasonMilitaryRoyalView:OnDestroy()
  DataCenter.SeasonMilitaryManager:ClearRoyalCache()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryRoyalView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMilitaryLevelRoyalUpdate, self.OnUpdateRoyal)
  self:AddUIListener(EventId.SeasonMilitaryLevelRoyalLevelPreview, self.OnLevelPreviewClicked)
end

function UILWSeasonMilitaryRoyalView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMilitaryLevelRoyalUpdate, self.OnUpdateRoyal)
  self:RemoveUIListener(EventId.SeasonMilitaryLevelRoyalLevelPreview, self.OnLevelPreviewClicked)
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryRoyalView:ReInIt(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateMilitary()
      self:UpdateRank()
    end
  else
    self:OnCloseClicked()
  end
end

function UILWSeasonMilitaryRoyalView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.Level = Mathf.Max(2, checknumber(self.Data.DefaultLevel))
    return true
  end
  return false
end

function UILWSeasonMilitaryRoyalView:InitUi()
  self.p_listview_rank:Init(UILWSeasonMilitaryRankCell)
  self.p_text_no_content:SetActive(true)
  self.p_listview_rank:SetActive(false)
end

function UILWSeasonMilitaryRoyalView:UpdateData()
  self.RankData = DataCenter.SeasonMilitaryManager:GetRoyalCacheData(self.Level)
  return true
end

function UILWSeasonMilitaryRoyalView:UpdateMilitary()
  local data = {}
  data.Level = self.Level
  data.ShowSwitch = true
  data.MinLevel = 2
  data.MaxLevel = DataCenter.SeasonMilitaryManager:GetMaxLevel()
  data.EventId = EventId.SeasonMilitaryLevelRoyalLevelPreview
  self.p_comp_level:ReInit(data)
end

function UILWSeasonMilitaryRoyalView:UpdateRank()
  local curData
  self.p_listview_rank:Clear()
  self.p_text_no_content:SetActive(true)
  self.p_listview_rank:SetActive(false)
  local manualLevel = DataCenter.SeasonMilitaryManager:GetMaxManualLevel()
  if self.RankData ~= nil then
    if not table.IsNullOrEmpty(self.RankData.RankList) then
      self.p_listview_rank:SetActive(true)
      self.p_text_no_content:SetActive(false)
      for _, rankSlot in pairs(self.RankData.RankList) do
        local rankData = self.ctrl:GetRankData(rankSlot, manualLevel <= self.Level)
        self.p_listview_rank:AddData(rankData)
        if rankSlot.Uid == LuaEntry.Player.uid then
          curData = rankData
        end
      end
      self.p_listview_rank:Show()
    end
  else
    DataCenter.SeasonMilitaryManager:SendGetRoyal(self.Level)
  end
  if curData ~= nil then
    curData.IsSelf = curData.Uid == LuaEntry.Player.uid
  end
  self.p_comp_rank_cur:ReInit(curData)
end

function UILWSeasonMilitaryRoyalView:OnUpdateRoyal(rankData)
  if rankData ~= nil then
    local level = checknumber(rankData.Level)
    if checknumber(self.Level) == level and self:UpdateData() then
      self:UpdateMilitary()
      self:UpdateRank()
    end
  end
end

function UILWSeasonMilitaryRoyalView:OnLevelPreviewClicked(evt)
  local level = checknumber(evt)
  if 1 < level then
    self.Level = level
    if self:UpdateData() then
      self:UpdateMilitary()
      self:UpdateRank()
    end
  end
end

function UILWSeasonMilitaryRoyalView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

return UILWSeasonMilitaryRoyalView
