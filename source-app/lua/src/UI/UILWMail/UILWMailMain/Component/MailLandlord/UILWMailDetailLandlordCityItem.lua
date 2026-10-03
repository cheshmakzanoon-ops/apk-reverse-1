local base = UIBaseContainer
local UILWMailDetailLandlordCityItem = BaseClass("UILWMailDetailLandlordCityItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWMailDetailLandlordCityItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailLandlordCityItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailLandlordCityItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgCityIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textCityName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textCityNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function UILWMailDetailLandlordCityItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgCityIcon = nil
  self.textCityName = nil
  self.textCityNum = nil
end

function UILWMailDetailLandlordCityItem:DataDefine()
end

function UILWMailDetailLandlordCityItem:DataDestroy()
end

function UILWMailDetailLandlordCityItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailLandlordCityItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailLandlordCityItem:ReInit(data)
  local cityId = data.cityId
  local num = data.num
  self.textCityNum:SetText(string.format("\195\151%d", num))
  local tableName = DataCenter.LandlordMgr:GetCityTemplateTableName()
  if string.IsNullOrEmpty(tableName) then
    tableName = "zonewar_landlord_city_s5"
  end
  local cityTemplate = LocalController:instance():getLine(tableName, cityId)
  if cityTemplate then
    self.imgCityIcon:LoadSpriteAsyncWithCallback(cityTemplate.city_rally_icon, function()
      if self.imgCityIcon then
        self.imgCityIcon:SetNativeSize()
      end
    end)
    local subType = toInt(cityTemplate.sub_type)
    local cityTypeTableName = DataCenter.LandlordMgr:GetCityTypeTemplateTableName()
    local name = GetTableData(cityTypeTableName, subType, "name")
    self.textCityName:SetLocalText(name)
  end
end

return UILWMailDetailLandlordCityItem
