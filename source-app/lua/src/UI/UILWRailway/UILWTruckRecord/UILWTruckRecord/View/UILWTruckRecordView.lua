local UILWTruckRecordView = BaseClass("UILWTruckRecordView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local SendRecord = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecord.Component.SendRecord")
local RobRecord = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecord.Component.RobRecord")
local CollectRecord = require("UI.UILWRailway.UILWTruckRecord.UILWTruckRecord.Component.CollectRecord")
local text_title_path = "Root/TopBar/TextTitle"
local root_send_record_path = "Root/RootSend"
local root_rob_record_path = "Root/RootRob"
local root_collect_record_path = "Root/RootCollect"
local tab_item1_path = "Root/TopBar/Tab/TabItem1"
local tab_item2_path = "Root/TopBar/Tab/TabItem2"
local tab_item3_path = "Root/TopBar/Tab/TabItem3"
local btn_back_path = "Root/BottomBar/BtnBack"

function UILWTruckRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWTruckRecordView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTruckRecordView:OnAddListener()
  base.OnAddListener(self)
end

function UILWTruckRecordView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTruckRecordView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.root_send_record = self:AddComponent(SendRecord, root_send_record_path)
  self.root_rob_record = self:AddComponent(RobRecord, root_rob_record_path)
  self.root_collect_record = self:AddComponent(CollectRecord, root_collect_record_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:ShowTab(1, false)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:ShowTab(2, false)
    end
  end)
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      self:ShowTab(3, false)
    end
  end)
  self.tab_item1:SetIsOnWithoutNotify(false)
  self.tab_item2:SetIsOnWithoutNotify(false)
  self.tab_item3:SetIsOnWithoutNotify(false)
  local curShowTab = 1
  self.userData = self:GetUserData()
  if self.userData and self.userData.showTab then
    curShowTab = self.userData.showTab
  end
  if curShowTab == 1 then
    self.tab_item1:SetIsOn(true)
    if self.activeTab == nil then
      self:ShowTab(1, false)
    end
  elseif curShowTab == 2 then
    self.tab_item2:SetIsOn(true)
    if self.activeTab == nil then
      self:ShowTab(2, false)
    end
  elseif curShowTab == 3 then
    self.tab_item3:SetIsOn(true)
    if self.activeTab == nil then
      self:ShowTab(3, false)
    end
  end
end

function UILWTruckRecordView:ComponentDestroy()
  self.root_send_record = nil
  self.root_rob_record = nil
  self.root_collect_record = nil
  self.btn_back = nil
  self.btn_history = nil
  self.activeTab = nil
end

function UILWTruckRecordView:UpdateData()
end

function UILWTruckRecordView:ShowTab(tabIndex, force)
  if self.activeTab == tabIndex and not force then
    return
  end
  self.root_rob_record:SetActive(tabIndex == 1)
  self.root_send_record:SetActive(tabIndex == 2)
  self.root_collect_record:SetActive(tabIndex == 3)
  if tabIndex == 1 then
    self.root_rob_record:RefreshContent()
  elseif tabIndex == 2 then
    self.root_send_record:RefreshContent()
  elseif tabIndex == 3 then
    self.root_collect_record:RefreshContent()
  end
  self.activeTab = tabIndex
end

return UILWTruckRecordView
