local UIChampionDuelSignTipView = BaseClass("UIChampionDuelSignTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIChampionDuelSignTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIChampionDuelSignTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelSignTipView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
end

function UIChampionDuelSignTipView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.btnGo = nil
end

function UIChampionDuelSignTipView:DataDefine()
  local now = UITimeManager:GetInstance():GetServerTime()
  CommonUtil.PlayerPrefsSetLong(DataCenter.ChampionDuelManager:GetSignPrefsKey(), now)
end

function UIChampionDuelSignTipView:DataDestroy()
end

function UIChampionDuelSignTipView:OnAddListener()
  base.OnAddListener(self)
end

function UIChampionDuelSignTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIChampionDuelSignTipView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIChampionDuelSignTipView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIChampionDuelSignTipView:OnBtnGoClick()
  local data = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ChampionDuelMain.Type)
  if data == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelMain, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, data)
  self.ctrl:CloseSelf()
end

return UIChampionDuelSignTipView
