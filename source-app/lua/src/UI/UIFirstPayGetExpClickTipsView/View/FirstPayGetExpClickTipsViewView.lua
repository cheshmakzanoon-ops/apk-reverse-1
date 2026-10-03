local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local FirstPayGetExpClickTipsViewView = BaseClass("FirstPayGetExpClickTipsViewView", base)
local Localization = CS.GameEntry.Localization

function FirstPayGetExpClickTipsViewView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
end

function FirstPayGetExpClickTipsViewView:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function FirstPayGetExpClickTipsViewView:ComponentDefine()
  base.ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textDescText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDescText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnGoto = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self:RefreshView()
end

function FirstPayGetExpClickTipsViewView:ComponentDestroy()
  base.ComponentDestroy(self)
  self.viewSkin = nil
  self.textTitle = nil
  self.textDescText1 = nil
  self.textDescText2 = nil
  self.btnGoto = nil
end

function FirstPayGetExpClickTipsViewView:DataDefine()
end

function FirstPayGetExpClickTipsViewView:DataDestroy()
end

function FirstPayGetExpClickTipsViewView:OnAddListener()
  base.OnAddListener(self)
end

function FirstPayGetExpClickTipsViewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FirstPayGetExpClickTipsViewView:OnBtnGotoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPay, {anim = false}, {delay = 0.5})
end

function FirstPayGetExpClickTipsViewView:RefreshView()
  local isHasBoughtFirstPay = DataCenter.FirstPayManager:IsHasBoughtFirstPay()
  local tipsTextKey = isHasBoughtFirstPay and "fp_tips_2" or "fp_tips_1"
  self.textTitle:SetLocalText(tipsTextKey)
  self.textDescText2:SetLocalText("fp_tips_desc")
  self.btnGoto:SetActive(not isHasBoughtFirstPay)
  local expMaxLimit = 0
  local buildingExpData = DataCenter.FirstPayManager:GetCurBuildExpData()
  if not buildingExpData then
    self.textDescText1:SetText("")
    return
  end
  expMaxLimit = tostring(math.floor(buildingExpData.expMaxLimit))
  local itemDesc = DataCenter.ItemTemplateManager:GetDes(buildingExpData.goldPigItemId)
  self.textDescText1:SetText(itemDesc)
end

return FirstPayGetExpClickTipsViewView
