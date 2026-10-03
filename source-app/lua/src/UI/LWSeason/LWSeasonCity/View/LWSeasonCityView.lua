local LWSeasonCityView = BaseClass("LWSeasonCityView", UIBaseView)
local base = UIBaseView
local LWSeasonCityItem = require("UI.LWSeason.LWSeasonCity.Component.LWSeasonCityItem")
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local alliance_center_item_path = "Root/Container/Viewport/AllianceCenterItem"
local content_path = "Root/Container/Viewport/Content"

function LWSeasonCityView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefillCells()
  DataCenter.AllianceStorageManager:CheckAllianceStorage()
  DataCenter.AllianceMineManager:RequestAllianceMineInfo(true)
end

function LWSeasonCityView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonCityView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceTechnology, self.UpdateData)
  self:AddUIListener(EventId.UpdateAllAllianceMineList, self.UpdateData)
end

function LWSeasonCityView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceTechnology, self.UpdateData)
  self:RemoveUIListener(EventId.UpdateAllAllianceMineList, self.UpdateData)
  base.OnRemoveListener(self)
end

function LWSeasonCityView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("season_alliance_UI100")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(alliance_center_item_path).gameObject
  self.theItem:GameObjectCreatePool()
end

function LWSeasonCityView:ComponentDestroy()
  self.content:RemoveComponents(LWSeasonCityItem)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
end

function LWSeasonCityView:SetOnTop()
  for i, city in ipairs(self.cityList) do
    city:UpdateData()
  end
end

function LWSeasonCityView:UpdateData()
  for i, city in ipairs(self.cityList) do
    city:UpdateData()
  end
end

function LWSeasonCityView:RefillCells()
  local cityList = {}
  local goItem, theItem
  self.content:RemoveComponents(LWSeasonCityItem)
  self.theItem:GameObjectRecycleAll()
  local dic = {}
  self.allianceFlagDic = DataCenter.AllianceMineManager:GetAllianceFlagData()
  if self.allianceFlagDic then
    for i, v in pairs(self.allianceFlagDic) do
      table.insert(dic, DataCenter.AllianceMineManager:GetAllianceMineTemplate(v.buildId))
    end
  end
  self.alCityList = DataCenter.AllianceMineManager:GetAlCenterBuildList()
  if self.alCityList then
    for i, v in ipairs(self.alCityList) do
      table.insert(dic, v)
    end
  end
  table.sort(dic, function(a, b)
    return a.order > b.order
  end)
  for i, v in ipairs(dic) do
    NameCount = NameCount + 1
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = "city_" .. NameCount
    goItem:SetActive(true)
    theItem = self.content:AddComponent(LWSeasonCityItem, goItem.name)
    theItem:SetItemShow(v)
    table.insert(cityList, theItem)
  end
  self.cityList = cityList
end

return LWSeasonCityView
