local UILWGetGiftView = BaseClass("UILWGetGiftView", UIBaseView)
local base = UIBaseView
local key1 = "activity_bargain_shop_desc28"
local Localization = CS.GameEntry.Localization
local tmpSpriteKey = "<sprite name=%s>"

function UILWGetGiftView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UILWGetGiftView:ComponentDefine()
  self.title_text = self:AddComponent(UIText, "text/layout/title")
  self.getBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/getBtn")
  self.icon = self:AddComponent(UIImage, "UICommonPopUpTitle/icon")
  self.layout = self:AddComponent(UIBaseContainer, "text/layout")
  self.getBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UILWGetGiftView:OnBtnClick()
  local uid = self.data.reward[1].value.uuid
  local count = self.data.reward[1].value.count
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {uuid = uid, num = count})
  self.ctrl:CloseSelf()
end

function UILWGetGiftView:ComponentDestroy()
  self.title_text = nil
  self.getBtn = nil
  self.icon = nil
  self.layout = nil
end

function UILWGetGiftView:ReInit()
  self.data = self:GetUserData()
  local actTemplate = DataCenter.ActivityListDataManager:GetActivityDataById(self.data.activityId)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(tonumber(actTemplate.para_2))
  local str = ""
  if goods and not string.IsNullOrEmpty(goods.icon) then
    str = string.format(tmpSpriteKey, goods.icon)
  end
  self.title_text:SetLocalText(key1, self.data.reduce, str)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title_text.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.transform)
  self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(self.data.reward[1].value.itemId)))
end

function UILWGetGiftView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

return UILWGetGiftView
