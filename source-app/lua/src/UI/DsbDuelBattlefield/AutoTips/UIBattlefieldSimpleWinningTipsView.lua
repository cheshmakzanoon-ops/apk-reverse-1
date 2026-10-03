local UIBattlefieldAutoTipsView = require("UI.DsbDuelBattlefield.AutoTips.UIBattlefieldAutoTipsView")
local base = UIBattlefieldAutoTipsView
local UIBattlefieldSimpleWinningTipsView = BaseClass("UIBattlefieldSimpleWinningTipsView", base)
local Localization = CS.GameEntry.Localization

function UIBattlefieldSimpleWinningTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetupView(self:GetUserData())
end

function UIBattlefieldSimpleWinningTipsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattlefieldSimpleWinningTipsView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmp01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTmp02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTmp01Score = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmp02Score = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgIcon01 = self.viewSkin:AddComponent(self, UIImage, 5)
  self.imgIcon02 = self.viewSkin:AddComponent(self, UIImage, 6)
  self.compBg01 = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compBg02 = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.textTmpTitleNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
end

function UIBattlefieldSimpleWinningTipsView:ComponentDestroy()
  self.viewSkin = nil
  self.textTmp01 = nil
  self.textTmp02 = nil
  self.textTmp01Score = nil
  self.textTmp02Score = nil
  self.imgIcon01 = nil
  self.imgIcon02 = nil
  self.compBg01 = nil
  self.compBg02 = nil
  self.textTmpTitleNotice = nil
end

function UIBattlefieldSimpleWinningTipsView:DataDefine()
end

function UIBattlefieldSimpleWinningTipsView:DataDestroy()
end

function UIBattlefieldSimpleWinningTipsView:OnAddListener()
  base.OnAddListener(self)
end

function UIBattlefieldSimpleWinningTipsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBattlefieldSimpleWinningTipsView:SetupView(param)
  if not param then
    return
  end
  local title = param.title
  local name_0 = param.name_0
  local name_1 = param.name_1
  local val_0 = param.val_0
  local val_1 = param.val_1
  local icon_0 = param.icon_0
  local icon_1 = param.icon_1
  local labelWidth = param.width
  local label0Width = 0
  local label1Width = 0
  local maxWidth = 0
  if title then
    self.textTmpTitleNotice:SetText(title)
    self.textTmpTitleNotice:SetActive(true)
    self.textTmpTitleNotice:SetSizeDeltaXY(labelWidth, 0)
  else
    self.textTmpTitleNotice:SetActive(false)
  end
  if name_0 then
    self.textTmp01:SetText(name_0)
    self.textTmp01:SetActive(true)
    self.textTmp01:SetSizeDeltaXY(labelWidth, 0)
    if val_0 then
      self.textTmp01Score:SetText(val_0)
    end
    if icon_0 then
      self.imgIcon01:LoadSpriteAsync(icon_0)
      self.imgIcon01:SetAspectSize(50)
    end
  else
    self.textTmp01:SetActive(false)
  end
  if name_1 then
    self.textTmp02:SetText(name_1)
    self.textTmp02:SetActive(true)
    self.textTmp02:SetSizeDeltaXY(labelWidth, 0)
    if val_1 then
      self.textTmp02Score:SetText(val_1)
    end
    if icon_1 then
      self.imgIcon02:LoadSpriteAsync(icon_1)
      self.imgIcon02:SetAspectSize(50)
    end
  else
    self.textTmp02:SetActive(false)
  end
  self:SetDirty()
end

return UIBattlefieldSimpleWinningTipsView
