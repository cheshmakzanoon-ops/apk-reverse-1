local UIMainBuildItem = BaseClass("UIMainBuildItem", UIBaseContainer)
local base = UIBaseContainer
local btn_path = "buildBtn"
local red_path = "RedPointNum"
local red_num_path = "RedPointNum/Text"

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.red_go = self:AddComponent(UIBaseContainer, red_path)
  self.red_num_text = self:AddComponent(UIText, red_num_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.red_go = nil
  self.red_num_text = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LUA_BUILD_INIT_END, self.Refresh)
  self:AddUIListener(EventId.BuildLevelUp, self.Refresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.LUA_BUILD_INIT_END, self.Refresh)
  self:RemoveUIListener(EventId.BuildLevelUp, self.Refresh)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ReInit(self, type)
  self.type = type
  self:Refresh()
end

local function Refresh(self)
  local inBuildNum = DataCenter.BuildManager:GetBuildRedDotByTabType(UIBuildListTabType.Economy)
  local outBuildNum = DataCenter.BuildManager:GetBuildRedDotByTabType(UIBuildListTabType.Military)
  local num = inBuildNum + outBuildNum
  if 0 < num then
    self.red_go:SetActive(true)
    self.red_num_text:SetText(num)
  else
    self.red_go:SetActive(false)
  end
end

local function OnClick(self)
  self.view.ctrl:OnFunctionClick(self.type)
end

local function OnUpdateRedPot(self)
  self:Refresh()
end

UIMainBuildItem.OnCreate = OnCreate
UIMainBuildItem.OnDestroy = OnDestroy
UIMainBuildItem.OnEnable = OnEnable
UIMainBuildItem.OnDisable = OnDisable
UIMainBuildItem.ComponentDefine = ComponentDefine
UIMainBuildItem.ComponentDestroy = ComponentDestroy
UIMainBuildItem.DataDefine = DataDefine
UIMainBuildItem.DataDestroy = DataDestroy
UIMainBuildItem.ReInit = ReInit
UIMainBuildItem.Refresh = Refresh
UIMainBuildItem.OnClick = OnClick
UIMainBuildItem.OnUpdateRedPot = OnUpdateRedPot
UIMainBuildItem.OnAddListener = OnAddListener
UIMainBuildItem.OnRemoveListener = OnRemoveListener
return UIMainBuildItem
