local MailBattleMonsterBlood = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleType.MailBattleMonsterBlood")
local MailBattleTeamHeroItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleType.MailBattleTeamHeroItem")
local MailBattleTeamItem_TroopDetailInfo = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleType.MailBattleTeamItem_TroopDetailInfo")
local MailBattleUserResult = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleType.MailBattleUserResult")
local MailBattleTeamItem = BaseClass("MailBattleTeamItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local Icon_Turret = "Assets/Main/Sprites/BuildIconOutCity/pic418000_2_free.png"
local _cp_root = ""
local _cp_imgLeftBg = "imgLeftBg"
local _cp_imgRightBg = "imgRightBg"
local _cp_txtPowerLostCnt_left = "ObjBattleTeamInfo/txtPowerLostCnt_left"
local _cp_txtAllianceLeft = "ObjBattleTeamInfo/objNameLeft/txtAllianceLeft"
local _cp_txtNameLeft = "ObjBattleTeamInfo/objNameLeft/txtNameLeft"
local _cp_txtAlliance_right = "ObjBattleTeamInfo/objNameRight/txtAllianceRight"
local _cp_txtName_right = "ObjBattleTeamInfo/objNameRight/txtName_right"
local _cp_imgUserHead_left = "ObjBattleTeamInfo/objUserHead_left/imgUserHead_left"
local _cp_imgHeadBg_left = "ObjBattleTeamInfo/objUserHead_left/HeadBtnL"
local _cp_imgHeadFg_left = "ObjBattleTeamInfo/objUserHead_left/HeadFgL"
local _cp_imgUserHead_right = "ObjBattleTeamInfo/objUserHead_right/imgUserHead_right"
local _cp_imgHeadBg_right = "ObjBattleTeamInfo/objUserHead_right/HeadBtnR"
local _cp_imgHeadFg_right = "ObjBattleTeamInfo/objUserHead_right/HeadFgR"
local _cp_txtPowerLost_left = "ObjBattleTeamInfo/txtPowerLost_left"
local _cp_txtPosLeft = "ObjBattleTeamInfo/btnPosLeft/txtPosLeft"
local _cp_btnPosLeft = "ObjBattleTeamInfo/btnPosLeft"
local _cp_btnPosRight = "ObjBattleTeamInfo/btnPosRight"
local _cp_txtPos_right = "ObjBattleTeamInfo/btnPosRight/txtPos_right"
local _cp_txtResult_right = "ObjBattleTeamInfo/txtResult_right"
local _cp_txtResult_left = "ObjBattleTeamInfo/txtResult_left"
local _cp_txtRound = "ObjBattleTeamInfo/txtRound"
local _cp_btnHeroList_left = "ObjHeroes/ObjHeroesLeftNode/btnMoreUserInfo_Left"
local _cp_btnHeroList_right = "ObjHeroes/ObjHeroesRightNode/btnMoreUserInfo_Right"
local _cp_ObjHeroesLeftNode = "ObjHeroes/ObjHeroesLeftNode"
local _cp_ObjHeroesRightNode = "ObjHeroes/ObjHeroesRightNode"
local _cp_txtNoHeroTips_Left = "ObjHeroes/ObjHeroesLeftNode/txtNoHeroTips_Left"
local _cp_txtNoHeroTips_Right = "ObjHeroes/ObjHeroesRightNode/txtNoHeroTips_Right"
local _cp_objHeroCellTemplate = "ObjHeroes/template/UIHeroCellSmall"
local _cp_ObjBloodBarNode_Monster = "ObjHeroes/ObjBloodBarNode_Monster"
local _cp_txtTotalCntTitle_left = "ObjBattleTroopDetailInfo/LeftSide/txtTotalCntTitle_left"
local _cp_txtHealTitle_left = "ObjBattleTroopDetailInfo/LeftSide/txtHealTitle_left"
local _cp_txtDeadTitle_left = "ObjBattleTroopDetailInfo/LeftSide/txtDeadTitle_left"
local _cp_txtInjureTitle_left = "ObjBattleTroopDetailInfo/LeftSide/txtInjureTitle_left"
local _cp_txtWoundedTitle_left = "ObjBattleTroopDetailInfo/LeftSide/txtWoundedTitle_left"
local _cp_txtAliveTitle_left = "ObjBattleTroopDetailInfo/LeftSide/txtAliveTitle_left"
local _cp_txtTotalCntTitle_right = "ObjBattleTroopDetailInfo/RightFormation/txtTotalCntTitle_right"
local _cp_txtHealTitle_right = "ObjBattleTroopDetailInfo/RightFormation/txtHealTitle_right"
local _cp_txtDeadTitle_right = "ObjBattleTroopDetailInfo/RightFormation/txtDeadTitle_right"
local _cp_txtInjureTitle_right = "ObjBattleTroopDetailInfo/RightFormation/txtInjureTitle_right"
local _cp_txtWoundedTitle_right = "ObjBattleTroopDetailInfo/RightFormation/txtWoundedTitle_right"
local _cp_txtAliveTitle_right = "ObjBattleTroopDetailInfo/RightFormation/txtAliveTitle_right"
local _cp_ObjBattleTroopDetailInfo = "ObjBattleTroopDetailInfo"
local _cp_ObjBattleUserResult = "ObjBattleUserResult"
local _cp_btnReport = "ObjBtnNode/btnReport"
local _cp_txtReport = "ObjBtnNode/btnReport/txtBtnReport"
local _cp_btnTroopInfo = "ObjBtnNode/btnTroopInfo"
local _cp_txtTroopInfo = "ObjBtnNode/btnTroopInfo/txtTroopInfo"
local OriginSize_Width = 770
local OriginSize_Height_TeamInfo = 143
local OriginSize_Height_Heroes = 60
local OriginSize_Height_BtnNode = 100
local OriginSize_Height = 558
local OriginBgWidth = 382
local OriginBottomBtnHeight = 100

function MailBattleTeamItem:DataDefine()
end

function MailBattleTeamItem:OnCreate()
  base.OnCreate(self)
  self._root = self:AddComponent(UIBaseContainer, _cp_root)
  self._imgLeftBg = self:AddComponent(UIImage, _cp_imgLeftBg)
  self._imgRightBg = self:AddComponent(UIImage, _cp_imgRightBg)
  self._objBloodBarNode_Monster = self:AddComponent(MailBattleMonsterBlood, _cp_ObjBloodBarNode_Monster)
  self._txtPowerLostCnt_left = self:AddComponent(UIText, _cp_txtPowerLostCnt_left)
  self._txtAllianceLeft = self:AddComponent(UIText, _cp_txtAllianceLeft)
  self._txtNameLeft = self:AddComponent(UIText, _cp_txtNameLeft)
  self._imgUserHead_left = self:AddComponent(UIPlayerHead, _cp_imgUserHead_left)
  self._imgHeadBg_left = self:AddComponent(UIImage, _cp_imgHeadBg_left)
  self._imgHeadFg_left = self:AddComponent(UIImage, _cp_imgHeadFg_left)
  self._imgUserHead_right = self:AddComponent(UIPlayerHead, _cp_imgUserHead_right)
  self._imgHeadBg_right = self:AddComponent(UIImage, _cp_imgHeadBg_right)
  self._imgHeadFg_right = self:AddComponent(UIImage, _cp_imgHeadFg_right)
  self._imgUserHead_left_normal = self:AddComponent(CircleImage, _cp_imgUserHead_left)
  self._imgUserHead_right_normal = self:AddComponent(CircleImage, _cp_imgUserHead_right)
  self._txtPowerLost_left = self:AddComponent(UIText, _cp_txtPowerLost_left)
  self._txtPosLeft = self:AddComponent(UITextMeshProUGUI, _cp_txtPosLeft)
  self._btnPosLeft = self:AddComponent(UIButton, _cp_btnPosLeft)
  self._btnPosLeft:SetOnClick(BindCallback(self, self.OnClickPosLeft))
  self._btnPosRight = self:AddComponent(UIButton, _cp_btnPosRight)
  self._btnPosRight:SetOnClick(BindCallback(self, self.OnClickPosRight))
  self._txtName_right = self:AddComponent(UIText, _cp_txtName_right)
  self._txtAllianceRight = self:AddComponent(UIText, _cp_txtAlliance_right)
  self._txtPos_right = self:AddComponent(UITextMeshProUGUI, _cp_txtPos_right)
  self._txtResult_right = self:AddComponent(UIText, _cp_txtResult_right)
  self._txtResult_left = self:AddComponent(UIText, _cp_txtResult_left)
  self._txtRound = self:AddComponent(UIText, _cp_txtRound)
  self._ObjBattleTroopDetailInfo = self:AddComponent(MailBattleTeamItem_TroopDetailInfo, _cp_ObjBattleTroopDetailInfo)
  self._ObjBattleUserResult = self:AddComponent(MailBattleUserResult, _cp_ObjBattleUserResult)
  self._btnReport = self:AddComponent(UIButton, _cp_btnReport)
  self._btnReport:SetOnClick(BindCallback(self, self.OnClickBtnReport))
  self._txtReport = self:AddComponent(UIText, _cp_txtReport)
  self._btnTroopInfo = self:AddComponent(UIButton, _cp_btnTroopInfo)
  self._btnTroopInfo:SetOnClick(BindCallback(self, self.OnClickBtnTroopInfo))
  self._txtTroopInfo = self:AddComponent(UIText, _cp_txtTroopInfo)
  self._btnHeroList_left = self:AddComponent(UIButton, _cp_btnHeroList_left)
  self._btnHeroList_left:SetOnClick(BindCallback(self, self.OnClickLeftHeroList))
  self._btnHeroList_right = self:AddComponent(UIButton, _cp_btnHeroList_right)
  self._btnHeroList_right:SetOnClick(BindCallback(self, self.OnClickRightHeroList))
  self._txtTotalCntTitle_left = self:AddComponent(UIText, _cp_txtTotalCntTitle_left)
  self._txtHealTitle_left = self:AddComponent(UIText, _cp_txtHealTitle_left)
  self._txtDeadTitle_left = self:AddComponent(UIText, _cp_txtDeadTitle_left)
  self._txtInjureTitle_left = self:AddComponent(UIText, _cp_txtInjureTitle_left)
  self._txtWoundedTitle_left = self:AddComponent(UIText, _cp_txtWoundedTitle_left)
  self._txtAliveTitle_left = self:AddComponent(UIText, _cp_txtAliveTitle_left)
  self._txtTotalCntTitle_right = self:AddComponent(UIText, _cp_txtTotalCntTitle_right)
  self._txtHealTitle_right = self:AddComponent(UIText, _cp_txtHealTitle_right)
  self._txtDeadTitle_right = self:AddComponent(UIText, _cp_txtDeadTitle_right)
  self._txtInjureTitle_right = self:AddComponent(UIText, _cp_txtInjureTitle_right)
  self._txtWoundedTitle_right = self:AddComponent(UIText, _cp_txtWoundedTitle_right)
  self._txtAliveTitle_right = self:AddComponent(UIText, _cp_txtAliveTitle_right)
  self._ObjHeroesLeftNode = self:AddComponent(UIBaseContainer, _cp_ObjHeroesLeftNode)
  self._ObjHeroesRightNode = self:AddComponent(UIBaseContainer, _cp_ObjHeroesRightNode)
  self._txtNoHeroTips_Left = self:AddComponent(UIText, _cp_txtNoHeroTips_Left)
  self._txtNoHeroTips_Right = self:AddComponent(UIText, _cp_txtNoHeroTips_Right)
  self._prefab_hero = self.transform:Find(_cp_objHeroCellTemplate).gameObject
  self._prefab_hero:GameObjectCreatePool()
end

function MailBattleTeamItem:OnClickPosLeft()
  if self._fightReport == nil then
    return
  end
  local mySideInfo = self._fightReport:GetSelfInfo() or {}
  local mySidePointId = mySideInfo.pointId or 0
  self.view.ctrl:OnClickPosBtn(mySidePointId)
end

function MailBattleTeamItem:OnClickPosRight()
  local otherSidePointId = self._fightReport:GetTargetPos() or 0
  self.view.ctrl:OnClickPosBtn(otherSidePointId)
end

function MailBattleTeamItem:OnClickLeftHeroList()
  local param = {}
  param.mailId = self._mailId
  param.roundIdx = self._roundIndex
  param.mailInfo = self._mailInfo
  param.side = "self"
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailAllUserHeroesView, {anim = true}, param)
end

