local LWUIWorldBossRewardObj = require("UI.LWUIWorldBossReward.Component.LWUIWorldBossRewardObj")
local LWUIWorldBossAtkTimeRewardObj = require("UI.LWUIWorldBossReward.Component.LWUIWorldBossAtkTimeRewardObj")
local LWUIWorldBossRewardView = BaseClass("LWUIWorldBossRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "Panel"
local text_title_path = "safearea/TopBar/TextTitle"
local btn_close_path = "safearea/BtnClose"
local toggle1_path = "mainObj/Tab/Toggle1"
local tab1_text_path = "mainObj/Tab/Toggle1/tab1_text"
local tab12_text_path = "mainObj/Tab/Toggle1/Choose/tab12_text"
local toggle2_path = "mainObj/Tab/Toggle2"
local tab2_text_path = "mainObj/Tab/Toggle2/tab2_text"
local tab22_text_path = "mainObj/Tab/Toggle2/Choose/tab22_text"
local rank_scroll_view_path = "mainObj/MiddleBg/rankScrollView"
local atk_time_scroll_view_path = "mainObj/MiddleBg/atkTimeScrollView"

function LWUIWorldBossRewardView:OnCreate()
  base.OnCreate(self)
  self.actId = self:GetUserData()
  if not DataCenter.ActBossDataManager:HasRankReward(self.actId) then
    SFSNetwork.SendMessage(MsgDefines.ActivityGetRankReward, self.actId, -1)
  end
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
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(1)
    end
  end)
  self.tab1_text = self:AddComponent(UIText, tab1_text_path)
  self.tab1_text:SetLocalText(456003)
  self.tab12_text = self:AddComponent(UIText, tab12_text_path)
  self.tab12_text:SetLocalText(456003)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(2)
    end
  end)
  self.tab2_text = self:AddComponent(UIText, tab2_text_path)
  self.tab2_text:SetLocalText(456004)
  self.tab22_text = self:AddComponent(UIText, tab22_text_path)
  self.tab22_text:SetLocalText(456004)
  self.rank_scroll_view = self:AddComponent(LWUIWorldBossRewardObj, rank_scroll_view_path)
  self.atk_time_scroll_view = self:AddComponent(LWUIWorldBossAtkTimeRewardObj, atk_time_scroll_view_path)
end

function LWUIWorldBossRewardView:OnDestroy()
  self.panel = nil
  self.text_title = nil
  self.btn_close = nil
  self.toggle1 = nil
  self.tab1_text = nil
  self.tab12_text = nil
  self.toggle2 = nil
  self.tab2_text = nil
  self.tab22_text = nil
  self.txt_empty = nil
  self.rank_scroll_view = nil
  self.atk_time_scroll_view = nil
  base.OnDestroy(self)
end

function LWUIWorldBossRewardView:ToggleControlBorS(tabIdx)
  self:RefreshList()
end

function LWUIWorldBossRewardView:OnEnable()
  base.OnEnable(self)
  self:ToggleControlBorS(1)
end

function LWUIWorldBossRewardView:OnDisable()
  base.OnDisable(self)
end

function LWUIWorldBossRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnActBossRewardRefresh, self.RefreshList)
end

function LWUIWorldBossRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnActBossRewardRefresh, self.RefreshList)
end

function LWUIWorldBossRewardView:RefreshList()
  if self.toggle1:GetIsOn() == true then
    self.rank_scroll_view:SetActive(true)
    self.rank_scroll_view:RefreshList()
    self.atk_time_scroll_view:SetActive(false)
  elseif self.toggle2:GetIsOn() == true then
    self.rank_scroll_view:SetActive(false)
    self.atk_time_scroll_view:SetActive(true)
    self.atk_time_scroll_view:RefreshList()
  end
end

return LWUIWorldBossRewardView
