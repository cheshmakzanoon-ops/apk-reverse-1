local MailPlayerHeroItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleTypeNew.MailPlayerHeroItem")
local PlayerReportTroopListCell = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleTypeNew.PlayerReportTroopListCell")
local MailPlayerResResult = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleTypeNew.MailPlayerResResult")
local CampRestraintItem = require("UI.UIFormation.UIFormationTableNew.Component.CampRestraintItem")
local MailPlayerReport = BaseClass("MailPlayerReport", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local _cp_root = ""
local _cp_txtNameLeft = "root/PlayerReportTop/Left/txtNameLeft"
local _cp_txtKillLeft = "root/PlayerReportTop/Left/objKillLeft/txtKillLeft"
local _cp_txtKillNumLeft = "root/PlayerReportTop/Left/objKillLeft/txtKillNumLeft"
local _cp_careerLabelLeft = "root/PlayerReportTop/Left/UICareerLabelLeft"
local _cp_txtKillRight = "root/PlayerReportTop/Right/objKillRight/txtKillRight"
local _cp_txtKillNumRight = "root/PlayerReportTop/Right/objKillRight/txtKillNumRight"
local _cp_txtName_right = "root/PlayerReportTop/Right/txtName_right"
local _cp_careerLabelRight = "root/PlayerReportTop/Right/UICareerLabelRight"
local _cp_img_normal_left = "root/PlayerReportTop/objUserHead_left/ImageNormal_left"
local _cp_img_normal_right = "root/PlayerReportTop/objUserHead_right/ImageNormal_right"
local _cp_imgUserHead_left = "root/PlayerReportTop/objUserHead_left/imgUserHead_left"
local _cp_imgHeadBg_left = "root/PlayerReportTop/objUserHead_left/HeadBtnL"
local _cp_imgHeadFg_left = "root/PlayerReportTop/objUserHead_left/HeadFgL"
local _cp_imgUserHead_right = "root/PlayerReportTop/objUserHead_right/imgUserHead_right"
local _cp_imgHeadBg_right = "root/PlayerReportTop/objUserHead_right/HeadBtnR"
local _cp_imgHeadFg_right = "root/PlayerReportTop/objUserHead_right/HeadFgR"
local _cp_txtResult_right = "root/PlayerReportTop/txtResult_right"
local _cp_txtResult_left = "root/PlayerReportTop/txtResult_left"
local _cp_txtRound = "root/PlayerReportTop/txtRound"
local _cp_ObjHeroesLeftNode = "root/PlayerReportTop/ObjHeroesLeftNode/leftContent"
local _cp_ObjHeroesRightNode = "root/PlayerReportTop/ObjHeroesRightNode/rightContent"
local _cp_detail_left_btn = "root/PlayerReportTop/ObjHeroesLeftNode/leftBtnInfo"
local _cp_detail_right_btn = "root/PlayerReportTop/ObjHeroesRightNode/rightBtnInfo"
local _cp_txtNoHeroTips_Left = "root/PlayerReportTop/txtNoHeroTips_Left"
local _cp_txtNoHeroTips_Right = "root/PlayerReportTop/txtNoHeroTips_Right"
local _cp_CampRestraintItem_LeftBtn = "root/PlayerReportTop/leftCamp"
local _cp_CampRestraintItem_RightBtn = "root/PlayerReportTop/rightCamp"
local _cp_CampRestraintItem_Left = "root/PlayerReportTop/leftCamp/LeftCampRestraintItem"
local _cp_CampRestraintItem_Left_Add = "root/PlayerReportTop/leftCamp/camp_faction"
local _cp_CampRestraintItem_Right = "root/PlayerReportTop/rightCamp/RightCampRestraintItem"
local _cp_troopCell1 = "root/troopList/cell1"
local _cp_troopCell2 = "root/troopList/cell2"
local _cp_troopCell3 = "root/troopList/cell3"
local _cp_troopCell4 = "root/troopList/cell4"
local _cp_troopCell5 = "root/troopList/cell5"
local _cp_troopCell6 = "root/troopList/cell6"
local _cp_troopCell7 = "root/troopList/cell7"
local _cp_ObjBattleUserResult = "root/PlayerReportIncome"
local _cp_btnObj = "root/ObjBtnNode"
local _cp_ObjBattleDamageResult = "root/PlayerDamageObj"
local _cp_damageDes = "root/PlayerDamageObj/Des"
local _cp_damageImgBg = "root/PlayerDamageObj/dmgSliderBg"
local _cp_damageSlider = "root/PlayerDamageObj/dmgSliderBg/Image/dmgLeft/dmgSlider"
local _cp_damageLeft = "root/PlayerDamageObj/dmgSliderBg/Image/dmgLeft"
local _cp_damageLeft_text = "root/PlayerDamageObj/dmgSliderBg/Image/dmgLeft/dmgLeftText"
local _cp_damageSlider_text = "root/PlayerDamageObj/dmgSliderBg/Image/dmgLeft/dmgSlider/dmgSliderText"
local _cp_btnReport = "root/ObjBtnNode/layout/btnReport"
local _cp_txtReport = "root/ObjBtnNode/layout/btnReport/txtBtnReport"
local _cp_btnTroopInfo = "root/ObjBtnNode/layout/btnTroopInfo"
local _cp_txtTroopInfo = "root/ObjBtnNode/layout/btnTroopInfo/txtTroopInfo"
local _cp_btnReplay = "root/ObjBtnNode/layout/btnReplay"
local _cp_txtReplay = "root/ObjBtnNode/layout/btnReplay/txtReplay"

function MailPlayerReport:DataDefine()
end

function MailPlayerReport:OnCreate()
  base.OnCreate(self)
  self._root = self:AddComponent(UIBaseContainer, _cp_root)
  self._txtNameLeft = self:AddComponent(UIText, _cp_txtNameLeft)
  self._cp_careerLabelLeft = self:AddComponent(UICareerLabel, _cp_careerLabelLeft)
  self._imgUserHead_left = self:AddComponent(UIPlayerHead, _cp_imgUserHead_left)
  self._imgHeadBg_left = self:AddComponent(UIImage, _cp_imgHeadBg_left)
  self._imgHeadFg_left = self:AddComponent(UIImage, _cp_imgHeadFg_left)
  self._imgUserHead_right = self:AddComponent(UIPlayerHead, _cp_imgUserHead_right)
  self._imgHeadBg_right = self:AddComponent(UIImage, _cp_imgHeadBg_right)
  self._imgHeadFg_right = self:AddComponent(UIImage, _cp_imgHeadFg_right)
  self._imgUserHead_left_normal = self:AddComponent(CircleImage, _cp_img_normal_left)
  self._imgUserHead_right_normal = self:AddComponent(CircleImage, _cp_img_normal_right)
  self._cp_txtKillLeft = self:AddComponent(UIText, _cp_txtKillLeft)
  self._cp_txtKillNumLeft = self:AddComponent(UIText, _cp_txtKillNumLeft)
  self._cp_txtKillRight = self:AddComponent(UIText, _cp_txtKillRight)
  self._cp_txtKillNumRight = self:AddComponent(UIText, _cp_txtKillNumRight)
  self._txtNameRight = self:AddComponent(UIText, _cp_txtName_right)
  self._cp_careerLabelRight = self:AddComponent(UICareerLabel, _cp_careerLabelRight)
  self._txtResult_right = self:AddComponent(UIText, _cp_txtResult_right)
  self._txtResult_left = self:AddComponent(UIText, _cp_txtResult_left)
  self._txtRound = self:AddComponent(UIText, _cp_txtRound)
  self._cp_troopCell1 = self:AddComponent(PlayerReportTroopListCell, _cp_troopCell1)
  self._cp_troopCell2 = self:AddComponent(PlayerReportTroopListCell, _cp_troopCell2)
  self._cp_troopCell3 = self:AddComponent(PlayerReportTroopListCell, _cp_troopCell3)
  self._cp_troopCell4 = self:AddComponent(PlayerReportTroopListCell, _cp_troopCell4)
  self._cp_troopCell5 = self:AddComponent(PlayerReportTroopListCell, _cp_troopCell5)
  self._cp_troopCell6 = self:AddComponent(PlayerReportTroopListCell, _cp_troopCell6)
  self._cp_troopCell7 = self:AddComponent(PlayerReportTroopListCell, _cp_troopCell7)
  self._ObjBattleUserResult = self:AddComponent(MailPlayerResResult, _cp_ObjBattleUserResult)
  self._ObjBtn = self:AddComponent(UIBaseContainer, _cp_btnObj)
  self.ObjBattleDamageResult = self:AddComponent(UIBaseContainer, _cp_ObjBattleDamageResult)
  self.damageDes = self:AddComponent(UIText, _cp_damageDes)
  self.damageImgBg = self:AddComponent(UIImage, _cp_damageImgBg)
  self.damageSlider = self:AddComponent(UIImage, _cp_damageSlider)
  self.damageLeft = self:AddComponent(UIImage, _cp_damageLeft)
  self.damageSliderText = self:AddComponent(UIText, _cp_damageSlider_text)
  self.damageLeftText = self:AddComponent(UIText, _cp_damageLeft_text)
  self._btnReport = self:AddComponent(UIButton, _cp_btnReport)
  self._btnReport:SetOnClick(BindCallback(self, self.OnClickBtnReport))
  self._txtReport = self:AddComponent(UIText, _cp_txtReport)
  self._btnTroopInfo = self:AddComponent(UIButton, _cp_btnTroopInfo)
  self._btnTroopInfo:SetOnClick(BindCallback(self, self.OnClickBtnTroopInfo))
  self._txtTroopInfo = self:AddComponent(UIText, _cp_txtTroopInfo)
  self._btnReplay = self:AddComponent(UIButton, _cp_btnReplay)
  self._btnReplay:SetOnClick(BindCallback(self, self.OnClickBtnReplay))
  self._txtReplay = self:AddComponent(UIText, _cp_txtReplay)
  self.leftBtn = self:AddComponent(UIButton, _cp_detail_left_btn)
  self.leftBtn:SetOnClick(function()
    self:OnHeroDetailClick(true)
  end)
  self.rightBtn = self:AddComponent(UIButton, _cp_detail_right_btn)
  self.rightBtn:SetOnClick(function()
    self:OnHeroDetailClick(false)
  end)
  self._ObjHeroesLeftNode = self:AddComponent(UIBaseContainer, _cp_ObjHeroesLeftNode)
  self._ObjHeroesRightNode = self:AddComponent(UIBaseContainer, _cp_ObjHeroesRightNode)
  self._CampRestraintItem_LeftBtn = self:AddComponent(UIButton, _cp_CampRestraintItem_LeftBtn)
  self._CampRestraintItem_RightBtn = self:AddComponent(UIButton, _cp_CampRestraintItem_RightBtn)
  self._CampRestraintItem_LeftBtn:SetOnClick(function()
    self:OnLeftCampClick()
  end)
  self._CampRestraintItem_RightBtn:SetOnClick(function()
    self:OnRightCampClick()
  end)
  self._CampRestraintItem_Left = self:AddComponent(CampRestraintItem, _cp_CampRestraintItem_Left)
  self._CampRestraintItem_Right = self:AddComponent(CampRestraintItem, _cp_CampRestraintItem_Right)
  self._CampRestraintImg = self:AddComponent(UIImage, _cp_CampRestraintItem_Left_Add)
  self._txtNoHeroTips_Left = self:AddComponent(UIText, _cp_txtNoHeroTips_Left)
  self._txtNoHeroTips_Right = self:AddComponent(UIText, _cp_txtNoHeroTips_Right)
  self.leftModel = {}
  self.rightModel = {}
end

function MailPlayerReport:OnEnable()
  base.OnEnable(self)
  self:InitDialog()
end

function MailPlayerReport:InitDialog()
  self._txtReport:SetLocalText(311047)
  self._txtTroopInfo:SetLocalText(311048)
  self._cp_txtKillLeft:SetLocalText(310139)
  self._cp_txtKillRight:SetLocalText(310139)
  self._txtReplay:SetLocalText(372265)
  self._cp_troopCell1:InitDialog(130068, BattleReportShowType.Soldier)
  self._cp_troopCell4:InitDialog(163138, BattleReportShowType.Atk)
  self._cp_troopCell5:InitDialog(163139, BattleReportShowType.Def)
  self._cp_troopCell7:InitDialog(163141, BattleReportShowType.SoldierLevel)
  self._cp_troopCell6:InitDialog(163140, BattleReportShowType.Health)
  self._cp_troopCell2:InitDialog(220206, BattleReportShowType.HeroAtk)
  self._cp_troopCell3:InitDialog(220207, BattleReportShowType.HeroDef)
  self._txtResult_right:SetText("")
  self._txtResult_left:SetText("")
  self._txtRound:SetText("")
end

function MailPlayerReport:OnClickBtnReport()
end

function MailPlayerReport:OnClickBtnTroopInfo()
  local param = {}
  param.leftFightData = self.leftFightData
  param.rightFightData = self.rightFightData
  param.leftBattleEffect = self.leftBattleEffect
  param.rightBattleEffect = self.rightBattleEffect
  param.leftUuid = self.leftUuid
  param.rightUuid = self.rightUuid
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailBattleAttrDetail, {anim = false}, param)
end

