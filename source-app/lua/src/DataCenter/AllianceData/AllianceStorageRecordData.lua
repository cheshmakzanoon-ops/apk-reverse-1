local AllianceStorageRecordData = BaseClass("AllianceStorageRecordData")

local function __init(self)
  self.uid = ""
  self.userName = ""
  self.pic = ""
  self.picVer = 0
  self.monthCardEndTime = 0
  self.careerType = CareerType.None
  self.careerLv = 0
  self.type = 1
  self.param = ""
  self.time = 0
  self.cost = {}
end

local function __delete(self)
  self.uid = nil
  self.userName = nil
  self.pic = nil
  self.picVer = nil
  self.monthCardEndTime = nil
  self.careerType = nil
  self.careerLv = nil
  self.type = nil
  self.param = nil
  self.time = nil
  self.cost = nil
end

local function ParseData(self, data)
  if data.uid then
    self.uid = data.uid
  end
  if data.userName then
    self.userName = data.userName
  end
  if data.pic then
    self.pic = data.pic
  end
  if data.picVer then
    self.picVer = data.picVer
  end
  if data.monthCardEndTime then
    self.monthCardEndTime = data.monthCardEndTime
  end
  if data.careerType then
    self.careerType = data.careerType
  end
  if data.careerLv then
    self.careerLv = data.careerLv
  end
  if data.type then
    self.type = data.type
  end
  if data.param then
    self.param = data.param
  end
  if data.time then
    self.time = data.time
  end
  self.cost = {}
  if data.cost then
    if data.cost.alliancePoint then
      local newOne = {
        rewardType = RewardType.ALLIANCE_POINT,
        count = data.cost.alliancePoint
      }
      table.insert(self.cost, newOne)
    end
    if data.cost.money then
      local newOne = {
        rewardType = RewardType.FOOD,
        count = data.cost.money
      }
      table.insert(self.cost, newOne)
    end
    if data.cost.electricity then
      local newOne = {
        rewardType = RewardType.ELECTRICITY,
        count = data.cost.electricity
      }
      table.insert(self.cost, newOne)
    end
    if data.cost.crystal then
      local newOne = {
        rewardType = RewardType.METAL,
        count = data.cost.crystal
      }
      table.insert(self.cost, newOne)
    end
    if data.cost.sapphire then
      local newOne = {
        rewardType = RewardType.SAPPHIRE,
        count = data.cost.sapphire
      }
      table.insert(self.cost, newOne)
    end
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

AllianceStorageRecordData.__init = __init
AllianceStorageRecordData.__delete = __delete
AllianceStorageRecordData.ParseData = ParseData
AllianceStorageRecordData.GetHeadBgImg = GetHeadBgImg
return AllianceStorageRecordData
