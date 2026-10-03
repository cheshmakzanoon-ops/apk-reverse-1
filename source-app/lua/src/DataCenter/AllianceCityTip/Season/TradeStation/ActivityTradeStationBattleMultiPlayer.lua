local base = UIBaseContainer
local ActivityTradeStationBattleMultiPlayer = BaseClass("ActivityTradeStationBattleMultiPlayer", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local TradeStataionPointData = require("DataCenter.AllianceCityTip.Season.TradeStation.TradeStataionPointData")
local first_player_path = "battleInfo/firstPlayer"
local second_player_path = "battleInfo/secondPlayer"
local third_player_path = "battleInfo/thirdPlayer"
local end_time_tip_path = "battleInfo/Image/end_time_tip"
local first_name_path = "battleInfo/firstPlayer/first_Name"
local pro1_path = "battleInfo/firstPlayer/first_progress/pro1"
local pro1_des_path = "battleInfo/firstPlayer/first_progress/pro1_des"
local pro2_path = "battleInfo/secondPlayer/second_progress/pro2"
local pro2_des_path = "battleInfo/secondPlayer/second_progress/pro2_des"
local pro3_path = "battleInfo/thirdPlayer/third_progress/pro3"
local pro3_des_path = "battleInfo/thirdPlayer/third_progress/pro3_des"
local u_i_player_head1_path = "battleInfo/firstPlayer/headParent/UIPlayerHead1"
local u_i_player_head2_path = "battleInfo/secondPlayer/headParent/UIPlayerHead2"
local u_i_player_head3_path = "battleInfo/thirdPlayer/headParent/UIPlayerHead3"
local pro1_fill_path = "battleInfo/firstPlayer/first_progress/pro1/FillArea/pro1_fill"
local pro2_fill_path = "battleInfo/secondPlayer/second_progress/pro2/FillArea/pro2_fill"
local pro3_fill_path = "battleInfo/thirdPlayer/third_progress/pro3/FillArea/pro3_fill"
local click_btn_path = "battleInfo/clickBtn"
local occupiedDes = ""
local endTimeDes = ""

function ActivityTradeStationBattleMultiPlayer:__init(gameObject)
  self.parentTrabs = gameObject.transform
  self.lodCache = 1
  self.selfActive = false
  occupiedDes = Localization:GetString("season_s3_trade_city031")
  endTimeDes = Localization:GetString("season_s3_trade_city032")
  self:InitPrefab()
end

function ActivityTradeStationBattleMultiPlayer:__delete()
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
  self.selfActive = false
  self.parentTrabs = nil
  self.lodCache = 1
end

function ActivityTradeStationBattleMultiPlayer:InitPrefab()
  local request = ResourceManager:InstantiateAsync("Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceCityTip/TradeStationBattleTip.prefab")
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

function ActivityTradeStationBattleMultiPlayer:OnCreate()
  base.OnCreate(self)
  self.first_player = self:AddComponent(UIBaseContainer, first_player_path)
  self.second_player = self:AddComponent(UIBaseContainer, second_player_path)
  self.third_player = self:AddComponent(UIBaseContainer, third_player_path)
  self.end_time_tip = self:AddComponent(UITextMeshProUGUIEx, end_time_tip_path)
  self.playerHead1 = self:AddComponent(UICommonHead, u_i_player_head1_path)
  self.first_name = self:AddComponent(UITextMeshProUGUIEx, first_name_path)
  self.pro1 = self:AddComponent(UISlider, pro1_path)
  self.pro1_des = self:AddComponent(UITextMeshProUGUIEx, pro1_des_path)
  self.playerHead2 = self:AddComponent(UICommonHead, u_i_player_head2_path)
  self.pro2 = self:AddComponent(UISlider, pro2_path)
  self.pro2_des = self:AddComponent(UITextMeshProUGUIEx, pro2_des_path)
  self.playerHead3 = self:AddComponent(UICommonHead, u_i_player_head3_path)
  self.pro3 = self:AddComponent(UISlider, pro3_path)
  self.pro3_des = self:AddComponent(UITextMeshProUGUIEx, pro3_des_path)
  self.pro1_fill = self:AddComponent(UIImage, pro1_fill_path)
  self.pro2_fill = self:AddComponent(UIImage, pro2_fill_path)
  self.pro3_fill = self:AddComponent(UIImage, pro3_fill_path)
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self.click_btn:SetOnClick(function()
    if self.data and not self.isEmpty then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWTradeStationBattleList, {anim = true}, self.data)
    end
  end)
