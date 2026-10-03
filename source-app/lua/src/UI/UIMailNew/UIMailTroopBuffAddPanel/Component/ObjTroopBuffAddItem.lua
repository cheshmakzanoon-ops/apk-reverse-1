local ObjTroopBuffHeroInfoItem = require("UI.UIMailNew.UIMailTroopBuffAddPanel.Component.ObjTroopBuffHeroInfoItem")
local ObjTroopBuffEffectItem = require("UI.UIMailNew.UIMailTroopBuffAddPanel.Component.ObjTroopBuffEffectItem")
local ObjTroopBuffAddItem = BaseClass("ObjTroopBuffAddItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Const_HeroCellHeight = 59
local Const_BuffCellHeight = 35
local Const_TopUserInfoHeight = 100
local Const_OriginCellWidth = 962
local Const_OriginBgWidth = 465
local _cp_imgLeftBg = "imgLeftBg"
local _cp_imgRightBg = "imgRightBg"
local _cp_objLeft = "ObjBattleTeamInfo/objLeft"
local _cp_objRight = "ObjBattleTeamInfo/objRight"
local _cp_txtNameLeft = "ObjBattleTeamInfo/objLeft/txtNameLeft"
local _cp_txtName_right = "ObjBattleTeamInfo/objRight/txtName_right"
local _cp_imgUserHead_left = "ObjBattleTeamInfo/objLeft/GameObject/objUserHead_left/imgUserHead_left"
local _cp_imgUserHead_right = "ObjBattleTeamInfo/objRight/GameObject/objUserHead_right/imgUserHead_right"
local _cp_objHeroes = "ObjHeroes"
local _cp_objHeroes_left = "ObjHeroes/ObjHeroesLeftNode"
local _cp_objHeroes_right = "ObjHeroes/ObjHeroesRightNode"
local _cp_objEffectList = "ObjEffectList"
local _cp_effect_left_list = "ObjEffectList/effect_left_list"
local _cp_effect_right_list = "ObjEffectList/effect_right_list"
local _template_ObjHeroItem_left = "template/ObjBattleHeroItem_Left"
local _template_ObjHeroItem_right = "template/ObjBattleHeroItem_Right"
local _template_objBuffItem = "template/objBuffItem"
local _cp_txtNoInfo_left = "txtNoInfo_left"
local _cp_txtNoInfo_right = "txtNoInfo_right"
local _cp_img_line_left = "objLine/img_line_left"
local _cp_img_line_right = "objLine/img_line_right"

function ObjTroopBuffAddItem:OnCreate()
  base.OnCreate(self)
  self._imgLeftBg = self:AddComponent(UIImage, _cp_imgLeftBg)
  self._imgRightBg = self:AddComponent(UIImage, _cp_imgRightBg)
  self._txtNameLeft = self:AddComponent(UIText, _cp_txtNameLeft)
  self._img_line_left = self:AddComponent(UIBaseContainer, _cp_img_line_left)
  self._img_line_right = self:AddComponent(UIBaseContainer, _cp_img_line_right)
  self._objUserInfo_left = self:AddComponent(UIBaseContainer, _cp_objLeft)
  self._objUserInfo_right = self:AddComponent(UIBaseContainer, _cp_objRight)
  self._txtName_right = self:AddComponent(UIText, _cp_txtName_right)
  self._imgUserHead_left = self:AddComponent(UIPlayerHead, _cp_imgUserHead_left)
  self._imgUserHead_right_head = self:AddComponent(UIPlayerHead, _cp_imgUserHead_right)
  self._imgUserHead_right_image = self:AddComponent(CircleImage, _cp_imgUserHead_right)
  self._objHeroes = self:AddComponent(UILayoutElement, _cp_objHeroes)
  self._objHeroes_left = self:AddComponent(UIBaseContainer, _cp_objHeroes_left)
  self._objHeroes_right = self:AddComponent(UIBaseContainer, _cp_objHeroes_right)
  self._objEffectList = self:AddComponent(UILayoutElement, _cp_objEffectList)
  self._effect_left_list = self:AddComponent(UIBaseContainer, _cp_effect_left_list)
  self._effect_right_list = self:AddComponent(UIBaseContainer, _cp_effect_right_list)
  self._txtNoInfo_left = self:AddComponent(UIText, _cp_txtNoInfo_left)
  self._txtNoInfo_right = self:AddComponent(UIText, _cp_txtNoInfo_right)
  self._prefab_objHeroItem_left = self.transform:Find(_template_ObjHeroItem_left).gameObject
  self._prefab_objHeroItem_right = self.transform:Find(_template_ObjHeroItem_right).gameObject
  self._prefab_ObjBuffItem = self.transform:Find(_template_objBuffItem).gameObject
end

function ObjTroopBuffAddItem:SetData(param)
  local mailId = param.mailId
  local roundIndex = param.roundIndex
  local cellIndex = param.cellIndex
  if cellIndex < 1 then
    return
  end
  local mailInfo = self.view._mailInfo
  if mailInfo == nil then
    return
  end
  self._mailInfo = mailInfo
  local roundInfo = mailInfo:GetMailExt():GetFightReportByRoundIndex(roundIndex)
  if roundInfo == nil then
    return
  end
  self._roundInfo = roundInfo
  local member_myside = roundInfo:GetAllMembers(true)
  local member_other = roundInfo:GetAllMembers(false)
  self._member_myside_item = member_myside[cellIndex]
  self._member_other_item = member_other[cellIndex]
  self._targetBattleType = roundInfo:GetTargetBattleType()
  self._selfBattleType = roundInfo:GetSelfBattleType()
  if self._targetBattleType == BattleType.Monster or self._targetBattleType == BattleType.Boss then
    self._targetName = roundInfo:GetTargetName()
  else
    self._targetName = ""
    if self._member_other_item ~= nil then
      self._targetName = self._member_other_item:GetUserName()
    end
  end
  self:ShowUserInfo()
  self:ShowUserHeroes()
  local heroHeight = Const_HeroCellHeight * self._heroCellCnt
  self._objHeroes:SetPreferredHeight(heroHeight)
  self:ShowBuffItem()
  local buffItemHeight = Const_BuffCellHeight * self._buffItemCnt + 20
  self._objEffectList:SetPreferredHeight(buffItemHeight)
  local totalHeight = Const_TopUserInfoHeight + heroHeight + buffItemHeight + 30
  self._imgLeftBg.rectTransform:Set_sizeDelta(Const_OriginBgWidth, totalHeight)
  self._imgRightBg.rectTransform:Set_sizeDelta(Const_OriginBgWidth, totalHeight)
  self.rectTransform:Set_sizeDelta(Const_OriginCellWidth, totalHeight)
end

function ObjTroopBuffAddItem:OnDestroy()
  self:RecycleHero()
  self:RecycleBuffItem()
end

function ObjTroopBuffAddItem:ShowUserInfo()
  if self._member_myside_item ~= nil and self._selfBattleType ~= BattleType.Turret then
    self._objUserInfo_left:SetActive(true)
    local username = self._member_myside_item:GetUserName()
    self._txtNameLeft:SetText(username)
    local picinfo = self._member_myside_item:GetPicInfo()
    self._imgUserHead_left:SetData(picinfo.uid, picinfo.pic, picinfo.picVer)
  else
    self._objUserInfo_left:SetActive(false)
  end
  if self._member_other_item ~= nil and self._targetBattleType ~= BattleType.Turret then
    self._objUserInfo_right:SetActive(true)
    self._txtName_right:SetText(self._targetName)
    if self._targetBattleType == BattleType.Monster or self._targetBattleType == BattleType.Boss then
      local monsterPic = "Assets/Main/Sprites/UI/UISearch/UISearch_icon_monster.png"
      self._imgUserHead_right_image:LoadSprite(monsterPic)
    else
      local picinfo = self._member_other_item:GetPicInfo()
      self._imgUserHead_right_head:SetData(picinfo.uid, picinfo.pic, picinfo.picVer)
    end
  else
    self._objUserInfo_right:SetActive(false)
  end
end

function ObjTroopBuffAddItem:ShowUserHeroes()
  self:RecycleHero()
  local leftCnt = 0
  local rightCnt = 0
  if self._member_myside_item ~= nil and self._selfBattleType ~= BattleType.Turret then
    local heroes = self._member_myside_item:GetPlayerHeroes()
    for _, heroInfo in pairs(heroes) do
      leftCnt = leftCnt + 1
      self:AddHeroNode(heroInfo, true)
    end
  end
  if self._targetBattleType ~= BattleType.Monster and self._targetBattleType ~= BattleType.Boss and self._targetBattleType ~= BattleType.Turret and self._member_other_item ~= nil then
    local heroes = self._member_other_item:GetPlayerHeroes()
    for _, heroInfo in pairs(heroes) do
      rightCnt = rightCnt + 1
      self:AddHeroNode(heroInfo, false)
    end
  end
  self._heroCellCnt = math.max(leftCnt, rightCnt)
end

function ObjTroopBuffAddItem:AddHeroNode(heroInfoProto, isMySide)
  local parent = isMySide and self._objHeroes_left or self._objHeroes_right
  local prefab = isMySide and self._prefab_objHeroItem_left or self._prefab_objHeroItem_right
  local item = prefab:GameObjectSpawn(parent.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = parent:AddComponent(ObjTroopBuffHeroInfoItem, item.name)
  obj:SetData(heroInfoProto)
end

function ObjTroopBuffAddItem:RecycleHero()
  self._prefab_objHeroItem_left.gameObject:GameObjectRecycleAll()
  self._prefab_objHeroItem_right.gameObject:GameObjectRecycleAll()
  self._objHeroes_left:RemoveComponents(ObjTroopBuffHeroInfoItem)
  self._objHeroes_right:RemoveComponents(ObjTroopBuffHeroInfoItem)
end

function ObjTroopBuffAddItem:ShowBuffItem()
  self:RecycleBuffItem()
  local leftCnt = 0
  local rightCnt = 0
  local battleEffect_MySide = {}
  local battleEffect_OtherSide = {}
  if self._member_myside_item ~= nil and self._selfBattleType ~= BattleType.Turret then
    local marchId = self._member_myside_item:GetMarchId()
    if self._selfBattleType == BattleType.ELITE_FIGHT_MAIL then
      battleEffect_MySide = self._roundInfo:GetSelfBattleEffectByMarchId(marchId)
    else
      battleEffect_MySide = self._mailInfo:GetMailExt():GetMySideBattleEffect(marchId) or {}
    end
  end
  if self._member_other_item ~= nil and self._targetBattleType ~= BattleType.Turret then
    local marchId = self._member_other_item:GetMarchId()
    battleEffect_OtherSide = self._roundInfo:GetOtherBattleEffectByMarchId(marchId)
  end
  for _, effectItem in pairs(battleEffect_MySide) do
    leftCnt = leftCnt + 1
    local obj = self:AddBuffItem(effectItem, true)
    obj:SetExtraData(battleEffect_OtherSide)
  end
  if leftCnt == 0 then
    self._txtNoInfo_left:SetText("")
    self._img_line_left:SetActive(false)
  else
    self._txtNoInfo_left:SetText("")
    self._img_line_left:SetActive(true)
  end
  for _, effectItem in pairs(battleEffect_OtherSide) do
    rightCnt = rightCnt + 1
    local obj = self:AddBuffItem(effectItem, false)
    obj:SetExtraData(battleEffect_MySide)
  end
  if rightCnt == 0 then
    self._txtNoInfo_right:SetText("")
    self._img_line_right:SetActive(false)
  else
    self._txtNoInfo_right:SetText("")
    self._img_line_right:SetActive(true)
  end
  self._buffItemCnt = math.max(leftCnt, rightCnt)
end

function ObjTroopBuffAddItem:AddBuffItem(battleEffectInfo, isMySide)
  local parent = isMySide and self._effect_left_list or self._effect_right_list
  local item = self._prefab_ObjBuffItem:GameObjectSpawn(parent.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = parent:AddComponent(ObjTroopBuffEffectItem, item.name)
  obj:SetData(battleEffectInfo)
  return obj
end

function ObjTroopBuffAddItem:RecycleBuffItem()
  self._prefab_ObjBuffItem.gameObject:GameObjectRecycleAll()
  self._effect_left_list:RemoveComponents(ObjTroopBuffEffectItem)
  self._effect_right_list:RemoveComponents(ObjTroopBuffEffectItem)
end

return ObjTroopBuffAddItem
