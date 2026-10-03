local BuildUpgradeCompleteEffect = BaseClass("BuildUpgradeCompleteEffect")
local upgrade_path = "VFX/particle_yanhua"

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  local trans = self.transform:Find(upgrade_path)
  if trans ~= nil then
    self.upgrade = trans.gameObject
  end
end

local function ComponentDestroy(self)
  self.upgrade = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.curPosition = nil
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
end

local function ReInit(self, param)
  self.param = param
  self:ShowPanel()
end

local function ShowPanel(self)
  self.gameObject.transform.position = BuildingUtils.GetBuildModelCenterVec(self.param.posIndex, self.param.tileX, self.param.tileY)
  self.upgrade.transform:Set_localPosition(0, self.param.modelHeight, 0)
end

BuildUpgradeCompleteEffect.OnCreate = OnCreate
BuildUpgradeCompleteEffect.OnDestroy = OnDestroy
BuildUpgradeCompleteEffect.ComponentDefine = ComponentDefine
BuildUpgradeCompleteEffect.ComponentDestroy = ComponentDestroy
BuildUpgradeCompleteEffect.DataDefine = DataDefine
BuildUpgradeCompleteEffect.DataDestroy = DataDestroy
BuildUpgradeCompleteEffect.ReInit = ReInit
BuildUpgradeCompleteEffect.ShowPanel = ShowPanel
return BuildUpgradeCompleteEffect
