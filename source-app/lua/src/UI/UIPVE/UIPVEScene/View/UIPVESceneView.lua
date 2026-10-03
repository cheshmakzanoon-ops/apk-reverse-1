local UIPVESceneView = BaseClass("UIPVESceneView", UIBaseView)
local CampRestraintItem = require("UI.UIFormation.UIFormationTableNew.Component.CampRestraintItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ContentSizeFitter = CS.UnityEngine.UI.ContentSizeFitter
local PVEHeroSelectList = require("UI.UIPVE.UIPVEScene.Component.PVEHeroSelectList")
local UIPVEHeadBar = require("UI.UIPVE.UIPVEScene.Component.UIPVEHeadBar")
local UIPVEBlood = require("UI.UIPVE.UIPVEScene.Component.UIPVEBlood")
local PveBuffCell = require("UI.UIPVE.UIPVEScene.Component.PveBuffCell")
local Const = require("Scene.BattlePveModule.Const")
local BattleConst = require("Scene.PVEBattleLevel.Const")
local topAlign_path = "Root/TopAlign"
local topAlign2_path = "TopAlign2"
local rightContainer_path = "TopAlign2/Right"
local leftContent_path = topAlign2_path .. "/LeftBuff"
local rightContent_path = topAlign2_path .. "/RightBuff"
local leftBtn_path = topAlign2_path .. "/Left/BtnLeft"
local rightBtn_path = topAlign2_path .. "/Right/BtnRight"
local left_image_path = topAlign2_path .. "/Left/Image"
local leftSoldierNum_path = topAlign2_path .. "/Left/leftNum"
local rightSoldierNum_path = topAlign2_path .. "/Right/rightNum"
local leftPowerNum_path = "leftPower"
local rightPowerNum_path = "rightPower"
local leftPowerGuideEffect_path = "leftPower/leftPowerGuideEffect"
local rightPowerGuideEffect_path = "rightPower/rightPowerGuideEffect"
local leftBloodLayer_path = topAlign2_path .. "/Left/leftLayer"
local rightBloodLayer_path = topAlign2_path .. "/Right/rightLayer"
local _cp_img_normal_left = topAlign2_path .. "/Left/leftIconBg/objUserHead_left/ImageNormal_left"
local _cp_img_normal_right = topAlign2_path .. "/Right/rightIconBg/objUserHead_right/ImageNormal_right"
local _cp_imgUserHead_left = topAlign2_path .. "/Left/leftIconBg/objUserHead_left/imgUserHead_left"
local _cp_imgHeadBg_left = topAlign2_path .. "/Left/leftIconBg/objUserHead_left/HeadBtnL"
local _cp_imgHeadFg_left = topAlign2_path .. "/Left/leftIconBg/objUserHead_left/HeadFgL"
local _cp_imgUserHead_right = topAlign2_path .. "/Right/rightIconBg/objUserHead_right/imgUserHead_right"
local _cp_imgHeadBg_right = topAlign2_path .. "/Right/rightIconBg/objUserHead_right/HeadBtnR"
local _cp_imgHeadFg_right = topAlign2_path .. "/Right/rightIconBg/objUserHead_right/HeadFgR"
local _cp_CampRestraintItem_btn = topAlign2_path .. "/leftCamp"
local _cp_CampRestraintItem_btn_right = topAlign2_path .. "/rightCamp"
local _cp_CampRestraintItem_Left = topAlign2_path .. "/leftCamp/LeftCampRestraintItem"
local _cp_CampRestraintItem_Left_Add = topAlign2_path .. "/leftCamp/camp_faction"
local _cp_CampRestraintItem_Right = topAlign2_path .. "/rightCamp/RightCampRestraintItem"
local _cp_CampRestraintItem_Left_txt = topAlign2_path .. "/leftCamp/camp_faction/desLayout/restraintText"
local saveBtn_path = "Root/saveBtn"
local saveBtnTxt_path = "Root/saveBtn/saveBtnTxt"
local btnStartPVE = "Root/setBtn"
local btnStartPVE_limit_text = btnStartPVE .. "/stateTxt"
local btnStartPVE_text = btnStartPVE .. "/setText"
local btnStartPVE_icon = btnStartPVE .. "/stateTxt/PowerIcon"
local stamina_text_path = btnStartPVE .. "/staminaText"
local home_btn_path = "Root/GameObject/GameObject/Button"
local hero_list_path = "Root/GameObject/FormationHeroList"
local btn_showResult = "Root/bottomRight/btnShowResult"
local bottomRight_path = "Root/bottomRight"
local btn_speed2_path = "Root/bottomRight/Button2"
local btn_speed4_path = "Root/bottomRight/Button4"
local btn_speed6_path = "Root/bottomRight/Button6"
local result_lock_path = "Root/bottomRight/btnShowResult/lockObj"
local lock_btn_speed4_path = "Root/bottomRight/tempButton4"
local lock_btn_speed2_path = "Root/bottomRight/tempButton2"
local red_dot_path = "Root/bottomRight/redDot"
local fly_obj_path = "Root/bottomRight/flyObj"
local fly_img_path = "Root/bottomRight/flyObj/icon"
local icon_effect_path = "Root/bottomRight/flyObj/iconEffect"
local adventure_path = "Root/Adventure"
local adventure_tip_go_path = "Root/Adventure/AdventureTip"
local adventure_tip_text_path = "Root/Adventure/AdventureTip/AdventureTipText"
local raid_btn_path = "Root/Adventure/Raid"
local raid_text_path = "Root/Adventure/Raid/RaidText"
local shop_btn_path = "Root/Adventure/Shop"
local shop_text_path = "Root/Adventure/Shop/ShopText"
local guideMask_path = "guideMask"
local mask_left_path = "guideMask/leftImage"
local mask_right_path = "guideMask/rightImage"
local mask_all_path = "guideMask/totalImage"
local gray_mask_path = "grayMask"
local hideEnemyTip_path = "TopAlign2/hideHero/hideHeroTip"
local start_desc_path = "Root/StartDesc"
local speedOffset1 = 1
local speedOffset2 = 2
local speedOffset4 = 4

local function OnCreate(self)
  base.OnCreate(self)
  local levelId, triggerId, levelParam = self:GetUserData()
  self.levelId = tonumber(levelId)
  self.triggerId = tonumber(triggerId)
  self.levelParam = levelParam
  self.isShowLineup = false
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    self.ctrl:InitData(false)
  else
    self.ctrl:InitData(true)
  end
  self:BindUIComponent()
end

local function BindUIComponent(self)
  self.anim = self:AddComponent(UISimpleAnimation, guideMask_path)
  self.guideMask = self:AddComponent(UIButton, guideMask_path)
  self.guideMask:SetOnClick(function()
    self:OnClickGuideMask()
  end)
  self.guideMask:SetActive(false)
  self.gray_mask = self:AddComponent(UIButton, gray_mask_path)
  self.gray_mask:SetOnClick(function()
    self:OnClickGrayMask()
  end)
  self.gray_mask:SetActive(false)
  self.mask_all = self:AddComponent(UIBaseContainer, mask_all_path)
  self.mask_left = self:AddComponent(UIBaseContainer, mask_left_path)
  self.mask_right = self:AddComponent(UIBaseContainer, mask_right_path)
  self.topAlign = self:AddComponent(UIBaseContainer, topAlign_path)
  self.topAlign:SetActive(false)
  self.topAlign2 = self:AddComponent(UIBaseContainer, topAlign2_path)
  self.topAlign2:SetActive(true)
  self.rightContainer = self:AddComponent(UIBaseContainer, rightContainer_path)
  self.rightContainer:SetActive(true)
  self.leftContent = self:AddComponent(UIBaseContainer, leftContent_path)
  self.leftContent:SetActive(false)
  self.rightContent = self:AddComponent(UIBaseContainer, rightContent_path)
  self.rightContent:SetActive(false)
  self.leftSoldierNum = self:AddComponent(UITweenNumberText, leftSoldierNum_path)
  self.leftSoldierNum:SetSeparator(true)
  self.rightSoldierNum = self:AddComponent(UITweenNumberText, rightSoldierNum_path)
  self.rightSoldierNum:SetSeparator(true)
  self.leftPowerNum = self:AddComponent(UITweenNumberText, leftPowerNum_path)
  self.leftPowerNum:SetKmg(true)
  self.rightPowerNum = self:AddComponent(UITweenNumberText, rightPowerNum_path)
  self.rightPowerNum:SetKmg(true)
  self.rightPowerNum:SetActive(true)
  self.leftPowerGuideEffect = self:AddComponent(UIBaseContainer, leftPowerGuideEffect_path)
  self.leftPowerGuideEffect:SetActive(false)
  self.rightPowerGuideEffect = self:AddComponent(UIBaseContainer, rightPowerGuideEffect_path)
  self.rightPowerGuideEffect:SetActive(false)
  self.leftImg = self:AddComponent(UIImage, left_image_path)
  self.leftHeadBar = self:AddComponent(UIPVEHeadBar, "Root/TopAlign/TopLeft")
  self.rightHeadBar = self:AddComponent(UIPVEHeadBar, "Root/TopAlign/TopRight")
  self.leftBloodLayer = self:AddComponent(UIPVEBlood, leftBloodLayer_path)
  self.rightBloodLayer = self:AddComponent(UIPVEBlood, rightBloodLayer_path)
  self._imgUserHead_left = self:AddComponent(UIPlayerHead, _cp_imgUserHead_left)
  self._imgHeadBg_left = self:AddComponent(UIImage, _cp_imgHeadBg_left)
  self._imgHeadFg_left = self:AddComponent(UIImage, _cp_imgHeadFg_left)
  self._imgUserHead_right = self:AddComponent(UIPlayerHead, _cp_imgUserHead_right)
  self._imgHeadBg_right = self:AddComponent(UIImage, _cp_imgHeadBg_right)
  self._imgHeadFg_right = self:AddComponent(UIImage, _cp_imgHeadFg_right)
  self._imgUserHead_left_normal = self:AddComponent(CircleImage, _cp_img_normal_left)
  self._imgUserHead_right_normal = self:AddComponent(CircleImage, _cp_img_normal_right)
  self.CampRestraintItem_btn = self:AddComponent(UIButton, _cp_CampRestraintItem_btn)
  self.CampRestraintItem_btn:SetOnClick(function()
    self:OnCampClick()
  end)
  self.CampRestraintItem_btn_right = self:AddComponent(UIButton, _cp_CampRestraintItem_btn_right)
  self.CampRestraintItem_btn_right:SetOnClick(function()
    self:OnRightCampClick()
  end)
  self._CampRestraintItem_Left = self:AddComponent(CampRestraintItem, _cp_CampRestraintItem_Left)
  self._CampRestraintItem_Right = self:AddComponent(CampRestraintItem, _cp_CampRestraintItem_Right)
  self._CampRestraintImg = self:AddComponent(UIImage, _cp_CampRestraintItem_Left_Add)
  self._CampRestraintItem_Left_txt = self:AddComponent(UIText, _cp_CampRestraintItem_Left_txt)
  self.leftBtn = self:AddComponent(UIButton, leftBtn_path)
  self.leftBtn:SetOnClick(function()
    self:OnLeftClick()
  end)
  self.rightBtn = self:AddComponent(UIButton, rightBtn_path)
  self.rightBtn:SetOnClick(function()
    self:OnRightClick()
  end)
  self.home_btn = self:AddComponent(UIButton, home_btn_path)
  self.home_btn:SetActive(true)
  self.home_btn:SetOnClick(function()
    self:OnHomeClick()
  end)
  self.saveBtnN = self:AddComponent(UIButton, saveBtn_path)
  self.saveBtnN:SetOnClick(function()
    self:OnClickSaveBtn()
  end)
  self.saveBtnN:SetActive(false)
  self.saveBtnTxtN = self:AddComponent(UIText, saveBtnTxt_path)
  self.saveBtnTxtN:SetLocalText(300055)
  self.btn_start = self:AddComponent(UIButton, btnStartPVE)
  self.btn_start:SetActive(true)
  self.bottomRight = self:AddComponent(UIBaseContainer, bottomRight_path)
  self.bottomRight:SetActive(false)
  self.btn_limit_text = self:AddComponent(UIText, btnStartPVE_limit_text)
  self.btn_limit_text:SetActive(true)
  self.btn_start_text = self:AddComponent(UIText, btnStartPVE_text)
  self.btn_start_text:SetLocalText(400006)
  self.btn_start_icon = self:AddComponent(UIBaseContainer, btnStartPVE_icon)
  self.stamina_text = self:AddComponent(UIText, stamina_text_path)
  self.btn_start:SetOnClick(function()
    self:OnStartPVE()
  end)
  self.btn_showResult = self:AddComponent(UIButton, btn_showResult)
  self.btn_showResult:SetOnClick(function()
    self:OnShowResult()
  end)
  self.btn_speed2 = self:AddComponent(UIButton, btn_speed2_path)
  self.btn_speed2:SetOnClick(function()
    self:OnChangeSpeed(speedOffset2)
  end)
  self.btn_speed4 = self:AddComponent(UIButton, btn_speed4_path)
  self.btn_speed4:SetOnClick(function()
    self:OnChangeSpeed(speedOffset4)
  end)
  self.btn_speed6 = self:AddComponent(UIButton, btn_speed6_path)
  self.btn_speed6:SetOnClick(function()
    self:OnChangeSpeed(speedOffset1)
  end)
  self.lock_btn_speed4 = self:AddComponent(UIButton, lock_btn_speed4_path)
  self.lock_btn_speed4:SetOnClick(function()
    self:OnClickLock(speedOffset4)
  end)
  self.lock_btn_speed2 = self:AddComponent(UIButton, lock_btn_speed2_path)
  self.lock_btn_speed2:SetOnClick(function()
    self:OnClickLock(speedOffset2)
  end)
  self.result_lock = self:AddComponent(UIBaseContainer, result_lock_path)
  self.red_dot = self:AddComponent(UIBaseContainer, red_dot_path)
  self.fly_obj = self:AddComponent(UIBaseContainer, fly_obj_path)
  self.fly_img = self:AddComponent(UIImage, fly_img_path)
  self.icon_effect = self:AddComponent(UIBaseContainer, icon_effect_path)
  self.fly_obj:SetActive(false)
  self.hero_list = self:AddComponent(PVEHeroSelectList, hero_list_path)
  self.hero_list:SetActive(true)
  self:SetShowSpeedUpConfig()
  self:CheckShowFinish()
  self:CheckShowSpeedUp()
  self.leftHeadBar:SetPlayerHead(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer)
  self.rightHeadBar:SetIcon("Assets/Main/Sprites/HeroIconsSmall/UIPVEorder_img_guai.png")
  self.leftBuffInstance = {}
  self.rightBuffInstance = {}
  self.leftBuffList = {}
  self.rightBuffList = {}
  self.hideHeroTipN = self:AddComponent(UIText, hideEnemyTip_path)
  self.hideHeroTipN:SetLocalText(302234)
  self.leftPower = 0
  self.rightPower = 0
  self.guideTime = 0
  self.canClickGuideMask = false
  self.start_desc_text = self:AddComponent(UIText, start_desc_path)
  
  function self.timer_action()
    self:TimeRefresh()
  end
  
  self.adventure_go = self:AddComponent(UIBaseContainer, adventure_path)
  self.adventure_tip_go = self:AddComponent(UIBaseContainer, adventure_tip_go_path)
  self.adventure_tip_text = self:AddComponent(UIText, adventure_tip_text_path)
  self.adventure_tip_text:SetLocalText(302271)
  self.raid_btn = self:AddComponent(UIButton, raid_btn_path)
  self.raid_btn:SetOnClick(function()
    self:OnRaidClick()
  end)
  self.raid_text = self:AddComponent(UIText, raid_text_path)
  self.raid_text:SetLocalText(302253)
  self.shop_btn = self:AddComponent(UIButton, shop_btn_path)
  self.shop_btn:SetOnClick(function()
    self:OnShopClick()
  end)
  self.shop_btn:SetActive(LuaEntry.DataConfig:CheckSwitch("APS_shop_explorer"))
  self.shop_text = self:AddComponent(UIText, shop_text_path)
  self.shop_text:SetLocalText(104241)
  local mainLvLimit = LuaEntry.DataConfig:TryGetNum("battle_config", "k20")
  self.showCamp = mainLvLimit <= DataCenter.BuildManager.MainLv
end

local function UnBindUIComponent(self)
  self:ClearLeftList()
  self:ClearRightList()
  self.selectBuffId = nil
  self.isLeftBuffId = nil
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroTips) == true then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroTips)
  end
  self.topAlign = nil
  self.topAlign2 = nil
  self.left1_army = nil
  self.left1_army_icon = nil
  self.left1_army_num = nil
  self.left2_army = nil
  self.left2_army_icon = nil
  self.left2_army_num = nil
  self.left3_army = nil
  self.left3_army_icon = nil
  self.left3_army_num = nil
  self.right1_army = nil
  self.right1_army_icon = nil
  self.right1_army_num = nil
  self.right2_army = nil
  self.right2_army_icon = nil
  self.right2_army_num = nil
  self.right3_army = nil
  self.right3_army_icon = nil
  self.right3_army_num = nil
  self.leftHeadBar = nil
  self.rightHeadBar = nil
  self.home_btn = nil
  self.btn_start = nil
  self.bottomRight = nil
  self.btn_start_text = nil
  self.btn_start_icon = nil
  self.btn_showResult = nil
  self.btn_speed2 = nil
  self.btn_speed4 = nil
  self.btn_speed6 = nil
  self.hero_list = nil
  self.start_desc_text = nil
  self.adventure_go = nil
  self.adventure_tip_go = nil
  self.adventure_tip_text = nil
  self.raid_btn = nil
  self.raid_text = nil
  self.shop_btn = nil
  self.shop_text = nil
