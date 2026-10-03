local ActMigrationPlayerData = BaseClass("ActMigrationPlayerData")

function ActMigrationPlayerData:__init()
  self.uid = ""
  self.serverId = 0
  self.pic = ""
  self.picVer = 0
  self.headSkinId = 0
  self.name = ""
  self.abbr = ""
  self.alName = ""
  self.power = 0
  self.identity = 1
  self.score = 0
  self.applyScore = 0
  self.message = ""
  self.time = 0
  self.flag = ""
  self.praise = 0
  self.online = 0
  self.applyState = 0
  self.bInvited = false
  self.lv = 0
  self.countryflag = ""
end

function ActMigrationPlayerData:__delete()
  self.uid = ""
  self.serverId = 0
  self.pic = ""
  self.picVer = 0
  self.headSkinId = 0
  self.name = ""
  self.abbr = ""
  self.alName = ""
  self.power = 0
  self.identity = 1
  self.score = 0
  self.applyScore = 0
  self.message = ""
  self.time = 0
  self.flag = ""
  self.praise = 0
  self.online = 0
  self.applyState = 0
  self.bInvited = false
  self.lv = 0
  self.countryflag = ""
end

function ActMigrationPlayerData:ParseData(t)
  if t == nil then
    return
  end
  if t.serverId then
    self.serverId = t.serverId
  end
  if t.uid then
    self.uid = t.uid
  end
  if t.pic then
    self.pic = t.pic
  end
  if t.picVer then
    self.picVer = t.picVer
  end
  if t.headSkinId then
    self.headSkinId = t.headSkinId
  end
  if t.picVer then
    self.picVer = t.picVer
  end
  if t.name then
    self.name = t.name
  end
  if t.abbr then
    self.abbr = t.abbr
  end
  if t.alName then
    self.alName = t.alName
  end
  if t.power then
    self.power = t.power
  end
  if t.identity then
    self.identity = t.identity
  end
  if t.score then
    self.score = t.score
  end
  if t.applyScore then
    self.applyScore = t.applyScore
  end
  if t.message then
    self.message = t.message
  end
  if t.time then
    self.time = t.time
  end
  if t.flag then
    self.flag = t.flag
  end
  if t.countryflag then
    self.countryflag = t.countryflag
  end
  if t.praise then
    self.praise = t.praise
  end
  if t.online then
    self.online = t.online
  end
  if t.applyState then
    self.applyState = t.applyState
  end
  if t.bInvited then
    self.bInvited = t.bInvited
  end
  if t.lv then
    self.lv = t.lv
  end
end

return ActMigrationPlayerData
