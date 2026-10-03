local UIPiggyBankContent = BaseClass("UIPiggyBankContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local info_path = "Info"
local slider_path = "Slider"
local fill_path = "Slider/FillArea/Fill"
local bubble_desc_path = "Bubble/BubbleDesc"
local seal_desc_path = "Seal/SealDesc"
local seal_num_path = "Seal/SealNum"
local progress_path = "Slider/Progress"
local time_desc_path = "TimeDesc"
local buy_btn_path = "BuyBtn"
local buy_text_path = "BuyBtn/BuyText"
local go_btn_path = "GoBtn"
local go_text_path = "GoBtn/GoText"
local point_path = "BuyBtn/UIGiftPackagePoint"
local desc1_path = "Desc1"
local desc2_path = "Desc2"
local PROGRESS_YELLOW = "Assets/Main/Sprites/UI/UIPiggyBank/lrb_cunqianguan_jiemian_jindutiao_01.png"
local PROGRESS_GREEN = "Assets/Main/Sprites/UI/UIPiggyBank/lrb_cunqianguan_jiemian_jindutiao_00.png"

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
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.fill_image = self:AddComponent(UIImage, fill_path)
  self.bubble_desc_text = self:AddComponent(UIText, bubble_desc_path)
  self.bubble_desc_text:SetLocalText(320303)
  self.seal_desc_text = self:AddComponent(UIText, seal_desc_path)
  self.seal_num_text = self:AddComponent(UIText, seal_num_path)
  self.progress_text = self:AddComponent(UIText, progress_path)
  self.time_desc_text = self:AddComponent(UIText, time_desc_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn:SetOnClick(function()
    self:OnBuyClick()
  end)
  self.buy_text = self:AddComponent(UIText, buy_text_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.go_text:SetLocalText(110003)
  self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
  self.desc1_text = self:AddComponent(UIText, desc1_path)
  self.desc1_text:SetLocalText(320304)
  self.desc2_text = self:AddComponent(UIText, desc2_path)
  self.desc2_text:SetLocalText(320304)
end

local function ComponentDestroy(self)
  self.info_btn = nil
  self.slider = nil
  self.fill_image = nil
  self.bubble_desc_text = nil
  self.seal_desc_text = nil
  self.seal_num_text = nil
  self.progress_text = nil
  self.time_desc_text = nil
  self.buy_btn = nil
  self.buy_text = nil
  self.go_btn = nil
  self.go_text = nil
  self.point_rect = nil
end

local function DataDefine(self)
  self.view = nil
  self.pack = nil
  self.cur = 0
  self.max = 0
  self.endTime = 0
  self.active = false
end

local function DataDestroy(self)
  self.view = nil
  self.pack = nil
  self.cur = nil
  self.max = nil
  self.endTime = nil
  self.active = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInitView(self, view)
  self.info_btn:SetActive(false)
  self.buy_btn:SetActive(false)
  self.go_btn:SetActive(true)
  self:ReInit(view)
end

local function ReInitPanel(self, view)
  self.info_btn:SetActive(true)
  self.buy_btn:SetActive(true)
  self.go_btn:SetActive(false)
  self:ReInit(view)
end

local function ReInit(self, view)
  local pack = GiftPackageData.getPiggyBankPack()
  local cur = pack._serverData.money
  local max = pack._serverData.maxMoney
  local per = pack:getPercent()
  self.active = true
  self.view = view
  self.pack = GiftPackageData.getPiggyBankPack()
  self.cur = cur
  self.max = max
  self.endTime = pack:getEndTime()
  self.buy_text:SetText(DataCenter.PayManager:GetDollarText(pack:getPrice(), pack:getProductID()))
  self.progress_text:SetText(string.GetFormattedSeperatorNum(cur) .. "/" .. string.GetFormattedSeperatorNum(max))
  self.fill_image:LoadSprite(cur < max and PROGRESS_YELLOW or PROGRESS_GREEN)
  self.slider:SetValue(cur / max)
  self.seal_num_text:SetText(per .. "%")
  if cur >= max then
    self.desc1_text:SetLocalText(2800045)
    self.desc2_text:SetLocalText(2800045)
  else
    self.desc1_text:SetLocalText(320304)
    self.desc2_text:SetLocalText(320304)
  end
  self.point_rect:RefreshPoint(pack)
end

local function Close(self)
  self.active = false
  self.view.ctrl:CloseSelf()
end

local function Buy(self)
  if self.view.ctrl.BuyGift then
    self.view.ctrl:BuyGift(self.pack)
  else
    DataCenter.PayManager:BuyGift(self.pack)
  end
  self:Close()
end

local function OnInfoClick(self)
  UIUtil.ShowIntro(Localization:GetString("320305"), Localization:GetString("170001"), Localization:GetString("320307"))
end

local function OnGoClick(self)
  self:Close()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.PiggyBank)
end

local function OnBuyClick(self)
  if self.cur <= 0 then
    return
  end
  if self.cur >= self.max then
    self:Buy()
  else
    local piggyBankConfig = LuaEntry.DataConfig:TryGetStr("piggybank", "k3")
    local strArry1 = string.split(piggyBankConfig, "|")
    local times = 1
    for k, v in ipairs(strArry1) do
      local strArry2 = string.split(v, ";")
      local packId = tonumber(strArry2[1])
      if packId == tonumber(self.pack._serverData.id) then
        times = tonumber(strArry2[4])
        break
      end
    end
    if times == 0 then
      times = 1
    end
    local str = Localization:GetString("320306", self.max / times, self.cur / times)
    UIUtil.ShowMessage(str, 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, nil, function()
      self:Buy()
    end)
  end
end

UIPiggyBankContent.OnCreate = OnCreate
UIPiggyBankContent.OnDestroy = OnDestroy
UIPiggyBankContent.OnEnable = OnEnable
UIPiggyBankContent.OnDisable = OnDisable
UIPiggyBankContent.ComponentDefine = ComponentDefine
UIPiggyBankContent.ComponentDestroy = ComponentDestroy
UIPiggyBankContent.DataDefine = DataDefine
UIPiggyBankContent.DataDestroy = DataDestroy
UIPiggyBankContent.OnAddListener = OnAddListener
UIPiggyBankContent.OnRemoveListener = OnRemoveListener
UIPiggyBankContent.ReInitView = ReInitView
UIPiggyBankContent.ReInitPanel = ReInitPanel
UIPiggyBankContent.ReInit = ReInit
UIPiggyBankContent.Close = Close
UIPiggyBankContent.Buy = Buy
UIPiggyBankContent.OnInfoClick = OnInfoClick
UIPiggyBankContent.OnGoClick = OnGoClick
UIPiggyBankContent.OnBuyClick = OnBuyClick
return UIPiggyBankContent
