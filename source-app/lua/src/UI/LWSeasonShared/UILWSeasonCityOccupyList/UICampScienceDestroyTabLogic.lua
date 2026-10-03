local base = UIBaseContainer
local UICampScienceDestroyTabLogic = BaseClass("UICampScienceDestroyTabLogic", base)
local UICampScienceDestroyCityItem = require("UI.LWSeasonShared.UILWSeasonCityOccupyList.UICampScienceDestroyCityItem")
local img_res_icon_path = "Content/produce/txt_produce/res_icon"
local txt_tipsSpeed_path = "Content/produce/txt_produce"
local txt_tipsCount_path = "Content/all/tipsContribute"
local sr_ScrollView_path = "Content/ScrollView"
local btn_BtnBack_path = "BottomBar/BtnBack"
local btn_BtnCollectCityRes_path = "BottomBar/BtnCollectCityRes"
local btn_BtnBankView_path = "BottomBar/BtnBankView"
local go_Empty_path = "Empty"
local go_Content_path = "Content"
local txt_UnLock_path = "Empty/txt_UnLock"
local go_Tips_path = "Tips"

function UICampScienceDestroyTabLogic:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.CampProductView)
end

function UICampScienceDestroyTabLogic:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampScienceDestroyTabLogic:ComponentDefine()
  self.img_res_icon = self:AddComponent(UIImage, img_res_icon_path)
  self.txt_tipsSpeed = self:AddComponent(UIText, txt_tipsSpeed_path)
  self.txt_tipsCount = self:AddComponent(UIText, txt_tipsCount_path)
  self.sr_ScrollView = self:AddComponent(UIScrollView, sr_ScrollView_path)
  self.btn_BtnBack = self:AddComponent(UIButton, btn_BtnBack_path)
  self.btn_BtnCollectCityRes = self:AddComponent(UIButton, btn_BtnCollectCityRes_path)
  self.btn_BtnBankView = self:AddComponent(UIButton, btn_BtnBankView_path)
  self.go_Empty = self:AddComponent(UIBaseContainer, go_Empty_path)
  self.go_Content = self:AddComponent(UIBaseContainer, go_Content_path)
  self.txt_UnLock = self:AddComponent(UITextMeshProUGUIEx, txt_UnLock_path)
  self.go_Tips = self:AddComponent(UIBaseContainer, go_Tips_path)
  self.sr_ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.sr_ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.btn_BtnBack:SetOnClick(BindCallback(self, self.ClickBack))
  self.btn_BtnCollectCityRes:SetOnClick(BindCallback(self, self.ClickBtnCollectCityRes))
  self.btn_BtnBankView:SetOnClick(BindCallback(self, self.ClickBankView))
  
  function self.txt_UnLock.unity_tmpro.onPointerClick(eventData)
    self:OnPointerClick(eventData)
  end
end

function UICampScienceDestroyTabLogic:ComponentDestroy()
  self.img_res_icon = nil
  self.txt_tipsSpeed = nil
  self.txt_tipsCount = nil
  self.sr_ScrollView = nil
  self.btn_BtnBack = nil
  self.btn_BtnCollectCityRes = nil
  self.btn_BtnBankView = nil
  self.go_Empty = nil
  self.go_Content = nil
  self.txt_UnLock = nil
  self.go_Tips = nil
end

function UICampScienceDestroyTabLogic:OnAddListener()
  self:AddUIListener(EventId.UpdateCampProduceDesRecordList, self.UpdateCampProduceDesRecordListListHandle)
  self:AddUIListener(EventId.GetCampDestroyCityList, self.GetCampDestroyCityListHandle)
end

function UICampScienceDestroyTabLogic:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateCampProduceDesRecordList, self.UpdateCampProduceDesRecordListListHandle)
  self:RemoveUIListener(EventId.GetCampDestroyCityList, self.GetCampDestroyCityListHandle)
end

function UICampScienceDestroyTabLogic:ClickBack()
  self.holder.view.ctrl:CloseSelf()
end

function UICampScienceDestroyTabLogic:ClickBtnCollectCityRes()
  local isOpen = DataCenter.CampScienceDataManager:IsOpenCampDestroy()
  if not isOpen then
    UIUtil.ShowTipsId("season_camp_science_tips_21")
    return
  end
  local productCity = {}
  for _, v in ipairs(self.serverCityDataList) do
    table.insert(productCity, {
      cityId = v.cityDataConfig.id,
      serverId = v.cityDataConfig:GetCurServerId(LuaEntry.Player:GetSourceServerId())
    })
  end
  SFSNetwork.SendMessage(MsgDefines.GetCampDestroyReward, productCity)
end

