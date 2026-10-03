local base = UIBaseContainer
local LWUIZoneMobilizationRankRewardPreviewTabItemRender = BaseClass("LWUIZoneMobilizationRankRewardPreviewTabItemRender", base)
local Localization = CS.GameEntry.Localization
local tabText_path = "TabText"
local selectState_path = "SelectState"
local btn_path = ""

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
  self.tabText = self:AddComponent(UIText, tabText_path)
  self.selectState = self:AddComponent(UIBaseContainer, selectState_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:TabBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.tabText = nil
  self.selectState = nil
  self.btn = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

local function InitData(self, data, curSelectTabType)
  self.data = data
  self:SetSelectState(self.data.tabType == curSelectTabType)
end

local function SetSelectState(self, isSelect)
  self.selectState:SetActive(isSelect)
  local tabName = Localization:GetString(self.data.tabName)
  if isSelect then
    self.tabText:SetText("<color=#FFFFFF>" .. tabName .. "</color>")
  else
    self.tabText:SetText("<color=#C8C8C8>" .. tabName .. "</color>")
  end
end

local function TabBtnClick(self)
  self.view:OnTabItemClick(self.data.tabType)
end

LWUIZoneMobilizationRankRewardPreviewTabItemRender.OnCreate = OnCreate
LWUIZoneMobilizationRankRewardPreviewTabItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationRankRewardPreviewTabItemRender.OnEnable = OnEnable
LWUIZoneMobilizationRankRewardPreviewTabItemRender.OnDisable = OnDisable
LWUIZoneMobilizationRankRewardPreviewTabItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationRankRewardPreviewTabItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationRankRewardPreviewTabItemRender.DataDefine = DataDefine
LWUIZoneMobilizationRankRewardPreviewTabItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationRankRewardPreviewTabItemRender.InitData = InitData
LWUIZoneMobilizationRankRewardPreviewTabItemRender.SetSelectState = SetSelectState
LWUIZoneMobilizationRankRewardPreviewTabItemRender.TabBtnClick = TabBtnClick
return LWUIZoneMobilizationRankRewardPreviewTabItemRender
