local base = UIBaseContainer
local UICurrencyCell = BaseClass("UICurrencyCell", base)

function UICurrencyCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICurrencyCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICurrencyCell:ComponentDefine()
  self.icon = self:AddComponent(UIImage, "Icon")
  self.countText = self:AddComponent(UIText, "ExpText")
  self.addBtn = self:AddComponent(UIButton, "addBtn")
  self.addBtn:SetOnClick(function()
    if self.data == nil then
      return
    end
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.addBtnCallBack then
      self.addBtnCallBack()
    end
    local info = DataCenter.ActBargainShopData:GetInfoByActId(self.data.activityId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.data.activityId, info:GetGiftPackId(), tonumber(self.actTemplate.para_2))
  end)
end

function UICurrencyCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.UpdateCount)
end

function UICurrencyCell:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateCount)
  base.OnRemoveListener(self)
end

function UICurrencyCell:ComponentDestroy()
  self.icon = nil
  self.countText = nil
  self.addBtn = nil
  self.addBtnCallBack = nil
  self.data = nil
  self.actTemplate = nil
end

function UICurrencyCell:UpdateData(data)
  self.data = data
  self.actTemplate = DataCenter.ActivityListDataManager:GetActivityDataById(self.data.activityId)
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(self.actTemplate.para_2))
  self.icon:LoadSprite(iconPath)
  self:UpdateCount()
  if data.addBtnCallBack then
    self.addBtnCallBack = data.addBtnCallBack
  end
end

function UICurrencyCell:UpdateCount()
  local itemData = DataCenter.ItemData:GetItemById(tonumber(self.actTemplate.para_2))
  self.countText:SetText(itemData and itemData.count or 0)
end

return UICurrencyCell
