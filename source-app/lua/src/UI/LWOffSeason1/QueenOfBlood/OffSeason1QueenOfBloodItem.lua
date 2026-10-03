local base = UIBaseContainer
local OffSeason1QueenOfBloodItem = BaseClass("OffSeason1QueenOfBloodItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function OffSeason1QueenOfBloodItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function OffSeason1QueenOfBloodItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OffSeason1QueenOfBloodItem:ComponentDefine()
  self.imgBgWhite = self:AddComponent(UIImage, "BgWhite")
  self.imgBgYellow = self:AddComponent(UIImage, "BgYellow")
  self.imgBgGray = self:AddComponent(UIImage, "BgGray")
  self.imgBgRed = self:AddComponent(UIImage, "BgRed")
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.imgIndex = self:AddComponent(UIImage, "IndexImage")
  self.textIndex = self:AddComponent(UITextMeshProUGUIEx, "IndexImage/IndexText")
  self.bossStateRect = self:AddComponent(UIBaseComponent, "BossStateRect")
  self.textBossName = self:AddComponent(UITextMeshProUGUIEx, "BossStateRect/BossNameText")
  self.sliderBoss = self:AddComponent(UISlider, "BossStateRect/HpBossSlider/BossSlider")
  self.textBossSlider = self:AddComponent(UITextMeshProUGUIEx, "BossStateRect/HpBossSlider/BossTextSlider")
  self.btnBossAttack = self:AddComponent(UIButton, "BossStateRect/BossAttackButton")
  self.btnBossAttack:SetOnClick(function()
    self:OnBtnBossAttackClick()
  end)
  self.buildingStateRect = self:AddComponent(UIBaseComponent, "BuildingStateRect")
  self.btnPos = self:AddComponent(UIButton, "BuildingStateRect/PosBtn")
  self.btnPos:SetOnClick(function()
    self:OnBtnPosClick()
  end)
  self.textPos = self:AddComponent(UITextMeshProUGUIEx, "BuildingStateRect/PosBtn/PosText")
  self.btnAllianceNum = self:AddComponent(UIButton, "IndexImage/AllianceNumBtn")
  self.btnAllianceNum:SetOnClick(function()
    self:OnBtnAllianceNumClick()
  end)
  self.textAllianceNum = self:AddComponent(UITextMeshProUGUIEx, "IndexImage/AllianceNumBtn/allianceNum")
  self.slider = self:AddComponent(UISlider, "BuildingStateRect/HpSlider/Slider")
  self.imgFill = self:AddComponent(UIImage, "BuildingStateRect/HpSlider/Slider/Fill Area/Fill")
  self.textSlider = self:AddComponent(UITextMeshProUGUIEx, "BuildingStateRect/HpSlider/TextSlider")
  self.rectReady = self:AddComponent(UIBaseComponent, "BuildingStateRect/rect_ready")
  self.rectAlliance = self:AddComponent(UIBaseComponent, "BuildingStateRect/rect_ready/rect_alliance")
  self.btnCancel = self:AddComponent(UIButton, "BuildingStateRect/rect_ready/rect_alliance/CancelButton")
  self.btnCancel:SetOnClick(function()
    self:OnBtnCancelClick()
  end)
  self.btnDefence = self:AddComponent(UIButton, "BuildingStateRect/rect_ready/rect_alliance/DefenceButton")
  self.btnDefence:SetOnClick(function()
    self:OnBtnDefenceClick()
  end)
  self.textDefenceMember = self:AddComponent(UITextMeshProUGUIEx, "BuildingStateRect/rect_ready/DefenceMemberText")
  self.rectDoing = self:AddComponent(UIBaseComponent, "BuildingStateRect/rect_doing")
  self.btnDefenceNum = self:AddComponent(UIButton, "BuildingStateRect/rect_doing/DefenceNumButton")
  self.btnDefenceNum:SetOnClick(function()
    self:OnBtnDefenceNumClick()
  end)
  self.defenceState = self:AddComponent(UIBaseComponent, "BuildingStateRect/rect_doing/DefenceState")
  self.textDefenceNum = self:AddComponent(UITextMeshProUGUIEx, "BuildingStateRect/rect_doing/DefenceState/LW_Btn_Common_New_Base/DefenceNumText")
  self.rectOver = self:AddComponent(UIBaseComponent, "BuildingStateRect/rect_over")
  self.textDefeat = self:AddComponent(UITextMeshProUGUIEx, "BuildingStateRect/rect_over/DefeatText")
  self.textVictory = self:AddComponent(UITextMeshProUGUIEx, "BuildingStateRect/rect_over/VictoryText")
  self.textDefenceBtnNum = self:AddComponent(UITextMeshProUGUIEx, "BuildingStateRect/rect_doing/DefenceNumButton/LW_Btn_Common_New_Base/DefenceNumBtnText")
  self.sliderRect = self:AddComponent(UIBaseComponent, "BuildingStateRect/HpSlider")
  self.btnLv = self:AddComponent(UIButton, "LvBtn")
  self.btnLv:SetOnClick(function()
    self:OnBtnLvClick()
  end)
end

function OffSeason1QueenOfBloodItem:ComponentDestroy()
  self.imgBgWhite = nil
  self.imgBgYellow = nil
  self.imgBgGray = nil
  self.imgBgRed = nil
  self.imgIcon = nil
  self.imgIndex = nil
  self.textIndex = nil
  self.bossStateRect = nil
  self.textBossName = nil
  self.sliderBoss = nil
  self.textBossSlider = nil
  self.btnBossAttack = nil
  self.buildingStateRect = nil
  self.btnPos = nil
  self.textPos = nil
  self.btnAllianceNum = nil
  self.textAllianceNum = nil
  self.slider = nil
  self.imgFill = nil
  self.textSlider = nil
  self.rectReady = nil
  self.rectAlliance = nil
  self.btnCancel = nil
  self.btnDefence = nil
  self.textDefenceMember = nil
  self.rectDoing = nil
  self.btnDefenceNum = nil
  self.defenceState = nil
  self.textDefenceNum = nil
  self.rectOver = nil
  self.textDefeat = nil
  self.textVictory = nil
  self.textDefenceBtnNum = nil
  self.sliderRect = nil
  self.btnLv = nil
end

function OffSeason1QueenOfBloodItem:DataDefine()
  self.cfgId = ""
  self.isBoss = false
  self.monsterInfo = nil
  self.monsterPos = nil
  self.state = 1
  self.isR4orR5 = false
  self.isPrecedence = false
  self.haveDefenced = false
  self.hpRate = 0
  self.defendCount = 0
  self.allianceCount = 0
  self.isVictory = false
  self.cityPos = nil
end

function OffSeason1QueenOfBloodItem:DataDestroy()
  self.state = nil
  self.isBoss = nil
  self.isR4orR5 = nil
  self.isPrecedence = nil
  self.haveDefenced = false
  self.isVictory = nil
  self.cityPos = nil
  self.index = nil
  self.hpRate = nil
  self.defendCount = nil
  self.allianceCount = nil
  self.itemInfo = nil
  self.cfgId = nil
  self.monsterInfo = nil
  self.monsterPos = nil
  self.monsterUuid = nil
end

function OffSeason1QueenOfBloodItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshQueenOfBloodActivityInfoSingleMonster, self.OnRefreshQueenOfBloodActivityInfoSingleMonster)
end

