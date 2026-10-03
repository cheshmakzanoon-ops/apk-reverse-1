local UISeasonTowerRankRewardView = BaseClass("UISeasonTowerRankRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UISeasonTowerRankRewardObj = require("UI.LWUISeasonTower.UISeasonTowerRankReward.Component.UISeasonTowerRankRewardObj")
local UISeasonTowerRankRewardItem = require("UI.LWUISeasonTower.UISeasonTowerRankReward.Component.UISeasonTowerRankRewardItem")
local panel_path = "Panel"
local text_title_path = "safearea/TopBar/TextTitle"
local btn_close_path = "safearea/BtnClose"
local allianceRankScrollView_path = "mainObj/MiddleBg/allianceRankScrollView"
local self_rank_obj_path = "mainObj/MiddleBg/SelfRankObj"

function UISeasonTowerRankRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.rankInfo = self:GetUserData()
  self:RefreshList()
end

function UISeasonTowerRankRewardView:OnDestroy()
  self.rankInfo = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonTowerRankRewardView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("season_tower_rank_reward")
  self.self_rank_obj = self:AddComponent(UISeasonTowerRankRewardItem, self_rank_obj_path)
  self.rankScrollView = self:AddComponent(UISeasonTowerRankRewardObj, allianceRankScrollView_path)
end

function UISeasonTowerRankRewardView:ComponentDestroy()
  self.panel = nil
  self.btn_close = nil
  self.text_title = nil
  self.rankScrollView = nil
  self.self_rank_obj = nil
end

function UISeasonTowerRankRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTowerRewardRefresh, self.RefreshList)
end

function UISeasonTowerRankRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SeasonTowerRewardRefresh, self.RefreshList)
end

function UISeasonTowerRankRewardView:RefreshList()
  self.rankScrollView:SetActive(true)
  self.rankScrollView:RefreshList()
  local showDatalist = DataCenter.LWSeasonTowerManager:GetCurrentRankRewardShowList()
  local selfRank
  if self.rankInfo and self.rankInfo.ranking > 0 then
    for _, v in ipairs(showDatalist) do
      if v.minRank <= self.rankInfo.ranking and v.maxRank >= self.rankInfo.ranking then
        selfRank = v
        break
      end
    end
  end
  local sizeDelta = self.rankScrollView:GetSizeDelta()
  if selfRank then
    self.self_rank_obj:SetActive(true)
    self.self_rank_obj:SetData(selfRank)
    sizeDelta.y = 882
  else
    self.self_rank_obj:SetActive(false)
    sizeDelta.y = 1000
  end
  self.rankScrollView:SetSizeDelta(sizeDelta)
end

return UISeasonTowerRankRewardView
