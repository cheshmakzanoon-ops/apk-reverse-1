local AccountScoreData = BaseClass("AccountScoreData")

function AccountScoreData:__init()
  self.uuid = ""
  self.status = nil
  self.cardId = ""
  self.cardPoint = 0
end

function AccountScoreData:__delete()
  self.uuid = nil
  self.status = nil
  self.cardId = nil
  self.cardPoint = nil
end

function AccountScoreData:ParseData(data)
  if data == nil then
    return
  end
  self.uuid = LuaEntry.Player:GetUid()
  self.status = data.status or 0
  self.cardId = data.cardId or ""
  self.cardPoint = data.point or 0
end

function AccountScoreData:GetUUID()
  return self.uuid
end

function AccountScoreData:GetStatus()
  return self.status == 1
end

function AccountScoreData:GetCardId()
  return self.cardId
end

function AccountScoreData:GetCardPoint()
  return self.cardPoint
end

return AccountScoreData
