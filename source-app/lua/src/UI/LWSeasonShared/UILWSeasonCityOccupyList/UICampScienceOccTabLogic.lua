local base = UIBaseContainer
local UICampScienceOccTabLogic = BaseClass("UICampScienceOccTabLogic", base)
local UICampScienceOccCityItem = require("UI.LWSeasonShared.UILWSeasonCityOccupyList.UICampScienceOccCityItem")
local img_res_icon_path = "Content/produce/tipsSpeed/res_icon"
local txt_tipsCount_path = "Content/all/tipsContribute"
local sr_ScrollView_path = "Content/ScrollView"
local btn_BtnBack_path = "BottomBar/BtnBack"
local btn_BtnCollectCityRes_path = "BottomBar/BtnCollectCityRes"
local go_Content_path = "Content"
local go_Empty_path = "Empty"
local txt_UnLock_path = "Empty/txt_UnLock"
local txt_produce_path = "Content/produce/txt_produce"
local go_Tips_path = "Tips"

function UICampScienceOccTabLogic:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.CampProductView)
end

function UICampScienceOccTabLogic:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampScienceOccTabLogic:ComponentDefine()
  self.img_res_icon = self:AddComponent(UIImage, img_res_icon_path)
  self.txt_tipsCount = self:AddComponent(UIText, txt_tipsCount_path)
  self.sr_ScrollView = self:AddComponent(UIScrollView, sr_ScrollView_path)
  self.btn_BtnBack = self:AddComponent(UIButton, btn_BtnBack_path)
  self.btn_BtnCollectCityRes = self:AddComponent(UIButton, btn_BtnCollectCityRes_path)
  self.go_Content = self:AddComponent(UIBaseContainer, go_Content_path)
  self.go_Empty = self:AddComponent(UIBaseContainer, go_Empty_path)
  self.txt_UnLock = self:AddComponent(UITextMeshProUGUIEx, txt_UnLock_path)
  self.txt_produce = self:AddComponent(UIText, txt_produce_path)
  self.go_Tips = self:AddComponent(UIBaseContainer, go_Tips_path)
  self.sr_ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.sr_ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.btn_BtnBack:SetOnClick(BindCallback(self, self.ClickBack))
  self.btn_BtnCollectCityRes:SetOnClick(BindCallback(self, self.ClickBtnCollectCityRes))
  
  function self.txt_UnLock.unity_tmpro.onPointerClick(eventData)
    self:OnPointerClick(eventData)
  end
end

function UICampScienceOccTabLogic:ComponentDestroy()
  self.img_res_icon = nil
  self.txt_tipsCount = nil
  self.sr_ScrollView = nil
  self.btn_BtnBack = nil
  self.btn_BtnCollectCityRes = nil
  self.go_Content = nil
  self.go_Empty = nil
  self.txt_UnLock = nil
  self.txt_produce = nil
  self.go_Tips = nil
end

function UICampScienceOccTabLogic:OnAddListener()
  self:AddUIListener(EventId.UpdateCampProduceList, self.UpdateCampProduceListHandle)
  self:AddUIListener(EventId.UpdateCampProduceRewardList, self.UpdateCampProduceRewardListHandle)
end

function UICampScienceOccTabLogic:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateCampProduceList, self.UpdateCampProduceListHandle)
  self:RemoveUIListener(EventId.UpdateCampProduceRewardList, self.UpdateCampProduceRewardListHandle)
end

function UICampScienceOccTabLogic:OnPointerClick(eventData)
  if not eventData then
    return
  end
  local clickPos = eventData.position
  local linkScienceIds = self.txt_UnLock:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkScienceIds) then
    return
  end
  local link = string.split(linkScienceIds, "|")
  local campId = DataCenter.SeasonFactionWarDataManager.myCampId
  if link[campId] then
    GoToUtil.GoToCampScience(link[campId])
  end
end

function UICampScienceOccTabLogic:ClickBack()
  self.holder.view.ctrl:CloseSelf()
end

function UICampScienceOccTabLogic:ClickBtnCollectCityRes()
  local isOpen = DataCenter.CampScienceDataManager:IsOpenCampProduce()
  if not isOpen then
    UIUtil.ShowTipsId("season_camp_science_tips_21")
    return
  end
  local productCity = {}
  for _, v in ipairs(self.serverCityDataList) do
    for _, cityId in pairs(v.cityIds) do
      local product = v.produceInfo[cityId]
      if product ~= nil and product:GetLeftNum() > 0 then
        table.insert(productCity, {
          cityId = cityId,
          serverId = product.serverId
        })
      end
    end
  end
  if 0 < table.count(productCity) then
    SFSNetwork.SendMessage(MsgDefines.GetCampProductReward, productCity)
  end
end

function UICampScienceOccTabLogic:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.sr_ScrollView:AddComponent(UICampScienceOccCityItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.serverCityDataList[index])
  end
end

function UICampScienceOccTabLogic:OnRankItemMoveOut(itemObj, index)
  self.sr_ScrollView:RemoveComponent(itemObj.name, UICampScienceOccCityItem)
end

function UICampScienceOccTabLogic:ClearScroll()
  self.sr_ScrollView:ClearCells()
  self.sr_ScrollView:RemoveComponents(UICampScienceOccCityItem)
end

function UICampScienceOccTabLogic:UpdateCampProduceListHandle()
  self:RefreshList()
end

function UICampScienceOccTabLogic:UpdateCampProduceRewardListHandle()
  self:RefreshList()
end

function UICampScienceOccTabLogic:ReInit()
  self:RefreshList()
end

