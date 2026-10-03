local CityLightManager = BaseClass("CityLightManager")
local Data = CS.GameEntry.Data
local LightPath = "City/Scene_City2(Clone)/Light_City"

local function __init(self)
end

local function __delete(self)
  self.light = nil
end

local function CheckCacheCityLight(self)
  local function ResetRef()
    if not IsNull(self.light) then
      self.lightActive = self.light.activeSelf
      
      if self.lightActive == false then
        self.deactiveRef = 1
      else
        self.deactiveRef = 0
      end
    end
  end
  
  if not self.light or IsNull(self.light) then
    self.light = CS.UnityEngine.GameObject.Find(LightPath)
    ResetRef()
  end
  return not IsNull(self.light)
end

function CityLightManager:AddDeactiveRef()
  local isExist = CheckCacheCityLight(self)
  if not isExist then
    return
  end
  if not self.deactiveRef then
    self.deactiveRef = 0
  end
  self.deactiveRef = self.deactiveRef + 1
  if self.deactiveRef > 0 and self.lightActive ~= nil and self.lightActive ~= false and not IsNull(self.light) then
    self.light:SetActive(false)
    self.lightActive = false
  end
end

function CityLightManager:DecreaseDeactiveRef()
  local isExist = CheckCacheCityLight(self)
  if not isExist then
    return
  end
  if not self.deactiveRef then
    self.deactiveRef = 0
  end
  self.deactiveRef = self.deactiveRef - 1
  if self.deactiveRef <= 0 and self.lightActive ~= nil and self.lightActive ~= true and not IsNull(self.light) then
    self.light:SetActive(true)
    self.lightActive = true
  end
end

CityLightManager.__init = __init
CityLightManager.__delete = __delete
return CityLightManager
