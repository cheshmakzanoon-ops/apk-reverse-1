local WeaponInfoViewMessage = BaseClass("WeaponInfoViewMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid, serverId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWMyStationDataManager:OnGetEnemyWeaponInfo(message)
  DataCenter.TacticalWeaponManager:OnGetOtherPlayerWeaponInfo(message)
end

WeaponInfoViewMessage.OnCreate = OnCreate
WeaponInfoViewMessage.HandleMessage = HandleMessage
return WeaponInfoViewMessage
