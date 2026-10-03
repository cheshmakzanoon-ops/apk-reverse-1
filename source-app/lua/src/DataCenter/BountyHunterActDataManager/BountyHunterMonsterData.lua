local BountyHunterMonsterData = BaseClass("BountyHunterMonsterData")
local Localization = CS.GameEntry.Localization
local ActivityHunterMonsterTemplate = require("DataCenter.BountyHunterActDataManager.ActivityHunterMonsterTemplate")

local function __init(self)
  self.uuid = 0
  self.monsterId = 0
  self.chestId = 0
  self.curHp = 0
  self.monsterTmp = nil
  self.itemType = BountyHunterItemType.GroundMonster
  self.monsterQuality = BountyMonsterQualityType.NormalMonster
end

local function __delete(self)
  self.uuid = nil
  self.monsterId = nil
  self.chestId = nil
  self.curHp = nil
  self.monsterTmp = nil
  self.monsterType = nil
  self.monsterQuality = nil
end

function BountyHunterMonsterData:UpdateData(data)
  if not data then
    return
  end
  self.uuid = data.uuid
  self.monsterId = data.monsterId
  self.chestId = data.chestId
  self.curHp = data.hp
  local lineData = LocalController:instance():getLine(TableName.Bounty_Monster, self.monsterId)
  if lineData then
    self.monsterTmp = ActivityHunterMonsterTemplate.New()
    self.monsterTmp:UpdateData(lineData)
    self.itemType = self.monsterTmp.monsterType
    self.monsterQuality = self.monsterTmp.type
    self.maxHp = self.monsterTmp.blood
  end
end

function BountyHunterMonsterData:UpdateHp(newHp)
  self.curHp = newHp
end

BountyHunterMonsterData.__init = __init
BountyHunterMonsterData.__delete = __delete
return BountyHunterMonsterData
