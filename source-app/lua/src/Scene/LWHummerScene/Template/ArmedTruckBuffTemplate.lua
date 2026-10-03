local ArmedTruckBuffTemplate = BaseClass("LWHummerSceneConfigTemplate")

function ArmedTruckBuffTemplate:__init()
  self.id = 0
  self.type = 0
  self.value = 0
  self.duration = 0
  self.maxAddNum = 0
end

function ArmedTruckBuffTemplate:__delete()
  self.id = nil
  self.type = nil
  self.value = nil
  self.duration = nil
  self.maxAddNum = nil
end

function ArmedTruckBuffTemplate:InitData(cfg)
  if cfg == nil then
    return
  end
  self.id = cfg:getValue("id")
  self.type = cfg:getValue("type")
  self.value = cfg:getValue("value")
  self.duration = cfg:getValue("duration")
  self.maxAddNum = cfg:getValue("maxAddNum")
end

return ArmedTruckBuffTemplate
