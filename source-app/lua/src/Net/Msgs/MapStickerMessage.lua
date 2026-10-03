local MapStickerMessage = BaseClass("MapStickerMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, uuid, stickerId, worldId, targetServer, numPara)
  base.OnCreate(self)
  if type then
    self.sfsObj:PutInt("type", type)
  end
  if uuid then
    self.sfsObj:PutLong("uuid", uuid)
  end
  if stickerId then
    self.sfsObj:PutInt("stickerId", stickerId)
  end
  if worldId then
    self.sfsObj:PutInt("worldId", worldId)
  end
  if targetServer then
    self.sfsObj:PutInt("targetServer", targetServer)
  end
  if numPara then
    self.sfsObj:PutInt("numPara", numPara)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

MapStickerMessage.OnCreate = OnCreate
MapStickerMessage.HandleMessage = HandleMessage
return MapStickerMessage
