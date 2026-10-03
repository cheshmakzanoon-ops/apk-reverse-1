local PveBuffTemplate = BaseClass("PveBuffTemplate")

local function __init(self)
  self.id = 0
  self.type_buff = PveBuffType.No
  self.para = ""
  self.time = 0
  self.pic = ""
  self.model = ""
  self.time_type = PveBuffTimeType.Time
  self.des = 0
end

local function __delete(self)
  self.id = nil
  self.type_buff = nil
  self.para = nil
  self.time = nil
  self.pic = nil
  self.model = nil
  self.time_type = nil
  self.des = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.type_buff = row:getValue("type_buff")
  self.para = row:getValue("para")
  self.time = row:getValue("time")
  self.pic = row:getValue("pic")
  self.model = row:getValue("model")
  if self.model == nil or self.model == "" or self.model == "null" then
    self.model = "PveBuffBox"
  end
  self.time_type = row:getValue("time_type")
  self.des = row:getValue("des")
end

local function GetBuffEffectValue(self)
  if (self.type_buff == PveBuffType.Speed or self.type_buff == PveBuffType.WeaponBigger or self.type_buff == PveBuffType.AttackQuick or self.type_buff == PveBuffType.AddAttack or self.type_buff == PveBuffType.Stun) and self.para ~= nil and self.para ~= "" then
    return tonumber(self.para)
  end
  return 0
end

PveBuffTemplate.__init = __init
PveBuffTemplate.__delete = __delete
PveBuffTemplate.InitData = InitData
PveBuffTemplate.GetBuffEffectValue = GetBuffEffectValue
return PveBuffTemplate
