local SeasonAttackCityDetailItem = BaseClass("SeasonAttackCityDetailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_white_path = "bgWhite"
local bg_red_path = "bgRed"
local bg_blue_path = "bgBlue"
local building_path = "building"
local level_path = "txtLevel"
local txt_status_path = "Status/txtStatus"
local txt_end_time_path = "Status/txtEndTime"
local text_path = "Pos/Text"
local length_path = "Pos/txtLength"
local def_path = "Battle/def"
local act_path = "Battle/act"
local pos_path = "Pos"
local city_path = "building/city"
local king_path = "building/king"
local icon_path = "building/icon"
local tooltip_path = "tooltip"
local tooltip_value_path = "tooltip/tooltip_value"
local tooltip_key_path = "tooltip/tooltip_key"
local close_btn_path = "tooltip/closeBtn"

function SeasonAttackCityDetailItem:OnCreate()
  base.OnCreate(self)
  self.bg_white = self:AddComponent(UIImage, bg_white_path)
  self.bg_red = self:AddComponent(UIImage, bg_red_path)
  self.bg_blue = self:AddComponent(UIImage, bg_blue_path)
  self.building = self:AddComponent(UIButton, building_path)
  self.city = self:AddComponent(UIBaseContainer, city_path)
  self.king = self:AddComponent(UIBaseContainer, king_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.txtLevel = self:AddComponent(UIText, level_path)
  self.txt_status = self:AddComponent(UIText, txt_status_path)
  self.txt_end_time = self:AddComponent(UIText, txt_end_time_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.txtDistance = self:AddComponent(UIText, length_path)
  self.def = self:AddComponent(UIImage, def_path)
  self.act = self:AddComponent(UIImage, act_path)
  self.pos_btn = self:AddComponent(UIButton, pos_path)
  self.pos_btn:SetOnClick(function()
    if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
      local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetCurServerId())
    end
  end)
  self.building:SetOnClick(function()
    self:ShowTips()
  end)
  self.tooltip = self:AddComponent(UICanvasGroup, tooltip_path)
  self.tooltip_value = self:AddComponent(UIText, tooltip_value_path)
  self.tooltip_key = self:AddComponent(UIText, tooltip_key_path)
  self.tooltip_close_btn = self:AddComponent(UIButton, close_btn_path)
  self.tooltip:SetActive(false)
  self.tooltip:SetAlpha(0)
  self.tooltip.transform:Rotate(0, 90, 0)
  self.tooltip_close_btn:SetOnClick(function()
    self:HideTips()
  end)
end

function SeasonAttackCityDetailItem:ShowTips()
  if self.effectId ~= nil then
    self.tooltip:SetAlpha(0)
    self.tooltip:SetActive(true)
    self.tooltip:FadeIn(0.3)
    self.tooltip.transform:DORotate(Vector3.zero, 0.2)
    self.tooltip_tick = 2
  end
end

function SeasonAttackCityDetailItem:HideTips()
  if self.effectId ~= nil then
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(self.tooltip:FadeOut(0.3))
    sequence:Join(self.tooltip.transform:DORotate(Vector3.New(0, 90, 0), 0.2))
    sequence:OnComplete(function()
      self.tooltip:SetActive(false)
    end)
    self.tooltip_tick = 0
  end
end

function SeasonAttackCityDetailItem:OnDestroy()
  self.bg_white = nil
  self.bg_red = nil
  self.bg_blue = nil
  self.building = nil
  self.txtLevel = nil
  self.txt_status = nil
  self.txt_end_time = nil
  self.txtDistance = nil
  self.text = nil
  self.def = nil
  self.act = nil
  base.OnDestroy(self)
end

function SeasonAttackCityDetailItem:OnEnable()
  base.OnEnable(self)
end

function SeasonAttackCityDetailItem:OnDisable()
  base.OnDisable(self)
end

function SeasonAttackCityDetailItem:ReInit(index, dataConfig, dataServer, openTime)
  local allianceId = LuaEntry.Player:GetAllianceUid()
  self.index = index
  self.dataConfig = dataConfig
  self.dataServer = dataServer
  self.openTime = openTime
  self.cityPos = dataConfig.pos
  self.txtLevel:SetLocalText("300665", dataConfig.level)
  self.city:SetActive(false)
  self.king:SetActive(false)
  self.icon:SetActive(true)
  self.icon:LoadSprite(dataConfig:GetIconPath(false))
  if dataServer ~= nil and dataServer.protectTime ~= nil and dataServer.protectTime > 0 then
    self.bg_white:SetActive(true)
    self.bg_red:SetActive(false)
    self.bg_blue:SetActive(false)
    self.txt_end_time:SetActive(true)
    self.txt_status:SetActive(true)
    self.txt_status:SetText("<color=#5fef87>" .. Localization:GetString("456511") .. "</color>")
    self:Update1000MS()
  elseif dataServer ~= nil and dataServer.alName ~= nil then
    self.bg_white:SetActive(true)
    self.bg_red:SetActive(false)
    self.bg_blue:SetActive(false)
    self.txt_end_time:SetActive(true)
    if dataServer.alId == allianceId then
      self.txt_status:SetActive(true)
      self.txt_status:SetLocalText("803008")
      self.txt_end_time:SetText("<color=\"white\">" .. string.GetFormattedSeparatorNum(dataConfig.force) .. "</color>")
    else
      self.txt_status:SetActive(true)
      self.txt_status:SetText("<color=#f97077>[" .. dataServer.alAbbr .. "]" .. dataServer.alName .. "</color>")
      self.txt_end_time:SetText("<color=\"white\">" .. Localization:GetString("456518") .. "</color>")
    end
  else
    self.bg_white:SetActive(true)
    self.bg_red:SetActive(false)
    self.bg_blue:SetActive(false)
    self.txt_end_time:SetActive(false)
    self.txt_status:SetActive(true)
    if self.openTime == nil then
      self.txt_status:SetLocalText("456519")
    else
      self.txt_status:SetLocalText("120105")
    end
  end
  self.def:SetActive(false)
  self.act:SetActive(false)
  local main_city_pos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  local distance = math.ceil(SceneUtils.TileDistance(self.cityPos, main_city_pos))
  self.txtDistance:SetText(distance .. Localization:GetString(GameDialogDefine.KILOMETRE))
  self.text:SetText("<u>(" .. dataConfig.pos.x .. "," .. dataConfig.pos.y .. ")</u>")
  local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
  if DeclareWarDataList ~= nil then
    for _, WarData in ipairs(DeclareWarDataList) do
      if WarData.content == tostring(dataConfig.id) then
        if WarData.aId == allianceId then
          self.bg_white:SetActive(false)
          self.bg_red:SetActive(true)
          self.bg_blue:SetActive(false)
          self.act:SetActive(true)
        elseif dataServer ~= nil and dataServer.alId == allianceId then
          self.bg_white:SetActive(false)
          self.bg_red:SetActive(false)
          self.bg_blue:SetActive(true)
          self.def:SetActive(true)
        end
        self.txt_status:SetActive(false)
        self.txt_end_time:SetText("<color=\"white\">" .. Localization:GetString("456510") .. "</color>")
        break
      end
    end
  end
  self.effectId = nil
  self.effectValue = nil
  if dataConfig.buff ~= nil and dataConfig.buff ~= "" then
    local effectId, effectValue = string.match(dataConfig.buff, "(%d+);(%d+[.]?%d+)")
    if effectId ~= nil and effectValue ~= nil then
      local buffAddNum, effectName = UIUtil.GetEffectStr(nil, effectValue, effectId)
      if buffAddNum ~= nil then
        self.tooltip_key:SetLocalText(effectName)
        self.tooltip_value:SetText(buffAddNum)
        self.effectId = effectId
        self.effectValue = effectValue
      end
    end
  end
end

function SeasonAttackCityDetailItem:Update1000MS()
  if self.openTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.openTime - curTime
    if remainTime < 0 then
      self.openTime = nil
      self.txt_status:SetLocalText("456519")
    end
  end
  local dataServer = self.dataServer
  if dataServer ~= nil and dataServer.protectTime ~= nil and 0 < dataServer.protectTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = dataServer.protectTime - curTime
    local allianceId = LuaEntry.Player:GetAllianceUid()
    if 0 < remainTime then
      self.txt_end_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      dataServer.protectTime = 0
      if dataServer ~= nil and dataServer.alName ~= nil then
        self.txt_end_time:SetActive(true)
        if dataServer.alId == allianceId then
          self.txt_status:SetActive(false)
          local msg = Localization:GetString("season_sever_intrusion_008") .. self.dataConfig.force
          self.txt_end_time:SetText("<color=\"white\">" .. msg .. "</color>")
        else
          self.txt_status:SetText("<color=#f97077>[" .. dataServer.alAbbr .. "]" .. dataServer.alName .. "</color>")
          self.txt_end_time:SetText("<color=\"white\">" .. Localization:GetString("456518") .. "</color>")
        end
      else
        self.txt_end_time:SetActive(false)
        self.txt_status:SetLocalText("456519")
      end
    end
  end
  if self.effectId ~= nil and self.tooltip_tick ~= nil and 0 < self.tooltip_tick then
    self.tooltip_tick = self.tooltip_tick - 1
    if 0 >= self.tooltip_tick then
      self:HideTips()
    end
  end
end

return SeasonAttackCityDetailItem
