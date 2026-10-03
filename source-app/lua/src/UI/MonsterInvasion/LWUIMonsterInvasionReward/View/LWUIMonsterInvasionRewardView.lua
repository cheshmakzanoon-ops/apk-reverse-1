local LWUIMonsterInvasionRewardObj = require("UI.MonsterInvasion.LWUIMonsterInvasionReward.Component.LWUIMonsterInvasionRewardObj")
local LWUIMonsterInvasionRewardView = BaseClass("LWUIMonsterInvasionRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "Panel"
local text_title_path = "safearea/TopBar/TextTitle"
local btn_close_path = "safearea/BtnClose"
local rank_scroll_view_path = "mainObj/MiddleBg/rankScrollView"

function LWUIMonsterInvasionRewardView:OnCreate()
  base.OnCreate(self)
  self.actId = self:GetUserData()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText(302026)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.rank_scroll_view = self:AddComponent(LWUIMonsterInvasionRewardObj, rank_scroll_view_path)
  self:RefreshList()
end

function LWUIMonsterInvasionRewardView:OnDestroy()
  self.panel = nil
  self.text_title = nil
  self.btn_close = nil
  self.rank_scroll_view = nil
  base.OnDestroy(self)
end

function LWUIMonsterInvasionRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MonsterInvasionRankReward, self.RefreshList)
end

function LWUIMonsterInvasionRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonsterInvasionRankReward, self.RefreshList)
end

function LWUIMonsterInvasionRewardView:RefreshList()
  self.rank_scroll_view:SetActive(true)
  self.rank_scroll_view:RefreshList(self.actId)
end

return LWUIMonsterInvasionRewardView
