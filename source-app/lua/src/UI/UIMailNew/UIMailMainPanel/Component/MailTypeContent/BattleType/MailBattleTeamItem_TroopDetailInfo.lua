local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local MailBattleMonsterCom = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleType.MailBattleMonsterCom")
local MailBattleTeamItem_TroopDetailInfo = BaseClass("MailBattleTeamItem_TroopDetailInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local _cp_objLeftSide = "LeftSide"
local _cp_btnMoreDetail = "LeftSide/btnMoreDetail"
local _cp_txtTotalCntTitle_left = "LeftSide/txtTotalCntTitle_left"
local _cp_txtTotalCnt_left = "LeftSide/txtTotalCnt_left"
local _cp_txtHealTitle_left = "LeftSide/txtHealTitle_left"
local _cp_txtHealCnt_left = "LeftSide/txtHealCnt_left"
local _cp_txtDeadTitle_left = "LeftSide/txtDeadTitle_left"
local _cp_txtDeadCnt_left = "LeftSide/txtDeadCnt_left"
local _cp_txtInjureTitle_left = "LeftSide/txtInjureTitle_left"
local _cp_txtInjureCnt_left = "LeftSide/txtInjureCnt_left"
local _cp_btnInjure = "LeftSide/btnInjure"
local _cp_txtWoundedTitle_left = "LeftSide/txtWoundedTitle_left"
local _cp_txtWoundedCnt_left = "LeftSide/txtWoundedCnt_left"
local _cp_btnWounded = "LeftSide/btnWounded"
local _cp_txtAliveTitle_left = "LeftSide/txtAliveTitle_left"
local _cp_txtAliveCnt_left = "LeftSide/txtAliveCnt_left"
local _cp_ObjBloodBarNode_Right = "ObjBloodBarNode_Right"
local _cp_txtBloodBarTitle_Right = "ObjBloodBarNode_Right/txtBloodBarTitle_Right"
local _cp_objSlideBar_Right = "ObjBloodBarNode_Right/ObjSlideBar_Right"
local _cp_imgSlideBar_Right = "ObjBloodBarNode_Right/ObjSlideBar_Right/imgSlideBar_Right"
local _cp_txtSlideBar_Right = "ObjBloodBarNode_Right/ObjSlideBar_Right/txtSlideBar_Right"
local _cp_btnMonsterHpInfo_Right = "ObjBloodBarNode_Right/ObjSlideBar_Right/btnMonsterHpInfo_Right"
local _cp_ObjBloodBarNode_Left = "ObjBloodBarNode_Left"
local _cp_txtBloodBarTitle_Left = "ObjBloodBarNode_Left/txtBloodBarTitle_Left"
local _cp_objSlideBar_Left = "ObjBloodBarNode_Left/ObjSlideBar_Left"
local _cp_imgSlideBar_Left = "ObjBloodBarNode_Left/ObjSlideBar_Left/imgSlideBar_Left"
local _cp_txtSlideBar_Left = "ObjBloodBarNode_Left/ObjSlideBar_Left/txtSlideBar_Left"
local _cp_btnMonsterHpInfo_Left = "ObjBloodBarNode_Left/ObjSlideBar_Left/btnMonsterHpInfo_Left"
local _cp_objRightFormation = "RightFormation"
local _cp_ObjMonsterCom = "ObjMonsterCom"
local _cp_txtTotalCntTitle_right = "RightFormation/txtTotalCntTitle_right"
local _cp_txtTotalCnt_right = "RightFormation/txtTotalCnt_right"
local _cp_txtHealTitle_right = "RightFormation/txtHealTitle_right"
local _cp_txtHealCnt_right = "RightFormation/txtHealCnt_right"
local _cp_txtDeadTitle_right = "RightFormation/txtDeadTitle_right"
local _cp_txtDeadCnt_right = "RightFormation/txtDeadCnt_right"
local _cp_txtInjureTitle_right = "RightFormation/txtInjureTitle_right"
local _cp_txtInjureCnt_right = "RightFormation/txtInjureCnt_right"
local _cp_txtWoundedTitle_right = "RightFormation/txtWoundedTitle_right"
local _cp_txtWoundedCnt_right = "RightFormation/txtWoundedCnt_right"
local _cp_txtAliveTitle_right = "RightFormation/txtAliveTitle_right"
local _cp_txtAliveCnt_right = "RightFormation/txtAliveCnt_right"
local _cp_objDemage_left = "LeftSide/objDemage_left"
local _cp_txtBuildingDemageTitle_left = "LeftSide/objDemage_left/txtBuildingDemageTitle_left"
local _cp_txtBuildingDemageCnt_left = "LeftSide/objDemage_left/txtBuildingDemageCnt_left"
local _cp_objDemage_right = "RightFormation/objDemage_right"
local _cp_txtBuildingDemageTitle_right = "RightFormation/objDemage_right/txtBuildingDemageTitle_right"
local _cp_txtBuildingDemageCnt_right = "RightFormation/objDemage_right/txtBuildingDemageCnt_right"
local Const_Panel_Height_WithDemage = 315
local Const_Panel_Height = 265
local Const_Panel_Width = 770

function MailBattleTeamItem_TroopDetailInfo:OnCreate()
  base.OnCreate(self)
  self._root = self:AddComponent(UILayoutElement, "")
  self._objLeftSide = self:AddComponent(UIBaseContainer, _cp_objLeftSide)
  self._btnMoreDetail = self:AddComponent(UIButton, _cp_btnMoreDetail)
  self._btnMoreDetail:SetOnClick(BindCallback(self, self.OnClickMoreDetail))
  self._objDemage_left = self:AddComponent(UIBaseContainer, _cp_objDemage_left)
  self._txtBuildingDemageTitle_left = self:AddComponent(UIText, _cp_txtBuildingDemageTitle_left)
  self._txtBuildingDemageCnt_left = self:AddComponent(UIText, _cp_txtBuildingDemageCnt_left)
  self._objDemage_right = self:AddComponent(UIBaseContainer, _cp_objDemage_right)
  self._txtBuildingDemageTitle_right = self:AddComponent(UIText, _cp_txtBuildingDemageTitle_right)
  self._txtBuildingDemageCnt_right = self:AddComponent(UIText, _cp_txtBuildingDemageCnt_right)
  self._txtTotalCntTitle_left = self:AddComponent(UIText, _cp_txtTotalCntTitle_left)
  self._txtTotalCnt_left = self:AddComponent(UIText, _cp_txtTotalCnt_left)
  self._txtHealTitle_left = self:AddComponent(UIText, _cp_txtHealTitle_left)
  self._txtHealCnt_left = self:AddComponent(UIText, _cp_txtHealCnt_left)
  self._txtDeadTitle_left = self:AddComponent(UIText, _cp_txtDeadTitle_left)
  self._txtDeadCnt_left = self:AddComponent(UIText, _cp_txtDeadCnt_left)
  self._txtInjureTitle_left = self:AddComponent(UIText, _cp_txtInjureTitle_left)
  self._txtInjureCnt_left = self:AddComponent(UIText, _cp_txtInjureCnt_left)
  self._btnInjure = self:AddComponent(UIButton, _cp_btnInjure)
  self._btnInjure:SetOnClick(BindCallback(self, self.OnClickBtnInjure))
  self._txtWoundedTitle_left = self:AddComponent(UIText, _cp_txtWoundedTitle_left)
  self._txtWoundedCnt_left = self:AddComponent(UIText, _cp_txtWoundedCnt_left)
  self._btnWounded = self:AddComponent(UIButton, _cp_btnWounded)
  self._btnWounded:SetOnClick(BindCallback(self, self.OnClickBtnWounded))
  self._txtAliveTitle_left = self:AddComponent(UIText, _cp_txtAliveTitle_left)
  self._txtAliveCnt_left = self:AddComponent(UIText, _cp_txtAliveCnt_left)
  self._objBloodBarNode_Right = self:AddComponent(UIBaseContainer, _cp_ObjBloodBarNode_Right)
  self._txtBloodBarTitle_Right = self:AddComponent(UIText, _cp_txtBloodBarTitle_Right)
  self._objSlideBar_Right = self:AddComponent(UIBaseContainer, _cp_objSlideBar_Right)
  self._imgSlideBar_Right = self:AddComponent(UIImage, _cp_imgSlideBar_Right)
  self._txtSlideBar_Right = self:AddComponent(UIText, _cp_txtSlideBar_Right)
  self._btnMonsterHpInfo_Right = self:AddComponent(UIButton, _cp_btnMonsterHpInfo_Right)
  self._btnMonsterHpInfo_Right:SetOnClick(BindCallback(self, self.OnClickBtnMonsterHpInfo_Right))
  local sliderRect = self._objSlideBar_Right.rectTransform.rect
  self._slideBarTotalWidth_Right = sliderRect.width - 4
  self._slideBarTotalHeight_Right = sliderRect.height - 5
  self._objBloodBarNode_Left = self:AddComponent(UIBaseContainer, _cp_ObjBloodBarNode_Left)
  self._txtBloodBarTitle_Left = self:AddComponent(UIText, _cp_txtBloodBarTitle_Left)
  self._objSlideBar_Left = self:AddComponent(UIBaseContainer, _cp_objSlideBar_Left)
  self._imgSlideBar_Left = self:AddComponent(UIImage, _cp_imgSlideBar_Left)
  self._txtSlideBar_Left = self:AddComponent(UIText, _cp_txtSlideBar_Left)
  self._btnMonsterHpInfo_Left = self:AddComponent(UIButton, _cp_btnMonsterHpInfo_Left)
  self._btnMonsterHpInfo_Left:SetOnClick(BindCallback(self, self.OnClickBtnMonsterHpInfo_Left))
  local sliderRect = self._objSlideBar_Left.rectTransform.rect
  self._slideBarTotalWidth_Left = sliderRect.width
  self._slideBarTotalHeight_Left = sliderRect.height
  self._objRightFormation = self:AddComponent(UIBaseContainer, _cp_objRightFormation)
  self._txtTotalCntTitle_right = self:AddComponent(UIText, _cp_txtTotalCntTitle_right)
  self._txtTotalCnt_right = self:AddComponent(UIText, _cp_txtTotalCnt_right)
  self._txtHealTitle_right = self:AddComponent(UIText, _cp_txtHealTitle_right)
  self._txtHealCnt_right = self:AddComponent(UIText, _cp_txtHealCnt_right)
  self._txtDeadTitle_right = self:AddComponent(UIText, _cp_txtDeadTitle_right)
  self._txtDeadCnt_right = self:AddComponent(UIText, _cp_txtDeadCnt_right)
  self._txtInjureTitle_right = self:AddComponent(UIText, _cp_txtInjureTitle_right)
  self._txtInjureCnt_right = self:AddComponent(UIText, _cp_txtInjureCnt_right)
  self._txtWoundedTitle_right = self:AddComponent(UIText, _cp_txtWoundedTitle_right)
  self._txtWoundedCnt_right = self:AddComponent(UIText, _cp_txtWoundedCnt_right)
  self._txtAliveTitle_right = self:AddComponent(UIText, _cp_txtAliveTitle_right)
  self._txtAliveCnt_right = self:AddComponent(UIText, _cp_txtAliveCnt_right)
  self._ObjMonsterCom = self:AddComponent(MailBattleMonsterCom, _cp_ObjMonsterCom)
end

function MailBattleTeamItem_TroopDetailInfo:OnClickBtnMonsterHpInfo_Right()
  local position = self._btnMonsterHpInfo_Right.transform.position + Vector3.New(0, 10, 0)
  local strmsg = Localization:GetString("390830")
  self:ShowTips(position, strmsg)
end

function MailBattleTeamItem_TroopDetailInfo:OnClickBtnMonsterHpInfo_Left()
  local position = self._btnMonsterHpInfo_Left.transform.position + Vector3.New(0, 10, 0)
  local strmsg = Localization:GetString("390830")
  self:ShowTips(position, strmsg)
end

function MailBattleTeamItem_TroopDetailInfo:OnClickMoreDetail()
  local mySideInfo = self.rounddata:GetSelfArmyResult()
  if mySideInfo == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailTroopInfoListView, {anim = true}, mySideInfo)
