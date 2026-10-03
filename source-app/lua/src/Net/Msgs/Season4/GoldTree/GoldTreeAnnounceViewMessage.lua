local GoldTreeAnnounceViewMessage = BaseClass("GoldTreeAnnounceViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GoldTreeAnnounceViewMessage:OnCreate(weekNum, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("weekNum", weekNum or 0)
  self.sfsObj:PutInt("serverId", serverId or LuaEntry.Player:GetSourceServerId())
end

function GoldTreeAnnounceViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonGoldTreeManager:GoldTreeAnnounceViewMessage(t)
end

function GoldTreeAnnounceViewMessage:GetTestData(weekNum, serverId)
  weekNum = weekNum or 1
  serverId = serverId or LuaEntry.Player:GetSourceServerId()
  local data = {
    weekNum = weekNum,
    serverId = serverId,
    announceArr = {
      {
        combinationId = 1,
        userArr = {
          self:GetUserData(serverId),
          self:GetUserData(serverId),
          self:GetUserData(serverId),
          self:GetUserData(serverId)
        }
      },
      {
        combinationId = 3,
        userArr = {
          self:GetUserData(serverId),
          self:GetUserData(serverId),
          self:GetUserData(serverId),
          self:GetUserData(serverId)
        }
      }
    }
  }
  return data
end

function GoldTreeAnnounceViewMessage:GetUserData(serverId)
  return {
    recordTime = math.random(1, 1745932052840),
    name = "\230\181\139\232\175\149\229\144\141\229\173\151" .. math.random(1, 100),
    uid = "7284694201000699",
    serverId = serverId,
    srcServer = serverId,
    abbr = "\230\181\139\232\175\149\232\129\148\231\155\159",
    pic = "pic",
    picver = 1,
    headFrame = 1,
    careerType = 1,
    careerLevel = 1,
    power = 1,
    gender = 1,
    countryflag = "CN",
    allianceId = "allianceId",
    allianceName = "\232\129\148\231\155\159\229\144\141\229\173\151"
  }
end

return GoldTreeAnnounceViewMessage
