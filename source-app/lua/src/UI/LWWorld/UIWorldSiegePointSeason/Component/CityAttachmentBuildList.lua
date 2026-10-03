local base = UIAsyncContainer
local CityAttachmentBuildList = BaseClass("CityAttachmentBuildList", base)
local CityAttachmentBuildItem = require("UI.LWWorld.UIWorldSiegePointSeason.Component.CityAttachmentBuildItem")
local CityAttachmentBuildDetail = require("UI.LWWorld.UIWorldSiegePointSeason.Component.CityAttachmentBuildDetail")

function CityAttachmentBuildList:OnCreate()
  base.OnCreate(self)
  self.slotRoot1 = self:AddComponent(CityAttachmentBuildItem, "bg/BtnBuild1")
  self.slotRoot2 = self:AddComponent(CityAttachmentBuildItem, "bg/BtnBuild2")
  self.slotRoot3 = self:AddComponent(CityAttachmentBuildItem, "bg/BtnBuild3")
  self.infoBtn = self:AddComponent(UIButton, "info")
  self.infoBtn:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "season_builders_alliance_UI_11"
    param.alignObject = self.infoBtn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
end

function CityAttachmentBuildList:OnDestroy()
  self.infoBtn = nil
  self.data = nil
  self.cfg = nil
  self.serverData = nil
  base.OnDestroy(self)
end

function CityAttachmentBuildList:ReInit(data)
  self.data = data
  if data and self.cfg == nil then
    local cfg = DataCenter.SeasonFarmerTemplateManager:GetCityAttachmentTemplate(data.cityId)
    self.cfg = cfg
    if cfg and cfg.build_list and #cfg.build_list >= 3 then
      self.cfgData1 = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(cfg.build_list[1])
      self.cfgData2 = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(cfg.build_list[2])
      self.cfgData3 = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(cfg.build_list[3])
    end
  end
  self:UpdateData()
end

function CityAttachmentBuildList:UpdateData()
  if self.data == nil or IsNull(self.gameObject) then
    return
  end
  local cityDetail = self.serverData
  if cityDetail == nil then
    cityDetail = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.data.cityId)
  end
  self:RefreshData(cityDetail)
end

function CityAttachmentBuildList:RefreshData(data)
  self.serverData = data
  if IsNull(self.gameObject) then
    return
  end
  if data and data.attachmentList then
    for k, v in ipairs(data.attachmentList) do
      if v and v.slot then
        if v.slot == 0 then
          self.slotData1 = v
        elseif v.slot == 1 then
          self.slotData2 = v
        elseif v.slot == 2 then
          self.slotData3 = v
        end
      end
    end
  end
  self.slotHasFirst0 = true
  self.slotHasFirst1 = true
  self.slotHasFirst2 = true
  if data and data.slotFirstStatus then
    local tmp = string.split(data.slotFirstStatus, ",")
    if tmp then
      for _, v in ipairs(tmp) do
        self["slotHasFirst" .. v] = false
      end
    end
  end
  self.slotRoot1:RefreshData(1, self.data, self.cfgData1, self.slotData1, self.slotHasFirst0)
  self.slotRoot2:RefreshData(2, self.data, self.cfgData2, self.slotData2, self.slotHasFirst1)
  self.slotRoot3:RefreshData(3, self.data, self.cfgData3, self.slotData3, self.slotHasFirst2)
end

return CityAttachmentBuildList
