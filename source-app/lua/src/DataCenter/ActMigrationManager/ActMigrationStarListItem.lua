local ActMigrationStarListItem = BaseClass("ActMigrationStarListItem")

function ActMigrationStarListItem:__init(msg)
  self.id = msg.id
  self.identity = msg.identity
  self.minPersonScore = msg.minPersonScore
  self.maxPersonScore = msg.maxPersonScore
  self.servers = msg.servers
  self.index = 0
end

function ActMigrationStarListItem:__delete()
  self.id = nil
  self.identity = nil
  self.minPersonScore = nil
  self.maxPersonScore = nil
  self.servers = nil
  self.index = nil
end

function ActMigrationStarListItem:ServerCount()
  return self.servers and #self.servers or 0
end

function ActMigrationStarListItem:GetServerIDByIndex(index)
  return self.servers and self.servers[index]
end

function ActMigrationStarListItem:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("%s, %s, %s ~ %s", self.id, self.identity, self.minPersonScore, self.maxPersonScore)
  sb:AppendFormatLine("%s:%s", #self.servers, table.concat(self.servers, ","))
  return sb:ToString()
end

return ActMigrationStarListItem
