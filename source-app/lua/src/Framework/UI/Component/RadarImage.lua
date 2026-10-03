local RadarImage = BaseClass("RadarImage", UIBaseComponent)
local base = UIBaseComponent
local UnityImage = typeof(CS.RadarImage)

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_image = self.gameObject:GetComponent(UnityImage)
end

local function SetDemensions(self, demensions)
  self.unity_image:SetDemensions(demensions)
end

local function SetValues(self, values)
  self.unity_image:SetValues(values)
end

local function OnDestroy(self)
  self.unity_image = nil
  base.OnDestroy(self)
end

RadarImage.OnCreate = OnCreate
RadarImage.SetDemensions = SetDemensions
RadarImage.SetValues = SetValues
RadarImage.OnDestroy = OnDestroy
return RadarImage
