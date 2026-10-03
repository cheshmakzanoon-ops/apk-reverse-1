local TryThumbsUpMessage = BaseClass("TryThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function TryThumbsUpMessage:OnCreate(targetUid, thumbsUpType, content, extParam)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutUtfString("content", content)
  self.sfsObj:PutInt("type", thumbsUpType)
  if BattleFieldUtil.InBattleField() then
    self.sfsObj:PutInt("serverId", LuaEntry.Player:GetCrossServerId())
    self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
    self.sfsObj:PutInt("worldType", LuaEntry.Player:GetCurWorldType())
  end
  if extParam == nil then
    extParam = ""
  end
  self.sfsObj:PutUtfString("extParam", extParam)
end

function TryThumbsUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    InteractiveUtil.OnThumbsUpMessage(t)
  end
end

return TryThumbsUpMessage
