local UILWSeasonCityOccupyDetailView = BaseClass("UILWSeasonCityOccupyDetailView", UIBaseView)
local base = UIBaseView
local DetailItem = require("UI.LWSeason1.UILWSeasonCityOccupyDetail.Component.UILWSeasonCityOccupyDetailItem")
local item_path = "PopUpTitle/ScrollView/Viewport/Content/item"
local items_path = "PopUpTitle/ScrollView/Viewport/Content/items"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "PopUpTitle/ScrollView/Viewport/Content/TitleText"

function UILWSeasonCityOccupyDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
  self.title_text:SetLocalText("season_tips239")
  local SeasonConfig = DataCenter.SeasonDataManager:GetServerCurrentSeasonConfig()
  if SeasonConfig then
    local cityMaxNew = toInt(SeasonConfig.city_max)
    if 0 < cityMaxNew then
      self.title_text:SetLocalText("season_tips239_new")
    end
  end
end

function UILWSeasonCityOccupyDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyDetailView:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.titleBar = self:AddComponent(DetailItem, item_path)
  self.content = self:AddComponent(UIBaseContainer, items_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panel = self:AddComponent(UIButton, "panel")
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.theItem = self.titleBar.gameObject
  self.theItem:GameObjectCreatePool()
end

function UILWSeasonCityOccupyDetailView:ComponentDestroy()
  self.content:RemoveComponents(DetailItem)
  self.theItem:GameObjectRecycleAll()
  self.title_text = nil
end

function UILWSeasonCityOccupyDetailView:UpdateData()
  local goItem
  local theItem = self.titleBar
  self.content:RemoveComponents(DetailItem)
  self.theItem:GameObjectRecycleAll()
  theItem:ReInit(0, true)
  local seasonType = SeasonUtil.GetSeasonType()
  local strDetail
  if seasonType == SeasonMapType.CityStronghold then
    strDetail = LuaEntry.DataConfig:TryGetStr("season_new_s1_stronghold", "k6", "1;+1|2;+1|3;+1|4;+1|5;+1|6;+2")
  elseif seasonType == SeasonMapType.NineNation then
    strDetail = LuaEntry.DataConfig:TryGetStr("season_new_s5_stronghold", "k6", "1;+1|2;+1|3;+1|4;+1|5;+1|6;+2")
  end
  if not string.IsNullOrEmpty(strDetail) then
    local index = 1
    for item in string.gmatch(strDetail, "([^|]+)|?") do
      local title, desc = string.match(item, "([^;]+);([^;]+)")
      if title and desc then
        local theName = "item_" .. index
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = theName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(DetailItem, theName)
        theItem:ReInit(index, false, title, desc)
        index = index + 1
      end
    end
  end
end

return UILWSeasonCityOccupyDetailView
