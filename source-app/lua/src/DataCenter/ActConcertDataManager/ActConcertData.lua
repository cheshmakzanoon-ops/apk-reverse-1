local ActConcertData = BaseClass("ActConcertData")

function ActConcertData:__init()
  self.uid = ""
  self.layer = 0
  self.statusId = 0
  self.expireTime = 0
  self.praise = 0
  self.pointId = 0
  self.partyId = ""
  self.info = {}
end

function ActConcertData:__delete()
  self.uid = nil
  self.layer = nil
  self.statusId = nil
  self.expireTime = nil
  self.praise = nil
  self.pointId = nil
  self.partyId = nil
  self.info = nil
end

function ActConcertData:ParseData(message)
  if not message then
    Logger.LogError("ActConcertData:ParseData - message is nil")
    return
  end
  self.uid = message.uid or ""
  self.layer = message.layer or 0
  self.statusId = message.statusId or 0
  self.expireTime = message.expireTime or 0
  self.praise = message.praise or 0
  self.info = message.info or {}
  self.pointId = message.pointId or 0
  self.partyId = message.partyId
end

return ActConcertData
