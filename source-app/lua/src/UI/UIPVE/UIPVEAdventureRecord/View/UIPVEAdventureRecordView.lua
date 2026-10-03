local UIPVEAdventureRecord = BaseClass("UIPVEAdventureRecord", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPVEAdventureRecordItem = require("UI.UIPVE.UIPVEAdventureRecord.Component.UIPVEAdventureRecordItem")
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_path = "UICommonPopUpTitle/CloseBtn"
local return_path = "UICommonPopUpTitle/panel"
local scroll_view_path = "ScrollView"
local empty_path = "Empty"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(302252)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.return_btn = self:AddComponent(UIButton, return_path)
  self.return_btn:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.empty_text = self:AddComponent(UIText, empty_path)
  self.empty_text:SetLocalText(302286)
end

local function ClearScroll(self)
  self.itemList = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIPVEAdventureRecordItem)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.reset_desc_text = nil
  self.state_desc_text = nil
  self.back_btn = nil
  self.restart_btn = nil
  self.restart_text = nil
  self.history_btn = nil
  self.history_text = nil
  self.raid_btn = nil
  self.raid_text = nil
  self.buff_text = nil
  self.buff_info_btn = nil
  self.scroll_view = nil
  self.empty_text = nil
end

local function DataDefine(self)
  self.dataList = {}
  self.itemList = {}
end

local function DataDestroy(self)
  self.dataList = nil
  self.itemList = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  DataCenter.AdventureManager:SendGetRecord()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AdventureGetRecord, self.OnAdventureGetRecord)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AdventureGetRecord, self.OnAdventureGetRecord)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  if not table.IsNullOrEmpty(self.itemList) then
    self:ClearScroll()
  end
  self.scroll_view:SetTotalCount(#self.dataList)
  if #self.dataList > 0 then
    self.scroll_view:RefillCells()
    self.empty_text:SetActive(false)
  else
    self.empty_text:SetActive(true)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local data = self.dataList[index]
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIPVEAdventureRecordItem, itemObj)
  item:SetData(data)
  self.itemList[index] = item
end

local function OnItemMoveOut(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIPVEAdventureRecordItem)
  self.itemList[index] = nil
end

local function OnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnAdventureGetRecord(self, recordList)
  self.dataList = recordList
  self:ReInit()
end

UIPVEAdventureRecord.OnCreate = OnCreate
UIPVEAdventureRecord.OnDestroy = OnDestroy
UIPVEAdventureRecord.OnEnable = OnEnable
UIPVEAdventureRecord.OnDisable = OnDisable
UIPVEAdventureRecord.ComponentDefine = ComponentDefine
UIPVEAdventureRecord.ComponentDestroy = ComponentDestroy
UIPVEAdventureRecord.DataDefine = DataDefine
UIPVEAdventureRecord.DataDestroy = DataDestroy
UIPVEAdventureRecord.OnAddListener = OnAddListener
UIPVEAdventureRecord.OnRemoveListener = OnRemoveListener
UIPVEAdventureRecord.ReInit = ReInit
UIPVEAdventureRecord.RefreshBuff = RefreshBuff
UIPVEAdventureRecord.OnItemMoveIn = OnItemMoveIn
UIPVEAdventureRecord.OnItemMoveOut = OnItemMoveOut
UIPVEAdventureRecord.ClearScroll = ClearScroll
UIPVEAdventureRecord.OnCloseClick = OnCloseClick
UIPVEAdventureRecord.OnAdventureGetRecord = OnAdventureGetRecord
return UIPVEAdventureRecord
