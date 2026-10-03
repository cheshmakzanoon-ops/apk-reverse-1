local UIActGiftBoxKeyAccessItem = BaseClass("UIActGiftBoxKeyAccessItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local recommend_path = "BuyContent/BG1"
local item_icon_path = "JumpContent/BoxImg"
local name_text_path = "TitleText"
local gift_rect_path = "BuyContent/RewardContent"
local buy_rect_path = "BuyContent"
local jump_rect_path = "JumpContent"
local go_btn_path = "JumpContent/JumpBtn"
local go_txt_path = "JumpContent/JumpBtn/BG/JumpBtnText"
local gift_btn_path = "BuyContent/CostBuyBtn"
local gift_btn_buy_path = "BuyContent/CostBuyBtn/BG/CostBtnText"
local priceGift_txt_path = "BuyContent/CostBuyBtn/BG/PriceBtnText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.recommend_rect = self:AddComponent(UIBaseContainer, recommend_path)
  self.buy_rect = self:AddComponent(UIBaseContainer, buy_rect_path)
  self.jump_rect = self:AddComponent(UIBaseContainer, jump_rect_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.gift_rect = self:AddComponent(UIBaseContainer, gift_rect_path)
  self.rewardList = {}
  for i = 1, 3 do
    self.rewardList[i] = self.gift_rect:AddComponent(UICommonResItem, "Reward" .. i)
  end
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_txt = self:AddComponent(UIText, go_txt_path)
  self.go_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnJumpBtnClick()
  end)
  self.buy_btn = self:AddComponent(UIButton, gift_btn_path)
  self.buy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuyBtnClick()
  end)
  self.price_txt = self:AddComponent(UIText, priceGift_txt_path)
  self.gift_btn_buy_txt = self:AddComponent(UIText, gift_btn_buy_path)
  self.gift_btn_buy_txt:SetLocalText(129011)
end

local function ComponentDestroy(self)
  self.recommend_rect = nil
  self.item_icon = nil
  self.name_text = nil
  self.desc_text = nil
  self.point_rect = nil
  self:ClearList()
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param, distab)
  self.param = param
  self.lacktab = distab
  self:ShowRecommend(true)
  self.model = {}
  self:ClearList()
  self.buy_rect:SetActive(false)
  self.jump_rect:SetActive(false)
  if param:GetTips() == ResLackGoToType.BuyGiftNew or param:GetTips() == ResLackGoToType.BuyGiftResNew then
    self.buy_rect:SetActive(true)
    self.item_icon:SetActive(false)
    self.name_text:SetText(self.param:GetGiftName())
    self.buy_btn:SetActive(true)
    self.go_btn:SetActive(false)
    self.gift_rect:SetActive(true)
    self:SetGiftBtnInfo()
  elseif param:GetTips() == ResLackGoToType.ResourceBagUse or param:GetTips() == ResLackGoToType.LoesCamp or param:GetTips() == ResLackGoToType.UseBuildGoods then
    self.jump_rect:SetActive(true)
    self.name_text:SetText(self.param:GetName())
    self.buy_btn:SetActive(false)
    self.go_btn:SetActive(true)
    self.gift_rect:SetActive(false)
    self:SetBtnInfo()
  else
    self.jump_rect:SetActive(true)
    self.item_icon:SetActive(true)
    self.item_icon:LoadSpriteAuto(param:GetIcon())
    self.name_text:SetText(self.param:GetName())
    self.buy_btn:SetActive(false)
    self.go_btn:SetActive(true)
    self.gift_rect:SetActive(false)
    self:SetBtnInfo()
  end
end

local function ShowRecommend(self, isRecommend)
  self.recommend_rect:SetActive(isRecommend)
end

local function SetBtnInfo(self)
  self.go_txt:SetActive(self.param:GetBtnNameType() == 1)
  if self.param:GetBtnNameType() == 1 then
    self.go_txt:SetText(self.param:GetBtnName())
  elseif self.param:GetBtnNameType() == 2 then
    self.price_txt:SetText(self.param:GetBtnName())
  end
end

local function SetGiftBtnInfo(self)
  self.price_txt:SetText(self.param:GetGiftPrice())
  local list = self.param:GetCellsList()
  for i = 1, 3 do
    if list[i] then
      self.rewardList[i]:SetActive(true)
      self.rewardList[i]:ReInit(list[i])
    else
      self.rewardList[i]:SetActive(false)
    end
  end
end

local function ClearList(self)
  if next(self.model) then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function OnBuyBtnClick(self)
  self.param:TodoAction(self.go_btn.transform.position, true, self.lacktab)
  if self.view.ctrl then
    self.view.ctrl:CloseSelf()
  end
end

local function OnJumpBtnClick(self)
  self.param:TodoAction(self.go_btn.transform.position, true, self.lacktab)
  if self.view.ctrl then
    self.view.ctrl:CloseSelf()
  end
end

UIActGiftBoxKeyAccessItem.OnCreate = OnCreate
UIActGiftBoxKeyAccessItem.OnDestroy = OnDestroy
UIActGiftBoxKeyAccessItem.OnBuyBtnClick = OnBuyBtnClick
UIActGiftBoxKeyAccessItem.OnJumpBtnClick = OnJumpBtnClick
UIActGiftBoxKeyAccessItem.OnEnable = OnEnable
UIActGiftBoxKeyAccessItem.OnDisable = OnDisable
UIActGiftBoxKeyAccessItem.ComponentDefine = ComponentDefine
UIActGiftBoxKeyAccessItem.ComponentDestroy = ComponentDestroy
UIActGiftBoxKeyAccessItem.DataDefine = DataDefine
UIActGiftBoxKeyAccessItem.DataDestroy = DataDestroy
UIActGiftBoxKeyAccessItem.ReInit = ReInit
UIActGiftBoxKeyAccessItem.ShowRecommend = ShowRecommend
UIActGiftBoxKeyAccessItem.SetBtnInfo = SetBtnInfo
UIActGiftBoxKeyAccessItem.SetGiftBtnInfo = SetGiftBtnInfo
UIActGiftBoxKeyAccessItem.ClearList = ClearList
return UIActGiftBoxKeyAccessItem
