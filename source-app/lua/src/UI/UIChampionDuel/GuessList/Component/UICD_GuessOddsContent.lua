local UICD_GuessOddsContent = BaseClass("UICD_GuessOddsContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICD_GuessMatchRival = require("UI.UIChampionDuel.GuessList.Component.UICD_GuessMatchRival")
local img_top_path = "Top"
local img_odds_path = "Top/OddsBg"
local text_odds_path = "Top/OddsBg/OddsText"
local img_arrow_path = "Top/Btn/Arrow"
local text_title_path = "Top/Mid/TitleText"
local red_path = "Top/Mid/Red"
local text_red_path = "Top/Mid/Red/RedText"
local btn_info_path = "Top/Mid/BtnInfo"
local btn_top_path = "Top/Btn"
local content_path = "ListContent"
local TOP_RES_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunduijue_jingcai_gengguoxiazhu_biaotitiao0%d.png"
local ODDS_RES_PATH = "Assets/Main/Sprites/UI/UICitySkinActivity/sj_shengdang_jiaobiao%d.png"
local ARROW_DOWN_RES_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_1.png"
local ARROW_UP_RES_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_anniu_xiala_2.png"

function UICD_GuessOddsContent:OnCreate()
  base.OnCreate(self)
  self.baseItem = nil
  self.items = {}
  self.timers = {}
  self.img_top = self:AddComponent(UIImage, img_top_path)
  self.img_odds = self:AddComponent(UIImage, img_odds_path)
  self.text_odds = self:AddComponent(UIText, text_odds_path)
  self.img_arrow = self:AddComponent(UIImage, img_arrow_path)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.red = self:AddComponent(UIBaseComponent, red_path)
  self.text_red = self:AddComponent(UIText, text_red_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnInfoClick))
  self.btn_top = self:AddComponent(UIButton, btn_top_path)
  self.btn_top:SetOnClick(BindCallback(self, self.OnTopClick))
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UICD_GuessOddsContent:OnDestroy()
  self:ClearDelays()
  self.content:RemoveComponents(UICD_GuessMatchRival)
  self.items = {}
  self.baseItem = nil
  self.img_top = nil
  self.img_odds = nil
  self.text_odds = nil
  self.img_arrow = nil
  self.text_title = nil
  self.red = nil
  self.text_red = nil
  self.btn_top = nil
  self.content = nil
  base.OnDestroy(self)
end

function UICD_GuessOddsContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelBetInfoRefresh, self.UpdateData)
end

function UICD_GuessOddsContent:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelBetInfoRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function UICD_GuessOddsContent:ClearDelays()
  if not table.IsNullOrEmpty(self.timers) then
    for _, v in pairs(self.timers) do
      v:Stop()
    end
  end
  self.timers = {}
end

function UICD_GuessOddsContent:UpdateData(betMatchId)
  if self.curTab == 1 or betMatchId == nil or table.IsNullOrEmpty(self.matchRivals) then
    return
  end
  for _, v in pairs(self.matchRivals) do
    if v.betMatchId == betMatchId then
      self:UpdateRed()
      break
    end
  end
end

function UICD_GuessOddsContent:UpdateRed()
  if self.curTab == 1 or table.IsNullOrEmpty(self.matchRivals) then
    self.red:SetActive(false)
    return
  end
  local cnt = 0
  for _, v in pairs(self.matchRivals) do
    if v.hasBet and not v.hasReward then
      cnt = cnt + 1
    end
  end
  self.red:SetActive(0 < cnt)
  if 0 < cnt then
    self.text_red:SetText(cnt)
  end
end

