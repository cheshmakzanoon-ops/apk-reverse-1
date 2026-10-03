local UIGray = CS.UIGray
local WorldDrillDes = BaseClass("WorldDrillDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization

function WorldDrillDes:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function WorldDrillDes:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function WorldDrillDes:OnEnable()
  base.OnEnable(self)
end

function WorldDrillDes:OnDisable()
  self:OnReturnClick()
  self:DeleteTimer()
  base.OnDisable(self)
end

function WorldDrillDes:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAllyDrillStageChange, self.OnStageChange)
  self:AddUIListener(EventId.OnAllyDrillBossInfoGet, self.RefreshBossData)
  
  function self:OnSingleMarchStateUpdate(matchUUID)
    if not self.data then
      return
    end
    if self.data.uuid ~= matchUUID then
      return
    end
    self.marchInfo = CS.SceneManager.World:GetMarch(self.data.uuid)
    self.bossInfo = self.marchInfo.allianceBoss
    self:RefreshBossStatus()
  end
  
  self:AddUIListener(EventId.SingleMarchStateUpdate, self.OnSingleMarchStateUpdate)
end

function WorldDrillDes:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnAllyDrillStageChange, self.OnStageChange)
  self:RemoveUIListener(EventId.OnAllyDrillBossInfoGet, self.RefreshBossData)
  self:RemoveUIListener(EventId.SingleMarchStateUpdate, self.OnSingleMarchStateUpdate)
end

function WorldDrillDes:OnStageChange(stage)
  if stage ~= AllyDrillStage.PrepareStage then
    self.view.ctrl:CloseSelf()
  end
end

function WorldDrillDes:ComponentDefine()
  self.bonusNode = self:AddComponent(UIBaseComponent, "BuildInfo/Bonus")
  self.btnsNode = self:AddComponent(UIBaseComponent, "BuildInfo/btns")
  self.nameTxt = self:AddComponent(UIText, "BuildInfo/allyNameTxt")
  self.content = self:AddComponent(UIBaseContainer, "BuildInfo/ScrollView/Viewport/Content")
  self.donateBtn = self:AddComponent(UIButton, "BuildInfo/btns/DonateBtn")
  self.donateBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickDonateBtn()
  end)
  self.goBtn = self:AddComponent(UIButton, "BuildInfo/btns/GoBtn")
  self.goBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickGoBtn()
  end)
  self.rewardBtn = self:AddComponent(UIButton, "BuildInfo/btns/RewardBtn")
  self.rewardBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickRewardBtn()
  end)
  self.infoBtn = self:AddComponent(UIButton, "BuildInfo/Bonus/InfoBtn")
  self.infoBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickInfoBtn()
  end)
  self.timeBtn = self:AddComponent(UIButton, "BuildInfo/down/timeLabel/timeBtn")
  self.timeBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickTimeBtn()
  end)
  self.tip = self:AddComponent(UIButton, "BuildInfo/Bonus/Tip")
  self.tip:SetActive(false)
  local closeTipBtn = self:AddComponent(UIButton, "BuildInfo/Bonus/Tip/closeTipBtn")
  closeTipBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.tip:SetActive(false)
  end)
  self.bonusTxt = self:AddComponent(UIText, "BuildInfo/Bonus/bonusTxt")
  self.timeLabel = self:AddComponent(UIText, "BuildInfo/down/timeLabel")
  self.head = self:AddComponent(UICommonHead, "BuildInfo/Bonus/Tip/TipBg/head")
  self.mvpNameTxt = self:AddComponent(UIText, "BuildInfo/Bonus/Tip/TipBg/nameTxt")
  self.TipBg = self:AddComponent(UIBaseComponent, "BuildInfo/Bonus/Tip/TipBg")
  self.tipTxt = self:AddComponent(UIBaseComponent, "BuildInfo/Bonus/Tip/tipTxt")
  self.animator = self:AddComponent(UIAnimator, "")
  self.main_obj_canvas = self:AddComponent(UICanvasGroup, "BuildInfo")
  self.des_obj_canvas = self:AddComponent(UICanvasGroup, "BuildDetails")
  self.main_obj_canvas:SetAlpha(1)
  self.des_obj_canvas:SetAlpha(1)
  self.tankNode = self:AddComponent(UIBaseComponent, "BuildInfo/bossTankNode")
  self.tankDamageSlider = self:AddComponent(UISlider, "BuildInfo/bossTankNode/damageSlider")
  self.tankDamageSliderTxt = self:AddComponent(UIText, "BuildInfo/bossTankNode/damageSlider/damageSliderTxt")
  self.sandWormNode = self:AddComponent(UIBaseComponent, "BuildInfo/bossSandWormNode")
  self.sandWormHpSlider = self:AddComponent(UISlider, "BuildInfo/bossSandWormNode/sHpSlider")
  self.sandWormHpSliderTxt = self:AddComponent(UIText, "BuildInfo/bossSandWormNode/sHpSlider/sHpSliderTxt")
  self.sandWormEmojNode = self:AddComponent(UIBaseComponent, "BuildInfo/bossSandWormNode/Boss/bossIcon/emoj")
  self.sandWormBossIcon = self:AddComponent(UIImage, "BuildInfo/bossSandWormNode/Boss/bossIcon")
  self.sandWormBossEmoj = self:AddComponent(UIImage, "BuildInfo/bossSandWormNode/Boss/bossIcon/emoj/bossEmoj")
  self.sandWormBossStatusTxt = self:AddComponent(UIText, "BuildInfo/bossSandWormNode/Boss/bossStatusDesc")
  self.sandWormDescTxt = self:AddComponent(UIText, "BuildInfo/bossSandWormNode/BossDesc")
