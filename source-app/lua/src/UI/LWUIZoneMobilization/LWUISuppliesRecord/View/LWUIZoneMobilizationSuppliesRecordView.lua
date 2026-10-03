local base = UIBaseView
local LWUIZoneMobilizationSuppliesRecordView = BaseClass("LWUIZoneMobilizationSuppliesRecordView", base)
local LWUIZoneMobilizationSuppliesRecordItem = require("UI.LWUIZoneMobilization.LWUISuppliesRecord.Component.LWUIZoneMobilizationSuppliesRecordItem")
local Localization = CS.GameEntry.Localization
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local scroll_root_path = "PopUpContent/ScrollRoot"
local scroll_view_path = "PopUpContent/ScrollRoot/ScrollView"
local scroll_content_path = "PopUpContent/ScrollRoot/ScrollView/Viewport/ScrollContent"
local empty_text_path = "PopUpContent/ScrollRoot/EmptyText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.GetZoneMobilizationSurpriseRecord)
end

local function OnDestroy(self)
  self.scroll_content:RemoveComponents(LWUIZoneMobilizationSuppliesRecordItem)
  self.scroll_view:ClearAllItems()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
  self.empty_text:SetLocalText("zone_mobilization_donated_no_data")
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.titleText:SetLocalText("zone_mobilization_donated_data_title")
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scroll_root = self:AddComponent(UIBaseContainer, scroll_root_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
  self.scroll_content = self:AddComponent(UIBaseContainer, scroll_content_path)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.empty_text = nil
  self.closeBtn = nil
  self.scroll_root = nil
  self.scroll_view = nil
  self.scroll_content = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function InitData(self, message)
  self.recordDataList = message and message.recordArray
  if self.recordDataList then
    local listCount = table.count(self.recordDataList)
    self.empty_text:SetActive(listCount == 0)
    self.scroll_view:SetListItemCount(listCount, false, false)
    self.scroll_view:RefreshAllShownItem()
  end
end

local function OnGetItemByIndex(self, listView, index)
  local count = table.count(self.recordDataList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = listView:NewListViewItem("LWUIZoneMobilizationRecordItem")
  local script = self.scroll_content:GetComponent(item.gameObject.name, LWUIZoneMobilizationSuppliesRecordItem)
  if script == nil then
    NameCount = NameCount + 1
    local objectName = tostring(NameCount)
    item.gameObject.name = objectName
    script = self.scroll_content:AddComponent(LWUIZoneMobilizationSuppliesRecordItem, objectName)
  end
  script:SetActive(true)
  local data = self.recordDataList[index]
  script:InitData(data)
  return item
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnZoneMobilizationRecordGot, self.InitData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnZoneMobilizationRecordGot, self.InitData)
  base.OnRemoveListener(self)
end

LWUIZoneMobilizationSuppliesRecordView.OnCreate = OnCreate
LWUIZoneMobilizationSuppliesRecordView.OnDestroy = OnDestroy
LWUIZoneMobilizationSuppliesRecordView.OnEnable = OnEnable
LWUIZoneMobilizationSuppliesRecordView.OnDisable = OnDisable
LWUIZoneMobilizationSuppliesRecordView.ComponentDefine = ComponentDefine
LWUIZoneMobilizationSuppliesRecordView.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationSuppliesRecordView.DataDefine = DataDefine
LWUIZoneMobilizationSuppliesRecordView.DataDestroy = DataDestroy
LWUIZoneMobilizationSuppliesRecordView.OnGetItemByIndex = OnGetItemByIndex
LWUIZoneMobilizationSuppliesRecordView.InitData = InitData
LWUIZoneMobilizationSuppliesRecordView.OnAddListener = OnAddListener
LWUIZoneMobilizationSuppliesRecordView.OnRemoveListener = OnRemoveListener
return LWUIZoneMobilizationSuppliesRecordView
