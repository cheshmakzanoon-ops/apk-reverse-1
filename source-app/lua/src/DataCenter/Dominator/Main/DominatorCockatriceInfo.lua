local DominatorInfo = require("DataCenter/Dominator/Main/DominatorInfo")
local DominatorCockatriceInfo = BaseClass("DominatorCockatriceInfo", DominatorInfo)

function DominatorCockatriceInfo:__init()
  DominatorInfo.__init(self)
  self.finishTaskIndex = nil
  self.unlockTime = nil
end

function DominatorCockatriceInfo:__delete()
  DominatorInfo.__delete(self)
  self.finishTaskIndex = nil
  self.unlockTime = nil
end

function DominatorCockatriceInfo:UpdateInfo(info)
  DominatorInfo.UpdateInfo(self, info)
  if info.finishTaskIndex then
    self.finishTaskIndex = info.finishTaskIndex
  end
  if info.unlockTime then
    self.unlockTime = info.unlockTime
  end
end

function DominatorCockatriceInfo:GetCurFinishedQuestIndex()
  if self.finishTaskIndex ~= nil then
    return self.finishTaskIndex
  end
  return 0
end

return DominatorCockatriceInfo
