local CityDefense = BaseClass("CityDefense")

function CityDefense:__init()
  self.cityDefenseVal = 0
  self.cityFireStamp = 0
  self.cityLastRepairStamp = 0
  self.cityUpdateStamp = 0
  self.addDefenceDiamond = 0
end

function CityDefense:InitFromNet(obj)
  self:UpdateCityDefenceInfo(obj)
end

function CityDefense:UpdateCityDefenceInfo(data)
  if data.cityDefValue then
    self.cityDefenseVal = data.cityDefValue
  end
  if data.ft then
    self.cityFireStamp = data.ft
  end
  if data.lastCityDefTime then
    self.cityLastRepairStamp = data.lastCityDefTime
  end
  if data.curCostDiamond then
    self.addDefenceDiamond = data.curCostDiamond
  end
  self.cityUpdateStamp = UITimeManager:GetInstance():GetServerTime()
end

function CityDefense:UpdateCityDefenceInfo2(data)
  self.cityDefenseVal = data.cityDefValue
  self.cityLastRepairStamp = data.lastCityDefTime
  if data.curCostDiamond then
    self.addDefenceDiamond = data.curCostDiamond
  end
end

function CityDefense:ResetCityDefence()
  self.cityDefenseVal = GetDefCityMax()
  self.cityFireStamp = 0
  self.cityUpdateStamp = 0
  self.cityLastRepairStamp = 0
end

function CityDefense:IsCityInFire()
  if self.cityFireStamp > UITimeManager:GetInstance():GetServerTime() then
    return true
  end
  return false
end

function CityDefense:GetFireRemainTime()
  local seconds = self.cityFireStamp - GameEntry.Timer.GetServerTime()
  seconds = seconds / 1000
  return seconds
end

function CityDefense:GetDefCityMax()
  return 1150
end

function CityDefense:GetDefCity()
  return self.cityDefenseVal
end

function CityDefense:GetFireRate()
  local fireRate = 0
  return fireRate
end

function CityDefense:StartGetCityDefence()
  GetCityDefMessage.Instance.Send()
end

function CityDefense:EndGetCityDefence(dict)
end

function CityDefense:StartRepairCity()
  AddDefenseMessage.Instance.Send()
end

function CityDefense:EndRepairCity(dict)
  UpdateCityDefenceInfo(dict)
end

function CityDefense:StartCityOutFire()
  BuyCityDefMessage.Instance.Send()
end

function CityDefense:EndCityOutFire(dict)
  UpdateCityDefenceInfo(dict)
end

function CityDefense:GetRepairValue()
  return GameEntry.GlobalData.fire1[2]
end

function CityDefense:GetRepairButtonTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local interval = GameEntry.GlobalData.fire1[1] * 60 * 1000
  local next = self.cityLastRepairStamp + interval
  local s = next - now
  s = s / 1000
  return s
end

function CityDefense:UpdateCurrentValue()
  if self:IsCityInFire() == false then
    return 0
  end
  local ft = self:GetFireRate()
  local now = UITimeManager:GetInstance():GetServerTime()
  local elapse = (now - self.cityUpdateStamp) / 1000
  local value = ft * elapse / 3600
  self.cityDefenseVal = self.cityDefenseVal - value
  if 0 > self.cityDefenseVal then
    self.cityDefenseVal = 0
  end
  self.cityUpdateStamp = UITimeManager:GetInstance():GetServerTime()
  return self.cityDefenseVal
end

function CityDefense:UpdateCurrentValueOutFire()
  if self:IsCityInFire() == true or self.cityDefenseVal >= self:GetDefCityMax() then
    return
  end
  local ft = self:GetDefenceGrowRate()
  local now = UITimeManager:GetInstance():GetServerTime()
  local elapse = (now - self.cityUpdateStamp) / 1000
  local value = ft * elapse / 3600
  self.cityDefenseVal = self.cityDefenseVal + value
  if self.cityDefenseVal >= self:GetDefCityMax() then
    self.cityDefenseVal = self:GetDefCityMax()
  end
  self.cityUpdateStamp = UITimeManager:GetInstance():GetServerTime()
end

function CityDefense:GetDefenceGrowRate()
  local k4 = LuaEntry.DataConfig:TryGetStr("nai_jiu_zhi", "k4")
  local GrowMin = tonumber(k4) / 100 * self:GetDefCityMax()
  local rate = LuaEntry.Effect:GetGameEffect(297)
  GrowMin = GrowMin * (1 + rate / 100)
  return GrowMin * 60
end

function CityDefense:StartCityAddDefence()
  BuyCitydefAddMessage.Instance.Send()
end

function CityDefense:EndCityAddDefence(dict)
  if not dict.cityDefValue then
    return
  end
  self:UpdateCityDefenceInfo(dict)
end

function CityDefense:GetCostDiamond()
  return self.addDefenceDiamond
end

function CityDefense:GetDefenceGrow()
  local Grow = LuaEntry.DataConfig:TryGetNum("nai_jiu_zhi", "k1")
  return Grow
end

return CityDefense
