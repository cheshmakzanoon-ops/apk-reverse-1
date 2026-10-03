local UIWorldSiegeMissileFactorySeason = BaseClass("UIWorldSiegeMissileFactorySeason", UIAsyncContainer)
local base = UIAsyncContainer
local UIWorldOccupyHistoryItem = require("UI.LWWorld.UIWorldOccupyHistory.Component.UIWorldOccupyHistoryItem")
local detail_title_path = "detailTitle"
local detail_des_title_path = "detailTitle/detailDesTitle"
local des_txt_path = "detailTitle/desTxt"
local status_path = "Status"
local status_text_path = "Status/StatusText"
local status_time_path = "Status/StatusTime"
local info_btn_path = "Status/InfoBtn"
local desc_path = "desc"
local occupy_path = "Occupy"
local occupy_btn_path = "Occupy/BtnMore"

function UIWorldSiegeMissileFactorySeason:OnCreate()
  base.OnCreate(self)
  self.occupyInfo = self:AddComponent(UIWorldOccupyHistoryItem, occupy_path)
  self.occupyBtn = self:AddComponent(UIButton, occupy_btn_path)
  self.occupyBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldOccupyHistory, {anim = true}, self.data.uuid)
  end)
  self.statusRoot = self:AddComponent(UIImage, status_path)
  self.status_text = self:AddComponent(UITextMeshProUGUIEx, status_text_path)
  self.status_time = self:AddComponent(UITextMeshProUGUIEx, status_time_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.desc:SetLocalText("season_activity_1000086_tips08")
  self.info_btn:SetOnClick(function()
    if self.info_btn then
      local param = {}
      param.type = "desc"
      param.title = ""
      param.desc = "season_activity_1000086_tips14"
      param.alignObject = self.info_btn
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
  self.detail_title = self:AddComponent(UIImage, detail_title_path)
  self.detail_des_title = self:AddComponent(UIText, detail_des_title_path)
  self.detail_des_txt = self:AddComponent(UIText, des_txt_path)
  self.detail_title:SetActive(false)
  self.detail_des_title:SetLocalText("season_alliance_government_skill_41_name")
  self.detail_des_txt:SetLocalText("season_activity_1000086_tips48")
  self.occupyInfo:SetActive(false)
end

function UIWorldSiegeMissileFactorySeason:OnDestroy()
  self.data = nil
  self.detail_btn = nil
  self.status = nil
  self.status_text = nil
  self.status_time = nil
  self.info_btn = nil
  self.desc = nil
  self.occupyBtn = nil
  self.occupyInfo = nil
  base.OnDestroy(self)
end

function UIWorldSiegeMissileFactorySeason:OnAddListener()
  self:AddUIListener(EventId.WorldAllianceCityDetail, self.OnCityDetailUpdate)
end

function UIWorldSiegeMissileFactorySeason:OnRemoveListener()
  self:RemoveUIListener(EventId.WorldAllianceCityDetail, self.OnCityDetailUpdate)
end

function UIWorldSiegeMissileFactorySeason:UpdateData()
  self:InitData(self.data)
  if self.serverData == nil or self.serverData.latestOccupy == nil then
    self.occupyInfo:SetActive(false)
  else
    self.occupyInfo:ReInit(1, self.serverData.latestOccupy)
    self.occupyInfo:SetActive(true)
  end
end

function UIWorldSiegeMissileFactorySeason:RefreshOccupyData(serverData)
  self.serverData = serverData
  if IsNull(self.gameObject) then
    return
  end
  if serverData == nil or serverData.latestOccupy == nil then
    self.occupyInfo:SetActive(false)
  else
    self.occupyInfo:ReInit(1, serverData.latestOccupy)
    self.occupyInfo:SetActive(true)
  end
end

function UIWorldSiegeMissileFactorySeason:OnInfoClick()
  if IsNull(self.gameObject) or self.data == nil then
    return
  end
  self.detail_title:SetActive(true)
  return self.activeSelf
end

function UIWorldSiegeMissileFactorySeason:OnReturnClick()
  if IsNull(self.gameObject) or self.data == nil then
    return
  end
  self.detail_title:SetActive(false)
  return self.activeSelf
end

function UIWorldSiegeMissileFactorySeason:InitData(param)
  if param == nil or IsNull(self.gameObject) then
    self.data = param
    return
  end
  local cityDetail = DataCenter.WorldPointDetailManager:GetAllianceCityData(param.cityId)
  self.data = param
  self.protectTime = nil
  self.occupyInfo:SetActive(false)
  if param.state == AllianceCityState.SERVER_TOWER_NOT_START then
    self.status_text:SetLocalText("season_activity_1000086_tips07")
    self.status_time:SetActive(false)
  elseif param.canBattle then
    if param.state == AllianceCityState.SERVER_OCCUPIED or param.state == AllianceCityState.SERVER_NEUTRAL then
      self.status_text:SetLocalText(801471)
      self.status_time:SetActive(false)
    elseif param.state == AllianceCityState.SERVER_BUILD_THRONE then
      if cityDetail and cityDetail.latestOccupy then
        self.occupyInfo:ReInit(1, cityDetail.latestOccupy)
        self.occupyInfo:SetActive(true)
        local missileFactoryProduct = cityDetail.missileFactoryProduct
        if missileFactoryProduct then
          self.productTime = toInt(missileFactoryProduct.endTime or 0)
          self.status_text:SetLocalText("season_activity_1000086_tips09")
          self.status_time:SetActive(false)
        end
      else
        self.status_text:SetLocalText(801471)
        self.status_time:SetActive(false)
        self.occupyInfo:SetActive(false)
      end
      self:UpdateModelName()
    end
  elseif param.state ~= nil then
    self.status_text:SetLocalText("season_activity_1000086_tips07")
    self.status_time:SetActive(false)
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if curTime < param.openTime then
      self.protectTime = param.openTime * 1000
    elseif curTime < param.protectTime then
      self.protectTime = param.protectTime * 1000
    elseif curTime > param.protectTime then
      if CS.CommonUtils.IsDebug() then
        Logger.Log("[Debug] \231\130\174\229\143\176\230\149\176\230\141\174\233\148\153\232\175\175")
        Logger.Log("TOWER.openTime = " .. param.openTime)
        Logger.Log("TOWER.protectTime = " .. param.protectTime)
      end
      self.protectTime = nil
      self.status_time:SetText("")
    else
      self.protectTime = nil
    end
    if LuaEntry.Player:AtHomeNow() then
      local activityServerData = DataCenter.GovernmentManager.activityServerData
      if activityServerData == nil or activityServerData.actFightStep ~= 2 then
        self.protectTime = nil
        self.status_time:SetText("")
      end
    end
    self.status_time:SetActive(toInt(self.protectTime) > 0)
  else
    self.status_text:SetLocalText("season_activity_1000086_tips07")
    self.status_time:SetActive(false)
  end
  self:Update1000MS()
end

function UIWorldSiegeMissileFactorySeason:UpdateModelName()
  if IsNull(self.gameObject) or self.data == nil then
    return
  end
  local cityId = tonumber(self.data.cityId)
  local model = SeasonUtil.GetCanonNameModel(cityId)
  if model then
    local theNameNode = model:GetComponent(typeof(CS.SuperTextMesh))
    local ownerServerId = self.data.ownerServerId
    local ownerAllianceId = self.data.allianceId
    if ownerServerId == nil or ownerServerId == 0 then
      theNameNode.color32 = Color32.New(255, 255, 255, 255)
      theNameNode.text = CS.GameEntry.Localization:GetString(self.data.name)
    else
      local sourceServerId = LuaEntry.Player:GetSourceServerId()
      if SeasonUtil.IsAlly(ownerServerId, sourceServerId, ownerAllianceId) then
        theNameNode.color32 = Color32.New(84, 196, 242, 255)
      else
        theNameNode.color32 = Color32.New(229, 39, 39, 255)
      end
      local owner = UIUtil.FormatServerAllianceName(ownerServerId, self.data.alAbbr, self.data.alName)
      theNameNode.text = owner
    end
  end
end

function UIWorldSiegeMissileFactorySeason:OnCityDetailUpdate()
  if self.data then
    self:InitData(self.data)
  end
end

function UIWorldSiegeMissileFactorySeason:Update1000MS()
  if self.protectTime and self.status_time then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.protectTime - curTime
    if 0 < remainTime then
      self.status_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.protectTime = nil
      self.status_time:SetActive(false)
    end
  elseif self.productTime and self.status_time then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.productTime - curTime
    if 0 < remainTime then
      self.status_text:SetLocalText("season_activity_1000086_tips09", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.productTime = nil
      self.status_text:SetLocalText("602026")
    end
    self.status_time:SetActive(false)
  end
end

return UIWorldSiegeMissileFactorySeason