function MailPlayerReport:OnDisable()
  self:ClearLeftHero()
  self:ClearRightHero()
  base.OnDisable(self)
end

function MailPlayerReport:onDestroy()
  BattleReportUtil.Cancel()
  base.OnDestroy(self)
end

function MailPlayerReport:ClearLeftHero()
  self._ObjHeroesLeftNode:RemoveComponents(MailPlayerHeroItem)
  if self.leftModel ~= nil then
    for k, v in pairs(self.leftModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.leftModel = {}
end

function MailPlayerReport:ClearRightHero()
  self._ObjHeroesRightNode:RemoveComponents(MailPlayerHeroItem)
  if self.rightModel ~= nil then
    for k, v in pairs(self.rightModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rightModel = {}
end

function MailPlayerReport:SetData(maildata, roundIndex, showReplay, jumpType)
  self._btnReplay:SetActive(showReplay ~= nil and showReplay == true)
  self._mailId = maildata.uid
  self.roundIndex = roundIndex
  self.jumpType = jumpType
  local _showData = maildata:GetMailExt():GetShowRoundListDataByIndex(roundIndex)
  if _showData == nil then
    return
  end
  self._mailInfo = maildata
  self.leftFightData = _showData.leftData
  self.rightFightData = _showData.rightData
  self.bigRoundIndex = _showData._roundIndex
  self.bigRoundUuid = _showData.roundUuid
  self.fightResult = _showData.fightResult
  self.leftHurt = _showData.leftHurt
  self.rightHurt = _showData.rightHurt
  self.leftUuid = _showData.leftUuid
  self.rightUuid = _showData.rightUuid
  self.leftBattleEffect = self._mailInfo:GetMailExt():GetMySideBattleEffect(self.leftUuid)
  self.rightBattleEffect = self._mailInfo:GetMailExt():GetOtherSideBattleEffect(self.rightUuid)
  self:DataDefine()
  self._cp_troopCell1:SetRoundData(self.leftFightData, self.rightFightData)
  self._cp_troopCell2:SetRoundData(self.leftFightData, self.rightFightData)
  self._cp_troopCell3:SetRoundData(self.leftFightData, self.rightFightData)
  self._cp_troopCell4:SetRoundData(self.leftFightData, self.rightFightData)
  self._cp_troopCell5:SetRoundData(self.leftFightData, self.rightFightData)
  self._cp_troopCell6:SetRoundData(self.leftFightData, self.rightFightData)
  self._cp_troopCell7:SetRoundData(self.leftFightData, self.rightFightData)
  local showDetail = self.leftFightData.unitData ~= nil and self.leftFightData.unitAttrInfo ~= nil and self.rightFightData.unitData ~= nil and self.rightFightData.unitAttrInfo ~= nil
  self._cp_troopCell2:SetActive(showDetail)
  self._cp_troopCell3:SetActive(showDetail)
  self._cp_troopCell4:SetActive(showDetail)
  self._cp_troopCell5:SetActive(showDetail)
  self._cp_troopCell6:SetActive(showDetail)
  self._cp_troopCell7:SetActive(showDetail)
  self._ObjBattleUserResult:SetData(self.leftFightData, self.rightFightData, self.bigRoundIndex, maildata, self.leftUuid, self.rightUuid)
  self._ObjBattleUserResult:SetActive(self._ObjBattleUserResult:GetResCount() > 0)
  self:ShowHeadInfo()
  self:ShowHeroes()
  self:ShowTroopAttr()
  self:SetAttackAddData()
  self:SetDefenceAddData()
  self:SetHealthAddData()
  self:ShowHurt()
  self:ShowDamage()
  self:SetCampData()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function MailPlayerReport:ShowHeadInfo()
  if self.leftFightData.unitData == nil then
    if self.leftFightData.name ~= nil then
      self._txtNameLeft:SetText(self.leftFightData.name)
    end
    if self.leftFightData.pic ~= nil and self.leftFightData.pic ~= "" then
      self._imgUserHead_left:SetActive(false)
      self._imgUserHead_left_normal:SetActive(true)
      self._imgUserHead_left_normal:LoadSpriteAuto(self.leftFightData.pic)
    end
    self._cp_careerLabelLeft:SetActive(false)
  else
    local selfAbbr = self.leftFightData.unitData.alAbbr
    local selfname = self.leftFightData.unitData.name
    local selfType = self.leftFightData.unitData:GetSpecialType()
    if selfType == SpecialUnitType.BUILDING_STATION then
      self._txtNameLeft:SetText(Localization:GetString("140311"))
      self._imgUserHead_left:SetActive(false)
      self._imgUserHead_left_normal:SetActive(true)
      self._imgUserHead_left_normal:LoadSprite("Assets/Main/Sprites/HeroIconsSmall/round_hero_icon_43001.png")
      self._cp_careerLabelLeft:SetRootActive(false)
    elseif selfType == SpecialUnitType.ALLIANCE_CITY_NPC then
      self._txtNameLeft:SetText(Localization:GetString("302119"))
      self._imgUserHead_left:SetActive(false)
      self._imgUserHead_left_normal:SetActive(true)
      self._imgUserHead_left_normal:LoadSprite("Assets/Main/Sprites/BuildIconOutCity/alliance_city.png")
      self._cp_careerLabelLeft:SetRootActive(false)
    elseif selfType == SpecialUnitType.DESERT_NPC then
      self._txtNameLeft:SetText(Localization:GetString("110251"))
      self._imgUserHead_left:SetActive(false)
      self._imgUserHead_left_normal:SetActive(true)
      self._imgUserHead_left_normal:LoadSprite("Assets/Main/Sprites/BuildIconOutCity/alliance_city.png")
      self._cp_careerLabelLeft:SetRootActive(false)
    else
      local str = selfname
      if selfAbbr ~= nil and selfAbbr ~= "" then
        str = "[" .. selfAbbr .. "]" .. str
      end
      self._txtNameLeft:SetText(str)
      self._imgUserHead_left:SetActive(true)
      self._imgUserHead_left_normal:SetActive(false)
      self._imgUserHead_left:SetData(self.leftFightData.unitData:GetUserId(), self.leftFightData.unitData.pic, self.leftFightData.unitData.picVer)
      self._imgHeadFg_left:SetActive(false)
      self._cp_careerLabelLeft:SetData(self.leftFightData.unitData.careerType, self.leftFightData.unitData.careerLv)
    end
  end
  if self.rightFightData.unitData == nil then
    if self.rightFightData.name ~= nil then
      self._txtNameRight:SetText(self.rightFightData.name)
    end
    if self.rightFightData.pic ~= nil and self.rightFightData.pic ~= "" then
      self._imgUserHead_right:SetActive(false)
      self._imgUserHead_right_normal:SetActive(true)
      self._imgUserHead_right_normal:LoadSpriteAuto(self.rightFightData.pic)
    end
    self._cp_careerLabelRight:SetRootActive(false)
  else
    local otherAbbr = self.rightFightData.unitData.alAbbr
    local othername = self.rightFightData.unitData.name
    local otherType = self.rightFightData.unitData:GetSpecialType()
    if self.rightFightData.battleType == BattleType.Monster or self.rightFightData.battleType == BattleType.CHALLENGE_BOSS then
      self._txtNameRight:SetText(self.rightFightData.name)
      local monsterPic = "Assets/Main/Sprites/HeroIconsSmall/UIPVEorder_img_guai.png"
      self._imgUserHead_right:SetActive(false)
      self._imgUserHead_right_normal:SetActive(true)
      self._imgUserHead_right_normal:LoadSprite(monsterPic)
      self._cp_careerLabelRight:SetRootActive(false)
    elseif self.rightFightData.battleType == BattleType.Boss then
      self._txtNameRight:SetText(self.rightFightData.name)
      local monsterPic = "Assets/Main/Sprites/UI/UISearch/UISearch_icon_monster.png"
      self._imgUserHead_right:SetActive(false)
      self._imgUserHead_right_normal:SetActive(true)
      self._imgUserHead_right_normal:LoadSprite(monsterPic)
      self._cp_careerLabelRight:SetRootActive(false)
    elseif self.rightFightData.battleType == BattleType.ACT_BOSS then
      self._txtNameRight:SetText(self.rightFightData.name)
      local monsterPic = "Assets/Main/Sprites/HeroIconsSmall/hero_icon_bossBoat.png"
      self._imgUserHead_right:SetActive(false)
      self._imgUserHead_right_normal:SetActive(true)
      self._imgUserHead_right_normal:LoadSprite(monsterPic)
      self._cp_careerLabelRight:SetRootActive(false)
    elseif self.rightFightData.battleType == BattleType.PUZZLE_BOSS then
      self._txtNameRight:SetText(self.rightFightData.name)
      local monsterPic = "Assets/Main/Sprites/HeroIconsSmall/hero_icon_bossBoat.png"
      self._imgUserHead_right:SetActive(false)
      self._imgUserHead_right_normal:SetActive(true)
      self._imgUserHead_right_normal:LoadSprite(monsterPic)
      self._cp_careerLabelRight:SetRootActive(false)
    elseif self.rightFightData.battleType == BattleType.Explore then
      self._txtNameRight:SetText(self.rightFightData.name)
      local monsterPic = "Assets/Main/Sprites/HeroIconsSmall/hero_icon_monster02.png"
      self._imgUserHead_right:SetActive(false)
      self._imgUserHead_right_normal:SetActive(true)
      self._imgUserHead_right_normal:LoadSprite(monsterPic)
      self._cp_careerLabelRight:SetRootActive(false)
    elseif otherType == SpecialUnitType.BUILDING_STATION then
      self._txtNameRight:SetText(Localization:GetString("140311"))
      self._imgUserHead_right:SetActive(false)
      self._imgUserHead_right_normal:SetActive(true)
      self._imgUserHead_right_normal:LoadSprite("Assets/Main/Sprites/HeroIconsSmall/round_hero_icon_43001.png")
      self._cp_careerLabelRight:SetRootActive(false)
    elseif otherType == SpecialUnitType.ALLIANCE_CITY_NPC then
      self._txtNameRight:SetText(Localization:GetString("302119"))
      self._imgUserHead_right:SetActive(false)
      self._imgUserHead_right_normal:SetActive(true)
      self._imgUserHead_right_normal:LoadSprite("Assets/Main/Sprites/BuildIconOutCity/alliance_city.png")
      self._cp_careerLabelRight:SetRootActive(false)
    elseif otherType == SpecialUnitType.DESERT_NPC then
      self._txtNameRight:SetText(Localization:GetString("110251"))
      self._imgUserHead_right:SetActive(false)
      self._imgUserHead_right_normal:SetActive(true)
      self._imgUserHead_right_normal:LoadSprite("Assets/Main/Sprites/BuildIconOutCity/alliance_city.png")
      self._cp_careerLabelRight:SetRootActive(false)
    else
      if othername == "" then
        othername = Localization:GetString("100184")
      end
      local str = othername
      if otherAbbr ~= nil and otherAbbr ~= "" then
        str = "[" .. otherAbbr .. "]" .. str
      end
      self._txtNameRight:SetText(str)
      self._imgUserHead_right:SetActive(true)
      self._imgUserHead_right_normal:SetActive(false)
      self._imgUserHead_right:SetData(self.rightFightData.unitData:GetUserId(), self.rightFightData.unitData.pic, self.rightFightData.unitData.picVer)
      self._imgHeadFg_right:SetActive(false)
      self._cp_careerLabelRight:SetData(self.rightFightData.unitData.careerType, self.rightFightData.unitData.careerLv)
    end
  end
  if self._mailInfo.type == MailType.ELITE_FIGHT_MAIL and self.rightFightData.battleType == BattleType.ELITE_FIGHT_MAIL then
    self:ShowBattleResultInfo()
    self:ShowBattleRoundInfo()
  end
end

function MailPlayerReport:ShowBattleResultInfo()
  if self.fightResult == FightResult.OTHER_WIN then
    self._txtResult_right:SetLocalText(390186)
    self._txtResult_left:SetLocalText(390187)
  else
    self._txtResult_right:SetLocalText(390187)
    self._txtResult_left:SetLocalText(390186)
  end
end

function MailPlayerReport:ShowBattleRoundInfo()
  self._txtRound:SetLocalText(302069, self.roundIndex)
end

function MailPlayerReport:ShowHeroes()
  self:ShowHeroes_Self()
  self:ShowHeroes_TargetUser()
end

function MailPlayerReport:AddHeroNode(heroInfo, parentNode)
  local item = self._prefab_hero:GameObjectSpawn(parentNode.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = parentNode:AddComponent(MailPlayerHeroItem, item.name)
  obj:SetData(heroInfo)
end

function MailPlayerReport:ShowHeroes_Self()
  self:ClearLeftHero()
  local heroes = {}
  local selfType = SpecialUnitType.NONE
  if self.leftFightData.unitData ~= nil then
    heroes = self.leftFightData.unitData:GetPlayerHeroes()
    selfType = self.leftFightData.unitData:GetSpecialType()
  end
  if table.count(heroes) == 0 then
    local des = Localization:GetString("182047")
    if selfType == SpecialUnitType.BUILDING_STATION then
      des = Localization:GetString("140330", self.leftFightData.name)
    end
    self._txtNoHeroTips_Left:SetActive(true)
    self._txtNoHeroTips_Left:SetText(des)
    return
  end
  self._txtNoHeroTips_Left:SetActive(false)
  local heroList = table.values(heroes)
  table.sort(heroList, function(heroA, heroB)
    return heroA.index < heroB.index
  end)
  for _, heroInfo in pairs(heroList) do
    if self.leftModel[_] == nil then
      self.leftModel[_] = self:GameObjectInstantiateAsync(UIAssets.MailPlayerHeroItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._ObjHeroesLeftNode.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self._ObjHeroesLeftNode:AddComponent(MailPlayerHeroItem, nameStr)
        cell:SetData(heroInfo, self, true)
      end)
    end
  end
end

function MailPlayerReport:ShowHeroes_TargetUser()
  self:ClearRightHero()
  local heroes = {}
  local otherType = SpecialUnitType.NONE
  if self.rightFightData.unitData ~= nil then
    heroes = self.rightFightData.unitData:GetPlayerHeroes()
    otherType = self.rightFightData.unitData:GetSpecialType()
  end
  if table.count(heroes) == 0 then
    local des = Localization:GetString("182047")
    if otherType == SpecialUnitType.BUILDING_STATION then
      des = Localization:GetString("140330", self.rightFightData.name)
    end
    self._txtNoHeroTips_Right:SetActive(true)
    self._txtNoHeroTips_Right:SetText(des)
    return
  end
  self._txtNoHeroTips_Right:SetActive(false)
  local heroList = table.values(heroes)
  table.sort(heroList, function(heroA, heroB)
    return heroA.index < heroB.index
  end)
  for _, heroInfo in pairs(heroList) do
    if self.rightModel[_] == nil then
      self.rightModel[_] = self:GameObjectInstantiateAsync(UIAssets.MailPlayerHeroItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._ObjHeroesRightNode.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self._ObjHeroesRightNode:AddComponent(MailPlayerHeroItem, nameStr)
        cell:SetData(heroInfo, self, false)
      end)
    end
  end
end

function MailPlayerReport:ShowTroopAttr()
  self:ShowAttrLeft()
  self:ShowAttrRight()
end

function MailPlayerReport:ShowAttrLeft()
  if self.leftFightData.unitData ~= nil and self.leftFightData.unitAttrInfo ~= nil then
    local total = self.leftFightData.unitData:GetAttTotalCnt(eMailSoldierAttr.Total)
    local lost = self.leftFightData.unitData:GetAttTotalCnt(eMailSoldierAttr.Lost)
    local rest = math.max(0, total - lost)
    local levelStr = self.leftFightData.unitData:GetSoliderLvStr()
    local attr = self.leftFightData.unitAttrInfo
    local heroAtk = attr:GetAtkAttrByType(AtkDefReason.HERO)
    local heroDef = attr:GetDefAttrByType(AtkDefReason.HERO)
    self._cp_troopCell1:SetLeftValue(string.GetFormattedSeperatorNum(math.floor(rest)))
    self._cp_troopCell7:SetLeftValue(levelStr)
    self._cp_troopCell2:SetLeftValue(string.GetFormattedSeperatorNum(math.floor(heroAtk)))
    self._cp_troopCell3:SetLeftValue(string.GetFormattedSeperatorNum(math.floor(heroDef)))
  else
    self._cp_troopCell1:SetLeftValue("0")
    self._cp_troopCell2:SetLeftValue("0")
    self._cp_troopCell3:SetLeftValue("0")
    self._cp_troopCell7:SetLeftValue("")
  end
end

function MailPlayerReport:ShowAttrRight()
  if self.rightFightData.unitData ~= nil and self.rightFightData.unitAttrInfo ~= nil then
    local total = self.rightFightData.unitData:GetAttTotalCnt(eMailSoldierAttr.Total)
    local lost = self.rightFightData.unitData:GetAttTotalCnt(eMailSoldierAttr.Lost)
    local rest = math.max(0, total - lost)
    local levelStr = self.rightFightData.unitData:GetSoliderLvStr()
    local attr = self.rightFightData.unitAttrInfo
    local heroAtk = attr:GetAtkAttrByType(AtkDefReason.HERO)
    local heroDef = attr:GetDefAttrByType(AtkDefReason.HERO)
    self._cp_troopCell1:SetRightValue(string.GetFormattedSeperatorNum(math.floor(rest)))
    self._cp_troopCell7:SetRightValue(levelStr)
    self._cp_troopCell2:SetRightValue(string.GetFormattedSeperatorNum(math.floor(heroAtk)))
    self._cp_troopCell3:SetRightValue(string.GetFormattedSeperatorNum(math.floor(heroDef)))
  else
    self._cp_troopCell1:SetRightValue("0")
    self._cp_troopCell2:SetRightValue("0")
    self._cp_troopCell3:SetRightValue("0")
    self._cp_troopCell7:SetRightValue("")
  end
end

function MailPlayerReport:ShowHurt()
  self._cp_txtKillNumLeft:SetText(string.GetFormattedSeperatorNum(math.floor(self.leftHurt)))
  self._cp_txtKillNumRight:SetText(string.GetFormattedSeperatorNum(math.floor(self.rightHurt)))
  if self.rightFightData.battleType == BattleType.ACT_BOSS or self.rightFightData.battleType == BattleType.PUZZLE_BOSS or self.rightFightData.battleType == BattleType.CHALLENGE_BOSS then
    self._cp_txtKillLeft:SetText("")
    self._cp_txtKillRight:SetText("")
    self._cp_txtKillNumLeft:SetText("")
    self._cp_txtKillNumRight:SetText("")
  end
end

function MailPlayerReport:ShowDamage()
  self.damageImgBg:SetActive(false)
  if self.rightFightData.battleType == BattleType.ACT_BOSS or self.rightFightData.battleType == BattleType.PUZZLE_BOSS or self.rightFightData.battleType == BattleType.CHALLENGE_BOSS then
    self._ObjBtn:SetActive(false)
    self.ObjBattleDamageResult:SetActive(true)
    local damage = 0
    local damagePercentStr = ""
    if self.rightFightData.unitData ~= nil and self.rightFightData.afterUnitData ~= nil and self.rightFightData.damagePercent ~= nil then
      local beforeHealth = self.rightFightData.unitData:GetHealth()
      local afterHealth = self.rightFightData.afterUnitData:GetHealth()
      local initHealth = self.rightFightData.unitData:GetInitHealth()
      local rightDamagePercent = self.rightFightData.damagePercent.damagePercent
      damage = math.max((beforeHealth - afterHealth) * rightDamagePercent, 0)
      if self.rightFightData.battleType == BattleType.PUZZLE_BOSS then
        self.damageImgBg:SetActive(true)
        local rect = self.damageImgBg.rectTransform.rect
        local leftPercent = math.ceil(afterHealth * 1000 / initHealth) / 1000
        local dmgPercent = math.floor((beforeHealth - afterHealth) * 1000 / initHealth) / 1000
        if 1 < dmgPercent + leftPercent then
          leftPercent = 1 - dmgPercent
        end
        leftPercent = Mathf.Clamp(leftPercent, 0, 1)
        dmgPercent = Mathf.Clamp(dmgPercent, 0, 1)
        self.damageLeft.rectTransform:Set_sizeDelta(rect.width * leftPercent, rect.height)
        self.damageSlider.rectTransform:Set_sizeDelta(rect.width * dmgPercent, rect.height)
        self.damageSliderText:SetText("")
        if beforeHealth ~= afterHealth then
          damagePercentStr = string.GetFormattedPercentStr(dmgPercent)
        end
        if afterHealth == 0 then
          self.damageLeftText:SetText("")
        else
          self.damageLeftText:SetText(string.GetFormattedPercentStr(leftPercent))
        end
      end
    end
    local damageStr = string.format("<color=#dd2828> %s</color>", string.GetFormattedSeperatorNum(math.ceil(damage)))
    if not string.IsNullOrEmpty(damagePercentStr) then
      damageStr = damageStr .. "(" .. damagePercentStr .. ")"
    end
    self.damageDes:SetText(Localization:GetString("302192", damageStr))
  else
    self._ObjBtn:SetActive(true)
    self.ObjBattleDamageResult:SetActive(false)
  end
end

function MailPlayerReport:SetAttackAddData()
  local leftNum = 0
  local rightNum = 0
  local leftFightData = self.leftFightData
  local rightFightData = self.rightFightData
  local leftBattleEffect = self.leftBattleEffect
  local rightBattleEffect = self.rightBattleEffect
  if leftBattleEffect ~= nil then
    leftNum = leftNum + leftBattleEffect:GetValue(35000)
    local aLeftPercent = 0
    if leftFightData ~= nil and leftFightData.unitData ~= nil then
      aLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
    end
    leftNum = leftNum + leftBattleEffect:GetValue(35001) * aLeftPercent
    local bLeftPercent = 0
    if leftFightData ~= nil and leftFightData.unitData ~= nil then
      bLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
    end
    leftNum = leftNum + leftBattleEffect:GetValue(35002) * bLeftPercent
    local cLeftPercent = 0
    if leftFightData ~= nil and leftFightData.unitData ~= nil then
      cLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
    end
    leftNum = leftNum + leftBattleEffect:GetValue(35003) * cLeftPercent
  end
  if rightBattleEffect ~= nil then
    rightNum = rightNum + rightBattleEffect:GetValue(35000)
    local aRightPercent = 0
    if rightFightData ~= nil and rightFightData.unitData ~= nil then
      aRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
    end
    rightNum = rightNum + rightBattleEffect:GetValue(35001) * aRightPercent
    local bRightPercent = 0
    if rightFightData ~= nil and rightFightData.unitData ~= nil then
      bRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
    end
    rightNum = rightNum + rightBattleEffect:GetValue(35002) * bRightPercent
    local cRightPercent = 0
    if rightFightData ~= nil and rightFightData.unitData ~= nil then
      cRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
    end
    rightNum = rightNum + rightBattleEffect:GetValue(35003) * cRightPercent
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if (leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret) and leftBattleEffect ~= nil then
      leftNum = leftNum + leftBattleEffect:GetValue(35048)
    end
    if (rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret) and rightBattleEffect ~= nil then
      rightNum = rightNum + rightBattleEffect:GetValue(35048)
    end
    if (rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret) and leftBattleEffect ~= nil then
      leftNum = leftNum + leftBattleEffect:GetValue(35040)
    end
    if (leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret) and rightBattleEffect ~= nil then
      rightNum = rightNum + rightBattleEffect:GetValue(35040)
    end
    if (leftFightData.battleType == BattleType.RallyFormation or leftFightData.battleType == BattleType.Formation or leftFightData.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB) and (rightFightData.battleType == BattleType.RallyFormation or rightFightData.battleType == BattleType.Formation or rightFightData.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB) then
      if leftBattleEffect ~= nil then
        leftNum = leftNum + leftBattleEffect:GetValue(35024)
      end
      if rightBattleEffect ~= nil then
        rightNum = rightNum + rightBattleEffect:GetValue(35024)
      end
    end
    if (leftFightData.battleType == BattleType.RallyFormation or leftFightData.battleType == BattleType.Formation) and (rightFightData.battleType == BattleType.Monster or rightFightData.battleType == BattleType.Boss or rightFightData.battleType == BattleType.ACT_BOSS or rightFightData.battleType == BattleType.PUZZLE_BOSS or rightFightData.battleType == BattleType.CHALLENGE_BOSS) then
      if leftBattleEffect ~= nil then
        leftNum = leftNum + leftBattleEffect:GetValue(35056)
      end
      if rightBattleEffect ~= nil then
        rightNum = rightNum + rightBattleEffect:GetValue(35056)
      end
    end
    if leftFightData.battleType == BattleType.RallyFormation and leftBattleEffect ~= nil then
      leftNum = leftNum + leftBattleEffect:GetValue(35032)
    end
    if rightFightData.battleType == BattleType.RallyFormation and rightBattleEffect ~= nil then
      rightNum = rightNum + rightBattleEffect:GetValue(35032)
    end
    if (leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret) and leftFightData.unitData ~= nil and leftFightData.unitData:GetSpecialType() == SpecialUnitType.NONE and leftBattleEffect ~= nil then
      leftNum = leftNum + leftBattleEffect:GetValue(35133)
    end
    if (rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret) and rightFightData.unitData ~= nil and rightFightData.unitData:GetSpecialType() == SpecialUnitType.NONE and rightBattleEffect ~= nil then
      rightNum = rightNum + rightBattleEffect:GetValue(35133)
    end
    if leftFightData.unitData ~= nil then
      local index = leftFightData.unitData:GetFormationIndex()
      local effectId = 0
      if rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret then
        if index == 1 then
          effectId = 40051
        elseif index == 2 then
          effectId = 40052
        elseif index == 3 then
          effectId = 40053
        elseif index == 4 then
          effectId = 40054
        end
        if 0 < effectId then
          local effectNum = leftBattleEffect:GetValue(effectId)
          leftNum = leftNum + effectNum
        end
      end
      effectId = 0
      if index == 1 then
        effectId = 40036
      elseif index == 2 then
        effectId = 40037
      elseif index == 3 then
        effectId = 40038
      elseif index == 4 then
        effectId = 40039
      end
      if 0 < effectId then
        local effectNum = leftBattleEffect:GetValue(effectId)
        leftNum = leftNum + effectNum
      end
    end
    if rightFightData.unitData ~= nil then
      local index = rightFightData.unitData:GetFormationIndex()
      local effectId = 0
      if leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret then
        if index == 1 then
          effectId = 40051
        elseif index == 2 then
          effectId = 40052
        elseif index == 3 then
          effectId = 40053
        elseif index == 4 then
          effectId = 40054
        end
        if 0 < effectId then
          local effectNum = rightBattleEffect:GetValue(effectId)
          rightNum = rightNum + effectNum
        end
      end
      effectId = 0
      if index == 1 then
        effectId = 40036
      elseif index == 2 then
        effectId = 40037
      elseif index == 3 then
        effectId = 40038
      elseif index == 4 then
        effectId = 40039
      end
      if 0 < effectId then
        local effectNum = rightBattleEffect:GetValue(effectId)
        rightNum = rightNum + effectNum
      end
    end
  end
  self._cp_troopCell4:SetLeftValue(string.GetFormattedPercentStr(leftNum / 100))
  self._cp_troopCell4:SetRightValue(string.GetFormattedPercentStr(rightNum / 100))
end

function MailPlayerReport:SetDefenceAddData()
  local leftNum = 0
  local rightNum = 0
  local leftFightData = self.leftFightData
  local rightFightData = self.rightFightData
  local leftBattleEffect = self.leftBattleEffect
  local rightBattleEffect = self.rightBattleEffect
  if leftBattleEffect ~= nil then
    leftNum = leftNum + leftBattleEffect:GetValue(35004)
    local aLeftPercent = 0
    if leftFightData ~= nil and leftFightData.unitData ~= nil then
      aLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
    end
    leftNum = leftNum + leftBattleEffect:GetValue(35005) * aLeftPercent
    local bLeftPercent = 0
    if leftFightData ~= nil and leftFightData.unitData ~= nil then
      bLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
    end
    leftNum = leftNum + leftBattleEffect:GetValue(35006) * bLeftPercent
    local cLeftPercent = 0
    if leftFightData ~= nil and leftFightData.unitData ~= nil then
      cLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
    end
    leftNum = leftNum + leftBattleEffect:GetValue(35007) * cLeftPercent
  end
  if rightBattleEffect ~= nil then
    rightNum = rightNum + rightBattleEffect:GetValue(35004)
    local aRightPercent = 0
    if rightFightData ~= nil and rightFightData.unitData ~= nil then
      aRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
    end
    rightNum = rightNum + rightBattleEffect:GetValue(35005) * aRightPercent
    local bRightPercent = 0
    if rightFightData ~= nil and rightFightData.unitData ~= nil then
      bRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
    end
    rightNum = rightNum + rightBattleEffect:GetValue(35006) * bRightPercent
    local cRightPercent = 0
    if rightFightData ~= nil and rightFightData.unitData ~= nil then
      cRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
    end
    rightNum = rightNum + rightBattleEffect:GetValue(35007) * cRightPercent
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if (leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret) and leftBattleEffect ~= nil then
      leftNum = leftNum + leftBattleEffect:GetValue(35052)
    end
    if (rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret) and rightBattleEffect ~= nil then
      rightNum = rightNum + rightBattleEffect:GetValue(35052)
    end
    if (rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret) and leftBattleEffect ~= nil then
      leftNum = leftNum + leftBattleEffect:GetValue(35044)
    end
    if (leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret) and rightBattleEffect ~= nil then
      rightNum = rightNum + rightBattleEffect:GetValue(35044)
    end
    if (leftFightData.battleType == BattleType.RallyFormation or leftFightData.battleType == BattleType.Formation or leftFightData.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB) and (rightFightData.battleType == BattleType.RallyFormation or rightFightData.battleType == BattleType.Formation or rightFightData.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB) then
      if leftBattleEffect ~= nil then
        leftNum = leftNum + leftBattleEffect:GetValue(35028)
      end
      if rightBattleEffect ~= nil then
        rightNum = rightNum + rightBattleEffect:GetValue(35028)
      end
    end
    if (leftFightData.battleType == BattleType.RallyFormation or leftFightData.battleType == BattleType.Formation) and (rightFightData.battleType == BattleType.Monster or rightFightData.battleType == BattleType.Boss or rightFightData.battleType == BattleType.ACT_BOSS or rightFightData.battleType == BattleType.PUZZLE_BOSS or rightFightData.battleType == BattleType.CHALLENGE_BOSS) then
      if leftBattleEffect ~= nil then
        leftNum = leftNum + leftBattleEffect:GetValue(35060)
      end
      if rightBattleEffect ~= nil then
        rightNum = rightNum + rightBattleEffect:GetValue(35060)
      end
    end
    if leftFightData.battleType == BattleType.RallyFormation and leftBattleEffect ~= nil then
      leftNum = leftNum + leftBattleEffect:GetValue(35036)
    end
    if rightFightData.battleType == BattleType.RallyFormation and rightBattleEffect ~= nil then
      rightNum = rightNum + rightBattleEffect:GetValue(35036)
    end
    if (leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret) and leftFightData.unitData ~= nil and leftFightData.unitData:GetSpecialType() == SpecialUnitType.NONE and leftBattleEffect ~= nil then
      leftNum = leftNum + leftBattleEffect:GetValue(35134)
    end
    if (rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret) and rightFightData.unitData ~= nil and rightFightData.unitData:GetSpecialType() == SpecialUnitType.NONE and rightBattleEffect ~= nil then
      rightNum = rightNum + rightBattleEffect:GetValue(35134)
    end
    if leftFightData.unitData ~= nil then
      local index = leftFightData.unitData:GetFormationIndex()
      local effectId = 0
      if rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret then
        if index == 1 then
          effectId = 40055
        elseif index == 2 then
          effectId = 40056
        elseif index == 3 then
          effectId = 40057
        elseif index == 4 then
          effectId = 40058
        end
        if 0 < effectId then
          local effectNum = leftBattleEffect:GetValue(effectId)
          leftNum = leftNum + effectNum
        end
      end
      effectId = 0
      if index == 1 then
        effectId = 40040
      elseif index == 2 then
        effectId = 40041
      elseif index == 3 then
        effectId = 40042
      elseif index == 4 then
        effectId = 40043
      end
      if 0 < effectId then
        local effectNum = leftBattleEffect:GetValue(effectId)
        leftNum = leftNum + effectNum
      end
    end
    if rightFightData.unitData ~= nil then
      local index = rightFightData.unitData:GetFormationIndex()
      local effectId = 0
      if leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret then
        if index == 1 then
          effectId = 40055
        elseif index == 2 then
          effectId = 40056
        elseif index == 3 then
          effectId = 40057
        elseif index == 4 then
          effectId = 40058
        end
        if 0 < effectId then
          local effectNum = rightBattleEffect:GetValue(effectId)
          rightNum = rightNum + effectNum
        end
      end
      effectId = 0
      if index == 1 then
        effectId = 40040
      elseif index == 2 then
        effectId = 40041
      elseif index == 3 then
        effectId = 40042
      elseif index == 4 then
        effectId = 40043
      end
      if 0 < effectId then
        local effectNum = rightBattleEffect:GetValue(effectId)
        rightNum = rightNum + effectNum
      end
    end
  end
  self._cp_troopCell5:SetLeftValue(string.GetFormattedPercentStr(leftNum / 100))
  self._cp_troopCell5:SetRightValue(string.GetFormattedPercentStr(rightNum / 100))
end

function MailPlayerReport:SetHealthAddData()
  local leftNum = 0
  local rightNum = 0
  local leftFightData = self.leftFightData
  local rightFightData = self.rightFightData
  local leftBattleEffect = self.leftBattleEffect
  local rightBattleEffect = self.rightBattleEffect
  if leftBattleEffect ~= nil then
    leftNum = leftNum + leftBattleEffect:GetValue(35012)
    local aLeftPercent = 0
    if leftFightData ~= nil and leftFightData.unitData ~= nil then
      aLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
    end
    leftNum = leftNum + leftBattleEffect:GetValue(35013) * aLeftPercent
    local bLeftPercent = 0
    if leftFightData ~= nil and leftFightData.unitData ~= nil then
      bLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
    end
    leftNum = leftNum + leftBattleEffect:GetValue(35014) * bLeftPercent
    local cLeftPercent = 0
    if leftFightData ~= nil and leftFightData.unitData ~= nil then
      cLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
    end
    leftNum = leftNum + leftBattleEffect:GetValue(35015) * cLeftPercent
  end
  if rightBattleEffect ~= nil then
    rightNum = rightNum + rightBattleEffect:GetValue(35012)
    local aRightPercent = 0
    if rightFightData ~= nil and rightFightData.unitData ~= nil then
      aRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
    end
    rightNum = rightNum + rightBattleEffect:GetValue(35013) * aRightPercent
    local bRightPercent = 0
    if rightFightData ~= nil and rightFightData.unitData ~= nil then
      bRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
    end
    rightNum = rightNum + rightBattleEffect:GetValue(35014) * bRightPercent
    local cRightPercent = 0
    if rightFightData ~= nil and rightFightData.unitData ~= nil then
      cRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
    end
    rightNum = rightNum + rightBattleEffect:GetValue(35015) * cRightPercent
  end
  if leftNum <= 0 and rightNum <= 0 then
    self._cp_troopCell6:SetActive(false)
  else
    self._cp_troopCell6:SetActive(true)
    self._cp_troopCell6:SetLeftValue(string.GetFormattedPercentStr(leftNum / 100))
    self._cp_troopCell6:SetRightValue(string.GetFormattedPercentStr(rightNum / 100))
  end
end

function MailPlayerReport:SetCampData()
  local leftFightData = self.leftFightData
  local rightFightData = self.rightFightData
  local leftBattleEffect = self.leftBattleEffect
  local rightBattleEffect = self.rightBattleEffect
  local campRestraintLeft = 0
  local campRestraintRight = 0
  self.RestraintData = nil
  if leftFightData ~= nil and rightFightData ~= nil and leftFightData.unitData ~= nil and rightFightData.unitData ~= nil then
    local leftHeroes = leftFightData.unitData:GetPlayerHeroes()
    local rightHeroes = rightFightData.unitData:GetPlayerHeroes()
    local leftHeroKey = table.keys(leftHeroes)
    local rightHeroKey = table.keys(rightHeroes)
    local leftEffectList = {}
    local rightEffectList = {}
    local RestraintData = MarchUtil.GetBaseHeroRestraintValue(leftHeroKey, rightHeroKey, leftEffectList, rightEffectList)
    if RestraintData ~= nil then
      self._CampRestraintImg:SetActive(true)
      self._CampRestraintItem_LeftBtn:SetActive(true)
      self._CampRestraintItem_RightBtn:SetActive(true)
      self._CampRestraintItem_Left:InitData(RestraintData.leftCampRestraintData.camp, RestraintData.leftCampRestraintData.num)
      self._CampRestraintItem_Right:InitData(RestraintData.rightCampRestraintData.camp, RestraintData.rightCampRestraintData.num)
      if RestraintData.isLeft then
        campRestraintLeft = RestraintData.value
        campRestraintRight = 0
        self._CampRestraintImg:LoadSprite("Assets/Main/Sprites/UI/UIHeroList/hero_faction_fight_kezhi.png")
      else
        campRestraintLeft = 0
        campRestraintRight = RestraintData.value
        self._CampRestraintImg:LoadSprite("Assets/Main/Sprites/UI/UIHeroList/hero_faction_fight_beikezhi.png")
      end
      self.RestraintData = RestraintData
    else
      self._CampRestraintItem_LeftBtn:SetActive(false)
      self._CampRestraintItem_RightBtn:SetActive(false)
      self._CampRestraintImg:SetActive(false)
    end
  else
    self._CampRestraintItem_LeftBtn:SetActive(false)
    self._CampRestraintItem_RightBtn:SetActive(false)
    self._CampRestraintImg:SetActive(false)
  end
end

function MailPlayerReport:OnLeftCampClick()
  if self.RestraintData ~= nil and self.RestraintData.leftCampRestraintData ~= nil then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local x = self._CampRestraintItem_Left.transform.position.x
    local y = self._CampRestraintItem_Left.transform.position.y - 40 * scaleFactor
    local restraintData = self.RestraintData.leftCampRestraintData
    local campIndex = -1
    local campNum = -1
    if restraintData ~= nil then
      campIndex = restraintData.camp
      campNum = restraintData.num
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailCampRestraintDetail, campIndex, campNum, x, y)
  end
end

function MailPlayerReport:OnRightCampClick()
  if self.RestraintData ~= nil and self.RestraintData.rightCampRestraintData ~= nil then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local x = self._CampRestraintItem_Right.transform.position.x
    local y = self._CampRestraintItem_Right.transform.position.y - 40 * scaleFactor
    local restraintData = self.RestraintData.rightCampRestraintData
    local campIndex = -1
    local campNum = -1
    if restraintData ~= nil then
      campIndex = restraintData.camp
      campNum = restraintData.num
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailCampRestraintDetail, campIndex, campNum, x, y)
  end
end

function MailPlayerReport:OnHeroDetailClick(isSelf)
  if isSelf == true then
    if self.leftFightData ~= nil and self.leftFightData.unitData ~= nil then
      if self.leftFightData.battleType == BattleType.Monster or self.leftFightData.battleType == BattleType.Boss or self.leftFightData.battleType == BattleType.ACT_BOSS or self.leftFightData.battleType == BattleType.Explore or self.leftFightData.battleType == BattleType.PUZZLE_BOSS or self.leftFightData.battleType == BattleType.CHALLENGE_BOSS then
        return false
      end
      if self.leftFightData.unitData:GetSpecialType() == SpecialUnitType.NONE or self.leftFightData.unitData:GetSpecialType() == SpecialUnitType.CITY_STATION or self.leftFightData.unitData:GetSpecialType() == SpecialUnitType.TEAM_LEADER or self.leftFightData.unitData:GetSpecialType() == SpecialUnitType.TEAM_MEMBER then
        local heroes = self.leftFightData.unitData:GetPlayerHeroes()
        local soldierMax = 0
        local attr = self.leftFightData.unitAttrInfo
        local heroAtk = attr:GetAtkAttrByType(AtkDefReason.HERO)
        local heroDef = attr:GetDefAttrByType(AtkDefReason.HERO)
        local heroKey = table.keys(heroes)
        local campData = MarchUtil.GetCampParamByHeroIdList(heroKey)
        local heroList = {}
        local index = 0
        for k, v in pairs(heroes) do
          index = index + 1
          local level = v.heroLevel
          local heroId = v.heroId
          local rankLv = v.rankLv or 0
          local stage = v.stage or 0
          local quality = v.heroQuality or 0
          local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
          local rarity = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "rarity")
          soldierMax = soldierMax + GetTableData(TableName.NewHeroesLevelUp, level, "army_num" .. rarity)
          local rankTroop = string.split(GetTableData(TableName.HeroMilitaryRankLv, curMilitaryRankId, "troop"), "|")[rarity]
          if rankTroop ~= nil then
            soldierMax = soldierMax + rankTroop
          end
          local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
          local starAddTroop = config.hero_star_troops[math.min(#config.hero_star_troops, curMilitaryRankId)]
          if starAddTroop ~= nil then
            soldierMax = soldierMax + toInt(starAddTroop)
          end
          local heroData = {}
          heroData.heroId = heroId
          heroData.quality = quality
          heroData.heroLv = level
          heroData.rankId = curMilitaryRankId
          heroData.skillList = {}
          local skillData = v.skillInfos
          for a, b in pairs(skillData) do
            local skill = {}
            skill.id = b.skillId
            skill.level = b.skillLv
            table.insert(heroData.skillList, skill)
          end
          local key = tostring(index)
          heroList[key] = heroData
        end
        local para = {}
        para.totalSoliderNum = math.floor(soldierMax)
        para.totalAtkNum = math.floor(heroAtk)
        para.totalDefNum = math.floor(heroDef)
        para.heroList = heroList
        para.campData = campData
        para.fromMail = 1
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationShare, {anim = true}, para)
        return true
      end
    end
  elseif self.rightFightData ~= nil and self.rightFightData.unitData ~= nil then
    if self.rightFightData.battleType == BattleType.Monster or self.rightFightData.battleType == BattleType.Boss or self.rightFightData.battleType == BattleType.ACT_BOSS or self.rightFightData.battleType == BattleType.Explore or self.rightFightData.battleType == BattleType.PUZZLE_BOSS or self.rightFightData.battleType == BattleType.CHALLENGE_BOSS then
      return false
    end
    if self.rightFightData.unitData:GetSpecialType() == SpecialUnitType.NONE or self.rightFightData.unitData:GetSpecialType() == SpecialUnitType.CITY_STATION or self.rightFightData.unitData:GetSpecialType() == SpecialUnitType.TEAM_LEADER or self.rightFightData.unitData:GetSpecialType() == SpecialUnitType.TEAM_MEMBER then
      local heroes = self.rightFightData.unitData:GetPlayerHeroes()
      local soldierMax = 0
      local attr = self.rightFightData.unitAttrInfo
      local heroAtk = attr:GetAtkAttrByType(AtkDefReason.HERO)
      local heroDef = attr:GetDefAttrByType(AtkDefReason.HERO)
      local heroKey = table.keys(heroes)
      local campData = MarchUtil.GetCampParamByHeroIdList(heroKey)
      local heroList = {}
      local index = 0
      for k, v in pairs(heroes) do
        index = index + 1
        local level = v.heroLevel
        local heroId = v.heroId
        local rankLv = v.rankLv or 0
        local stage = v.stage or 0
        local quality = v.heroQuality or 0
        local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
        local rarity = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "rarity")
        soldierMax = soldierMax + GetTableData(TableName.NewHeroesLevelUp, level, "army_num" .. rarity)
        local rankTroop = string.split(GetTableData(TableName.HeroMilitaryRankLv, curMilitaryRankId, "troop"), "|")[rarity]
        if rankTroop ~= nil then
          soldierMax = soldierMax + rankTroop
        end
        local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
        local starAddTroop = config.hero_star_troops[math.min(#config.hero_star_troops, curMilitaryRankId)]
        if starAddTroop ~= nil then
          soldierMax = soldierMax + toInt(starAddTroop)
        end
        local heroData = {}
        heroData.heroId = heroId
        heroData.quality = quality
        heroData.heroLv = level
        heroData.rankId = curMilitaryRankId
        heroData.skillList = {}
        local skillData = v.skillInfos
        for a, b in pairs(skillData) do
          local skill = {}
          skill.id = b.skillId
          skill.level = b.skillLv
          table.insert(heroData.skillList, skill)
        end
        local key = tostring(index)
        heroList[key] = heroData
      end
      local para = {}
      para.totalSoliderNum = math.floor(soldierMax)
      para.totalAtkNum = math.floor(heroAtk)
      para.totalDefNum = math.floor(heroDef)
      para.heroList = heroList
      para.campData = campData
      para.fromMail = 1
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationShare, {anim = true}, para)
      return true
    end
  end
  return false
end

function MailPlayerReport:OnClickBtnReplay()
  local currentMail = self._mailInfo
  if currentMail == nil or currentMail.type ~= MailType.NEW_FIGHT then
    return
  end
  local count = currentMail:GetMailExt():GetTotalRoundCnt()
  if count == 1 then
    local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(BattlePlayBackLevelId)
    if pveTemplate ~= nil then
      local param = {}
      local _showData = currentMail:GetMailExt():GetShowRoundListDataByIndex(1)
      if _showData == nil then
        return
      end
      local roundFight = currentMail:GetMailExt():GetFightReportByRoundIndex(1)
      if roundFight == nil then
        return
      end
      local bigRoundIndex = _showData._roundIndex
      local bigRoundUuid = _showData.roundUuid
      local selfHealth = roundFight:GetTroopHealth(true)
      local otherHealth = roundFight:GetTroopHealth(false)
      local leftUuid = _showData.leftUuid
      local rightUuid = _showData.rightUuid
      local leftFightData = _showData.leftData
      local rightFightData = _showData.rightData
      local leftBattleEffect = currentMail:GetMailExt():GetMySideBattleEffect(leftUuid)
      local rightBattleEffect = currentMail:GetMailExt():GetOtherSideBattleEffect(rightUuid)
      local leftHero = {}
      local rightHero = {}
      local leftSoliderList = {}
      local rightSoliderList = {}
      local leftPower = 0
      local rightPower = 0
      local rightMonsterId = 0
      
      local function GetHeroInfo(heroData)
        local oneData = {}
        local power = 0
        local level = heroData.heroLevel
        local heroId = heroData.heroId
        local rankLv = heroData.rankLv or 0
        local stage = heroData.stage or 0
        local quality = heroData.heroQuality or 0
        local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
        local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
        local beyondTimes = HeroUtils.GetBeyondTimesByLevel(level)
        local curAtk, curDef = HeroUtils.GetHeroAttr(heroId, quality, level, beyondTimes, curMilitaryRankId)
        power = Mathf.Round((curAtk + curDef) * k1)
        local skillData = heroData.skillInfos
        local firstSkillId = HeroUtils.GetHeroFirstSkillId(heroId)
        local skillLv = 0
        for a, b in pairs(skillData) do
          local id = b.skillId
          local skillLevel = b.skillLv
          if id == firstSkillId then
            skillLv = skillLevel
          end
          local powerStr = GetTableData(TableName.SkillTab, id, "power")
          local strArr = string.split(powerStr, "|")
          if skillLevel <= #strArr then
            power = power + tonumber(strArr[skillLevel])
          end
        end
        oneData.heroId = tostring(heroId)
        oneData.heroLv = level
        oneData.heroQuality = quality
        oneData.index = heroData.index
        oneData.power = power
        oneData.damage = HeroUtils.GetHeroSkillDamage(firstSkillId, skillLv)
        return oneData
      end
      
      local function GetEffectNum(battleEffect, effectId)
        if battleEffect ~= nil then
          return battleEffect:GetValue(effectId)
        end
        return 0
      end
      
      if leftFightData.unitData ~= nil then
        local attr = leftFightData.unitAttrInfo
        if attr == nil then
          return
        end
        local heroes = leftFightData.unitData:GetPlayerHeroes()
        if table.count(heroes) == 0 then
          return
        end
        local heroList = table.values(heroes)
        table.sort(heroList, function(heroA, heroB)
          return heroA.index < heroB.index
        end)
        local heroKey = {}
        local sumSkillDamage = 0
        for i = 1, #heroList do
          local heroData = heroList[i]
          local oneData = GetHeroInfo(heroData)
          sumSkillDamage = sumSkillDamage + oneData.damage
          table.insert(heroKey, oneData.heroId)
          table.insert(leftHero, oneData)
        end
        local heroAtk = attr:GetAtkAttrByType(AtkDefReason.HERO)
        local heroDef = attr:GetDefAttrByType(AtkDefReason.HERO)
        local campAtkAdd = 0
        local campData = MarchUtil.GetCampParamByHeroIdList(heroKey)
        if 0 < #campData then
          for i = 1, #campData do
            campAtkAdd = campAtkAdd + campData[i].addEffectNum
          end
        end
        local soldierBasicAtk = 0
        local soldierBasicDef = 0
        local soldierBasicHealth = 0
        local soldierTotalNum = 0
        local soliderList = leftFightData.unitData:GetSoldiers()
        local totalFormationAtkAdd = GetEffectNum(leftBattleEffect, EffectDefine.APS_BATTLE_TROOP_TOTAL_ATK_INCR_PERCENT)
        local totalFormationDefAdd = GetEffectNum(leftBattleEffect, EffectDefine.APS_BATTLE_TROOP_TOTAL_DEF_INCR_PERCENT)
        local baseAtkEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_ATTACK, "arm_all"))
        local baseDefEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_DEFEND, "arm_all"))
        local baseHealthEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_HEALTH_PERCENT, "arm_all"))
        for k, v in pairs(soliderList) do
          local armId = k
          local num = v[eMailSoldierAttr.Total] - v[eMailSoldierAttr.Lost]
          local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
          if template ~= nil then
            local atk = template.attack
            local def = template.defence
            local health = template.health
            local typeStr = template:GetAddValueEffectName()
            local typeAtkEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_ATTACK, typeStr))
            local typeDefEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_DEFEND, typeStr))
            local typeHealthEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_HEALTH_PERCENT, typeStr))
            soldierBasicAtk = soldierBasicAtk + atk * (1 + (totalFormationAtkAdd + baseAtkEffectNum + typeAtkEffectNum) / 100) * num
            soldierBasicDef = soldierBasicDef + def * (1 + (totalFormationDefAdd + baseDefEffectNum + typeDefEffectNum) / 100) * num
            soldierBasicHealth = soldierBasicHealth + health * (1 + (baseHealthEffectNum + typeHealthEffectNum) / 100) * num
            soldierTotalNum = soldierTotalNum + num
            leftSoliderList[armId] = num
          end
        end
        if 0 < soldierTotalNum then
          local k1 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k1")
          local k2 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k2")
          local k3 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k3")
          local k15 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k15")
          local k16 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k16")
          local k18 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k18")
          local totalPower = Mathf.Pow(soldierTotalNum * k1, k2) * (soldierBasicAtk / soldierTotalNum) * (soldierBasicDef / soldierTotalNum) * (soldierBasicHealth / soldierTotalNum) * Mathf.Pow(heroAtk, k3) * Mathf.Pow(heroDef, k3) * (1 + campAtkAdd / 100) * (1 + sumSkillDamage / 10) * soldierTotalNum / math.max(1, k15)
          leftPower = Mathf.Pow(totalPower, k18)
        end
      end
      if rightFightData.unitData ~= nil then
        local attr = rightFightData.unitAttrInfo
        if attr == nil then
          return
        end
        local heroes = rightFightData.unitData:GetPlayerHeroes()
        if table.count(heroes) == 0 then
          return
        end
        local heroList = table.values(heroes)
        table.sort(heroList, function(heroA, heroB)
          return heroA.index < heroB.index
        end)
        local heroKey = {}
        local sumSkillDamage = 0
        for i = 1, #heroList do
          local heroData = heroList[i]
          local oneData = GetHeroInfo(heroData)
          sumSkillDamage = sumSkillDamage + oneData.damage
          table.insert(heroKey, oneData.heroId)
          table.insert(rightHero, oneData)
        end
        local heroAtk = attr:GetAtkAttrByType(AtkDefReason.HERO)
        local heroDef = attr:GetDefAttrByType(AtkDefReason.HERO)
        local campAtkAdd = 0
        local campData = MarchUtil.GetCampParamByHeroIdList(heroKey)
        if 0 < #campData then
          for i = 1, #campData do
            campAtkAdd = campAtkAdd + campData[i].addEffectNum
          end
        end
        local soldierBasicAtk = 0
        local soldierBasicDef = 0
        local soldierBasicHealth = 0
        local soldierTotalNum = 0
        local soliderList = rightFightData.unitData:GetSoldiers()
        local totalFormationAtkAdd = GetEffectNum(rightBattleEffect, EffectDefine.APS_BATTLE_TROOP_TOTAL_ATK_INCR_PERCENT)
        local totalFormationDefAdd = GetEffectNum(rightBattleEffect, EffectDefine.APS_BATTLE_TROOP_TOTAL_DEF_INCR_PERCENT)
        local baseAtkEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_ATTACK, "arm_all"))
        local baseDefEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_DEFEND, "arm_all"))
        local baseHealthEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_HEALTH_PERCENT, "arm_all"))
        for k, v in pairs(soliderList) do
          local armId = k
          local num = v[eMailSoldierAttr.Total] - v[eMailSoldierAttr.Lost]
          local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
          if template ~= nil then
            local atk = template.attack
            local def = template.defence
            local health = template.health
            local typeStr = template:GetAddValueEffectName()
            local typeAtkEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_ATTACK, typeStr))
            local typeDefEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_DEFEND, typeStr))
            local typeHealthEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_HEALTH_PERCENT, typeStr))
            soldierBasicAtk = soldierBasicAtk + atk * (1 + (totalFormationAtkAdd + baseAtkEffectNum + typeAtkEffectNum) / 100) * num
            soldierBasicDef = soldierBasicDef + def * (1 + (totalFormationDefAdd + baseDefEffectNum + typeDefEffectNum) / 100) * num
            soldierBasicHealth = soldierBasicHealth + health * (1 + (baseHealthEffectNum + typeHealthEffectNum) / 100) * num
            soldierTotalNum = soldierTotalNum + num
            rightSoliderList[armId] = num
          end
        end
        if 0 < soldierTotalNum then
          local k1 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k1")
          local k2 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k2")
          local k3 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k3")
          local k15 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k15")
          local k16 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k16")
          local k18 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k18")
          local totalPower = Mathf.Pow(soldierTotalNum * k1, k2) * (soldierBasicAtk / soldierTotalNum) * (soldierBasicDef / soldierTotalNum) * (soldierBasicHealth / soldierTotalNum) * Mathf.Pow(heroAtk, k3) * Mathf.Pow(heroDef, k3) * (1 + campAtkAdd / 100) * (1 + sumSkillDamage / 10) * soldierTotalNum / math.max(1, k15)
          rightPower = Mathf.Pow(totalPower, k18)
        end
      end
      param.leftPower = leftPower
      param.rightPower = rightPower
      param.leftHero = leftHero
      param.rightHero = rightHero
      param.leftSoliderList = leftSoliderList
      param.rightSoliderList = rightSoliderList
      param.rightMonsterId = rightMonsterId
      param.selfHealth = selfHealth
      param.otherHealth = otherHealth
      param.bigRoundUuid = bigRoundUuid
      param.bigRoundIndex = bigRoundIndex
      param.pveEntrance = PveEntrance.BattlePlayBack
      param.levelId = BattlePlayBackLevelId
      param.battleResult = currentMail:GetMailExt():GetBattleWinInPve()
      param.jumpType = self.jumpType
      param.leftHeadParam = {}
      if leftFightData.unitData ~= nil then
        param.leftHeadParam.uid = leftFightData.unitData:GetUserId()
        param.leftHeadParam.pic = leftFightData.unitData.pic
        param.leftHeadParam.picVer = leftFightData.unitData.picVer
      end
      param.rightHeadParam = {}
      if rightFightData.battleType == BattleType.Monster then
        param.rightHeadParam.monsterPic = "Assets/Main/Sprites/HeroIconsSmall/UIPVEorder_img_guai.png"
      elseif rightFightData.unitData ~= nil then
        param.rightHeadParam.uid = rightFightData.unitData:GetUserId()
        param.rightHeadParam.pic = rightFightData.unitData.pic
        param.rightHeadParam.picVer = rightFightData.unitData.picVer
      end
      local needExchange = currentMail:GetMailExt():CheckIfNeedExchange()
      param.needExchange = needExchange
      DataCenter.BattleLevel:Enter(param)
    end
  end
end

return MailPlayerReport
