local base = UIBaseView
local SeasonGreenRankRewardPanel = BaseClass("SeasonGreenRankRewardPanel", base)
local LWSeasonBattleFieldReward = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonBattleFieldReward")
local title_path = "safeArea/TopBar/TextTitle"
local closeBtn_path = "safeArea/BottomBar/BtnBackWhite"
local seasonRankReward_path = "safeArea/panelContainer/LWSeasonBattleFieldReward"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.seasonRankRewardN = self:AddComponent(LWSeasonBattleFieldReward, seasonRankReward_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.seasonRankRewardN = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function SeasonGreenRankRewardPanel:RefreshView()
  self.titleN:SetLocalText("season_oasis_UI_23")
  self.seasonRankRewardN:SetData(LWSeasonBattleFieldRewardPanelType.GreenReward)
end

SeasonGreenRankRewardPanel.OnCreate = OnCreate
SeasonGreenRankRewardPanel.OnDestroy = OnDestroy
SeasonGreenRankRewardPanel.OnAddListener = OnAddListener
SeasonGreenRankRewardPanel.OnRemoveListener = OnRemoveListener
SeasonGreenRankRewardPanel.ComponentDefine = ComponentDefine
SeasonGreenRankRewardPanel.ComponentDestroy = ComponentDestroy
SeasonGreenRankRewardPanel.DataDefine = DataDefine
SeasonGreenRankRewardPanel.DataDestroy = DataDestroy
return SeasonGreenRankRewardPanel
