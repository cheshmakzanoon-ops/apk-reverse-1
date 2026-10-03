local CampScienceBuffInfo = BaseClass("CampScienceBuffInfo")

function CampScienceBuffInfo:__init()
  self.type = 0
  self.value = 0
  self.buffId = 0
  self.config = nil
end

function CampScienceBuffInfo:__delete()
  self.type = nil
  self.value = nil
  self.buffId = nil
  self.config = nil
end

function CampScienceBuffInfo:ParseServer(message)
  if message == nil then
    return
  end
  if message.type then
    self.type = message.type
  end
  if message.value then
    self.value = message.value
  end
  if message.buffId then
    self.buffId = message.buffId
  end
  self.config = nil
  if self.buffId > 0 then
    self:ParseConfig()
  end
end

function CampScienceBuffInfo:ParseConfig()
  self.config = DataCenter.CampScienceTemplateManager:GetCampBuffTemplatesByID(self.buffId)
end

return CampScienceBuffInfo
