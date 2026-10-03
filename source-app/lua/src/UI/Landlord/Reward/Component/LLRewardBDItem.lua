local base = require("UI.Landlord.Reward.Component.LLRewardBaseItem")
local LLRewardBDItem = BaseClass("LLRewardBDItem", base)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLRewardBDItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRewardBDItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRewardBDItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function LLRewardBDItem:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
  self.textDesc = nil
end

function LLRewardBDItem:DataDefine()
end

function LLRewardBDItem:DataDestroy()
end

function LLRewardBDItem:OnAddListener()
  base.OnAddListener(self)
end

function LLRewardBDItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRewardBDItem:SetData(_, camp)
  self.textDesc:SetLocalText(camp == LLConst.LandLordGroup.FARMER and "zonewar_landlord_desc_1002" or "zonewar_landlord_desc_1003")
  local rewardList = ActMgr:GetReward(LLConst.RewardType.BD, camp)
  local info = rewardList ~= nil and rewardList[1] or nil
  if info ~= nil then
    self:RefreshIcons(info.reward)
  end
end

return LLRewardBDItem
