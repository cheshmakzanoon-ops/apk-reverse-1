local FindMonsterBossMessage = BaseClass("FindMonsterBossMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, level, radarSearch)
  base.OnCreate(self)
  if level then
    level = math.modf(level)
    self.sfsObj:PutInt("level", level)
  end
  if radarSearch ~= nil then
    self.sfsObj:PutInt("radarSearch", radarSearch)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.RadarCenterDataManager:HandleFindMonsterBossBack(message)
end

FindMonsterBossMessage.OnCreate = OnCreate
FindMonsterBossMessage.HandleMessage = HandleMessage
return FindMonsterBossMessage
