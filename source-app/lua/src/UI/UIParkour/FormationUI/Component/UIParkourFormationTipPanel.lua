local UIParkourFormationTipPanel = BaseClass("UIParkourFormationTipPanel", UIAsyncContainer)
local base = UIBaseContainer

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
  self.tipText1 = self:AddComponent(UIText, "TipText1")
  self.tipText2 = self:AddComponent(UIText, "TipText2")
end

local function ComponentDestroy(self)
  self.tipText1 = nil
  self.tipText2 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.tipStr1 = nil
  self.tipStr2 = nil
  self.anchoredPos = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetData(self, tipStr1, tipStr2, anchoredPos)
  self.tipStr1 = tipStr1
  self.tipStr2 = tipStr2
  self.anchoredPos = anchoredPos
  self:UpdateData()
end

local function UpdateData(self)
  if not GameObjectIsValid(self.gameObject) then
    return
  end
  if self.tipStr1 then
    self.tipText1:SetText(self.tipStr1)
  end
  if self.tipStr2 then
    self.tipText2:SetText(self.tipStr2)
  end
  if self.anchoredPos then
    self:SetAnchoredPosition(self.anchoredPos)
  end
end

UIParkourFormationTipPanel.OnCreate = OnCreate
UIParkourFormationTipPanel.OnDestroy = OnDestroy
UIParkourFormationTipPanel.OnEnable = OnEnable
UIParkourFormationTipPanel.OnDisable = OnDisable
UIParkourFormationTipPanel.ComponentDefine = ComponentDefine
UIParkourFormationTipPanel.ComponentDestroy = ComponentDestroy
UIParkourFormationTipPanel.DataDefine = DataDefine
UIParkourFormationTipPanel.DataDestroy = DataDestroy
UIParkourFormationTipPanel.OnAddListener = OnAddListener
UIParkourFormationTipPanel.OnRemoveListener = OnRemoveListener
UIParkourFormationTipPanel.SetData = SetData
UIParkourFormationTipPanel.UpdateData = UpdateData
return UIParkourFormationTipPanel