function MailBattleTeamItem:OnClickRightHeroList()
  local param = {}
  param.mailId = self._mailId
  param.roundIdx = self._roundIndex
  param.mailInfo = self._mailInfo
  param.side = "other"
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailAllUserHeroesView, {anim = true}, param)
end

function MailBattleTeamItem:OnEnable()
  base.OnEnable(self)
  self:InitDialog()
end

function MailBattleTeamItem:InitDialog()
  self._txtReport:SetLocalText(311047)
  self._txtTroopInfo:SetLocalText(311048)
  self._txtPowerLost_left:SetText("")
  self._txtPowerLostCnt_left:SetText("")
  self._txtResult_right:SetText("")
  self._txtResult_left:SetText("")
  self._txtRound:SetText("")
  self._txtTotalCntTitle_left:SetLocalText(130068)
  self._txtHealTitle_left:SetLocalText(310130)
  self._txtDeadTitle_left:SetLocalText(310131)
  self._txtInjureTitle_left:SetLocalText(310132)
  self._txtWoundedTitle_left:SetLocalText(310133)
  self._txtAliveTitle_left:SetLocalText(310134)
  self._txtTotalCntTitle_right:SetLocalText(130068)
  self._txtHealTitle_right:SetLocalText(310130)
  self._txtDeadTitle_right:SetLocalText(310131)
  self._txtInjureTitle_right:SetLocalText(310132)
  self._txtWoundedTitle_right:SetLocalText(310133)
  self._txtAliveTitle_right:SetLocalText(310134)
