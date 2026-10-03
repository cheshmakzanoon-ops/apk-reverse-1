local UIGiftPackChooseResItem = BaseClass("UIGiftPackChooseResItem", UIBaseContainer)
local base = UIBaseContainer

function UIGiftPackChooseResItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGiftPackChooseResItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGiftPackChooseResItem:OnEnable()
  base.OnEnable(self)
end

function UIGiftPackChooseResItem:OnDisable()
  base.OnDisable(self)
end

function UIGiftPackChooseResItem:ComponentDefine()
  self.chosenItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.unknownIcon = self:AddComponent(UIImage, "UnknownIcon")
  self.btn = self:AddComponent(UIButton, "ClickMask")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
end

function UIGiftPackChooseResItem:ComponentDestroy()
  self.chosenItem = nil
  self.unknownIcon = nil
  self.btn = nil
end

function UIGiftPackChooseResItem:DataDefine()
  self.refreshAction = BindCallback(self, self.RefreshUI)
end

function UIGiftPackChooseResItem:DataDestroy()
  self.data = nil
  self.refreshAction = nil
end

function UIGiftPackChooseResItem:RefreshUI()
  if self.data and not table.IsNullOrEmpty(self.data:getCombs()) then
    local chooseInex = self.data:getChooseIndex()
    local choosen = Setting:GetInt("GIFT_PACK_COMBINE_CHOOSE" .. self.data:getID(), 0)
    choosen = 1 <= choosen
    if not choosen then
      self.chosenItem:SetActive(false)
      self.unknownIcon:SetActive(true)
    else
      self.chosenItem:SetActive(true)
      self.unknownIcon:SetActive(false)
      local items = self.data:getComb(chooseInex)
      if not table.IsNullOrEmpty(items) then
        local item = items[1]
        self.chosenItem:ReInit(item)
      end
    end
  end
end

function UIGiftPackChooseResItem:ReInit(giftPackData)
  self.data = giftPackData
  self:RefreshUI()
end

function UIGiftPackChooseResItem:OnClick()
  if self.data then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackRewardSelect, {anim = true}, self.data:getID(), self.refreshAction)
  end
end

return UIGiftPackChooseResItem
