local HeroEquipRecommendOpenMessage = BaseClass("HeroEquipRecommendOpenMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.EquipRecommendManager:OnFunctionOpenPushCallback(message)
end

HeroEquipRecommendOpenMessage.OnCreate = OnCreate
HeroEquipRecommendOpenMessage.HandleMessage = HandleMessage
return HeroEquipRecommendOpenMessage
