local HeroStationSaveMessage = BaseClass("HeroStationSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, stationData)
  base.OnCreate(self)
  self.sfsObj:PutInt("stationId", stationData.stationId)
  local heroInfos = stationData.heroInfos
  if heroInfos then
    if heroInfos.AddSFSObject then
      self.sfsObj:PutSFSArray("heroInfos", heroInfos)
    else
      local heroArray = SFSArray.New()
      table.walk(heroInfos, function(k, v)
        local key = k
        if type(key) == "number" then
          key = tostring(key)
        end
        local obj = SFSObject.New()
        obj:PutLong("heroUuid", v)
        obj:PutUtfString("index", key)
        heroArray:AddSFSObject(obj)
      end)
      self.sfsObj:PutSFSArray("heroInfos", heroArray)
    end
  else
    Logger.LogError("heroInfos is nil")
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.HeroStationManager:HandleHeroStationSaveMessage(t)
end

HeroStationSaveMessage.OnCreate = OnCreate
HeroStationSaveMessage.HandleMessage = HandleMessage
return HeroStationSaveMessage