function OffSeason1QueenOfBloodItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshQueenOfBloodActivityInfoSingleMonster, self.OnRefreshQueenOfBloodActivityInfoSingleMonster)
  base.OnRemoveListener(self)
end

function OffSeason1QueenOfBloodItem:UpdateCityInfo()
  self.itemInfo = DataCenter.OffSeason1QueenOfBloodManager:GetCityInfoById(self.cfgId)
  if self.itemInfo then
    self:RefreshData()
    self:RefreshUI()
    self:RefreshUIByData()
  end
end

function OffSeason1QueenOfBloodItem:UpdateBossInfo()
  self.itemInfo = DataCenter.OffSeason1QueenOfBloodManager:GetMonsterInfoByUuid(self.monsterUuid)
  if self.itemInfo then
    self:RefreshBossData()
  end
end

function OffSeason1QueenOfBloodItem:ReInit(index, itemInfo)
  self.index = index
  self.itemInfo = itemInfo
  self.isBoss = index == 0
  self.defendCountMax = DataCenter.OffSeason1QueenOfBloodManager:GetMaxDefendNum()
  self:RefreshUI()
  if self.isBoss then
    self:RefreshBossData()
  else
    self:RefreshData()
    self:RefreshUIByData()
  end
end

function OffSeason1QueenOfBloodItem:RefreshBossData()
  self.monsterInfo = self.itemInfo
  self.monsterUuid = self.monsterInfo.monsterUuid
  local monsterCfg = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.monsterInfo.monsterConfigId)
  self.monsterPos = SceneUtils.IndexToTilePos(self.monsterInfo.point, ForceChangeScene.World)
  self.textBossName:SetLocalText(monsterCfg.name)
  self.imgIcon:LoadSpriteAuto(monsterCfg:GetIcon())
  local progressValue = Mathf.Clamp(self.monsterInfo.hp / 100, 0, 1)
  self.sliderBoss:SetValue(progressValue)
  self.textBossSlider:SetText(string.percentage(self.monsterInfo.hp, 100, 2))
  self.btnLv:SetActive(false)