end

function MailBattleTeamItem_TroopDetailInfo:OnClickBtnInjure()
  local position = self._btnInjure.transform.position + Vector3.New(-30, 0, 0)
  local strmsg = Localization:GetString("310135")
  self:ShowTips(position, strmsg)
end

function MailBattleTeamItem_TroopDetailInfo:OnClickBtnWounded()
  local position = self._btnWounded.transform.position + Vector3.New(-30, 0, 0)
  local strmsg = Localization:GetString("310136")
  self:ShowTips(position, strmsg)
end

function MailBattleTeamItem_TroopDetailInfo:ShowTips(position, strmsg)
  local param = UIHeroTipView.Param.New()
  param.content = strmsg
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 320
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function MailBattleTeamItem_TroopDetailInfo:OnEnable()
  base.OnEnable(self)
  self:InitDialog()
end

function MailBattleTeamItem_TroopDetailInfo:InitDialog()
  self._txtTotalCntTitle_left:SetLocalText(130068)
  self._txtHealTitle_left:SetLocalText(310130)
  self._txtDeadTitle_left:SetLocalText(310131)
  self._txtInjureTitle_left:SetLocalText(310132)
  self._txtWoundedTitle_left:SetLocalText(310133)
  self._txtAliveTitle_left:SetLocalText(310134)
  self._txtBuildingDemageTitle_left:SetLocalText(311056)
  self._txtBuildingDemageTitle_right:SetLocalText(311056)
