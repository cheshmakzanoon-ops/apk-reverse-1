local SeasonDigGameGetPersonalRewardMessage = BaseClass("SeasonDigGameGetPersonalRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.DiggingDataManager:OnGetReward(t)
end

local function GetTestData(self, uuid)
  local mapData = DataCenter.DiggingDataManager.curMapData
  if mapData == nil then
    return
  end
  if mapData.rewardState == 0 or mapData.rewardState == 2 then
    return
  end
  if mapData.type ~= SeasonDigGameType.Single then
    return
  end
  local t = {}
  t.uuid = uuid
  t.reward = {
    [1] = {
      type = RewardType.GOODS,
      value = {
        uuid = "5497731772507372",
        count = 6545,
        itemId = "200201",
        otherPara = "",
        para1 = "1",
        para2 = "1",
        para3 = "300",
        rewardAdd = 10,
        use = "0"
      }
    }
  }
  mapData = DataCenter.DiggingDataManager.__Cache[uuid]
  mapData.rewardState = 1
  return t
end

SeasonDigGameGetPersonalRewardMessage.GetTestData = GetTestData
SeasonDigGameGetPersonalRewardMessage.OnCreate = OnCreate
SeasonDigGameGetPersonalRewardMessage.HandleMessage = HandleMessage
return SeasonDigGameGetPersonalRewardMessage