end

local function OnShowResult(self)
  if self.finishLockOpen and self.finishOpen == false then
    UIUtil.ShowTips(Localization:GetString("400080"))
  else
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.LandLock or entranceType == PveEntrance.MonsterLock then
      local k10 = LuaEntry.DataConfig:TryGetStr("aps_pve_config", "k10")
      local arr = string.split(k10, ";")
      if 2 <= #arr then
        local needMainLv = tonumber(arr[2])
        local checkRate = tonumber(arr[1])
        if needMainLv > DataCenter.BuildManager.MainLv then
          local rate = (self.leftPower - self.rightPower) / math.max(1, self.rightPower)
          if checkRate > math.abs(rate) then
            local str = Localization:GetString("400086", string.GetFormattedPercentStr(checkRate))
            UIUtil.ShowTips(str)
            return
          end
        end
      end
    end
    PveActorMgr:GetInstance():ForceShowResult()
  end
end

local function OnClickLock(self, speed)
  local configStr = LuaEntry.DataConfig:TryGetStr("aps_pve_config", "k8")
  local configArr = string.split(configStr, ";")
  if 3 <= #configArr then
    local k1Open = tonumber(configArr[1])
    local k2Open = tonumber(configArr[2])
    local k3Open = tonumber(configArr[3])
    if speed == speedOffset4 then
      UIUtil.ShowTips(Localization:GetString("400077", k2Open, speed))
    elseif speed == speedOffset2 then
      UIUtil.ShowTips(Localization:GetString("400077", k1Open, speed))
    end
  end