end

function MailBattleTeamItem_TroopDetailInfo:OnDisable()
  base.OnDisable(self)
end

function MailBattleTeamItem_TroopDetailInfo:SetData(rounddata)
  self.rounddata = rounddata
  self.showDemageValue = false
  self:ShowMySide(rounddata)
  local targetBattleType = rounddata:GetTargetBattleType()
  if targetBattleType == BattleType.Monster or targetBattleType == BattleType.Boss then
    self:ShowTarget_Monster(rounddata)
  elseif targetBattleType == BattleType.Building or targetBattleType == BattleType.Road or targetBattleType == BattleType.City or targetBattleType == BattleType.Formation or targetBattleType == BattleType.ELITE_FIGHT_MAIL or targetBattleType == BattleType.RallyFormation then
    self:ShowTarget_Formation(rounddata)
  elseif targetBattleType == BattleType.Turret then
    self:ShowTargetSide_Turret(rounddata)
  elseif targetBattleType == BattleType.ALLIANCE_NEUTRAL_CITY or targetBattleType == BattleType.ALLIANCE_OCCUPIED_CITY then
    self:ShowTargetSide_Neatrul(rounddata)
  end
  if self.showDemageValue then
    self._root:SetPreferredHeight(Const_Panel_Height_WithDemage)
  else
    self._root:SetPreferredHeight(Const_Panel_Height)
  end
