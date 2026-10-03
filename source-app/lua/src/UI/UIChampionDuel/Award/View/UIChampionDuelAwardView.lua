local UIChampionDuelAwardView = BaseClass("UIChampionDuelAwardView", UIBaseView)
local base = UIBaseView
local UIChampionDuelAwardTaskItem = require("UI.UIChampionDuel.Award.Component.UIChampionDuelAwardTaskItem")
local UIChampionDuelAwardRankItem = require("UI.UIChampionDuel.Award.Component.UIChampionDuelAwardRankItem")
local close_btn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local title_path = "Common_bg_orange/Common_img_title/titleText"
local tip_path = "Common_bg_orange/tip_text"
local btn_tip_path = "Common_bg_orange/TipBtn"
local text_btn_tip_path = "Common_bg_orange/TipBtn/TipBtnText"
local stageList = {
  3,
  5,
  7
}
local base_toggle_top_path = "Common_bg_orange/Common_bg_orange2/TogView/Content/ToggleStage"
local textKeys = {
  "champion_duel_phase_name1003",
  "champion_duel_phase_name1005",
  "champion_duel_phase_name1007"
}
local base_toggle_sec_path = "Common_bg_orange/Common_bg_orange2/SecView/Content/ToggleType"
local textSecKeys = {
  "champion_duel_tips1016",
  "champion_duel_tips1017"
}
local tip_reward_path = "Common_bg_orange/Common_bg_orange2/TipReward"
local content_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Viewport/Content"
local scroll_rect_path = "Common_bg_orange/Common_bg_orange2/ScrollView"
local sp_flag_path = "Common_bg_orange/Common_bg_orange2/SpFlag"
local item_task_name = "UIChampionDuelAwardTaskItem"
local item_rank_name = "UIChampionDuelAwardRankItem"
local item_rank_sp_name = "UIChampionDuelAwardRankSpItem"

function UIChampionDuelAwardView:OnCreate()
  base.OnCreate(self)
  self.cb = self:GetUserData()
  self.endTime = 0
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("130065")
  self.tip = self:AddComponent(UIText, tip_path)
  self.tip:SetActive(false)
  self.btn_tip = self:AddComponent(UIButton, btn_tip_path)
  self.btn_tip:SetOnClick(BindCallback(self, self.OnBtnTipClick))
  self.btn_tip:SetActive(false)
  self.text_btn_tip = self:AddComponent(UIText, text_btn_tip_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tip_reward = self:AddComponent(UIButton, tip_reward_path)
  self.tip_reward:SetOnClick(BindCallback(self, self.OnTipClick))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_rect_path)
  self.scroll_view:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
  self.scroll_view:SetOnDragingAction(function(_)
    self:CheckTipReward()
  end)
  self.scroll_view:SetOnEndDragAction(function(_)
    self:DelayCheckTipReward()
  end)
  self.spFlag = self.transform:Find(sp_flag_path).gameObject
  self.spFlag:GameObjectCreatePool()
  self.toggles = {}
  self.redStages = {}
  self.textRedStages = {}
  self.toggleSecs = {}
  self.redSecs = {}
  self.textRedSecs = {}
  local len = #textKeys
  local lenSec = #textSecKeys
  for i = 1, len do
    local keyStr = base_toggle_top_path .. i
    local toggle = self:AddComponent(UIToggle, keyStr)
    toggle:SetOnValueChanged(function(tf)
      self:SetOnTabValueChanged(i, tf)
    end)
    self.toggles[i] = toggle
    local langKey = textKeys[i]
    local text1 = self:AddComponent(UIText, keyStr .. "/tabStage_text" .. i)
    text1:SetLocalText(langKey)
    local text2 = self:AddComponent(UIText, keyStr .. "/Choose/tabStage_text" .. i .. 2)
    text2:SetLocalText(langKey)
    local red = self:AddComponent(UIBaseContainer, keyStr .. "/RedStage" .. i)
    self.redStages[i] = red
    local textRed = self:AddComponent(UIText, keyStr .. "/RedStage" .. i .. "/TextRedStage" .. i)
    self.textRedStages[i] = textRed
    if i <= lenSec then
      keyStr = base_toggle_sec_path .. i
      local toggleSec = self:AddComponent(UIToggle, keyStr)
      toggleSec:SetOnValueChanged(function(tf)
        self:SetOnValueChanged(i, tf)
      end)
      self.toggleSecs[i] = toggleSec
      langKey = textSecKeys[i]
      local textSec1 = self:AddComponent(UIText, keyStr .. "/tabType_text" .. i)
      textSec1:SetLocalText(langKey)
      local textSec2 = self:AddComponent(UIText, keyStr .. "/Choose/tabType_text" .. i .. 2)
      textSec2:SetLocalText(langKey)
      local redSec = self:AddComponent(UIBaseContainer, keyStr .. "/RedSec" .. i)
      self.redSecs[i] = redSec
      local textRedSec = self:AddComponent(UIText, keyStr .. "/RedSec" .. i .. "/TextRedSec" .. i)
      self.textRedSecs[i] = textRedSec
    end
  end
  self:CalculateReds()
  self.toggles[1]:SetIsOn(true)
  self:SetOnTabValueChanged(1, true, true)