end

function OffSeason1QueenOfBloodItem:RefreshData()
  self.state = DataCenter.OffSeason1QueenOfBloodManager:GetQueenOfBloodActivityStage()
  self.isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  self.isPrecedence = self.itemInfo.defendInfo.isChoose
  self.haveDefenced = self.itemInfo.defendInfo.containSelf
  self.isVictory = self.itemInfo.defendInfo.isDefendSuccess
  self.hpRate = self.itemInfo.defendInfo.hp
  self.defendCount = self.itemInfo.defendInfo.defendCount
  self.allianceCount = self.itemInfo.defendInfo.chooseCount
  self.cfgId = self.itemInfo.cityId
  self.battleLv = self.itemInfo.defendInfo.battleLv
  if not self.isBoss then
    local template = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cfgId)
    self.cityPos = template.pos
  end
end

function OffSeason1QueenOfBloodItem:RefreshUI()
  self.imgBgWhite.gameObject:SetActive(not self.isBoss)
  self.imgIndex.gameObject:SetActive(not self.isBoss)
  self.buildingStateRect.gameObject:SetActive(not self.isBoss)
  self.imgBgRed.gameObject:SetActive(self.isBoss)
  self.bossStateRect.gameObject:SetActive(self.isBoss)
end

function OffSeason1QueenOfBloodItem:RefreshUIByData()
  if self.isBoss then
    self.imgBgGray.gameObject:SetActive(false)
    self.imgBgYellow.gameObject:SetActive(false)
  else
    local template = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cfgId)
    if template then
      self.imgIcon:LoadSprite(template:GetIconPath(false))
    end
    local ready = self.state == QueenOfBloodActivityState.preBattleShow
    local readyEnd = self.state == QueenOfBloodActivityState.preBattleShowNoApplication
    local doing = self.state == QueenOfBloodActivityState.battle
    local over = self.state == QueenOfBloodActivityState.postBattleShow or self.state == QueenOfBloodActivityState.activityEndShow
    self.textPos:SetText("<u>" .. Localization:GetString("300015", self.cityPos.x, self.cityPos.y) .. "</u>")
    self.sliderRect.gameObject:SetActive(doing or over)
    self.btnAllianceNum.gameObject:SetActive(true)
    self.textAllianceNum:SetText(self.allianceCount)
    self.rectReady.gameObject:SetActive(ready or readyEnd)
    self.rectDoing.gameObject:SetActive(doing)
    self.rectOver.gameObject:SetActive(over)
    self.textIndex:SetText(self.index)
    if self.battleLv and self.battleLv > 0 then
      self.btnLv:SetActive(true)
      self.btnLv:LoadSprite(QueenOfBloodLvImgPath[self.battleLv])
    else
      self.btnLv:SetActive(false)
    end
    if ready then
      self.imgBgGray.gameObject:SetActive(false)
      self.imgBgYellow.gameObject:SetActive(self.isPrecedence)
      if self.isR4orR5 then
        self.rectAlliance.gameObject:SetActive(true)
        self.btnCancel.gameObject:SetActive(self.isPrecedence)
        self.btnDefence.gameObject:SetActive(not self.isPrecedence)
        self.textDefenceMember.gameObject:SetActive(false)
      else
        self.rectAlliance.gameObject:SetActive(false)
        self.textDefenceMember.gameObject:SetActive(self.isPrecedence)
      end
    elseif readyEnd then
      self.imgBgGray.gameObject:SetActive(false)
      self.imgBgYellow.gameObject:SetActive(self.isPrecedence)
      self.rectAlliance.gameObject:SetActive(false)
      self.textDefenceMember.gameObject:SetActive(self.isPrecedence)
    elseif doing then
      self.imgBgGray.gameObject:SetActive(false)
      self.imgBgYellow.gameObject:SetActive(self.isPrecedence)
      if self.isPrecedence then
        self.btnDefenceNum.gameObject:SetActive(not self.haveDefenced)
        self.defenceState.gameObject:SetActive(self.haveDefenced)
        if self.haveDefenced then
          self.textDefenceNum:SetText(self.defendCount .. "/" .. self.defendCountMax)
        else
          self.textDefenceBtnNum:SetText(self.defendCount .. "/" .. self.defendCountMax)
        end
      else
        self.btnDefenceNum.gameObject:SetActive(false)
        self.defenceState.gameObject:SetActive(true)
        self.textDefenceNum:SetText(self.defendCount .. "/" .. self.defendCountMax)
      end
      self:UpdateHp()
    elseif over then
      self.imgBgYellow.gameObject:SetActive(false)
      self.textVictory.gameObject:SetActive(self.isVictory)
      self.textDefeat.gameObject:SetActive(not self.isVictory)
      self.imgBgGray.gameObject:SetActive(not self.isVictory)
      self:UpdateHp()
    end
  end
