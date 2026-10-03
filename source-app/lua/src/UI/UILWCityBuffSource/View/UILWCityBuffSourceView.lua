local UILWCityBuffSourceView = BaseClass("UILWCityBuffSourceView", UIBaseView)
local base = UIBaseView
local BuffSourceItem = require("UI.UILWCityBuffSource.Component.UILWCityBuffSourceItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local item_path = "PopUpTitle/ScrollView/Viewport/Content/item"

function UILWCityBuffSourceView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function UILWCityBuffSourceView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWCityBuffSourceView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UITextMeshProUGUIEx, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_builders_alliance_tips_56")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.theItemPool = self.transform:Find(item_path).gameObject
  self.theItemPool:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UILWCityBuffSourceView:ComponentDestroy()
  self.content:RemoveComponents(BuffSourceItem)
  self.theItemPool:GameObjectRecycleAll()
  self.btn_back = nil
  self.content = nil
  self.theItemPool = nil
end

function UILWCityBuffSourceView:UpdateData()
  local param = self:GetUserData()
  self.param = param
  if param then
    local goItem, theItem
    self.content:RemoveComponents(BuffSourceItem)
    self.theItemPool:GameObjectRecycleAll()
    for k, v in pairs(param) do
      local buildId = toInt(v.buildId)
      if 0 < buildId then
        local buildData = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(buildId)
        if buildData then
          goItem = self.theItemPool:GameObjectSpawn(self.content.transform)
          goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
          goItem:SetActive(true)
          theItem = self.content:AddComponent(BuffSourceItem, goItem.name)
          theItem:ReInit(k, v, buildData)
        end
      end
    end
  end
end

return UILWCityBuffSourceView
