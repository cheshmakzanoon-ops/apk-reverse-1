local GoldTreeOpenCardMessage = BaseClass("GoldTreeOpenCardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GoldTreeOpenCardMessage:OnCreate(day, weekTime)
  base.OnCreate(self)
  self.sfsObj:PutLong("weekTime", weekTime or UITimeManager:GetInstance():GetServerTime())
  self.sfsObj:PutInt("day", day or UITimeManager:GetInstance():GetNowWeekdayIndex())
end

function GoldTreeOpenCardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonGoldTreeManager:GoldTreeOpenCardMessage(t)
end

function GoldTreeOpenCardMessage:GetTestData(param)
  local day = param or 2
  local data = {
    cardReward = {
      {
        type = 7,
        value = {
          itemId = "211106",
          rewardAdd = 2,
          use = "1",
          count = 2,
          para1 = "2010",
          para2 = "10000",
          uuid = "e557f6f297a4469cac39b8f90d01eb36"
        }
      }
    },
    _id = 177,
    day = day,
    _time = 20,
    userGoldTreeDataInfo = {
      userGoldTeeInfo = {
        uid = "7301234728000123",
        combinationId = 0,
        weekTime = 1746979200000,
        settle = 0,
        seasonFirstFinishPowerTime = 1747104387730,
        startTime = 1747411200000,
        endTime = 1748016000000,
        uuid = 1240964836007902109,
        goldTreeConfigId = 10001
      },
      weekTime = 1746979200000,
      userGoldTreeCardArr = {
        {
          uid = "7301234728000123",
          multiplierId = math.random(1, 5),
          cardId = 5,
          rewardRecord = {
            {
              type = 7,
              value = {
                itemId = "520018",
                otherPara = "",
                rewardAdd = 2,
                use = "1",
                count = 46,
                para1 = "520005,1|520006,1|520007,1",
                uuid = "5530016283757921"
              }
            }
          },
          uuid = 1240971148544473963,
          day = day,
          targetUuid = 1240964836007902109
        }
      }
    }
  }
  if 6 <= day then
    data.combinationRewardArr = {
      {
        type = 7,
        value = {
          itemId = "200211",
          otherPara = "",
          rewardAdd = 50,
          use = "0",
          count = 4857,
          para1 = "7",
          para2 = "1",
          para3 = "300",
          uuid = "5523241308127676"
        }
      }
    }
  end
  return data
end

function GoldTreeOpenCardMessage:GetTest2(day)
  local data = {
    cardReward = {
      {
        type = 7,
        value = {
          itemId = "200211",
          otherPara = "",
          rewardAdd = 20,
          use = "0",
          count = 4807,
          para1 = "7",
          para2 = "1",
          para3 = "300",
          uuid = "5523241308127676"
        }
      }
    },
    _id = 173,
    day = day,
    _time = 84,
    userGoldTreeDataInfo = {
      userGoldTeeInfo = {
        uid = "7284694201000699",
        combinationId = 8,
        weekTime = 1746374400000,
        settle = 1,
        seasonFirstFinishPowerTime = 1745932052840,
        startTime = 1746460800000,
        endTime = 1747065600000,
        uuid = 1236859927927110448,
        goldTreeConfigId = 10001
      },
      weekTime = 1746374400000,
      userGoldTreeCardArr = {
        {
          uid = "7284694201000699",
          multiplierId = 1,
          cardId = 1,
          uuid = 1236859927981636408,
          day = day,
          targetUuid = 1236859927927110448,
          rewardRecord = 1
        }
      }
    }
  }
  return data
end

return GoldTreeOpenCardMessage
