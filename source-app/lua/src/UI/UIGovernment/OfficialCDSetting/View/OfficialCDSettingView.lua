local OfficialCDSettingView = BaseClass("OfficialCDSettingView", UIBaseView)
local OfficialCDSettingCell = require("UI.UIGovernment.OfficialCDSetting.Component.OfficialCDSettingCell")
local base = UIBaseView
local UIGray = CS.UIGray
local GridInfinityScrollView = require("Framework.UI.Component.GridInfinityScrollView")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.btnPanel = self:AddComponent(UIButton, "Root/panel")
  self.btnPanel:SetOnClick(BindCallback(self, self.OnCloseBtnClick))
  self.btnClose = self:AddComponent(UIButton, "Root/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self, self.OnCloseBtnClick))
  self.scrollRectScrollView = self:AddComponent(UIScrollRect, "Root/Common_bg_orange/CenterContent/ScrollView")
  self.compContent = self:AddComponent(GridInfinityScrollView, "Root/Common_bg_orange/CenterContent/ScrollView/Content")
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.cellList = {}
  self.compContent:Init(bindFunc1, bindFunc2, bindFunc3)
  self.btnSet = self:AddComponent(UIButton, "Root/Common_bg_orange/SetBtn")
  self.btnSet:SetOnClick(function()
    self:OnSetBtnClick()
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnPanel = nil
  self.btnClose = nil
  self.scrollRectScrollView = nil
  self.compContent = nil
  self.btnSet = nil
end

local function DataDefine(self)
  self.cdIndex = tonumber(self:GetUserData())
  self.selectIndex = self.cdIndex
  local timeStr = LuaEntry.DataConfig:TryGetStr("auto_wonder_config", "k4")
  if timeStr then
    self.timeArr = string.split(timeStr, ";")
    self.compContent:SetItemCount(#self.timeArr)
  end
  UIGray.SetGray(self.btnSet.transform, true, true)
end

local function DataDestroy(self)
  self.timeArr = nil
  self.cdIndex = nil
  self.selectIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OfficialCdSelectTogChanged, self.OnSelectChanged)
  self:AddUIListener(EventId.OfficialGetPositionCd, self.OnUpdateCdSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OfficialCdSelectTogChanged, self.OnSelectChanged)
  self:RemoveUIListener(EventId.OfficialGetPositionCd, self.OnUpdateCdSuccess)
  base.OnRemoveListener(self)
end

local function OnInitScroll(self, go, index)
  local item = self.scrollRectScrollView:AddComponent(OfficialCDSettingCell, go)
  item.name = tostring("OfficialCDSettingCell" .. index)
  self.cellList[go] = item
end

local function OnUpdateScroll(self, go, index)
  if self.timeArr == nil or self.timeArr[index + 1] == nil then
    go:SetActive(false)
    return
  end
  local cellItem = self.cellList[go]
  go:SetActive(true)
  local time = ""
  if index + 1 <= #self.timeArr then
    time = self.timeArr[index + 1]
  end
  cellItem:SetData({
    index = index,
    time = self.timeArr and time,
    isSelected = index == self.cdIndex
  })
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearScroll(self)
  self.scrollRectScrollView:RemoveComponents(OfficialCDSettingCell)
  self.compContent:DestroyChildNode()
end

local function OnCloseBtnClick(self)
  self.ctrl:CloseSelf()
end

local function OnSetBtnClick(self)
  if self.selectIndex ~= self.cdIndex then
    DataCenter.GovernmentManager:SendKingdomPositionAppointmentCdUpdate(self.selectIndex)
  else
    UIUtil.ShowTipsId("officer_apply_041")
  end
end

local function OnSelectChanged(self, index)
  if self.selectIndex ~= index then
    self.selectIndex = index
  end
  UIGray.SetGray(self.btnSet.transform, self.selectIndex == self.cdIndex, true)
end

local function OnUpdateCdSuccess(self)
  UIUtil.ShowTipsId("officer_apply_036")
  self:OnCloseBtnClick()
end

OfficialCDSettingView.OnCreate = OnCreate
OfficialCDSettingView.OnDestroy = OnDestroy
OfficialCDSettingView.OnEnable = OnEnable
OfficialCDSettingView.OnDisable = OnDisable
OfficialCDSettingView.ComponentDefine = ComponentDefine
OfficialCDSettingView.ComponentDestroy = ComponentDestroy
OfficialCDSettingView.DataDefine = DataDefine
OfficialCDSettingView.DataDestroy = DataDestroy
OfficialCDSettingView.OnAddListener = OnAddListener
OfficialCDSettingView.OnRemoveListener = OnRemoveListener
OfficialCDSettingView.OnInitScroll = OnInitScroll
OfficialCDSettingView.OnUpdateScroll = OnUpdateScroll
OfficialCDSettingView.OnDestroyScrollItem = OnDestroyScrollItem
OfficialCDSettingView.ClearScroll = ClearScroll
OfficialCDSettingView.OnCloseBtnClick = OnCloseBtnClick
OfficialCDSettingView.OnSetBtnClick = OnSetBtnClick
OfficialCDSettingView.OnSelectChanged = OnSelectChanged
OfficialCDSettingView.OnUpdateCdSuccess = OnUpdateCdSuccess
return OfficialCDSettingView
