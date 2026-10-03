local PushHunterMvpInfoMessage = BaseClass("PushHunterMvpInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushHunterMvpInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushHunterMvpInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if table.IsNullOrEmpty(t) then
    return
  end
  DataCenter.SeasonHunterManager:ShowMvp(t)
end

function PushHunterMvpInfoMessage:GetTestData()
  local data = {
    killMvpInfo = {
      careerType = 102,
      headSkinET = 0,
      gender = 0,
      level = 30,
      monthCardEndTime = 0,
      countryflag = "KR",
      pic = "",
      serverId = 555,
      picVer = 0,
      uid = "74287614266000555",
      score = "2",
      headSkinId = 20012,
      careerLevel = 100,
      name = "74287614266",
      power = 207386056,
      abbr = "FL0"
    },
    scoreMvpInfo = {
      careerType = 102,
      headSkinET = 0,
      gender = 0,
      level = 30,
      monthCardEndTime = 0,
      countryflag = "KR",
      pic = "",
      serverId = 555,
      picVer = 0,
      uid = "74287614266000555",
      score = "6",
      headSkinId = 20012,
      careerLevel = 100,
      name = "74287614266",
      power = 207386056,
      abbr = "FL0"
    },
    lifeTimeMvpInfo = {
      careerType = 102,
      headSkinET = 0,
      gender = 0,
      level = 30,
      monthCardEndTime = 0,
      countryflag = "KR",
      pic = "",
      serverId = 555,
      picVer = 0,
      uid = "74287614266000555",
      score = "3414049",
      headSkinId = 20012,
      careerLevel = 100,
      name = "74287614266",
      power = 207386056,
      abbr = "FL0"
    }
  }
  return data
end

return PushHunterMvpInfoMessage
