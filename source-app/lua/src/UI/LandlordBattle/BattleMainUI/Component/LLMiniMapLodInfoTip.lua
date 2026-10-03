local base = UIAsyncContainer
local LLMiniMapLodInfoTip = BaseClass("LLMiniMapLodInfoTip", base)
local Localization = CS.GameEntry.Localization

function LLMiniMapLodInfoTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMiniMapLodInfoTip:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMiniMapLodInfoTip:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnGo1 = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnGo1:SetOnClick(function()
    self:OnBtnGo1Click()
  end)
  self.btnGo2 = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnGo2:SetOnClick(function()
    self:OnBtnGo2Click()
  end)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 4)
end

function LLMiniMapLodInfoTip:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.btnGo1 = nil
  self.btnGo2 = nil
  self.imgIcon = nil
end

function LLMiniMapLodInfoTip:DataDefine()
  CS.UIGray.SetGray(self.imgIcon.transform, true, false)
end

function LLMiniMapLodInfoTip:DataDestroy()
end

function LLMiniMapLodInfoTip:OnAddListener()
  base.OnAddListener(self)
end

function LLMiniMapLodInfoTip:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLMiniMapLodInfoTip:OnBtnCloseClick()
  self:SetActive(false)
end

function LLMiniMapLodInfoTip:OnBtnGo1Click()
  self:SetActive(false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLRule, {anim = true}, LLConst.RuleType.BattleDef)
end

function LLMiniMapLodInfoTip:OnBtnGo2Click()
  self:SetActive(false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLRule, {anim = true}, LLConst.RuleType.BattleAtk)
end

return LLMiniMapLodInfoTip