end

function MailBattleTeamItem:OnClickBtnReport()
end

function MailBattleTeamItem:OnClickBtnTroopInfo()
  if string.IsNullOrEmpty(self._mailId) then
    return
  end
  local param = {}
  param.mailId = self._mailId
  param.roundIndex = self._roundIndex
  param.mailInfo = self._mailInfo
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailTroopBuffAddPanel, {anim = false}, param)
end

function MailBattleTeamItem:SetRealSize(realHeight)
  self.rectTransform:Set_sizeDelta(OriginSize_Width, realHeight)
  self._imgLeftBg.rectTransform:Set_sizeDelta(OriginBgWidth, realHeight - OriginBottomBtnHeight)
  self._imgRightBg.rectTransform:Set_sizeDelta(OriginBgWidth, realHeight - OriginBottomBtnHeight)
end

function MailBattleTeamItem:OnDisable()
  self._ObjHeroesLeftNode:RemoveComponents(MailBattleTeamHeroItem)
  self._ObjHeroesLeftNode:RemoveComponents(MailBattleTeamHeroItem)
  self._prefab_hero.gameObject:GameObjectRecycleAll()
  base.OnDisable(self)
end

function MailBattleTeamItem:OnDestroy()
  BattleReportUtil.Cancel()
  base.OnDestroy(self)