end

function ActivityTradeStationBattleMultiPlayer:OnDestroy()
  if self.seq then
    self.seq:Kill()
  end
  self.seq = nil
  self.first_player = nil
  self.second_player = nil
  self.third_player = nil
  self.end_time_tip = nil
  self.playerHead1 = nil
  self.first_name = nil
  self.pro1 = nil
  self.pro1_des = nil
  self.playerHead2 = nil
  self.pro2 = nil
  self.pro2_des = nil
  self.playerHead3 = nil
  self.pro3 = nil
  self.pro3_des = nil
  self.pro1_fill = nil
  self.pro2_fill = nil
  self.pro3_fill = nil
  self.click_btn = nil
  self.battlePlayerInfo = nil
  base.OnDestroy(self)
end

function ActivityTradeStationBattleMultiPlayer:UpdateData()
  self:DoRefresh()
end

function ActivityTradeStationBattleMultiPlayer:SetLod(lod)
  if not self.selfActive then
    return
  end
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 3)
  end
end

function ActivityTradeStationBattleMultiPlayer:CheckLod(lod)
  if not self.selfActive then
    return
  end
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 3)
  end
end

function ActivityTradeStationBattleMultiPlayer:ReInit(data, serverId)
  self.data = data
  self.selfActive = self.data ~= nil
  self.battleEnd = false
  self.serverId = serverId or LuaEntry.Player:GetCurServerId()
  self:DoRefresh()
  EventManager:GetInstance():Broadcast(EventId.TradeStationBattleInfoChange, self.data)
end

function ActivityTradeStationBattleMultiPlayer:DoRefresh()
  if not IsNotNull(self.gameObject) then
    return
  end
  self.showFlag = 1
  if self.data then
    self.endTime = self.data.battleEndTime / 1000
    self.maxPoint = self.data.maxPoint
    self:RefreshBattlePlayerData(false)
    self:Update1000MS()
  else
    self.selfActive = false
    if IsNotNull(self.gameObject) then
      self:SetActive(false)
    end
  end
end

function ActivityTradeStationBattleMultiPlayer.SetFirstFillImage(imgCom, data)
  if data.uid == LuaEntry.Player.uid then
    imgCom:LoadSprite(string.format(LoadPath.CommonPath, "cfm_tongyong_jindutiao_lv.png"))
    return
  end
  if not string.IsNullOrEmpty(LuaEntry.Player:GetAllianceUid()) and LuaEntry.Player:GetAllianceUid() == data.allianceId then
    imgCom:LoadSprite(string.format(LoadPath.LWCommonPath, "lrb_dongjifengbao_jindutiao03"))
    return
  end
  imgCom:LoadSprite(string.format(LoadPath.LWCommonPath, "lrb_dongjifengbao_jindutiao02"))
end

function ActivityTradeStationBattleMultiPlayer.SetFillImage(imgCom, data)
  if data.uid == LuaEntry.Player.uid then
    imgCom:LoadSprite("Assets/Main/Sprites/UI/UILWMail/lyp_zdhf_jindutiao_lv.png")
    return
  end
  if not string.IsNullOrEmpty(LuaEntry.Player:GetAllianceUid()) and LuaEntry.Player:GetAllianceUid() == data.allianceId then
    imgCom:LoadSprite("Assets/Main/Sprites/UI/UILWMail/lyp_zdhf_jindutiao_lan.png")
    return
  end
  imgCom:LoadSprite("Assets/Main/Sprites/UI/UILWMail/lyp_zdhf_jindutiao_hong.png")
end

