local UILWMummyLackSourceView = BaseClass("UILWMummyLackSourceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWResourceLackTemplate = require("DataCenter.LWResourceLack.LWResourceLackTemplate")
local LWResourceLackCell = require("UI.LWResourceLack.Res.Component.LWResourceLackCell")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local cell_path = "PopUpTitle/ScrollView/Viewport/Content/Cell"
local detail_txt_path = "PopUpTitle/Common_bg_orange2/Cell/DetailTxt"
local count_txt_path = "PopUpTitle/Common_bg_orange2/Cell/CountTxt"
local source_txt_path = "PopUpTitle/ScrollView/Viewport/Content/SourceTxt"
local icon_path = "PopUpTitle/Common_bg_orange2/Cell/icon"
local detail_txt_dark_path = "PopUpTitle/Common_bg_orange2/CellDark/DetailTxtDark"
local count_txt_dark_path = "PopUpTitle/Common_bg_orange2/CellDark/CountTxtDark"
local cell_dark_path = "PopUpTitle/Common_bg_orange2/CellDark"

function UILWMummyLackSourceView:OnCreate()
  base.OnCreate(self)
  self.data = self:GetUserData()
  self:ComponentDefine()
  self:UpdateData()
end

function UILWMummyLackSourceView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMummyLackSourceView:ComponentDefine()
  self.cell_dark = self:AddComponent(UIBaseContainer, cell_dark_path)
  self.detail_txt_dark = self:AddComponent(UITextMeshProUGUIEx, detail_txt_dark_path)
  self.count_txt_dark = self:AddComponent(UITextMeshProUGUIEx, count_txt_dark_path)
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(cell_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.detail_txt = self:AddComponent(UITextMeshProUGUIEx, detail_txt_path)
  self.count_txt = self:AddComponent(UITextMeshProUGUIEx, count_txt_path)
  self.source_txt = self:AddComponent(UITextMeshProUGUIEx, source_txt_path)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Mummy then
    self.source_txt:SetLocalText("season_s3_Mummy_tips011")
    if self.data and self.data.title then
      self.dialog_title_text:SetLocalText(self.data.title)
    else
      self.dialog_title_text:SetLocalText("season_s3_Mummy_ui_info01")
    end
  else
    self.source_txt:SetLocalText("season_s4_Mummy_ui_info_09")
    if self.data and self.data.title then
      self.dialog_title_text:SetLocalText(self.data.title)
    else
      self.dialog_title_text:SetLocalText("season_s4_Mummy_ui_info_08")
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.source_txt.transform)
end

function UILWMummyLackSourceView:ComponentDestroy()
  self.content:RemoveComponents(LWResourceLackCell)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
  self.title_txt = nil
  self.icon = nil
  self.cell_dark = nil
  self.detail_txt_dark = nil
  self.count_txt_dark = nil
end

function UILWMummyLackSourceView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResourceItemRefresh)
end

function UILWMummyLackSourceView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResourceItemRefresh)
  base.OnRemoveListener(self)
end

function UILWMummyLackSourceView:OnResourceItemRefresh()
  self:UpdateData()
end

function UILWMummyLackSourceView:UpdateData()
  local configList
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNation then
    local stateMeta = LocalController:instance():getLine(TableName.StatusTab, 704201)
    if stateMeta and not string.IsNullOrEmpty(stateMeta.icon) then
      self.icon:LoadSprite(stateMeta.icon)
      self.detail_txt:SetLocalText(stateMeta.name)
      self.count_txt:SetLocalText(stateMeta.description)
      self.detail_txt_dark:SetLocalText(stateMeta.name)
      self.count_txt_dark:SetLocalText(stateMeta.description)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.cell_dark.transform)
    configList = {
      3233,
      3234,
      3235
    }
  else
    local effectTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(EffectDefine.SEASON_MUMMY_GROUND_BUILD_EFFECT_ID)
    if effectTemplate then
      self.detail_txt:SetLocalText(effectTemplate.name)
      self.count_txt:SetLocalText(effectTemplate.desc)
      self.detail_txt_dark:SetLocalText(effectTemplate.name)
      self.count_txt_dark:SetLocalText(effectTemplate.desc)
    end
    configList = {
      2000,
      2001,
      2002
    }
  end
  local goItem, theItem
  self.content:RemoveComponents(LWResourceLackCell)
  self.theItem:GameObjectRecycleAll()
  if configList then
    for k, configId in ipairs(configList) do
      local config = LocalController:instance():getLine(TableName.LW_Res_Lack_Tips, configId)
      if config then
        local template = LWResourceLackTemplate.New()
        template:InitData(config)
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.content:AddComponent(LWResourceLackCell, goItem.name)
        theItem:ParseResourceLackTemplate(template, self.ctrl, {
          SeasonType = SeasonMapType.Mummy,
          ShowItemCount = true,
          MaxUseCount = 100
        })
      end
    end
  end
end

return UILWMummyLackSourceView
