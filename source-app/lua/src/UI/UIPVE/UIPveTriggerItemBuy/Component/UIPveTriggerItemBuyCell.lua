local UIPveTriggerItemBuyCell = BaseClass("UIPveBuffCell", UIBaseContainer)
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

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.name = self:AddComponent(UIText, name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn_text = self:AddComponent(UIText, buy_btn_text_path)
  self.item_enough_img = self:AddComponent(UIImage, item_enough_img_path)
  self.item_num1 = self:AddComponent(UIText, item_num1_path)
  self.item_num2 = self:AddComponent(UIText, item_num2_path)
  self.submit_btn = self:AddComponent(UIButton, submit_btn_path)
  self.submit_btn_text = self:AddComponent(UIText, submit_btn_text_path)
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

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.isClick = false
end

local function DataDestroy(self)
  self.isClick = false
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self.param = param
  self:Refresh()
end

local function Refresh(self)
  self.isClick = false
  self.name:SetText(self.param.name)
  self.icon:LoadSprite(self.param.icon)
  self.goto_btn:SetActive(false)
  self.submit_btn_text:SetLocalText(self.param.submitText)
  if self.param.isSubmit then
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
    self.item_num2:SetText("/" .. self.param.need)
    if self.param.has >= self.param.need then
      self.buy_btn:SetActive(false)
      self.submit_btn:SetActive(true)
      self.item_num1:SetColor(WhiteColor)
      UIGray.SetGray(self.submit_btn.transform, false, true)
    else
      self.goto_btn:SetActive(true)
      if not self.param.canBuy then
        self.buy_btn:SetActive(false)
        self.submit_btn:SetActive(true)
        self.item_num1:SetColor(RedColor)
        UIGray.SetGray(self.submit_btn.transform, not self.param.canBuy, self.param.canBuy)
      else
        self.buy_btn:SetActive(true)
        self.item_num1:SetColor(RedColor)
        self.submit_btn:SetActive(false)
        self.buy_btn_text:SetText(self.param.diamond)
      end
    end
  end
end

local function OnGotoBtnClick(self)
  if self.param.gotoTriggerId ~= nil then
    GoToUtil.GoTriggerPve({
      tostring(self.param.gotoTriggerId)
    })
    self.view.ctrl:CloseSelf()
  elseif self.param.isResourceItem == true then
    local resourceItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.param.itemId)
    if resourceItemTemplate ~= nil and not string.IsNullOrEmpty(resourceItemTemplate.building) then
      if self.view and self.view.ctrl then
        self.view.ctrl:CloseSelf()
      end
      DataCenter.BattleLevel:Exit(function()
        local buildType = toInt(resourceItemTemplate.building)
        if buildType == BuildingTypes.APS_BUILD_FARM_FIELD then
          GoToUtil.GotoCityByBuildId(BuildingTypes.APS_BUILD_FARM_FIELD)
        elseif buildType == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or buildType == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildType == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
          GoToUtil.GotoCityByBuildId(buildType)
        elseif DataCenter.BuildManager:IsFactoryBuild(buildType) then
          GoToUtil.GotoCityByBuildId(buildType)
        end
      end)
    end
  end
end

local function OnSubmitBtnClick(self)
  if self.isClick == false then
    self.isClick = true
    local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(self.param.triggerId)
    if trigger:IsTypeGainArmy() then
      local param = {}
      param.index = self.param.index
      param.trigger = self.param.triggerId
      param.level = self.param.level
      param.useGold = 0
      param.count = self.view.panelData.count
      DataCenter.BattleLevel:TryGainArmyByTrigger(param)
    elseif trigger:IsTypeHireHero() then
      DataCenter.BattleLevel:HireHeroByTrigger(trigger, self.view.panelData.heroData)
      self.view.ctrl:CloseSelf()
    else
      local param = {}
      param.index = self.param.index
      param.trigger = self.param.triggerId
      param.level = self.param.level
      param.useGold = 0
      SFSNetwork.SendMessage(MsgDefines.PayTriggerResItem, param)
    end
  end
end

local function OnBuyBtnClick(self)
  if LuaEntry.Player.gold >= self.param.diamond then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(self.param.diamond), Localization:GetString(GameDialogDefine.DIAMOND), self.param.name), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      local param = {}
      param.index = self.param.index
      param.trigger = self.param.triggerId
      param.level = self.param.level
      param.useGold = 1
      SFSNetwork.SendMessage(MsgDefines.PayTriggerResItem, param)
    end, function()
    end)
  else
    GoToUtil.GotoPayTips(self.param.diamond)
  end
end

UIPveTriggerItemBuyCell.OnCreate = OnCreate
UIPveTriggerItemBuyCell.OnDestroy = OnDestroy
UIPveTriggerItemBuyCell.ComponentDefine = ComponentDefine
UIPveTriggerItemBuyCell.ComponentDestroy = ComponentDestroy
UIPveTriggerItemBuyCell.DataDefine = DataDefine
UIPveTriggerItemBuyCell.DataDestroy = DataDestroy
UIPveTriggerItemBuyCell.OnEnable = OnEnable
UIPveTriggerItemBuyCell.OnDisable = OnDisable
UIPveTriggerItemBuyCell.OnAddListener = OnAddListener
UIPveTriggerItemBuyCell.OnRemoveListener = OnRemoveListener
UIPveTriggerItemBuyCell.ReInit = ReInit
UIPveTriggerItemBuyCell.OnBuyBtnClick = OnBuyBtnClick
UIPveTriggerItemBuyCell.Refresh = Refresh
UIPveTriggerItemBuyCell.OnSubmitBtnClick = OnSubmitBtnClick
UIPveTriggerItemBuyCell.OnGotoBtnClick = OnGotoBtnClick
return UIPveTriggerItemBuyCell
