local TacticalEquipAttriItem = BaseClass("TacticalEquipAttriItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.compBg = self:AddComponent(UIBaseContainer, "bg")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "layout/title")
  self.textCurValue = self:AddComponent(UITextMeshProUGUIEx, "layout/AttriLayout/curValue")
  self.textNextValue = self:AddComponent(UITextMeshProUGUIEx, "layout/AttriLayout/nextValue")
  self.compArrowIcon = self:AddComponent(UIBaseContainer, "layout/AttriLayout/arrowIcon")
  self.compVfx = self:AddComponent(UIVfx, "vfx", VfxAssets.TacticalEquipAttributeSaoGuang, {
    lifeType = UIVfxLifeType.DestroyAfterOnce
  })
end

local function ComponentDestroy(self)
  self.compBg = nil
  self.textTitle = nil
  self.textCurValue = nil
  self.textNextValue = nil
  self.compArrowIcon = nil
  self.compVfx = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

function TacticalEquipAttriItem:SetData(param)
  if param == nil then
    return
  end
  if not param.isFromShortcutKey then
    self:CheckParamUpdate(param)
  end
  self.param = param
  self.compBg:SetActive(param.index % 2 == 1)
  self.textTitle:SetLocalText(param.title)
  self.textCurValue:SetText(param.curValue)
  if param.nextValue and param.valueChange then
    self.textNextValue:SetText(param.nextValue)
  end
  self.textNextValue:SetActive(param.nextValue and param.valueChange)
  self.compArrowIcon:SetActive(param.nextValue and param.valueChange)
end

function TacticalEquipAttriItem:CheckParamUpdate(param)
  if self.param ~= nil and param.curValueNumber > self.param.curValueNumber then
    self.compVfx:Replay()
  end
end

TacticalEquipAttriItem.OnCreate = OnCreate
TacticalEquipAttriItem.OnDestroy = OnDestroy
TacticalEquipAttriItem.OnEnable = OnEnable
TacticalEquipAttriItem.OnDisable = OnDisable
TacticalEquipAttriItem.ComponentDefine = ComponentDefine
TacticalEquipAttriItem.ComponentDestroy = ComponentDestroy
TacticalEquipAttriItem.DataDefine = DataDefine
TacticalEquipAttriItem.DataDestroy = DataDestroy
return TacticalEquipAttriItem
