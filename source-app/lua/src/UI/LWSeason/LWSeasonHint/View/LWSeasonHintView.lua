local LWSeasonHintView = BaseClass("LWSeasonHintView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWSeasonHintItem = require("UI.LWSeason.LWSeasonHint.Component.LWSeasonHintItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local detail1_path = "PopUpTitle/ScrollView/Viewport/Content/detail1"
local detail2_path = "PopUpTitle/ScrollView/Viewport/Content/detail2"

function LWSeasonHintView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
  self:UpdateData()
end

function LWSeasonHintView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonHintView:OnAddListener()
  base.OnAddListener(self)
end

function LWSeasonHintView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWSeasonHintView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_main_UI103")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem1 = self.transform:Find(detail1_path).gameObject
  self.theItem1:GameObjectCreatePool()
  self.theItem2 = self.transform:Find(detail2_path).gameObject
  self.theItem2:GameObjectCreatePool()
end

function LWSeasonHintView:ComponentDestroy()
  self.content:RemoveComponents(LWSeasonHintItem)
  self.theItem1:GameObjectRecycleAll()
  self.theItem2:GameObjectRecycleAll()
  self.btn_back = nil
end

function LWSeasonHintView:UpdateData()
  local line = LocalController:instance():getLine(TableName.LW_Season, self.param)
  if line and line.hint then
    local goItem, theItem
    for item in string.gmatch(line.hint, "([^|]+)|?") do
      local index, theType, img, title, desc = string.match(item, "([^;]+);([^;]+);([^;]+);([^;]+);([^;]+)")
      if index and theType and img and title and desc and (theType == "1" or theType == "2") then
        goItem = self["theItem" .. theType]:GameObjectSpawn(self.content.transform)
        goItem.name = "item_" .. index .. "_" .. theType
        goItem:SetActive(true)
        theItem = self.content:AddComponent(LWSeasonHintItem, goItem.name)
        theItem:ReInit(index, theType, img, title, desc)
      end
    end
  end
end

return LWSeasonHintView
