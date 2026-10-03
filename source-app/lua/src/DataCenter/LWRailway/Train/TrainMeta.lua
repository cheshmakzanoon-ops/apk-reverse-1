local TrainMeta = BaseClass("TrainMeta")

local function __init(self)
  self.id = 0
  self.quality = 0
  self.length = 0
  self.speed = 0
end

local function __delete(self)
  self.id = nil
end

local function InitConfig(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.quality = tonumber(row:getValue("quality")) or 0
  self.length = tonumber(row:getValue("length")) or 0
  self.speed = tonumber(row:getValue("speed")) or 0
  self.type = tonumber(row:getValue("type")) or 1
  self.world_model = row:getValue("world_model")
  self.city_model = row:getValue("city_model")
  self.icon = row:getValue("icon")
  self.bg_icon = row:getValue("bg_icon")
  self.share_icon = row:getValue("share_icon")
end

TrainMeta.__init = __init
TrainMeta.__delete = __delete
TrainMeta.InitConfig = InitConfig
return TrainMeta
