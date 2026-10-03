local base = UIBaseContainer
local LWUIGiftPrivilegeItemTitle = BaseClass("LWUIGiftPrivilegeItemTitle", base)
local titleTxt_path = "Title"

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
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
end

local function ComponentDestroy(self)
  self.titleTxt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWUIGiftPrivilegeItemTitle:UpdateItem(data)
  if data.Unlock then
    self.titleTxt:SetLocalText("gift_privilege_unlocked")
  else
    self.titleTxt:SetLocalText("gift_privilege_locked")
  end
end

LWUIGiftPrivilegeItemTitle.OnCreate = OnCreate
LWUIGiftPrivilegeItemTitle.OnDestroy = OnDestroy
LWUIGiftPrivilegeItemTitle.OnEnable = OnEnable
LWUIGiftPrivilegeItemTitle.OnDisable = OnDisable
LWUIGiftPrivilegeItemTitle.ComponentDefine = ComponentDefine
LWUIGiftPrivilegeItemTitle.ComponentDestroy = ComponentDestroy
LWUIGiftPrivilegeItemTitle.DataDefine = DataDefine
LWUIGiftPrivilegeItemTitle.DataDestroy = DataDestroy
return LWUIGiftPrivilegeItemTitle
