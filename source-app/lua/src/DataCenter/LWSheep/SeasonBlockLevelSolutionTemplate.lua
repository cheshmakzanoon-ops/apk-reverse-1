local SeasonBlockLevelSolutionTemplate = BaseClass("SeasonBlockLevelSolutionTemplate")
local LWSheepUtil = require("DataCenter.LWSheep.LWSheepUtil")

function SeasonBlockLevelSolutionTemplate:__init()
  self.id = 0
  self.group = 0
  self.height = 0
  self.block_location = ""
  self.blockMap = {}
end

function SeasonBlockLevelSolutionTemplate:__delete()
  self.id = nil
  self.group = nil
  self.height = nil
  self.block_location = nil
  self.blockMap = nil
end

function SeasonBlockLevelSolutionTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.height = rowData:getValue("height") or 0
  self.block_location = rowData:getValue("block_location") or ""
  local strVec = string.split(self.block_location, "|")
  for i = 1, #strVec do
    local itemStr = strVec[i]
    if itemStr == nil then
      return
    end
    local valurStr = string.split(itemStr, ";")
    local posX, posY = math.floor(valurStr[1]), math.floor(valurStr[2])
    self.blockMap[LWSheepUtil.PosXYZToGridID(posX, posY, self.height)] = {
      pos = {
        x = posX,
        y = posY,
        z = self.height
      },
      offset = {
        x = tonumber(valurStr[1]),
        y = tonumber(valurStr[2])
      }
    }
  end
end

return SeasonBlockLevelSolutionTemplate
