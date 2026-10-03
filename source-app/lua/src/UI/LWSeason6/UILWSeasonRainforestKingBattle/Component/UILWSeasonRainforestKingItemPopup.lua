local UILWSeasonRainforestKingItemPopup = BaseClass("UILWSeasonRainforestKingItemPopup", UIBaseContainer)
local base = UIBaseContainer
local arrow_top_path = "arrowTop"
local txt_title_path = "txtTitle"
local txt_name_path = "txtName"
local txt_server_path = "txtServer"
local txt_title2_path = "CityList/txtTitle2"
local city_root_path = "CityList/CityRoot"
local city1_path = "CityList/CityRoot/city1"
local txt_owner_server1_path = "CityList/CityRoot/city1/txtOwnerServer1"
local city2_path = "CityList/CityRoot/city2"
local txt_owner_server2_path = "CityList/CityRoot/city2/txtOwnerServer2"
local city3_path = "CityList/CityRoot/city3"
local txt_owner_server3_path = "CityList/CityRoot/city3/txtOwnerServer3"
local city4_path = "CityList/CityRoot/city4"
local txt_owner_server4_path = "CityList/CityRoot/city4/txtOwnerServer4"
local city5_path = "CityList/CityRoot/city5"
local txt_owner_server5_path = "CityList/CityRoot/city5/txtOwnerServer5"
local close_btn_path = "closeBtn"
local go_btn_path = "GoBtn"
local txt_go_path = "GoBtn/GoBtn/txtGo"
local no_connect_tips_path = "CityList/NoConnectTips"
local txt_title3_path = "CityList2/txtTitle3"
local city6_path = "CityList2/CityRoot/city6"
local txt_owner_server6_path = "CityList2/CityRoot/city6/txtOwnerServer6"
local city7_path = "CityList2/CityRoot/city7"
local txt_owner_server7_path = "CityList2/CityRoot/city7/txtOwnerServer7"
local city8_path = "CityList2/CityRoot/city8"
local txt_owner_server8_path = "CityList2/CityRoot/city8/txtOwnerServer8"
local city9_path = "CityList2/CityRoot/city9"
local txt_owner_server9_path = "CityList2/CityRoot/city9/txtOwnerServer9"
local city10_path = "CityList2/CityRoot/city10"
local txt_owner_server10_path = "CityList2/CityRoot/city10/txtOwnerServer10"
local mask1_path = "CityList/mask1"
local mask2_path = "CityList2/mask2"

