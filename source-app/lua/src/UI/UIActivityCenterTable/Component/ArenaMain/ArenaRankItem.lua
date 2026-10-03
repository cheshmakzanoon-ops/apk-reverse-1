local ArenaRankItem = BaseClass("ArenaRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailPlayerHeroItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleTypeNew.MailPlayerHeroItem")
local CampRestraintItem = require("UI.UIFormation.UIFormationTableNew.Component.CampRestraintItem")
local rankNum_path = "rankInfo/rank"
local rankImg_path = "rankInfo/rankImg"
local playerHead_path = "rankInfo/playerFlag/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "rankInfo/playerFlag/UIPlayerHead/Foreground"
local playerHeadBtn_path = "rankInfo/playerFlag/UIPlayerHead"
local name_path = "rankInfo/playerName"
local power_path = "rankInfo/power"
local score_path = "rankInfo/btns/rankNum"
local showArmyBtn_path = "rankInfo/btns/showTeamBtn"
local showArmyBtnImg_path = "rankInfo/btns/showTeamBtn/Image (2)"
local amryContent_path = "heroList"
local heroEffect_path = "heroList/effect"
local heroEffect_des_path = "heroList/effect/effectDes"
local camp_restraint_btn_path = "heroList/effect/campRestraintBtn"
local camp_restraint_item_path = "heroList/effect/campRestraintBtn/CampRestraintItem"
local camp_restraint_txt_path = "heroList/effect/campRestraintBtn/campRestraintText"
local camp_btn_path = "heroList/effect/campBtn"
local camp_icon_path = "heroList/effect/campBtn/campIcon"
local camp_num_path = "heroList/effect/campBtn/campDesText/campText"
local heroTemplate_path = "heroList/MailPlayerHeroItem"
local challengeBtn_path = "rankInfo/btns/challengeBtn"
local challengeBtnTxt_path = "rankInfo/btns/challengeBtn/layout/fightBtnTxt"
local challengeCost_path = "rankInfo/btns/challengeBtn/layout/fightCost"
local challengeCostNum_path = "rankInfo/btns/challengeBtn/layout/fightCost/costTicketNum"
local armyTxt_path = "heroList/Text_uityhei16"

local function GetCampImgByParamList(campAddParam)
  local img = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_fettersbg.png"
  if #campAddParam == 2 then
    local campA = campAddParam[1]
    local campB = campAddParam[2]
    if campA.num == 3 and campB.num == 2 or campA.num == 2 and campB.num == 3 then
      img = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_fetters_2.png"
    elseif campA.num == 2 and campB.num == 2 then
      img = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_fetters_7.png"
    end
  elseif #campAddParam == 1 then
    local campA = campAddParam[1]
    if campA.num == 2 then
      img = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_fetters_5.png"
    elseif campA.num == 3 then
      img = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_fetters_1.png"
    elseif campA.num == 4 then
      img = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_fetters_3.png"
    elseif campA.num == 5 then
      img = "Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_fetters_4.png"
    end
  end
  return img
end

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.armyContentN:RemoveComponents(MailPlayerHeroItem)
  self.heroTemplateN.gameObject:GameObjectRecycleAll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rankNumN = self:AddComponent(UIText, rankNum_path)
  self.rankImgN = self:AddComponent(UIImage, rankImg_path)
  self.playerHeadN = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadFgN = self:AddComponent(UIImage, playerHeadFg_path)
  self.playerHeadBtnN = self:AddComponent(UIButton, playerHeadBtn_path)
  self.playerHeadBtnN:SetOnClick(function()
    self:OnClickPlayerHeadBtn()
  end)
  self.nameN = self:AddComponent(UIText, name_path)
  self.powerN = self:AddComponent(UIText, power_path)
  self.scoreN = self:AddComponent(UIText, score_path)
  self.showArmyBtnN = self:AddComponent(UIButton, showArmyBtn_path)
  self.showArmyBtnN:SetOnClick(function()
    self:OnClickShowArmyBtn()
  end)
  self.showArmyBtnImgN = self:AddComponent(UIImage, showArmyBtnImg_path)
  self.armyContentN = self:AddComponent(UIBaseContainer, amryContent_path)
  self.heroEffect = self:AddComponent(UIBaseContainer, heroEffect_path)
  self.heroEffect_des = self:AddComponent(UIText, heroEffect_des_path)
  self.heroEffect_des:SetText(Localization:GetString("150231") .. ": ")
  self.camp_num = self:AddComponent(UIText, camp_num_path)
  self.camp_icon = self:AddComponent(UIImage, camp_icon_path)
  self.camp_restraint_item = self:AddComponent(CampRestraintItem, camp_restraint_item_path)
  self.camp_restraint_txt = self:AddComponent(UIText, camp_restraint_txt_path)
  self.heroTemplateN = self:AddComponent(UIBaseContainer, heroTemplate_path)
  self.heroTemplateN.gameObject:GameObjectCreatePool()
  self.challengeBtnN = self:AddComponent(UIButton, challengeBtn_path)
  self.challengeBtnN:SetOnClick(function()
    self:OnClickChallengeBtn()
  end)
  self.challengeBtnTxtN = self:AddComponent(UIText, challengeBtnTxt_path)
  self.challengeBtnTxtN:SetLocalText(372258)
  self.challengeCostN = self:AddComponent(UIBaseContainer, challengeCost_path)
  self.challengeCostN:SetActive(false)
  self.challengeCostNumN = self:AddComponent(UIText, challengeCostNum_path)
  self.armyTxtN = self:AddComponent(UIText, armyTxt_path)
  self.armyTxtN:SetLocalText(372257)
