local UIDesertBattleCommanderView = BaseClass("UIDesertBattleCommanderView", UIBaseView)
local base = UIBaseView
local UIDesertBattleOrderGroup = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleCommander.Component.UIDesertBattleOrderGroup")
local UIDesertBattleCommanderGroup = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleCommander.Component.UIDesertBattleCommanderGroup")
local UIDesertBattleIntroductionGroup = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleCommander.Component.UIDesertBattleIntroductionGroup")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local tab_base_path = "PopUpTitle/TogView/Content/Tab"
local status_path = "PopUpTitle/TogView/Content/Tab1/Choose/Orders"
local commander_path = "PopUpTitle/TogView/Content/Tab2/Choose/Commander"
local introduction_path = "PopUpTitle/TogView/Content/Tab3/Choose/Introduction"

function UIDesertBattleCommanderView:OnCreate()
  base.OnCreate(self)
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("Desert_strom_commander_1020")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.order_content = self:AddComponent(UIDesertBattleOrderGroup, status_path)
  self.commander_content = self:AddComponent(UIDesertBattleCommanderGroup, commander_path)
  self.introduction_content = self:AddComponent(UIDesertBattleIntroductionGroup, introduction_path)
  self.curToggle = 0
  self.toggles = {}
  for i = 1, 3 do
    local toggle = self:AddComponent(UIToggle, tab_base_path .. i)
    toggle:SetOnValueChanged(function(tf)
      self:SetOnValueChanged(i, tf)
    end)
    self.toggles[i] = toggle
  end
  self.toggles[1]:SetIsOn(true)
  self:SetOnValueChanged(1, true)
  DataCenter.ActDragonManager:SendCommanderList()
end

function UIDesertBattleCommanderView:OnDestroy()
  self.curToggle = 1
  base.OnDestroy(self)
end

function UIDesertBattleCommanderView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonCommandOrderUpdate, self.UpdateOrder)
  self:AddUIListener(EventId.GetDagonPlayerList, self.UpdateCommander)
end

function UIDesertBattleCommanderView:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonCommandOrderUpdate, self.UpdateOrder)
  self:RemoveUIListener(EventId.GetDagonPlayerList, self.UpdateCommander)
  base.OnRemoveListener(self)
end

function UIDesertBattleCommanderView:UpdateOrder()
  if self.curToggle == 1 then
    self.order_content:UpdateData()
  end
end

function UIDesertBattleCommanderView:UpdateCommander()
  if self.curToggle == 2 then
    self.commander_content:UpdateData()
  end
end

function UIDesertBattleCommanderView:UpdateIntroduction()
  if self.curToggle == 3 then
    self.introduction_content:UpdateData()
  end
end

function UIDesertBattleCommanderView:SetOnValueChanged(idx, tf)
  if not tf or self.curToggle == idx then
    return
  end
  self.curToggle = idx
  self:UpdateOrder()
  self:UpdateCommander()
  self:UpdateIntroduction()
end

return UIDesertBattleCommanderView
