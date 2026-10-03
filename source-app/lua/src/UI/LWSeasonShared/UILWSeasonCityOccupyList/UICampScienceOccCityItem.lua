local base = UIBaseContainer
local UICampScienceOccCityItem = BaseClass("UICampScienceOccCityItem", base)
local txt_txtLevel_path = "txtLevel"
local img_res_icon_path = "Status/title/res_icon"
local txt_txtStatus_path = "Status/title/txtStatus"
local btn_popup_path = "popup"
local img_res_icon2_path = "popup/res_icon2"
local txt_res_count_path = "popup/res_count"
local img_Status_path = "Status"
local img_icon_path = "building/icon"
local txt_txtCount_path = "txtCount"
local img_bgWhite_path = "bgWhite"

function UICampScienceOccCityItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICampScienceOccCityItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampScienceOccCityItem:ComponentDefine()
  self.txt_txtLevel = self:AddComponent(UIText, txt_txtLevel_path)
  self.img_res_icon = self:AddComponent(UIImage, img_res_icon_path)
  self.txt_txtStatus = self:AddComponent(UIText, txt_txtStatus_path)
  self.btn_popup = self:AddComponent(UIButton, btn_popup_path)
  self.img_res_icon2 = self:AddComponent(UIImage, img_res_icon2_path)
  self.txt_res_count = self:AddComponent(UIText, txt_res_count_path)
  self.img_Status = self:AddComponent(UIImage, img_Status_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_txtCount = self:AddComponent(UIText, txt_txtCount_path)
  self.img_bgWhite = self:AddComponent(UIImage, img_bgWhite_path)
  self.btn_popup:SetOnClick(function()
    local productCity = {}
    for _, cityId in pairs(self.data.cityIds) do
      local produceInfo = self.data.produceInfo[cityId]
      if produceInfo ~= nil then
        table.insert(productCity, {
          cityId = cityId,
          serverId = produceInfo.serverId
        })
      end
    end
    SFSNetwork.SendMessage(MsgDefines.GetCampProductReward, productCity)
  end)
end

function UICampScienceOccCityItem:ComponentDestroy()
  self.txt_txtLevel = nil
  self.img_res_icon = nil
  self.txt_txtStatus = nil
  self.btn_popup = nil
  self.img_res_icon2 = nil
  self.txt_res_count = nil
  self.img_Status = nil
  self.img_icon = nil
  self.txt_txtCount = nil
  self.img_bgWhite = nil
end

function UICampScienceOccCityItem:ReInit(index, data)
  local dataConfig = data.cityDataConfig
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local cityId = toInt(dataConfig.id)
  self.index = index
  self.dataConfig = dataConfig
  self.cityPos = dataConfig.pos
  self.cityId = cityId
  self.serverId = dataConfig:GetCurServerId(mySourceServerId)
  self.data = data
  self.txt_txtLevel:SetLocalText("300665", dataConfig.level)
  self.img_icon:SetActive(true)
  self.img_icon:LoadSprite(dataConfig:GetIconPath(false))
  local resData = dataConfig:ParseCampResOutput()
  if resData ~= nil and 0 < #resData then
    resData = resData[1]
  else
    resData = {id = 0, count = 0}
  end
  if resData.id ~= 0 then
    local icon = DataCenter.ResourceManager:GetResourceIconByType(resData.id)
    self.img_res_icon:LoadSprite(icon)
    self.img_res_icon2:LoadSprite(icon)
  end
  local leftNum = 0
  for _, v in pairs(data.produceInfo) do
    if v then
      leftNum = leftNum + v:GetLeftNum()
    end
  end
  local cityMgr = DataCenter.AllianceCityTemplateManager
  local produceCount = 0
  for _, city in ipairs(data.cityInfo) do
    if city then
      local cityMeta = cityMgr:GetTemplate(toInt(city.cityId), LuaEntry.Player:GetSourceServerId())
      local resData = cityMeta:ParseCampResOutput()
      if resData ~= nil and 0 < #resData then
        produceCount = produceCount + resData[1].count
      end
    end
  end
  self.btn_popup:SetActive(0 < leftNum * resData.count)
  if 0 < leftNum then
    self.txt_res_count:SetText(string.GetFormattedStr(leftNum * resData.count))
  end
  if data.dummyData then
    self.img_icon:SetColorRGBA(1, 1, 1, 0.3)
    CS.UIGray.SetGray(self.img_bgWhite.transform, true, false)
    CS.UIGray.SetGray(self.img_Status.transform, true, false)
    self.txt_txtStatus:SetText("+0/h")
  else
    self.img_icon:SetColorRGBA(1, 1, 1, 1)
    CS.UIGray.SetGray(self.img_bgWhite.transform, false, false)
    CS.UIGray.SetGray(self.img_Status.transform, false, false)
    self.txt_txtStatus:SetText("+" .. string.GetFormattedSeparatorNum(resData.count) .. "/h")
  end
  self.txt_txtCount:SetText("x" .. table.count(data.cityIds))
end

return UICampScienceOccCityItem