end

local function ComponentDestroy(self)
  self.rankNumN = nil
  self.rankImgN = nil
  self.playerHeadN = nil
  self.playerHeadFgN = nil
  self.nameN = nil
  self.powerN = nil
  self.scoreN = nil
  self.showArmyBtnN = nil
  self.armyContentN = nil
  self.heroTemplateN = nil
  self.challengeBtnN = nil
  self.challengeBtnTxtN = nil
end

local function DataDefine(self)
  self.rankInfo = nil
  self.index = 1
  self.showArmyCallBack = nil
  self.heroItems = {}
  self.isShowHeroes = false
end

local function DataDestroy(self)
  self.rankInfo = nil
  self.index = nil
  self.showArmyCallBack = nil
  self.heroItems = nil
  self.isShowHeroes = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, rankInfo, param)
  self.rankInfo = rankInfo
  self.index = param and param.index or 1
  self.showArmyCallBack = param and param.callback or nil
  self.isShowHeroes = param and param.isShowHeroes or nil
  self.challengeBtnN:SetActive(param and param.showChallenge)
  self:RefreshAll()
end

local function RefreshAll(self)
  if self.rankInfo == nil then
    self:ShowSelf()
  else
    self:ShowOther()
  end
end

local function ShowSelf(self)
  local selfInfo = DataCenter.ArenaManager:GetSelfInfo()
  self.rankImgN:SetActive(false)
  if selfInfo.selfRank < 0 then
    self.rankNumN:SetActive(true)
    self.rankNumN:SetLocalText(361054)
    self.scoreN:SetText(selfInfo.selfScore)
  else
    self.rankNumN:SetText(selfInfo.selfRank)
    self.scoreN:SetText(selfInfo.selfScore)
    if selfInfo.selfRank < 4 then
      self.rankImgN:SetActive(true)
      self.rankNumN:SetActive(false)
      self.rankImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_" .. selfInfo.selfRank)
    else
      self.rankNumN:SetActive(true)
      self.rankImgN:SetActive(false)
    end
  end
  self.playerHeadN:SetData(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer)
  local fgImg = LuaEntry.Player:GetHeadBgImg()
  if not string.IsNullOrEmpty(fgImg) then
    self.playerHeadFgN:SetActive(true)
  else
    self.playerHeadFgN:SetActive(false)
  end
  if LuaEntry.Player:IsInAlliance() then
    local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceBase then
      abbr = allianceBase.abbr
      self.nameN:SetText("[" .. allianceBase.abbr .. "]" .. LuaEntry.Player.name)
    else
      self.nameN:SetText(LuaEntry.Player.name)
    end
  else
    self.nameN:SetText(LuaEntry.Player.name)
  end
  self.powerN:SetText(string.GetFormattedStr(selfInfo.selfPower))
end

local function ShowOther(self)
  if self.rankInfo.type == 0 then
    self.rankNumN:SetActive(true)
    self.rankNumN:SetText(self.rankInfo.score)
    self.rankImgN:SetActive(false)
    self.nameN:SetLocalText(100184)
    self.powerN:SetText(string.GetFormattedStr(self.rankInfo.power))
    self.scoreN:SetText(self.rankInfo.score)
  else
    if self.rankInfo.rank < 4 then
      self.rankNumN:SetActive(false)
      self.rankImgN:SetActive(true)
      self.rankImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_" .. self.rankInfo.rank)
    else
      self.rankImgN:SetActive(false)
      self.rankNumN:SetActive(true)
      self.rankNumN:SetText(self.rankInfo.rank)
    end
    self.playerHeadN:SetData(self.rankInfo.uid, self.rankInfo.pic, self.rankInfo.picVer)
    local tempAbbr = not string.IsNullOrEmpty(self.rankInfo.abbr) and "[" .. self.rankInfo.abbr .. "]" or ""
    self.nameN:SetText(tempAbbr .. self.rankInfo.name)
    self.powerN:SetText(string.GetFormattedStr(self.rankInfo.power))
    self.scoreN:SetText(self.rankInfo.score)
  end
  local selfInfo = DataCenter.ArenaManager:GetSelfInfo()
  local maxChallengeTimes = LuaEntry.DataConfig:TryGetNum("arena", "k2")
  local remainTimes = maxChallengeTimes - selfInfo.fightTimes
  if 0 < remainTimes then
    self.challengeCostN:SetActive(false)
    self.challengeCostNumN:SetLocalText(130126)
    CS.UIGray.SetGray(self.challengeBtnN.transform, false, true)
  else
    local good = DataCenter.ItemData:GetItemById(ArenaTicketId)
    local num = good and good.count or 0
    if 0 < num then
      self.challengeCostN:SetActive(false)
      self.challengeCostNumN:SetText("x1")
      CS.UIGray.SetGray(self.challengeBtnN.transform, false, true)
    else
      self.challengeCostN:SetActive(false)
      CS.UIGray.SetGray(self.challengeBtnN.transform, true, false)
    end
  end
  self:RefreshArmy()