function UICampScienceOccTabLogic:GetCityOrStrongholdList(isCity)
  local serverCityDataList = {}
  local campOccCityList = DataCenter.WorldAllianceCityDataManager:GetCampOccCityOrStrongholdList(isCity)
  local cityMgr = DataCenter.AllianceCityTemplateManager
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local cityLevelMap = {}
  local city2Ids = {}
  for _, v in pairs(campOccCityList) do
    local cityMeta = cityMgr:GetTemplate(toInt(v.cityId), sourceServerId)
    local outPut = cityMeta:ParseCampResOutput()
    if outPut and table.count(outPut) > 0 then
      cityLevelMap[cityMeta.level] = cityLevelMap[cityMeta.level] or {}
      table.insert(cityLevelMap[cityMeta.level], v)
      city2Ids[v.cityId] = true
    end
  end
  local campProduceOccList = DataCenter.CampProduceDataManager:GetCampProduceOccList()
  local cityMeta
  for level, cityMap in pairs(cityLevelMap) do
    local cityIds = {}
    local produceInfo = {}
    local cityInfo = {}
    for _, city in pairs(cityMap) do
      table.insert(cityIds, city.cityId)
      produceInfo[city.cityId] = campProduceOccList[city.cityId]
      table.insert(cityInfo, city)
    end
    cityMeta = cityMgr:GetTemplate(toInt(cityMap[1].cityId), sourceServerId)
    if cityMeta then
      serverCityDataList[level] = {
        level = level,
        cityDataConfig = cityMeta,
        cityIds = cityIds,
        produceInfo = produceInfo,
        cityInfo = cityInfo
      }
    end
  end
  if campProduceOccList and table.count(campProduceOccList) > 0 then
    for _, v in pairs(campProduceOccList) do
      if v and 0 < toInt(v:GetLeftNum()) and not city2Ids[v.cityId] then
        local cityMeta = cityMgr:GetTemplate(toInt(v.cityId), sourceServerId)
        if cityMeta then
          local canAdd = cityMeta:IsCity() and isCity or cityMeta:IsCityStronghold() and not isCity
          if canAdd then
            local serverCity = serverCityDataList[cityMeta.level]
            if serverCity == nil then
              serverCity = {
                dummyData = true,
                level = cityMeta.level,
                cityDataConfig = cityMeta,
                cityIds = {
                  [1] = v.cityId
                },
                produceInfo = {
                  [v.cityId] = v
                },
                cityInfo = {
                  [1] = nil
                }
              }
              serverCityDataList[cityMeta.level] = serverCity
            else
              table.insert(serverCity.cityIds, v.cityId)
              serverCity.produceInfo[v.cityId] = v
              table.insert(serverCity.cityInfo, nil)
            end
          end
        end
      end
    end
  end
  local result = {}
  for _, v in pairs(serverCityDataList) do
    table.insert(result, v)
  end
  table.sort(result, function(a, b)
    return a.level < b.level
  end)
  return result
end

function UICampScienceOccTabLogic:GetShowDataList()
  local result = {}
  local cityList = self:GetCityOrStrongholdList(true)
  local strongHold = self:GetCityOrStrongholdList(false)
  for _, v in ipairs(cityList) do
    table.insert(result, v)
  end
  for _, v in ipairs(strongHold) do
    table.insert(result, v)
  end
  return result
end

function UICampScienceOccTabLogic:RefreshList()
  local isOpen = DataCenter.CampScienceDataManager:IsOpenCampProduce()
  self.go_Content:SetActive(isOpen)
  self.go_Empty:SetActive(not isOpen)
  self.go_Tips:SetActive(false)
  if not isOpen then
    return
  end
  self:ClearScroll()
  self.serverCityDataList = self:GetShowDataList()
  self.sr_ScrollView:SetTotalCount(#self.serverCityDataList)
  self.sr_ScrollView:RefillCells()
  self.go_Tips:SetActive(#self.serverCityDataList == 0)
  local groupTemplate = DataCenter.CampScienceDataManager:GetCampScienceGroupTemplate()
  self.img_res_icon:LoadSprite(groupTemplate.camp_reward_icon)
  self:RefreshStatus()
end

function UICampScienceOccTabLogic:RefreshStatus()
  local speed = 0
  local allianceCount = 0
  local serverCount = 0
  local cityMgr = DataCenter.AllianceCityTemplateManager
  local canReceive = false
  for _, cityData in ipairs(self.serverCityDataList) do
    if not cityData.dummyData then
      for _, v in ipairs(cityData.cityInfo) do
        if v ~= nil then
          local sourceServerId = LuaEntry.Player:GetSourceServerId()
          local cityDataConfig = cityMgr:GetTemplate(toInt(v.cityId), sourceServerId)
          local resOutPut = cityDataConfig:ParseCampResOutput()
          if resOutPut ~= nil and 0 < table.count(resOutPut) then
            local count = checknumber(resOutPut[1].count)
            speed = speed + count
            if cityDataConfig:GetCurServerId(sourceServerId) == sourceServerId then
              serverCount = serverCount + count
            end
            local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
            if allianceData ~= nil and v.allianceId == allianceData.uid then
              allianceCount = allianceCount + count
            end
            if not canReceive and cityData.produceInfo then
              for _, proInfo in pairs(cityData.produceInfo) do
                if 0 < proInfo:GetLeftNum() then
                  canReceive = true
                end
              end
            end
          end
        end
      end
    elseif not canReceive and cityData.produceInfo then
      for _, proInfo in pairs(cityData.produceInfo) do
        if 0 < proInfo:GetLeftNum() then
          canReceive = true
        end
      end
    end
  end
  self.txt_produce:SetLocalText("season_camp_science_ui_38", speed)
  self.txt_tipsCount:SetLocalText("season_camp_science_ui_34", serverCount, allianceCount)
  CS.UIGray.SetGray(self.btn_BtnCollectCityRes.transform, not canReceive, canReceive)
end

return UICampScienceOccTabLogic
