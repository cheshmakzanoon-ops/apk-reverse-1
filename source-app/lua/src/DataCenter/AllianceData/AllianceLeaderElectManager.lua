local AllianceLeaderElectManager = BaseClass("AllianceLeaderElectManager")

local function __init(self)
  self.leaderCandidates = {}
  self.autoJoin = 0
  self.autoJoinTimer = nil
  self:AddListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function __delete(self)
  self.leaderCandidates = nil
  self.autoJoin = nil
  self.autoJoinTimer = nil
end

local function UpdateCandidates(self, msg)
  self.leaderCandidates = {}
  for i, v in ipairs(msg.candidateInfo) do
    table.insert(self.leaderCandidates, v)
  end
end

local function UpdateOneCandidateInfo(self, candidate)
  if self.leaderCandidates then
    for i, v in ipairs(self.leaderCandidates) do
      if v.uid == candidate.uid then
        v.voteNum = candidate.voteNum
        v.name = candidate.name
        v.pic = candidate.pic
        v.picVer = candidate.picVer
        break
      end
    end
  end
end

local function UpdateAutoJoinSignal(self, autoJoin)
  self.autoJoin = autoJoin
  if self.autoJoin == 1 then
    self:AddAutoJoinTimer()
  else
    self:DelAutoJoinTimer()
  end
end

local function AddAutoJoinTimer(self)
  if self.autoJoinTimer == nil then
    self.autoJoinTimer = TimerManager:GetInstance():GetTimer(0.5, function()
      self:DelAutoJoinTimer()
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("390866"), 2, nil, nil, function()
        SFSNetwork.SendMessage(MsgDefines.AutoJoinAlliance)
      end, function()
        SFSNetwork.SendMessage(MsgDefines.AutoJoinAlliance)
      end, function()
        SFSNetwork.SendMessage(MsgDefines.AutoJoinAlliance)
      end)
    end, self, true, false, false)
    self.autoJoinTimer:Start()
  end
end

local function DelAutoJoinTimer(self)
  if self.autoJoinTimer ~= nil then
    self.autoJoinTimer:Stop()
    self.autoJoinTimer = nil
  end
end

local function GetAlLeaderCandidates(self)
  return self.leaderCandidates
end

local function GetAlLeaderVoteStatus(self)
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  if not hasAlliance then
    return 1
  else
    local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceBaseData.sysAlState == 2 then
      if allianceBaseData.voted == 0 then
        return 0
      else
        return 3
      end
    else
      return 2
    end
  end
end

local function GetAlLeaderElectStatus(self)
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  if not hasAlliance then
    return 1
  else
    local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceBaseData.sysAlState == 1 then
      if allianceBaseData.elected == 0 then
        return 0
      else
        return 3
      end
    else
      return 2
    end
  end
end

local function IsAutoJoin(self)
  return self.autoJoin == 1
end

AllianceLeaderElectManager.__init = __init
AllianceLeaderElectManager.__delete = __delete
AllianceLeaderElectManager.AddListener = AddListener
AllianceLeaderElectManager.RemoveListener = RemoveListener
AllianceLeaderElectManager.UpdateCandidates = UpdateCandidates
AllianceLeaderElectManager.UpdateOneCandidateInfo = UpdateOneCandidateInfo
AllianceLeaderElectManager.GetAlLeaderVoteStatus = GetAlLeaderVoteStatus
AllianceLeaderElectManager.GetAlLeaderElectStatus = GetAlLeaderElectStatus
AllianceLeaderElectManager.GetAlLeaderCandidates = GetAlLeaderCandidates
AllianceLeaderElectManager.UpdateAutoJoinSignal = UpdateAutoJoinSignal
AllianceLeaderElectManager.AddAutoJoinTimer = AddAutoJoinTimer
AllianceLeaderElectManager.DelAutoJoinTimer = DelAutoJoinTimer
AllianceLeaderElectManager.IsAutoJoin = IsAutoJoin
return AllianceLeaderElectManager
