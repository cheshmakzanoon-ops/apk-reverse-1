local LWActMeteoriteRank = BaseClass("LWActMeteoriteRank", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RankItem = require("UI.LWActMeteorite.Component.Rank.LWActMeteoriteRankItem")
local LWActMeteoriteRankTopTree = require("UI.LWActMeteorite.Component.Rank.LWActMeteoriteRankTopTree")
local base_toggle_path = "ToggleGroup/ToggleR"
local top_three_path = "TopThree"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/ViewPort/Content"
local empty_text_path = "EmptyText"
local my_item_path = "MyItem"
local a_info_btn_path = "MyItem/AInfo/Slider/AInfoBtn"
local p_info_btn_path = "MyItem/CoinText/PInfoBtn"
local gift_btn_path = "GiftBtn"
local tip_text_path = "TipText"
local TOP_P_CNT = 3

function LWActMeteoriteRank:OnCreate()
  base.OnCreate(self)
  self.dataList = {}
  self.itemObjs = {}
  self.toggles = {}
  self.topFlag = {}
  for i = 1, 4 do
    local toggle = self:AddComponent(UIToggle, base_toggle_path .. i)
    toggle:SetOnValueChanged(function(action)
      if action then
        self:SetToggle(i)
      end
    end)
    self.toggles[i] = toggle
    local text1 = toggle:AddComponent(UITextMeshProUGUIEx, "Text" .. i .. 1)
    local text2 = toggle:AddComponent(UITextMeshProUGUIEx, "Choose/Text" .. i .. 2)
    text1:SetLocalText("yuntieBattle_interface_1012", i)
    text2:SetLocalText("yuntieBattle_interface_1012", i)
    self.topFlag[i] = toggle:AddComponent(UIBaseComponent, "RedSec" .. i)
  end
  self.top_three = self:AddComponent(LWActMeteoriteRankTopTree, top_three_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
  self.my_item = self:AddComponent(RankItem, my_item_path)
  self.a_info_btn = self:AddComponent(UIButton, a_info_btn_path)
  self.a_info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnInfoClick(self.a_info_btn)
  end)
  self.p_info_btn = self:AddComponent(UIButton, p_info_btn_path)
  self.p_info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnInfoClick(self.p_info_btn)
  end)
  self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
  self.gift_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWActMeteoriteRankAward, {anim = true}, self.bPerson)
  end)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
end

function LWActMeteoriteRank:OnDestroy()
  self.scroll_view:RecycleAllItem()
  self.content:RemoveComponents(RankItem)
  self.top_three = nil
  self.scroll_view = nil
  self.content = nil
  self.empty_text = nil
  self.my_item = nil
  self.a_info_btn = nil
  self.p_info_btn = nil
  self.gift_btn = nil
  self.tip_text = nil
  self.dataList = {}
  self.itemObjs = {}
  self.toggles = {}
  self.topFlag = {}
  base.OnDestroy(self)
end

function LWActMeteoriteRank:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MeteoriteBattleRankRefresh, self.UpdateData)
end

function LWActMeteoriteRank:OnRemoveListener()
  self:RemoveUIListener(EventId.MeteoriteBattleRankRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function LWActMeteoriteRank:OnInfoClick(btn)
  local strTip = Localization:GetString("yuntieBattle_tips_1003")
  UIUtil.ShowBubbleTips(strTip, btn.transform.position, 0, 30, 0, nil, nil, {reversal = true})
end

function LWActMeteoriteRank:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if not self.dataList or index < 1 or index > #self.dataList then
    return nil
  end
  local item = loopScroll:NewListViewItem("LWActMeteoriteRankItem")
  if not item then
    return
  end
  local temp = self.itemObjs[item]
  if not temp then
    temp = self.content:GetComponent(item.gameObject.name, RankItem)
    if temp == nil then
      NameCount = NameCount + 1
      local objectName = tostring(NameCount)
      item.gameObject.name = objectName
      temp = self.content:AddComponent(RankItem, item.gameObject)
    end
  end
  if self.bPerson then
    local realIdx = index + TOP_P_CNT
    temp:SetData(realIdx, self.dataList[realIdx], true)
  else
    temp:SetData(index, self.dataList[index], false, self.maxNum)
  end
  self.itemObjs[item] = temp
  return item
end

function LWActMeteoriteRank:SetData(toIdx)
  self.bPerson = self.view and self.view:GetCurIdx() == 3
  self.tip_text:SetLocalText(self.bPerson and "yuntieBattle_interface_1013" or "yuntieBattle_interface_1014")
  self:UpdateScrollH(false)
  self.empty_text:SetActive(true)
  self.scroll_view:SetActive(false)
  self.my_item:SetActive(false)
  local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo() or {}
  local topIdx
  if actInfo.stage == MeteoriteState.SHOW then
    local checkServer = self.bPerson and actInfo.highestPersonRankServer or actInfo.highestAllianceRankServer
    local meteorites = actInfo.meteorites or {}
    for i, v in ipairs(meteorites) do
      if checkServer == v.serverId then
        topIdx = i
        break
      end
    end
  end
  for i, flag in ipairs(self.topFlag) do
    flag:SetActive(i == topIdx)
  end
  local grabLimit = actInfo.grabLimit or 1
  for i, toggle in ipairs(self.toggles) do
    toggle:SetActive(i <= grabLimit)
  end
  local stage = actInfo.stage or MeteoriteState.MATCH
  local curIdx = toIdx or 0
  if toIdx == nil and stage ~= MeteoriteState.SHOW then
    curIdx = actInfo.grabTimes or 0
  end
  curIdx = math.min(curIdx + 1, #self.toggles)
  if self.toggles[curIdx]:GetIsOn() then
    self:SetToggle(curIdx)
  else
    self.toggles[curIdx]:SetIsOn(true)
  end
end

function LWActMeteoriteRank:SetToggle(index)
  self.curIdx = index
  self.scroll_view:SetActive(false)
  self.my_item:SetActive(false)
  DataCenter.ActMeteoriteBattleManager:ReqRankInfo(index - 1, self.bPerson)
end

function LWActMeteoriteRank:UpdateData(group)
  if group.bPerson ~= self.bPerson or group.grabTimes ~= self.curIdx - 1 then
    return
  end
  local dataList = group.data or {}
  self.dataList = dataList
  if not self.bPerson and dataList[1] then
    self.maxNum = dataList[1].score
  else
    self.maxNum = 0
  end
  self.my_item:SetActive(true)
  self.my_item:SetSelfInfo(group.rank or 0, group.score or 0, self.bPerson, self.maxNum)
  local cnt = #dataList
  self.empty_text:SetActive(cnt == 0)
  self:UpdateScrollH(self.bPerson and 0 < cnt)
  if self.bPerson then
    if 0 < cnt then
      self.top_three:SetData(dataList[1], dataList[2], dataList[3])
    end
    cnt = math.max(cnt - TOP_P_CNT, 0)
  end
  self.scroll_view:SetActive(0 < cnt)
  if 0 < cnt then
    self.scroll_view:SetListItemCount(cnt, false, false)
    self.scroll_view:RefreshAllShownItem()
    self.scroll_view:MovePanelToItemIndex(0, 0)
  end
end

function LWActMeteoriteRank:UpdateScrollH(bPerson)
  self.top_three:SetActive(bPerson)
  local x, y = self.scroll_view:GetOffsetMaxXY()
  y = -95
  if bPerson then
    local _, h = self.top_three:GetSizeDeltaXY()
    y = y - h
  end
  self.scroll_view:SetOffsetMaxXY(x, y)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scroll_view.transform)
end

return LWActMeteoriteRank