function UICD_GuessOddsContent:ReInit(curTab, matchRivals, item, cb, idx)
  self.matchRivals = matchRivals
  if table.IsNullOrEmpty(matchRivals) then
    self:SetActive(false)
    self.curTab = nil
    self.baseItem = nil
    self.cb = nil
    return
  end
  self:SetActive(true)
  self.curTab = curTab
  self.baseItem = item
  self.cb = cb
  self.showList = idx ~= 1
  local odds = matchRivals[1].odds
  self.text_odds:SetText("\195\151" .. odds)
  local stageId = matchRivals[1].stageId or 0
  local oddsList = DataCenter.ChampionDuelManager:GetBetOdds(stageId)
  local str = ""
  local tmpNum = 1
  if stageId >= ChampionDuelState.KnockOut then
    local groupId = matchRivals[1].groupId or 0
    str = DataCenter.ChampionDuelManager:GetFinalStrKey(groupId)
    if odds == oddsList[#oddsList] then
      tmpNum = 2
    end
  elseif oddsList[1] == odds then
    str = "champion_duel_tips1115"
  elseif oddsList[2] == odds then
    str = "champion_duel_tips1114"
  elseif oddsList[3] == odds then
    str = "champion_duel_tips1113"
    tmpNum = 2
  end
  self.img_top:LoadSpriteAuto(string.format(TOP_RES_PATH, tmpNum))
  self.img_odds:LoadSpriteAuto(string.format(ODDS_RES_PATH, tmpNum))
  self.img_arrow:LoadSpriteAuto(ARROW_DOWN_RES_PATH)
  self.text_title:SetLocalText(str)
  self:UpdateRed()
  self:OnTopClick(true)
end

function UICD_GuessOddsContent:RefreshList(bReInit)
  local maxNum = math.max(#self.matchRivals, #self.items)
  local delayCnt = 0
  local delayScale = 1
  for i = 1, maxNum do
    local info = self.matchRivals[i]
    local item = self.items[i]
    if info ~= nil then
      if item == nil then
        self.timers[i] = TimerManager:GetInstance():DelayFrameInvoke(function()
          local cell = self.baseItem:GameObjectSpawn(self.content.transform)
          cell.name = "item" .. i
          item = self.content:AddComponent(UICD_GuessMatchRival, cell.name)
          self.items[i] = item
          item:SetActive(true)
          item:ReInit(info, self.curTab)
        end, delayCnt * delayScale)
        delayCnt = delayCnt + 1
      else
        item:SetActive(true)
        item:ReInit(info, self.curTab)
      end
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
  if bReInit ~= true or self.cb == nil then
    return
  end
  if delayCnt == 0 then
    self.cb()
  else
    self.timers[999] = TimerManager:GetInstance():DelayFrameInvoke(function()
      self.cb()
    end, delayCnt * delayScale)
  end
end

function UICD_GuessOddsContent:OnInfoClick()
  local strTip = Localization:GetString("champion_duel_tips1112")
  local pos = self.btn_info.transform.position
  local reversal = pos.y < Screen.height / 4
  local num = reversal and 30 or -30
  UIUtil.ShowBubbleTips(strTip, self.btn_info.transform.position, 0, num, 0, nil, nil, {reversal = reversal})
end

function UICD_GuessOddsContent:OnTopClick(bReInit)
  self:ClearDelays()
  self.showList = not self.showList
  self.content:SetActive(self.showList)
  local path = self.showList and ARROW_UP_RES_PATH or ARROW_DOWN_RES_PATH
  self.img_arrow:LoadSpriteAuto(path)
  if self.showList then
    self:RefreshList(bReInit)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  if bReInit ~= true and self.cb then
    self.cb()
  end
end

function UICD_GuessOddsContent:GetShowList()
  return self.showList
end

function UICD_GuessOddsContent:GetItemYH(idx)
  local name = "item" .. idx
  local item = self.content:GetComponent(name, UICD_GuessMatchRival)
  if item == nil then
    return 0, 0
  end
  local _, sY = self:GetLocalPositionXYZ()
  local _, iY = item:GetLocalPositionXYZ()
  local _, cY = self.content:GetLocalPositionXYZ()
  local _, cH = self.content.rectTransform:Get_sizeDelta()
  local _, iH = item.rectTransform:Get_sizeDelta()
  return sY + cY + iY, iH
end

return UICD_GuessOddsContent