end

function MailBattleTeamItem:SetData(maildata, roundIndex)
  self._mailId = maildata.uid
  self._roundIndex = roundIndex
  local _FightReport = maildata:GetMailExt():GetFightReportByRoundIndex(roundIndex)
  if _FightReport == nil then
    return
  end
  self._mailInfo = maildata
  self._fightReport = _FightReport
  self:DataDefine()
  self:ShowLeaderInfo(_FightReport)
  self:ShowHeroes(_FightReport)
  self:CheckShowMonsterBlood(_FightReport)
  self._ObjBattleTroopDetailInfo:SetData(_FightReport)
  local detailInfoHeight = self._ObjBattleTroopDetailInfo:GetCurHeight()
  self._ObjBattleUserResult:SetData(_FightReport, maildata)
  local resultComHeight = self._ObjBattleUserResult:GetComponentHeight()
  if resultComHeight == 0 then
    self._ObjBattleUserResult:SetActive(false)
  else
    self._ObjBattleUserResult:SetActive(true)
  end
  local realHeight = OriginSize_Height_TeamInfo + OriginSize_Height_Heroes + detailInfoHeight + resultComHeight + OriginSize_Height_BtnNode
  self:SetRealSize(realHeight)
end

function MailBattleTeamItem:CheckShowMonsterBlood(fightReport)
  local targetBattleType = fightReport:GetTargetBattleType()
  local battleResult = fightReport:GetBattleResult()
  if (targetBattleType == BattleType.Monster or targetBattleType == BattleType.Boss) and battleResult == FightResult.OTHER_WIN then
    self._objBloodBarNode_Monster:SetActive(true)
    self._objBloodBarNode_Monster:SetData(fightReport)
  else
    self._objBloodBarNode_Monster:SetActive(false)
  end
