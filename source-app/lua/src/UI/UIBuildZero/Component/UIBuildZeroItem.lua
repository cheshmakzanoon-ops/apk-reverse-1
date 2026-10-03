local UIBuildZeroItem = BaseClass("UIPveBuffCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
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

function UIBuildZeroItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIBuildZeroItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIBuildZeroItem:ComponentDefine()
  self.name = self:AddComponent(UIText, name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn_text = self:AddComponent(UIText, buy_btn_text_path)
  self.item_enough_img = self:AddComponent(UIImage, item_enough_img_path)
  self.item_num1 = self:AddComponent(UIText, item_num1_path)
  self.item_num2 = self:AddComponent(UIText, item_num2_path)
  self.submit_btn = self:AddComponent(UIButton, submit_btn_path)
  self.submit_btn_text = self:AddComponent(UIText, submit_btn_text_path)
  self.submit_btn_text:SetLocalText(GameDialogDefine.SUBMIT)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.buy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuyBtnClick()
  end)
  self.submit_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSubmitBtnClick()
  end)
  self.goto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnGotoBtnClick()
  end)
end

function UIBuildZeroItem:ComponentDestroy()
end

function UIBuildZeroItem:DataDefine()
  self.param = {}
end

function UIBuildZeroItem:DataDestroy()
  self.param = {}
end

function UIBuildZeroItem:OnEnable()
  base.OnEnable(self)
end

function UIBuildZeroItem:OnDisable()
  base.OnDisable(self)
end

function UIBuildZeroItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBuildZeroItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBuildZeroItem:ReInit(param)
  self.param = param
  self:Refresh()
end

function UIBuildZeroItem:Refresh()
  self.name:SetText(self.param.name)
  self.icon:LoadSprite(self.param.icon)
  self.goto_btn:SetActive(false)
  if self.param.needType == CommonCostNeedType.Resource and self.param.resourceType == ResourceType.People then
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
      self.item_num1:SetText(self.param.has)
      self.item_num2:SetText("/" .. self.param.count)
      self.goto_btn:SetActive(true)
      self.buy_btn:SetActive(false)
      self.submit_btn:SetActive(false)
      self.item_num1:SetColor(RedColor)
      UIGray.SetGray(self.submit_btn.transform, true, false)
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
    self.item_num1:SetText(self.param.has)
    self.item_num2:SetText("/" .. self.param.count)
    if self.param.has >= self.param.count then
      self.buy_btn:SetActive(false)
      self.submit_btn:SetActive(true)
      self.item_num1:SetColor(WhiteColor)
      UIGray.SetGray(self.submit_btn.transform, false, true)
    else
      self.goto_btn:SetActive(true)
      if self.param.diamond ~= nil and 0 < self.param.diamond then
        self.buy_btn:SetActive(true)
        self.item_num1:SetColor(RedColor)
        self.submit_btn:SetActive(false)
        self.buy_btn_text:SetText(self.param.diamond)
      else
        self.buy_btn:SetActive(false)
        self.submit_btn:SetActive(true)
        self.item_num1:SetColor(RedColor)
        UIGray.SetGray(self.submit_btn.transform, true, false)
      end
    end
  end
end

function UIBuildZeroItem:OnGotoBtnClick()
  local lackTab = {}
  local param = {}
  if self.param.needType == CommonCostNeedType.Resource then
    param.type = ResLackType.Res
    param.resType = self.param.resourceType
  elseif self.param.needType == CommonCostNeedType.ResourceItem then
    param.type = ResLackType.ResItem
    param.itemId = self.param.resItemId
  elseif self.param.needType == CommonCostNeedType.Goods then
    param.type = ResLackType.Item
    param.itemId = self.param.itemId
  end
  param.targetNum = self.param.count
  table.insert(lackTab, param)
  GoToResLack.GoToItemResLackList(lackTab)
end

function UIBuildZeroItem:OnSubmitBtnClick()
  self:SendSubmit(false)
end

function UIBuildZeroItem:OnBuyBtnClick()
  if LuaEntry.Player.gold >= self.param.diamond then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(self.param.diamond), Localization:GetString(GameDialogDefine.DIAMOND), self.param.name), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:SendSubmit(true)
    end, function()
    end)
  else
    GoToUtil.GotoPayTips(self.param.diamond)
  end
end

function UIBuildZeroItem:SendSubmit(useGold)
  local param = {}
  if self.param.needType == CommonCostNeedType.Resource then
    param.resources = {}
    param.resources[self.param.resourceType] = self.param.count
  elseif self.param.needType == CommonCostNeedType.ResourceItem then
    param.resourceItems = {}
    param.resourceItems[self.param.resItemId] = self.param.count
  elseif self.param.needType == CommonCostNeedType.Goods then
    param.items = {}
    param.items[self.param.itemId] = self.param.count
  end
  param.bUuid = self.param.uuid
  param.useGold = useGold
  DataCenter.BuildUpgradeStockManager:SendUBStoreUpgrade(param)
end

return UIBuildZeroItem
