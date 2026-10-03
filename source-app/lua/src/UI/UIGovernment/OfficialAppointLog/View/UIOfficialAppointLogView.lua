local base = UIBaseView
local UIOfficialAppointLogView = BaseClass("UIOfficialAppointLogView", base)
local UIOfficialAppointLogCell = require("UI.UIGovernment.OfficialAppointLog.Component.UIOfficialAppointLogCell")
local Localization = CS.GameEntry.Localization
local titleText_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local closeBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local scrollView_path = "Root/Content/ContentHolder/ScrollView"
local nonePanel_path = "Root/Content/ContentHolder/NonePanel"
local noneTipText_path = "Root/Content/ContentHolder/NonePanel/NoneTipText"
local closePanel_path = "Panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.nonePanel = self:AddComponent(UIBaseContainer, nonePanel_path)
  self.noneTipText = self:AddComponent(UIText, noneTipText_path)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.titleText = nil
  self.closeBtn = nil
  self.scrollView = nil
  self.nonePanel = nil
  self.noneTipText = nil
  self.closePanel = nil
end

local function DataDefine(self)
  self.positionId = self:GetUserData()
  self.ctrl:SendKingdomPositionHistoryList(self.positionId)
end

local function DataDestroy(self)
  self.positionId = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OfficialAppointLogListInit, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OfficialAppointLogListInit, self.Refresh)
  base.OnRemoveListener(self)
end

local function Refresh(self)
  self.appointLogList = DataCenter.OfficialApplyManager:GetAppointLogList(self.positionId)
  if self.appointLogList and #self.appointLogList > 0 then
    self.scrollView:SetActive(true)
    self.nonePanel:SetActive(false)
    self.scrollView:SetTotalCount(#self.appointLogList)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
    self.nonePanel:SetActive(true)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring("UIOfficialAppointLogCell" .. index)
  local cellItem = self.scrollView:AddComponent(UIOfficialAppointLogCell, itemObj)
  cellItem:SetData(self.positionId, self.appointLogList[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIOfficialAppointLogCell)
end

local function ClearScroll(self)
  self.scrollView:RemoveComponents(UIOfficialAppointLogCell)
  self.scrollView:ClearCells()
end

UIOfficialAppointLogView.OnCreate = OnCreate
UIOfficialAppointLogView.OnDestroy = OnDestroy
UIOfficialAppointLogView.OnEnable = OnEnable
UIOfficialAppointLogView.OnDisable = OnDisable
UIOfficialAppointLogView.ComponentDefine = ComponentDefine
UIOfficialAppointLogView.ComponentDestroy = ComponentDestroy
UIOfficialAppointLogView.DataDefine = DataDefine
UIOfficialAppointLogView.DataDestroy = DataDestroy
UIOfficialAppointLogView.OnItemMoveIn = OnItemMoveIn
UIOfficialAppointLogView.OnItemMoveOut = OnItemMoveOut
UIOfficialAppointLogView.ClearScroll = ClearScroll
UIOfficialAppointLogView.OnAddListener = OnAddListener
UIOfficialAppointLogView.OnRemoveListener = OnRemoveListener
UIOfficialAppointLogView.Refresh = Refresh
return UIOfficialAppointLogView
