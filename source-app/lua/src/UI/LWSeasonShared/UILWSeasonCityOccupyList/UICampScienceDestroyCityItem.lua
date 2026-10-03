local base = UIBaseContainer
local UICampScienceDestroyCityItem = BaseClass("UICampScienceDestroyCityItem", base)
local img_bgWhite_path = "bgWhite"
local txt_txtLevel_path = "txtLevel"
local btn_building_path = "building"
local btn_popup_path = "popup"
local img_res_icon2_path = "popup/res_icon2"
local txt_res_count_path = "popup/res_count"
local img_Status_path = "Status"
local img_icon_path = "building/icon"
local txt_attack_path = "Status/item_attack/txt_attack"
local txt_defense_path = "Status/item_defense/txt_defense"
local btn_Pos_path = "Pos"
local txt_Text_path = "Pos/Text"

function UICampScienceDestroyCityItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICampScienceDestroyCityItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampScienceDestroyCityItem:ComponentDefine()
  self.img_bgWhite = self:AddComponent(UIImage, img_bgWhite_path)
  self.txt_txtLevel = self:AddComponent(UIText, txt_txtLevel_path)
  self.btn_building = self:AddComponent(UIButton, btn_building_path)
  self.btn_popup = self:AddComponent(UIButton, btn_popup_path)
  self.img_res_icon2 = self:AddComponent(UIImage, img_res_icon2_path)
  self.txt_res_count = self:AddComponent(UIText, txt_res_count_path)
  self.img_Status = self:AddComponent(UIImage, img_Status_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_attack = self:AddComponent(UIText, txt_attack_path)
  self.txt_defense = self:AddComponent(UIText, txt_defense_path)
  self.btn_Pos = self:AddComponent(UIButton, btn_Pos_path)
  self.txt_Text = self:AddComponent(UIText, txt_Text_path)
  self.btn_popup:SetOnClick(function()
    if self.cityId then
      local productCity = {}
      table.insert(productCity, {
        cityId = self.cityId,
        serverId = self.serverId
      })
      SFSNetwork.SendMessage(MsgDefines.GetCampDestroyReward, productCity)
    end
  end)
  self.btn_Pos:SetOnClick(function()
    if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
      local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, self.serverId)
    end
  end)
end

function UICampScienceDestroyCityItem:ComponentDestroy()
  self.img_bgWhite = nil
  self.txt_txtLevel = nil
  self.btn_building = nil
  self.btn_popup = nil
  self.img_res_icon2 = nil
  self.txt_res_count = nil
  self.img_Status = nil
  self.img_icon = nil
  self.txt_attack = nil
  self.txt_defense = nil
  self.btn_Pos = nil
  self.txt_Text = nil
end

function UICampScienceDestroyCityItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetCampDestroyCityList, self.UpdateDestroyInfo)
end

function UICampScienceDestroyCityItem:OnRemoveListener()
  self:RemoveUIListener(EventId.GetCampDestroyCityList, self.UpdateDestroyInfo)
  base.OnRemoveListener(self)
end

function UICampScienceDestroyCityItem:ReInit(index, data)
  local dataConfig = data.cityDataConfig
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local cityId = toInt(dataConfig.id)
  self.index = index
  self.dataConfig = dataConfig
  self.cityPos = dataConfig.pos
  self.cityId = cityId
  self.serverId = dataConfig:GetCurServerId(mySourceServerId)
  self.txt_txtLevel:SetLocalText("300665", dataConfig.level)
  self.img_icon:SetActive(true)
  self.img_icon:LoadSprite(dataConfig:GetIconPath(false))
  local resData = dataConfig:GetCampDestroyResOutput()
  if resData == nil then
    resData = {id = 0, count = 0}
  end
  if resData.id ~= 0 then
    local groupTemplate = DataCenter.CampScienceDataManager:GetCampScienceGroupTemplate()
    self.img_res_icon2:LoadSprite(groupTemplate.camp_destroy_reward_icon)
  end
  local hasRecord = data.campProduceData ~= nil
  self.txt_Text:SetText(string.format("<color=#0C9C4A><u>X:%s,Y:%s</u></color>", dataConfig.pos.x, dataConfig.pos.y))
  self.btn_popup:SetActive(not hasRecord)
  if not hasRecord then
    self.txt_res_count:SetText(string.GetFormattedStr(resData.count))
  end
  if hasRecord then
    self.img_icon:SetColorRGBA(1, 1, 1, 0.3)
    CS.UIGray.SetGray(self.img_bgWhite.transform, true, false)
    CS.UIGray.SetGray(self.img_Status.transform, true, false)
  else
    self.img_icon:SetColorRGBA(1, 1, 1, 1)
    CS.UIGray.SetGray(self.img_bgWhite.transform, false, false)
    CS.UIGray.SetGray(self.img_Status.transform, false, false)
  end
  self:UpdateDestroyInfo()
end

function UICampScienceDestroyCityItem:UpdateDestroyInfo()
  local data = DataCenter.CampProduceDataManager:GetShowOccDestroyRecordData()
  if data and data[self.cityId] then
    local selfData = data[self.cityId]
    self.txt_attack:SetText("#" .. selfData.atkAlliance.serverId .. "[" .. selfData.atkAlliance.abbr .. "]")
    if selfData.defAlliance ~= nil then
      self.txt_defense:SetText("#" .. selfData.defAlliance.serverId .. "[" .. selfData.defAlliance.abbr .. "]")
    else
      self.txt_defense:SetText("#" .. selfData.cityServerId)
    end
  end
end

return UICampScienceDestroyCityItem