function UILWSeasonRainforestKingItemPopup:OnCreate()
  base.OnCreate(self)
  self.no_connect_tips = self:AddComponent(UITextMeshProUGUIEx, no_connect_tips_path)
  self.arrow_top = self:AddComponent(UIImage, arrow_top_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.txt_server = self:AddComponent(UITextMeshProUGUIEx, txt_server_path)
  self.txt_title2 = self:AddComponent(UITextMeshProUGUIEx, txt_title2_path)
  self.city_root = self:AddComponent(UIBaseContainer, city_root_path)
  self.city1 = self:AddComponent(UIButton, city1_path)
  self.txt_owner_server1 = self:AddComponent(UITextMeshProUGUIEx, txt_owner_server1_path)
  self.city2 = self:AddComponent(UIButton, city2_path)
  self.txt_owner_server2 = self:AddComponent(UITextMeshProUGUIEx, txt_owner_server2_path)
  self.city3 = self:AddComponent(UIButton, city3_path)
  self.txt_owner_server3 = self:AddComponent(UITextMeshProUGUIEx, txt_owner_server3_path)
  self.city4 = self:AddComponent(UIButton, city4_path)
  self.txt_owner_server4 = self:AddComponent(UITextMeshProUGUIEx, txt_owner_server4_path)
  self.city5 = self:AddComponent(UIButton, city5_path)
  self.txt_owner_server5 = self:AddComponent(UITextMeshProUGUIEx, txt_owner_server5_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.txt_go = self:AddComponent(UITextMeshProUGUIEx, txt_go_path)
  self.go_btn:SetOnClick(function()
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.kingCityId, mySourceServerId)
    if meta then
      meta:JumpTo()
    end
  end)
  self.close_btn:SetOnClick(function()
    self:SetActive(false)
  end)
  self.txt_title3 = self:AddComponent(UITextMeshProUGUIEx, txt_title3_path)
  self.city6 = self:AddComponent(UIButton, city6_path)
  self.txt_owner_server6 = self:AddComponent(UITextMeshProUGUIEx, txt_owner_server6_path)
  self.city7 = self:AddComponent(UIButton, city7_path)
  self.txt_owner_server7 = self:AddComponent(UITextMeshProUGUIEx, txt_owner_server7_path)
  self.city8 = self:AddComponent(UIButton, city8_path)
  self.txt_owner_server8 = self:AddComponent(UITextMeshProUGUIEx, txt_owner_server8_path)
  self.city9 = self:AddComponent(UIButton, city9_path)
  self.txt_owner_server9 = self:AddComponent(UITextMeshProUGUIEx, txt_owner_server9_path)
  self.city10 = self:AddComponent(UIButton, city10_path)
  self.txt_owner_server10 = self:AddComponent(UITextMeshProUGUIEx, txt_owner_server10_path)
  self.mask1 = self:AddComponent(UIRawImage, mask1_path)
  self.mask2 = self:AddComponent(UIRawImage, mask2_path)
  self.city_list = self:AddComponent(UIImage, "CityList")
  self.city_list2 = self:AddComponent(UIImage, "CityList2")
  self.txt_title:SetLocalText("season_s6_activity_1200116_desc03")
  self.txt_title2:SetLocalText("season_s6_activity_1200116_desc04")
  self.txt_title3:SetLocalText("season_s6_activity_1200116_desc05")
end

function UILWSeasonRainforestKingItemPopup:OnDestroy()
  self.event_blocker = nil
  self.mask1 = nil
  self.mask2 = nil
  self.city_list = nil
  self.no_connect_tips = nil
  self.arrow_top = nil
  self.txt_title = nil
  self.txt_name = nil
  self.txt_server = nil
  self.txt_title2 = nil
  self.city_root = nil
  self.city1 = nil
  self.txt_owner_server1 = nil
  self.city2 = nil
  self.txt_owner_server2 = nil
  self.city3 = nil
  self.txt_owner_server3 = nil
  self.city4 = nil
  self.txt_owner_server4 = nil
  self.city5 = nil
  self.txt_owner_server5 = nil
  self.close_btn = nil
  self.go_btn = nil
  self.txt_go = nil
  self.txt_title3 = nil
  self.city6 = nil
  self.txt_owner_server6 = nil
  self.city7 = nil
  self.txt_owner_server7 = nil
  self.city8 = nil
  self.txt_owner_server8 = nil
  self.city9 = nil
  self.txt_owner_server9 = nil
  self.city10 = nil
  self.txt_owner_server10 = nil
  base.OnDestroy(self)
end

function UILWSeasonRainforestKingItemPopup:OnEnable()
  base.OnEnable(self)
end

function UILWSeasonRainforestKingItemPopup:OnDisable()
  self.item = nil
  self.mapIndex = nil
  self.kingCityId = nil
  self.cityData = nil
  base.OnDisable(self)
end

function UILWSeasonRainforestKingItemPopup:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.ShowOwner)
end

function UILWSeasonRainforestKingItemPopup:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.ShowOwner)
  base.OnRemoveListener(self)
end

