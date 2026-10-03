local base = UIBaseContainer
local LWUIZombieRushTabItemRender = BaseClass("LWUIZombieRushTabItemRender", base)
local tabText_path = "TabText"
local selectState_path = "SelectState"
local selectTabText_path = "SelectState/SelectTabText"
local btn_path = ""

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
  self.tabText = self:AddComponent(UITextMeshProUGUIEx, tabText_path)
  self.selectState = self:AddComponent(UIBaseContainer, selectState_path)
  self.selectTabText = self:AddComponent(UITextMeshProUGUIEx, selectTabText_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.tabText = nil
  self.selectState = nil
  self.selectTabText = nil
  self.btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ReInit(self, tabType, isSelect, clickCallBack)
  self.tabType = tabType
  self.clickCallBack = clickCallBack
  if self.tabType == ZombieRushRewardTabType.Alliance then
    self.tabText:SetLocalText(2010310)
    self.selectTabText:SetLocalText(2010310)
  else
    self.tabText:SetLocalText(2010311)
    self.selectTabText:SetLocalText(2010311)
  end
  self:SetSelect(isSelect)
end

local function SetSelect(self, isSelect)
  self.selectState:SetActive(isSelect)
end

local function OnBtnClick(self)
  if self.clickCallBack then
    self.clickCallBack(self.tabType)
  end
end

LWUIZombieRushTabItemRender.OnCreate = OnCreate
LWUIZombieRushTabItemRender.OnDestroy = OnDestroy
LWUIZombieRushTabItemRender.OnEnable = OnEnable
LWUIZombieRushTabItemRender.OnDisable = OnDisable
LWUIZombieRushTabItemRender.ComponentDefine = ComponentDefine
LWUIZombieRushTabItemRender.ComponentDestroy = ComponentDestroy
LWUIZombieRushTabItemRender.DataDefine = DataDefine
LWUIZombieRushTabItemRender.DataDestroy = DataDestroy
LWUIZombieRushTabItemRender.ReInit = ReInit
LWUIZombieRushTabItemRender.SetSelect = SetSelect
LWUIZombieRushTabItemRender.OnBtnClick = OnBtnClick
return LWUIZombieRushTabItemRender
