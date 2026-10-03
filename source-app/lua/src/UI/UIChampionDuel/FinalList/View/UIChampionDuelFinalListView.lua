local UIChampionDuelFinalListView = BaseClass("UIChampionDuelFinalListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICD_FinalBg = require("UI.UIChampionDuel.FinalList.Component.UICD_FinalBg")
local UICD_FinalTopThree_Cls = "UI.UIChampionDuel.FinalList.Component.UICD_FinalTopThree"
local UICD_FinalTopThree_Prefab = "Assets/Main/Prefabs/UI/UIChampionDuel/Final/UICD_FinalTopThree.prefab"
local UICD_FinalListGroup_Cls = "UI.UIChampionDuel.FinalList.Component.UICD_FinalListGroup"
local UICD_FinalListGroup_Prefab = "Assets/Main/Prefabs/UI/UIChampionDuel/Final/UICD_FinalListGroup.prefab"
local bg_path = "Root/ScrollView/Viewport/Content/Bg"
local title_path = "Root/ScrollView/Viewport/Content/Top/titleText"
local btn_info_path = "Root/ScrollView/Viewport/Content/Top/InfoBtn"
local text_time_path = "Root/ScrollView/Viewport/Content/Top/TimeGroup/TimeText"
local btn_close_path = "Root/Bottom/BtnBack"
local scroll_rect_path = "Root/ScrollView"
local content_path = "Root/ScrollView/Viewport/Content"

function UIChampionDuelFinalListView:OnCreate()
  base.OnCreate(self)
  self.items = {}
  self.checkCB = BindCallback(self, self.CheckLoadFinish)
  self.bg = self:AddComponent(UICD_FinalBg, bg_path)
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("champion_duel_tips1138")
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClick))
  self.text_time = self:AddComponent(UIText, text_time_path)
  self.text_time:SetActive(true)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scroll_rect = self:AddComponent(UIScrollRect, scroll_rect_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.top_three = self:LoadComponentAsync(UICD_FinalTopThree_Cls, UICD_FinalTopThree_Prefab, self.content)
  self.top_three:SetSiblingIndex(1)
  self.top_three:SetName("TopThree")
  self:InitData()
  local list = DataCenter.ChampionDuelManager:GetFinalRankList()
  if table.IsNullOrEmpty(list) then
    DataCenter.ChampionDuelManager:ReqBattleFinalRank()
  else
    self:RefreshUI()
  end
end

function UIChampionDuelFinalListView:OnDestroy()
  self.items = nil
  self.top_three = nil
  self.bg = nil
  self.title = nil
  self.btn_info = nil
  self.btn_close = nil
  self.content = nil
  self.scroll_rect = nil
  self.dataList = nil
  base.OnDestroy(self)
end

function UIChampionDuelFinalListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelFinalRankListRefresh, self.RefreshUI)
end

function UIChampionDuelFinalListView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelFinalRankListRefresh, self.RefreshUI)
  base.OnRemoveListener(self)
end

function UIChampionDuelFinalListView:OnBtnInfoClick()
  UIUtil.ShowIntro(Localization:GetString(170001), nil, Localization:GetString("champion_duel_tips1150"))
end

function UIChampionDuelFinalListView:InitData()
  local list = {}
  local MyInsert = table.insert
  MyInsert(list, {s = 4, e = 8})
  MyInsert(list, {s = 9, e = 16})
  MyInsert(list, {s = 17, e = 32})
  self.dataList = list
end

function UIChampionDuelFinalListView:RefreshUI()
  self.bg:SetFixSize(self.content.rectTransform.rect.width)
  self.endTime = DataCenter.ChampionDuelManager:GetFinalRankEndTime()
  if self.endTime == 0 then
    local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
    if actInfo then
      self.endTime = actInfo.endTime or 0
    end
  end
  self.endTime = self.endTime * 1000
  self.top_three:SetActive(true)
  self.top_three:SetData("UICD_FinalListView")
  self.finishCnt = 0
  local l = #self.dataList
  for i = 1, l do
    local info = self.dataList[i]
    local item = self.items[i]
    if info ~= nil then
      if item == nil then
        item = self:LoadComponentAsync(UICD_FinalListGroup_Cls, UICD_FinalListGroup_Prefab, self.content)
        item:SetSiblingIndex(i + 2)
        self.items[i] = item
        item:SetName("item" .. i)
      end
      item:SetActive(true)
      item:SetData(i, info, self.checkCB)
    else
      if item ~= nil then
        item:SetActive(false)
      end
      self:CheckLoadFinish()
    end
  end
end

function UIChampionDuelFinalListView:CheckLoadFinish()
  self.finishCnt = self.finishCnt + 1
  if self.finishCnt < #self.dataList then
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self.bg:SetFixSize(self.content.rectTransform.rect.width)
  self.scroll_rect:SetVerticalNormalizedPosition(1)
end

function UIChampionDuelFinalListView:Update1000MS()
  if not self.text_time:GetActive() or self.endTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.text_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.text_time:SetActive(false)
    self.ctrl:CloseSelf()
  end
end

return UIChampionDuelFinalListView