end

local function ShowHeadInfo(self)
  local leftParam = PveActorMgr:GetInstance():GetLeftHeadParam()
  if leftParam.uid ~= nil and leftParam.uid ~= "" then
    self._imgUserHead_left:SetActive(true)
    self._imgUserHead_left_normal:SetActive(false)
    self._imgUserHead_left:SetData(leftParam.uid, leftParam.pic, leftParam.picVer)
  else
    self._imgUserHead_left:SetActive(false)
    self._imgUserHead_left_normal:SetActive(true)
    self._imgUserHead_left_normal:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_player_head_big")
  end
  local rightParam = PveActorMgr:GetInstance():GetRightHeadParam()
  if rightParam.uid ~= nil and rightParam.uid ~= "" then
    self._imgUserHead_right:SetActive(true)
    self._imgUserHead_right_normal:SetActive(false)
    self._imgUserHead_right:SetData(rightParam.uid, rightParam.pic, rightParam.picVer)
  elseif rightParam.monsterPic ~= nil then
    self._imgUserHead_right:SetActive(false)
    self._imgUserHead_right_normal:SetActive(true)
    self._imgUserHead_right_normal:LoadSprite(rightParam.monsterPic)
  else
    self._imgUserHead_right:SetActive(false)
    self._imgUserHead_right_normal:SetActive(true)
    self._imgUserHead_right_normal:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_player_head_big")
  end
end

local function OnDestroy(self)
  self.timer_action = nil
  self:DeleteTimer()
  self:UnBindUIComponent()
  base.OnDestroy(self)
end

local function RefreshStamina(self)
  local type = GetTableData(TableName.PVETrigger, tonumber(self.triggerId), "UnclockType")
  if type ~= nil and toInt(type) == BattleConst.TriggerType.MonsterWithHp then
    local stamina = DataCenter.BattleLevel:GetMonsterEnergyCost(self.triggerId)
    if 0 < stamina then
      local curNum = LuaEntry.Player:GetCurStamina()
      if stamina <= curNum then
        self.stamina_text:SetColor(WhiteColor)
      else
        self.stamina_text:SetColor(RedColor)
      end
      self.stamina_text:SetText(stamina)
      self.stamina_text:SetActive(true)
    else
      self.stamina_text:SetActive(false)
    end
  else
    self.stamina_text:SetActive(false)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ShowHeadInfo()
  self.monsterId = 0
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    self.isShowLineup = true
    self:RefreshPlayBackArmy()
    self:RefreshPlayBackEmArmy()
    self.hideHeroTipN:SetActive(false)
    self.adventure_go:SetActive(false)
    self.hero_list:SetActive(false)
    self.btn_start:SetActive(false)
    self.bottomRight:SetActive(true)
    self.home_btn:SetActive(true)
    self.start_desc_text:SetActive(false)
    self.CampRestraintItem_btn:SetActive(false)
    self.CampRestraintItem_btn_right:SetActive(false)
    self:SetBtnLimitText()
    return
  end
  if PveActorMgr:GetInstance():IsLineupLoadOK() then
    self:ShowLineup()
  end
  self:RefreshStamina()
  self:RefreshEmArmy()
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    self.hideHeroTipN:SetActive(true)
    self.adventure_go:SetActive(false)
    if DataCenter.MineCaveManager:CheckIfNeedPreloadEnemy() then
      self.rightContainer:SetActive(true)
      self.rightPowerNum:SetActive(true)
    else
      self.CampRestraintItem_btn_right:SetActive(false)
      self.rightContainer:SetActive(false)
      self.rightPowerNum:SetActive(false)
    end
  elseif entranceType == PveEntrance.ArenaSetting then
    self.CampRestraintItem_btn_right:SetActive(false)
    self.rightContainer:SetActive(false)
    self.hideHeroTipN:SetActive(false)
    self.btn_start:SetActive(false)
    self.saveBtnN:SetActive(true)
    self.home_btn:SetActive(true)
    self.adventure_go:SetActive(false)
    self.rightPowerNum:SetActive(false)
  elseif entranceType == PveEntrance.ArenaBattle then
    self.adventure_go:SetActive(false)
  elseif entranceType == PveEntrance.AdventureSetting then
    self.CampRestraintItem_btn_right:SetActive(false)
    self.rightContainer:SetActive(false)
    self.hideHeroTipN:SetActive(false)
    self.btn_start:SetActive(false)
    self.saveBtnN:SetActive(true)
    self.home_btn:SetActive(true)
    self.adventure_go:SetActive(true)
    self.rightPowerNum:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.adventure_tip_text.transform)
  elseif entranceType == PveEntrance.Adventure then
    self.hero_list:SetActive(false)
    self.hideHeroTipN:SetActive(false)
    self.adventure_go:SetActive(false)
  else
    self.monsterId = tonumber(GetTableData(TableName.PVETrigger, tonumber(self.triggerId), "UnclockPara")) or 0
    self.rightContainer:SetActive(true)
    self.hideHeroTipN:SetActive(false)
    self.adventure_go:SetActive(false)
  end
  local levelType = DataCenter.BattleLevel:GetLevelType()
  if levelType == PveLevelType.RadarExpLevel then
    local maxHeroLevel = DataCenter.BattleLevel:GetMaxHeroLevel()
    self.start_desc_text:SetActive(true)
    self.start_desc_text:SetText(Localization:GetString("400070", maxHeroLevel))
  else
    self.start_desc_text:SetActive(false)
  end
  self:SetBtnLimitText()
  self:RefreshGuideBtn()
  DataCenter.GuideManager:SendLogMessage(self.levelId, StatTTType.PveBattleStart, tostring(self.triggerId))
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetBtnLimitText(self)
  local descs = {}
  local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(tonumber(self.monsterId))
  if monsterTemplate then
    if monsterTemplate.recommend_power > 0 then
      local desc = Localization:GetString("300644", string.GetFormattedSeperatorNum(monsterTemplate.recommend_power))
      table.insert(descs, desc)
    end
    if 0 < monsterTemplate.needArmy.level then
      local desc = Localization:GetString("400019", monsterTemplate.needArmy.level, string.GetFormattedSeperatorNum(monsterTemplate.needArmy.count))
      table.insert(descs, desc)
    end
    if 0 < monsterTemplate.needHero.level then
      local desc = Localization:GetString("121460", monsterTemplate.needHero.level, monsterTemplate.needHero.count)
      table.insert(descs, desc)
    end
  end
  self.btn_limit_text:SetText(string.join(descs, "\n"))
  local MAX_WIDTH = 240
  local rtf = self.btn_limit_text.rectTransform
  local fitter = rtf:GetComponent(typeof(ContentSizeFitter))
  fitter.horizontalFit = ContentSizeFitter.FitMode.PreferredSize
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf)
  if MAX_WIDTH < rtf.sizeDelta.x then
    fitter.horizontalFit = ContentSizeFitter.FitMode.Unconstrained
    rtf.sizeDelta = Vector2.New(MAX_WIDTH, rtf.sizeDelta.y)
  end
end

