local ApsRandom = BaseClass("ApsRandom")
local MULTIPLIER = 25214903917
local ADDEND = 11
local MASK_31 = 2147483647
local MASK_48 = 281474976710655

local function __init(self, seed)
  self.seed = 0
  if seed then
    self:SetSeed(seed)
  end
end

local function __delete(self)
  self.seed = nil
end

local function InitialScramble(seed)
  return (seed ~ MULTIPLIER) & MASK_48
end

local function SetSeed(self, seed)
  self.seed = InitialScramble(seed)
end

local function GetSeed(self)
  return self.seed
end

local function Next(self, bits)
  self.seed = self.seed * MULTIPLIER + ADDEND & MASK_48
  return self.seed >> 48 - bits & MASK_31
end

local function NextInt(self, bound)
  local r = self:Next(31)
  local m = bound - 1
  if bound & m == 0 then
    r = bound * r >> 31 & MASK_31
  else
    local u = r
    r = u % bound
    while u - r + m < 0 do
      u = self:Next(31)
      r = u % bound
    end
  end
  return r
end

ApsRandom.__init = __init
ApsRandom.__delete = __delete
ApsRandom.SetSeed = SetSeed
ApsRandom.GetSeed = GetSeed
ApsRandom.Next = Next
ApsRandom.NextInt = NextInt
return ApsRandom