end

function MailBattleTeamItem_TroopDetailInfo:GetCurHeight()
  if self.showDemageValue then
    return Const_Panel_Height_WithDemage
  else
    return Const_Panel_Height
  end
end

function MailBattleTeamItem_TroopDetailInfo:ShowMySide(rounddata)
  local sBattleType = rounddata:GetSelfBattleType()
  if sBattleType == BattleType.Turret then
    self:ShowMySide_Turret(rounddata)
  elseif sBattleType == BattleType.ALLIANCE_OCCUPIED_CITY then
    self:ShowMySide_Neutral(rounddata)
  else
    self:ShowMySide_Formation(rounddata)
  end
end

function MailBattleTeamItem_TroopDetailInfo:ShowMySide_Neutral(rounddata)
  local sArmyResult = rounddata:GetSelfArmyResult()
  if sArmyResult == nil then
    return
  end
  local afterArmyObj = sArmyResult:GetAfterArmyObj()
  if afterArmyObj == nil then
    return
  end
  self._objLeftSide:SetActive(false)
  self._objBloodBarNode_Left:SetActive(true)
  self._objSlideBar_Left:SetActive(false)
  self._btnMonsterHpInfo_Left:SetActive(true)
  local initHealth = sArmyResult:GetNeutral_InitHealth()
  local curHealth = sArmyResult:GetNeutral_Health()
  local lostHealth = initHealth - curHealth
  lostHealth = 0 < lostHealth and lostHealth or 0
  lostHealth = lostHealth < 0 and 0 or lostHealth
  self._txtBloodBarTitle_Left:SetLocalText(104188, lostHealth)
