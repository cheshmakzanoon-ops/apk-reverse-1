local AllianceInvitePlayerMessage = BaseClass("AllianceInvitePlayerMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, playerIdList, playerUid)
  base.OnCreate(self)
  if playerIdList ~= nil and 0 < #playerIdList then
    local str = ""
    str = playerIdList[1]
    if #playerIdList == 1 then
      self.sfsObj:PutUtfString("playerId", str)
    else
      for i = 2, #playerIdList do
        str = str .. ";" .. playerIdList[i]
      end
      self.sfsObj:PutUtfString("playerArr", str)
    end
  elseif playerUid then
    self.sfsObj:PutUtfString("playerId", playerUid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(391050)
  end
end

AllianceInvitePlayerMessage.OnCreate = OnCreate
AllianceInvitePlayerMessage.HandleMessage = HandleMessage
return AllianceInvitePlayerMessage
