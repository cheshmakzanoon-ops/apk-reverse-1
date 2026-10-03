local ParkourGhostNpcTemplate = BaseClass("ParkourGhostNpcTemplate")

function ParkourGhostNpcTemplate:__init()
  self.id = nil
  self.tier = nil
  self.road = nil
  self.time = nil
  self.icon = nil
  self.name = nil
  self.playback = nil
  self.type = nil
end

function ParkourGhostNpcTemplate:__delete()
  self.id = nil
  self.tier = nil
  self.road = nil
  self.time = nil
  self.icon = nil
  self.name = nil
  self.playback = nil
  self.type = nil
end

function ParkourGhostNpcTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.tier = row:getValue("tier")
  self.road = row:getValue("road")
  self.time = row:getValue("time")
  self.icon = row:getValue("icon")
  self.name = row:getValue("name")
  self.playback = row:getValue("playback")
  self.type = row:getValue("type")
end

return ParkourGhostNpcTemplate
