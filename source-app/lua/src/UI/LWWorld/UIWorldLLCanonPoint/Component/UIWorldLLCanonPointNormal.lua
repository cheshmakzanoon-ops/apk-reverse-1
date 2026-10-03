local UIWorldLLCanonPointNormal = BaseClass("UIWorldLLCanonPointNormal", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local COLOR_GREEN = Color.New(0.03529411764705882, 0.6078431372549019, 0.2901960784313726, 1)
local base_path = "base"
local info_path = "base/info"
local title_path = "base/info/title"
local time_path = "base/info/time"
local mine_path = "base/info/mine"
local other_path = "base/info/other"
local buff1_path = "buff1"
local buf_title1_path = "buff1/bufTitle1"
local buff_text1_path = "buff1/buffText1"
local buff2_path = "buff2"
local buf_title2_path = "buff2/bufTitle2"
local buff_text2_path = "buff2/buffText2"
local fire_status_root_path = "fireStatus"
local fire_status_text_path = "fireStatus/fireStatusText"
local desc_path = "desc"
local speed_tip_path = "infoSpeed/SpeedTip"
local speed_num_path = "infoSpeed/SpeedNum"

function UIWorldLLCanonPointNormal:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.buff1:SetActive(false)
  self.buff2:SetActive(false)
end

function UIWorldLLCanonPointNormal:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldLLCanonPointNormal:ComponentDefine()
  self.base = self:AddComponent(UIBaseContainer, base_path)
  self.info = self:AddComponent(UIImage, info_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.tick_time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.mine = self:AddComponent(UITextMeshProUGUIEx, mine_path)
  self.other = self:AddComponent(UITextMeshProUGUIEx, other_path)
  self.buff1 = self:AddComponent(UIImage, buff1_path)
  self.buf_title1 = self:AddComponent(UITextMeshProUGUIEx, buf_title1_path)
  self.buff_text1 = self:AddComponent(UITextMeshProUGUIEx, buff_text1_path)
  self.buff2 = self:AddComponent(UIImage, buff2_path)
  self.buf_title2 = self:AddComponent(UITextMeshProUGUIEx, buf_title2_path)
  self.buff_text2 = self:AddComponent(UITextMeshProUGUIEx, buff_text2_path)
  self.fire_status_root = self:AddComponent(UIImage, fire_status_root_path)
  self.fire_status_text = self:AddComponent(UITextMeshProUGUIEx, fire_status_text_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.speed_tip = self:AddComponent(UITextMeshProUGUIEx, speed_tip_path)
  self.speed_num = self:AddComponent(UITextMeshProUGUIEx, speed_num_path)
end

function UIWorldLLCanonPointNormal:ComponentDestroy()
  self.base = nil
  self.info = nil
  self.title = nil
  self.tick_time = nil
  self.mine = nil
  self.other = nil
  self.buff1 = nil
  self.buf_title1 = nil
  self.buff_text1 = nil
  self.buff2 = nil
  self.buf_title2 = nil
  self.buff_text2 = nil
  self.fire_status_root = nil
  self.fire_status_text = nil
  self.desc = nil
  self.speed_tip = nil
  self.speed_num = nil
end

function UIWorldLLCanonPointNormal:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordGetCityDetail, self.OnLandlordDetailInfoUpdate)
  self:AddUIListener(EventId.LandlordCanonTowerFire, self.DoAttackFire)
end

function UIWorldLLCanonPointNormal:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordGetCityDetail, self.OnLandlordDetailInfoUpdate)
  self:RemoveUIListener(EventId.LandlordCanonTowerFire, self.DoAttackFire)
  base.OnRemoveListener(self)
end

function UIWorldLLCanonPointNormal:InitData(param)
  self.param = param
  self.cityId = param.cityId
  self.serverId = param.serverId
  self.pointId = param.pointId
  self.cityMeta = param.meta
  self.uuid = param.uuid
  self:RefreshUI(self.param, self.serverData, self.cityMeta)
end

function UIWorldLLCanonPointNormal:RefreshData(serverData)
  self.serverData = serverData
  if self.param then
    self:RefreshUI(self.param, self.serverData, self.cityMeta)
  end
end

function UIWorldLLCanonPointNormal:OnLandlordDetailInfoUpdate()
  if self.param then
    self:RefreshUI(self.param, self.serverData, self.cityMeta)
  end
end

function UIWorldLLCanonPointNormal:RefreshUI(data, serverData, cityMeta)
  local cityId = data.cityId
  local inProtectMode = data.inProtectMode
  local battleStartTime = data.battleStartTime
  local lastTowerAttackTime = DataCenter.ZoneWarManager:GetBatteryLastFireTime(cityId, data.lastTowerAttackTime)
  local towerOwnerCampId = data.ownerCampId
  if towerOwnerCampId ~= self.towerOwnerCampId then
    self:UpdateModelName(towerOwnerCampId)
    self.towerOwnerCampId = towerOwnerCampId
  end
  self.base:SetActive(true)
  self.buff1:SetActive(false)
  self.buff2:SetActive(false)
  self:RefreshEffectTxt()
  if inProtectMode then
    if data and data.meta then
      self.desc:SetLocalText(data.meta.desc)
    end
    self.title:SetLocalText(801470)
    self.title:SetActive(true)
    self.desc:SetActive(true)
    self.tick_time:SetActive(false)
    self.fire_status_root:SetActive(false)
    self.other:SetActive(false)
    self.mine:SetActive(false)
    self:Update1000MS()
  else
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local myCampId = DataCenter.LandlordMgr:GetMyGroup()
    local max_battle_time = LuaEntry.DataConfig:TryGetNum("wonder_zone_war_put_out", "k1", 3600) * 1000
    self.battle_end_time = battleStartTime + max_battle_time
    self.towerInfo = {lastTowerAttackTime = lastTowerAttackTime, insideTroopCount = 0}
    if serverData and serverData.assistanceList and serverData.currAssistance then
      self.towerInfo.insideTroopCount = toInt(serverData.currAssistance)
    end
    self.title:SetActive(true)
    self.desc:SetActive(false)
    self.tick_time:SetActive(false)
    self.title:SetLocalText(110236)
    self.fireEnable = false
    local isSameOwner = myCampId == towerOwnerCampId
    if towerOwnerCampId ~= 0 and not isSameOwner then
      self.fireEnable = true
    end
    if towerOwnerCampId == 0 then
      self.title:SetLocalText(801471)
      self.other:SetActive(false)
      self.mine:SetActive(false)
    elseif myCampId == towerOwnerCampId then
      self.other:SetActive(false)
      self.mine:SetActive(true)
      self.mine:SetLocalText(towerOwnerCampId == LLConst.LandLordGroup.LORD and "zonewar_landlord_limit_1076" or "zonewar_landlord_limit_1075")
      self.buff1:SetActive(false)
    else
      self.mine:SetActive(false)
      self.other:SetActive(true)
      self.other:SetLocalText(towerOwnerCampId == LLConst.LandLordGroup.LORD and "zonewar_landlord_limit_1076" or "zonewar_landlord_limit_1075")
    end
    if self.fireEnable then
      self.fire_status_root:SetActive(true)
      self.fireEnable = true
      self.fire_status_text:SetLocalText(801476)
      self:UpdateFireTime()
    else
      self.fire_status_root:SetActive(false)
    end
  end
end

function UIWorldLLCanonPointNormal:RefreshEffectTxt()
  if not self.cityMeta then
    return
  end
  local buff = self.cityMeta.buff
  self.effects = {}
  if not string.IsNullOrEmpty(buff) then
    for _, pair in ipairs(string.split(buff, "|")) do
      local idStr, valStr = string.match(pair, "(.*)[;,](.*)")
      if idStr and valStr then
        table.insert(self.effects, {
          id = tonumber(idStr),
          value = tonumber(valStr)
        })
      end
    end
  end
  local myCampId = DataCenter.LandlordMgr:GetMyGroup()
  local effectId = myCampId == LLConst.LandLordGroup.LORD and LLConst.OccupySpeedEffectId[LLConst.LandLordGroup.LORD] or LLConst.OccupySpeedEffectId[LLConst.LandLordGroup.FARMER]
  local effectNum = 0
  table.walk(self.effects, function(k, v)
    if v.id == effectId then
      effectNum = v.value
    end
  end)
  local nameStr, effectNumStr = WorkerUtil.GetEffectText(effectId, effectNum, true)
  self.speed_tip:SetText(nameStr)
  self.speed_num:SetText(effectNumStr)
  self.speed_num:SetColor(COLOR_GREEN)
end

function UIWorldLLCanonPointNormal:UpdateFireTime()
  if IsNull(self.gameObject) or self.param == nil then
    return
  end
  if self.fire_status_text == nil or self.fire_status_text.SetLocalText == nil then
    return
  end
  local left_time = DataCenter.ZoneWarManager:GetBatteryLeftFireTime(self.param.cityId, self.towerInfo.insideTroopCount)
  if left_time < 1000 then
    self.fire_status_text:SetLocalText(801476)
  else
    self.fire_status_text:SetLocalText(801475, string.format("<size=58>%ss</size>", math.floor(left_time * 0.001)))
  end
end

function UIWorldLLCanonPointNormal:UpdateModelName(towerOwnerCampId)
  local world = CS.SceneManager.World
  if world == nil or self.uuid == nil then
    return
  end
  local obj = world:GetObjectByUuid(self.uuid)
  if obj ~= nil and type(obj.OwnerChanged) == "function" then
    obj:OwnerChanged(towerOwnerCampId)
  end
end

function UIWorldLLCanonPointNormal:DoAttackFire(cityId)
  if self.param and self.param.cityId == cityId then
    self.fireTime = 2
    self.fire_status_text:SetLocalText(801476)
  end
end

function UIWorldLLCanonPointNormal:Update1000MS()
  if self.fireTime then
    self.fireTime = self.fireTime - 1
    if self.fireTime <= 0 then
      self.fireTime = nil
      self:UpdateFireTime()
    end
  elseif self.fireEnable then
    self:UpdateFireTime()
  end
end

return UIWorldLLCanonPointNormal
