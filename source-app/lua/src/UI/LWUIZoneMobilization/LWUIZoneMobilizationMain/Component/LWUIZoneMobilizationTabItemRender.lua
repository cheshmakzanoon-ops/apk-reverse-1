local base = UIBaseContainer
local LWUIZoneMobilizationTabItemRender = BaseClass("LWUIZoneMobilizationTabItemRender", base)
local normalState_path = "NormalState"
local normalStateText_path = "NormalState/NormalStateText"
local selectState_path = "SelectState"
local selectStateText_path = "SelectState/SelectStateText"
local tabBtn_path = ""
local red_point_path = "RedPoint"

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
  self.normalState = self:AddComponent(UIBaseContainer, normalState_path)
  self.normalStateText = self:AddComponent(UIText, normalStateText_path)
  self.selectState = self:AddComponent(UIBaseContainer, selectState_path)
  self.selectStateText = self:AddComponent(UIText, selectStateText_path)
  self.tabBtn = self:AddComponent(UIButton, tabBtn_path)
  self.tabBtn:SetOnClick(function()
    self:TabBtnClick()
  end)
  self.red_point = self:AddComponent(UIImage, red_point_path)
end

local function ComponentDestroy(self)
  self.normalState = nil
  self.normalStateText = nil
  self.selectState = nil
  self.selectStateText = nil
  self.tabBtn = nil
  self.red_point = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnZoneMobilizationRedPointChanged, self.RefreshRedPoint)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnZoneMobilizationRedPointChanged, self.RefreshRedPoint)
  base.OnRemoveListener(self)
end

local function InitData(self, data, curSelectTabType)
  self.data = data
  self.normalStateText:SetLocalText(data.tabName)
  self.selectStateText:SetLocalText(data.tabName)
  self:SetSelectState(self.data.tabType == curSelectTabType)
  self:RefreshRedPoint()
end

local function SetSelectState(self, isSelect)
  self.selectState:SetActive(isSelect)
end

local function TabBtnClick(self)
  self.view:OnTabItemClick(self.data.tabType)
end

local function RefreshRedPoint(self)
  if self.data then
    local tabType = self.data.tabType
    if tabType == ZoneMobilizationTabType.Donated then
      local show = DataCenter.LWZoneMobilizationManager:GetDonateTabRedPoint()
      self.red_point:SetActive(show)
    elseif tabType == ZoneMobilizationTabType.Attack then
      self.red_point:SetActive(DataCenter.LWZoneMobilizationManager:GetAttackTabRedPoint())
    elseif tabType == ZoneMobilizationTabType.Defend then
      self.red_point:SetActive(DataCenter.LWZoneMobilizationManager:GetDefendTabRedPoint())
    end
  end
end

LWUIZoneMobilizationTabItemRender.OnCreate = OnCreate
LWUIZoneMobilizationTabItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationTabItemRender.OnEnable = OnEnable
LWUIZoneMobilizationTabItemRender.OnDisable = OnDisable
LWUIZoneMobilizationTabItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationTabItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationTabItemRender.DataDefine = DataDefine
LWUIZoneMobilizationTabItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationTabItemRender.OnAddListener = OnAddListener
LWUIZoneMobilizationTabItemRender.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationTabItemRender.InitData = InitData
LWUIZoneMobilizationTabItemRender.SetSelectState = SetSelectState
LWUIZoneMobilizationTabItemRender.TabBtnClick = TabBtnClick
LWUIZoneMobilizationTabItemRender.RefreshRedPoint = RefreshRedPoint
return LWUIZoneMobilizationTabItemRender
