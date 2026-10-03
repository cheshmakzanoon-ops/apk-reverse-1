local ArenaHistoryItem = BaseClass("ArenaHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailPlayerHeroItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleTypeNew.MailPlayerHeroItem")
local playerHead_path = "rankInfo/playerFlag/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "rankInfo/playerFlag/UIPlayerHead/Foreground"
local playerName_path = "rankInfo/playerName"
local playerHeadBtn_path = "rankInfo/playerFlag/UIPlayerHead"
local result_path = "rankInfo/result"
local addScore_path = "rankInfo/addScore"
local fightBtn_path = "rankInfo/fightBtn"
local fightBtnTxt_path = "rankInfo/fightBtn/layout/fightBtnTxt"
local costTicket_path = "rankInfo/fightBtn/layout/fightCost"
local costTicketNum_path = "rankInfo/fightBtn/layout/fightCost/costTicketNum"
local showHeroes_path = "rankInfo/showTeamBtn"
local showHeroesImg_path = "rankInfo/showTeamBtn/Image (2)"
local heroContainer_path = "heroList"
local heroTemplate_path = "heroList/MailPlayerHeroItem"
local heroTxt_path = "heroList/Text_uityhei16"
local resultWin_path = "rankInfo/win_bg"
local resultWinText_path = "rankInfo/win_bg/result_win"
local resultlose_path = "rankInfo/lose_bg"
local resultloseText_path = "rankInfo/lose_bg/result_lose"
local replay_btn_path = "rankInfo/btnRelay"
local replay_txt_path = "rankInfo/btnRelay/btnRelayTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.heroContainerN:RemoveComponents(MailPlayerHeroItem)
  self.heroTemplateN.gameObject:GameObjectRecycleAll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.playerHeadN = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadFgN = self:AddComponent(UIImage, playerHeadFg_path)
  self.playerNameN = self:AddComponent(UIText, playerName_path)
  self.playerHeadBtnN = self:AddComponent(UIButton, playerHeadBtn_path)
  self.playerHeadBtnN:SetOnClick(function()
    self:OnClickPlayerHeadBtn()
  end)
  self.resultN = self:AddComponent(UIText, result_path)
  self.addScoreN = self:AddComponent(UIText, addScore_path)
  self.fightBtnN = self:AddComponent(UIButton, fightBtn_path)
  self.fightBtnN:SetOnClick(function()
    self:OnClickChallengeBtn()
  end)
  self.fightBtnTxtN = self:AddComponent(UIText, fightBtnTxt_path)
  self.fightBtnTxtN:SetLocalText(372264)
  self.costTicketN = self:AddComponent(UIBaseContainer, costTicket_path)
  self.costTicketNumN = self:AddComponent(UIText, costTicketNum_path)
  self.showHeroesBtnN = self:AddComponent(UIButton, showHeroes_path)
  self.showHeroesBtnN:SetOnClick(function()
    self:OnClickShowArmyBtn()
  end)
  self.showHeroesBtnImgN = self:AddComponent(UIImage, showHeroesImg_path)
  self.heroContainerN = self:AddComponent(UIBaseContainer, heroContainer_path)
  self.heroTemplateN = self:AddComponent(UIBaseContainer, heroTemplate_path)
  self.resultWinN = self:AddComponent(UIBaseContainer, resultWin_path)
  self.resultloseN = self:AddComponent(UIBaseContainer, resultlose_path)
  self.resultWinTextN = self:AddComponent(UIText, resultWinText_path)
  self.resultloseTextN = self:AddComponent(UIText, resultloseText_path)
  self.heroTemplateN.gameObject:GameObjectCreatePool()
  self.heroTxtN = self:AddComponent(UIText, heroTxt_path)
  self.replay_btn = self:AddComponent(UIButton, replay_btn_path)
  self.replay_btn:SetOnClick(function()
    self:OnClickRePlayBtn()
  end)
  self.replay_txt = self:AddComponent(UIText, replay_txt_path)
  self.replay_txt:SetLocalText(100092)
  self.heroTxtN:SetLocalText(372257)
end

local function ComponentDestroy(self)
  self.playerHeadN = nil
  self.playerHeadFgN = nil
  self.playerNameN = nil
  self.resultN = nil
  self.addScoreN = nil
  self.fightBtnN = nil
  self.costTicketNumN = nil
  self.showHeroesBtnN = nil
  self.heroContainerN = nil
  self.heroTemplateN = nil
end

local function DataDefine(self)
  self.rankInfo = nil
  self.heroItems = {}
  self.isShowHeroes = false
end

local function DataDestroy(self)
  self.rankInfo = nil
  self.heroItems = nil
  self.isShowHeroes = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, rankInfo, params)
  self.rankInfo = rankInfo
  self.index = params and params.index or 1
  self.isShowHeroes = params and params.isShowHeroes or false
  self.showHeroesCallBack = params and params.callback or nil
  if not self.rankInfo then
    return
  end
  self:RefreshAll()
end

