local UIWorldOutpostCanonPointNormal = BaseClass("UIWorldOutpostCanonPointNormal", UIHorizontalOrVerticalLayoutGroup)
local base = UIHorizontalOrVerticalLayoutGroup
local FetchOutpostDetailInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostDetailInfoMessage")
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
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

function UIWorldOutpostCanonPointNormal:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.buff1:SetActive(false)
  self.buff2:SetActive(false)
end

function UIWorldOutpostCanonPointNormal:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldOutpostCanonPointNormal:ComponentDefine()
  self.bg = self:AddComponent(UIRawImage, bg_path)
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
end

function UIWorldOutpostCanonPointNormal:ComponentDestroy()
  self.bg = nil
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
end

function UIWorldOutpostCanonPointNormal:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostDetailInfoUpdate, self.OnOutpostDetailInfoUpdate)
end

function UIWorldOutpostCanonPointNormal:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostDetailInfoUpdate, self.OnOutpostDetailInfoUpdate)
  base.OnRemoveListener(self)
end

function UIWorldOutpostCanonPointNormal:InitData(param)
  self.param = param
  self.cityId = param.cityId
  self.serverId = param.serverId
  self.pointId = param.pointId
  self.cityMeta = param.meta
  self.outpostCityId = param.outpostCityId
  self:RefreshUI(self.param, self.serverData, self.cityMeta)
end

function UIWorldOutpostCanonPointNormal:RefreshData(serverData)
  self.serverData = serverData
  if self.param then
    self:RefreshUI(self.param, self.serverData, self.cityMeta)
  end
end

function UIWorldOutpostCanonPointNormal:OnOutpostDetailInfoUpdate()
  if self.param then
    self:RefreshUI(self.param, self.serverData, self.cityMeta)
  end
end

function UIWorldOutpostCanonPointNormal:RefreshUI(data, serverData, cityMeta)
  local serverId = data.serverId
  local pointId = data.pointId
  local cityId = data.cityId
  local outpostCityId = data.outpostCityId
  local isRuin = data.state == 0
  local inProtectMode = data.inProtectMode
  local protectTime = data.protectTime
  local battleStartTime = data.battleStartTime
  local lastTowerAttackTime = DataCenter.ZoneWarManager:GetBatteryLastFireTime(cityId, data.lastTowerAttackTime)
  local towerOwnerServerId = data.tmpOwnerServerId
  local canAttack = data.canBattle
  local now = UITimeManager:GetInstance():GetServerTime()
  if towerOwnerServerId ~= self.towerOwnerServerId then
    self:UpdateModelName(towerOwnerServerId)
    self.towerOwnerServerId = towerOwnerServerId
  end
  self.base:SetActive(not isRuin)
  self.buff1:SetActive(false)
  self.buff2:SetActive(false)
  if isRuin then
    self.desc:SetLocalText(801432)
    self.title:SetLocalText(801431)
    self.title:SetActive(true)
    self.desc:SetActive(true)
    self.bg:SetActive(true)
    self.tick_time:SetActive(false)
    self.fire_status_root:SetActive(false)
    self.other:SetActive(false)
    self.mine:SetActive(false)
  elseif inProtectMode then
    self.protectTime = protectTime
    self.desc:SetLocalText("server_output_desc_1")
    self.title:SetLocalText(801470)
    self.bg:SetActive(true)
    self.title:SetActive(true)
    self.desc:SetActive(true)
    self.tick_time:SetActive(true)
    self.fire_status_root:SetActive(false)
    self.other:SetActive(false)
    self.mine:SetActive(false)
    self:Update1000MS()
  else
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local max_battle_time = DataCenter.SeasonOutpostManager:TryGetNum("k1", 3600) * 1000
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
    local outpostCityData = FetchOutpostDetailInfo.GetDetailInfo(serverId, outpostCityId, true, false)
    local outpostOwnerServerId = -1
    if outpostCityData ~= nil then
      outpostOwnerServerId = outpostCityData.tmpOwnerServerId or outpostCityData.ownerServerId or -1
    end
    local isSameOwner = outpostOwnerServerId == towerOwnerServerId
    if towerOwnerServerId ~= 0 and not isSameOwner then
      self.fireEnable = true
    end
    if towerOwnerServerId == 0 then
      self.title:SetLocalText(801471)
      self.other:SetActive(false)
      self.mine:SetActive(false)
      self.bg:SetActive(true)
    elseif mySourceServerId == towerOwnerServerId then
      self.bg:SetActive(false)
      self.other:SetActive(false)
      self.mine:SetActive(true)
      self.mine:SetText("#" .. towerOwnerServerId)
      self.buff1:SetActive(false)
      self.buff2:SetActive(isSameOwner)
      if isSameOwner then
        local towerSpeedAdd = LuaEntry.DataConfig:TryGetNum("tower_zone_war_put_out", "k4", 25)
        self.buff_text2:SetLocalText("tower_zone_war_buff2", towerSpeedAdd)
      end
    else
      self.bg:SetActive(true)
      self.mine:SetActive(false)
      self.other:SetActive(true)
      self.other:SetText("#" .. towerOwnerServerId)
    end
    if self.fireEnable then
      self.fire_status_root:SetActive(true)
      if self.towerInfo.insideTroopCount == 0 then
        self.fireEnable = false
        self.fire_status_text:SetLocalText(801477)
      else
        self.fireEnable = true
        self.fire_status_text:SetLocalText(801476)
        self:UpdateFireTime()
      end
    else
      self.fire_status_root:SetActive(false)
    end
  end
end

function UIWorldOutpostCanonPointNormal:GetEffectText(effectId)
  local defence_buff = self.param.defence_buff
  if defence_buff ~= nil and defence_buff ~= "" then
    local defence_buff_id, defence_buff_num = string.match(defence_buff, "([^;]+)[;]([^;]+)")
    local text, describe = UIUtil.GetEffectStr(nil, defence_buff_num, effectId)
    return Localization:GetString(describe) .. "<color=#099B4A>" .. (text or "") .. "</color>"
  end
  return ""
end

function UIWorldOutpostCanonPointNormal:UpdateFireTime()
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

function UIWorldOutpostCanonPointNormal:UpdateModelName(towerOwnerServerId)
  local world = CS.SceneManager.World
  if world == nil or self.uuid == nil then
    return
  end
  local obj = world:GetObjectByUuid(self.uuid)
  if obj ~= nil and type(obj.OwnerChanged) == "function" then
    obj:OwnerChanged(towerOwnerServerId)
  end
end

function UIWorldOutpostCanonPointNormal:DoAttackFire(cityId)
  if self.param and self.param.cityId == cityId then
    self.fireTime = 2
    self.fire_status:SetLocalText(801476)
  end
end

function UIWorldOutpostCanonPointNormal:Update1000MS()
  if self.fireTime then
    self.fireTime = self.fireTime - 1
    if self.fireTime <= 0 then
      self.fireTime = nil
      self:UpdateFireTime()
    end
  elseif self.fireEnable then
    self:UpdateFireTime()
  elseif self.protectTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.protectTime - curTime
    if 0 < remainTime then
      if remainTime > OneDayTime * 365 * 1000 then
        self.tick_time:SetActive(false)
        self.protectTime = nil
      else
        self.tick_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      end
    else
      self.tick_time:SetActive(false)
      self.protectTime = nil
    end
  end
end

return UIWorldOutpostCanonPointNormal