local function SetBtnLimitIcon(self, power, heroUuids)
  local iconType = LandLockTopIcon.None
  local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(tonumber(self.monsterId))
  if monsterTemplate then
    local data = DataCenter.LandLockManager:GetLandLockDataByPve(self.levelId)
    if data and data.state == LandLockState.Locked then
      if monsterTemplate.recommend_power > 0 then
        if power < monsterTemplate.recommend_power then
          iconType = LandLockTopIcon.Red
        end
      elseif 0 < monsterTemplate.needHero.level then
        local count = 0
        for _, heroUuid in ipairs(heroUuids) do
          local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
          if heroData and heroData.level >= monsterTemplate.needHero.level then
            count = count + 1
          end
        end
        if count < monsterTemplate.needHero.count then
          iconType = LandLockTopIcon.Red
        end
      end
    end
  end
  if iconType ~= LandLockTopIcon.None then
    self.btn_start_icon:SetActive(true)
    local tfCount = self.btn_start_icon.transform.childCount
    if 0 < tfCount then
      for i = 0, tfCount - 1 do
        local tf = self.btn_start_icon.transform:GetChild(i)
        tf.gameObject:SetActive(tf.name == iconType)
      end
    end
  else
    self.btn_start_icon:SetActive(false)
  end
end

local function OnPveMineCaveInfoUpdate(self)
  self.home_btn:SetActive(false)
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
  else
    self:RefreshEmArmy()
    self.rightPowerNum:SetActive(true)
    self.rightContainer:SetActive(true)
    self.hideHeroTipN:SetActive(false)
  end
end

local function OnLeftClick(self)
  local list = {}
  local army = PveActorMgr:GetInstance():GetArmys()
  local totalNum = 0
  table.walk(army, function(k, v)
    local soldierId = tonumber(k)
    local data = self.ctrl:GetArmyData(soldierId, true)
    local oneData = {}
    oneData.count = tonumber(v)
    oneData.armyId = tonumber(soldierId)
    oneData.icon = data.icon
    oneData.level = data.level
    oneData.name = data.name
    totalNum = totalNum + tonumber(v)
    table.insert(list, oneData)
  end)
  local param = {}
  param.isShowLeft = true
  param.soldierData = list
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    param.maxNum = totalNum
  else
    param.maxNum = self.ctrl:GetMaxNum()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPveBattleSoldierList, {anim = false, playEffect = false}, param)
end

local function OnRightClick(self)
  local list = {}
  local army = PveActorMgr:GetInstance():GetEmArmyList()
  if army ~= nil and table.count(army) > 0 then
    table.walk(army, function(k, v)
      local soldierId = v.soldierId
      local data = self.ctrl:GetArmyData(soldierId)
      local oneData = {}
      oneData.count = v.soldierNum
      oneData.armyId = tonumber(soldierId)
      oneData.icon = data.icon
      oneData.level = data.level
      oneData.name = data.name
      table.insert(list, oneData)
    end)
  end
  local param = {}
  param.isShowLeft = false
  param.soldierData = list
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPveBattleSoldierList, {anim = false, playEffect = false}, param)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnEmBattleHeroChanged, self.OnEmBattleHeroChanged)
  self:AddUIListener(EventId.PVE_TotalHp_Changed, self.OnTotalHpChanged)
  self:AddUIListener(EventId.PVE_Lineup_Init_End, self.LineupInitEnd)
  self:AddUIListener(EventId.PVEBattleSetLeftBuffData, self.SetLeftBuffData)
  self:AddUIListener(EventId.PVEBattleSetRightBuffData, self.SetRightBuffData)
  self:AddUIListener(EventId.PVEBattleShowLeftBuff, self.ShowLeftBuff)
  self:AddUIListener(EventId.PVEBattleShowRightBuff, self.ShowRightBuff)
  self:AddUIListener(EventId.RefreshGuide, self.OnRefreshGuideSignal)
  self:AddUIListener(EventId.PveMineCaveInfoUpdate, self.OnPveMineCaveInfoUpdate)
  self:AddUIListener(EventId.FormationStaminaUpdate, self.RefreshStamina)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.FormationStaminaUpdate, self.RefreshStamina)
  self:RemoveUIListener(EventId.OnEmBattleHeroChanged, self.OnEmBattleHeroChanged)
  self:RemoveUIListener(EventId.PVE_TotalHp_Changed, self.OnTotalHpChanged)
  self:RemoveUIListener(EventId.PVE_Lineup_Init_End, self.LineupInitEnd)
  self:RemoveUIListener(EventId.PVEBattleSetLeftBuffData, self.SetLeftBuffData)
  self:RemoveUIListener(EventId.PVEBattleSetRightBuffData, self.SetRightBuffData)
  self:RemoveUIListener(EventId.PVEBattleShowLeftBuff, self.ShowLeftBuff)
  self:RemoveUIListener(EventId.PVEBattleShowRightBuff, self.ShowRightBuff)
  self:RemoveUIListener(EventId.RefreshGuide, self.OnRefreshGuideSignal)
  self:RemoveUIListener(EventId.PveMineCaveInfoUpdate, self.OnPveMineCaveInfoUpdate)
  base.OnRemoveListener(self)
end

local function OnStartPVE(self)
  local curHeroCount = self.ctrl:GetCurHeroNum()
  if curHeroCount == 0 then
    UIUtil.ShowTipsId(121007)
    return
  end
  if not self.hasArmy then
    UIUtil.ShowMessage(Localization:GetString("400008"), 2, "110003", "110106", function()
      self:OnHomeClick()
      GoToUtil.GotoOpenView(UIWindowNames.UIHospital, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide,
        hideTop = true
      }, CurScene.PVEScene)
    end)
    return
  end
  local type = GetTableData(TableName.PVETrigger, tonumber(self.triggerId), "UnclockType")
  if type ~= nil and toInt(type) == BattleConst.TriggerType.MonsterWithHp then
    local stamina = DataCenter.BattleLevel:GetMonsterEnergyCost(self.triggerId)
    if stamina > LuaEntry.Player:GetCurStamina() then
      UIUtil.ShowTipsId(GameDialogDefine.LACK_PVE_STAMINA)
      return
    end
  end
  local maxHeroCount = self.ctrl:GetMaxHeroNum()
  PveUtil.CheckHeroSlotEmpty(curHeroCount, maxHeroCount, function()
    PveUtil.CheckHeroesRarity(self.ctrl.curHeroes, function()
      PveUtil.CheckHeroesBreak(self.ctrl.curHeroes, function()
        PveUtil.CheckHeroesMaxed(self.ctrl.curHeroes, function()
          local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(tonumber(self.monsterId))
          if monsterTemplate and monsterTemplate.enter_limit then
            local param = {}
            param.monsterId = self.monsterId
            param.power = self.leftPower
            param.armyDict = PveActorMgr:GetInstance():GetArmys()
            param.heroUuidList = self.ctrl.curHeroes
            param.showBg = true
            if PveUtil.CanShowPowerLack(param) then
              UIUtil.ShowPvePowerLack(param)
              DataCenter.GuideManager:SendLogMessage(self.levelId, StatTTType.PveBattlePowerLack, tostring(self.triggerId))
              return
            end
            self:GotoStartPVE()
          else
            self:GotoStartPVE()
          end
        end)
      end)
    end)
  end)
end

local function GotoStartPVE(self)
  self.hero_list:SetActive(false)
  self.btn_start:SetActive(false)
  self.bottomRight:SetActive(true)
  self.home_btn:SetActive(true)
  self.start_desc_text:SetActive(false)
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  local trigger = PveActorMgr:GetInstance():GetCurTrigger()
  local levelType = DataCenter.BattleLevel:GetLevelType()
  if entranceType == PveEntrance.MineCave then
    PveActorMgr:GetInstance():SendCaveBattleCmd()
  elseif entranceType == PveEntrance.ArenaBattle then
    PveActorMgr:GetInstance():SendArenaBattle()
  elseif trigger and trigger:IsTypeDiffMonster() then
    PveActorMgr:GetInstance():SendDiffBattle()
  elseif trigger and trigger:IsTypeDiffMonsterEasy() then
    PveActorMgr:GetInstance():SendDiffBattle()
  elseif trigger and trigger:IsTypeLevelLimitMonster() then
    PveActorMgr:GetInstance():SendLevelLimitBattle()
  elseif trigger and trigger:IsTypeAdventureSub() then
    DataCenter.AdventureManager:SendSelect()
  elseif levelType == PveLevelType.BarrageLevel then
    DataCenter.BattleLevel:CreateSquad()
    return
  else
    PveActorMgr:GetInstance():SendBattleCmd(101001)
  end
  self:CheckShowSpeedEffect()
  self:CheckShowResultBtn()
end

