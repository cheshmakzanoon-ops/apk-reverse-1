local UILWSeasonVirusRankView = BaseClass("UILWSeasonVirusRankView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local RankItem = require("UI.LWSeason1.UILWSeasonVirusRank.Component.UILWSeasonVirusRankItem")
local theRanDataCache = {}
local last_active_index = 1
local last_active_toggle_1 = 1
local last_active_toggle_2 = 1
local last_active_toggle_3 = 1
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local loading_path = "PopUpTitle/Root/Content/loading"
local txt_empty_path = "PopUpTitle/Root/Content/TxtEmpty"
local tab1_path = "PopUpTitle/Root/TabLayout/Tab1"
local tab2_path = "PopUpTitle/Root/TabLayout/Tab2"
local tab3_path = "PopUpTitle/Root/TabLayout/Tab3"
local toggle1_path = "PopUpTitle/Root/Content/Tab/toggle1"
local toggle2_path = "PopUpTitle/Root/Content/Tab/toggle2"
local scroll_view_path = "PopUpTitle/Root/Content/ScrollView"
local content_path = "PopUpTitle/Root/Content/ScrollView/Viewport/Content"
local self_obj_path = "PopUpTitle/Root/Content/Item/SelfObj"
local text_title1_path = "PopUpTitle/Root/Content/BG2/TextTitle1"
local text_title2_path = "PopUpTitle/Root/Content/BG2/TextTitle2"
local text_title3_path = "PopUpTitle/Root/Content/BG2/TextTitle3"

function UILWSeasonVirusRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.tabSelect = nil
  self.rankSelect = nil
  self.text_title1:SetLocalText("challenge_zombie_rank")
  self.text_title2:SetLocalText("challenge_zombie_person")
  self.text_title3:SetLocalText("challenge_zombie_record")
  self.tab1:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnTabChanged(1)
    end
  end)
  self.tab2:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnTabChanged(2)
    end
  end)
  self.tab3:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnTabChanged(3)
    end
  end)
  self.toggle1:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnRankTypeChanged(1)
    end
  end)
  self.toggle2:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnRankTypeChanged(0)
    end
  end)
  if last_active_index == 1 then
    self.rankSelect = last_active_toggle_1
    self.tab1:SetIsOn(true)
  elseif last_active_index == 2 then
    self.rankSelect = last_active_toggle_2
    self.tab2:SetIsOn(true)
  elseif last_active_index == 3 then
    self.rankSelect = last_active_toggle_3
    self.tab3:SetIsOn(true)
  end
  if self.rankSelect == 0 then
    self.toggle2:SetIsOn(true)
  else
    self.toggle1:SetIsOn(true)
  end
  self.tabSelect = last_active_index
  self:UpdateData()
end

function UILWSeasonVirusRankView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonVirusRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonVirusRankListUpdate, self.OnVirusRankListUpdate)
end

function UILWSeasonVirusRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonVirusRankListUpdate, self.OnVirusRankListUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonVirusRankView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("390040")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.text_title1 = self:AddComponent(UITextMeshProUGUIEx, text_title1_path)
  self.text_title2 = self:AddComponent(UITextMeshProUGUIEx, text_title2_path)
  self.text_title3 = self:AddComponent(UITextMeshProUGUIEx, text_title3_path)
  self.txt_empty = self:AddComponent(UITextMeshProUGUIEx, txt_empty_path)
  self.txt_empty:SetLocalText("zone_mobilization_player_no_data")
  self.txt_empty:SetActive(false)
  self.loading = self:AddComponent(UIImage, loading_path)
  self.loading:SetActive(true)
  self.tab1 = self:AddComponent(UIToggle, tab1_path)
  self.tab2 = self:AddComponent(UIToggle, tab2_path)
  self.tab3 = self:AddComponent(UIToggle, tab3_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.self_obj = self:AddComponent(RankItem, self_obj_path)
  self.self_obj:SetActive(false)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetFixedItemSize(750, 136)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UILWSeasonVirusRankView:ComponentDestroy()
  self.tabSelect = nil
  self.rankSelect = nil
  self.btn_back = nil
  self.text_title1 = nil
  self.text_title2 = nil
  self.text_title3 = nil
  self.tab1 = nil
  self.tab2 = nil
  self.tab3 = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.scroll_view = nil
  self.content = nil
  self.self_obj = nil
  self.loading = nil
  self.txt_empty = nil
end

function UILWSeasonVirusRankView:OnTabChanged(tabIndex)
  if self.tabSelect == tabIndex then
    return
  end
  last_active_index = tabIndex
  self.tabSelect = tabIndex
  if tabIndex == 1 then
    self.rankSelect = last_active_toggle_1
  elseif tabIndex == 2 then
    self.rankSelect = last_active_toggle_2
  elseif tabIndex == 3 then
    self.rankSelect = last_active_toggle_3
  end
  if self.rankSelect == 1 then
    self.toggle1:SetIsOn(true)
  else
    self.toggle2:SetIsOn(true)
  end
  self:UpdateData()
end

function UILWSeasonVirusRankView:OnRankTypeChanged(rankIndex)
  if self.rankSelect == rankIndex or self.tabSelect == nil then
    return
  end
  if self.tabSelect == 1 then
    last_active_toggle_1 = rankIndex
  elseif self.tabSelect == 2 then
    last_active_toggle_2 = rankIndex
  elseif self.tabSelect == 3 then
    last_active_toggle_3 = rankIndex
  else
    return
  end
  self.rankSelect = rankIndex
  self:UpdateData()
end

function UILWSeasonVirusRankView:OnVirusRankListUpdate(data)
  if theRanDataCache == nil then
    theRanDataCache = {}
  end
  local rank_data = theRanDataCache[data.type] or {}
  rank_data[data.subtype] = data
  theRanDataCache[data.type] = rank_data
  self:UpdateData()
end

function UILWSeasonVirusRankView:GetData()
  if self.rankSelect == nil or self.tabSelect == nil then
    return nil
  end
  local sub_data
  if theRanDataCache ~= nil then
    local rank_data = theRanDataCache[self.tabSelect]
    if rank_data ~= nil then
      sub_data = rank_data[self.rankSelect]
    end
  end
  if sub_data == nil or sub_data.requestTime == nil or UITimeManager:GetInstance():GetServerTime() - sub_data.requestTime > 15000 then
    SFSNetwork.SendMessage(MsgDefines.FetchVirusRankList, self.tabSelect, self.rankSelect)
  end
  return sub_data
end

function UILWSeasonVirusRankView:UpdateData()
  local data = self:GetData()
  if data == nil then
    self:ClearScroll()
    self.loading:SetActive(true)
    self.txt_empty:SetActive(false)
    self.self_obj:SetActive(false)
    return
  end
  self.rankList = data.rankArr or {}
  self.self_obj:SetActive(true)
  self.loading:SetActive(false)
  self:ClearScroll()
  local dataCount = #self.rankList
  if 0 < dataCount then
    self.txt_empty:SetActive(false)
    self.ScrollView:SetActive(true)
    self.ScrollView:SetTotalCount(dataCount)
    self.ScrollView:RefillCells()
  else
    self.ScrollView:SetActive(false)
    self.txt_empty:SetActive(true)
  end
  self.self_obj:ReInit(self.tabSelect, data.owner or {score = 0, rank = 0}, true)
end

function UILWSeasonVirusRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = UIUtil.GetLoopListItemIndex()
  local cellItem = self.ScrollView:AddComponent(RankItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.tabSelect, self.rankList[index], false)
  end
end

function UILWSeasonVirusRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RankItem)
end

function UILWSeasonVirusRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RankItem)
end

return UILWSeasonVirusRankView