end

local function ShowHeroesByExternal(self, isShow)
  self.isShowHeroes = isShow
  self:RefreshArmy()
end

local function OnClickShowArmyBtn(self)
  if self.showArmyCallBack then
    self.showArmyCallBack(self.index)
  end
end

local function RefreshArmy(self)
  local scaleX = self.isShowHeroes and -1 or 1
  self.showArmyBtnImgN:SetLocalScaleXYZ(scaleX, 1, 1)
  self.armyContentN:SetActive(self.isShowHeroes)
  self.heroEffect:SetActive(self.isShowHeroes)
  if self.isShowHeroes then
    local heroes = self.rankInfo.army and self.rankInfo.army.heroes or {}
    local heroCount = #heroes
    for i = #self.heroItems, heroCount do
      local item = self.heroTemplateN.gameObject:GameObjectSpawn(self.armyContentN.transform)
      item.name = "hero_" .. i
      local obj = self.armyContentN:AddComponent(MailPlayerHeroItem, item.name)
      table.insert(self.heroItems, obj)
    end
    local heroIdList = {}
    for i, v in ipairs(self.heroItems) do
      if heroCount >= i then
        v:SetActive(true)
        v:SetData(heroes[i])
        table.insert(heroIdList, heroes[i].heroId)
      else
        v:SetActive(false)
      end
    end
    self:UpdateCampState(heroIdList)
  end
end

local function UpdateCampState(self, heroIdList)
  if #heroIdList <= 0 then
    self.heroEffect:SetActive(false)
    return
  end
  local campDataList = MarchUtil.GetCampParamByHeroIdList(heroIdList)
  if campDataList ~= nil then
    if 0 < #campDataList then
      local attackNum = 0
      for i = 1, #campDataList do
        attackNum = attackNum + campDataList[i].addEffectNum
      end
      self.camp_num:SetText(math.floor(attackNum) .. "%")
      local img = GetCampImgByParamList(campDataList)
      self.camp_icon:LoadSprite(img)
    else
      self.camp_icon:LoadSprite("Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_fettersbg.png")
      self.camp_num:SetLocalText(130261)
    end
  end
  local restraintData = MarchUtil.GetRestraintCampAndValue(heroIdList)
  if restraintData ~= nil then
    self.camp_restraint_item:InitData(restraintData.camp, restraintData.num)
    self.camp_restraint_txt:SetText(restraintData.addValue .. "%")
  else
    self.camp_restraint_item:InitData()
    self.camp_restraint_txt:SetText("0%")
  end
end

local function OnClickChallengeBtn(self)
  local canFight, tipId = DataCenter.ArenaManager:CheckIfCanChallenge()
  if not canFight then
    UIUtil.ShowTipsId(tipId)
    return
  end
  local id = ArenaBattleLevelId
  local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(id)
  if pveTemplate ~= nil then
    self.view.ctrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityCenterTable)
    DataCenter.ArenaManager:CacheUIName(UIWindowNames.UIArenaChallenge)
    DataCenter.ArenaManager:SetTargetEnemyInfo(self.rankInfo)
    local param = {}
    param.pveEntrance = PveEntrance.ArenaBattle
    param.levelId = id
    param.isStart = true
    DataCenter.BattleLevel:Enter(param)
  end
end

local function OnClickPlayerHeadBtn(self)
  if self.rankInfo and self.rankInfo.type == 1 and self.rankInfo.uid ~= LuaEntry.Player.uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.rankInfo.uid)
  end
end

ArenaRankItem.OnCreate = OnCreate
ArenaRankItem.OnDestroy = OnDestroy
ArenaRankItem.ComponentDefine = ComponentDefine
ArenaRankItem.ComponentDestroy = ComponentDestroy
ArenaRankItem.DataDefine = DataDefine
ArenaRankItem.DataDestroy = DataDestroy
ArenaRankItem.OnAddListener = OnAddListener
ArenaRankItem.OnRemoveListener = OnRemoveListener
ArenaRankItem.SetItem = SetItem
ArenaRankItem.RefreshAll = RefreshAll
ArenaRankItem.ShowSelf = ShowSelf
ArenaRankItem.ShowOther = ShowOther
ArenaRankItem.RefreshArmy = RefreshArmy
ArenaRankItem.ShowHeroesByExternal = ShowHeroesByExternal
ArenaRankItem.OnClickShowArmyBtn = OnClickShowArmyBtn
ArenaRankItem.OnClickChallengeBtn = OnClickChallengeBtn
ArenaRankItem.OnClickPlayerHeadBtn = OnClickPlayerHeadBtn
ArenaRankItem.UpdateCampState = UpdateCampState
return ArenaRankItem
