local base = UIBaseContainer
local LWUIZoneMobilizationAllianceRankTabItemRender = BaseClass("LWUIZoneMobilizationAllianceRankTabItemRender", base)
local normalState_path = "NormalState"
local normalStateText_path = "NormalState/NormalStateText"
local selectState_path = "SelectState"
local selectStateText_path = "SelectState/SelectStateText"
local tabBtn_path = ""

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
end

local function ComponentDestroy(self)
  self.normalState = nil
  self.normalStateText = nil
  self.selectState = nil
  self.selectStateText = nil
  self.tabBtn = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

local function InitData(self, data, curSelectTabType)
  self.data = data
  self.normalStateText:SetLocalText(data.tabName)
  self.selectStateText:SetLocalText(data.tabName)
  self:SetSelectState(self.data.tabType == curSelectTabType)
end

local function SetSelectState(self, isSelect)
  self.selectState:SetActive(isSelect)
end

local function TabBtnClick(self)
  self.view:OnTabItemClick(self.data.tabType)
end

LWUIZoneMobilizationAllianceRankTabItemRender.OnCreate = OnCreate
LWUIZoneMobilizationAllianceRankTabItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationAllianceRankTabItemRender.OnEnable = OnEnable
LWUIZoneMobilizationAllianceRankTabItemRender.OnDisable = OnDisable
LWUIZoneMobilizationAllianceRankTabItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationAllianceRankTabItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationAllianceRankTabItemRender.DataDefine = DataDefine
LWUIZoneMobilizationAllianceRankTabItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationAllianceRankTabItemRender.InitData = InitData
LWUIZoneMobilizationAllianceRankTabItemRender.SetSelectState = SetSelectState
LWUIZoneMobilizationAllianceRankTabItemRender.TabBtnClick = TabBtnClick
return LWUIZoneMobilizationAllianceRankTabItemRender