end

function MailBattleTeamItem:ShowHeroes(battleRoundItem)
  local sAllMembers = battleRoundItem:GetAllMembers(true)
  local tAllMembers = battleRoundItem:GetAllMembers(false)
  
  local function getRealCnt(allMember)
    local cnt = 0
    for i = 1, table.count(allMember) do
      if not allMember[i]:IsEmpty() then
        cnt = cnt + 1
      end
    end
    return cnt
  end
  
  local sCnt = getRealCnt(sAllMembers)
  local tCnt = getRealCnt(tAllMembers)
  local sVisible = 1 < sCnt
  local tVisible = 1 < tCnt
  self._btnHeroList_left:SetActive(sVisible)
  self._btnHeroList_right:SetActive(tVisible)
  self:ShowHeroes_Self(battleRoundItem)
  local targetBattleType = battleRoundItem:GetTargetBattleType()
  if targetBattleType == BattleType.Monster or targetBattleType == BattleType.Boss then
    self:ShowHeroes_Monster()
  elseif targetBattleType == BattleType.Turret or targetBattleType == BattleType.ALLIANCE_OCCUPIED_CITY then
    self._ObjHeroesRightNode:RemoveComponents(MailBattleTeamHeroItem)
    self._ObjHeroesRightNode:SetActive(false)
  else
    self:ShowHeroes_TargetUser(battleRoundItem)
  end
end