function UICampScienceDestroyTabLogic:ClickBankView()
  local isOpen = DataCenter.CampScienceDataManager:IsOpenCampDestroy()
  if not isOpen then
    UIUtil.ShowTipsId("season_camp_science_tips_21")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICampScienceDestroyRecord, {anim = true})
end

function UICampScienceDestroyTabLogic:OnPointerClick(eventData)
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

function UICampScienceDestroyTabLogic:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.sr_ScrollView:AddComponent(UICampScienceDestroyCityItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.serverCityDataList[index], self.activeTabIndex == 1)
  end
end

function UICampScienceDestroyTabLogic:OnRankItemMoveOut(itemObj, index)
  self.sr_ScrollView:RemoveComponent(itemObj.name, UICampScienceDestroyCityItem)
end

function UICampScienceDestroyTabLogic:UpdateCampProduceDesRecordListListHandle()
  self:RefreshList()
end

function UICampScienceDestroyTabLogic:GetShowDataList()
  local serverCityDataList = {}
  local campDesCityList = DataCenter.WorldAllianceCityDataManager:GetCampDestroyCityList()
  local cityMgr = DataCenter.AllianceCityTemplateManager
  local cityMeta
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  for cityId, destroyServerId in pairs(campDesCityList) do
    cityMeta = cityMgr:GetTemplate(toInt(cityId), sourceServerId)
    local resOutPut = cityMeta:GetCampDestroyResOutput()
    if resOutPut ~= nil then
      local campProduceOccList = DataCenter.CampProduceDataManager:GetUserCampDesTroyRewardRecordByCityID(cityId)
      table.insert(serverCityDataList, {
        destroyServerId = destroyServerId,
        serverId = cityMeta:GetCurServerId(sourceServerId),
        allianceId = "",
        cityDataConfig = cityMeta,
        campProduceData = campProduceOccList
      })
    end
  end
  return serverCityDataList
end

function UICampScienceDestroyTabLogic:ClearScroll()
  self.sr_ScrollView:ClearCells()
  self.sr_ScrollView:RemoveComponents(UICampScienceDestroyCityItem)
end

function UICampScienceDestroyTabLogic:ReInit()
  DataCenter.CampProduceDataManager:RepCampDestroyList()
  self:ClearScroll()
  self:RefreshList()
end

function UICampScienceDestroyTabLogic:RefreshList()
  local isOpen = DataCenter.CampScienceDataManager:IsOpenCampDestroy()
  self.go_Content:SetActive(isOpen)
  self.go_Empty:SetActive(not isOpen)
  self.go_Tips:SetActive(false)
  if not isOpen then
    return
  end
  self.serverCityDataList = self:GetShowDataList()
  self.sr_ScrollView:SetTotalCount(#self.serverCityDataList)
  self.sr_ScrollView:RefillCells()
  self.go_Tips:SetActive(#self.serverCityDataList == 0)
  local groupTemplate = DataCenter.CampScienceDataManager:GetCampScienceGroupTemplate()
  self.img_res_icon:LoadSprite(groupTemplate.camp_destroy_reward_icon)
  self:RefreshStatus()
end

function UICampScienceDestroyTabLogic:RefreshStatus()
  local speed = 0
  local canReceive = false
  for _, v in ipairs(self.serverCityDataList) do
    local resOutPut = v.cityDataConfig:GetCampDestroyResOutput()
    if resOutPut ~= nil then
      local count = checknumber(resOutPut.count)
      speed = speed + count
      if not canReceive and v.campProduceData == nil then
        canReceive = true
      end
    end
  end
  self.txt_tipsSpeed:SetText(speed)
  CS.UIGray.SetGray(self.btn_BtnCollectCityRes.transform, not canReceive, canReceive)
end

function UICampScienceDestroyTabLogic:GetCampDestroyCityListHandle()
  local destroyCity = DataCenter.CampProduceDataManager:GetShowOccDestroyRecordData()
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local allianceCount = 0
  local serverCount = 0
  local cityMgr = DataCenter.AllianceCityTemplateManager
  for cityId, info in pairs(destroyCity) do
    local cityMeta = cityMgr:GetTemplate(toInt(cityId), LuaEntry.Player:GetSourceServerId())
    local resOutPut = cityMeta:GetCampDestroyResOutput()
    if resOutPut then
      local count = checknumber(resOutPut.count)
      if allianceData ~= nil and info.atkAlliance.allianceId == allianceData.uid then
        allianceCount = allianceCount + count
      end
      if info.atkAlliance.serverId == LuaEntry.Player:GetSourceServerId() then
        serverCount = serverCount + count
      end
    end
  end
  self.txt_tipsCount:SetLocalText("season_camp_science_ui_37", serverCount, allianceCount)
end

return UICampScienceDestroyTabLogic
