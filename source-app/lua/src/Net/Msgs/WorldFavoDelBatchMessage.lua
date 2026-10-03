local WorldFavoDelBatchMessage = BaseClass("WorldFavoDelBatchMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, list)
  base.OnCreate(self)
  if not list or #list <= 0 then
    return
  end
  local array = SFSArray.New()
  for k, v in ipairs(list) do
    local sfs = SFSObject.New()
    sfs:PutInt("point", v.pos)
    sfs:PutInt("type", v.type)
    sfs:PutInt("server", v.server)
    sfs:PutInt("worldId", v.worldId)
    array:AddSFSObject(sfs)
  end
  self.sfsObj:PutSFSArray("points", array)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.state == 1 then
    DataCenter.WorldFavoDataManager:DelBookmarkBatch(t.points)
    EventManager:GetInstance():Broadcast(EventId.RefreshBookmark)
    UIUtil.ShowTipsId(280154)
  end
end

WorldFavoDelBatchMessage.OnCreate = OnCreate
WorldFavoDelBatchMessage.HandleMessage = HandleMessage
return WorldFavoDelBatchMessage