local function CheckShowResultBtn(self)
  if self.finishOpen == true then
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.LandLock or entranceType == PveEntrance.MonsterLock then
      local k10 = LuaEntry.DataConfig:TryGetStr("aps_pve_config", "k10")
      local arr = string.split(k10, ";")
      if 2 <= #arr then
        local needMainLv = tonumber(arr[2])
        local checkRate = tonumber(arr[1])
        if needMainLv > DataCenter.BuildManager.MainLv then
          local rate = (self.leftPower - self.rightPower) / math.max(1, self.rightPower)
          if checkRate > rate then
            CS.UIGray.SetGray(self.btn_showResult.transform, true, true)
            return
          end
        end
      end
    end
  end
  CS.UIGray.SetGray(self.btn_showResult.transform, false, true)
end

local function CheckShowSpeedEffect(self)
  if self.doFly == true then
    self.fly_obj:SetActive(true)
    self.icon_effect:SetActive(true)
    local targetPos = self.btn_speed2.transform.position
    local targetScale = 0.3
    local flyDir = Vector3.Normalize(targetPos - self.fly_obj.transform.position)
    Setting:SetPrivateInt(SettingKeys.PVE_SPEED_SHOW_EFFECT, self.showEffectNum)
    TimerManager:GetInstance():DelayInvoke(function()
      self.icon_effect:SetActive(false)
      DOTween.Sequence():Append(self.fly_obj.transform:DOMove(self.fly_obj.transform.position - flyDir * 20, 0.2)):Append(self.fly_obj.transform:DOMove(targetPos + Vector3.New(2, 18, 0), 0.5)):Join(self.fly_obj.transform:DOScale(Vector3.New(targetScale, targetScale, 1), 0.5)):AppendCallback(function()
        self.fly_obj:SetActive(false)
        self:CheckShowRedDot()
      end)
    end, 0.5)
  end
end

local function OnHomeClick(self)
  local trigger = PveActorMgr:GetInstance():GetCurTrigger()
  local levelType = DataCenter.BattleLevel:GetLevelType()
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if levelType == PveLevelType.AdventureLevel then
    trigger:SetMonsterLevelVisible(true)
  end
  if entranceType == PveEntrance.ArenaSetting then
    UIUtil.ShowMessage(Localization:GetString("372282"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.BattleLevel:Exit()
    end)
    return
  end
  if levelType == PveLevelType.FightLevel or levelType == PveLevelType.RadarExpLevel or levelType == PveLevelType.AdventureSetting then
    DataCenter.BattleLevel:Exit()
  elseif levelType == PveLevelType.BattlePlayBackLevel then
    local param = PveActorMgr:GetInstance():GetLevelParam()
    local mailId, jumpType
    if param ~= nil and param.pveEntrance == PveEntrance.BattlePlayBack then
      mailId = param.mailId
      jumpType = param.jumpType
    end
    DataCenter.BattleLevel:Exit(function()
      if jumpType == PlayBackEndJumpType.Mail then
        if mailId ~= nil then
          GoToUtil.GotoOpenView(UIWindowNames.UIMailNew, MailInternalGroup.MAIL_IN_report, mailId)
        end
      elseif jumpType == PlayBackEndJumpType.Arena then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDailyActivity, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, 8)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIArenaHistory)
      elseif jumpType == PlayBackEndJumpType.MineCave then
        DataCenter.MineCaveManager:SetEnemyPlayerPower()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDailyActivity, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, ActivityOverviewType.MineCave)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMineCaveLog)
      end
    end)
  else
    PveActorMgr:GetInstance():Leave()
  end
end

local function OnSelectHeroFinish(self, data, isAdd, pos)
  local index = data.index
  local heroId = data.heroId
  local heroUuid = data.heroUuid
  local heroLv = data.level
  local heroQuality = data.qualityIndex
  local rarity = data.rarity
  self:RefreshArmy()
  local power = PveActorMgr:GetInstance():GetInitPowerByHeroUuid(heroUuid)
  power = Mathf.Ceil(power)
  if isAdd then
    if pos ~= nil then
      local targetPos = self.leftImg.transform.position
      UIUtil.DoFly(RewardType.GOODS, 3, "Assets/Main/Sprites/UI/LWCommon/Sprite/UITroopsNew_icon3.png", pos, targetPos)
    end
    PveActorMgr:GetInstance():LoadPlayer(index, heroId, power, heroLv, heroQuality, rarity)
  else
    PveActorMgr:GetInstance():RemoveModelObj(Const.CampType.Player, index, heroId)
  end
  PveActorMgr:GetInstance():RefreshHeroSigns()
end

local function OnEmBattleHeroChanged(self)
end

local function OnTotalHpChanged(self, isAtk)
  if not PveActorMgr:GetInstance().isHeroesBattleInit then
    return
  end
  if isAtk then
    local maxBlood = PveActorMgr:GetInstance():GetAtkTotalMaxHp()
    local curBlood = PveActorMgr:GetInstance():GetAtkTotalCurHp()
    local percent = math.min(curBlood / math.max(1, maxBlood), 1)
    local cur = self.leftNum * percent
    local duration = self.leftBloodLayer:SetTargetVal(cur)
    self.leftSoldierNum:TweenToNum(math.floor(cur), duration)
    local curPower = self.leftPower * percent
    self.leftPowerNum:TweenToNum(math.floor(curPower), duration)
    self:SetBtnLimitIcon(curPower, self.ctrl.curHeroes)
  else
    local maxBlood = PveActorMgr:GetInstance():GetDefTotalMaxHp()
    local curBlood = PveActorMgr:GetInstance():GetDefTotalCurHp()
    local percent = math.min(curBlood / math.max(1, maxBlood), 1)
    local cur = self.rightNum * percent
    local duration = self.rightBloodLayer:SetTargetVal(cur)
    self.rightSoldierNum:TweenToNum(math.floor(cur), duration)
    local curPower = self.rightPower * percent
    self.rightPowerNum:TweenToNum(math.floor(curPower), duration)
  end
end

local function OnChangeSpeed(self, speed)
  if speed == speedOffset1 then
    speed = speedOffset2
  elseif speed == speedOffset2 then
    if self.speed4Open == nil or self.speed4Open == false then
      speed = speedOffset1
    else
      speed = speedOffset4
    end
  elseif speed == speedOffset4 then
    speed = speedOffset1
  end
  if speed == speedOffset2 then
    if self.speed2Open == nil or self.speed2Open == false then
      return
    end
  elseif speed == speedOffset4 and (self.speed4Open == nil or self.speed4Open == false) then
    return
  end
  self.btn_speed2:SetActive(speed == speedOffset2 and self.speed2Open ~= nil and self.speed2Open == true)
  self.btn_speed4:SetActive(speed == speedOffset4 and self.speed4Open ~= nil and self.speed4Open == true)
  self.btn_speed6:SetActive(speed == speedOffset1 and (self.speed2Open ~= nil and self.speed2Open == true or self.speed4Open ~ nil and self.speed4Open == true))
  PveActorMgr:GetInstance():SetSpeedOffset(speed)
  self:CheckShowRedDot()
end

local function LineupInitEnd(self)
  self:ShowLineup()
end

local function ShowLineup(self)
  if self.isShowLineup == true then
    return
  end
  self.isShowLineup = true
  local uid = LuaEntry.Player.uid
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    self:RefreshArmy()
  elseif entranceType == PveEntrance.Adventure then
    self:RefreshAdventureArmyAndHero()
  else
    local heroes = DataCenter.BattleLevel:GetHeroSelectHistory()
    if not table.IsNullOrEmpty(heroes) then
      for _, uuid in ipairs(heroes) do
        self.ctrl:SelectHeroByUuid(uuid)
        local data = self.ctrl:GetHeroDataByUuid(uuid)
        if data.index > 0 then
          self:OnSelectHeroFinish(data, true)
        end
      end
    else
      self:RefreshArmy()
    end
  end
end

local function RefreshAdventureArmyAndHero(self)
  local heroUuidList = DataCenter.AdventureManager:GetHeroUuidList()
  PveActorMgr:GetInstance():SetHeros(heroUuidList)
  local num, totalNum = DataCenter.AdventureManager:GetArmyCount()
  self.leftNum = num
  local pPower, pHp = PveActorMgr:GetInstance():GetEmBattleTotalPowerAndHp(true)
  self.leftPower = pPower
  self.leftBloodLayer:SetMaxValImmediately(totalNum, true, function()
    local duration = self.leftBloodLayer:SetTargetVal(num)
    self.leftSoldierNum:TweenToNum(math.floor(num), duration)
    self.leftPowerNum:TweenToNum(math.floor(pPower), duration)
  end)
  self.hasArmy = true
  local heroes = PveActorMgr:GetInstance():GetHeros()
  for _, v in ipairs(heroes) do
    local heroUuid = v.uuid
    local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
    local power = Mathf.Ceil(PveActorMgr:GetInstance():GetInitPowerByHeroUuid(heroUuid))
    PveActorMgr:GetInstance():LoadPlayer(v.index, heroData.heroId, power, heroData.level, heroData.quality, heroData.rarity)
  end