end

function UIChampionDuelAwardView:OnDestroy()
  self:ClearDelay()
  self.cb = nil
  self:ClearGroupCell()
  self.content = nil
  self.scroll_view = nil
  self.spFlag = nil
  self.endTime = 0
  self.title = nil
  self.tip = nil
  self.btn_tip = nil
  self.text_btn_tip = nil
  self.close_btn = nil
  self.closeBg = nil
  self.toggles = {}
  self.redStages = {}
  self.textRedStages = {}
  self.toggleSecs = {}
  self.redSecs = {}
  self.textRedSecs = {}
  self.dataList = nil
  base.OnDestroy(self)
end

function UIChampionDuelAwardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelRewardRefresh, self.UpdateData)
end

function UIChampionDuelAwardView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelRewardRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIChampionDuelAwardView:ClearDelay()
  if self.delay then
    self.delay:Stop()
  end
  self.delay = nil
end

function UIChampionDuelAwardView:ClearGroupCell()
  self.scroll_view:RecycleAllItem()
  self.content:RemoveComponents(UIChampionDuelAwardTaskItem)
  self.content:RemoveComponents(UIChampionDuelAwardRankItem)
  if self.spFlag then
    self.spFlag:GameObjectRecycleAll()
  end
end

function UIChampionDuelAwardView:GetItemPrefabAndCls(info)
  if self.curIdx == 1 then
    return item_task_name, UIChampionDuelAwardTaskItem
  end
  local paras = info and info.paraList or nil
  local rank1 = paras ~= nil and tonumber(paras[1]) or 1
  if info ~= nil and info.stage == ChampionDuelState.KnockOut and rank1 == 1 then
    return item_rank_sp_name, UIChampionDuelAwardRankItem
  end
  return item_rank_name, UIChampionDuelAwardRankItem
end

function UIChampionDuelAwardView:GetItemComponent(loopItem, cls)
  if loopItem == nil or cls == nil or self.content == nil then
    return nil
  end
  local item = self.content:GetComponent(loopItem.gameObject.name, cls)
  if item == nil then
    local objectName = UIUtil.GetLoopListItemIndex("Item_")
    loopItem.gameObject.name = objectName
    item = self.content:AddComponent(cls, objectName)
  end
  return item
end

function UIChampionDuelAwardView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if not self.dataList or index < 1 or index > #self.dataList then
    return nil
  end
  local info = self.dataList[index]
  local prefabName, cls = self:GetItemPrefabAndCls(info)
  local loopItem = loopScroll:NewListViewItem(prefabName)
  if not loopItem then
    return nil
  end
  local item = self:GetItemComponent(loopItem, cls)
  if item then
    item:SetActive(true)
    item:ReInit(index, info)
    self.scroll_view:OnItemSizeChanged(index - 1)
  end
  return loopItem
end

function UIChampionDuelAwardView:GetRewardStatus(info)
  if info == nil then
    return 0
  end
  local status = 0
  local data = DataCenter.ChampionDuelManager:GetRewardInfo(info.id)
  local state = data ~= nil and data.status or 0
  if state == 1 then
    status = 1
  end
  state = data ~= nil and data.srStatus or 0
  if state == 1 then
    status = 2
  end
  return status