local function RefreshAll(self)
  if self.rankInfo.type == 0 then
    self.playerNameN:SetLocalText(100184)
  else
    self.playerHeadN:SetData(self.rankInfo.uid, self.rankInfo.pic, self.rankInfo.picVer)
    local tempAbbr = not string.IsNullOrEmpty(self.rankInfo.abbr) and "[" .. self.rankInfo.abbr .. "]" or ""
    self.playerNameN:SetText(tempAbbr .. self.rankInfo.name)
  end
  self.resultloseN:SetActive(false)
  self.resultWinN:SetActive(false)
  if 0 < self.rankInfo.addScore then
    self.addScoreN:SetText("+" .. self.rankInfo.addScore)
    self.addScoreN:SetColor(Color.New(0.5333333333333333, 0.8941176470588236, 0.21568627450980393, 1))
    self.resultWinTextN:SetLocalText(390186)
    self.fightBtnN:SetActive(false)
    self.resultWinN:SetActive(true)
  else
    self.resultloseTextN:SetLocalText(390187)
    self.addScoreN:SetText(self.rankInfo.addScore)
    self.addScoreN:SetColor(Color.New(0.8666666666666667, 0.1568627450980392, 0.1568627450980392, 1))
    self.resultloseN:SetActive(true)
    self.fightBtnN:SetActive(true)
    local selfInfo = DataCenter.ArenaManager:GetSelfInfo()
    local maxChallengeTimes = LuaEntry.DataConfig:TryGetNum("arena", "k2")
    local remainTimes = maxChallengeTimes - selfInfo.fightTimes
    if 0 < remainTimes then
      self.costTicketN:SetActive(true)
      self.costTicketNumN:SetLocalText(130126)
      CS.UIGray.SetGray(self.fightBtnN.transform, false, true)
    else
      local good = DataCenter.ItemData:GetItemById(ArenaTicketId)
      local num = good and good.count or 0
      if 0 < num then
        self.costTicketN:SetActive(true)
        self.costTicketNumN:SetText("x1")
        CS.UIGray.SetGray(self.fightBtnN.transform, false, true)
      else
        self.costTicketN:SetActive(false)
        CS.UIGray.SetGray(self.fightBtnN.transform, true, false)
      end
    end
  end
  self:RefreshArmy()
end

local function RefreshArmy(self)
  local scaleX = self.isShowHeroes and -1 or 1
  self.showHeroesBtnImgN:SetLocalScaleXYZ(scaleX, 1, 1)
  self.heroContainerN:SetActive(self.isShowHeroes)
  if self.isShowHeroes then
    local heroes = self.rankInfo.army and self.rankInfo.army.heroes or {}
    local heroCount = #heroes
    for i = #self.heroItems, heroCount do
      local item = self.heroTemplateN.gameObject:GameObjectSpawn(self.heroContainerN.transform)
      item.name = "hero_" .. i
      local obj = self.heroContainerN:AddComponent(MailPlayerHeroItem, item.name)
      table.insert(self.heroItems, obj)
    end
    for i, v in ipairs(self.heroItems) do
      if i <= heroCount then
        v:SetActive(true)
        v:SetData(heroes[i])
      else
        v:SetActive(false)
      end
    end
  end
end

local function ShowHeroesByExternal(self, isShow)
  self.isShowHeroes = isShow
  self:RefreshArmy()
end

local function OnClickShowArmyBtn(self)
  if self.showHeroesCallBack then
    self.showHeroesCallBack(self.index)
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
    DataCenter.ArenaManager:CacheUIName(UIWindowNames.UIArenaHistory)
    DataCenter.ArenaManager:SetTargetEnemyInfo(self.rankInfo)
    local param = {}
    param.pveEntrance = PveEntrance.ArenaBattle
    param.levelId = id
    param.isStart = true
    DataCenter.BattleLevel:Enter(param)
  end
end

local function OnClickPlayerHeadBtn(self)
  if self.rankInfo and self.rankInfo.type == 1 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.rankInfo.uid)
  end
end

local function OnClickRePlayBtn(self)
  if self.rankInfo and self.rankInfo.uuid ~= 0 then
    SFSNetwork.SendMessage(MsgDefines.UserGetArenaReport, self.rankInfo.uuid)
  end
end

ArenaHistoryItem.OnCreate = OnCreate
ArenaHistoryItem.OnDestroy = OnDestroy
ArenaHistoryItem.ComponentDefine = ComponentDefine
ArenaHistoryItem.ComponentDestroy = ComponentDestroy
ArenaHistoryItem.DataDefine = DataDefine
ArenaHistoryItem.DataDestroy = DataDestroy
ArenaHistoryItem.OnAddListener = OnAddListener
ArenaHistoryItem.OnRemoveListener = OnRemoveListener
ArenaHistoryItem.SetItem = SetItem
ArenaHistoryItem.RefreshAll = RefreshAll
ArenaHistoryItem.RefreshArmy = RefreshArmy
ArenaHistoryItem.ShowSelf = ShowSelf
ArenaHistoryItem.ShowOther = ShowOther
ArenaHistoryItem.ShowHeroesByExternal = ShowHeroesByExternal
ArenaHistoryItem.OnClickShowArmyBtn = OnClickShowArmyBtn
ArenaHistoryItem.OnClickChallengeBtn = OnClickChallengeBtn
ArenaHistoryItem.OnClickPlayerHeadBtn = OnClickPlayerHeadBtn
ArenaHistoryItem.OnClickRePlayBtn = OnClickRePlayBtn
return ArenaHistoryItem
