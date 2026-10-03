local UILWSeasonOutpostMapRootS6 = BaseClass("UILWSeasonOutpostMapRootS6", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local MapItem = require("UI.LWSeason6.Outpost.UILWSeasonOutpostAttackS6.Component.UILWSeasonOutpostMapItemS6")

function UILWSeasonOutpostMapRootS6:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.bg = self:AddComponent(UIRawImage, "")
  self.area5 = self:AddComponent(MapItem, "Area5")
  self.area1 = self:AddComponent(MapItem, "Area1")
  self.area2 = self:AddComponent(MapItem, "Area2")
  self.area3 = self:AddComponent(MapItem, "Area3")
  self.area4 = self:AddComponent(MapItem, "Area4")
  self.area1:SetOnValueChanged(function(value)
    if value then
      self:OnValueChange(self.area1, self.cityList[1])
    elseif self.lastSelect == self.area1 then
      self.lastSelect = nil
      if self.parentView ~= nil then
        self.parentView:HidePopUp()
      end
    end
  end)
  self.area2:SetOnValueChanged(function(value)
    if value then
      self:OnValueChange(self.area2, self.cityList[2])
    elseif self.lastSelect == self.area2 then
      self.lastSelect = nil
      if self.parentView ~= nil then
        self.parentView:HidePopUp()
      end
    end
  end)
  self.area3:SetOnValueChanged(function(value)
    if value then
      self:OnValueChange(self.area3, self.cityList[3])
    elseif self.lastSelect == self.area3 then
      self.lastSelect = nil
      if self.parentView ~= nil then
        self.parentView:HidePopUp()
      end
    end
  end)
  self.area4:SetOnValueChanged(function(value)
    if value then
      self:OnValueChange(self.area4, self.cityList[4])
    elseif self.lastSelect == self.area4 then
      self.lastSelect = nil
      if self.parentView ~= nil then
        self.parentView:HidePopUp()
      end
    end
  end)
  self.btn:SetOnClick(function()
    if self.parentView ~= nil then
      self.parentView:HidePopUp()
      self.parentView:CleanSelect()
    end
  end)
end

function UILWSeasonOutpostMapRootS6:OnDestroy()
  self.bg = nil
  self.area5 = nil
  self.area1 = nil
  self.area2 = nil
  self.area3 = nil
  self.area4 = nil
  self.serverId = nil
  self.cityList = nil
  self.kingCityId = nil
  self.kingCityPos = nil
  self.toggleGroup = nil
  base.OnDestroy(self)
end

function UILWSeasonOutpostMapRootS6:ReInit(serverId, parent, toggleGroup)
  local _cityId, _serverId, cityList = SeasonUtil.GetOutpostId(serverId)
  local _kingCityId, _kingCityPos = SeasonUtil.GetKingCityId(serverId)
  self.serverId = serverId
  self.cityList = cityList
  self.kingCityId = _kingCityId
  self.kingCityPos = _kingCityPos
  self.toggleGroup = toggleGroup
  self.parentView = parent
end

function UILWSeasonOutpostMapRootS6:OnValueChange(area, cityId)
  self.lastSelect = area
  if self.parentView ~= nil and area ~= nil then
    local putByServerId = DataCenter.SeasonOutpostManager:GetPutInfoByCityId(cityId)
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, self.serverId)
    if cityInfo ~= nil then
      if cityInfo.destroyServerId == nil or cityInfo.destroyServerId == 0 then
        local x, y, z = area:GetPositionXYZ()
        self.parentView:ShowPopUp(x, y + 33, z, self.serverId, cityId)
      else
        UIUtil.ShowTipsId("104202")
        self.parentView:HidePopUp()
      end
    elseif putByServerId == nil or putByServerId == 0 then
      self.parentView:HidePopUp()
      local SameCamp = DataCenter.SeasonFactionWarDataManager:IsInSameCampByServer(self.serverId)
      if not SameCamp then
        UIUtil.ShowTipsId("s6_outpost_limit_18")
        return
      end
      local dataList = DataCenter.SeasonOutpostManager:CalcPutData()
      local now = UITimeManager:GetInstance():GetServerTime()
      for _, theCityData in ipairs(dataList) do
        if theCityData == nil then
        elseif now < theCityData.put_start_time then
          local remainTime = theCityData.put_start_time - now
          local msg = Localization:GetString("s6_outpost_limit_16", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
          UIUtil.ShowTips(msg)
          return
        elseif now < theCityData.put_end_time then
          if self.view and self.view.tab_item1 then
            self.view.tab_item1:SetIsOn(true)
          end
          return
        end
      end
      UIUtil.ShowTipsId("370100")
      return
    else
      local x, y, z = area:GetPositionXYZ()
      self.parentView:ShowPopUp(x, y + 33, z, self.serverId, cityId)
    end
  end
end

function UILWSeasonOutpostMapRootS6:UpdateData()
  if self.area5 == nil or self.serverId == nil or self.cityList == nil or not self:AsyncLoadDone() then
    return
  end
  if self.toggleGroup then
    self.area1:SetGroup(self.toggleGroup)
    self.area2:SetGroup(self.toggleGroup)
    self.area3:SetGroup(self.toggleGroup)
    self.area4:SetGroup(self.toggleGroup)
    self.area5:SetGroup(self.toggleGroup)
  end
  self.area1:ReInit(self.serverId, self.cityList[1], false)
  self.area2:ReInit(self.serverId, self.cityList[2], false)
  self.area3:ReInit(self.serverId, self.cityList[3], false)
  self.area4:ReInit(self.serverId, self.cityList[4], false)
  self.area5:ReInit(self.serverId, self.kingCityId, true)
end

function UILWSeasonOutpostMapRootS6:CleanSelect()
  if self.area5 == nil or self.serverId == nil or self.cityList == nil or not self:AsyncLoadDone() then
    return
  end
  self.area5:SetIsOn(false)
  self.area1:SetIsOn(false)
  self.area2:SetIsOn(false)
  self.area3:SetIsOn(false)
  self.area4:SetIsOn(false)
end

return UILWSeasonOutpostMapRootS6
