local FreeBuildingPlaceNewMessage = BaseClass("FreeBuildingPlaceNewMessage", SFSBaseMessage)
local base = SFSBaseMessage
local isPlayAnimation = false

local function OnCreate(self, param, isPlay)
  if isPlay == nil then
    isPlayAnimation = true
  else
    isPlayAnimation = isPlay
  end
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("buildingId", param.buildingId)
    self.sfsObj:PutInt("pointId", param.pointId)
    self.sfsObj:PutInt("pathTime", param.pathTime)
    if param.itemUuid ~= nil and param.itemUuid ~= "" then
      self.sfsObj:PutUtfString("itemUuid", param.itemUuid)
    end
    self.sfsObj:PutLong("robotUuid", param.robotUuid)
    self.sfsObj:PutInt("targetServer", param.targetServerId)
    if param.heroId ~= nil then
      self.sfsObj:PutInt("heroId", param.heroId)
    end
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.BuildManager:FreeBuildingPlaceNewHandle(message, isPlayAnimation)
end

FreeBuildingPlaceNewMessage.OnCreate = OnCreate
FreeBuildingPlaceNewMessage.HandleMessage = HandleMessage
return FreeBuildingPlaceNewMessage