end

function WorldDrillDes:ComponentDestroy()
end

function WorldDrillDes:DataDefine()
  self.data = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

function WorldDrillDes:DataDestroy()
  self.data = nil
end

function WorldDrillDes:SetAllCellDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function WorldDrillDes:RefreshData(data)
  self.data = data
  DataCenter.AllyDrillDataManager:SendMsgAllianceBossRewardInfo()
  DataCenter.AllyDrillDataManager:SendMsgAllianceBossActInfo()
  DataCenter.AllyDrillDataManager:SendMsgAllianceBossDetail(data.uuid)
  self.marchInfo = CS.SceneManager.World:GetMarch(data.uuid)
  if not self.marchInfo then
    return
  end
  self.isMine = self.marchInfo.allianceUid == LuaEntry.Player.allianceId
  self.bossInfo = self.marchInfo.allianceBoss
  self.bossType = DataCenter.AllyDrillDataManager:GetBossType()
  self:RefreshView()
end

function WorldDrillDes:RefreshBossData(bossData)
  if bossData.uuid ~= self.data.uuid then
    return
  end
  if not self.bossInfo then
    self.bossInfo = {}
  end
  self.bossData = bossData
  self.bossInfo.battleEndTime = bossData.battleEndTime
  self.bossInfo.damage = bossData.damage
  self.bossInfo.readyTime = bossData.readyTime
  self.bossInfo.battleStartTime = bossData.battleStartTime
  self.bossInfo.maxDamage = bossData.maxDamage
  self.bossInfo.lv = bossData.lv
  self:RefreshView()
end

function WorldDrillDes:RefreshView()
  if not self.marchInfo then
    return
  end
  local abbr = self.marchInfo.allianceAbbr
  local allianceName = self.marchInfo.allianceName
  self.nameTxt:SetLocalText(2010375, abbr, self.bossInfo.lv)
  self:RefreshTime()
  self:RefreshBossStatus()
  self:RefreshReward()
  self:RefreshBonus()
  self:RefreshBtns()
  self:AddTimer()
end

