local GiveUpAlCityMessage = BaseClass("GiveUpAlCityMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, cityId, isCancel, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutInt("serverId", serverId or LuaEntry.Player:GetCurServerId())
  self.sfsObj:PutBool("isCancel", isCancel)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if toInt(t.giveUpTime) > 0 then
      local configTime = Mathf.Round(LuaEntry.DataConfig:TryGetNum("worldcity_s0", "k13", 3600) / 60)
      UIUtil.ShowTips(Localization:GetString(393063, showName, configTime))
    else
      UIUtil.ShowTipsId(393061)
    end
    DataCenter.WorldAllianceCityDataManager:UpdateOneGivingUpCity(t, true)
  end
end

GiveUpAlCityMessage.OnCreate = OnCreate
GiveUpAlCityMessage.HandleMessage = HandleMessage
return GiveUpAlCityMessage
