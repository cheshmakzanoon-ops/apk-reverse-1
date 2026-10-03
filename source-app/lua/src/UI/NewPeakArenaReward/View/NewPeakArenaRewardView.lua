local NewPeakArenaRewardView = BaseClass("NewPeakArenaRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local NewPeakArenaRewardObj = require("UI.NewPeakArenaReward.Component.NewPeakArenaRewardObj")
local NewPeakArenaAtkTimeRewardObj = require("UI.NewPeakArenaReward.Component.NewPeakArenaAtkTimeRewardObj")
local NewPeakArenaAllianceRewardObj = require("UI.NewPeakArenaReward.Component.NewPeakArenaAllianceRewardObj")
local panel_path = "Panel"
local text_title_path = "safearea/TopBar/TextTitle"
local btn_close_path = "safearea/BtnClose"
local toggle1_path = "mainObj/Tab/Toggle1"
local tab1_text_path = "mainObj/Tab/Toggle1/tab1_text"
local tab12_text_path = "mainObj/Tab/Toggle1/Choose/tab12_text"
local toggle2_path = "mainObj/Tab/Toggle2"
local tab2_text_path = "mainObj/Tab/Toggle2/tab2_text"
local tab22_text_path = "mainObj/Tab/Toggle2/Choose/tab22_text"
local toggle3_path = "mainObj/Tab/Toggle3"
local tab3_text_path = "mainObj/Tab/Toggle3/tab3_text"
local tab32_text_path = "mainObj/Tab/Toggle3/Choose/tab32_text"
local rank_scroll_view_path = "mainObj/MiddleBg/rankScrollView"
local atk_time_scroll_view_path = "mainObj/MiddleBg/atkTimeScrollView"
local allianceRankScrollView_path = "mainObj/MiddleBg/allianceRankScrollView"

function NewPeakArenaRewardView:OnCreate()
  base.OnCreate(self)
  self.level, self.pvpArenaType = self:GetUserData()
  self:ComponentDefine()
  self:TrySendGetDataMsg()
  self:RefreshList()
end

function NewPeakArenaRewardView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function NewPeakArenaRewardView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("new_arena_tips_10")
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.tab1_text = self:AddComponent(UIText, tab1_text_path)
  self.tab1_text:SetLocalText("new_arena_tips_11")
  self.tab12_text = self:AddComponent(UIText, tab12_text_path)
  self.tab12_text:SetLocalText("new_arena_tips_11")
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.tab2_text = self:AddComponent(UIText, tab2_text_path)
  self.tab2_text:SetLocalText("new_arena_tips_12")
  self.tab22_text = self:AddComponent(UIText, tab22_text_path)
  self.tab22_text:SetLocalText("new_arena_tips_12")
  self.toggle3 = self:AddComponent(UIToggle, toggle3_path)
  self.toggle3:SetIsOn(false)
  self.toggle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.tab3_text = self:AddComponent(UIText, tab3_text_path)
  self.tab3_text:SetLocalText("new_arena_tips_13")
  self.tab32_text = self:AddComponent(UIText, tab32_text_path)
  self.tab32_text:SetLocalText("new_arena_tips_13")
  self.rank_scroll_view = self:AddComponent(NewPeakArenaRewardObj, rank_scroll_view_path)
  self.atk_time_scroll_view = self:AddComponent(NewPeakArenaAtkTimeRewardObj, atk_time_scroll_view_path)
  self.allianceRankScrollView = self:AddComponent(NewPeakArenaAllianceRewardObj, allianceRankScrollView_path)
end

function NewPeakArenaRewardView:ComponentDestroy()
  self.panel = nil
  self.btn_close = nil
  self.text_title = nil
  self.toggle1 = nil
  self.tab1_text = nil
  self.tab12_text = nil
  self.toggle2 = nil
  self.tab2_text = nil
  self.tab22_text = nil
  self.toggle3 = nil
  self.tab3_text = nil
  self.tab32_text = nil
  self.rank_scroll_view = nil
  self.atk_time_scroll_view = nil
  self.allianceRankScrollView = nil
end

function NewPeakArenaRewardView:OnEnable()
  base.OnEnable(self)
end

function NewPeakArenaRewardView:OnDisable()
  base.OnDisable(self)
end

function NewPeakArenaRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.NewPeakArenaGetRewardPreview, self.RefreshList)
  self:AddUIListener(EventId.NewGaleArenaGetRewardPreview, self.RefreshList)
end

function NewPeakArenaRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.NewPeakArenaGetRewardPreview, self.RefreshList)
  self:RemoveUIListener(EventId.NewGaleArenaGetRewardPreview, self.RefreshList)
end

function NewPeakArenaRewardView:RefreshList()
  if self.toggle3:GetIsOn() == true then
    self.rank_scroll_view:SetActive(true)
    self.rank_scroll_view:RefreshList()
    self.atk_time_scroll_view:SetActive(false)
    self.allianceRankScrollView:SetActive(false)
  elseif self.toggle2:GetIsOn() == true then
    self.rank_scroll_view:SetActive(false)
    self.atk_time_scroll_view:SetActive(true)
    self.atk_time_scroll_view:RefreshList()
    self.allianceRankScrollView:SetActive(false)
  elseif self.toggle1:GetIsOn() == true then
    self.rank_scroll_view:SetActive(false)
    self.atk_time_scroll_view:SetActive(false)
    self.allianceRankScrollView:SetActive(true)
    self.allianceRankScrollView:RefreshList()
  end
end

function NewPeakArenaRewardView:ToggleControlBorS()
  self:RefreshList()
end

function NewPeakArenaRewardView:TrySendGetDataMsg()
  if self.pvpArenaType == PVPArenaType.NewGaleArena then
    SFSNetwork.SendMessage(MsgDefines.GaleArenaRewardPreView, self.level)
  else
    SFSNetwork.SendMessage(MsgDefines.NewArenaRewardPreView, self.level)
  end
end

return NewPeakArenaRewardView