function WorldDrillDes:RefreshTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local nextTime
  if now < self.bossInfo.readyTime then
    self.stage = AllyDrillStage.PrepareStage
    nextTime = self.bossInfo.readyTime
    self.timeLabel:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(nextTime - now))
  elseif self.bossInfo.battleStartTime <= 0 then
    if self.bossInfo.actEndTime then
      if now < self.bossInfo.actEndTime then
        self.stage = AllyDrillStage.ReadyStage
        nextTime = self.bossInfo.actEndTime
        self.timeLabel:SetLocalText(2010395, UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(nextTime - now))
      else
        self.stage = AllyDrillStage.End
        self.timeLabel:SetLocalText(2010333)
      end
    else
      self.stage = AllyDrillStage.ReadyStage
      self.timeLabel:SetLocalText(2010349)
    end
  elseif now < self.bossInfo.battleEndTime then
    self.stage = AllyDrillStage.AttackStage
    if self.bossType == AllyDrillBoss.TankBoss or self.bossType == AllyDrillBoss.RoadHog then
      nextTime = self.bossInfo.battleEndTime
      self.timeLabel:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(nextTime - now))
      DataCenter.AllyDrillDataManager:SetHasClickedAttackBtn()
    elseif self.bossType == AllyDrillBoss.HugeSandWorm then
      local s3Data = self.bossInfo.dataS3
      local bossIsAlive = s3Data.stage < 3 or s3Data.stage == 3 and 0 < s3Data.curHp
      if bossIsAlive then
        nextTime = self.bossInfo.battleEndTime
        self.timeLabel:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(nextTime - now))
        DataCenter.AllyDrillDataManager:SetHasClickedAttackBtn()
      else
        self.timeLabel:SetLocalText(2010333)
      end
    end
  else
    self.stage = AllyDrillStage.SettleStage
    self.timeLabel:SetLocalText(2010333)
  end
  self.timeBtn:SetActive(nextTime)
  self.nextTime = nextTime
  if self.bossType == AllyDrillBoss.HugeSandWorm and self.isDizziness then
    local s3Data = self.bossInfo.dataS3
    local dizzinessTime = s3Data and s3Data.dizzinessTime or 0
    if now > dizzinessTime then
      self.isDizziness = false
      self.sandWormEmojNode:SetActive(false)
      self.sandWormBossStatusTxt:SetActive(false)
    else
      local dizzinessName = s3Data.dizzinessUser and s3Data.dizzinessUser.name or ""
      self.sandWormBossStatusTxt:SetLocalText("new_alliance_boss_tips_17", dizzinessName, UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(dizzinessTime - now))
    end
  end
end

function WorldDrillDes:RefreshBossStatus()
  self.tankNode:SetActive(false)
  self.sandWormNode:SetActive(false)
  if self.bossType == AllyDrillBoss.TankBoss or self.bossType == AllyDrillBoss.RoadHog then
    self.tankNode:SetActive(true)
    local abbr = self.marchInfo.allianceAbbr
    self.nameTxt:SetLocalText(2010375, abbr, self.bossInfo.lv)
    if self.stage == AllyDrillStage.PrepareStage or self.stage == AllyDrillStage.ReadyStage or self.stage == AllyDrillStage.End then
      self.tankDamageSlider:SetActive(false)
    else
      self.tankDamageSlider:SetActive(true)
      if self.bossInfo.maxDamage <= 0 then
        self.tankDamageSlider:SetValue(1)
        self.tankDamageSliderTxt:SetText(string.GetFormattedStr(self.bossInfo.damage) .. "/...")
      else
        self.tankDamageSlider:SetValue(self.bossInfo.damage / self.bossInfo.maxDamage)
        self.tankDamageSliderTxt:SetText(string.GetFormattedStr(self.bossInfo.damage) .. "/" .. string.GetFormattedStr(self.bossInfo.maxDamage))
      end
    end
  elseif self.bossType == AllyDrillBoss.HugeSandWorm then
    self.sandWormNode:SetActive(true)
    local s3Data = self.bossInfo.dataS3 or "?"
    self.nameTxt:SetLocalText("new_alliance_boss_tips_14", s3Data.stage)
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.marchInfo.monsterId)
    local monster_icon = monster and monster.pic or ""
    if not string.IsNullOrEmpty(monster_icon) then
      self.sandWormBossIcon:LoadSpriteAuto(LoadPath.HeroIconsSmallPath .. monster_icon)
    end
    local monster_desc = monster and Localization:GetString(monster.desc) or ""
    self.sandWormDescTxt:SetText(monster_desc)
    if self.stage == AllyDrillStage.PrepareStage or self.stage == AllyDrillStage.ReadyStage or self.stage == AllyDrillStage.End then
      self.sandWormHpSlider:SetActive(false)
      self.sandWormEmojNode:SetActive(false)
    else
      self.sandWormHpSlider:SetActive(true)
      local curHp = s3Data and s3Data.curHp or 0
      local totalHp = s3Data and s3Data.totalHp or 1
      local sliderValue = curHp / totalHp
      self.sandWormHpSlider:SetValue(sliderValue)
      self.sandWormBossStatusTxt:SetActive(false)
      if self.stage == AllyDrillStage.SettleStage and 0 < s3Data.curHp then
        self.sandWormHpSliderTxt:SetLocalText("new_alliance_boss_tips_21")
        self.sandWormEmojNode:SetActive(false)
      else
        self.sandWormHpSliderTxt:SetText(string.format("%.2f", sliderValue * 100) .. "%")
        local dizziness = s3Data and s3Data.dizzinessState == 1 or false
        local dizzinessTime = s3Data and s3Data.dizzinessTime or 0
        local severTimeNow = UITimeManager:GetInstance():GetServerTime()
        if dizziness and dizzinessTime > severTimeNow then
          self.sandWormEmojNode:SetActive(true)
          self.sandWormBossEmoj:LoadSprite("Assets/Main/Sprites/UI/LWAllyDrillBossEmoj/biaaoqing_xuanyun_stun.png")
          self.sandWormBossStatusTxt:SetActive(true)
          self.isDizziness = true
        else
          self.sandWormEmojNode:SetActive(false)
          self.isDizziness = false
        end
      end
    end
  end