function MailBattleTeamItem:AddHeroNode(heroInfo, parentNode)
  local item = self._prefab_hero:GameObjectSpawn(parentNode.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = parentNode:AddComponent(MailBattleTeamHeroItem, item.name)
  obj:SetData(heroInfo)
end

function MailBattleTeamItem:ShowHeroes_Self(battleRoundItem)
  self._ObjHeroesLeftNode:RemoveComponents(MailBattleTeamHeroItem)
  local selfBattleType = battleRoundItem:GetSelfBattleType()
  if selfBattleType == BattleType.Turret or selfBattleType == BattleType.ALLIANCE_OCCUPIED_CITY then
    self._ObjHeroesLeftNode:RemoveComponents(MailBattleTeamHeroItem)
    self._ObjHeroesLeftNode:SetActive(false)
  else
    self._ObjHeroesLeftNode:SetActive(true)
  end
  local heroes = {}
  local unitType = battleRoundItem:GetSelfArmyResult():GetUnitType()
  if unitType == BattleType.ALLIANCE_OCCUPIED_CITY then
    local allMember = battleRoundItem:GetAllMembers(true)
    local selfUserName = battleRoundItem._selfInfo.name
    for i = 1, table.count(allMember) do
      local oneItem = allMember[i]
      if oneItem.name == selfUserName then
        local userid = oneItem._simpleCombatUnit:GetUid()
        heroes = battleRoundItem:GetLeaderHeroes(true, false, userid)
      end
    end
  else
    heroes = battleRoundItem:GetLeaderHeroes(true, false)
  end
  if table.count(heroes) == 0 then
    local des = Localization:GetString("311079")
    if unitType == BattleType.Building then
      local allMember = battleRoundItem:GetAllMembers(true)
      if table.count(allMember) > 0 then
        local name = battleRoundItem:GetBuildingName(true)
        des = Localization:GetString("140330", name)
      end
    end
    self._txtNoHeroTips_Left:SetActive(true)
    self._txtNoHeroTips_Left:SetText(des)
    return
  end
  self._txtNoHeroTips_Left:SetActive(false)
  for _, heroInfo in pairs(heroes) do
    self:AddHeroNode(heroInfo, self._ObjHeroesLeftNode)
  end
end

function MailBattleTeamItem:ShowHeroes_Monster(battleRoundItem)
  self._ObjHeroesRightNode:SetActive(false)
end

function MailBattleTeamItem:ShowHeroes_TargetUser(battleRoundItem)
  self._ObjHeroesRightNode:RemoveComponents(MailBattleTeamHeroItem)
  self._ObjHeroesRightNode:SetActive(true)
  local heroes = {}
  local unitType = battleRoundItem:GetOtherArmyResult():GetUnitType()
  if unitType == BattleType.ALLIANCE_OCCUPIED_CITY then
    local allMember = battleRoundItem:GetAllMembers(false)
    local selfUserName = battleRoundItem._otherInfo.name
    for i = 1, table.count(allMember) do
      local oneItem = allMember[i]
      if oneItem.name == selfUserName then
        local userid = oneItem._simpleCombatUnit:GetUid()
        heroes = battleRoundItem:GetLeaderHeroes(false, false, userid)
      end
    end
  else
    heroes = battleRoundItem:GetLeaderHeroes(false, false)
  end
  if table.count(heroes) == 0 then
    local des = Localization:GetString("311079")
    if unitType == BattleType.Building then
      local allMember = battleRoundItem:GetAllMembers(false)
      if table.count(allMember) > 0 then
        local name = battleRoundItem:GetBuildingName(false)
        des = Localization:GetString("140330", name)
      end
    end
    self._txtNoHeroTips_Right:SetActive(true)
    self._txtNoHeroTips_Right:SetText(des)
    return
  end
  self._txtNoHeroTips_Right:SetActive(false)
  for _, heroInfo in pairs(heroes) do
    self:AddHeroNode(heroInfo, self._ObjHeroesRightNode)
  end
end

function MailBattleTeamItem:ShowLeaderInfo(battleRoundItem)
  local selfBattleType = battleRoundItem:GetSelfBattleType()
  local targetBattleType = battleRoundItem:GetTargetBattleType()
  local mySideInfo = battleRoundItem:GetSelfInfo()
  local mySidePointId = mySideInfo.pointId or 0
  local selfAbbr = battleRoundItem:GetOnlySelfAbbr()
  local selfname = battleRoundItem:GetOnlySelfName()
  if selfBattleType == BattleType.Turret then
    selfAbbr = ""
    self._imgUserHead_left_normal:LoadSprite(Icon_Turret)
  elseif selfBattleType == BattleType.ALLIANCE_NEUTRAL_CITY or selfBattleType == BattleType.ALLIANCE_OCCUPIED_CITY then
    selfAbbr = ""
    self._imgUserHead_left_normal:LoadSprite("Assets/Main/Sprites/BuildIconOutCity/alliance_city.png")
  else
    self._imgUserHead_left:SetData(mySideInfo.uid, mySideInfo.pic, mySideInfo.picVer)
    local headBgImg = mySideInfo.headFrame == 1 and "Common_playerbg_golloes" or nil
    if headBgImg then
      self._imgHeadFg_left:SetActive(true)
      self._imgHeadFg_left:LoadSprite(string.format(LoadPath.CommonNewPath, headBgImg))
    else
      self._imgHeadFg_left:SetActive(false)
    end
  end
  if not string.IsNullOrEmpty(selfAbbr) then
    selfAbbr = "[" .. selfAbbr .. "]"
  end
  if battleRoundItem:GetSelfBattleType() == BattleType.ALLIANCE_OCCUPIED_CITY then
    selfAbbr = ""
  end
  self._txtNameLeft:SetText(selfname)
  self._txtAllianceLeft:SetText(selfAbbr)
  local mySidePos = SceneUtils.IndexToTilePos(mySidePointId)
  local strPoint1 = Localization:GetString("310137", mySidePos.x, mySidePos.y)
  if CS.SceneManager:IsInCity() or selfBattleType == BattleType.ELITE_FIGHT_MAIL then
    strPoint1 = ""
  end
  self._txtPosLeft:SetText(strPoint1)
  if targetBattleType == BattleType.Monster or targetBattleType == BattleType.Boss then
    self:ShowMonsterInfo(battleRoundItem)
  elseif targetBattleType == BattleType.City or targetBattleType == BattleType.Building or targetBattleType == BattleType.Formation or targetBattleType == BattleType.Road or targetBattleType == BattleType.Turret or targetBattleType == BattleType.ALLIANCE_NEUTRAL_CITY or targetBattleType == BattleType.ALLIANCE_OCCUPIED_CITY or targetBattleType == BattleType.ELITE_FIGHT_MAIL or targetBattleType == BattleType.RallyFormation then
    self:ShowCityInfo(battleRoundItem)
  end
  if targetBattleType == BattleType.ELITE_FIGHT_MAIL then
    self:ShowBattleResultInfo(battleRoundItem)
    self:ShowBattleRoundInfo()
  end
end

function MailBattleTeamItem:ShowBattleResultInfo(battleRoundItem)
  if battleRoundItem:GetBattleResult() == FightResult.OTHER_WIN then
    self._txtResult_right:SetLocalText(390186)
    self._txtResult_left:SetLocalText(390187)
  else
    self._txtResult_right:SetLocalText(390187)
    self._txtResult_left:SetLocalText(390186)
  end
end

function MailBattleTeamItem:ShowBattleRoundInfo()
  self._txtRound:SetLocalText(302069, self._roundIndex)
end

function MailBattleTeamItem:ShowCityInfo(battleRoundItem)
  local otherSidePointId = battleRoundItem:GetTargetPos()
  local targetBattleType = battleRoundItem:GetTargetBattleType()
  local otherSidePos = SceneUtils.IndexToTilePos(otherSidePointId)
  local strPoint2 = Localization:GetString("310137", otherSidePos.x, otherSidePos.y)
  if CS.SceneManager:IsInCity() or targetBattleType == BattleType.ELITE_FIGHT_MAIL then
    strPoint2 = ""
  end
  self._txtPos_right:SetText(strPoint2)
  if targetBattleType == BattleType.Turret then
    local otherSideName = battleRoundItem:GetOnlyTargetName()
    self._txtAllianceRight:SetText("")
    self._txtName_right:SetText(otherSideName)
    self._imgUserHead_right_normal:LoadSprite(Icon_Turret)
    return
  elseif targetBattleType == BattleType.ALLIANCE_NEUTRAL_CITY or targetBattleType == BattleType.ALLIANCE_OCCUPIED_CITY then
    local otherSideName = battleRoundItem:GetOnlyTargetName()
    self._txtAllianceRight:SetText("")
    self._txtName_right:SetText(otherSideName)
    self._imgUserHead_right_normal:LoadSprite("Assets/Main/Sprites/BuildIconOutCity/alliance_city.png")
    return
  end
  local abbr = battleRoundItem:GetOnlyTargetAbbr()
  local username = battleRoundItem:GetOnlyTargetName()
  if not string.IsNullOrEmpty(abbr) then
    abbr = "[" .. abbr .. "]"
  end
  self._txtAllianceRight:SetText(abbr)
  self._txtName_right:SetText(username)
  local otherSideInfo = battleRoundItem:GetTargetInfo()
  if otherSideInfo ~= nil then
    self._imgUserHead_right:SetData(otherSideInfo.uid, otherSideInfo.pic, otherSideInfo.picVer)
    local headBgImg = otherSideInfo.headFrame == 1 and "Common_playerbg_golloes" or nil
    if headBgImg then
      self._imgHeadFg_right:SetActive(true)
      self._imgHeadFg_right:LoadSprite(string.format(LoadPath.CommonNewPath, headBgImg))
    else
      self._imgHeadFg_right:SetActive(false)
    end
  end
end

function MailBattleTeamItem:ShowMonsterInfo(battleRoundItem)
  self._btnHeroList_right:SetActive(false)
  local otherSidePointId = battleRoundItem:GetTargetPos()
  local otherSidePos = SceneUtils.IndexToTilePos(otherSidePointId)
  local strPoint2 = Localization:GetString("310137", otherSidePos.x, otherSidePos.y)
  self._txtPos_right:SetText(strPoint2)
  self._txtAllianceRight:SetText("")
  local otherSideName = battleRoundItem:GetTargetName()
  self._txtName_right:SetText(otherSideName)
  local monsterPic = "Assets/Main/Sprites/UI/UISearch/UISearch_icon_monster.png"
  self._imgUserHead_right_normal:LoadSprite(monsterPic)
end

return MailBattleTeamItem
