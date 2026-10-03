local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local ActivityKingBattleLogic = BaseClass("ActivityKingBattleLogic", base)
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger
local king_occupy_path = "KingOccupy"
local king_occupy_btn_path = "KingOccupy/btn"
local king_icon_path = "KingOccupy/icon"
local king_user_name_path = "KingOccupy/user_name"
local king_pro_path = "KingOccupy/pro_bg/pro"
local king_pro_num_path = "KingOccupy/pro_bg/pro_num"

function ActivityKingBattleLogic:__init(gameObject)
  base.__init(self, gameObject)
  self.king_occupy = self.transform:Find(king_occupy_path).gameObject
  self.king_icon = self.transform:Find(king_icon_path):GetComponent(typeof(SpriteRenderer))
  self.king_pro = self.transform:Find(king_pro_path):GetComponent(typeof(SpriteRenderer))
  self.king_pro_num = self.transform:Find(king_pro_num_path):GetComponent(typeof(SuperTextMesh))
  self.king_user_name = self.transform:Find(king_user_name_path):GetComponent(typeof(SuperTextMesh))
  self.king_occupy_btn = self.transform:Find(king_occupy_btn_path):GetComponent(typeof(TouchObjectEventTrigger))
  
  function self.king_occupy_btn.onPointerClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOccupyRankDetail, self.cityId)
  end
  
  self.king_occupy_btn.previewType = CS.WorldPreviewType.GUI
  self.king_occupy:SetActive(false)
end

function ActivityKingBattleLogic:__delete()
  self.king_occupy_player = nil
  self.king_occupy_btn.onPointerClick = nil
  self.king_occupy:SetActive(false)
  base.__delete(self)
end

function ActivityKingBattleLogic:TimerAction()
  if self.isCrossServerThrone then
    self:DeleteTimer()
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.king_occupy_player ~= nil and self.king_occupy_player.startTime ~= nil then
    local point = (curTime - self.king_occupy_player.startTime) * 0.001 * self.king_occupy_point_speed + self.king_occupy_player.point
    local rate = point / self.king_occupy_point_max
    if 1 < rate then
      rate = 1
      self.king_occupy_player = nil
      self.king_occupy:SetActive(false)
    end
    self.king_pro_num.text = string.percentage(point, self.king_occupy_point_max, 2)
    self.king_pro:Set_size(1.72 * rate, 0.202)
  end
end

function ActivityKingBattleLogic:OnKingOccupyProgressRefresh()
  if self.isKingCity then
    base.UpdateCityInfo(self)
    self:DoRefresh()
  end
end

function ActivityKingBattleLogic:OnPointDateUpdate()
  if self.isKingCity then
    base.UpdateCityInfo(self)
    self:DoRefresh()
  end
end

function ActivityKingBattleLogic:OnWorldAllianceCityDetail()
  if self.isKingCity then
    base.UpdateCityInfo(self)
    self:DoRefresh()
  end
end

function ActivityKingBattleLogic:SetLod(lod)
  base.SetLod(self, lod)
end

function ActivityKingBattleLogic:CheckLod(lod)
  base.CheckLod(self, lod)
  self.king_occupy:SetActive(self.lodCache and self.lodCache < 3 and self.king_occupy_player ~= nil)
end

function ActivityKingBattleLogic:ReInit(data)
  base.ReInit(self, data)
end

function ActivityKingBattleLogic:DoRefresh()
  local isInBigMap = SeasonUtil.InSeasonBigMapMode(self.serverId)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.theExtraInfo then
    local timeOpen = self.theExtraInfo.openTime or 0
    local timeEnd = self.theExtraInfo.protectTime or 0
    if curTime < timeOpen or curTime >= timeEnd then
      self.king_occupy_player = nil
      self.king_occupy:SetActive(false)
      self:DeleteTimer()
      return
    end
  end
  if self.isCrossServerThrone or not isInBigMap and self.serverId ~= LuaEntry.Player:GetSelfServerId() then
    self.king_occupy_player = nil
    self.king_occupy:SetActive(false)
    self:DeleteTimer()
    return
  end
  if self.theExtraInfo and self.theExtraInfo.state == AllianceCityState.OCCUPIED then
    self.king_occupy_player = nil
    self.king_occupy:SetActive(false)
    self:DeleteTimer()
    return
  end
  local curPresident = DataCenter.GovernmentManager:GetCurPresident(self.serverId)
  if curPresident == nil or self.theExtraInfo and self.theExtraInfo.state == AllianceCityState.BUILDING then
    local maxPoint = SeasonUtil.GetPresidentOccupationRate("k2", 28800)
    local addSpeed = SeasonUtil.GetPresidentOccupationRate("k1", 1)
    self.king_occupy_player = DataCenter.GovernmentManager:GetKingOccupyPlayer(self.serverId)
    if self.king_occupy_player == nil then
      local activityServerData = DataCenter.GovernmentManager.activityServerData
      local fightInfo = DataCenter.GovernmentManager:GetKingOccupyList(self.serverId)
      if fightInfo ~= nil and activityServerData ~= nil then
        for _, v in ipairs(fightInfo) do
          if v and v.isBuilding == 1 then
            self.king_occupy_player = v
            break
          end
        end
      end
    end
    if self.king_occupy_player == nil then
      local allianceCityPointInfo = self.theExtraInfo
      if allianceCityPointInfo ~= nil then
        local alAbbr = allianceCityPointInfo.alAbbr
        local alName = allianceCityPointInfo.alName
        local buildPoint = allianceCityPointInfo.buildPoint
        local buildStartTime = allianceCityPointInfo.buildStartTime
        if buildStartTime ~= nil and buildStartTime ~= 0 and buildStartTime ~= "" then
          local pointNow = (curTime - buildStartTime) * addSpeed + buildPoint
          self.king_occupy_player = {
            point = pointNow,
            startTime = curTime * 1000,
            abbr = alAbbr,
            name = alName
          }
        end
      end
    end
    if self.king_occupy_player ~= nil then
      local v = self.king_occupy_player
      local rate = v.point / maxPoint
      if 1 < rate then
        self.king_occupy_player = nil
        self.king_occupy:SetActive(false)
        return
      end
      self.king_occupy_point_max = maxPoint
      self.king_occupy_point_speed = addSpeed
      self.king_user_name.text = v.name
      self.king_pro_num.text = string.percentage(v.point, maxPoint, 2)
      self.king_pro:Set_size(1.72 * rate, 0.202)
      if v.icon then
        self.king_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(v.icon)))
      end
      if v.abbr == nil or v.abbr == "" then
        self.king_user_name.text = v.name
      else
        self.king_user_name.text = "[" .. v.abbr .. "] " .. v.name
      end
    end
    self.king_occupy:SetActive(self.lodCache < 3 and self.king_occupy_player ~= nil)
    if self.king_occupy_player ~= nil then
      self:TimerAction()
    end
  else
    self.king_occupy_player = nil
    self.king_occupy:SetActive(false)
  end
end

return ActivityKingBattleLogic