end

function WorldDrillDes:RefreshBtns()
  if self.isMine then
    self.btnsNode:SetActive(false)
    if self.stage == AllyDrillStage.PrepareStage then
      self.goBtn:SetActive(true)
      CS.UIGray.SetGray(self.goBtn.transform, true, true)
    elseif self.stage == AllyDrillStage.ReadyStage then
      self.goBtn:SetActive(true)
      CS.UIGray.SetGray(self.goBtn.transform, false, true)
    else
      self.goBtn:SetActive(false)
    end
  else
    self.btnsNode:SetActive(false)
  end
end

function WorldDrillDes:RefreshBonus()
  if (self.stage == AllyDrillStage.AttackStage or self.stage == AllyDrillStage.SettleStage) and self.bossType == AllyDrillBoss.TankBoss then
    self.bonusNode:SetActive(true)
    local curBonus = 1
    if self.bossData then
      curBonus = self.bossData.bonus
    elseif self.isMine then
      local actInfo = DataCenter.AllyDrillDataManager:GetActInfo()
      if actInfo and actInfo.data then
        curBonus = actInfo.data.currBonus
      end
    end
    curBonus = math.max(1, curBonus)
    self.bonusTxt:SetLocalText(2010335, curBonus)
  else
    self.bonusNode:SetActive(false)
  end
end

function WorldDrillDes:RefreshReward()
  self:SetAllCellDestroy()
  local container = self.content
  local list = {}
  if self.bossData then
    list = self.bossData.reward or {}
  elseif self.isMine then
    list = DataCenter.AllyDrillDataManager:GetCurAllyRewardData() or {}
  end
  for i = 1, table.length(list) do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if IsNull(request.gameObject) then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(container.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_sizeDelta(150, 150)
      go.transform:Set_pivot(0, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = container:AddComponent(UICommonResItem, nameStr)
      local data = list[i]
      local param = UICommonResItem.Param.New()
      param.rewardType = data.type
      if type(data.value) == "table" then
        param.itemId = data.value.id
        param.count = data.value.num
      else
        param.itemId = data.type
        param.count = data.value
      end
      param.rewardType = data.type
      param.heroUuid = data.heroUuid
      param.isHeroBox = data.isHeroBox
      cell:ReInit(param)
    end)
  end
end

function WorldDrillDes:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function WorldDrillDes:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function WorldDrillDes:OnInfoClick()
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

function WorldDrillDes:OnReturnClick()
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

function WorldDrillDes:OnClickDonateBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDrillDonate, {anim = true})
end

function WorldDrillDes:OnClickGoBtn()
  if self.stage == AllyDrillStage.PrepareStage then
    UIUtil.ShowTipsId(2010381)
  elseif self.stage == AllyDrillStage.ReadyStage then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      DataCenter.AllyDrillDataManager:SendMsgAllianceBossStart()
    else
      UIUtil.ShowTipsId(2010355)
    end
  end
end

function WorldDrillDes:OnClickRewardBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDrillRank, {anim = true})
end

function WorldDrillDes:OnClickInfoBtn()
  self.tip:SetActive(true)
  local mvpData = self.bossData.mvp
  self.TipBg:SetActive(mvpData)
  self.tipTxt:SetActive(not mvpData)
  if mvpData then
    self.mvpNameTxt:SetText(mvpData.name)
    self.head:SetHeadAndFrame(mvpData.uid, mvpData.pic, mvpData.picVer, false, mvpData.headSkinId, mvpData.headSkinET)
  end
end

function WorldDrillDes:OnClickTimeBtn()
  if self.nextTime then
    local localTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.nextTime)
    local content = Localization:GetString(2010345, localTime)
    UIUtil.ShowBubbleTips(content, self.timeBtn.transform.position, 0, -30, 0)
  end
end

return WorldDrillDes
