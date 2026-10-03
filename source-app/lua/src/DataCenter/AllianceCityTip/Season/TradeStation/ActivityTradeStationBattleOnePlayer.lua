local base = UIBaseContainer
local ActivityTradeStationBattleOnePlayer = BaseClass("ActivityTradeStationBattleOnePlayer", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local TradeStataionPointData = require("DataCenter.AllianceCityTip.Season.TradeStation.TradeStataionPointData")
local slider_path = "lordInfo/bg/slider"
local arrow1_path = "lordInfo/bg/arrow1"
local lord_countdown_path = "lordInfo/bg/lordCountdown"
local u_i_player_head_path = "lordInfo/headParent/UIPlayerHead"
local battle_countdown_path = "lordInfo/bg/battleCountdown"
local click_btn_path = "lordInfo/clickBtn"
local attack_icon_path = "lordInfo/attackIcon"
local lord_title_path = "lordInfo/headParent/lordTitle"
local leftStr = ""

function ActivityTradeStationBattleOnePlayer:__init(gameObject)
  self.parentTrabs = gameObject.transform
  self.lodCache = 1
  leftStr = Localization:GetString("season_s3_trade_city030")
  self:InitPrefab()
end

function ActivityTradeStationBattleOnePlayer:__delete()
  if self.gameObject ~= nil then
    self:OnDisable()
    self:OnDestroy()
  else
    self.holder = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self.parentTrabs = nil
  self.lodCache = 1
end

function ActivityTradeStationBattleOnePlayer:InitPrefab()
  local request = ResourceManager:InstantiateAsync("Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceCityTip/TradeStationBattleOnePlayer.prefab")
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or theWorld == nil or IsNull(self.parentTrabs) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.parentTrabs)
    go.transform:Set_localScale(0.01, 0.01, 0.01)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localRotation(0, 0, 0, 1)
    base.Reinit(self, go, "")
    self.initActiveSelf = true
    self:OnCreate()
    self:OnEnable()
    self:SetLod(theWorld:GetLodLevel())
    self:UpdateData()
  end)
  self.request = request
end

local sliderH = 120

function ActivityTradeStationBattleOnePlayer:OnCreate()
  base.OnCreate(self)
  self.slider = self:AddComponent(UIImage, slider_path)
  self.arrow1 = self:AddComponent(UIImage, arrow1_path)
  self.lord_countdown = self:AddComponent(UITextMeshProUGUIEx, lord_countdown_path)
  self.playerHead = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.battle_countdown = self:AddComponent(UITextMeshProUGUIEx, battle_countdown_path)
  self.attack_icon = self:AddComponent(UIImage, attack_icon_path)
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self.click_btn:SetOnClick(function()
    if self.data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWTradeStationBattleList, {anim = true}, self.data)
    end
  end)
  self.lord_title = self:AddComponent(UIImage, lord_title_path)
end

function ActivityTradeStationBattleOnePlayer:OnDestroy()
  self.slider = nil
  self.arrow1 = nil
  self.lord_countdown = nil
  self.playerHead = nil
  self.battle_countdown = nil
  self.attack_icon = nil
  self.click_btn = nil
  self.lord_title = nil
  base.OnDestroy(self)
end

function ActivityTradeStationBattleOnePlayer:UpdateData()
  self:DoRefresh()
end

function ActivityTradeStationBattleOnePlayer:SetLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 3)
  end
end

function ActivityTradeStationBattleOnePlayer:CheckLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 3)
  end
end

function ActivityTradeStationBattleOnePlayer:ReInit(data, serverId)
  self.data = data
  self.battleEnd = false
  self.serverId = serverId or LuaEntry.Player:GetCurServerId()
  self:DoRefresh()
  EventManager:GetInstance():Broadcast(EventId.TradeStationBattleInfoChange, self.data)
end

function ActivityTradeStationBattleOnePlayer:DoRefresh()
  if IsNotNull(self.gameObject) then
    self.endTime = self.data.battleEndTime / 1000
    self.maxPoint = self.data.maxPoint
    self:RefreshBattlePlayerData(false)
    self:Update1000MS()
  end
end

