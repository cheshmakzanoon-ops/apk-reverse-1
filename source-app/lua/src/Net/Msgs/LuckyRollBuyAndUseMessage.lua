local LuckyRollBuyAndUseMessage = BaseClass("LuckyRollBuyAndUseMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, itemId, itemNum, actId, isTen)
  base.OnCreate(self)
  if itemId and itemNum then
    self.sfsObj:PutUtfString("itemId", tostring(itemId))
    self.sfsObj:PutInt("itemNum", itemNum)
    self.sfsObj:PutInt("activityId", actId)
    self.sfsObj:PutInt("isTen", isTen)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.gold then
      LuaEntry.Player.gold = t.gold
    end
    DataCenter.ActLuckyRollInfo:UpdateRollInfo(t)
    EventManager:GetInstance():Broadcast(EventId.ActLuckyRollGetReward, t)
  end
end

LuckyRollBuyAndUseMessage.OnCreate = OnCreate
LuckyRollBuyAndUseMessage.HandleMessage = HandleMessage
return LuckyRollBuyAndUseMessage
