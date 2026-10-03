local UISeasonTowerBuffPanelView = BaseClass("UISeasonTowerBuffPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UISeasonTowerBuffPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetData()
end

function UISeasonTowerBuffPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonTowerBuffPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textBuffInfoTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textBtnTipTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnCommon = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnCommon:SetOnClick(function()
    self:OnBtnCommonClick()
  end)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.compButtonNode = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
end

function UISeasonTowerBuffPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.btnMask = nil
  self.btnClose = nil
  self.textBuffInfoTxt = nil
  self.textBtnTipTxt = nil
  self.btnCommon = nil
  self.btnLWInfo = nil
  self.compButtonNode = nil
  self.textTitle = nil
end

function UISeasonTowerBuffPanelView:DataDefine()
  local data = self:GetUserData()
  self.buffType = data.buffType
end

function UISeasonTowerBuffPanelView:DataDestroy()
end

function UISeasonTowerBuffPanelView:OnAddListener()
  base.OnAddListener(self)
end

function UISeasonTowerBuffPanelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISeasonTowerBuffPanelView:SetData()
  self:RefreshBuff()
end

function UISeasonTowerBuffPanelView:RefreshBuff()
  if self.buffType == SeasonTowerConfig.BuffType.All then
    self.compButtonNode:SetActive(false)
    local info = DataCenter.LWSeasonTowerManager:GetAllBuffInfo()
    local param = DataCenter.LWSeasonTowerManager:GetAllBuffInfoParam()
    self.textBuffInfoTxt:SetText(Localization:GetString(info, table.unpack(param)))
    self.textTitle:SetLocalText("season_tower_all_buff_title")
  elseif self.buffType == SeasonTowerConfig.BuffType.User then
    self.compButtonNode:SetActive(true)
    local info = DataCenter.LWSeasonTowerManager:GetUserBuffInfo()
    self.textBuffInfoTxt:SetText(Localization:GetString(info))
    self.textTitle:SetLocalText("season_tower_user_buff_title")
  else
    self.compButtonNode:SetActive(true)
  end
end

function UISeasonTowerBuffPanelView:OnBtnMaskClick()
  self.ctrl:CloseSelf()
end

function UISeasonTowerBuffPanelView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UISeasonTowerBuffPanelView:OnBtnCommonClick()
end

function UISeasonTowerBuffPanelView:OnBtnLWInfoClick()
  local param = {}
  if self.buffType == SeasonTowerConfig.BuffType.All then
    param.activityRulesStr = Localization:GetString("season_tower_all_buff_info")
  elseif self.buffType == SeasonTowerConfig.BuffType.User then
    param.activityRulesStr = Localization:GetString("season_tower_user_buff_info")
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

return UISeasonTowerBuffPanelView
