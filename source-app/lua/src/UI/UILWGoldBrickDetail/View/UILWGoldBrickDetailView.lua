local UILWGoldBrickDetailView = BaseClass("UILWGoldBrickDetailView", UIBaseView)
local base = UIBaseView

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local needRequest = DataCenter.PlayerInfoDataManager:NeedRequestGoldBrickDetail()
  if needRequest then
    self:RefreshLoadingView()
    DataCenter.PlayerInfoDataManager:RequestGoldBrickDetail()
    self.waitTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:RefreshDataView()
    end, 5)
  else
    self:RefreshDataView()
  end
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
  if self.waitTimer then
    self.waitTimer:Stop()
    self.waitTimer = nil
  end
  base.OnDisable(self)
end

local GOTO1_URL = "https://lastwar-h5.lastwargame.com/app/trade_law_ja.html"
local GOTO2_URL = "https://lastwar-h5.lastwargame.com/app/pay_services_ja.html"

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.imgGoldIcon = self:AddComponent(UIImage, "UICommonPopUpTitle/content/gold_icon")
  self.textFreeCountTxt = self:AddComponent(UIText, "UICommonPopUpTitle/content/freeGold/free_count_txt")
  self.textFreeDescTxt = self:AddComponent(UIText, "UICommonPopUpTitle/content/freeGold/free_desc_txt")
  self.textPaidCountTxt = self:AddComponent(UIText, "UICommonPopUpTitle/content/paidGold/paid_count_txt")
  self.textPaidDescTxt = self:AddComponent(UIText, "UICommonPopUpTitle/content/paidGold/paid_desc_txt")
  self.gotos = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/content/gotos")
  self.goto1_txt = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/content/gotos/goto1_txt")
  self.goto1_txt:OnPointerClick(function(eventData)
    CS.SDKManager.OpenURL(GOTO1_URL)
  end)
  self.goto2_txt = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/content/gotos/goto2_txt")
  self.goto2_txt:OnPointerClick(function(eventData)
    CS.SDKManager.OpenURL(GOTO2_URL)
  end)
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.btnClose = nil
  self.imgGoldIcon = nil
  self.textFreeCountTxt = nil
  self.textFreeDescTxt = nil
  self.textPaidCountTxt = nil
  self.textPaidDescTxt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetGoldBrickDetail, self.OnGetGoldDetail)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetGoldBrickDetail, self.OnGetGoldDetail)
  base.OnRemoveListener(self)
end

local function RefreshLoadingView(self)
  self.textFreeCountTxt:SetLocalText(100231)
  self.textPaidCountTxt:SetLocalText(100231)
end

local function RefreshDataView(self)
  local player = LuaEntry.Player
  local freeGold = 0
  local paidGold = 0
  if player then
    freeGold = player:GetFreeGoldBrick()
    paidGold = player:GetPaidGoldBrick()
  end
  self.textFreeCountTxt:SetText(string.GetFormattedStr2(freeGold))
  self.textPaidCountTxt:SetText(string.GetFormattedStr2(paidGold))
end

local function OnGetGoldDetail(self)
  if self.waitTimer then
    self.waitTimer:Stop()
    self.waitTimer = nil
  end
  self:RefreshDataView()
end

UILWGoldBrickDetailView.OnCreate = OnCreate
UILWGoldBrickDetailView.OnDestroy = OnDestroy
UILWGoldBrickDetailView.OnEnable = OnEnable
UILWGoldBrickDetailView.OnDisable = OnDisable
UILWGoldBrickDetailView.ComponentDefine = ComponentDefine
UILWGoldBrickDetailView.ComponentDestroy = ComponentDestroy
UILWGoldBrickDetailView.DataDefine = DataDefine
UILWGoldBrickDetailView.DataDestroy = DataDestroy
UILWGoldBrickDetailView.OnAddListener = OnAddListener
UILWGoldBrickDetailView.OnRemoveListener = OnRemoveListener
UILWGoldBrickDetailView.RefreshLoadingView = RefreshLoadingView
UILWGoldBrickDetailView.RefreshDataView = RefreshDataView
UILWGoldBrickDetailView.OnGetGoldDetail = OnGetGoldDetail
return UILWGoldBrickDetailView