end

local function RefreshPlayBackArmy(self)
  local num = 0
  local army = PveActorMgr:GetInstance():GetArmys()
  table.walk(army, function(k, v)
    if 0 < v then
      num = num + v
    end
  end)
  self.leftNum = num
  local duration = self.leftBloodLayer:SetMaxVal(num)
  self.leftSoldierNum:TweenToNum(math.floor(num), duration)
  local pPower, pHp = PveActorMgr:GetInstance():GetEmBattleTotalPowerAndHp(true)
  self.leftPower = pPower
  self.leftPowerNum:TweenToNum(math.floor(pPower), duration)
end

local function RefreshPlayBackEmArmy(self)
  local num = 0
  local list = PveActorMgr:GetInstance():GetEmArmyList()
  if list ~= nil and 0 < table.count(list) then
    table.walk(list, function(k, v)
      num = num + (v.soldierNum or 0)
    end)
  end
  self.rightNum = num
  local duration = self.rightBloodLayer:SetMaxVal(num)
  self.rightSoldierNum:TweenToNum(math.floor(num), duration)
  local ePower, pHp = PveActorMgr:GetInstance():GetEmBattleTotalPowerAndHp(false)
  self.rightPower = ePower
  self.rightPowerNum:TweenToNum(math.floor(ePower), duration)
end

local function CheckShowRestraint(self)
  if self.leftRestraintData ~= nil and self.rightRestraintData ~= nil then
    local leftCampRestraintData = self.leftRestraintData
    local rightCampRestraintData = self.rightRestraintData
    if leftCampRestraintData ~= nil and rightCampRestraintData ~= nil then
      local leftRestraintCamp = HeroUtils.GetHeroRestraintType(leftCampRestraintData.camp)
      local rightRestraintCamp = HeroUtils.GetHeroRestraintType(rightCampRestraintData.camp)
      if leftRestraintCamp == rightCampRestraintData.camp then
        self._CampRestraintImg:SetActive(true)
        self._CampRestraintImg:LoadSprite("Assets/Main/Sprites/UI/UIHeroList/hero_faction_fight_kezhi.png")
        self._CampRestraintItem_Left_txt:SetText(Localization:GetString("150228"))
      elseif rightRestraintCamp == leftCampRestraintData.camp then
        self._CampRestraintImg:SetActive(true)
        self._CampRestraintImg:LoadSprite("Assets/Main/Sprites/UI/UIHeroList/hero_faction_fight_beikezhi.png")
        self._CampRestraintItem_Left_txt:SetText(Localization:GetString("150229"))
      end
    end
  end
end

local function RefreshArmy(self)
  local heroes = PveActorMgr:GetInstance():GetHeros()
  local len = table.count(heroes)
  self.CampRestraintItem_btn:SetActive(self.showCamp)
  if 0 < len then
    local heroIdList = {}
    table.walk(heroes, function(k, v)
      local tempHeroData = DataCenter.BattleLevel:GetPveHeroData(v.uuid)
      if tempHeroData ~= nil then
        table.insert(heroIdList, tempHeroData.heroId)
      end
    end)
    self.leftRestraintData = MarchUtil.GetRestraintCampAndValue(heroIdList)
    if self.leftRestraintData ~= nil then
      self._CampRestraintItem_Left:InitData(self.leftRestraintData.camp, self.leftRestraintData.num)
    else
      self._CampRestraintImg:SetActive(false)
      self._CampRestraintItem_Left:InitData()
    end
    self:CheckShowRestraint()
    CS.UIGray.SetGray(self.btn_start.transform, false, true)
  else
    self._CampRestraintItem_Left:InitData()
    self._CampRestraintImg:SetActive(false)
    CS.UIGray.SetGray(self.btn_start.transform, true, false)
  end
  self.hasArmy = false
  local num = 0
  local list = self.ctrl:GetCurSoldierList()
  if list ~= nil then
    local armyDatas = {}
    for k, v in pairs(list) do
      if 0 < v then
        num = num + v
        armyDatas[k] = v
      end
    end
    PveActorMgr:GetInstance():SetArmys(armyDatas)
  end
  local maxNum = self.ctrl:GetMaxNum()
  self.leftNum = num
  if 0 < num then
    self.hasArmy = true
  end
  local duration = self.leftBloodLayer:SetMaxVal(num)
  self.leftSoldierNum:TweenToNum(math.floor(num), duration)
  local pPower, pHp = PveActorMgr:GetInstance():GetEmBattleTotalPowerAndHp(true)
  self.leftPower = pPower
  self.leftPowerNum:TweenToNum(math.floor(pPower), duration)
  self:SetBtnLimitIcon(pPower, self.ctrl.curHeroes)
end

local function RefreshEmArmy(self)
  local num = 0
  local list = PveActorMgr:GetInstance():GetEmArmyList()
  if list ~= nil and 0 < table.count(list) then
    table.walk(list, function(k, v)
      num = num + (v.soldierNum or 0)
    end)
  end
  self.rightNum = num
  local duration = self.rightBloodLayer:SetMaxVal(num)
  self.rightSoldierNum:TweenToNum(math.floor(num), duration)
  local ePower, pHp = PveActorMgr:GetInstance():GetEmBattleTotalPowerAndHp(false)
  self.rightPower = ePower
  self.rightPowerNum:TweenToNum(math.floor(ePower), duration)
  local heroList = PveActorMgr:GetInstance():GetEnemyHeros()
  local heroIdList = {}
  table.walk(heroList, function(k, v)
    local heroId = v.heroId
    if heroId ~= nil then
      table.insert(heroIdList, heroId)
    end
  end)
  if #heroIdList <= 0 then
    self.CampRestraintItem_btn_right:SetActive(false)
  else
    self.rightRestraintData = MarchUtil.GetRestraintCampAndValue(heroIdList)
    self.CampRestraintItem_btn_right:SetActive(self.showCamp)
    if self.rightRestraintData ~= nil then
      self._CampRestraintItem_Right:InitData(self.rightRestraintData.camp, self.rightRestraintData.num)
    else
      self._CampRestraintItem_Right:InitData()
    end
  end
end

local function SetLeftBuffData(self, data)
  if data ~= nil and table.count(data) > 0 then
    for k, v in pairs(data) do
      if self.cacheLeftBuffList ~= nil and self.cacheLeftBuffList[k] ~= nil then
        self.cacheLeftBuffList[k] = nil
      end
    end
    if self.cacheLeftBuffList ~= nil then
      for k, v in pairs(self.cacheLeftBuffList) do
        if self.leftBuffList[k] ~= nil then
          local nameStr = self.leftBuffList[k].objName
          self.leftContent:RemoveComponent(nameStr, PveBuffCell)
          self.leftBuffList[k] = nil
        end
        if self.leftBuffInstance[k] ~= nil then
          self.leftBuffInstance[k]:Destroy()
          self.leftBuffInstance[k] = nil
        end
        self:CheckRemoveTipsByBuffId(k, true)
      end
    end
  else
    self:CheckRemoveTipsByBuffId(self.selectBuffId, true)
    self:ClearLeftList()
    self.leftContent:SetActive(false)
  end
  self.cacheLeftBuffList = data
end

local function SetRightBuffData(self, data)
  if data ~= nil and table.count(data) > 0 then
    for k, v in pairs(data) do
      if self.cacheRightBuffList ~= nil and self.cacheRightBuffList[k] ~= nil then
        self.cacheRightBuffList[k] = nil
      end
    end
    if self.cacheRightBuffList ~= nil then
      for k, v in pairs(self.cacheRightBuffList) do
        if self.rightBuffList[k] ~= nil then
          local nameStr = self.rightBuffList[k].objName
          self.rightContent:RemoveComponent(nameStr, PveBuffCell)
          self.rightBuffList[k] = nil
        end
        if self.rightBuffInstance[k] ~= nil then
          self.rightBuffInstance[k]:Destroy()
          self.rightBuffInstance[k] = nil
        end
        self:CheckRemoveTipsByBuffId(k, false)
      end
    end
  else
    self:ClearRightList()
    self.rightContent:SetActive(false)
    self:CheckRemoveTipsByBuffId(self.selectBuffId, false)
  end
  self.cacheRightBuffList = data
end

local function ShowLeftBuff(self, data)
  local str = tostring(data)
  local arr = string.split(str, "|")
  if #arr < 2 then
    return
  end
  local k = tonumber(arr[1])
  local level = tonumber(arr[2])
  if level == nil or level <= 0 then
    level = 1
  end
  self.leftContent:SetActive(true)
  if self.leftBuffInstance[k] == nil then
    self.leftBuffInstance[k] = self:GameObjectInstantiateAsync(UIAssets.UIGuidePioneerBuffCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.leftContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.leftContent:AddComponent(PveBuffCell, nameStr)
      cell:InitData(k, nameStr, true, level)
      self.leftBuffList[k] = cell
    end)
  end
