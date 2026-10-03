local UIWarningTipView = BaseClass("UIWarningTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.btnClosePanel = self:AddComponent(UIButton, "ClosePanel")
  self.btnClosePanel:SetOnClick(function()
    self:OnBtnClosePanelClick()
  end)
  self.rawImgBar1 = self:AddComponent(UIRawImage, "Root/Bar1")
  self.rawImgBar2 = self:AddComponent(UIRawImage, "Root/Bar2")
  self.rawImgIcon = self:AddComponent(UIRawImage, "Root/Icon")
  self.text = self:AddComponent(UITextMeshProUGUIEx, "Root/Text")
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Battle_RewardTime_PopUp, false)
end

local function ComponentDestroy(self)
  self.btnClosePanel = nil
  self.rawImgBar1 = nil
  self.rawImgBar2 = nil
  self.rawImgIcon = nil
  self.text = nil
end

local function DataDefine(self)
  local warningTipType = self:GetUserData()
  self:Refresh(warningTipType)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnClosePanelClick(self)
end

local function Refresh(self, warningTipType)
  if warningTipType == WarningTipType.ParkourGoldBonus then
    self.rawImgIcon:LoadSprite("Assets/Main/TextureEx/UIWarningTip/zxl_fuweng_duojinbi.png")
    self.rawImgBar1:LoadSprite("Assets/Main/TextureEx/UIWarningTip/lrb_shangjinlieren_zhiyuan_biaoti02.png")
    self.rawImgBar2:LoadSprite("Assets/Main/TextureEx/UIWarningTip/lrb_shangjinlieren_zhiyuan_biaoti01.png")
    self.text:SetLocalText("monopoly_bonus_tips_01")
    DataCenter.LWSoundManager:PlaySound(80132, false)
  end
end

UIWarningTipView.OnCreate = OnCreate
UIWarningTipView.OnDestroy = OnDestroy
UIWarningTipView.OnEnable = OnEnable
UIWarningTipView.OnDisable = OnDisable
UIWarningTipView.ComponentDefine = ComponentDefine
UIWarningTipView.ComponentDestroy = ComponentDestroy
UIWarningTipView.DataDefine = DataDefine
UIWarningTipView.DataDestroy = DataDestroy
UIWarningTipView.OnAddListener = OnAddListener
UIWarningTipView.OnRemoveListener = OnRemoveListener
UIWarningTipView.OnBtnClosePanelClick = OnBtnClosePanelClick
UIWarningTipView.Refresh = Refresh
return UIWarningTipView
