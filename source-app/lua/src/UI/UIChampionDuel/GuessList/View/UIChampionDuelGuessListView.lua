local UIChampionDuelGuessListView = BaseClass("UIChampionDuelGuessListView", UIBaseView)
local base = UIBaseView
local UICD_GuessOddsContent = require("UI.UIChampionDuel.GuessList.Component.UICD_GuessOddsContent")
local title_path = "Common_bg_orange/Common_img_title/titleText"
local closeBtn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local tip_reward_path = "Common_bg_orange/Common_bg_orange2/TipReward"
local content_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Viewport/Content"
local scroll_view_path = "Common_bg_orange/Common_bg_orange2/ScrollView"
local toggle_base_path = "Common_bg_orange/Common_bg_orange2/ToggleGroup/Toggle"
local text_have_tip_path = "Common_bg_orange/Common_bg_orange2/Di/HaveGroup/HaveTipText"
local img_have_icon_path = "Common_bg_orange/Common_bg_orange2/Di/HaveGroup/HaveIcon"
local text_have_num_path = "Common_bg_orange/Common_bg_orange2/Di/HaveGroup/HaveNumText"
local text_remain_path = "Common_bg_orange/Common_bg_orange2/Di/RemainText"
local toggle_check_path = "Common_bg_orange/Common_bg_orange2/Di/CheckToggle"
local text_check_tip_path = "Common_bg_orange/Common_bg_orange2/Di/CheckToggle/CheckTipText"
local text_empty_path = "Common_bg_orange/Common_bg_orange2/EmptyText"
local red_path = "Common_bg_orange/Common_bg_orange2/ToggleGroup/Toggle2/Red"
local text_red_path = "Common_bg_orange/Common_bg_orange2/ToggleGroup/Toggle2/Red/RedText"
local item_path = "Common_bg_orange/Common_bg_orange2/Item"
local odds_content_path = "Common_bg_orange/Common_bg_orange2/oddsContent"
local TEXT_TOGGLE_KEY = {
  "champion_duel_tips1123",
  "champion_duel_tips1124"
}
local TAB_CHANGE_DELAY = 3

function UIChampionDuelGuessListView:OnCreate()
  base.OnCreate(self)
  self.cb = self:GetUserData()
  self.forceCb = BindCallback(self, self.ForceUpdateCb)
  self.groups = {}
  self.oddsList = {}
  self.items = {}
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("champion_duel_tips1117")
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.text_have_tip = self:AddComponent(UIText, text_have_tip_path)
  self.text_have_tip:SetLocalText("champion_duel_tips1110")
  self.img_have_icon = self:AddComponent(UIImage, img_have_icon_path)
  local iconPath = DataCenter.ChampionDuelManager:GetGuessItemIcon()
  if iconPath then
    self.img_have_icon:LoadSpriteAsyncWithCallback(iconPath, function()
      if self.img_have_icon then
        self.img_have_icon:SetNativeSize()
      end
    end)
  end
  self.text_have_num = self:AddComponent(UIText, text_have_num_path)
  self.text_remain = self:AddComponent(UIText, text_remain_path)
  self.toggle_check = self:AddComponent(UIToggle, toggle_check_path)
  self.toggle_check:SetOnValueChanged(function(tf)
    self:UpdateData()
  end)
  self.text_check_tip = self:AddComponent(UIText, text_check_tip_path)
  self.text_check_tip:SetLocalText("champion_duel_tips1116")
  self.text_empty = self:AddComponent(UIText, text_empty_path)
  self.red = self:AddComponent(UIBaseComponent, red_path)
  self.text_red = self:AddComponent(UIText, text_red_path)
  self.tip_reward = self:AddComponent(UIButton, tip_reward_path)
  self.tip_reward:SetOnClick(function()
    if self.targetPos then
      self.scroll_view:AnimVerticalNormalizedPos(self.targetPos, 0.2)
      self.targetPos = nil
      self.tip_reward:SetActive(false)
    end
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.scroll_view:AddValueChangeListener(function()
    self:CheckTipReward()
  end)
  self.toggles = {}
  for i = 1, 2 do
    local path = toggle_base_path .. i
    local toggle = self:AddComponent(UIToggle, path)
    toggle:SetOnValueChanged(function(tf)
      if tf then
        self:UpdateSel(i)
      end
    end)
    self.toggles[i] = toggle
    local textPath = path .. "/tab_text" .. i .. 1
    local text1 = self:AddComponent(UIText, textPath)
    text1:SetLocalText(TEXT_TOGGLE_KEY[i])
    textPath = path .. "/Choose/tab_text" .. i .. 2
    local text2 = self:AddComponent(UIText, textPath)
    text2:SetLocalText(TEXT_TOGGLE_KEY[i])
  end
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.oddsContent = self.transform:Find(odds_content_path).gameObject
  self.oddsContent:GameObjectCreatePool()
  local idx = self:CheckCanTab1() and 1 or 2
  self.toggles[idx]:SetIsOn(true)
  self:UpdateSel(idx)
end

function UIChampionDuelGuessListView:OnDestroy()
  self.cb = nil
  if self.spTimer then
    self.spTimer:Stop()
  end
  self.spTimer = nil
  self:ClearDelays()
  self.forceCb = nil
  self.groups = {}
  self.oddsList = {}
  self.items = {}
  self.content:RemoveComponents(UICD_GuessOddsContent)
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  self.oddsContent:GameObjectRecycleAll()
  self.oddsContent = nil
  self.content = nil
  self.scroll_view = nil
  self.toggles = {}
  self.tip_reward = nil
  self.title = nil
  self.close_btn = nil
  self.closeBg = nil
  self.text_have_tip = nil
  self.img_have_icon = nil
  self.text_have_num = nil
  self.text_remain = nil
  self.toggle_check = nil
  self.text_check_tip = nil
  self.text_empty = nil
  self.red = nil
  self.text_red = nil
  base.OnDestroy(self)
end

function UIChampionDuelGuessListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelBetListRefresh, self.UpdateData)
  self:AddUIListener(EventId.ChampionDuelBetInfoRefresh, self.RefreshDi)
