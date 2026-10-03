local LoginPopManager = BaseClass("LoginPopManager")
local Setting = CS.GameEntry.Setting
local K_COUNT = 32

local function __init(self)
  self.popped = false
  self.loadComplete = false
  self.packInited = false
  self.popPack = nil
  self.newBeeMigrateAccept = nil
  self.allianceSwitch = nil
  self:AddListeners()
end

local function __delete(self)
  self.popped = nil
  self.loadComplete = nil
  self.packInited = nil
  self.popPack = nil
  self.newBeeMigrateAccept = nil
  self.allianceSwitch = nil
  self:RemoveListeners()
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.LOAD_COMPLETE, self.OnLoadComplete)
  EventManager:GetInstance():AddListener(EventId.PaySuccess, self.OnPaySuccess)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.LOAD_COMPLETE, self.OnLoadComplete)
  EventManager:GetInstance():RemoveListener(EventId.PaySuccess, self.OnPaySuccess)
end

local function Startup(self)
end

local function OnLoadComplete()
  DataCenter.LoginPopManager.loadComplete = true
  DataCenter.LoginPopManager:LoginPop()
end

local function OnPaySuccess(packId)
  local popPack = DataCenter.LoginPopManager.popPack
  if popPack ~= nil and packId == popPack:getID() then
    DataCenter.LoginPopManager.popPack = nil
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
  end
end

local function NoticeInitPackage(self)
  self.packInited = true
  self:LoginPop()
end