end

local function ShowRightBuff(self, data)
  local str = tostring(data)
  local arr = string.split(str, "|")
  if #arr < 2 then
    return
  end
  local k = tonumber(arr[1])
  local level = tonumber(arr[2])
  if level == nil or level <= 0 then
    level = 1
  end
  self.rightContent:SetActive(true)
  if self.rightBuffInstance[k] == nil then
    self.rightBuffInstance[k] = self:GameObjectInstantiateAsync(UIAssets.UIGuidePioneerBuffCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.rightContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.rightContent:AddComponent(PveBuffCell, nameStr)
      cell:InitData(k, nameStr, false, level)
      self.rightBuffList[k] = cell
    end)
  end
end

local function ClearLeftList(self)
  for k, v in pairs(self.leftBuffInstance) do
    if v ~= nil then
      v:Destroy()
    end
  end
  self.leftContent:RemoveComponents(PveBuffCell)
  self.leftBuffInstance = {}
  self.leftBuffList = {}
end

local function ClearRightList(self)
  for k, v in pairs(self.rightBuffInstance) do
    if v ~= nil then
      v:Destroy()
    end
  end
  self.rightContent:RemoveComponents(PveBuffCell)
  self.rightBuffInstance = {}
  self.rightBuffList = {}
end

local function ShowGuideMask(self, type)
  self.guideMask:SetActive(true)
  self.mask_left:SetActive(false)
  self.mask_right:SetActive(false)
  self.mask_all:SetActive(false)
  if type == 1 then
    self.mask_left:SetActive(true)
    self.anim:Play("left")
  elseif type == 2 then
    self.mask_right:SetActive(true)
    self.anim:Play("right")
  elseif type == 3 then
    self.mask_all:SetActive(true)
    self.anim:Play("all")
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:OnClickGuideMask()
    end, 3)
  end
end

local function HideGuideMask(self)
  self.guideMask:SetActive(false)
end

local function ShowSpeedUpForGuide(self)
  local speedOffset = Setting:GetPrivateInt(SettingKeys.PVE_SPEED_OFFSET .. LuaEntry.Player.uid, 1)
  self.btn_speed2:SetActive(speedOffset == speedOffset2)
  self.btn_speed4:SetActive(speedOffset == speedOffset4)
  self.btn_speed6:SetActive(speedOffset == speedOffset1)
end

local function ShowFinishForGuide(self)
  self.btn_showResult:SetActive(true)
end

local function CheckShowSpeedUp(self)
  local speedOffset = Setting:GetPrivateInt(SettingKeys.PVE_SPEED_OFFSET .. LuaEntry.Player.uid, 1)
  if speedOffset ~= speedOffset4 or self.speed4Open then
  else
    speedOffset = speedOffset2
  end
  if speedOffset ~= speedOffset2 or self.speed2Open then
  else
    speedOffset = speedOffset1
  end
  self.lock_btn_speed4:SetActive(false)
  self.lock_btn_speed2:SetActive(self.speed2LockOpen)
  self.btn_speed2:SetActive(speedOffset == speedOffset2 and self.speed2Open ~= nil and self.speed2Open == true)
  self.btn_speed4:SetActive(speedOffset == speedOffset4 and self.speed4Open ~= nil and self.speed4Open == true)
  self.btn_speed6:SetActive(speedOffset == speedOffset1 and (self.speed2Open ~= nil and self.speed2Open == true or self.speed4Open ~= nil and self.speed4Open == true))
  PveActorMgr:GetInstance():SetSpeedOffset(speedOffset)
  self:CheckShowRedDot()
end

local function CheckShowRedDot(self)
  self.doFly = false
  self.showEffectNum = 1
  if self.speed2Open ~= nil and self.speed2Open == true or self.speed4Open ~= nil and self.speed4Open == true then
    local showRed = false
    local show = Setting:GetPrivateInt(SettingKeys.PVE_SPEED_SHOW_RED_DOT, 1)
    local showEffectNum = 0
    if show < speedOffset2 then
      local speedOffset = PveActorMgr:GetInstance():GetSpeedOffset()
      if speedOffset == speedOffset1 then
        showRed = true
        if self.speed4Open ~= nil and self.speed4Open == true then
          showEffectNum = speedOffset4
        else
          showEffectNum = speedOffset2
        end
      elseif speedOffset == speedOffset2 then
        if self.speed4Open ~= nil and self.speed4Open == true then
          showRed = true
          showEffectNum = speedOffset4
        else
          Setting:SetPrivateInt(SettingKeys.PVE_SPEED_SHOW_RED_DOT, speedOffset2)
        end
      elseif speedOffset == speedOffset4 then
        Setting:SetPrivateInt(SettingKeys.PVE_SPEED_SHOW_RED_DOT, speedOffset4)
      end
    elseif show < speedOffset4 then
      local speedOffset = PveActorMgr:GetInstance():GetSpeedOffset()
      if self.speed4Open ~= nil and self.speed4Open == true then
        if speedOffset < speedOffset4 then
          showRed = true
          showEffectNum = speedOffset4
        else
          Setting:SetPrivateInt(SettingKeys.PVE_SPEED_SHOW_RED_DOT, speedOffset4)
        end
      end
    end
    if showRed == true then
      local needShowEffect = Setting:GetPrivateInt(SettingKeys.PVE_SPEED_SHOW_EFFECT, 1)
      if showEffectNum > needShowEffect then
        self.red_dot:SetActive(false)
        self.doFly = true
        self.showEffectNum = showEffectNum
        if showEffectNum == speedOffset2 then
          self.fly_img:LoadSprite("Assets/Main/Sprites/Guide/UInewbie_2x01.png")
        elseif showEffectNum == speedOffset4 then
          self.fly_img:LoadSprite("Assets/Main/Sprites/Guide/UInewbie_4x02.png")
        end
      else
        self.red_dot:SetActive(true)
      end
    else
      self.red_dot:SetActive(false)
    end
  else
    self.red_dot:SetActive(false)
  end
end

local function CheckShowFinish(self)
  self.result_lock:SetActive(self.finishLockOpen and self.finishOpen == false)
  if self.finishOpen or self.finishLockOpen then
    self.btn_showResult:SetActive(true)
  else
    self.btn_showResult:SetActive(false)
  end
end

local function OnRefreshGuideSignal(self)
  if self.levelParam ~= nil and self.levelParam.entranceType == PveEntrance.BattlePlayBack then
  else
    self:RefreshGuideBtn()
  end
end

local function RefreshGuideBtn(self)
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil then
    if template.type == GuideType.PveShowBattleSpeedBtn then
      self:ShowSpeedUpForGuide()
      DataCenter.GuideManager:DoNext()
    elseif template.type == GuideType.PveShowBattleFinishBtn then
      self:ShowFinishForGuide()
      DataCenter.GuideManager:DoNext()
    elseif template.type == GuideType.PveShowBattlePowerLight then
      local showType = tonumber(template.para1)
      self:ShowGuideMask(showType)
    end
  end
end

local function OnClickGuideMask(self)
  self:HideGuideMask()
  DataCenter.GuideManager:DoNext()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function GetHeroObjByHeroId(self, heroId)
  return self.hero_list:GetHeroObjByHeroId(heroId)
end

local function OnClickGrayMask(self)
  self:HideGrayMask()
end

local function ShowGrayMask(self, time)
  local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
  if _modelMgr ~= nil then
    _modelMgr:SetBarForGuide()
  end
  self.gray_mask:SetActive(true)
  self.guideTime = 0
  self.canClickGuideMask = false
  self:AddTimer(time)
end

local function HideGrayMask(self)
  if self.canClickGuideMask then
    local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
    if _modelMgr ~= nil then
      _modelMgr:HideBarForGuide()
    end
    self.gray_mask:SetActive(false)
    if DataCenter.GuideManager:GetGuideType() == GuideType.PveShowBattleBloodLight then
      DataCenter.GuideManager:DoNext()
    end
  end
end

local function AddTimer(self, time)
  local realTime = 3
  if time ~= nil and time ~= "" then
    realTime = tonumber(time)
    if realTime ~= nil then
      realTime = math.ceil(tonumber(time) / 1000)
    else
      realTime = 3
    end
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(realTime, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function SetShowSpeedUpConfig(self)
  self.speed2Open = false
  self.speed4Open = false
  self.finishOpen = false
  self.speed2LockOpen = false
  self.speed4LockOpen = false
  self.finishLockOpen = false
  if self.levelParam ~= nil and self.levelParam.entranceType == PveEntrance.BattlePlayBack then
    self.speed2Open = true
    self.speed4Open = true
    self.finishOpen = true
  else
    local mainLv = DataCenter.BuildManager.MainLv
    local configStr = LuaEntry.DataConfig:TryGetStr("aps_pve_config", "k8")
    local configArr = string.split(configStr, ";")
    if 3 <= #configArr then
      local k1Open = tonumber(configArr[1])
      local k2Open = tonumber(configArr[2])
      local k3Open = tonumber(configArr[3])
      self.speed2Open = mainLv >= k1Open
      self.speed2LockOpen = k1Open == mainLv + 1
      self.speed4Open = mainLv >= k2Open
      self.speed4LockOpen = k2Open == mainLv + 1
      self.finishOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLOW_FORCE_END_PVE) > 0
      self.finishLockOpen = k3Open <= mainLv + 1
    end
  end