end

function UIChampionDuelGuessListView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelBetListRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.ChampionDuelBetInfoRefresh, self.RefreshDi)
  base.OnRemoveListener(self)
end

function UIChampionDuelGuessListView:RefreshDi()
  if self.cb then
    self.cb()
  end
  local curHave = DataCenter.ChampionDuelManager:GetGuessItemHave()
  self.text_have_num:SetText(string.GetFormattedStr(math.floor(curHave)))
  local betInfo = DataCenter.ChampionDuelManager:GetBetInfo()
  local dayRemainingBets = betInfo ~= nil and betInfo.dayRemainingBets or 0
  self.text_remain:SetLocalText("champion_duel_tips1111", dayRemainingBets)
  self:UpdateRed()
  if self:FixOnlySelf() then
    self:UpdateData()
    return true
  end
  return false
end

function UIChampionDuelGuessListView:CheckCanTab1(showTip)
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  if stageId == ChampionDuelState.RematchAnnouncement or stageId == ChampionDuelState.FinalShow then
    if showTip then
      UIUtil.ShowTipsId(stageId == ChampionDuelState.RematchAnnouncement and "champion_duel_tips1121" or "champion_duel_tips1122")
    end
    return false
  end
  local betInfo = DataCenter.ChampionDuelManager:GetBetInfo()
  if betInfo == nil or betInfo.isStageBattleEnd == true then
    if showTip then
      UIUtil.ShowTipsId(stageId == ChampionDuelState.Rematch and "champion_duel_tips1121" or "champion_duel_tips1122")
    end
    return false
  end
  return true
end

function UIChampionDuelGuessListView:UpdateSel(i)
  self.curTab = i
  if i == 1 then
    if not self:CheckCanTab1(true) then
      self.toggles[2]:SetIsOn(true)
      self:UpdateSel(2)
      return
    end
    self.toggle_check:SetActive(false)
    self:DelayFrameCall(function()
      self.oddsList = {}
      DataCenter.ChampionDuelManager:ReqBetMoreGuessable()
    end, TAB_CHANGE_DELAY)
  else
    self.toggle_check:SetActive(false)
    self:DelayFrameCall(function()
      self.oddsList = {}
      DataCenter.ChampionDuelManager:ReqBetMoreGuessed()
    end, TAB_CHANGE_DELAY)
  end
  self.tip_reward:SetActive(false)
  self.scroll_view:SetActive(false)
  self.text_empty:SetLocalText("champion_duel_tips1132")
  self.text_empty:SetActive(true)
  self:ClearDelays()
end

function UIChampionDuelGuessListView:DelayFrameCall(cb, delayFame)
  if self.spTimer then
    self.spTimer:Stop()
  end
  self.spTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.spTimer then
      self.spTimer:Stop()
    end
    self.spTimer = nil
    if cb then
      cb()
    end
  end, delayFame)
end

