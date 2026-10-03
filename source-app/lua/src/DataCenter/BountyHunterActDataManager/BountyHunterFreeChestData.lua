local BountyHunterFreeChestData = BaseClass("BountyHunterFreeChestData")
local Localization = CS.GameEntry.Localization
local ActivityHunterFreeBoxTemplate = require("DataCenter.BountyHunterActDataManager.ActivityHunterFreeboxTemplate")

local function __init(self)
  self.uuid = 0
end

local function __delete(self)
end

function BountyHunterFreeChestData:UpdateData(data)
  if not data then
    return
  end
  self.uuid = data.uuid
  self.chestId = data.id
  self.itemType = BountyHunterItemType.FreeChest
  local lineData = LocalController:instance():getLine(TableName.Bounty_Hunter_FreeChest, self.chestId)
  if lineData then
    self.chestTmp = ActivityHunterFreeBoxTemplate.New()
    self.chestTmp:UpdateData(lineData)
    self.prefabPath = self.chestTmp.prefab
  end
end

BountyHunterFreeChestData.__init = __init
BountyHunterFreeChestData.__delete = __delete
return BountyHunterFreeChestData
