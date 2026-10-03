local base = UIBaseView
local BankDepositInfo = BaseClass("BankDepositInfo", base)
local maleIconPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/cfm_lianmeng_tubiao_nan.png"
local femaleIconPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/cfm_lianmeng_tubiao_nv.png"
local closeBtn_path = "panel"
local head_path = "Root/HeadPoint/UIPlayerHead"
local playerName_path = "Root/NameArea/NickNameText"
local genderImg_path = "Root/NameArea/GenderImg"
local btnItem_path = "Root/GoodItem"
local iconItem_path = "Root/GoodItem"
local textValue_path = "Root/TextValue"
local textIncome_path = "Root/Income/TextIncome"
local textIncomeRank_path = "Root/Income/TextIncomeRank"
local textTotal_path = "Root/Total/TextTotal"
local textTotalRank_path = "Root/Total/TextTotalRank"
local textRate_path = "Root/Rate/TextRate"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.head = self:AddComponent(UIBaseContainer, head_path)
  self.playerName = self:AddComponent(UIText, playerName_path)
  self.genderImg = self:AddComponent(UIImage, genderImg_path)
  self.btnItem = self:AddComponent(UIButton, btnItem_path)
  self.iconItem = self:AddComponent(UIImage, iconItem_path)
  self.textValue = self:AddComponent(UIText, textValue_path)
  self.textIncome = self:AddComponent(UIText, textIncome_path)
  self.textIncomeRank = self:AddComponent(UIText, textIncomeRank_path)
  self.textTotal = self:AddComponent(UIText, textTotal_path)
  self.textTotalRank = self:AddComponent(UIText, textTotalRank_path)
  self.textRate = self:AddComponent(UIText, textRate_path)
  self.closeBtn:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.headItem = self:AddComponent(UICommonHead, head_path)
  self.btnItem:SetOnClick(function()
    DataCenter.SeasonBankManager:ShowItemTips(self.btnItem, nil, self.depositItemId or self.itemId)
  end)
end

local function ComponentDestroy(self)
  self.closeBtn = nil
  self.head = nil
  self.playerName = nil
  self.genderImg = nil
  self.btnItem = nil
  self.iconItem = nil
  self.textValue = nil
  self.textIncome = nil
  self.textIncomeRank = nil
  self.textTotal = nil
  self.textTotalRank = nil
  self.textRate = nil
end

local function DataDefine(self)
  local param = self:GetUserData()
  self.itemId = param and param.itemId or 0
  self.seasonId = param and param.seasonId or 0
  SFSNetwork.SendMessage(MsgDefines.LwRqUserSouvenir, self.itemId)
end

local function DataDestroy(self)
end

function BankDepositInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BankUserSouvenir, self.UpdateDepositInfo)
end

function BankDepositInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.BankUserSouvenir, self.UpdateDepositInfo)
  base.OnRemoveListener(self)
end

function BankDepositInfo:RefreshView()
  self.headItem:SetAsMyself()
  self.headItem:SetEnableClickShowInfo(true)
  self.playerName:SetText(LuaEntry.Player:GetName())
  local gender = LuaEntry.Player.gender
  if gender then
    if gender == 2 then
      self.genderImg:SetActive(true)
      self.genderImg:LoadSprite(femaleIconPath)
    elseif gender == 1 then
      self.genderImg:SetActive(true)
      self.genderImg:LoadSprite(maleIconPath)
    else
      self.genderImg:SetActive(false)
    end
    self.genderImg:SetNativeSize()
  end
end

function BankDepositInfo:UpdateDepositInfo(depositInfo)
  depositInfo = depositInfo or {}
  self.depositItemId = depositInfo.itemId or self.itemId
  DataCenter.SeasonBankManager:LoadItemIcon(self.iconItem, nil, self.depositItemId)
  self.textValue:SetText(string.GetFormattedSeperatorNum(depositInfo.withdrawAmount or 0))
  self.textIncome:SetText(string.GetFormattedSeperatorNum(depositInfo.saveAmount or 0))
  if not depositInfo.saveRank or 0 >= depositInfo.saveRank then
    self.textIncomeRank:SetLocalText("361054")
  else
    self.textIncomeRank:SetLocalText("280138", depositInfo.saveRank or 0)
  end
  self.textTotal:SetText(string.GetFormattedSeperatorNum(depositInfo.withdrawAmount or 0))
  if not depositInfo.withdrawRank or 0 >= depositInfo.withdrawRank then
    self.textTotalRank:SetLocalText("361054")
  else
    self.textTotalRank:SetLocalText("280138", depositInfo.withdrawRank or 0)
  end
  if not depositInfo.saveAmount or 0 >= depositInfo.saveAmount then
    self.textRate:SetLocalText("320362", 0)
  else
    local rate = math.floor((depositInfo.withdrawAmount or 0) / depositInfo.saveAmount * 100)
    self.textRate:SetLocalText("320362", rate)
  end
end

BankDepositInfo.OnCreate = OnCreate
BankDepositInfo.OnDestroy = OnDestroy
BankDepositInfo.OnEnable = OnEnable
BankDepositInfo.OnDisable = OnDisable
BankDepositInfo.ComponentDefine = ComponentDefine
BankDepositInfo.ComponentDestroy = ComponentDestroy
BankDepositInfo.DataDefine = DataDefine
BankDepositInfo.DataDestroy = DataDestroy
return BankDepositInfo
