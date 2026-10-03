local base = UIBaseContainer
local FirstPayExpRewardComponent = BaseClass("FirstPayExpRewardComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")

function FirstPayExpRewardComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FirstPayExpRewardComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FirstPayExpRewardComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPigImg = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPigImg:SetOnClick(function()
    self:OnBtnPigImgClick()
  end)
  self.compUICommonHorseLampTMP = self.viewSkin:AddComponent(self, UICommonHorseLampTMP, 2)
end

function FirstPayExpRewardComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnPigImg = nil
  self.compUICommonHorseLampTMP = nil
end

function FirstPayExpRewardComponent:DataDefine()
end

function FirstPayExpRewardComponent:DataDestroy()
end

function FirstPayExpRewardComponent:OnAddListener()
  base.OnAddListener(self)
end

function FirstPayExpRewardComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FirstPayExpRewardComponent:OnBtnPigImgClick()
  local param = {}
  param.alignObject = self.btnPigImg.transform
  param.width = 495
  param.showArrow = true
  param.addPosY = -50
  if self.holder then
    if self.holder:GetName() == UIWindowNames.UIBuildUpgradeSuccess or self.holder:GetName() == UIWindowNames.MainBuildUpgradeSuccess then
      param.addPosY = 50
    elseif self.holder:GetName() == UIWindowNames.UIBuildUpgrade then
      param.addPosY = -50
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.FirstPayGetExpClickTipsView, {anim = true}, param)
end

function FirstPayExpRewardComponent:Refresh(data)
  local curUpgradeStashExp = data.addExp or 0
  local isFunctionOn = DataCenter.FirstPayManager:IsBuildingUpgradeGetExpFunctionOn()
  local isShow = isFunctionOn and 0 < curUpgradeStashExp
  self.gameObject:SetActive(isShow)
  if not isShow then
    return
  end
  local isUnlockExpAdd = DataCenter.FirstPayManager:IsHasBoughtFirstPay()
  local desStr = isUnlockExpAdd and "fp_af_buildinginfo" or "fp_bf_buildinginfo"
  local buildExpData = DataCenter.FirstPayManager:GetCurBuildExpData()
  if buildExpData and buildExpData:IsExpPoolMax() then
    desStr = isUnlockExpAdd and "fp_de_limit8" or "fp_de_limit14"
  end
  local showStr = Localization:GetString(desStr, string.GetFormattedStr2(data.addExp or 0))
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.compUICommonHorseLampTMP:SetTextWithLength(showStr, nil, NoRollingAlignment.Right)
  else
    self.compUICommonHorseLampTMP:SetTextWithLength(showStr, nil, NoRollingAlignment.Left)
  end
end

return FirstPayExpRewardComponent