function UILWSeasonRainforestKingItemPopup:ShowIt(item, mapIndex, kingCityId, attackActData, cityData)
  local x0, y0, z0 = self:GetPositionXYZ()
  local x1, y1, z1 = self.arrow_top:GetPositionXYZ()
  local x2, y2, z2 = item:GetPositionXYZ()
  self.item = item
  self.mapIndex = mapIndex
  self.kingCityId = kingCityId
  self.cityData = cityData
  self:SetActive(true)
  self:SetPositionXYZ(x0, y2 - 55 + 45, z0)
  self.arrow_top:SetPositionXYZ(x2, y2 - 58 + 45, z1)
  self.txt_go:SetLocalText("war_zone_outpost_25")
  if self.event_blocker then
    self.event_blocker:SetActive(true)
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local ownerServerId = 0
  local tmpOwnerServerId = 0
  local ownerAllianceId
  if cityData then
    ownerServerId = toInt(cityData.ownerServerId)
    tmpOwnerServerId = toInt(cityData.tmpOwnerServerId)
    ownerAllianceId = cityData.ownerAllianceId
  end
  if ownerAllianceId ~= nil and ownerAllianceId ~= "" and ownerAllianceId ~= 0 then
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(ownerAllianceId)
    if allianceInfo == nil then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, ownerAllianceId)
      self.txt_name:SetText("-")
      self.txt_server:SetText("")
    else
      self:ShowOwner(allianceInfo)
    end
  else
    self.txt_name:SetLocalText("456519")
    self.txt_server:SetText("")
  end
  if mapIndex == 1 or mapIndex == 4 or mapIndex == 6 or mapIndex == 9 then
    self.city_list:SetColorHex("#d5e9ef")
    self.txt_title2:SetColorHex("#249BC5")
    self.mask1:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/CommonS6/mjc_S6_wenli_zhenying_1.png")
    self.city_list2:SetColorHex("#deede0")
    self.txt_title3:SetColorHex("#099B4A")
    self.mask2:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/CommonS6/mjc_S6_wenli_zhenying_2.png")
  else
    self.city_list:SetColorHex("#deede0")
    self.txt_title2:SetColorHex("#099B4A")
    self.mask1:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/CommonS6/mjc_S6_wenli_zhenying_2.png")
    self.city_list2:SetColorHex("#d5e9ef")
    self.txt_title3:SetColorHex("#249BC5")
    self.mask2:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/CommonS6/mjc_S6_wenli_zhenying_1.png")
  end
  self.mask1:SetColorHex("#FFFFFF44")
  self.mask2:SetColorHex("#FFFFFF44")
  for i = 1, 10 do
    local nodeCity = self["city" .. i]
    if nodeCity then
      nodeCity:SetActive(false)
    end
  end
  local theServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.Source)
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(kingCityId, theServerId)
  if cityTemplate then
    local theCityServerId = cityTemplate:GetSourceServerId()
    local factionMgr = DataCenter.SeasonFactionWarDataManager
    local hasConnectCity = false
    local nearBy = cityTemplate.nearBy
    if nearBy then
      local dataList = {}
      local mgr = DataCenter.WorldAllianceCityDataManager
      local cityIndex = 1
      for _, cityId in ipairs(nearBy) do
        local cityInfo = mgr:GetAllianceCityDataByCityId(toInt(cityId))
        if cityInfo ~= nil and cityInfo.occupyServerId ~= 0 and cityInfo.occupyServerId ~= theCityServerId and dataList[cityInfo.occupyServerId] == nil and not factionMgr:IsInSameCampByServer(theCityServerId, cityInfo.occupyServerId) then
          local nodeCity = self["city" .. cityIndex]
          local txt_owner_server = self["txt_owner_server" .. cityIndex]
          if nodeCity and txt_owner_server then
            nodeCity:SetActive(true)
            hasConnectCity = true
            txt_owner_server:SetText("#" .. cityInfo.occupyServerId)
            dataList[cityInfo.occupyServerId] = true
            if mySourceServerId == cityInfo.occupyServerId then
              nodeCity:SetColorHex("#5fef87")
            else
              nodeCity:SetColorHex("#ffffff")
            end
          end
          cityIndex = cityIndex + 1
        end
      end
    end
    self.city5:SetActive(false)
    self.txt_owner_server5:SetText("")
    self.no_connect_tips:SetActive(not hasConnectCity)
    if nearBy then
      local cityIndex = 6
      local dataList = {}
      local mgr = DataCenter.WorldAllianceCityDataManager
      for _, cityId in ipairs(nearBy) do
        local cityInfo = mgr:GetAllianceCityDataByCityId(toInt(cityId))
        if cityInfo ~= nil and cityInfo.occupyServerId ~= 0 and cityInfo.occupyServerId ~= theCityServerId and dataList[cityInfo.occupyServerId] == nil and factionMgr:IsInSameCampByServer(theCityServerId, cityInfo.occupyServerId) then
          local nodeCity = self["city" .. cityIndex]
          local txt_owner_server = self["txt_owner_server" .. cityIndex]
          if nodeCity and txt_owner_server then
            nodeCity:SetActive(true)
            hasConnectCity = true
            txt_owner_server:SetText("#" .. cityInfo.occupyServerId)
            dataList[cityInfo.occupyServerId] = true
            if mySourceServerId == cityInfo.occupyServerId then
              nodeCity:SetColorHex("#5fef87")
            else
              nodeCity:SetColorHex("#ffffff")
            end
          end
          cityIndex = cityIndex + 1
        end
      end
      self.city10:SetActive(false)
      self.txt_owner_server10:SetText("")
      if dataList[theCityServerId] == nil then
        self.city10:SetActive(true)
        self.txt_owner_server10:SetText("#" .. theCityServerId)
        if mySourceServerId == theCityServerId then
          self.city10:SetColorHex("#5fef87")
        else
          self.city10:SetColorHex("#ffffff")
        end
      end
    end
  else
    self.city1:SetActive(false)
    self.city2:SetActive(false)
    self.city3:SetActive(false)
    self.city4:SetActive(false)
    self.city5:SetActive(false)
    self.no_connect_tips:SetActive(true)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.city_root.rectTransform)
end

function UILWSeasonRainforestKingItemPopup:ShowOwner(allianceInfo)
  if self.cityData == nil then
    return
  end
  local data = allianceInfo or DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.cityData.ownerAllianceId)
  if data == nil then
    self.txt_name:SetText("")
    self.txt_server:SetText("")
    return
  end
  self.txt_name:SetText(data.allianceName or "")
  self.txt_server:SetText(UIUtil.FormatServerAllianceName(self.cityData.ownerServerId, data.abbr))
end

function UILWSeasonRainforestKingItemPopup:SetBlocker(event_blocker)
  self.event_blocker = event_blocker
end

return UILWSeasonRainforestKingItemPopup
