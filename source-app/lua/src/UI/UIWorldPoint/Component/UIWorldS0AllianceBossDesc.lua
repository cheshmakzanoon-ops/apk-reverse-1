local base = UIAsyncContainer
local UIWorldS0AllianceBossDesc = BaseClass("UIWorldS0AllianceBossDesc", base)
local Localization = CS.GameEntry.Localization
local UIS0AllianceBossSliderPersonal = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSliderPersonal")
local UIS0AllianceBossSliderAlliance = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSliderAlliance")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")

function UIWorldS0AllianceBossDesc:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIWorldS0AllianceBossDesc:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldS0AllianceBossDesc:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgBanner = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.textBossName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnShareSeason = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnShareSeason:SetOnClick(function()
    self:OnBtnShareSeasonClick()
  end)
  self.btnMarkSeason = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnMarkSeason:SetOnClick(function()
    self:OnBtnMarkSeasonClick()
  end)
  self.compSpeHead = self.viewSkin:AddComponent(self, UICommonHead, 6)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compBubbleEmoji = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.imgEmoji = self.viewSkin:AddComponent(self, UIImage, 9)
  self.textReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 11)
  self.compS0AllianceBossSliderPersonal = self.viewSkin:AddComponent(self, UIS0AllianceBossSliderPersonal, 12)
  self.compS0AllianceBossSliderAlliance = self.viewSkin:AddComponent(self, UIS0AllianceBossSliderAlliance, 13)
  self.textHint = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textSimpleTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.compBossStatusInfo = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.compBg = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.textHint:SetActive(true)
end

function UIWorldS0AllianceBossDesc:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.rawImgBanner = nil
  self.btnDetail = nil
  self.textBossName = nil
  self.btnShareSeason = nil
  self.btnMarkSeason = nil
  self.compSpeHead = nil
  self.textTips = nil
  self.compBubbleEmoji = nil
  self.imgEmoji = nil
  self.textReward = nil
  self.scrollView = nil
  self.compS0AllianceBossSliderPersonal = nil
  self.compS0AllianceBossSliderAlliance = nil
  self.textHint = nil
  self.textSimpleTip = nil
  self.textTime = nil
  self.compBossStatusInfo = nil
  self.compBg = nil
end

function UIWorldS0AllianceBossDesc:OnEnable()
  base.OnEnable(self)
  self:AddTimer()
end

function UIWorldS0AllianceBossDesc:OnDisable()
  base.OnDisable(self)
  self:RemoveTimer()
end

function UIWorldS0AllianceBossDesc:DataDefine()
  self.uuid = nil
end

function UIWorldS0AllianceBossDesc:DataDestroy()
  self.uuid = nil
end

function UIWorldS0AllianceBossDesc:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnS0AllianceBossMarchInfoChanged, self.RefreshItem)
end

function UIWorldS0AllianceBossDesc:OnRemoveListener()
  self:RemoveUIListener(EventId.OnS0AllianceBossMarchInfoChanged, self.RefreshItem)
  base.OnRemoveListener(self)
end

function UIWorldS0AllianceBossDesc:InitView()
  local power = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k19", 0)
  self.textSimpleTip:SetText(power)
  self.textReward:SetLocalText("s0_alliance_boss_current_reward_info")
end

function UIWorldS0AllianceBossDesc:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIWorldS0AllianceBossDesc:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, BindCallback(self, self.RefreshTime), self, false, false, false)
  end
  self.timer:Start()
end

function UIWorldS0AllianceBossDesc:RefreshTime()
  if self.endTime and self.endTime > 0 then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    local remain = self.endTime - curTs
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remain))
  end
end

function UIWorldS0AllianceBossDesc:RefreshData(data)
  if data then
    self.uuid = data.uuid
    self:RefreshItem(data.uuid)
  end
end

