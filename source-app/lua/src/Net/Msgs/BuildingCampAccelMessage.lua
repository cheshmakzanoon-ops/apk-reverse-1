local BuildingCampAccelMessage = BaseClass("BuildingCampAccelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, itemId, useGold)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  if itemId then
    self.sfsObj:PutUtfString("itemId", itemId)
  end
  if useGold then
    self.sfsObj:PutInt("useGold", useGold)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildManager:HandleProduceBuildingUpgrade(message)
    if message.gold ~= nil then
      LuaEntry.Player.gold = message.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    EventManager:GetInstance():Broadcast(EventId.GF_building_training_speedup, message.buildInfo)
  end
end

BuildingCampAccelMessage.OnCreate = OnCreate
BuildingCampAccelMessage.HandleMessage = HandleMessage
return BuildingCampAccelMessage
