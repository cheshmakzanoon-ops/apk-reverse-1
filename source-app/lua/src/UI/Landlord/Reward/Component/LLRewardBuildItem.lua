local base = require("UI.Landlord.Reward.Component.LLRewardBaseItem")
local LLRewardBuildItem = BaseClass("LLRewardBuildItem", base)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLRewardBuildItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRewardBuildItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRewardBuildItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compLock = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textLockTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
end

function LLRewardBuildItem:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
  self.imgIcon = nil
  self.textName = nil
  self.textDesc = nil
  self.compLock = nil
  self.textLockTip = nil
  self.textTip = nil
end

function LLRewardBuildItem:DataDefine()
end

function LLRewardBuildItem:DataDestroy()
end

function LLRewardBuildItem:OnAddListener()
  base.OnAddListener(self)
end

function LLRewardBuildItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRewardBuildItem:SetData(id, camp)
  local template = ActMgr:GetCityTypeConfig(id)
  if template == nil then
    return
  end
  local cityTemplate = ActMgr:GetCityTemplate(template.city_id)
  if cityTemplate ~= nil then
    self.imgIcon:LoadSpriteAuto(cityTemplate:GetIconPath())
  end
  self.textName:SetLocalText(template.name)
  self.textDesc:SetLocalText(template.desc)
  local unlockWeek = template.defend_reward_unlock_week
  local bLock = unlockWeek > ActMgr:GetCurWeek()
  self.textTip:SetActive(not bLock)
  self.compLock:SetActive(bLock)
  if bLock then
    self.textLockTip:SetLocalText("zonewar_landlord_limit_1015", unlockWeek + 1)
  end
  local rewardId = camp == LLConst.LandLordGroup.LORD and template.defend_reward or template.destroy_reward
  self:RefreshIcons(rewardId)
end

return LLRewardBuildItem