function UIWorldS0AllianceBossDesc:RefreshItem(uuid)
  if uuid and self.uuid == uuid then
    local marchInfo = CS.SceneManager.World:GetMarch(uuid)
    if marchInfo then
      local s0AllianceBossInfo = marchInfo and marchInfo.s0AllianceBossInfo
      if s0AllianceBossInfo then
        self.endTime = s0AllianceBossInfo.battleEndTime
        local cfgId = s0AllianceBossInfo.cfgId
        local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(cfgId)
        if bossTemp then
          self.rawImgBanner:LoadSpriteAuto(bossTemp.monster_banner)
          local allianceReward = bossTemp.allianceReward
          if allianceReward then
            local star = s0AllianceBossInfo.rewardProgress
            local result = {}
            local reward = allianceReward[star + 1]
            local rewardList = reward and DataCenter.RewardTemplateManager:GetList(reward)
            if rewardList then
              for _, v in ipairs(rewardList) do
                result[#result + 1] = v
              end
            end
            self:RefreshReward(result)
          end
          local monsterId = bossTemp.monsterId
          local monsterTemp = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
          if monsterTemp == nil then
            Logger.LogError("S0AllianceBoss -- monster template cannot find")
            return
          end
          local power = monsterTemp.recommend_power
          local powerStr = string.GetFormattedSeparatorNum(power)
          self.textHint:SetLocalText("challenge_zombie_recommend_power", powerStr)
          local personalDmgMax = bossTemp.personalMaxDmg
          local isMine = marchInfo.allianceUid == LuaEntry.Player.allianceId
          local curPersonalDmg = 0
          if isMine then
            self.compS0AllianceBossSliderPersonal:SetActive(true)
            curPersonalDmg = DataCenter.S0AllianceBossDataManager:GetCurPersonalDmg()
            if curPersonalDmg ~= nil then
              self.compS0AllianceBossSliderPersonal:RefreshView(curPersonalDmg, personalDmgMax, bossTemp.difficulty)
            end
          else
            self.compS0AllianceBossSliderPersonal:SetActive(false)
          end
          local allianceDmgMax = bossTemp.allianceMaxDmg
          local damage = s0AllianceBossInfo.damage
          self.compS0AllianceBossSliderAlliance:RefreshView(damage, allianceDmgMax, bossTemp.allianceDmg, bossTemp.difficulty)
          local curTs = UITimeManager:GetInstance():GetServerTime()
          local remain = self.endTime - curTs
          local isRuins = false
          if remain <= 0 then
            self.endTime = nil
            self.textTime:SetLocalText("s0_alliance_boss_end_tips")
            local name = bossTemp.name
            local level = bossTemp.difficulty
            local nameStr = "Lv." .. level .. " " .. Localization:GetString(name)
            self.textBossName:SetText(nameStr)
          else
            isRuins = true
            self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remain))
            local bossLevel = monsterTemp.level
            local bossName = monsterTemp.name
            local nameStr = "Lv." .. bossLevel .. " " .. Localization:GetString(bossName)
            self.textBossName:SetText(nameStr)
          end
          local offsetY = isMine and 0 or 126
          if allianceDmgMax <= damage and isRuins then
            self.compBossStatusInfo:SetActive(true)
            local picName = monsterTemp:GetSmallIcon()
            self.compSpeHead:SetHead("", picName, "")
            self.textTips:SetLocalText("s0_alliance_boss_alliance_weakened")
            self.compBg:SetSizeDeltaY(786 - offsetY)
          else
            self.compBossStatusInfo:SetActive(false)
            self.compBg:SetSizeDeltaY(660 - offsetY)
          end
        end
      end
    end
  end
end

function UIWorldS0AllianceBossDesc:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UICommonResItem, itemObj)
  if cellItem ~= nil then
    local reward = self.rewardList[index]
    if reward then
      cellItem:ParseInfo(reward)
    end
  end
end

function UIWorldS0AllianceBossDesc:OnRewardItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function UIWorldS0AllianceBossDesc:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonResItem)
end

function UIWorldS0AllianceBossDesc:RefreshReward(rewardList)
  if not table.IsNullOrEmpty(rewardList) then
    self.rewardList = rewardList
    self:ClearScroll()
    self.scrollView:SetTotalCount(#rewardList)
    self.scrollView:RefillCells()
  end
end

function UIWorldS0AllianceBossDesc:OnBtnDetailClick()
  local context = Localization:GetString("s0_alliance_boss_alliance_reward_tip")
  if self.scaleFactor == nil then
    self.scaleFactor = UIManager:GetInstance():GetScaleFactor()
  end
  local position = self.btnDetail.transform.position + Vector3.New(20, 0, 0) * self.scaleFactor
  if self.tipParam == nil then
    self.tipParam = UIHeroTipView.Param.New()
  end
  self.tipParam.content = context
  self.tipParam.dir = UIHeroTipView.Direction.RIGHT
  self.tipParam.defWidth = 200
  self.tipParam.pivot = 0.5
  self.tipParam.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, self.tipParam)
end

function UIWorldS0AllianceBossDesc:OnBtnShareSeasonClick()
  self.view:OnShareClick()
end

function UIWorldS0AllianceBossDesc:OnBtnMarkSeasonClick()
  self.view:OnMarkClick()
end

return UIWorldS0AllianceBossDesc
