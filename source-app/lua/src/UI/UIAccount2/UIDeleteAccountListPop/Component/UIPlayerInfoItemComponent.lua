local UIPlayerInfoItemComponent = BaseClass("UIPlayerInfoItemComponent", UIBaseContainer)
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
  self.textName = self:AddComponent(UIText, "nameText")
  self.textServer = self:AddComponent(UIText, "serverText")
end

local function ComponentDestroy(self)
  self.textName = nil
  self.textServer = nil
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

local function SetData(self, ShowInfo)
  self.textName:SetText(string.format("[%s]%s", ShowInfo.abbr, ShowInfo.name))
  self.textServer:SetText(ShowInfo.serverId)
end

UIPlayerInfoItemComponent.OnCreate = OnCreate
UIPlayerInfoItemComponent.OnDestroy = OnDestroy
UIPlayerInfoItemComponent.OnEnable = OnEnable
UIPlayerInfoItemComponent.OnDisable = OnDisable
UIPlayerInfoItemComponent.ComponentDefine = ComponentDefine
UIPlayerInfoItemComponent.ComponentDestroy = ComponentDestroy
UIPlayerInfoItemComponent.DataDefine = DataDefine
UIPlayerInfoItemComponent.DataDestroy = DataDestroy
UIPlayerInfoItemComponent.OnAddListener = OnAddListener
UIPlayerInfoItemComponent.OnRemoveListener = OnRemoveListener
UIPlayerInfoItemComponent.SetData = SetData
return UIPlayerInfoItemComponent
