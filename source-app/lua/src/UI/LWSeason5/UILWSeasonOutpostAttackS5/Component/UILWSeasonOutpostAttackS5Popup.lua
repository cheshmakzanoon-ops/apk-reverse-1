local UILWSeasonOutpostAttackS5Popup = BaseClass("UILWSeasonOutpostAttackS5Popup", UIBaseContainer)
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

function UILWSeasonOutpostAttackS5Popup:OnCreate()
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
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.outpostId, mySourceServerId)
    if meta then
      meta:JumpTo()
    end
  end)
  self.close_btn:SetOnClick(function()
    self:SetActive(false)
  end)
  self.city_list = self:AddComponent(UIImage, "CityList")
  self.txt_title:SetLocalText("war_zone_outpost_23")
  self.txt_title2:SetLocalText("war_zone_outpost_24")
end

function UILWSeasonOutpostAttackS5Popup:OnDestroy()
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
  base.OnDestroy(self)
end

function UILWSeasonOutpostAttackS5Popup:OnEnable()
  base.OnEnable(self)
end

function UILWSeasonOutpostAttackS5Popup:OnDisable()
  self.item = nil
  self.mapIndex = nil
  self.outpostId = nil
  self.cityData = nil
  self.event_blocker = nil
  base.OnDisable(self)
end

function UILWSeasonOutpostAttackS5Popup:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.ShowOwner)
end

function UILWSeasonOutpostAttackS5Popup:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.ShowOwner)
  base.OnRemoveListener(self)
end

function UILWSeasonOutpostAttackS5Popup:ShowIt(item, mapIndex, outpostId, attackActData, cityData)
  if cityData == nil then
    self:SetActive(false)
    return
  end
  local x0, y0, z0 = self:GetPositionXYZ()
  local x1, y1, z1 = self.arrow_top:GetPositionXYZ()
  local x2, y2, z2 = item:GetPositionXYZ()
  self.item = item
  self.mapIndex = mapIndex
  self.outpostId = outpostId
  self.cityData = cityData
  self:SetActive(true)
  self:SetPositionXYZ(x0, y2 - 55 + 5, z0)
  self.arrow_top:SetPositionXYZ(x2, y2 - 58 + 5, z1)
  self.txt_go:SetLocalText("war_zone_outpost_25")
  if self.event_blocker then
    self.event_blocker:SetActive(true)
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local ownerServerId = toInt(cityData.ownerServerId)
  local tmpOwnerServerId = toInt(cityData.tmpOwnerServerId)
  local ownerAllianceId = cityData.ownerAllianceId
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
  if mySourceServerId == ownerServerId then
    self.city_list:SetColorHex("#ffe3df")
    self.txt_title2:SetColorHex("#F53C3D")
  else
    self.city_list:SetColorHex("#F1EDEB")
    self.txt_title2:SetColorHex("#736863")
  end
  local theServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.Source)
  local defaultServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(mapIndex, ServerEnum.Source)
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(outpostId, theServerId)
  if cityTemplate then
    local hasConnectCity = false
    local nearBy = cityTemplate.nearBy
    if nearBy then
      local dataList = {}
      local mgr = DataCenter.WorldAllianceCityDataManager
      for i, cityId in ipairs(nearBy) do
        local nodeCity = self["city" .. i]
        local txt_owner_server = self["txt_owner_server" .. i]
        if nodeCity and txt_owner_server then
          local cityInfo = mgr:GetAllianceCityDataByCityId(toInt(cityId))
          if cityInfo ~= nil and cityInfo.occupyServerId ~= 0 and cityInfo.occupyServerId ~= ownerServerId and dataList[cityInfo.occupyServerId] == nil then
            nodeCity:SetActive(true)
            hasConnectCity = true
            txt_owner_server:SetText("#" .. cityInfo.occupyServerId)
            dataList[cityInfo.occupyServerId] = true
            if mySourceServerId == cityInfo.occupyServerId then
              nodeCity:SetColorHex("#5fef87")
            else
              nodeCity:SetColorHex("#ffffff")
            end
          else
            nodeCity:SetActive(false)
          end
        end
      end
      self.city5:SetActive(false)
      self.txt_owner_server5:SetText("")
      if ownerServerId ~= defaultServerId and dataList[defaultServerId] == nil then
        hasConnectCity = true
        self.city5:SetActive(true)
        self.txt_owner_server5:SetText("#" .. defaultServerId)
        if mySourceServerId == defaultServerId then
          self.city5:SetColorHex("#5fef87")
        else
          self.city5:SetColorHex("#ffffff")
        end
      end
    end
    self.no_connect_tips:SetActive(not hasConnectCity)
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

function UILWSeasonOutpostAttackS5Popup:ShowOwner(allianceInfo)
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

function UILWSeasonOutpostAttackS5Popup:SetBlocker(event_blocker)
  self.event_blocker = event_blocker
end

return UILWSeasonOutpostAttackS5Popup
