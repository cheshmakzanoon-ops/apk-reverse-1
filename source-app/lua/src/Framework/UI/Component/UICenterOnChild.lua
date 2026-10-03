local UICenterOnChild = BaseClass("UICenterOnChild", UIBaseComponent)
local base = UIBaseComponent
local CenterOnChild = typeof(CS.CenterOnChild)

local function OnCreate(self)
  base.OnCreate(self)
  self.CenterOnChild = self.gameObject:GetComponent(CenterOnChild)
end

local function OnDestroy(self)
  self.CenterOnChild = nil
  base.OnDestroy(self)
end

local function Reset(self)
  self.CenterOnChild:Reset()
end

UICenterOnChild.OnCreate = OnCreate
UICenterOnChild.OnDestroy = OnDestroy
UICenterOnChild.Reset = Reset
return UICenterOnChild