end

function UIChampionDuelAwardView:GetCheckPercent(status, index)
  if status == 1 then
    if self.toggleIdx == 3 and index == 1 then
      return 0.66
    end
    return 0.55
  end
  return 0.95
end

function UIChampionDuelAwardView:OnBtnTipClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local stageId = self.toggleIdx == 1 and ChampionDuelState.PreStage or ChampionDuelState.Rematch
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelGroupList, {anim = true}, stageId)
end

function UIChampionDuelAwardView:Update1000MS()
  if not self.canUpdate then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.endTime - curSec
  self.canUpdate = 0 <= remainTime
  if remainTime < 0 then
    if self.toggleIdx == 3 then
      self.tip:SetLocalText("champion_duel_tips1055")
      self.tip:SetActive(true)
      self.btn_tip:SetActive(false)
    else
      self.tip:SetActive(false)
      self.btn_tip:SetActive(true)
    end
  else
    local txt = UITimeManager:GetInstance():SecondToFmtString(remainTime)
    self.tip:SetLocalText("champion_duel_tips1054", txt)
    self.tip:SetActive(true)
    self.btn_tip:SetActive(false)
  end
end

function UIChampionDuelAwardView:SetOnTabValueChanged(idx, tf, bInit)
  if not tf then
    return
  end
  self.toggleIdx = idx
  local templateTypes = DataCenter.ChampionDuelManager:GetTemplateAwardByStageAndType(stageList[idx], 1)
  if table.IsNullOrEmpty(templateTypes) then
    self.toggleSecs[1]:SetActive(false)
    self.toggleSecs[2]:SetIsOn(true)
    self:SetOnValueChanged(2, true, bInit)
  else
    self.toggleSecs[1]:SetActive(true)
    self.toggleSecs[1]:SetIsOn(true)
    self:SetOnValueChanged(1, true, bInit)
  end
  local sTime, eTime
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  if idx == 1 then
    self.text_btn_tip:SetLocalText("champion_duel_tips1089")
    if stageId < ChampionDuelState.PreStageAnnouncement then
      sTime, eTime = DataCenter.ChampionDuelManager:GetStageTime(ChampionDuelState.PreStage)
    end
  elseif idx == 2 then
    self.text_btn_tip:SetLocalText("champion_duel_tips1090")
    if stageId < ChampionDuelState.RematchAnnouncement then
      sTime, eTime = DataCenter.ChampionDuelManager:GetStageTime(ChampionDuelState.Rematch)
    end
  elseif idx == 3 then
    sTime, eTime = DataCenter.ChampionDuelManager:GetStageTime(ChampionDuelState.KnockOut)
  end
  self.endTime = eTime ~= nil and eTime or 0
  self.canUpdate = true
  self:Update1000MS()
end

function UIChampionDuelAwardView:SetOnValueChanged(idx, tf, bInit)
  if tf then
    self.curIdx = idx
    self:RefreshList()
    self:RefreshReds()
  end
end

function UIChampionDuelAwardView:UpdateData(id)
  if self.cb then
    self.cb()
  end
  self:CalculateReds()
  if self.curIdx == 2 and id ~= nil then
    self:RefreshReds()
    return
  end
  self:SetOnValueChanged(self.curIdx, true)
end

local function SortList(a, b)
  local dataA = DataCenter.ChampionDuelManager:GetRewardInfo(a.id)
  local stateA = dataA ~= nil and dataA.status or 0
  local dataB = DataCenter.ChampionDuelManager:GetRewardInfo(b.id)
  local stateB = dataB ~= nil and dataB.status or 0
  if stateA ~= stateB then
    if stateA == 1 then
      return true
    end
    if stateB == 1 then
      return false
    end
    if stateA == 2 then
      return false
    end
    if stateB == 2 then
      return true
    end
  end
  return a.id < b.id
end

