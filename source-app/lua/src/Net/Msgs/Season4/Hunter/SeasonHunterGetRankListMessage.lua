local SeasonHunterGetRankListMessage = BaseClass("SeasonHunterGetRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonHunterGetRankListMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

function SeasonHunterGetRankListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonHunterManager:SeasonHunterGetRankList(t)
end

function SeasonHunterGetRankListMessage:GetTestData(type)
  local data = {lbType = type}
  local owner = {}
  owner.score = 1000
  owner.rank = 1
  data.owner = owner
  local rankArr = {}
  local max = math.random(0, 100)
  for i = 1, max do
    local rank = {}
    rank.careerType = 102
    rank.headSkinET = 0
    rank.gender = math.random(1, 3)
    rank.level = math.random(1, 35)
    rank.countryflag = "UN"
    rank.pic = ""
    rank.serverId = math.random(745, 752)
    rank.picVer = 0
    rank.uid = tostring(math.random(1000000000000000, 9999999999999999))
    rank.score = math.random(1000, 100000)
    rank.chatBubbleId = 50006
    rank.headSkinId = 21016
    rank.careerLevel = math.random(1, 70)
    rank.name = rank.uid
    rank.headFrame = ""
    rank.rank = i
    rank.chatBubbleET = 0
    rank.power = math.random(100000, 100000000)
    rank.abbr = ""
    rankArr[i] = rank
  end
  data.rankArr = rankArr
  return data
end

return SeasonHunterGetRankListMessage
