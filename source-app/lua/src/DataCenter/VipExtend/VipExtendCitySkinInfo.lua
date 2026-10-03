local VipExtendCitySkinInfo = BaseClass("VipExtendCitySkinInfo")

function VipExtendCitySkinInfo:__init()
  self.ifDisplay = 0
  self.displayType = 0
  self.displayPara1 = 0
  self.playerInfo = 0
  self.displayPara3 = ""
  self.anonymity = 0
  self.id = 0
  self.displayPara2 = ""
  self.playerId = ""
end

function VipExtendCitySkinInfo:__delete()
  self.ifDisplay = nil
  self.displayType = nil
  self.displayPara1 = nil
  self.playerInfo = nil
  self.id = nil
  self.anonymity = nil
  self.displayPara2 = nil
  self.displayPara3 = nil
  self.playerId = nil
end

function VipExtendCitySkinInfo:UpdateInfo(message)
  if message == nil then
    Logger.LogError("[VipExtend]  message is nil")
    return
  end
  self.isShow = message.ifDisplay == 1
  self.displayType = message.displayType
  self.displayPara1 = message.displayPara1
  self.playerInfo = message.playerInfo
  self.id = message.id
  self.anonymity = message.anonymity
  self.displayPara2 = message.displayPara2
  self.displayPara3 = message.displayPara3
  self.playerId = message.playerId
end

return VipExtendCitySkinInfo