end

local function TimeRefresh(self)
  self.canClickGuideMask = true
  self:DeleteTimer()
end

local function OnClickSaveBtn(self)
  local curHeroCount = self.ctrl:GetCurHeroNum()
  local maxHeroCount = self.ctrl:GetMaxHeroNum()
  PveUtil.CheckHeroSlotEmpty(curHeroCount, maxHeroCount, function()
    PveUtil.CheckHeroesRarity(self.ctrl.curHeroes, function()
      PveUtil.CheckHeroesBreak(self.ctrl.curHeroes, function()
        PveUtil.CheckHeroesMaxed(self.ctrl.curHeroes, function()
          local entranceType = DataCenter.BattleLevel:GetEntranceType()
          if entranceType == PveEntrance.ArenaSetting then
            if not PveActorMgr:GetInstance():SendArenaSetDefenseArmy() then
              UIUtil.ShowTipsId(372259)
            else
              DataCenter.BattleLevel:Exit()
            end
          elseif entranceType == PveEntrance.AdventureSetting then
            if not PveActorMgr:GetInstance():SetAdventureArmy() then
              UIUtil.ShowTipsId(372259)
            else
              self.saveBtnN:SetActive(false)
            end
          else
            DataCenter.BattleLevel:Exit()
          end
        end)
      end)
    end)
  end)
end

local function SetSelectBuff(self, buffId, isLeft)
  self.selectBuffId = buffId
  self.isLeftBuffId = isLeft
end

local function CheckRemoveTipsByBuffId(self, buffId, isLeft)
  if self.selectBuffId == buffId and self.isLeftBuffId == isLeft then
    self.selectBuffId = nil
    self.isLeftBuffId = nil
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroTip) == true then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroTip)
    end
  end
end

local function OnRaidClick(self)
  local raidState = DataCenter.AdventureManager:GetRaidState()
  if raidState == AdventureRaidState.Ready then
    local curHeroCount = self.ctrl:GetCurHeroNum()
    local maxHeroCount = self.ctrl:GetMaxHeroNum()
    PveUtil.CheckHeroSlotEmpty(curHeroCount, maxHeroCount, function()
      PveUtil.CheckHeroesRarity(self.ctrl.curHeroes, function()
        PveUtil.CheckHeroesBreak(self.ctrl.curHeroes, function()
          PveUtil.CheckHeroesMaxed(self.ctrl.curHeroes, function()
            if not PveActorMgr:GetInstance():SetAdventureArmy() then
              UIUtil.ShowTipsId(372259)
            else
              DataCenter.AdventureManager.autoRaid = true
              self.saveBtnN:SetActive(false)
            end
          end)
        end)
      end)
    end)
  elseif raidState == AdventureRaidState.NeedLevel then
    UIUtil.ShowTipsId(302273)
  else
    return
  end
end

local function OnShopClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop)
end

local function OnCampClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  if self.leftRestraintData ~= nil then
    local x = self.CampRestraintItem_btn.transform.position.x
    local y = self.CampRestraintItem_btn.transform.position.y - 60 * scaleFactor
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationRestraint, self.leftRestraintData.camp, self.leftRestraintData.num, x, y)
  else
    local x = self.CampRestraintItem_btn.transform.position.x
    local y = self.CampRestraintItem_btn.transform.position.y - 60 * scaleFactor
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationRestraint, -1, -1, x, y)
  end
end

local function OnRightCampClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  if self.rightRestraintData ~= nil then
    local x = self.CampRestraintItem_btn_right.transform.position.x
    local y = self.CampRestraintItem_btn_right.transform.position.y - 60 * scaleFactor
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationRestraint, self.rightRestraintData.camp, self.rightRestraintData.num, x, y, 1)
  else
    local position = self.CampRestraintItem_btn_right.transform.position + Vector3.New(0, -60, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("150232")
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

UIPVESceneView.OnCreate = OnCreate
UIPVESceneView.OnDestroy = OnDestroy
UIPVESceneView.OnEnable = OnEnable
UIPVESceneView.OnDisable = OnDisable
UIPVESceneView.OnAddListener = OnAddListener
UIPVESceneView.OnRemoveListener = OnRemoveListener
UIPVESceneView.BindUIComponent = BindUIComponent
UIPVESceneView.UnBindUIComponent = UnBindUIComponent
UIPVESceneView.OnStartPVE = OnStartPVE
UIPVESceneView.GotoStartPVE = GotoStartPVE
UIPVESceneView.OnHomeClick = OnHomeClick
UIPVESceneView.OnSelectHeroFinish = OnSelectHeroFinish
UIPVESceneView.OnShowResult = OnShowResult
UIPVESceneView.OnEmBattleHeroChanged = OnEmBattleHeroChanged
UIPVESceneView.OnTotalHpChanged = OnTotalHpChanged
UIPVESceneView.OnChangeSpeed = OnChangeSpeed
UIPVESceneView.LineupInitEnd = LineupInitEnd
UIPVESceneView.ShowLineup = ShowLineup
UIPVESceneView.RefreshArmy = RefreshArmy
UIPVESceneView.RefreshEmArmy = RefreshEmArmy
UIPVESceneView.SetRightBuffData = SetRightBuffData
UIPVESceneView.SetLeftBuffData = SetLeftBuffData
UIPVESceneView.ShowLeftBuff = ShowLeftBuff
UIPVESceneView.ShowRightBuff = ShowRightBuff
UIPVESceneView.ClearLeftList = ClearLeftList
UIPVESceneView.ClearRightList = ClearRightList
UIPVESceneView.OnLeftClick = OnLeftClick
UIPVESceneView.OnRightClick = OnRightClick
UIPVESceneView.ShowGuideMask = ShowGuideMask
UIPVESceneView.HideGuideMask = HideGuideMask
UIPVESceneView.ShowSpeedUpForGuide = ShowSpeedUpForGuide
UIPVESceneView.ShowFinishForGuide = ShowFinishForGuide
UIPVESceneView.OnRefreshGuideSignal = OnRefreshGuideSignal
UIPVESceneView.RefreshGuideBtn = RefreshGuideBtn
UIPVESceneView.OnClickGuideMask = OnClickGuideMask
UIPVESceneView.CheckShowSpeedUp = CheckShowSpeedUp
UIPVESceneView.CheckShowFinish = CheckShowFinish
UIPVESceneView.OnPveMineCaveInfoUpdate = OnPveMineCaveInfoUpdate
UIPVESceneView.GetHeroObjByHeroId = GetHeroObjByHeroId
UIPVESceneView.OnClickGrayMask = OnClickGrayMask
UIPVESceneView.ShowGrayMask = ShowGrayMask
UIPVESceneView.HideGrayMask = HideGrayMask
UIPVESceneView.SetShowSpeedUpConfig = SetShowSpeedUpConfig
UIPVESceneView.DeleteTimer = DeleteTimer
UIPVESceneView.AddTimer = AddTimer
UIPVESceneView.TimeRefresh = TimeRefresh
UIPVESceneView.OnClickSaveBtn = OnClickSaveBtn
UIPVESceneView.RefreshAdventureArmyAndHero = RefreshAdventureArmyAndHero
UIPVESceneView.RefreshPlayBackArmy = RefreshPlayBackArmy
UIPVESceneView.RefreshPlayBackEmArmy = RefreshPlayBackEmArmy
UIPVESceneView.OnClickLock = OnClickLock
UIPVESceneView.CheckRemoveTipsByBuffId = CheckRemoveTipsByBuffId
UIPVESceneView.SetSelectBuff = SetSelectBuff
UIPVESceneView.CheckShowRedDot = CheckShowRedDot
UIPVESceneView.ShowHeadInfo = ShowHeadInfo
UIPVESceneView.CheckShowSpeedEffect = CheckShowSpeedEffect
UIPVESceneView.CheckShowResultBtn = CheckShowResultBtn
UIPVESceneView.OnRaidClick = OnRaidClick
UIPVESceneView.OnShopClick = OnShopClick
UIPVESceneView.RefreshStamina = RefreshStamina
UIPVESceneView.CheckShowRestraint = CheckShowRestraint
UIPVESceneView.OnCampClick = OnCampClick
UIPVESceneView.OnRightCampClick = OnRightCampClick
UIPVESceneView.SetBtnLimitText = SetBtnLimitText
UIPVESceneView.SetBtnLimitIcon = SetBtnLimitIcon
return UIPVESceneView
