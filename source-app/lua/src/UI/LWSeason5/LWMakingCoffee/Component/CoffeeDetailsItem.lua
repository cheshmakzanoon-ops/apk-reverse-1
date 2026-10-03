local image_path = "mask/Image"
local base = UIBaseContainer
local CoffeeDetailsItem = BaseClass("CoffeeDetailsItem", UIBaseContainer)

function CoffeeDetailsItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CoffeeDetailsItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CoffeeDetailsItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgMask = self.viewSkin:AddComponent(self, UIImage, 1)
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgSelect = self.viewSkin:AddComponent(self, UIImage, 5)
  self.unlockText = self:AddComponent(UITextMeshProUGUIEx, "unlockText")
  self.unlockEffect = self:AddComponent(UIBaseContainer, "unlockEffect")
  self.image = self:AddComponent(UIAnimator, image_path)
end

function CoffeeDetailsItem:ComponentDestroy()
  self.imgMask = nil
  self.btnClick = nil
  self.textName = nil
  self.imgIcon = nil
  self.imgSelect = nil
  self.unlockText = nil
  self.image = nil
end

function CoffeeDetailsItem:DataDefine()
  self.data = nil
end

function CoffeeDetailsItem:DataDestroy()
  self.data = nil
end

function CoffeeDetailsItem:UpdateItem(data)
  self.data = data
  self.textName:SetLocalText(self.data.name)
  self.imgIcon:LoadSpriteAsync(self.data.icon)
  self.unlockEffect:SetActive(false)
  local isUnlock = DataCenter.MakingCoffeeManager:GetIsUnlock(self.data.id)
  local canUnLocked = DataCenter.MakingCoffeeManager:IsCanUnlocked(self.data.id)
  local showUnlockTips = canUnLocked and not isUnlock
  self.unlockText:SetActive(showUnlockTips)
  self.imgMask:SetActive(not isUnlock)
  if showUnlockTips then
    self.image:Play("V_ui_S5_LWMakingCoffeeView_lock_shake", 0, 0)
  end
end

function CoffeeDetailsItem:OnAddListener()
  base.OnAddListener(self)
end

function CoffeeDetailsItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CoffeeDetailsItem:OnBtnClickClick()
  self.view:SetCurCoffee(self.data)
end

function CoffeeDetailsItem:SelectItem(coffeeId)
  if self.data then
    self.imgSelect:SetActive(self.data.id == coffeeId)
  end
end

function CoffeeDetailsItem:UnlockCoffee(coffeeId)
  if self.data.id == coffeeId then
    self.unlockEffect:SetActive(true)
    self.unlockText:SetActive(false)
    self.imgMask:SetActive(false)
    self.image:Rebind()
    self.image:Play("EmptyState", 0, 0)
  end
end

return CoffeeDetailsItem
