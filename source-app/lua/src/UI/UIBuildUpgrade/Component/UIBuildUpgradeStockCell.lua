local UIBuildUpgradeStockCell = BaseClass("UIPveBuffCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local name_path = "NameText"
local icon_path = "Icon"
local buy_btn_path = "CostBtn"
local buy_btn_text_path = "CostBtn/btnTxt2"
local item_enough_img_path = "ItemEnoughImg"
local item_num1_path = "Num/NumText1"
local item_num2_path = "Num/NumText2"
local submit_btn_path = "SubmitBtn"
local submit_btn_text_path = "SubmitBtn/SubmitBtnText"
local goto_btn_path = "Cell_BG/GotoBtn"
local ShowStrKNum = 10000
local GotoBtnAnimName = {
  Wink = "goto_btn_wink",
  Idle = "goto_btn_idle"
}

function UIBuildUpgradeStockCell:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIBuildUpgradeStockCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIBuildUpgradeStockCell:ComponentDefine()
  self.name = self:AddComponent(UIText, name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn_text = self:AddComponent(UIText, buy_btn_text_path)
  self.buy_btn_text_shadow = self:AddComponent(UIShadow, buy_btn_text_path)
  self.item_enough_img = self:AddComponent(UIImage, item_enough_img_path)
  self.item_num1 = self:AddComponent(UIText, item_num1_path)
  self.item_num1_shadow = self:AddComponent(UIShadow, item_num1_path)
  self.item_num2 = self:AddComponent(UIText, item_num2_path)
  self.submit_btn = self:AddComponent(UIButton, submit_btn_path)
  self.submit_btn_text = self:AddComponent(UIText, submit_btn_text_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn_anim = self:AddComponent(UIAnimator, goto_btn_path)
  self.buy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuyBtnClick()
  end)
  self.submit_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Bill, false)
    self:OnSubmitBtnClick()
  end)
  self.goto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnGotoBtnClick()
  end)
end

function UIBuildUpgradeStockCell:ComponentDestroy()
end

function UIBuildUpgradeStockCell:DataDefine()
  self.param = {}
end

function UIBuildUpgradeStockCell:DataDestroy()
  self.param = {}
end

function UIBuildUpgradeStockCell:OnEnable()
  base.OnEnable(self)
end

function UIBuildUpgradeStockCell:OnDisable()
  base.OnDisable(self)
end

function UIBuildUpgradeStockCell:OnAddListener()
  base.OnAddListener(self)
end

function UIBuildUpgradeStockCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBuildUpgradeStockCell:ReInit(param)
  self.param = param
  self:Refresh()
end

function UIBuildUpgradeStockCell:Refresh()
  self.name:SetText(self.param.name)
  self.icon:LoadSprite(self.param.icon)
  self.goto_btn:SetActive(false)
  if self.param.needType == CommonCostNeedType.Build then
    self.icon.rectTransform:Set_sizeDelta(114, 150)
    self.item_enough_img:SetActive(false)
    self.item_num1:SetActive(true)
    self.item_num1:SetColor(Color.New(0.9725490196078431, 0.30196078431372547, 0.17254901960784313, 1))
    self.item_num1:SetText(self.param.has)
    self.item_num2:SetActive(false)
    self.goto_btn:SetActive(false)
    self.buy_btn:SetActive(false)
    self.goto_btn:SetActive(true)
    self:RefreshWink(self.param.gotoBtnWink)
    self.submit_btn:SetActive(false)
  else
    self.icon.rectTransform:Set_sizeDelta(118, 118)
    if self.param.resourceType ~= nil and self.param.resourceType == ResourceType.People then
      if self.param.has >= self.param.count then
        self.item_enough_img:SetActive(true)
        self.buy_btn:SetActive(false)
        self.item_num1:SetActive(false)
        self.item_num2:SetActive(false)
        self.submit_btn:SetActive(false)
      else
        self.item_enough_img:SetActive(false)
        self.item_num1:SetActive(true)
        self.item_num2:SetActive(true)
        self.item_num1:SetText(self:GetShowNumStr(self.param.has))
        self.item_num2:SetText("/" .. self:GetShowNumStr(self.param.count))
        self.goto_btn:SetActive(true)
        self:RefreshWink(self.param.gotoBtnWink)
        self.buy_btn:SetActive(false)
        self.submit_btn:SetActive(false)
        self.item_num1:SetColor(Color.New(0.9725490196078431, 0.30196078431372547, 0.17254901960784313, 1))
      end
    elseif self.param.count <= 0 then
      self.item_enough_img:SetActive(true)
      self.buy_btn:SetActive(false)
      self.item_num1:SetActive(false)
      self.item_num2:SetActive(false)
      self.submit_btn:SetActive(false)
    else
      self.item_enough_img:SetActive(false)
      self.item_num1:SetActive(true)
      self.item_num2:SetActive(true)
      self.item_num1:SetText(self:GetShowNumStr(self.param.has))
      self.item_num2:SetText("/" .. self:GetShowNumStr(self.param.count))
      self.submit_btn_text:SetLocalText(GameDialogDefine.SUBMIT)
      if self.param.has >= self.param.count then
        self.buy_btn:SetActive(false)
        self.submit_btn:SetActive(true)
        self.item_num1:SetColor(WhiteColor)
      else
        self.goto_btn:SetActive(true)
        self:RefreshWink(self.param.gotoBtnWink)
        if self.param.diamond ~= nil and 0 < self.param.diamond then
          self.buy_btn:SetActive(true)
          self.item_num1:SetColor(Color.New(0.9725490196078431, 0.30196078431372547, 0.17254901960784313, 1))
          self.submit_btn:SetActive(false)
          self.buy_btn_text:SetText(self.param.diamond)
          self:RefreshGoldColor()
        else
          self.buy_btn:SetActive(false)
          self.submit_btn:SetActive(false)
          self.item_num1:SetColor(Color.New(0.9725490196078431, 0.30196078431372547, 0.17254901960784313, 1))
        end
      end
    end
  end
