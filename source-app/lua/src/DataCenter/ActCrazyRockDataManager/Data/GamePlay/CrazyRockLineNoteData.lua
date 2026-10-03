local CrazyRockNoteBaseData = require("DataCenter.ActCrazyRockDataManager.Data.GamePlay.CrazyRockNoteBaseData")
local base = CrazyRockNoteBaseData
local CrazyRockLineNoteData = BaseClass("CrazyRockLineNoteData", CrazyRockNoteBaseData)

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

CrazyRockLineNoteData.__init = __init
CrazyRockLineNoteData.__delete = __delete
return CrazyRockLineNoteData
