local AlLeaderCandidateData = BaseClass("AlLeaderCandidateData")

local function __init(self)
  self.uid = ""
  self.power = 0
  self.voteNum = 0
  self.voteSlogan = ""
  self.name = ""
  self.pic = ""
  self.picVer = 0
  self.monthCardEndTime = 0
end

local function __delete(self)
  self.uid = nil
  self.power = nil
  self.voteNum = nil
  self.voteSlogan = nil
  self.name = nil
  self.pic = nil
  self.picVer = nil
  self.monthCardEndTime = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uid then
    self.uid = message.uid
  end
  if message.power then
    self.power = message.power
  end
  if message.voteNum then
    self.voteNum = message.voteNum
  end
  if message.declaration then
    self.voteSlogan = message.declaration
  end
  if message.name then
    self.name = message.name
  end
  if message.pic then
    self.pic = message.pic
  end
  if message.picVer then
    self.picVer = message.picVer
  end
  if message.monthCardEndTime then
    self.monthCardEndTime = message.monthCardEndTime
  end
end

local function GetHeadBgImg(self)
  local headBgImg
  local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
  if self.monthCardEndTime and serverTimeS < self.monthCardEndTime then
    headBgImg = "Common_playerbg_golloes"
  end
  if headBgImg and headBgImg ~= "" then
    return string.format(LoadPath.CommonNewPath, headBgImg)
  end
end

AlLeaderCandidateData.__init = __init
AlLeaderCandidateData.__delete = __delete
AlLeaderCandidateData.ParseData = ParseData
AlLeaderCandidateData.GetHeadBgImg = GetHeadBgImg
return AlLeaderCandidateData
