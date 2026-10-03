local GoldBrickItemCell = BaseClass("GoldBrickItemCell", UIBaseContainer)
local base = UIBaseContainer

function GoldBrickItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GoldBrickItemCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function GoldBrickItemCell:OnEnable()
  base.OnEnable(self)
end

function GoldBrickItemCell:OnDisable()
  base.OnDisable(self)
end

function GoldBrickItemCell:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "bg")
  self.price = self:AddComponent(UIText, "bg/price")
  self.reward = self:AddComponent(UIText, "bg/reward/numberReward")
  self.additional = self:AddComponent(UIText, "bg/Additional/reward/numberAdd")
  self.additional_title = self:AddComponent(UIText, "bg/Additional/titleAdd")
  self.btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.btn:SetSafeClickMode(true)
  self.icon = self:AddComponent(UIImage, "bg/Icon")
  self.icon_reward = self:AddComponent(UIImage, "bg/reward/rewardIcon")
  self.icon_reward_jp = self:AddComponent(UIImage, "bg/reward/rewardIconJP")
  self.icon_additional = self:AddComponent(UIImage, "bg/Additional/reward/addIcon")
  self.icon_additional_jp = self:AddComponent(UIImage, "bg/Additional/reward/addIconJP")
end

function GoldBrickItemCell:ComponentDestroy()
  self.btn = nil
  self.price = nil
  self.reward = nil
  self.additional = nil
  self.icon = nil
  self.icon_reward = nil
  self.icon_reward_jp = nil
  self.icon_additional = nil
  self.icon_additional_jp = nil
end

function GoldBrickItemCell:DataDefine()
end

function GoldBrickItemCell:DataDestroy()
end

function GoldBrickItemCell:Refresh(param)
  self.data = param
  self.price:SetText(self.data.currency_symbol .. self.data.amount)
  self.reward:SetText("\195\151" .. self.data.pay_brick_num)
  self.additional:SetText("\195\151" .. self.data.free_brick_num)
  self.additional_title:SetLocalText("goldbrick_store_labeljp")
  local path = WelfareController.GetGoldBrickIcon(self.data)
  self.icon:LoadSprite(path)
  local showGoldDetail = DataCenter.PlayerInfoDataManager:CanShowGoldBrickDetail()
  self.icon_reward:SetActive(not showGoldDetail)
  self.icon_reward_jp:SetActive(showGoldDetail)
  self.icon_additional:SetActive(not showGoldDetail)
  self.icon_additional_jp:SetActive(showGoldDetail)
end

function GoldBrickItemCell:OnShowClick(param)
  Logger.Log("Buy gold brick :" .. self.data.goods_id .. " " .. self.data.amount)
  UIManager:GetInstance():OpenWindow(UIWindowNames.GoldBrickStoreConfirmPop, self.data.goods_id)
  PostEventLog.Track(PostEventLog.Defines.c_amount_change, {
    packageid = self.data.goods_id
  })
end

return GoldBrickItemCell
