local UIPersonalArmsTaskTipItem = BaseClass("UIPersonalArmsTaskTipItem", UIBaseContainer)
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
  self.numText = self:AddComponent(UITextMeshProUGUIEx, "numText")
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, "nameText")
end

local function ComponentDestroy(self)
  self.numText = nil
  self.nameText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, sName, sPointNum)
  self.nameText:SetLocalText(sName)
  self.numText:SetText("+ " .. sPointNum)
end

UIPersonalArmsTaskTipItem.OnCreate = OnCreate
UIPersonalArmsTaskTipItem.OnDestroy = OnDestroy
UIPersonalArmsTaskTipItem.OnEnable = OnEnable
UIPersonalArmsTaskTipItem.OnDisable = OnDisable
UIPersonalArmsTaskTipItem.ComponentDefine = ComponentDefine
UIPersonalArmsTaskTipItem.ComponentDestroy = ComponentDestroy
UIPersonalArmsTaskTipItem.DataDefine = DataDefine
UIPersonalArmsTaskTipItem.DataDestroy = DataDestroy
UIPersonalArmsTaskTipItem.OnAddListener = OnAddListener
UIPersonalArmsTaskTipItem.OnRemoveListener = OnRemoveListener
UIPersonalArmsTaskTipItem.SetData = SetData
return UIPersonalArmsTaskTipItem