end

function UIBuildUpgradeStockCell:OnGotoBtnClick()
  if self.param.needType == CommonCostNeedType.Build then
    GoToUtil.GotoCityByBuildId(self.param.buildId, WorldTileBtnType.City_Upgrade)
  else
    local lackTab = {}
    local param = {}
    if self.param.needType == CommonCostNeedType.Goods then
      param.type = ResLackType.Item
      param.itemId = self.param.itemId
    elseif self.param.needType == CommonCostNeedType.ResourceItem then
      param.type = ResLackType.ResItem
      param.itemId = self.param.resItemId
    elseif self.param.needType == CommonCostNeedType.Resource then
      param.type = ResLackType.Res
      param.resType = self.param.resourceType
    end
    param.targetNum = self.param.count
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
  end
end

function UIBuildUpgradeStockCell:OnSubmitBtnClick()
  self:SendSubmit(false)
end

function UIBuildUpgradeStockCell:OnBuyBtnClick()
  if LuaEntry.Player.gold >= self.param.diamond then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(self.param.diamond), Localization:GetString(GameDialogDefine.DIAMOND), self.param.name), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:SendSubmit(true)
    end, function()
    end)
  else
    GoToUtil.GotoPayTips(self.param.diamond)
  end
end

function UIBuildUpgradeStockCell:SendSubmit(useGold)
  local param = {}
  if self.param.itemId ~= nil then
    param.items = {}
    param.items[self.param.itemId] = self.param.count
  elseif self.param.resItemId ~= nil then
    param.resourceItems = {}
    param.resourceItems[self.param.resItemId] = self.param.count
  elseif self.param.resourceType ~= nil then
    param.resources = {}
    param.resources[self.param.resourceType] = self.param.count
  end
  param.bUuid = self.param.uuid
  param.useGold = useGold
  DataCenter.BuildUpgradeStockManager:SendUBStoreUpgrade(param)
end

function UIBuildUpgradeStockCell:RefreshGoldColor()
  if self.param.diamond ~= nil and self.param.diamond > 0 then
    if LuaEntry.Player.gold >= self.param.diamond then
      self.buy_btn_text:SetColor(WhiteColor)
      self.buy_btn_text_shadow:AllEnable(true)
    else
      self.buy_btn_text_shadow:AllEnable(false)
      self.buy_btn_text:SetColor(RedColor)
    end
  end
end

function UIBuildUpgradeStockCell:RefreshWink(canWink)
  if self.goto_btn:GetActive() then
    if canWink then
      self.goto_btn_anim:Play(GotoBtnAnimName.Wink, 0, 0)
    else
      self.goto_btn_anim:Play(GotoBtnAnimName.Idle, 0, 0)
    end
  end
end

function UIBuildUpgradeStockCell:GetShowNumStr(num)
  if num >= ShowStrKNum then
    return string.GetFormattedStr(num)
  end
  return num
end

return UIBuildUpgradeStockCell
