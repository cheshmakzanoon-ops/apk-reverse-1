local DecorationData = BaseClass("DecorationData")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.skinId = 0
  self.type = 0
  self.expireTime = 0
  self.wear = 0
  self.colourId = nil
  self.colourTime = nil
end

local function __delete(self)
  self.skinId = 0
  self.type = 0
  self.expireTime = 0
  self.wear = 0
  self.colourId = nil
  self.colourTime = nil
end

local function ParseData(self, data)
  self.skinId = data.skinId
  self.type = data.type
  self.expireTime = data.expireTime
  self.wear = data.wear
  self.colourId = data.colourId
  self.colourTime = data.colourTime
end

local function IsWear(self)
  return self.wear == 1
end

local function SetIsWear(self, flg)
  if flg == false then
    self.wear = 0
  else
    self.wear = 1
  end
end

local function IsInExpireTime(self)
  local lastSex = LuaEntry.Player:GetGender()
  if lastSex ~= SexType.Woman and template.typeGain == DecorationGainType.DecorationGainType_Female then
    return false
  end
  if self.expireTime <= 0 then
    return true
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now < self.expireTime
end

function DecorationData:IsActiveWear()
  if self:IsWear() and self:IsInExpireTime() then
    return true
  end
  return false
end

local function GetDecorationType(self)
  return self.type
end

local function GetSkinId(self)
  return self.skinId
end

local function GetExpireTime(self)
  return self.expireTime
end

local function GetActiveSkinId(self, original, checkWear_)
  if checkWear_ and not self:IsActiveWear() then
    return
  end
  if not original and self.colourId and self.colourId > 0 and (0 >= self.colourTime or UITimeManager:GetInstance():GetServerTime() < self.colourTime) then
    local temp = DataCenter.DecorationDazzleManager:GetDazzleSkinTemplateById(self.skinId, self.colourId)
    if temp and 0 < temp.decoration_id_new then
      return temp.decoration_id_new
    end
  end
  return self.skinId
end

local function IsWearDazzleSkin(self, colourId)
  local isWear = false
  if colourId and 0 < colourId then
    isWear = self.colourId == colourId
  else
    isWear = self.colourId and 0 < self.colourId
  end
  if not isWear then
    return false
  end
  if 0 < self.colourTime and UITimeManager:GetInstance():GetServerTime() > self.colourTime then
    return false
  end
  return true
end

DecorationData.__init = __init
DecorationData.__delete = __delete
DecorationData.ParseData = ParseData
DecorationData.IsWear = IsWear
DecorationData.SetIsWear = SetIsWear
DecorationData.IsInExpireTime = IsInExpireTime
DecorationData.GetDecorationType = GetDecorationType
DecorationData.GetSkinId = GetSkinId
DecorationData.GetExpireTime = GetExpireTime
DecorationData.IsWearDazzleSkin = IsWearDazzleSkin
DecorationData.GetActiveSkinId = GetActiveSkinId
return DecorationData
