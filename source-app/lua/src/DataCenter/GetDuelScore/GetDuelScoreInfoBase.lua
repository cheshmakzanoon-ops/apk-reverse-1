local GetDuelScoreInfoBase = BaseClass("GetDuelScoreInfoBase")

local function __init(self, scoreType)
  self.curScore = nil
  self.scoreType = scoreType
  self.scoreData = nil
  self.speedScoreCfgs = {}
  self.targetScoreList = {}
end

local function __delete(self)
  self.curScore = nil
  self.scoreType = nil
  self.scoreData = nil
  self.speedScoreCfgs = nil
  self.targetScoreList = nil
end

local function SetCurScore(self, curScore)
  if self.curScore == nil then
    self.curScore = curScore
  end
end

local function CheckAndOpenGetDuelScoreView(self, oldScore, isDiff)
  local isOn = DataCenter.GetDuelScoreManager:GetIsOnByType(self.scoreType)
  if isOn and not BattleFieldUtil.InBattleField() and self.targetScoreList and #self.targetScoreList > 0 and oldScore < self.targetScoreList[#self.targetScoreList] then
    DataCenter.GetDuelScoreManager:OpenGetDuelScoreView(self.scoreType, oldScore, self.curScore, self.targetScoreList, isDiff)
  end
end

local function ServerAddScore(self, curScore, addScore)
  if curScore == self.curScore then
    return
  end
  if self.curScore == nil then
    self.curScore = 0
  end
  local isDiff = false
  local oldScore = curScore - addScore
  self.curScore = curScore
  CheckAndOpenGetDuelScoreView(self, oldScore, isDiff)
end

local function FakeAddScore(self, addScore)
  if self.curScore == nil then
    self.curScore = 0
  end
  local oldScore = self.curScore
  self.curScore = self.curScore + addScore
  CheckAndOpenGetDuelScoreView(self, oldScore)
end

local function OnPushScoreChange(self, data)
end

local function OnSetScoreData(self, data)
end

local function OnUseSpeed(self, scoreValue, speedNum)
end

local function Clear(self)
  self.curScore = nil
  self.scoreData = nil
  self.speedScoreCfgs = nil
  self.targetScoreGroups = nil
end

GetDuelScoreInfoBase.__init = __init
GetDuelScoreInfoBase.__delete = __delete
GetDuelScoreInfoBase.__delete = __delete
GetDuelScoreInfoBase.SetCurScore = SetCurScore
GetDuelScoreInfoBase.ServerAddScore = ServerAddScore
GetDuelScoreInfoBase.FakeAddScore = FakeAddScore
GetDuelScoreInfoBase.OnPushScoreChange = OnPushScoreChange
GetDuelScoreInfoBase.OnSetScoreData = OnSetScoreData
GetDuelScoreInfoBase.OnUseSpeed = OnUseSpeed
GetDuelScoreInfoBase.Clear = Clear
return GetDuelScoreInfoBase
