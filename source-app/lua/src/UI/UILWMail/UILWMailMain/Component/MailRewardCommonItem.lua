local MailRewardCommonItem = BaseClass("MailRewardCommonItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local mail_reward_item_path = "MailRewardItem"
local black_mask_item_path = "MailRewardItem/BlackMaskItem"
local hero_reward_item_path = "HeroRewardItem"
local black_mask_hero_path = "HeroRewardItem/BlackMaskHero"
local received_icon_path = "ReceivedIcon"

function MailRewardCommonItem:OnCreate()
  base.OnCreate(self)
  self.mail_reward_item = self:AddComponent(UICommonResItem, mail_reward_item_path)
  self.black_mask_item = self:AddComponent(UIImage, black_mask_item_path)
  self.hero_reward_item = self:AddComponent(HeroRewardItem, hero_reward_item_path)
  self.black_mask_hero = self:AddComponent(UIImage, black_mask_hero_path)
  self.received_icon = self:AddComponent(UIImage, received_icon_path)
end

function MailRewardCommonItem:OnDestroy()
  self.mail_reward_item = nil
  self.black_mask_item = nil
  self.hero_reward_item = nil
  self.black_mask_hero = nil
  self.received_icon = nil
  base.OnDestroy(self)
end

function MailRewardCommonItem:RefreshData(param, status)
  self.mail_reward_item:SetActive(false)
  self.hero_reward_item:SetActive(true)
  self.hero_reward_item:RefreshData(param)
  self.black_mask_hero:SetActive(status)
  self.received_icon:SetActive(status)
end

function MailRewardCommonItem:ReInit(rewardData, status)
  self.mail_reward_item:SetActive(true)
  self.hero_reward_item:SetActive(false)
  self.mail_reward_item:ReInit(rewardData)
  self.black_mask_item:SetActive(status)
  self.received_icon:SetActive(status)
end

return MailRewardCommonItem
