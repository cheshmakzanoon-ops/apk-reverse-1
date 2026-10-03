local base = UIBaseContainer
local UIWinterStormTaskS0Box = BaseClass("UIWinterStormTaskS0Box", UIBaseContainer)

function UIWinterStormTaskS0Box:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormTaskS0Box:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormTaskS0Box:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.eff_light = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.animatorIcon = self.viewSkin:AddComponent(self, UIAnimator, 3)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.compDiamondBg = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.eff_reward = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compIcon = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compBg = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
end

function UIWinterStormTaskS0Box:ComponentDestroy()
  self.viewSkin = nil
  self.eff_light = nil
  self.imgIcon = nil
  self.animatorIcon = nil
  self.btn = nil
  self.compDiamondBg = nil
  self.textNum = nil
  self.eff_reward = nil
  self.compIcon = nil
  self.compBg = nil
end

function UIWinterStormTaskS0Box:DataDefine()
end

function UIWinterStormTaskS0Box:DataDestroy()
end

function UIWinterStormTaskS0Box:OnAddListener()
  base.OnAddListener(self)
end

function UIWinterStormTaskS0Box:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWinterStormTaskS0Box:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.view:OpenRewardTips(self.boxIndex)
end

function UIWinterStormTaskS0Box:SetBoxInfo(view, idx, boxIndex, config)
  self.view = view
  self.boxIndex = boxIndex
  local state = self.view:GetBoxState(boxIndex)
  self.eff_light:SetActive(state == 2)
  local nameIdx = idx * 2
  if state ~= 3 then
    nameIdx = nameIdx - 1
  end
  local boxName = string.format("UIAllianceArmament_img_reward0%d.png", nameIdx)
  local iconPath = string.format(LoadPath.LWActRewardCommonPath, boxName)
  self.imgIcon:LoadSpriteAuto(iconPath)
  self.animatorIcon:Play(state == 2 and "box_open" or "box_unOpen", 0, 0)
  self.eff_reward:SetActive(state == 2)
  local txt, flag
  if DataCenter.ActWinterStormManager:IsRoundBox(config) then
    local round = self.view:GetRoundCanGetCnt()
    if 0 < round then
      txt = tostring(round)
      flag = false
    end
  elseif state ~= 3 then
    txt = string.GetFormattedSeperatorNum(toInt(config.value))
    flag = true
  end
  local showFlag = not string.IsNullOrEmpty(txt)
  self.compDiamondBg:SetActive(showFlag)
  if showFlag then
    local _, h = self:GetSizeDeltaXY()
    self.compDiamondBg:SetLocalPositionXYZ(flag and -50 or 50, h * 0.5, 0)
    self.compBg:SetLocalScaleXYZ(flag and 1 or -1, 1, 1)
    self.compIcon:SetActive(flag)
    self.textNum:SetText(txt)
    self.textNum:SetColorHex(flag and "#B76630" or "#2A2830")
  end
end

return UIWinterStormTaskS0Box