function ActivityTradeStationBattleOnePlayer.SetImage(bg, arrow, playerInfo)
  if playerInfo.uid == LuaEntry.Player.uid then
    bg:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/UITradeStation/mjc_S3_myz_jindutiao2_1.png")
    arrow:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/UITradeStation/mjc_S3_myz_jindutiao2_2.png")
    return
  end
  if not string.IsNullOrEmpty(LuaEntry.Player:GetAllianceUid()) and LuaEntry.Player:GetAllianceUid() == playerInfo.allianceId then
    bg:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/UITradeStation/mjc_S3_myz_jindutiao4_1.png")
    arrow:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/UITradeStation/mjc_S3_myz_jindutiao4_2.png")
    return
  end
  bg:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/UITradeStation/mjc_S3_myz_jindutiao3_1.png")
  arrow:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/UITradeStation/mjc_S3_myz_jindutiao3_2.png")
end

function ActivityTradeStationBattleOnePlayer:RefreshBattlePlayerData(isRefreshTime)
  self.battlePlayerInfo = self.data:CalcPlayerOccupyInfoAlive(1)
  local noOne = false
  if self.battlePlayerInfo then
    if self.battlePlayerInfo[1] then
      local playerInfo = self.battlePlayerInfo[1].buildPointInfo
      self.playerHead:ParseHeadInfo(playerInfo)
      local curScore = TradeStataionPointData.CalcPoint(playerInfo, self.maxPoint)
      local rate = curScore / self.maxPoint
      self.slider:SetSizeDeltaY(rate * sliderH)
      local percent = string.percentage(curScore, self.maxPoint, 2)
      local countDown = ""
      local time = TradeStataionPointData.CalcFinishTime(playerInfo, self.maxPoint)
      if 0 < time then
        countDown = UITimeManager:GetInstance():SecondToFmtString(time)
      else
        countDown = "00:00:00"
      end
      self.lord_countdown:SetText(percent .. "\n" .. countDown)
      if not isRefreshTime then
        ActivityTradeStationBattleOnePlayer.SetImage(self.slider, self.arrow1, playerInfo)
        self.attack_icon:SetActive(false)
        self.lord_title:SetActive(false)
      end
    else
      noOne = true
    end
  else
    noOne = true
  end
  if noOne then
    local rate = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local battleStartT = self.data.battleStartTime
    local battleEndT = self.data.battleEndTime
    if curTime > battleStartT then
      if curTime < battleEndT then
        rate = (curTime - battleStartT) / (battleEndT - battleStartT)
      else
        rate = 1
      end
    else
      rate = 0
    end
    local finishTime = (battleEndT - curTime) / 1000
    if 0 < finishTime then
      finishTime = math.ceil(finishTime)
      self.lord_countdown:SetText(leftStr .. "\n" .. UITimeManager:GetInstance():SecondToFmtString(finishTime))
    else
      self.lord_countdown:SetText(leftStr .. "\n" .. "00:00:00")
    end
    self.slider:SetSizeDeltaY(rate * sliderH)
    if not isRefreshTime then
      self.attack_icon:SetActive(false)
      ActivityTradeStationBattleOnePlayer.SetImage(self.slider, self.arrow1, {
        uid = self.data.uid,
        allianceId = self.data.allianceId
      })
      self.attack_icon:SetActive(false)
      local tradeId = self.data.tradeId
      local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(tradeId, self.serverId)
      if cityMeta and not string.IsNullOrEmpty(cityMeta.lord_cap) then
        self.lord_title:LoadSpriteAsyncEx(cityMeta.lord_cap)
        self.lord_title:SetActive(true)
        self.playerHead:ParseHeadInfo(self.data, true)
      else
        self.lord_title:SetActive(false)
        self.playerHead:ParseHeadInfo(self.data, false)
      end
    end
  end
end

function ActivityTradeStationBattleOnePlayer:Update1000MS()
  if not IsNotNull(self.gameObject) then
    return
  end
  if self.battleEnd then
    self.selfActive = false
    if IsNotNull(self.gameObject) then
      self:SetActive(false)
    end
    return
  end
  if self.endTime and self.endTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local deltaTime = self.endTime - curTime
    if 0 < deltaTime then
      self.battle_countdown:SetText(UITimeManager:GetInstance():SecondToFmtString(deltaTime))
    else
      self.battleEnd = true
      self.battle_countdown:SetText("00:00:00")
    end
  end
  self:RefreshBattlePlayerData(true)
end

return ActivityTradeStationBattleOnePlayer
