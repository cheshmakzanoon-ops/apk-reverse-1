local GetHDRIntensity = BaseClass("GetHDRIntensity", UIBaseComponent)
local base = UIBaseComponent
local UnityOutline = typeof(CS.GetHDRIntensity)

local function OnCreate(self)
  base.OnCreate(self)
  self.GetHDRIntensity = self.gameObject:GetComponent(UnityOutline)
end

local function OnDestroy(self)
  self.GetHDRIntensity = nil
  base.OnDestroy(self)
end

local function Init(self, mat)
  self.GetHDRIntensity:Init(mat)
end

GetHDRIntensity.OnCreate = OnCreate
GetHDRIntensity.OnDestroy = OnDestroy
GetHDRIntensity.Init = Init
return GetHDRIntensity
