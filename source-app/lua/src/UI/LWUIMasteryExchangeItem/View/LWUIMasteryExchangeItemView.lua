local LWUIMasteryExchangeItemView = BaseClass("LWUIMasteryExchangeItemView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.skillTemp, self.mastery_id = self:GetUserData()
  self.selected = 1
  self:ComponentDefine()
  self:InitView()
  self:Refresh()
  self.toogle1:SetIsOn(true)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, "UICommonMiniPopUpTitle/titleText")
  self.title_text:SetLocalText(self.skillTemp.name)
  self.return_btn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/panel")
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.changeBtnText = self:AddComponent(UIText, "changeBtn/GoText")
  self.changeBtnText:SetLocalText("season_mastery_UI_tips_18")
  self.changeBtn = self:AddComponent(UIButton, "changeBtn")
  self.changeBtn:SetOnClick(function()
    self:OnChangeHomeBtnClick()
  end)
  self.toogle1_ui_container = self:AddComponent(UIBaseContainer, "Tab/Toggle1")
  self.toogle1_tabtext_off = self.toogle1_ui_container:AddComponent(UINewText, "tab_text")
  self.toogle1_tabtext_on = self.toogle1_ui_container:AddComponent(UINewText, "Choose/tab_2_text")
  self.toogle1 = self:AddComponent(UIToggle, "Tab/Toggle1")
  self.toogle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(1)
    end
  end)
  self.toogle2_ui_container = self:AddComponent(UIBaseContainer, "Tab/Toggle2")
  self.toogle2_tabtext_off = self.toogle2_ui_container:AddComponent(UINewText, "tab_text")
  self.toogle2_tabtext_on = self.toogle2_ui_container:AddComponent(UINewText, "Choose/tab_2_text")
  self.toogle2 = self:AddComponent(UIToggle, "Tab/Toggle2")
  self.toogle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(2)
    end
  end)
  self.srcItemIcon = self:AddComponent(UIImage, "SrcItem/bg/srcItemIcon")
  self.srcNameTxt = self:AddComponent(UITextMeshProUGUIEx, "SrcItem/srcNameTxt")
  self.srcItemNameTxt = self:AddComponent(UITextMeshProUGUIEx, "SrcItem/srcItemNameTxt")
  self.srcItemCountTxt = self:AddComponent(UITextMeshProUGUIEx, "SrcItem/srcItemCountTxt")
  self.desstItemIcon = self:AddComponent(UIImage, "DestItem/bg/destItemIcon")
  self.desstNameTxt = self:AddComponent(UITextMeshProUGUIEx, "DestItem/destNameTxt")
  self.desstItemNameTxt = self:AddComponent(UITextMeshProUGUIEx, "DestItem/destItemNameTxt")
  self.desstItemCountTxt = self:AddComponent(UITextMeshProUGUIEx, "DestItem/destItemCountTxt")
  self.tipsText = self:AddComponent(UITextMeshProUGUIEx, "TipsText")
  self.srcNameTxt:SetLocalText("100040")
  self.desstNameTxt:SetLocalText("130067")
  self.tipsText:SetLocalText("season_mastery_UI_tips_17")
end

local function ComponentDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MasteryUseSkill, self.OnResOrItemUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.MasteryUseSkill, self.OnResOrItemUpdate)
  base.OnRemoveListener(self)
end

local function InitView(self)
  local template1 = DataCenter.ResourceTemplateManager:GetResourceTemplate(self.skillTemp.values[3])
  if template1 ~= nil then
    local name = Localization:GetString(template1.name)
    local tabName = Localization:GetString("season_mastery_UI_tips_10", name)
    self.toogle1_tabtext_off:SetText(tabName)
    self.toogle1_tabtext_on:SetText(tabName)
  end
  local template2 = DataCenter.ResourceTemplateManager:GetResourceTemplate(self.skillTemp.values2[3])
  if template2 ~= nil then
    local name = Localization:GetString(template2.name)
    local tabName = Localization:GetString("season_mastery_UI_tips_10", name)
    self.toogle2_tabtext_off:SetText(tabName)
    self.toogle2_tabtext_on:SetText(tabName)
  end
end

local function Refresh(self)
  local exchangeValues = {}
  if self.selected == 1 then
    exchangeValues = self.skillTemp.values
  elseif self.selected == 2 then
    exchangeValues = self.skillTemp.values2
  else
    return
  end
  local item1ID = exchangeValues[1]
  local item1Count = exchangeValues[2]
  local item2ID = exchangeValues[3]
  local item2Count = exchangeValues[4]
  self.srcItemID = item1ID
  self.srcItemCount = item1Count
  local srcTemplate = DataCenter.ResourceTemplateManager:GetResourceTemplate(item1ID)
  local destTemplate = DataCenter.ResourceTemplateManager:GetResourceTemplate(item2ID)
  self.srcItemIcon:LoadSprite(string.format(LoadPath.LWCommonPath, srcTemplate.icon))
  self.srcItemNameTxt:SetLocalText(srcTemplate.name)
  self.srcItemCountTxt:SetText(tostring(item1Count))
  self.desstItemIcon:LoadSprite(string.format(LoadPath.LWCommonPath, destTemplate.icon))
  self.desstItemNameTxt:SetLocalText(destTemplate.name)
  self.desstItemCountTxt:SetText(tostring(item2Count))
  self:OnResOrItemUpdate()
end

local function ToggleControlBorS(self, index)
  self.selected = index
  self:Refresh()
end

local function OnChangeHomeBtnClick(self)
  local tempCount = LuaEntry.Resource:GetCntByResType(self.srcItemID)
  if tempCount < self.srcItemCount then
    UIUtil.ShowTipsId("120020")
    return
  end
  if self.skillState ~= MasterySkillState.Normal then
    UIUtil.ShowTipsId("100381")
    return
  end
  if self.selected == 1 or self.selected == 2 then
    DataCenter.MasteryManager:SendUseSkillMsg(self.skillTemp, {
      selectId = self.selected
    })
  end
end

local function OnResOrItemUpdate(self)
  local tempCount = LuaEntry.Resource:GetCntByResType(self.srcItemID)
  self.skillState = DataCenter.MasteryManager:GetMasteryGroupSkillState(self.mastery_id)
  if tempCount < self.srcItemCount or self.skillState ~= MasterySkillState.Normal then
    CS.UIGray.SetGray(self.changeBtn.transform, true, true)
  else
    CS.UIGray.SetGray(self.changeBtn.transform, false, true)
  end
end

LWUIMasteryExchangeItemView.OnCreate = OnCreate
LWUIMasteryExchangeItemView.OnDestroy = OnDestroy
LWUIMasteryExchangeItemView.ComponentDefine = ComponentDefine
LWUIMasteryExchangeItemView.ComponentDestroy = ComponentDestroy
LWUIMasteryExchangeItemView.OnAddListener = OnAddListener
LWUIMasteryExchangeItemView.OnRemoveListener = OnRemoveListener
LWUIMasteryExchangeItemView.InitView = InitView
LWUIMasteryExchangeItemView.Refresh = Refresh
LWUIMasteryExchangeItemView.ToggleControlBorS = ToggleControlBorS
LWUIMasteryExchangeItemView.OnChangeHomeBtnClick = OnChangeHomeBtnClick
LWUIMasteryExchangeItemView.OnResOrItemUpdate = OnResOrItemUpdate
return LWUIMasteryExchangeItemView