function UIChampionDuelGuessListView:FixOnlySelf()
  local guessList = DataCenter.ChampionDuelManager:GetGuessList(self.curTab)
  local haveBet = false
  for _, v in ipairs(guessList) do
    if v.hasBet then
      haveBet = true
      break
    end
  end
  self.toggle_check:SetActive(self.curTab == 1 and haveBet)
  local bOnlySelf = self.toggle_check:GetIsOn()
  if bOnlySelf and not haveBet then
    self.toggle_check:SetIsOn(false)
    return true
  end
  return false
end

function UIChampionDuelGuessListView:ClearDelays()
  for _, v in pairs(self.items) do
    v:ClearDelays()
  end
end

function UIChampionDuelGuessListView:ForceUpdateCb()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self:CheckTipReward()
end

function UIChampionDuelGuessListView:UpdateData()
  if self:RefreshDi() then
    return
  end
  local guessList = DataCenter.ChampionDuelManager:GetGuessList(self.curTab)
  local groups = {}
  local oddsList = {}
  local bOnlySelf = self.toggle_check:GetIsOn()
  local marked = self.curTab == 1 and bOnlySelf or false
  for _, v in ipairs(guessList) do
    if not marked or v.hasBet then
      local key = v.odds .. "_" .. v.stageId
      if v.stageId == ChampionDuelState.KnockOut then
        key = key .. "_" .. v.groupId
      end
      local list = groups[key]
      if list == nil then
        list = {}
        groups[key] = list
        table.insert(oddsList, key)
      end
      table.insert(list, v)
    end
  end
  table.sort(oddsList, function(a, b)
    return b < a
  end)
  self.oddsList = oddsList
  for _, list in pairs(groups) do
    table.sort(list, function(a, b)
      return a.betMatchBattleTime > b.betMatchBattleTime
    end)
  end
  self.groups = groups
  local cnt = #self.oddsList
  self.text_empty:SetActive(cnt == 0)
  self.text_empty:SetLocalText("champion_duel_tips1131")
  self.scroll_view:SetActive(0 < cnt)
  self:ClearDelays()
  if cnt == 0 then
    return
  end
  local iCnt = #self.items
  local maxNum = math.max(cnt, iCnt)
  for i = 1, maxNum do
    local item = self.items[i]
    local odds = self.oddsList[i]
    if odds ~= nil then
      if item == nil then
        local cell = self.oddsContent:GameObjectSpawn(self.content.transform)
        cell.name = "item" .. i
        item = self.content:AddComponent(UICD_GuessOddsContent, cell.name)
        self.items[i] = item
      end
      item:SetActive(true)
      local list = self.groups[odds]
      item:ReInit(self.curTab, list, self.theItem, self.forceCb, i)
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
  self.scroll_view:SetVerticalNormalizedPosition(1)
end

function UIChampionDuelGuessListView:UpdateRed()
  local cnt = DataCenter.ChampionDuelManager:CheckGuessRewardRed()
  self.red:SetActive(0 < cnt)
  if 0 < cnt then
    self.text_red:SetText(cnt)
  end
  self:CheckTipReward()
end

function UIChampionDuelGuessListView:CheckTipReward()
  if self.curTab == 1 then
    self.tip_reward:SetActive(false)
    return
  end
  local rect = self.scroll_view.rectTransform.rect
  local y = self.content:GetAnchoredPositionY()
  local cH = self.content.rectTransform.rect.height
  local sH = rect.height
  local showFlag = false
  self.targetPos = nil
  local per = 0.95
  for i, odds in ipairs(self.oddsList) do
    local name = "item" .. i
    local item = self.content:GetComponent(name, UICD_GuessOddsContent)
    if item ~= nil then
      local list = self.groups[odds]
      if not table.IsNullOrEmpty(list) then
        local idx = 0
        for _i, v in ipairs(list) do
          if v.hasBet and not v.hasReward then
            idx = _i
          end
        end
        if 0 < idx then
          if item:GetShowList() then
            local iY, iH = item:GetItemYH(idx)
            local top = y + iY + sH
            local check = top - iH * per
            if check < 0 then
              showFlag = true
              self.targetPos = (cH + (iY - iH * per)) / cH
              break
            end
          else
            local _, itemH = item.rectTransform:Get_sizeDelta()
            local _, itemY = item:GetLocalPositionXYZ()
            local top = y + itemY + sH
            local check = top - itemH * per
            if check < 0 then
              showFlag = true
              self.targetPos = (cH + (itemY - itemH * per)) / cH
              break
            end
          end
        end
      end
    end
  end
  self.tip_reward:SetActive(showFlag)
end

return UIChampionDuelGuessListView
