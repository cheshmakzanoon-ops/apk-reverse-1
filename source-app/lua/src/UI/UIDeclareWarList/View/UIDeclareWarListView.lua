local UIDeclareWarListView = BaseClass("UIDeclareWarListView", UIBaseView)
local UIDeclareWarItem = require("UI.UIDeclareWarList.Component.UIDeclareWarItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local titleTxt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local return_path = "UICommonPopUpTitle/panel"
local scroll_view = "Rect_Content/ScrollView"
local Txt_WarAlliance = "Rect_Content/citys/Txt_WarAlliance"
local Txt_WarTime = "Rect_Content/citys/Txt_WarTime"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self._title_txt = self:AddComponent(UIText, titleTxt_path)
  self._close_btn = self:AddComponent(UIButton, closeBtn_path)
  self._return_btn = self:AddComponent(UIButton, return_path)
  self._close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.warAlliance_txt = self:AddComponent(UIText, Txt_WarAlliance)
  self.warTime_txt = self:AddComponent(UIText, Txt_WarTime)
end

local function ComponentDestroy(self)
  self._title_txt = nil
  self._close_btn = nil
  self._return_btn = nil
  self.warAlliance_txt = nil
  self.warTime_txt = nil
  self:ClearScroll()
end

local function DataDefine(self)
  self.k2 = DataCenter.AllianceDeclareWarManager:GetConfigData("k2")
  self.k3 = DataCenter.AllianceDeclareWarManager:GetConfigData("k3")
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.cityId = self:GetUserData()
  self._title_txt:SetLocalText(143549)
  self.warAlliance_txt:SetLocalText(143550)
  self.warTime_txt:SetLocalText(100018)
  self.warDataList = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.cityId)
  if next(self.warDataList) then
    self.scroll_view:SetTotalCount(#self.warDataList)
    self.scroll_view:RefillCells()
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIDeclareWarItem, itemObj)
  local data = self.warDataList[index]
  cellItem:ReInit(data)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIDeclareWarItem)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIDeclareWarItem)
end

UIDeclareWarListView.OnCreate = OnCreate
UIDeclareWarListView.OnDestroy = OnDestroy
UIDeclareWarListView.OnEnable = OnEnable
UIDeclareWarListView.OnDisable = OnDisable
UIDeclareWarListView.ComponentDefine = ComponentDefine
UIDeclareWarListView.ComponentDestroy = ComponentDestroy
UIDeclareWarListView.DataDefine = DataDefine
UIDeclareWarListView.DataDestroy = DataDestroy
UIDeclareWarListView.ReInit = ReInit
UIDeclareWarListView.OnCreateCell = OnCreateCell
UIDeclareWarListView.OnDeleteCell = OnDeleteCell
UIDeclareWarListView.ClearScroll = ClearScroll
return UIDeclareWarListView
