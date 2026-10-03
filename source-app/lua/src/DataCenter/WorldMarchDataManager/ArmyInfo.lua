local ArmyInfo = BaseClass("ArmyInfo")
local ArmyUnitBuff = require("DataCenter.MailData.BattleReport.ArmyUnitBuff")
local ArmyHeroInfo = require("DataCenter.WorldMarchDataManager.ArmyHeroInfo")
local ArmySoldierInfo = require("DataCenter.WorldMarchDataManager.ArmySoldierInfo")

local function __init(self)
  self.initHealth = 0
  self.health = 0
  self.uuid = 0
  self.Soldiers = {}
  self.HeroInfos = {}
  self.UnitBuffs = {}
  self.SoldiersByIndex = {}
end

local function __delete(self)
  self.initHealth = nil
  self.health = nil
  self.uuid = nil
  self.Soldiers = nil
  self.HeroInfos = nil
  self.UnitBuffs = nil
  self.SoldiersByIndex = nil
end

local function UpdateArmyList(self, proto)
  self.Soldiers = {}
  self.HeroInfos = {}
  self.UnitBuffs = {}
  local soldierArr = proto.soldiers
  for k, v in pairs(soldierArr) do
    local oneData = ArmySoldierInfo.New()
    oneData:UpdateSoldier(v)
    table.insert(self.Soldiers, oneData)
  end
  local heroesArr = proto.heroes
  for k, v in pairs(heroesArr) do
    local oneData = ArmyHeroInfo.New()
    oneData:UpdateHeroInfo(v)
    table.insert(self.HeroInfos, oneData)
  end
  local buffArr = proto.unitBuffs
  for k, v in pairs(buffArr) do
    local oneData = ArmyUnitBuff.New()
    oneData:InitData(v)
    table.insert(self.UnitBuffs, oneData)
  end
  self.SoldiersByIndex = {}
  self.totalSupply = 0
  self.totalSoldierCapacity = 0
  self.totalSoldierBurden = 0
  self.totalSoldierNum = 0
  for k, v in pairs(self.Soldiers) do
    local index = tonumber(v.armsId)
    local id = v.type
    local count = v.total - v.lost
    if not self.SoldiersByIndex[index] then
      self.SoldiersByIndex[index] = {}
      self.SoldiersByIndex[index].supply = 0
      self.SoldiersByIndex[index].count = 0
    end
    self.SoldiersByIndex[index][id] = count
    local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(id)
    if soldierMeta then
      local supply = soldierMeta.restoreHp * count or 0
      local capacity = DataCenter.SoldierDataManager:CalcSoldierPower(soldierMeta, count)
      local burden = soldierMeta.burden * count or 0
      self.SoldiersByIndex[index].supply = self.SoldiersByIndex[index].supply + supply
      self.SoldiersByIndex[index].count = self.SoldiersByIndex[index].count + count
      self.totalSupply = self.totalSupply + supply
      self.totalSoldierCapacity = self.totalSoldierCapacity + capacity
      self.totalSoldierBurden = self.totalSoldierBurden + burden
      self.totalSoldierNum = self.totalSoldierNum + count
    end
  end
end

local function GetTotalCapacity(self)
  return self:GetHeroesCapacity() + self:GetSoldiersCapacity()
end

local function GetHeroesCapacity(self)
  local ret = 0
  for k, v in pairs(self.HeroInfos) do
    local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(v.heroId)
    ret = ret + heroData.power
  end
  return ret
end

local function GetSoldiersCapacity(self)
  return self.totalSoldierCapacity
end

ArmyInfo.__init = __init
ArmyInfo.__delete = __delete
ArmyInfo.UpdateArmyList = UpdateArmyList
ArmyInfo.GetHeroesCapacity = GetHeroesCapacity
ArmyInfo.GetSoldiersCapacity = GetSoldiersCapacity
ArmyInfo.GetTotalCapacity = GetTotalCapacity
return ArmyInfo
