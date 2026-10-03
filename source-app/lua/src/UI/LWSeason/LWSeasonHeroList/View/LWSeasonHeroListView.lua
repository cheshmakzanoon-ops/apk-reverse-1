local LWSeasonHeroListView = BaseClass("LWSeasonHeroListView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWSeasonHeroListItem = require("UI.LWSeason.LWSeasonHeroList.Component.LWSeasonHeroListItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Content"
local btn_path = "PopUpTitle/Btn"
local btn_text_path = "PopUpTitle/Btn/BtnText"
local empty_tip_obj_path = "PopUpTitle/EmptyTipObj"

function LWSeasonHeroListView:OnCreate()
  base.OnCreate(self)
  self.panelType, self.typeParam, self.excludeHero, self.cardShowType = self:GetUserData()
  if not self.cardShowType then
    self.cardShowType = HeroListCardType.ShowHeroName
  end
  self.selectHeroUuid = nil
  self.heroList = {}
  self.listGO = {}
  self:ComponentDefine()
  self:ShowHeroList()
end

function LWSeasonHeroListView:OnDestroy()
  self:ComponentDestroy()
  self.selectHeroUuid = nil
  self.typeParam = nil
  self.panelType = nil
  base.OnDestroy(self)
end

function LWSeasonHeroListView:OnAddListener()
  base.OnAddListener(self)
end

function LWSeasonHeroListView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWSeasonHeroListView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ScrollView = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.content:Init(bindFunc1, bindFunc2, bindFunc3)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnRecruit))
  self.btn:SetActive(self.panelType == 2)
  self.emptyHeroTipObj = self:AddComponent(UIBaseContainer, empty_tip_obj_path)
end

function LWSeasonHeroListView:ComponentDestroy()
  self:ClearItemCell()
  self.listGO = {}
  self.btn_back = nil
  self.btn_text = nil
end

function LWSeasonHeroListView:ShowHeroList()
  local heroList
  if self.panelType == 1 then
    self.btn_text:SetLocalText("151020")
    self.dialog_title_text:SetLocalText("season_main_UI111")
    heroList = HeroUtils.GenerateHeroDataList(0, DataCenter.SeasonDataManager:GetHeroIdsList(), true)
  elseif self.panelType == 2 then
    self.btn_text:SetLocalText("110108")
    self.dialog_title_text:SetLocalText("151077")
    heroList = HeroUtils.GenerateHeroDataList(0, DataCenter.HeroDataManager:GetAllHeroIdList(self.excludeHero))
  else
    self.btn_text:SetLocalText("151020")
    self.dialog_title_text:SetLocalText("season_main_UI111")
    heroList = HeroUtils.GenerateHeroDataList(0, DataCenter.SeasonDataManager:GetHeroIdsList(), true)
  end
  self.heroList = heroList
  if heroList then
    local dataCount = #heroList or 0
    if 0 < dataCount then
      self.content:SetItemCount(dataCount)
    else
      self.content:SetItemCount(0)
    end
    self.emptyHeroTipObj:SetActive(dataCount <= 0)
  else
    self.emptyHeroTipObj:SetActive(true)
  end
end

function LWSeasonHeroListView:OnInitScroll(go, index)
  local item = self.ScrollView:AddComponent(LWSeasonHeroListItem, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function LWSeasonHeroListView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    local select = false
    if self.selectHeroUuid then
      select = self.selectHeroUuid == self.heroList[theIndex]
    end
    cellItem:ReInit(theIndex, self.heroList[theIndex], self.panelType, select, self.cardShowType)
  end
end

function LWSeasonHeroListView:OnDestroyScrollItem(go, index)
end

function LWSeasonHeroListView:ClearItemCell()
  self.ScrollView:SetVerticalNormalizedPosition(1)
  self.ScrollView:RemoveComponents(LWSeasonHeroListItem)
  self.content:DestroyChildNode()
end

function LWSeasonHeroListView:OnRecruit()
  if self.panelType == 1 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true}, nil, nil, nil, nil, nil)
  elseif self.panelType == 2 and self.selectHeroUuid then
    EventManager:GetInstance():Broadcast(EventId.LWHeroLevelChangeSelectHero, {
      heroUuid = self.selectHeroUuid,
      side = self.typeParam
    })
    self.ctrl.CloseSelf()
  end
end

function LWSeasonHeroListView:SelectHero(heroUuid)
  if self.panelType == 2 and self.selectHeroUuid ~= heroUuid then
    self.selectHeroUuid = heroUuid
    for key, value in pairs(self.listGO) do
      value:ResetSelect(self.selectHeroUuid)
    end
  end
end

return LWSeasonHeroListView
