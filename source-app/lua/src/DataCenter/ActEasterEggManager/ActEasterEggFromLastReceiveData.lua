local ActEasterEggFromLastReceiveData = BaseClass("ActEasterEggFromLastReceiveData")

function ActEasterEggFromLastReceiveData:__init()
  self.playerList = {}
  self.praise = 0
  self.comment = 0
  self.praiseItemNum = 0
  self.commentItemNum = 0
  self.historyPraiseObj = {}
  self.historyCommentObj = {}
end

function ActEasterEggFromLastReceiveData:__delete()
  self.playerList = nil
  self.praise = nil
  self.comment = nil
  self.praiseItemNum = nil
  self.commentItemNum = nil
  self.historyPraiseObj = nil
  self.historyCommentObj = nil
end

function ActEasterEggFromLastReceiveData:UpdateServerData(message)
  if not message then
    return
  end
  self.playerList = message.playerList
  self.praise = message.praise
  self.comment = message.comment
  self.praiseItemNum = message.praiseItemNum
  self.commentItemNum = message.commentItemNum
  self.historyPraiseObj = message.historyPraiseObj
  self.historyCommentObj = message.historyCommentObj
end

function ActEasterEggFromLastReceiveData:GetShowThumbsUpView()
  return self.playerList and table.count(self.playerList) > 0
end

function ActEasterEggFromLastReceiveData:GetIfReachMax()
  local eggConfig = DataCenter.ActEasterEggManager:GetEggConfigData()
  local coinsThumbsGive = eggConfig.thumbUpGiveItemNum
  local coinsCommitGive = eggConfig.commentGiveItemNum
  local maxThumbsGive = coinsThumbsGive * self.praise
  local maxCommentGive = coinsCommitGive * self.comment
  return maxThumbsGive > self.praiseItemNum, maxCommentGive > self.commentItemNum
end

function ActEasterEggFromLastReceiveData:GetFakeData()
  local data = {}
  data.praise = 10000
  data.praiseItemNum = 1
  data.comment = 10000
  data.commentItemNum = 1
  data.playerList = {}
  for i = 1, 20 do
    local playerInfo = {}
    playerInfo.uid = "7390003701000128"
    playerInfo.picVer = 0
    playerInfo.pic = ""
    playerInfo.playerName = "\231\142\169\229\174\182" .. i
    table.insert(data.playerList, playerInfo)
  end
  data.historyPraiseObj = {}
  data.historyCommentObj = {}
  for i = 1, 5 do
    data.historyPraiseObj[i] = 1000
  end
  for i = 1, 5 do
    data.historyCommentObj[i] = 1000
  end
  return data
end

return ActEasterEggFromLastReceiveData
