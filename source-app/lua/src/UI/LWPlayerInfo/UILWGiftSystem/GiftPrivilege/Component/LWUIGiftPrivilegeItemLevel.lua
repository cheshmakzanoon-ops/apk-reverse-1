local base = UIBaseContainer
local LWUIGiftPrivilegeItemLevel = BaseClass("LWUIGiftPrivilegeItemLevel", base)
local LWUIGiftLevelInfo = require("UI.LWPlayerInfo.UILWGiftSystem.Common.LWUIGiftLevelInfo")
local levelInfo_path = "LWUIGiftLevelInfo"

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
  self.levelInfo = self:AddComponent(UIBaseContainer, levelInfo_path)
  self.levelInfoComponent = self:AddComponent(LWUIGiftLevelInfo, levelInfo_path)
end

local function ComponentDestroy(self)
  self.levelInfo = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWUIGiftPrivilegeItemLevel:UpdateItem(data)
  self.levelInfoComponent:SetData()
end

LWUIGiftPrivilegeItemLevel.OnCreate = OnCreate
LWUIGiftPrivilegeItemLevel.OnDestroy = OnDestroy
LWUIGiftPrivilegeItemLevel.OnEnable = OnEnable
LWUIGiftPrivilegeItemLevel.OnDisable = OnDisable
LWUIGiftPrivilegeItemLevel.ComponentDefine = ComponentDefine
LWUIGiftPrivilegeItemLevel.ComponentDestroy = ComponentDestroy
LWUIGiftPrivilegeItemLevel.DataDefine = DataDefine
LWUIGiftPrivilegeItemLevel.DataDestroy = DataDestroy
return LWUIGiftPrivilegeItemLevel