function UIChampionDuelAwardView:RefreshList()
  local rewards = DataCenter.ChampionDuelManager:GetTemplateAwardByStageAndType(stageList[self.toggleIdx], self.curIdx) or {}
  if self.curIdx == 1 then
    table.sort(rewards, SortList)
  end
  self.dataList = rewards
  self.scroll_view:SetListItemCount(#rewards, false, false)
  self.scroll_view:RefreshAllShownItem()
  self.scroll_view:MovePanelToItemIndex(0)
  self.targetIdx = 1
  self:DelayCheckTipReward()
end

function UIChampionDuelAwardView:GetStateCnt(info)
  local cnt = 0
  local data = DataCenter.ChampionDuelManager:GetRewardInfo(info.id)
  local state = data ~= nil and data.status or 0
  if state == 1 then
    cnt = cnt + 1
  end
  state = data ~= nil and data.srStatus or 0
  if state == 1 then
    cnt = cnt + 1
  end
  return cnt
end

function UIChampionDuelAwardView:CalculateReds()
  self.redCount = {}
  local MyTbIsNull = table.IsNullOrEmpty
  for i = 1, 3 do
    local list = {}
    for j = 1, 2 do
      local templates = DataCenter.ChampionDuelManager:GetTemplateAwardByStageAndType(stageList[i], j)
      local cntSec = 0
      if not MyTbIsNull(templates) then
        for _, v in ipairs(templates) do
          cntSec = cntSec + self:GetStateCnt(v)
        end
      end
      list[j] = cntSec
    end
    self.redCount[i] = list
  end
end

function UIChampionDuelAwardView:RefreshReds()
  local redCount = self.redCount or {}
  for i = 1, 3 do
    local cntStage = 0
    local list = redCount[i]
    if list then
      for j = 1, 2 do
        local cntSec = list[j] or 0
        cntStage = cntStage + cntSec
        local redSec = self.redSecs[j]
        if redSec and i == self.toggleIdx then
          redSec:SetActive(0 < cntSec)
          if redSec:GetActive() then
            local textRedSec = self.textRedSecs[j]
            if textRedSec then
              textRedSec:SetText(cntSec)
            end
          end
        end
      end
    end
    local redStage = self.redStages[i]
    if redStage then
      redStage:SetActive(0 < cntStage)
      if 0 < cntStage then
        local textRedStage = self.textRedStages[i]
        if textRedStage then
          textRedStage:SetText(cntStage)
        end
      end
    end
  end
  self:DelayCheckTipReward()
end

function UIChampionDuelAwardView:DelayCheckTipReward()
  self:ClearDelay()
  if self.curIdx == 1 then
    self:OnTipClick()
    return
  end
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self:CheckTipReward()
  end, 0.5)
end

function UIChampionDuelAwardView:CheckTipReward()
  self:ClearDelay()
  if self.curIdx == 1 then
    self.tip_reward:SetActive(false)
    return
  end
  local rewards = self.dataList or {}
  local showFlag = false
  self.targetIdx = nil
  local firstShownItem = self.scroll_view:GetShownItemByIndex(0)
  local firstShownIndex = firstShownItem ~= nil and firstShownItem.ItemIndex + 1 or nil
  for i, info in ipairs(rewards) do
    local status = self:GetRewardStatus(info)
    if 0 < status then
      local shownItem = self.scroll_view:GetShownItemByItemIndex(i - 1)
      if shownItem == nil then
        if firstShownIndex ~= nil and i < firstShownIndex then
          showFlag = true
          self.targetIdx = i
        end
        break
      end
      local _, cls = self:GetItemPrefabAndCls(info)
      local item = self:GetItemComponent(shownItem, cls)
      if item == nil then
        break
      end
      local corners = self.scroll_view:GetItemCornerPosInViewPort(shownItem, CS.SuperScrollView.ItemCornerEnum.LeftTop)
      local _, cH = item.rectTransform:Get_sizeDelta()
      local p = self:GetCheckPercent(status, i)
      if corners ~= nil and 0 > corners.y + cH * p then
        showFlag = true
        self.targetIdx = i
        break
      end
    end
  end
  self.tip_reward:SetActive(showFlag)
end

function UIChampionDuelAwardView:OnTipClick()
  if self.targetIdx then
    self.scroll_view:MovePanelToItemIndex(self.targetIdx - 1)
    self.targetIdx = nil
    self.tip_reward:SetActive(false)
  end
end

return UIChampionDuelAwardView
