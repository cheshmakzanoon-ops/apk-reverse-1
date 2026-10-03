local panel_path = "panel"
local p_list_view_path = "PopUpTitle/Content/p_list_view"
local common_btn_close_path = "PopUpTitle/CloseBtn"
local S6MilitaryEliteScoreTipsCell = require("UI.LWSeason6.UILWSeasonMilitaryElite.ScoreTips.Comp.S6MilitaryEliteScoreTipsCell")
local base = UIBaseView
local S6MilitaryEliteScoreTipsView = BaseClass("S6MilitaryEliteScoreTipsView", UIBaseView)

function S6MilitaryEliteScoreTipsView:ComponentDefine()
  self.p_list_view = self:AddComponent(UILoopListViewSimple, p_list_view_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.common_btn_close = self:AddComponent(UIButton, common_btn_close_path)
  self.common_btn_close:SetOnClick(BindCallback(self, self.OnCloseClicked))
end

function S6MilitaryEliteScoreTipsView:ComponentDestroy()
  self.panel = nil
  self.p_list_view = nil
  self.common_btn_close = nil
end

function S6MilitaryEliteScoreTipsView:DataDefine()
end

function S6MilitaryEliteScoreTipsView:DataDestroy()
  self.Data = nil
end

function S6MilitaryEliteScoreTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function S6MilitaryEliteScoreTipsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6MilitaryEliteScoreTipsView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function S6MilitaryEliteScoreTipsView:InitData(data)
  if data ~= nil then
    self.Cell = LocalController:instance():tryGetLine(TableName.LW_SEASON_MILITARY_RANK, data.ConfigId)
    return self.Cell ~= nil
  end
  return false
end

function S6MilitaryEliteScoreTipsView:InitUi()
  self.p_list_view:Clear()
  if not table.IsNullOrEmpty(self.Cell.getway_desc) then
    self.p_list_view:Init(S6MilitaryEliteScoreTipsCell)
    local titleData = {}
    titleData.IsTitle = true
    self.p_list_view:AddData(titleData)
    local index = 1
    for _, way in pairs(self.Cell.getway_desc) do
      local data = {}
      data.Desc = CS.GameEntry.Localization:GetString(way)
      data.IsTitle = false
      data.Index = index
      self.p_list_view:AddData(data)
      index = index + 1
    end
    self.p_list_view:Show()
  end
end

function S6MilitaryEliteScoreTipsView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

return S6MilitaryEliteScoreTipsView
