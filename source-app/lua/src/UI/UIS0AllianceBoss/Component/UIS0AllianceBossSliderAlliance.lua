local base = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSliderPersonal")
local UIS0AllianceBossSliderAlliance = BaseClass("UIS0AllianceBossSliderAlliance", base)
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local ALLIANCE_ICON_PATH = "Assets/Main/Sprites/UI/UIS0AllianceBoss/lrb_TMJY_jifen_lianmeng.png"

function UIS0AllianceBossSliderAlliance:OnCreate()
  base.OnCreate(self)
  self:InitView()
end

function UIS0AllianceBossSliderAlliance:OnDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossSliderAlliance:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBubbleTip = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBubbleTip:SetOnClick(function()
    self:OnBtnBubbleTipClick()
  end)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTxtNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.sliderProgress = self.viewSkin:AddComponent(self, UISlider, 4)
  self.btnStar01 = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnStar01:SetOnClick(function()
    self:OnBtnStar01Click()
  end)
  self.compStarAn01 = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compStarLight01 = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.btnStar02 = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnStar02:SetOnClick(function()
    self:OnBtnStar02Click()
  end)
  self.compStarAn02 = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compStarLight02 = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.btnStar03 = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnStar03:SetOnClick(function()
    self:OnBtnStar03Click()
  end)
  self.compStarAn03 = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.compStarLight03 = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.btnStar04 = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnStar04:SetOnClick(function()
    self:OnBtnStar04Click()
  end)
  self.compStarAn04 = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.compStarLight04 = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.btnStar05 = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnStar05:SetOnClick(function()
    self:OnBtnStar05Click()
  end)
  self.compStarAn05 = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.compStarLight05 = self.viewSkin:AddComponent(self, UIBaseContainer, 19)
  self.textStarNum01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.textStarNum02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.textStarNum03 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.textStarNum04 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.textStarNum05 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
end

function UIS0AllianceBossSliderAlliance:ComponentDestroy()
  self.viewSkin = nil
  self.btnBubbleTip = nil
  self.imgIcon = nil
  self.textTxtNum = nil
  self.sliderProgress = nil
  self.btnStar01 = nil
  self.compStarAn01 = nil
  self.compStarLight01 = nil
  self.btnStar02 = nil
  self.compStarAn02 = nil
  self.compStarLight02 = nil
  self.btnStar03 = nil
  self.compStarAn03 = nil
  self.compStarLight03 = nil
  self.btnStar04 = nil
  self.compStarAn04 = nil
  self.compStarLight04 = nil
  self.btnStar05 = nil
  self.compStarAn05 = nil
  self.compStarLight05 = nil
  self.textStarNum01 = nil
  self.textStarNum02 = nil
  self.textStarNum03 = nil
  self.textStarNum04 = nil
  self.textStarNum05 = nil
end

function UIS0AllianceBossSliderAlliance:DataDefine()
  self.allianceDmgData = nil
  self.starLightList = {
    self.compStarLight01,
    self.compStarLight02,
    self.compStarLight03,
    self.compStarLight04,
    self.compStarLight05
  }
  self.starList = {
    self.compStarAn01,
    self.compStarAn02,
    self.compStarAn03,
    self.compStarAn04,
    self.compStarAn05
  }
  self.starNumList = {
    self.textStarNum01,
    self.textStarNum02,
    self.textStarNum03,
    self.textStarNum04,
    self.textStarNum05
  }
  self.scaleFactor = nil
  self.tipParam = nil
  self.viewDifficulty = nil
end

function UIS0AllianceBossSliderAlliance:DataDestroy()
  self.allianceDmgData = nil
  self.starLightList = nil
  self.starList = nil
  self.starNumList = nil
  self.scaleFactor = nil
  self.tipParam = nil
  self.viewDifficulty = nil
end

function UIS0AllianceBossSliderAlliance:OnAddListener()
  base.OnAddListener(self)
end

function UIS0AllianceBossSliderAlliance:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIS0AllianceBossSliderAlliance:InitView()
  self.imgIcon:LoadSpriteAuto(ALLIANCE_ICON_PATH)
end