end

function OffSeason1QueenOfBloodItem:UpdateHp()
  if self.hpRate then
    self.textSlider:SetText(string.formatDecimalDown(self.hpRate, 2) .. "%")
    if self.hpRate == 100 then
      self.imgFill:LoadSprite(string.format("Assets/Main/Sprites/UI/UIBuildBubble/lyp_common_jindutiao_lv.png"))
    else
      self.imgFill:LoadSprite(string.format("Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_tongyong_jindutiao_hong.png"))
    end
    self.slider:SetValue(self.hpRate / 100)
  end
end

function OffSeason1QueenOfBloodItem:OnBtnBossAttackClick()
  if self.monsterPos ~= nil and self.monsterPos.x ~= nil and self.monsterPos.y ~= nil then
    local v3 = SceneUtils.TileToWorld(self.monsterPos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetSourceServerId())
  end
end

function OffSeason1QueenOfBloodItem:OnBtnPosClick()
  if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
    local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetSourceServerId())
  end
end

function OffSeason1QueenOfBloodItem:OnBtnAllianceNumClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIQueenOfBloodAllianceListPop, self.cfgId)
end

function OffSeason1QueenOfBloodItem:OnBtnCancelClick()
  UIUtil.ShowNoToggleSecondMessage("", Localization:GetString("s1_QueenChallenge_ready_cancelConfirm"), 2, "110006", "110106", function()
    DataCenter.OffSeason1QueenOfBloodManager:SendBloodyQueenS1RestChooseCityDefendSet(-1, self.cfgId)
  end, function(needSellConfirm)
  end, function()
  end, nil, nil, nil, nil, nil, nil, false)
end

function OffSeason1QueenOfBloodItem:OnBtnDefenceClick()
  DataCenter.OffSeason1QueenOfBloodManager:SendBloodyQueenS1RestChooseCityDefendSet(1, self.cfgId)
end

function OffSeason1QueenOfBloodItem:OnBtnDefenceNumClick()
  self:OnBtnPosClick()
end

function OffSeason1QueenOfBloodItem:OnBtnLvClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIQueenOfBloodMonsterTip, {anim = true}, self.battleLv)
end

function OffSeason1QueenOfBloodItem:OnPushBloodQueenHpChange(cityInfo)
  if self.cfgId and cityInfo and self.cfgId == cityInfo.cityId then
    self:UpdateCityInfo()
  end
end

function OffSeason1QueenOfBloodItem:OnRefreshQueenOfBloodActivityInfoSingleMonster(monsterUuid)
  if self.monsterUuid and self.monsterUuid == monsterUuid then
    self:UpdateBossInfo()
  end
end

return OffSeason1QueenOfBloodItem
