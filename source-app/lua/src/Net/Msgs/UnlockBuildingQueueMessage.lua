local UnlockBuildingQueueMessage = BaseClass("UnlockBuildingQueueMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  else
    if t.robot ~= nil then
      DataCenter.BuildQueueManager:UpdateQueueData(t.robot)
    end
    if t.remainGold ~= nil then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if t.resource ~= nil then
      LuaEntry.Resource:UpdateResource(t.resource)
    end
    UIUtil.ShowTipsId(280174)
  end
end

UnlockBuildingQueueMessage.OnCreate = OnCreate
UnlockBuildingQueueMessage.HandleMessage = HandleMessage
return UnlockBuildingQueueMessage
