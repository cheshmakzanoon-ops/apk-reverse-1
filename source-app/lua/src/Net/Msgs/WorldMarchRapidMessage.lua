local WorldMarchRapidMessage = BaseClass("WorldMarchRapidMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, itemId, isBuy)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", tonumber(uuid))
  self.sfsObj:PutUtfString("itemId", tostring(itemId))
  self.sfsObj:PutInt("itemNum", 1)
  self.sfsObj:PutBool("useGold", isBuy)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.remainGold and LuaEntry.Player.gold ~= t.remainGold then
    LuaEntry.Player.gold = t.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

WorldMarchRapidMessage.OnCreate = OnCreate
WorldMarchRapidMessage.HandleMessage = HandleMessage
return WorldMarchRapidMessage
