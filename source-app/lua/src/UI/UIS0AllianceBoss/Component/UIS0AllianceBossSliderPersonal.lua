local base = UIBaseContainer
local UIS0AllianceBossSliderPersonal = BaseClass("UIS0AllianceBossSliderPersonal", UIBaseContainer)
local PERSONAL_ICON_PATH = "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_TMJY_jifen_geren.png"

function UIS0AllianceBossSliderPersonal:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIS0AllianceBossSliderPersonal:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossSliderPersonal:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBubbleTip = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBubbleTip:SetOnClick(function()
    self:OnBtnBubbleTipClick()
  end)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTxtNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.sliderProgress = self.viewSkin:AddComponent(self, UISlider, 4)
end

function UIS0AllianceBossSliderPersonal:ComponentDestroy()
  self.viewSkin = nil
  self.btnBubbleTip = nil
  self.imgIcon = nil
  self.textTxtNum = nil
  self.sliderProgress = nil
end

function UIS0AllianceBossSliderPersonal:DataDefine()
  self.dmg = nil
  self.dmgMax = nil
  self.viewDifficulty = nil
end

function UIS0AllianceBossSliderPersonal:DataDestroy()
  self.dmg = nil
  self.dmgMax = nil
  self.viewDifficulty = nil
end

function UIS0AllianceBossSliderPersonal:InitView()
  self.imgIcon:LoadSpriteAuto(PERSONAL_ICON_PATH)
end

function UIS0AllianceBossSliderPersonal:RefreshView(dmg, dmgMax, viewDifficulty)
  self.viewDifficulty = viewDifficulty
  if self.dmg ~= dmg or self.dmgMax ~= dmgMax then
    self.dmg = dmg
    self.dmgMax = dmgMax
    local dmgStr = string.GetFormattedStr(dmg)
    local dmgMaxStr = string.GetFormattedStr(dmgMax)
    self.textTxtNum:SetText(dmgStr .. "/" .. dmgMaxStr)
    local progress = Mathf.Clamp(dmg / dmgMax, 0, 1)
    self.sliderProgress:SetValue(progress)
  end
end

function UIS0AllianceBossSliderPersonal:OnBtnBubbleTipClick()
  if not DataCenter.S0AllianceBossDataManager:CheckMainLevelLimit() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossRewardPreview, {anim = true}, {
    viewDifficulty = self.viewDifficulty,
    type = 2
  })
end

return UIS0AllianceBossSliderPersonal