local function LoginPop(self)
  local newBeeMigrateWay = LuaEntry.Player:GetNewBeeMigrateWay()
  if self.loadComplete and 0 < newBeeMigrateWay then
    if newBeeMigrateWay % 2 == 0 and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUINewBeeMigrate) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUINewBeeMigrate)
    end
    return
  end
  if self.loadComplete then
    local playGuide = DataCenter.LoginGuideManager:LoginGuide()
    if playGuide then
      return
    end
  end
  if not self.loadComplete or not self.packInited then
    return
  end
  if self.popped then
    return
  end
  self.popped = true
  if DataCenter.BuildManager:CheckShowReplaceTip() then
    return
  end
  local lastTime = tonumber(Setting:GetString(SettingKeys.LOGIN_POP_LAST_TIME, "0"))
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local sameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, lastTime // 1000)
  local index = sameDay and Setting:GetInt(SettingKeys.LOGIN_POP_K, 1) or 1
  local attempted = 0
  local data
  repeat
    data = self.TryLoginPopIndex(index)
    index = index % K_COUNT + 1
    attempted = attempted + 1
  until data ~= nil or attempted == K_COUNT
  if data == nil then
    index = 1
  else
    if data.type == WelfareTagType.SpecialPack then
      local packs = WelfareController.GetPopupPackages()
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIPlayerLevelPackage, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, data.rechargeId, packs)
    elseif data.type == WelfareTagType.PiggyBank then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIPiggyBank)
    elseif data.type == WelfareTagType.EnergyBank then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIEnergyBank)
    elseif data.type == WelfareTagType.ScrollPack then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIScrollPack, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, data.pack)
    elseif data.type == WelfareTagType.RobotPack then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIRobotPack, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, data.pack)
    elseif data.type == WelfareTagType.MonthCard then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIGolloesMonthCard, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, data.pack)
    elseif data.type == WelfareTagType.FirstCharge then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIFirstPay, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, {delay = 0.5, isPopup = true})
    end
    self.popPack = data.pack
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
  end
  local isFunctionOnNewPopupStyle = DataCenter.LWPopupManager:IsFunctionOnNewPopupStyle()
  if LuaEntry.Player:AtHomeNow() then
    if DataCenter.ZoneWarManager:CheckShowMainUIBtn() and DataCenter.ZoneWarManager:IsBattleDay() then
      local count = UIUtil.GetWeekActiveCount("CrossKingBattlePopup", false)
      local yes = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.CrossKingActivity)
      if yes and count == 0 then
        if not isFunctionOnNewPopupStyle then
          DataCenter.UIPopWindowManager:Push(UIWindowNames.UIGovernmentServerBattlePopup, {
            anim = false,
            UIMainAnim = UIMainAnimType.AllHide
          })
        else
          DataCenter.LWPopupManager:TryAddPopupActivity(PopupActivityType.CrossKingActivity)
        end
      end
    else
      local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.KingActivity.Type)
      if 0 < #dataList then
        local count = toInt(Setting:GetPrivateInt(TodayNoSecondConfirmType.KingActivity, 0))
        if count < 2 then
          if not isFunctionOnNewPopupStyle then
            DataCenter.UIPopWindowManager:Push(UIWindowNames.UIGovernmentActivityPopup, {
              anim = false,
              UIMainAnim = UIMainAnimType.AllHide
            })
          else
            DataCenter.LWPopupManager:TryAddPopupActivity(PopupActivityType.KingActivity)
          end
        end
      end
    end
  end
  local dataBreach = LuaEntry.Effect:CheckCityBreach()
  if DataCenter.CityRebuildDataManager:CheckCanPopRebuildUI() and not DataCenter.DefenceWallDataManager:GetBreakState() then
    DataCenter.CityRebuildDataManager:SendMarchMessage(false)
    DataCenter.UIPopWindowManager:Push(UIWindowNames.LWUICityRebuildNewView, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, true)
  elseif dataBreach and dataBreach.uuid ~= nil and not DataCenter.CityRebuildDataManager:CheckCanPopRebuildUI() then
    DataCenter.UIPopWindowManager:Push(UIWindowNames.LWUICityBreach, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, dataBreach)
  end
  local infiniteGiftNotShow = LuaEntry.DataConfig:TryGetNum("activity_login_up", "k2", 0) == 1
  local infiniteGiftActDatas = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.InfiniteGift.Type)
  if not infiniteGiftNotShow and 0 < #infiniteGiftActDatas then
    for _, v in pairs(infiniteGiftActDatas) do
      if v:IsValid() then
        local isActive = DataCenter.ActInfiniteGiftDataManager:IsActAcitve(v.id)
        if isActive and not DataCenter.CityRebuildDataManager:CheckCanPopRebuildUI() then
          DataCenter.UIPopWindowManager:Push(UIWindowNames.UILWInfiniteGift, {
            anim = false,
            UIMainAnim = UIMainAnimType.AllHide
          }, v.id, 1)
        end
      end
    end
  end
  local heroMonthCardNotShow = LuaEntry.DataConfig:TryGetNum("activity_login_up", "k1", 0) == 1
  if not heroMonthCardNotShow then
    DataCenter.HeroMonthCardManager:CheckIsNeedPop()
  end
  if DataCenter.ChampionDuelManager:CheckShowSignPop() then
    if not isFunctionOnNewPopupStyle then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIChampionDuelSignTip, {anim = true})
    else
      DataCenter.LWPopupManager:TryAddPopupActivity(PopupActivityType.ChampionDuel)
    end
  end
  if not DataCenter.LWBeginnerDirectorManager:GetCurCityEvent() then
  end
  DataCenter.OfficialApplyManager:ShowLoginPop()
  if DataCenter.LWAccountBindTipManager:CheckTipShow() then
    DataCenter.LWAccountBindTipManager:TryPopTip()
  end
  if DataCenter.NewPeakArenaManager:CheckIsNeedPop() then
    if not isFunctionOnNewPopupStyle then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.NewPeakArenaFirstOpenTip, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, {
        type = PVPArenaType.NewPeakArena
      })
    else
      DataCenter.LWPopupManager:TryAddPopupActivity(PopupActivityType.NewPeakArena, {
        type = PVPArenaType.NewPeakArena
      })
    end
  elseif DataCenter.NewGaleArenaManager:CheckIsNeedPop() then
    if not isFunctionOnNewPopupStyle then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.NewPeakArenaFirstOpenTip, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, {
        type = PVPArenaType.NewGaleArena
      })
    else
      DataCenter.LWPopupManager:TryAddPopupActivity(PopupActivityType.NewGaleArena, {
        type = PVPArenaType.NewGaleArena
      })
    end
  elseif not isFunctionOnNewPopupStyle and DataCenter.AllianceCompeteDataManager:CheckShowProtectCoverPopup() then
    DataCenter.UIPopWindowManager:Push(UIWindowNames.LWUIAllianceCompeteProtectTip, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
  DataCenter.ActMeteoriteBattleManager:CheckIsNeedPop()
  BattlefieldDsbDuelUtils.ActInfo:CheckIsNeedPop()
  Setting:SetInt(SettingKeys.LOGIN_POP_K, index)
  Setting:SetString(SettingKeys.LOGIN_POP_LAST_TIME, tostring(curTime))
  DataCenter.LWWelcomeBackManager:TryShow()
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if infoPlayer and infoPlayer:InSettleTime() then
    local world_skin = infoPlayer:GetSkinTemplate()
    if world_skin ~= nil and not string.IsNullOrEmpty(world_skin.finish_tittle) and not string.IsNullOrEmpty(world_skin.finish_info) then
      local count = UIUtil.GetMonthActiveCount("SeasonSettleTips", false)
      if count == 0 then
        if not isFunctionOnNewPopupStyle then
          DataCenter.UIPopWindowManager:Push(UIWindowNames.UILWSeasonSettleTimeTipsS5, {
            anim = false,
            UIMainAnim = UIMainAnimType.AllHide
          })
        else
          DataCenter.LWPopupManager:TryAddPopupNotification(PopupNotificationType.SeasonSettleTime)
        end
      end
    end
  end
end

local function TryLoginPopIndex(index)
  local line = LuaEntry.DataConfig:TryGetStr("pop_rate", "k" .. index)
  if string.IsNullOrEmpty(line) then
    return nil
  end
  local dataList = {}
  local totalWeight = 0
  local packStrs = string.split(line, "|")
  for _, packStr in ipairs(packStrs) do
    local spls = string.split(packStr, ";")
    if #spls ~= 4 then
      return nil
    end
    local key = spls[1]
    local lineIndex = tonumber(spls[2])
    local packIndex = tonumber(spls[3])
    local weight = tonumber(spls[4])
    local data = {}
    if string.startswith(key, "type_") then
      local type = tonumber(string.sub(key, 6))
      if type then
        local rechargeIds = GiftPackageData.GetRechargeIdListByType(type)
        local rechargeLines = {}
        for _, rechargeId in ipairs(rechargeIds) do
          if WelfareController.CanPopup(rechargeId) then
            local packs = GiftPackageData.GetAllAvailablePackageByRechargeId(rechargeId, false)
            if not table.IsNullOrEmpty(packs) then
              local rechargeLine = DataCenter.RechargeManager:GetLine(rechargeId)
              local login_open_forbid = DataCenter.RechargeManager:getStrValue(rechargeId, "login_open_forbid")
              local forbidPop = DataCenter.CityRebuildDataManager:CheckCanPopRebuildUI()
              if not string.IsNullOrEmpty(login_open_forbid) and login_open_forbid == "1" then
                forbidPop = true
              end
              if rechargeLine and not forbidPop then
                local insert = true
                if tonumber(rechargeLine.type) == WelfareTagType.MonthCard then
                  local monthCardInfo = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
                  if monthCardInfo == nil or monthCardInfo:IsBought() then
                    insert = false
                  end
                elseif tonumber(rechargeLine.type) == WelfareTagType.HeroMonthCardNew then
                  local exchangeId = rechargeLine.para1
                  local activityId = DataCenter.HeroMonthCardManager:GetActivityIdByExchangeId(exchangeId)
                  if activityId then
                    local heroMonthCardInfo = DataCenter.HeroMonthCardManager:GetHeroMonthCardInfo(activityId)
                    if heroMonthCardInfo == nil or heroMonthCardInfo.buy == BuyFlag.BUY then
                      insert = false
                    end
                  end
                end
                if insert then
                  table.insert(rechargeLines, rechargeLine)
                end
              end
            end
          end
        end
        table.sort(rechargeLines, function(a, b)
          return a.order < b.order
        end)
        local rechargeLine = rechargeLines[lineIndex]
        if rechargeLine then
          local rechargeId = rechargeLine.id
          local packs = GiftPackageData.GetAllAvailablePackageByRechargeId(rechargeId, false)
          table.sort(packs, function(a, b)
            if a:getPopup() ~= b:getPopup() then
              return a:getPopup() > b:getPopup()
            else
              return a:getID() < b:getID()
            end
          end)
          local pack = packs[packIndex]
          if pack then
            data.type = type
            data.rechargeId = rechargeId
            data.pack = pack
          end
        end
      end
    end
    if data.pack then
      data.weight = weight
      totalWeight = totalWeight + weight
      table.insert(dataList, data)
    end
  end
  if table.IsNullOrEmpty(dataList) then
    return nil
  end
  local rand = math.random(1, totalWeight)
  for _, data in ipairs(dataList) do
    rand = rand - data.weight
    if rand <= 0 then
      return data
    end
  end
  return nil
end

LoginPopManager.__init = __init
LoginPopManager.__delete = __delete
LoginPopManager.AddListeners = AddListeners
LoginPopManager.RemoveListeners = RemoveListeners
LoginPopManager.Startup = Startup
LoginPopManager.OnLoadComplete = OnLoadComplete
LoginPopManager.OnPaySuccess = OnPaySuccess
LoginPopManager.NoticeInitPackage = NoticeInitPackage
LoginPopManager.LoginPop = LoginPop
LoginPopManager.TryLoginPopIndex = TryLoginPopIndex
return LoginPopManager