function ActivityTradeStationBattleMultiPlayer:RefreshBattlePlayerData(isUpdate)
  self.battlePlayerInfo = self.data:CalcPlayerOccupyInfo(3)
  self.isEmpty = true
  if self.battlePlayerInfo then
    if self.battlePlayerInfo[1] then
      self.isEmpty = false
      self.first_player:SetActive(true)
      local playerInfo = self.battlePlayerInfo[1].buildPointInfo
      local curScore = TradeStataionPointData.CalcPoint(playerInfo, self.maxPoint)
      local rate = curScore / self.maxPoint
      self.pro1:SetValue(rate)
      if self.showFlag == 1 then
        local time = 0
        if 0 < playerInfo.refreshTime then
          time = TradeStataionPointData.CalcFinishTime(playerInfo, self.maxPoint)
        else
          local curTime = UITimeManager:GetInstance():GetServerSeconds()
          time = self.endTime - curTime
        end
        if 0 < time then
          self.pro1_des:SetText(occupiedDes .. UITimeManager:GetInstance():SecondToFmtString(time))
        else
          self.pro1_des:SetText(occupiedDes .. "00:00:00")
        end
      else
        self.pro1_des:SetText(string.percentage(curScore, self.maxPoint, 2))
      end
      if not isUpdate and self.seq == nil then
        self.seq = CS.DG.Tweening.DOTween.Sequence()
        self.seq:Append(self.pro1_des:DOFade(0, 1):SetEase(CS.DG.Tweening.Ease.Linear))
        self.seq:AppendCallback(function()
          if self.battlePlayerInfo and self.battlePlayerInfo[1] and self.battlePlayerInfo[1].buildPointInfo then
            local playerInfo = self.battlePlayerInfo[1].buildPointInfo
            if self.showFlag == 1 then
              self.showFlag = 0
              local curScore = TradeStataionPointData.CalcPoint(playerInfo, self.maxPoint)
              local rate = curScore / self.maxPoint
              if self.pro1_des then
                self.pro1_des:SetText(string.percentage(curScore, self.maxPoint, 2))
              end
            else
              self.showFlag = 1
              local time = 0
              if 0 < playerInfo.refreshTime then
                time = TradeStataionPointData.CalcFinishTime(playerInfo, self.maxPoint)
              else
                local curTime = UITimeManager:GetInstance():GetServerSeconds()
                time = self.endTime - curTime
              end
              if self.pro1_des then
                if 0 < time then
                  self.pro1_des:SetText(occupiedDes .. UITimeManager:GetInstance():SecondToFmtString(time))
                else
                  self.pro1_des:SetText(occupiedDes .. "00:00:00")
                end
              end
            end
          end
        end)
        self.seq:Append(self.pro1_des:DOFade(1, 1):SetEase(CS.DG.Tweening.Ease.Linear))
        self.seq:AppendInterval(5)
        self.seq:SetLoops(-1)
      end
      local strUser = UIUtil.FormatServerAllianceName(playerInfo.serverId, playerInfo.alAbbr, playerInfo.uidName)
      self.first_name:SetText(strUser)
      self.playerHead1:ParseHeadInfo(playerInfo)
      ActivityTradeStationBattleMultiPlayer.SetFirstFillImage(self.pro1_fill, playerInfo)
    else
      self.first_player:SetActive(false)
      self.playerHead1:SetHead()
      self.pro1:SetValue(0)
      self.pro1_des:SetText("")
      self.first_name:SetText("")
    end
    if self.battlePlayerInfo[2] then
      self.second_player:SetActive(true)
      local playerInfo = self.battlePlayerInfo[2].buildPointInfo
      self.playerHead2:ParseHeadInfo(playerInfo)
      local curScore = TradeStataionPointData.CalcPoint(playerInfo, self.maxPoint)
      local rate = curScore / self.maxPoint
      self.pro2:SetValue(rate)
      self.pro2_des:SetText(string.percentage(curScore, self.maxPoint, 2))
      ActivityTradeStationBattleMultiPlayer.SetFillImage(self.pro2_fill, playerInfo)
    else
      self.second_player:SetActive(false)
      self.playerHead2:SetHead()
      self.pro2:SetValue(0)
      self.pro2_des:SetText("")
    end
    if self.battlePlayerInfo[3] then
      self.third_player:SetActive(true)
      local playerInfo = self.battlePlayerInfo[3].buildPointInfo
      self.playerHead3:ParseHeadInfo(playerInfo)
      local curScore = TradeStataionPointData.CalcPoint(playerInfo, self.maxPoint)
      local rate = curScore / self.maxPoint
      self.pro3:SetValue(rate)
      self.pro3_des:SetText(string.percentage(curScore, self.maxPoint, 2))
      ActivityTradeStationBattleMultiPlayer.SetFillImage(self.pro3_fill, playerInfo)
    else
      self.third_player:SetActive(false)
      self.playerHead3:SetHead()
      self.pro3:SetValue(0)
      self.pro3_des:SetText("")
    end
  end
end

function ActivityTradeStationBattleMultiPlayer:Update1000MS()
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
      self.end_time_tip:SetText(endTimeDes .. UITimeManager:GetInstance():SecondToFmtString(deltaTime))
    else
      self.battleEnd = true
      self.end_time_tip:SetText(endTimeDes .. "00:00:00")
    end
  end
  self:RefreshBattlePlayerData(true)
end

return ActivityTradeStationBattleMultiPlayer
