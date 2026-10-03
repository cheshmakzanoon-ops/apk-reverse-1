local HeroEquipRecommendSwitchMessage = BaseClass("HeroEquipRecommendSwitchMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

local function OnCreate(self, squadIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("formationIndex", squadIndex)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.EquipRecommendManager:OnSetSquadIndexCallback(message)
end

HeroEquipRecommendSwitchMessage.OnCreate = OnCreate
HeroEquipRecommendSwitchMessage.HandleMessage = HandleMessage
return HeroEquipRecommendSwitchMessage