end

function MailBattleTeamItem_TroopDetailInfo:ShowMySide_Formation(rounddata)
  self._objLeftSide:SetActive(true)
  self._objBloodBarNode_Left:SetActive(false)
  local total = rounddata:GetArmyObjAttTotalCnt(eMailSoldierAttr.Total, true) - rounddata:GetArmyObjAttTotalCnt(eMailSoldierAttr.Lost, true)
  local wounded = rounddata:GetSoldierAttrDisById(eMailSoldierAttr.Wounded, true)
  local injured = rounddata:GetSoldierAttrDisById(eMailSoldierAttr.Injured, true)
  local dead = rounddata:GetSoldierAttrDisById(eMailSoldierAttr.Dead, true)
  local lost = rounddata:GetSoldierAttrDisById(eMailSoldierAttr.Lost, true)
  local cure = rounddata:GetSoldierAttrDisById(eMailSoldierAttr.Cure, true)
  local alive = total - lost
  self._txtTotalCnt_left:SetText(total)
  self._txtWoundedCnt_left:SetText(wounded + cure)
  self._txtInjureCnt_left:SetText(injured)
  self._txtAliveCnt_left:SetText(alive)
  self._txtDeadCnt_left:SetText(dead)
  self._txtHealCnt_left:SetText(cure)
  local targetType = rounddata:GetTargetBattleType()
  local destroyValue = rounddata:GetDestroyValue(true)
  if 0 < destroyValue and (targetType == BattleType.Turret or targetType == BattleType.Building or targetType == BattleType.City or targetType == BattleType.Road) then
    self._objDemage_left:SetActive(true)
    self._txtBuildingDemageCnt_left:SetText(destroyValue)
    self.showDemageValue = true
  else
    self._objDemage_left:SetActive(false)
  end
end

function MailBattleTeamItem_TroopDetailInfo:ShowMySide_Turret(rounddata)
  local sArmyResult = rounddata:GetSelfArmyResult()
  if sArmyResult == nil then
    return
  end
  local afterArmyObj = sArmyResult:GetAfterArmyObj()
  if afterArmyObj == nil then
    return
  end
  local simpleCombatUnit = afterArmyObj:GetSimpleCombatUnit()
  if simpleCombatUnit == nil then
    return
  end
  self._txtBloodBarTitle_Left:SetLocalText(311058)
  self._objBloodBarNode_Left:SetActive(true)
  self._objSlideBar_Left:SetActive(false)
  self._btnMonsterHpInfo_Left:SetActive(true)
  self._objLeftSide:SetActive(false)
  local initHealth = simpleCombatUnit:GetInitHealth()
  local curHealth = simpleCombatUnit:GetHealth()
  local ratio = 0.0
  if 0 < initHealth then
    ratio = curHealth / initHealth
    ratio = ratio < 0 and 0 or ratio
    ratio = 1 < ratio and 1 or ratio
  end
  local curlength = self._slideBarTotalWidth_Left * ratio
  self._imgSlideBar_Left.rectTransform:Set_sizeDelta(curlength, self._slideBarTotalHeight_Left)
  local strRatio = string.format("%.1f%%", ratio * 100)
  self._txtSlideBar_Left:SetText(strRatio)
end

function MailBattleTeamItem_TroopDetailInfo:ShowTargetSide_Turret(rounddata)
  self._ObjMonsterCom:SetActive(false)
  local tArmyResult = rounddata:GetOtherArmyResult()
  if tArmyResult == nil then
    return
  end
  local afterArmyObj = tArmyResult:GetAfterArmyObj()
  if afterArmyObj == nil then
    return
  end
  local simpleCombatUnit = afterArmyObj:GetSimpleCombatUnit()
  if simpleCombatUnit == nil then
    return
  end
  self._txtBloodBarTitle_Right:SetLocalText(311058)
  self._objBloodBarNode_Right:SetActive(true)
  self._objSlideBar_Right:SetActive(true)
  self._btnMonsterHpInfo_Right:SetActive(true)
  self._objRightFormation:SetActive(false)
  local initHealth = simpleCombatUnit:GetInitHealth()
  local curHealth = simpleCombatUnit:GetHealth()
  local ratio = 0.0
  if 0 < initHealth then
    ratio = curHealth / initHealth
    ratio = ratio < 0 and 0 or ratio
    ratio = 1 < ratio and 1 or ratio
  end
  local curlength = self._slideBarTotalWidth_Right * ratio
  self._imgSlideBar_Right.rectTransform:Set_sizeDelta(curlength, self._slideBarTotalHeight_Right)
  local strRatio = string.format("%.1f%%", ratio * 100)
  self._txtSlideBar_Right:SetText(strRatio)
