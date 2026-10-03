local p_comp_manual_sticker_path = "p_comp_manual_sticker"
local p_comp_auto_sticker_path = "p_comp_auto_sticker"
local p_tab_sticker_path = "p_tab_sticker"
local p_comp_icons_sticker_path = "p_comp_icons_sticker"
local p_btn_sticker_info_close_path = "p_btn_sticker_info_close"
local p_go_sticker_info_path = "p_btn_sticker_info_close/p_go_sticker_info"
local p_text_sticker_info_tips_path = "p_btn_sticker_info_close/p_go_sticker_info/p_text_sticker_info_tips"
local UIDecorationStickersManualComp = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Manual.UIDecorationStickersManualComp")
local UIDecorationStickersAutoComp = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Auto.UIDecorationStickersAutoComp")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local UIDecorationStickerIcons = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Icons.UIDecorationStickerIcons")
local UIDecorationStickersNew = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationStickersNew")
local base = UIBaseContainer
local UIDecorationStickersContent = BaseClass("UIDecorationStickersContent", UIBaseContainer)

function UIDecorationStickersContent:ComponentDefine()
  self.p_comp_manual_sticker = self:AddComponent(UIDecorationStickersManualComp, p_comp_manual_sticker_path)
  self.p_comp_auto_sticker = self:AddComponent(UIDecorationStickersAutoComp, p_comp_auto_sticker_path)
  self.p_tab_sticker = self:AddComponent(UICommonToggleListComponent, p_tab_sticker_path)
  self.p_comp_icons_sticker = self:AddComponent(UIDecorationStickerIcons, p_comp_icons_sticker_path)
  self.p_btn_sticker_info_close = self:AddComponent(UIButton, p_btn_sticker_info_close_path)
  self.p_btn_sticker_info_close:SetOnClick(BindCallback(self, self.OnInfoCloseClicked))
  self.p_go_sticker_info = self:AddComponent(UIImage, p_go_sticker_info_path)
  self.p_text_sticker_info_tips = self:AddComponent(UITextMeshProUGUIEx, p_text_sticker_info_tips_path)
end

function UIDecorationStickersContent:ComponentDestroy()
  self.p_comp_manual_sticker = nil
  self.p_comp_auto_sticker = nil
  self.p_tab_sticker = nil
  self.p_comp_icons_sticker = nil
  self.p_btn_sticker_info_close = nil
  self.p_go_sticker_info = nil
  self.p_text_sticker_info_tips = nil
end

function UIDecorationStickersContent:DataDefine()
  self.Tab = {
    Manual = 1,
    Auto = 2,
    Special = 3
  }
end

function UIDecorationStickersContent:DataDestroy()
end

function UIDecorationStickersContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationStickersContent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  DataCenter.LWSticker3DManager:SendSetAutoSticker()
  base.OnDestroy(self)
end

function UIDecorationStickersContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationStickerAutoStickerTryClose, self.OnAutoStickerTryClose)
  self:AddUIListener(EventId.DecorationStickerAutoStickerGroupInfo, self.OnAutoStickerGroupInfo)
end

function UIDecorationStickersContent:OnRemoveListener()
  self:RemoveUIListener(EventId.DecorationStickerAutoStickerTryClose, self.OnAutoStickerTryClose)
  self:RemoveUIListener(EventId.DecorationStickerAutoStickerGroupInfo, self.OnAutoStickerGroupInfo)
  base.OnRemoveListener(self)
end

function UIDecorationStickersContent:SetData(dataList)
end

function UIDecorationStickersContent:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UIDecorationStickersContent:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UIDecorationStickersContent:InitUi()
  self.p_btn_sticker_info_close:SetActive(false)
  self.CurTab = -1
  self:InitToggle(self.Data.DefaultSubTab)
end

function UIDecorationStickersContent:InitToggle(defaultIndex)
  local tabDataList = self.view.ctrl:GetStickerTabData()
  if table.count(tabDataList) > 1 then
    local tabs = {}
    for _, tab in pairs(tabDataList) do
      local tabData = {}
      tabData.name = CS.GameEntry.Localization:GetString(tab.name)
      table.insert(tabs, tabData)
    end
    local toggleListData = {}
    toggleListData.itemsDataList = tabs
    toggleListData.defaultSelectIndex = defaultIndex
    
    function toggleListData.onItemSelect(index, itemData)
      self:OnToggled(index, itemData)
    end
    
    self.p_tab_sticker:ReInit(toggleListData)
  else
    self:OnToggled(defaultIndex, tabDataList[defaultIndex])
  end
end

function UIDecorationStickersContent:OnToggled(index, itemData)
  if self.CurTab == index then
    return
  end
  self.p_comp_manual_sticker:SetActive(false)
  self.p_comp_auto_sticker:SetActive(false)
  self.CurTab = index
  if self.CurTab == self.Tab.Manual then
    self.p_comp_manual_sticker:SetActive(true)
    local data = {}
    data.Tab = self.Tab.Manual
    self.p_comp_manual_sticker:ReInit(data)
  elseif self.CurTab == self.Tab.Auto then
    self.p_comp_auto_sticker:SetActive(true)
    local data = {}
    data.Tab = self.Tab.Auto
    self.p_comp_auto_sticker:ReInit(data)
  elseif self.CurTab == self.Tab.Special then
    self.p_comp_auto_sticker:SetActive(true)
    local data = {}
    data.Tab = self.Tab.Special
    self.p_comp_auto_sticker:ReInit(data)
  end
end

function UIDecorationStickersContent:RefreshIcons(hide)
  if hide then
    self.p_comp_icons_sticker:SetActive(false)
  else
    self.p_comp_icons_sticker:SetActive(true)
    local currentSelectType, currentSelectDecoration, allTypes, allDecorations = self.view.ctrl:GetPanelData(DecorationType.DecorationType_Emoji, nil)
    currentSelectDecoration = self:GetSelectStickerDecorationId(allDecorations)
    self.p_comp_icons_sticker:SetData(allDecorations, currentSelectDecoration, self.CurTab)
  end
end

function UIDecorationStickersContent:GetSelectStickerDecorationId(allDecorations)
  if self.CurTab == self.Tab.Manual then
    return self.p_comp_manual_sticker:GetSelectStickerDecorationId(allDecorations)
  elseif self.CurTab == self.Tab.Auto then
    return self.p_comp_auto_sticker:GetSelectStickerDecorationId(allDecorations)
  elseif self.CurTab == self.Tab.Special then
    return self.p_comp_auto_sticker:GetSelectStickerDecorationId(allDecorations)
  end
end

function UIDecorationStickersContent:OnAutoStickerTryClose(userData)
  if (self.CurTab == self.Tab.Auto or self.CurTab == self.Tab.Special) and self.p_comp_auto_sticker:TryBack() then
    userData.isUse = true
  end
end

function UIDecorationStickersContent:OnAutoStickerGroupInfo(evtData)
  if IsNotNull(evtData) then
    self.p_btn_sticker_info_close:SetActive(true)
    self.p_text_sticker_info_tips:SetText(evtData.Desc)
    self.p_go_sticker_info:SetPosition(evtData.TargetPos - Vector3.New(28 * CommonUtil.ArabicAutoMirrorFactor(), 0, 0))
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.p_go_sticker_info.transform)
  end
end

function UIDecorationStickersContent:OnInfoCloseClicked()
  self.p_btn_sticker_info_close:SetActive(false)
end

return UIDecorationStickersContent
