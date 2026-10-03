local UILWMummyLackViewS6 = BaseClass("UILWMummyLackViewS6", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWResourceLackTemplate = require("DataCenter.LWResourceLack.LWResourceLackTemplate")
local LWResourceLackCell = require("UI.LWResourceLack.Res.Component.LWResourceLackCell")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_txt_path = "PopUpTitle/Common_bg_orange2/GameObject/titleTxt"
local pro_bar_path = "PopUpTitle/Common_bg_orange2/GameObject/ProBar"
local pro_bar_text_path = "PopUpTitle/Common_bg_orange2/GameObject/ProBar/ProBarText"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local cell_path = "PopUpTitle/ScrollView/Viewport/Content/Cell"

function UILWMummyLackViewS6:OnCreate()
  base.OnCreate(self)
  self.data = self:GetUserData()
  self:ComponentDefine()
  self:UpdateData()
end

function UILWMummyLackViewS6:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMummyLackViewS6:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
  self.pro_bar = self:AddComponent(UISlider, pro_bar_path)
  self.pro_bar_text = self:AddComponent(UITextMeshProUGUIEx, pro_bar_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(cell_path).gameObject
  self.theItem:GameObjectCreatePool()
  if self.data and self.data.title then
    self.dialog_title_text:SetLocalText(self.data.title)
  else
    self.dialog_title_text:SetLocalText("season_s3_Mummy_ui_button02")
  end
end

function UILWMummyLackViewS6:ComponentDestroy()
  self.content:RemoveComponents(LWResourceLackCell)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
  self.title_txt = nil
  self.pro_bar = nil
  self.pro_bar_text = nil
end

function UILWMummyLackViewS6:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResourceItemRefresh)
end

function UILWMummyLackViewS6:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResourceItemRefresh)
  base.OnRemoveListener(self)
end

function UILWMummyLackViewS6:OnResourceItemRefresh()
  self:UpdateData()
end

function UILWMummyLackViewS6:UpdateData()
  local mummyCount = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy)
  local armyMax = toInt(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MUMMY_MAX_STOCK))
  local leftSize = armyMax - mummyCount
  if leftSize < 0 then
    leftSize = 0
  end
  self.title_txt:SetLocalText("season_s3_Mummy_ui_tittle05", leftSize)
  self.pro_bar_text:SetText(string.GetFormattedSeparatorNum(mummyCount) .. "/" .. string.GetFormattedSeparatorNum(armyMax))
  if mummyCount >= armyMax then
    self.pro_bar:SetValue(1)
  elseif armyMax == 0 or mummyCount == 0 then
    self.pro_bar:SetValue(0)
  else
    self.pro_bar:SetValue(math.max(math.min(1, mummyCount / armyMax), 0.03))
  end
  local isArabic = CommonUtil.IsArabicAutoMirrorOpen()
  local goItem, theItem
  self.content:RemoveComponents(LWResourceLackCell)
  self.theItem:GameObjectRecycleAll()
  local configList = {2004}
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
      if not isArabic then
        if theItem.title1 then
          theItem.title1:SetAlignment(CS.TMPro.TextAlignmentOptions.MidlineLeft)
        end
        if theItem.title2 then
          theItem.title2:SetAlignment(CS.TMPro.TextAlignmentOptions.MidlineLeft)
        end
      end
    end
  end
end

return UILWMummyLackViewS6
