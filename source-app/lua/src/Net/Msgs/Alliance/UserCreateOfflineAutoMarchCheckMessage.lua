local UserCreateOfflineAutoMarchCheckMessage = BaseClass("UserCreateOfflineAutoMarchCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage
local CITY_ID = 0
local Localization = CS.GameEntry.Localization

local function OnCreate(self, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  CITY_ID = cityId
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.member and t.member > 0 then
    UIUtil.ShowMessage(Localization:GetString("\231\161\174\232\174\164\230\180\190\233\129\163{0}\228\189\141\228\184\141\229\156\168\231\186\191\231\154\132\230\140\135\230\140\165\229\174\152\231\154\132\233\131\168\233\152\159\230\148\187\229\135\187\229\159\142\229\184\130\239\188\159" .. t.member, t.member), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.UserCreateOfflineAutoMarch, CITY_ID)
    end)
  else
    UIUtil.ShowTipsId("\229\189\147\229\137\141\230\178\161\230\156\137\230\140\135\230\140\165\229\174\152\229\143\175\228\187\165\229\147\141\229\186\148\229\133\168\229\134\155\229\135\186\229\135\187\230\140\135\228\187\164\239\188\140\230\147\141\228\189\156\229\164\177\232\180\165\239\188\129")
  end
end

UserCreateOfflineAutoMarchCheckMessage.OnCreate = OnCreate
UserCreateOfflineAutoMarchCheckMessage.HandleMessage = HandleMessage
return UserCreateOfflineAutoMarchCheckMessage
