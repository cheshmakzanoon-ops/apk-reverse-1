local DominatorInfo = require("DataCenter/Dominator/Main/DominatorInfo")
local DominatorGorillaInfo = BaseClass("DominatorGorillaInfo", DominatorInfo)

function DominatorGorillaInfo:__init()
  DominatorInfo.__init(self)
  self.process = 0
  self.lastUseTime = 0
  self.useInfo = {}
  self.maxProgressDict = {}
  local k3 = LuaEntry.DataConfig:TryGetStr("dominator_para", "k3", "")
  if not string.IsNullOrEmpty(k3) then
    local splitStr = string.split(k3, ";")
    if 0 < #splitStr then
      for i, v in ipairs(splitStr) do
        self.maxProgressDict[i] = tonumber(v) or 0
      end
    end
  end
  self.configDataDict = {}
  local k4 = LuaEntry.DataConfig:TryGetStr("dominator_para", "k4", "")
  if not string.IsNullOrEmpty(k4) then
    local splitStr = string.split(k4, "|")
    for i, v in pairs(splitStr) do
      local splitStrSub = string.split(v, ";")
      if #splitStrSub == 3 then
        local data = {
          itemId = tonumber(splitStrSub[1]) or 0,
          addProgress = tonumber(splitStrSub[2]) or 0,
          dailyLimit = tonumber(splitStrSub[3]) or 0
        }
        table.insert(self.configDataDict, data)
      end
    end
  end
end

function DominatorGorillaInfo:__delete()
  self.process = nil
  self.lastUseTime = nil
  self.useInfo = nil
  self.maxProgressDict = nil
  self.configDataDict = nil
  DominatorInfo.__delete(self)
end

function DominatorGorillaInfo:UpdateInfo(info)
  DominatorInfo.UpdateInfo(self, info)
  if info.process then
    self.process = info.process
  end
  if info.lastUseTime then
    self.lastUseTime = info.lastUseTime
  end
  if info.useInfo then
    self.useInfo = info.useInfo
  end
end

function DominatorGorillaInfo:IsUseInfoDataValid()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  return UITimeManager:GetInstance():IsSameDayForServer(self.lastUseTime // 1000, now)
end

function DominatorGorillaInfo:GetItemUsedTimeToday(itemId)
  if self:IsUseInfoDataValid() then
    return self.useInfo[tostring(itemId)] or 0
  end
  return 0
end

function DominatorGorillaInfo:GetCurProgress()
  local curState = self:GetCurState()
  if curState == self.State.Free then
    return self:GetMaxTreatmentProgress()
  end
  return self.process
end

function DominatorGorillaInfo:GetStageMaxProgress(stage)
  return self.maxProgressDict[stage] or 0
end

function DominatorGorillaInfo:GetTreatmentCostInfo()
  return self.configDataDict
end

function DominatorGorillaInfo:GetMaxTreatmentProgress()
  local res = 0
  for i, v in ipairs(self.maxProgressDict) do
    res = res + v
  end
  return res
end

function DominatorGorillaInfo:GetCurTreatmentStage()
  local curState = self:GetCurState()
  if curState == self.State.Locked then
    local curProgress = self:GetCurProgress()
    local max = 0
    for i, v in ipairs(self.maxProgressDict) do
      max = max + v
      if curProgress < max then
        return i
      end
    end
    return #self.maxProgressDict
  elseif curState == self.State.Free then
    return DominatorGorillaTreatmentStage.Finish
  end
  return 0
end

function DominatorGorillaInfo:IsInTreatment()
  if self:GetCurState() == self.State.Locked then
    local curProgress = self:GetCurProgress()
    local maxProgress = self:GetMaxTreatmentProgress()
    return curProgress < maxProgress
  end
  return false
end

function DominatorGorillaInfo:IsFinishTreatment()
  return self:GetCurState() ~= self.State.Locked
end

function DominatorGorillaInfo:IsCanOpenFromMainBuilding()
  return true
end

return DominatorGorillaInfo
