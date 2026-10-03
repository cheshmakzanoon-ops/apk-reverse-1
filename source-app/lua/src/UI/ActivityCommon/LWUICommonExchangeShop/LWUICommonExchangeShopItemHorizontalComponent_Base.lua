local base = UIBaseContainer
local LWUICommonExchangeShopItemHorizontalComponent_Base = BaseClass("LWUICommonExchangeShopItemHorizontalComponent_Base", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUICommonExchangeShopItemHorizontalComponent_Base:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textExchangeTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnExchange = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnExchange:SetOnClick(function()
    self:OnBtnExchangeClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compUICommonResItem01 = self.viewSkin:AddComponent(self, UICommonResItem, 4)
  self.imgArrow = self.viewSkin:AddComponent(self, UIImage, 5)
  self.compUICommonResItem02 = self.viewSkin:AddComponent(self, UICommonResItem, 6)
  self.compTagContent = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.imgTagIcon = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textTagYellow = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textTagRed = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:ComponentDestroy()
  self.viewSkin = nil
  self.textExchangeTime = nil
  self.btnExchange = nil
  self.textBtn = nil
  self.compUICommonResItem01 = nil
  self.imgArrow = nil
  self.compUICommonResItem02 = nil
  self.compTagContent = nil
  self.imgTagIcon = nil
  self.textTagYellow = nil
  self.textTagRed = nil
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:DataDefine()
  self.data = nil
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:DataDestroy()
  self.data = nil
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:OnAddListener()
  base.OnAddListener(self)
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:ReInit(data)
  self.data = data
  if self.data == nil then
    return
  end
  self:RefreshAll()
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:RefreshAll()
  self:RefreshTimes()
  self:RefreshTargetItem()
  self:RefreshCost()
  self:RefreshBtnText()
  self:RefreshTag()
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:RefreshBtnText()
  if self.data == nil then
    return
  end
  local customText = self.data:GetExchangeBtnText()
  if not string.IsNullOrEmpty(customText) then
    self.textBtn:SetText(customText)
  end
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:RefreshTimes()
  if self.data == nil then
    return
  end
  local showText = self.data:GetExchangeTimesText()
  local isShow = not string.IsNullOrEmpty(showText)
  self.textExchangeTime:SetActive(isShow)
  if isShow then
    self.textExchangeTime:SetText(showText)
  end
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:RefreshTargetItem()
  if self.data == nil then
    return
  end
  local rewardShowData = self.data:GetRewardData()
  self.compUICommonResItem02:SetActive(rewardShowData ~= nil)
  if rewardShowData ~= nil then
    self.compUICommonResItem02:ReInit(rewardShowData)
  end
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:RefreshCost()
  if self.data == nil then
    return
  end
  local rewardShowData = self.data:GetCostRewardData()
  self.compUICommonResItem01:SetActive(rewardShowData ~= nil)
  if rewardShowData ~= nil then
    self.compUICommonResItem01:ReInit(rewardShowData)
  end
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:RefreshTag()
  if self.data == nil then
    return
  end
  local showTag = false
  local yellowText = self.data:GetTagTextYellow()
  self.textTagYellow:SetActive(not string.IsNullOrEmpty(yellowText))
  if not string.IsNullOrEmpty(yellowText) then
    showTag = true
    self.textTagYellow:SetText(yellowText)
    self.imgTagIcon:LoadSprite("Assets/Main/Sprites/UI/UICitySkinActivity/sj_shengdang_jiaobiao1.png")
  end
  local redText = self.data:GetTagTextRed()
  self.textTagRed:SetActive(not string.IsNullOrEmpty(redText))
  if not string.IsNullOrEmpty(redText) then
    showTag = true
    self.textTagRed:SetText(redText)
    self.imgTagIcon:LoadSprite("Assets/Main/Sprites/UI/UICitySkinActivity/sj_shengdang_jiaobiao2.png")
  end
  self.compTagContent:SetActive(showTag)
end

function LWUICommonExchangeShopItemHorizontalComponent_Base:OnBtnExchangeClick()
  if self.data == nil then
    return
  end
  self.data:OnExchangeClick()
end

return LWUICommonExchangeShopItemHorizontalComponent_Base