end

function MailBattleTeamItem_TroopDetailInfo:ShowTargetSide_Neatrul(rounddata)
  self._ObjMonsterCom:SetActive(false)
  local tArmyResult = rounddata:GetOtherArmyResult()
  if tArmyResult == nil then
    return
  end
  local afterArmyObj = tArmyResult:GetAfterArmyObj()
  if afterArmyObj == nil then
    return
  end
  self._objBloodBarNode_Right:SetActive(true)
  self._objSlideBar_Right:SetActive(false)
  self._btnMonsterHpInfo_Right:SetActive(true)
  self._objRightFormation:SetActive(false)
  local initHealth = tArmyResult:GetNeutral_InitHealth()
  local curHealth = tArmyResult:GetNeutral_Health()
  local lostHealth = initHealth - curHealth
  lostHealth = 0 < lostHealth and lostHealth or 0
  lostHealth = lostHealth < 0 and 0 or lostHealth
  self._txtBloodBarTitle_Right:SetLocalText(104188, lostHealth)
end

function MailBattleTeamItem_TroopDetailInfo:ShowTarget_Monster(rounddata)
  self._objBloodBarNode_Right:SetActive(false)
  self._btnMonsterHpInfo_Right:SetActive(false)
  self._objRightFormation:SetActive(false)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIShareMail) then
    self._ObjMonsterCom:SetActive(false)
    return
  end
  self._ObjMonsterCom:SetActive(true)
  self._ObjMonsterCom:SetData(rounddata)
end

function MailBattleTeamItem_TroopDetailInfo:ShowTarget_Formation(rounddata)
  self._objBloodBarNode_Right:SetActive(false)
  self._objRightFormation:SetActive(true)
  self._ObjMonsterCom:SetActive(false)
  local total = rounddata:GetArmyObjAttTotalCnt(eMailSoldierAttr.Total, false) - rounddata:GetArmyObjAttTotalCnt(eMailSoldierAttr.Lost, false)
  local wounded = rounddata:GetSoldierAttrDisById(eMailSoldierAttr.Wounded, false)
  local injured = rounddata:GetSoldierAttrDisById(eMailSoldierAttr.Injured, false)
  local dead = rounddata:GetSoldierAttrDisById(eMailSoldierAttr.Dead, false)
  local lost = rounddata:GetSoldierAttrDisById(eMailSoldierAttr.Lost, false)
  local cure = rounddata:GetSoldierAttrDisById(eMailSoldierAttr.Cure, false)
  local destroyValue = rounddata:GetDestroyValue(false)
  local alive = total - lost
  self._txtTotalCnt_right:SetText(total)
  self._txtWoundedCnt_right:SetText(wounded + cure)
  self._txtInjureCnt_right:SetText(injured)
  self._txtAliveCnt_right:SetText(alive)
  self._txtDeadCnt_right:SetText(dead)
  self._txtHealCnt_right:SetText(cure)
  self._txtBuildingDemageCnt_right:SetText(destroyValue)
  local selfType = rounddata:GetSelfBattleType()
  if 0 < destroyValue and (selfType == BattleType.Turret or selfType == BattleType.Building or selfType == BattleType.City or selfType == BattleType.Road) then
    self._objDemage_right:SetActive(true)
    self._txtBuildingDemageCnt_right:SetText(destroyValue)
    self.showDemageValue = true
  else
    self._objDemage_right:SetActive(false)
  end
end

return MailBattleTeamItem_TroopDetailInfo
