local MailBattleMonsterBlood = BaseClass("MailBattleMonsterBlood", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local _cp_txtBloodBarTitle = "txtBloodBarTitle"
local _cp_imgSlideBar = "ObjSlideBar/imgSlideBar"
local _cp_txtSlideBar = "ObjSlideBar/txtSlideBar"
local _cp_btnMonsterHpInfo = "ObjSlideBar/btnMonsterHpInfo"
local _cp_ObjSlideBar = "ObjSlideBar"

function MailBattleMonsterBlood:OnCreate()
  base.OnCreate(self)
  self._txtBloodBarTitle = self:AddComponent(UIText, _cp_txtBloodBarTitle)
  self._imgSlideBar = self:AddComponent(UIImage, _cp_imgSlideBar)
  self._txtSlideBar = self:AddComponent(UIText, _cp_txtSlideBar)
  self._objSlideBar = self:AddComponent(UIBaseContainer, _cp_ObjSlideBar)
  local sliderRect = self._objSlideBar.rectTransform.rect
  self._slideBarTotalWidth = sliderRect.width - 4
  self._slideBarTotalHeight = sliderRect.height - 5
end

function MailBattleMonsterBlood:OnClickBtnMonsterHpInfo()
  local position = self._btnMonsterHpInfo.transform.position + Vector3.New(0, 10, 0)
  local strmsg = Localization:GetString("390830")
  self:ShowTips(position, strmsg)
end

function MailBattleMonsterBlood:ShowTips(position, strmsg)
  local param = UIHeroTipView.Param.New()
  param.content = strmsg
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 320
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function MailBattleMonsterBlood:SetData(rounddata)
  self._txtBloodBarTitle:SetLocalText(311058)
  local totalCnt = rounddata:GetArmyObjAttTotalCnt(eMailSoldierAttr.Total, false)
  local lostCnt = rounddata:GetAfterArmyObjAttTotalCnt(eMailSoldierAttr.Lost, false)
  local ratio = 0.0
  local battleResult = rounddata:GetBattleResult()
  if battleResult ~= FightResult.SELF_WIN or battleResult ~= FightResult.DRAW then
    ratio = 1 - lostCnt / totalCnt
    ratio = ratio < 0 and 0 or ratio
    ratio = 1 < ratio and 1 or ratio
  end
  local curlength = self._slideBarTotalWidth * ratio
  self._imgSlideBar.rectTransform:Set_sizeDelta(curlength, self._slideBarTotalHeight)
  local strRatio = string.format("%.1f%%", ratio * 100)
  self._txtSlideBar:SetText(strRatio)
end

return MailBattleMonsterBlood
