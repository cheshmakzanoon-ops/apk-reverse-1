local Season5DeclareCityListItem = BaseClass("Season5DeclareCityListItem", UIBaseContainer)
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
local protect_path = "building/protect"
local protect_time_path = "building/protect/protectTime"
local season_reward_icon_path = "season_reward_icon"
local reward_count_path = "season_reward_icon/reward_count"

function Season5DeclareCityListItem:OnCreate()
  base.OnCreate(self)
  self.bg_white = self:AddComponent(UIImage, bg_white_path)
  self.bg_red = self:AddComponent(UIImage, bg_red_path)
  self.bg_blue = self:AddComponent(UIImage, bg_blue_path)
  self.building = self:AddComponent(UIButton, building_path)
  self.protect = self:AddComponent(UIImage, protect_path)
  self.protect_time = self:AddComponent(UIText, protect_time_path)
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
      local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(self.curServerId)
      if self.curServerId == LuaEntry.Player:GetSelfServerId() or isBigMapMode and loginSameGroup then
        GoToUtil.MoveToWorldPointAndOpen(self.data.cfg:GetPointId(), nil, nil, self.curServerId, 0)
      else
        math.randomseed(SafeLocalOsTime())
        local tilePos = self.cityPos
        local x = math.random(tilePos.x - 7, tilePos.x + 7)
        local y = math.random(tilePos.y - 7, tilePos.y + 7)
        if x >= WorldTileCount or y >= WorldTileCount or x <= 0 or y <= 0 then
          CrossServerUtil.JumpToServerByServerId(self.curServerId, MoveCrossServerType.SeasonBattleDesert, self.data.cfg:GetPointId(), SeasonCrossCameraHeight)
        else
          local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
          CrossServerUtil.JumpToServerByServerId(self.curServerId, MoveCrossServerType.SeasonBattleDesert, pointId, SeasonCrossCameraHeight)
        end
      end
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
  self.season_reward_icon = self:AddComponent(UIButton, season_reward_icon_path)
  self.reward_count = self:AddComponent(UIText, reward_count_path)
  self.season_reward_icon:SetActive(false)
end

function Season5DeclareCityListItem:ShowTips()
  if self.effectId ~= nil then
    self.tooltip:SetAlpha(0)
    self.tooltip:SetActive(true)
    self.tooltip:FadeIn(0.3)
    self.tooltip.transform:DORotate(Vector3.zero, 0.2)
    self.tooltip_tick = 2
  end
end

function Season5DeclareCityListItem:HideTips()
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

function Season5DeclareCityListItem:OnDestroy()
  self.season_reward_icon:SetActive(false)
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

function Season5DeclareCityListItem:ReInit(index, data, curServerId)
  local allianceId = LuaEntry.Player:GetAllianceUid()
  local dataConfig = data.cfg
  self.index = index
  self.data = data
  self.curServerId = curServerId
  if curServerId == nil or curServerId == 0 then
    self.curServerId = data.serverId
  end
  self.cityPos = dataConfig.pos
  self.season_reward_icon:SetActive(data.firstReward == true and dataConfig.sever_loot_reward and dataConfig.sever_loot_reward ~= 0)
  self.reward_count:SetText("x" .. dataConfig.sever_loot_reward)
  self.txtLevel:SetLocalText("300665", dataConfig.level)
  self.city:SetActive(false)
  self.king:SetActive(false)
  self.icon:SetActive(true)
  self.icon:LoadSprite(dataConfig:GetIconPath(false))
  self.ShieldTime = nil
  if curServerId == 0 then
    self.protect:SetActive(false)
    self.bg_white:SetActive(true)
    self.bg_red:SetActive(false)
    self.bg_blue:SetActive(false)
    self.txt_end_time:SetActive(true)
    if data.beDeclare then
      self.txt_status:SetActive(false)
      self.txt_end_time:SetText("<color=\"white\">" .. Localization:GetString("456510") .. "</color>")
    else
      self.txt_status:SetActive(true)
      self.txt_status:SetLocalText("803008")
      self.txt_end_time:SetText("<color=\"white\">" .. string.GetFormattedSeparatorNum(dataConfig.force) .. "</color>")
    end
    self.ShieldTime = nil
  else
    if data ~= nil then
      local openTime = checknumber(data.openTime)
      local protectTime = checknumber(data.protectTime)
      if 0 < openTime or 0 < protectTime then
        self.protect:SetActive(true)
        self.bg_white:SetActive(true)
        self.bg_red:SetActive(false)
        self.bg_blue:SetActive(false)
        self.ShieldTime = math.max(openTime, protectTime)
        self:Update1000MS()
      else
        self.ShieldTime = nil
        self.protect:SetActive(false)
      end
    end
    if data ~= nil and data.alName ~= nil then
      self.bg_white:SetActive(true)
      self.bg_red:SetActive(false)
      self.bg_blue:SetActive(false)
      self.txt_end_time:SetActive(true)
      if data.alId == allianceId then
        self.txt_status:SetActive(false)
      else
        self.txt_status:SetActive(true)
        self.txt_status:SetText("<color=#f97077>[" .. data.alAbbr .. "]" .. data.alName .. "</color>")
      end
      self.txt_end_time:SetText("<color=\"white\">" .. Localization:GetString("456518") .. "</color>")
    else
      self.bg_white:SetActive(true)
      self.bg_red:SetActive(false)
      self.bg_blue:SetActive(false)
      self.txt_end_time:SetActive(false)
      self.txt_status:SetActive(true)
      self.txt_status:SetLocalText("456519")
    end
  end
  self.def:SetActive(false)
  self.act:SetActive(false)
  self.txtDistance:SetText("")
  self.text:SetText("#" .. (data.serverId or curServerId) .. "<u>(" .. self.cityPos.x .. "," .. self.cityPos.y .. ")</u>")
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

function Season5DeclareCityListItem:Update1000MS()
  local shieldTime = checknumber(self.ShieldTime)
  if 0 < shieldTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = shieldTime - curTime
    if 0 < remainTime then
      self.protect_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.protect:SetActive(false)
      self.ShieldTime = 0
    end
  end
  if self.effectId ~= nil and self.tooltip_tick ~= nil and 0 < self.tooltip_tick then
    self.tooltip_tick = self.tooltip_tick - 1
    if 0 >= self.tooltip_tick then
      self:HideTips()
    end
  end
end

return Season5DeclareCityListItem