function UIS0AllianceBossSliderAlliance:RefreshView(dmg, dmgMax, allianceDmgData, viewDifficulty, disableBtnBubbleTipClick)
  self.viewDifficulty = viewDifficulty
  local setValue = false
  if self.dmg ~= dmg or self.dmgMax ~= dmgMax then
    self.dmg = dmg
    self.dmgMax = dmgMax
    local dmgStr = string.GetFormattedStr(dmg)
    local dmgMaxStr = string.GetFormattedStr(dmgMax)
    self.textTxtNum:SetText(dmgStr .. "/" .. dmgMaxStr)
    setValue = true
  end
  self.allianceDmgData = allianceDmgData
  if allianceDmgData then
    local count = #allianceDmgData - 1
    local star = count
    local setStar = false
    for i, v in ipairs(allianceDmgData) do
      if v ~= -1 then
        local dmgStr = string.GetFormattedStr(v)
        self.starNumList[i]:SetText(dmgStr)
      end
      if not setStar and dmg < v then
        star = i - 1
        setStar = true
      end
    end
    if setValue then
      local value = 0
      local perValue = 1 / count
      if star == count then
        value = 1
      elseif star == 0 then
        value = dmg / allianceDmgData[1] * perValue
      elseif 0 < dmg then
        local curDmg = allianceDmgData[star]
        local nextDmg = allianceDmgData[star + 1]
        value = star * perValue + (dmg - curDmg) / (nextDmg - curDmg) * perValue
      end
      self.sliderProgress:SetValue(value)
    end
    for i = 1, count do
      self.starLightList[i]:SetActive(star >= i)
    end
  end
  if self.btnBubbleTip then
    if disableBtnBubbleTipClick then
      self.btnBubbleTip:SetInteractable(false)
    else
      self.btnBubbleTip:SetInteractable(true)
    end
  end
end

function UIS0AllianceBossSliderAlliance:OnBtnBubbleTipClick()
  if not DataCenter.S0AllianceBossDataManager:CheckMainLevelLimit() then
    return
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIS0AllianceBossRewardPreview) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWMailMain) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossRewardPreview, {anim = true}, {
    viewDifficulty = self.viewDifficulty,
    type = 1
  })
end

function UIS0AllianceBossSliderAlliance:OnBtnStar01Click()
  self:OnBtnStarClick(1)
end

function UIS0AllianceBossSliderAlliance:OnBtnStar02Click()
  self:OnBtnStarClick(2)
end

function UIS0AllianceBossSliderAlliance:OnBtnStar03Click()
  self:OnBtnStarClick(3)
end

function UIS0AllianceBossSliderAlliance:OnBtnStar04Click()
  self:OnBtnStarClick(4)
end

function UIS0AllianceBossSliderAlliance:OnBtnStar05Click()
  self:OnBtnStarClick(5)
end

function UIS0AllianceBossSliderAlliance:OnBtnStarClick(index)
  if self.allianceDmgData then
    local dmg = self.dmg or 0
    local dmgStr = string.GetFormattedStr2(dmg)
    local dmgMax = self.allianceDmgData[index]
    local dmgMaxStr
    if dmgMax == -1 then
      dmgMaxStr = "-"
    else
      dmgMaxStr = string.GetFormattedStr2(dmgMax)
    end
    local context = dmgStr .. "/" .. dmgMaxStr
    if self.scaleFactor == nil then
      self.scaleFactor = UIManager:GetInstance():GetScaleFactor()
    end
    local position = self.starList[index].transform.position + Vector3.New(0, 20, 0) * self.scaleFactor
    if self.tipParam == nil then
      self.tipParam = UIHeroTipView.Param.New()
    end
    local deltaX = 0
    if index == #self.starNumList then
      if CommonUtil.IsArabicAutoMirrorOpen() then
        deltaX = 20
      else
        deltaX = -20
      end
    end
    self.tipParam.content = context
    self.tipParam.dir = UIHeroTipView.Direction.ABOVE
    self.tipParam.defWidth = 150
    self.tipParam.pivot = 0.5
    self.tipParam.position = position
    self.tipParam.deltaX = deltaX
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, self.tipParam)
  end
end

return UIS0AllianceBossSliderAlliance
