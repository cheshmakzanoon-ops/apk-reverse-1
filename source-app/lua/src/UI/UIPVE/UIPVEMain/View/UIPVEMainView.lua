local UIPVEMainView = BaseClass("UIPVEMainView", UIBaseView)
local base = UIBaseView
local Const = require("Scene.PVEBattleLevel.Const")
local Localization = CS.GameEntry.Localization
local BallType = {Task = 1, Warn = 2}
local PVELevelSlider = require("UI.UIPVE.UIPVEMain.Component.PVELevelSlider")
local UIPVEResourceLayer = require("UI.UIPVE.UIPVEMain.Component.UIPVEResourceLayer")
local UIPVERewardLayer = require("UI.UIPVE.UIPVEMain.Component.UIPVERewardLayer")
local UIPVEBattleBuff = require("UI.UIPVE.UIPVEMain.Component.UIPVEBattleBuff")
local UIPVESkill = require("UI.UIPVE.UIPVEMain.Component.UIPVESkill")
local UIPVEStaminaSlider = require("UI.UIPVE.UIPVEMain.Component.UIPVEStaminaSlider")
local UIPVETask = require("UI.UIPVE.UIPVEMain.Component.UIPVETask")
local UIPVETaskMsg = require("UI.UIPVE.UIPVEMain.Component.UIPVETaskMsg")
local PVEViewOption = require("UI.UIPVE.UIPVEMain.Component.PVEViewOption")
local UIPVECharacterArrow = require("UI.UIPVE.UIPVEMain.Component.UIPVECharacterArrow")
local UIPVEMainPveAct = require("UI.UIPVE.UIPVEMain.Component.UIPVEMainPveAct")
local UIPVEPackList = require("UI.UIPVE.UIPVEMain.Component.UIPVEPackList")
local UIPVEJoystick = require("UI.UIPVE.UIPVEMain.Component.UIPVEJoystick")
local home_btn_path = "safeArea/bottomLayer/HomeBtn"
local hero_btn_path = "safeArea/bottomLayer/HeroBtn"
local back_btn_path = "safeArea/leftLayer/BackBtn"
local player_obj_path = "safeArea/leftLayer/playerObj"
local goods_btn_path = "safeArea/rightLayer/ResourceBar1/GoodsBtn"
local goods_num_path = "safeArea/rightLayer/ResourceBar1/GoodsBtn/GoodsRoot/GoodsNum"
local anim_path = "safeArea"
local level_start_btn_path = "safeArea/bottomLayer/LevelStart"
local level_start_text_path = "safeArea/bottomLayer/LevelStart/LevelStartText"
local battle_buff_path = "safeArea/bottomLayer/BattleBuff"
local slider_go_path = "safeArea/bottomLayer/SliderGo"
local resource_layer_path = "safeArea/rightLayer/ResourceBar1"
local reward_layer_path = "safeArea/leftLayer/UIPVERewardLayer"
local setting_path = "safeArea/leftLayer/Setting"
local debug_path = "safeArea/leftLayer/Debug"
local skill_go_path = "safeArea/bottomLayer/SkillGo"
local skill_btn_path = "safeArea/bottomLayer/SkillGo/SkillBtn"
local stamina_slider_go_path = "safeArea/topLayer/StaminaSliderGo"
local gray_mask_path = "GrayMask"
local pveTaskMsg_path = "safeArea/leftLayer/msglist/PveTaskMsg"
local safe_area_path = "safeArea"
local view_option_path = "safeArea/rightLayer/ViewOption"
local msglist_path = "safeArea/leftLayer/msglist"
local msglist_content_path = "safeArea/leftLayer/msglist/viewport/content"
local pve_act_path = "safeArea/rightLayer/Entrance/PveAct"
local lv_point_bar_path = "safeArea/rightLayer/ResourceBar1/LvPointBar"
local lv_point_num_path = "safeArea/rightLayer/ResourceBar1/LvPointBar/LvPointNum"
local char_arrow_path = "safeArea/CharacterArrow"
local pack_list_path = "safeArea/rightLayer/Entrance/PackList"
local gray_mask_arrow_path = "GrayMask/ArrowGo"
local joystick_path = "safeArea/Joystick"
local dark_corner_path = "DarkCorner"
local WarnList = 9999
local MaskDelta = {
  Bag = {
    position = Vector3.New(0, -30, 0),
    rotation = Vector3.New(0, 0, 180)
  },
  Stamina = {
    position = Vector3.New(0, -30, 0),
    rotation = Vector3.New(0, 0, 180)
  },
  Resource = {
    position = Vector3.New(-100, -60, 0),
    rotation = Vector3.New(0, 0, 135)
  }
}
local GuideEndWaitShowQuestTime = 0.8
local ContentEnum = {
  LevelStartBtn = 1,
  HeroBtn = 5,
  HomeBtn = 6,
  BackBtn = 7,
  PlayerObj = 8,
  RewardLayer = 10,
  StaminaSlider = 13,
  Goods = 14,
  ResourceLayer = 15,
  SkillGo = 16,
  PveAct = 17,
  LvPoint = 18
}
UIPVEMainView.ContentEnum = ContentEnum

function UIPVEMainView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIPVEMainView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPVEMainView:ComponentDefine()
  self.safe_area = self:AddComponent(UIBaseContainer, safe_area_path)
  self.home_btn = self:AddComponent(UIButton, home_btn_path)
  self.home_btn:SetOnClick(function()
    self:OnBtnHome()
  end)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnBtnHome()
  end)
  self.hero_btn = self:AddComponent(UIButton, hero_btn_path)
  self.hero_btn:SetOnClick(function()
    self:OnBtnHero()
  end)
  self.player_obj_go = self:AddComponent(UIBaseContainer, player_obj_path)
  self.goods_btn = self:AddComponent(UIButton, goods_btn_path)
  self.goods_btn:SetOnClick(function()
    self:OnBtnGoods()
  end)
  self.goods_num = self:AddComponent(UIText, goods_num_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.level_start_btn = self:AddComponent(UIButton, level_start_btn_path)
  self.level_start_btn:SetOnClick(function()
    self:OnBtnLevelStart()
  end)
  self.level_start_text = self:AddComponent(UIText, level_start_text_path)
  self.level_start_text:SetLocalText(110058)
  self.slider_go = self:AddComponent(PVELevelSlider, slider_go_path)
  self.resource_layer = self:AddComponent(UIPVEResourceLayer, resource_layer_path)
  self.reward_layer = self:AddComponent(UIPVERewardLayer, reward_layer_path)
  self.skill_go = self:AddComponent(UIBaseContainer, skill_go_path)
  self.skill = self:AddComponent(UIPVESkill, skill_btn_path)
  self.setting_btn = self:AddComponent(UIButton, setting_path)
  self.setting_btn:SetOnClick(function()
    self:OnSettingClick()
  end)
  self.debug_btn = self:AddComponent(UIButton, debug_path)
  self.debug_btn:SetOnClick(function()
    self:OnDebugClick()
  end)
  self.debug_btn:SetActive(CS.CommonUtils.IsDebug())
  self.battle_buff = self:AddComponent(UIPVEBattleBuff, battle_buff_path)
  self.battle_buff:ReInit()
  self.stamina_slider_go = self:AddComponent(UIPVEStaminaSlider, stamina_slider_go_path)
  self._pveTaskMsg_rect = self:AddComponent(UIPVETaskMsg, pveTaskMsg_path)
  self._pveTaskMsg_rect:GetQuest(function()
    return self:GetQuestCell()
  end)
  self.msgContent = self:AddComponent(UIBaseContainer, msglist_content_path)
  self.msglist_trigger = self:AddComponent(UIEventTrigger, msglist_path)
  self.msglist_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.view_option = self:AddComponent(PVEViewOption, view_option_path)
  self.view_option:SetOnClick(function(isOn)
    self:OnViewOptionClick(isOn)
  end)
  self.view_option:SetActive(DataCenter.BattleLevel:IsZoomOn())
  self.pve_act = self:AddComponent(UIPVEMainPveAct, pve_act_path)
  self.lv_point_bar_go = self:AddComponent(UIBaseContainer, lv_point_bar_path)
  self.lv_point_num_text = self:AddComponent(UIText, lv_point_num_path)
  self.char_arrow = self:AddComponent(UIPVECharacterArrow, char_arrow_path)
  self.contents = {
    [ContentEnum.LevelStartBtn] = self.level_start_btn,
    [ContentEnum.HeroBtn] = self.hero_btn,
    [ContentEnum.HomeBtn] = self.home_btn,
    [ContentEnum.BackBtn] = self.back_btn,
    [ContentEnum.PlayerObj] = self.player_obj_go,
    [ContentEnum.RewardLayer] = self.reward_layer,
    [ContentEnum.StaminaSlider] = self.stamina_slider_go,
    [ContentEnum.Goods] = self.goods_btn,
    [ContentEnum.ResourceLayer] = self.resource_layer,
    [ContentEnum.SkillGo] = self.skill_go,
    [ContentEnum.PveAct] = self.pve_act,
    [ContentEnum.LvPoint] = self.lv_point_bar_go
  }
  self.hideInHighView = {
    [ContentEnum.SkillGo] = true
  }
  self.gray_mask = self:AddComponent(UIButton, gray_mask_path)
  self.gray_mask:SetOnClick(function()
    self:OnClickGrayMask()
  end)
  self.gray_mask:SetActive(false)
  self.pack_list = self:AddComponent(UIPVEPackList, pack_list_path)
  self.gray_mask_arrow = self:AddComponent(UIBaseContainer, gray_mask_arrow_path)
  self.joystick = self:AddComponent(UIPVEJoystick, joystick_path)
  self.dark_corner_image = self:AddComponent(UIImage, dark_corner_path)
end

function UIPVEMainView:ComponentDestroy()
  self.safe_area = nil
  self.home_btn = nil
  self.back_btn = nil
  self.hero_btn = nil
  self.goods_btn = nil
  self.goods_num = nil
  self.anim = nil
  self.slider_go = nil
  self.resource_layer = nil
  self.reward_layer = nil
  self.contents = nil
  self.skill = nil
  self.stamina_slider_go = nil
  self.pve_act = nil
  self.lv_point_bar_go = nil
  self.lv_point_num_text = nil
  self.hideInHighView = nil
  self.char_arrow = nil
  self.pack_list = nil
  self.joystick = nil
  self.dark_corner_image = nil
  DataCenter.BattleLevel:SetJoystick(nil)
end

function UIPVEMainView:DataDefine()
  self.param = {}
  self.levelId = 0
  self.heroes = {}
  self.showingContent = self.showingContent or {}
  self.questCell = {}
  self.questObj = {}
  self.timer = nil
  self.isShowMask = false
  self.isPlayTask = false
  self.guideMaskParam = nil
  self.guide_end_show_quest = nil
  
  function self.guide_end_show_quest_action(temp)
    self:GuideEndShowQuest()
  end
end

function UIPVEMainView:DataDestroy()
  self.param = {}
  self.levelId = nil
  self.heroes = nil
  self.showingContent = nil
  self.questCell = nil
  self.msgContent:RemoveComponents(UIPVETask)
  for k, v in pairs(self.questObj) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self.questObj = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.isShowMask = false
  self.isPlayTask = nil
  self.guideMaskParam = nil
  self:DeleteGuideEndShowQuestTimer()
end

function UIPVEMainView:OnEnable()
  base.OnEnable(self)
  self.param = self:GetUserData()
  self.levelId = self.param.levelId
  if self.param.heroes then
    self:SetHeroes(self.param.heroes)
  end
  self:ReInit()
end

function UIPVEMainView:OnDisable()
  base.OnDisable(self)
end

function UIPVEMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PVE_Exit, self.OnExit)
  self:AddUIListener(EventId.PVEHeroExpFly, self.OnPVEHeroExpFly)
  self:AddUIListener(EventId.FormationStaminaUpdate, self.PveStaminaUpdateSignal)
  self:AddUIListener(EventId.ResourceUpdated, self.ResourceUpdatedSignal)
  self:AddUIListener(EventId.RefreshResourceItem, self.RefreshResourceItemSignal)
  self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:AddUIListener(EventId.MainTaskSuccess, self.PveTaskRefresh)
  self:AddUIListener(EventId.PveActTaskUpdate, self.PveTaskRefresh)
  self:AddUIListener(EventId.PveTaskGetReward, self.PveTaskGetRewardSignal)
  self:AddUIListener(EventId.SetPveSkillVisible, self.SetPveSkillVisibleSignal)
  self:AddUIListener(EventId.RefreshUIPveMainVisible, self.RefreshUIPveMainVisibleSignal)
  self:AddUIListener(EventId.SetPveStopRefreshStamina, self.SetPveStopRefreshStaminaSignal)
  self:AddUIListener(EventId.SetPveNoClickStamina, self.SetPveNoClickStaminaSignal)
  self:AddUIListener(EventId.SetGuideMask, self.SetGuideMaskSignal)
end

function UIPVEMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.PVE_Exit, self.OnExit)
  self:RemoveUIListener(EventId.PVEHeroExpFly, self.OnPVEHeroExpFly)
  self:RemoveUIListener(EventId.FormationStaminaUpdate, self.PveStaminaUpdateSignal)
  self:RemoveUIListener(EventId.ResourceUpdated, self.ResourceUpdatedSignal)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.RefreshResourceItemSignal)
  self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:RemoveUIListener(EventId.MainTaskSuccess, self.PveTaskRefresh)
  self:RemoveUIListener(EventId.PveActTaskUpdate, self.PveTaskRefresh)
  self:RemoveUIListener(EventId.PveTaskGetReward, self.PveTaskGetRewardSignal)
  self:RemoveUIListener(EventId.SetPveSkillVisible, self.SetPveSkillVisibleSignal)
  self:RemoveUIListener(EventId.RefreshUIPveMainVisible, self.RefreshUIPveMainVisibleSignal)
  self:RemoveUIListener(EventId.SetPveStopRefreshStamina, self.SetPveStopRefreshStaminaSignal)
  self:RemoveUIListener(EventId.SetPveNoClickStamina, self.SetPveNoClickStaminaSignal)
  self:RemoveUIListener(EventId.SetGuideMask, self.SetGuideMaskSignal)
  base.OnRemoveListener(self)
end

function UIPVEMainView:TimerAction()
end

function UIPVEMainView:ReInit()
  local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(self.levelId)
  self:InitGoodsNum()
  self:InitContents()
  self:SetUsedTime(self.usedTime or 0)
  self:RefreshHeroExpPanel()
  self.level_start_btn:SetInteractable(true)
  self.pve_act:ReInit(self.levelId)
  self.pack_list:Refresh()
  self.char_arrow:ReInit()
  self.joystick:ReInit()
  DataCenter.BattleLevel:SetJoystick(self.joystick)
  local pveTask = DataCenter.TaskManager:GetPveTaskList(self.levelId)
  for i = 1, #pveTask do
    if not self.questCell[i] then
      self.questObj[i] = self:GameObjectInstantiateAsync(UIAssets.UIPveQuestObj, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.msgContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = "questViceObj" .. i
        go.name = nameStr
        local cell = self.msgContent:AddComponent(UIPVETask, nameStr)
        cell:ReInit(pveTask[i], self.levelId, self._pveTaskMsg_rect)
        self.questCell[i] = cell
      end)
    end
  end
  if self.questCell then
    self:PveTaskListHandle(2)
  end
  if self.param.initSkillNum ~= nil then
    self:AddSkillSliderNum(self.param.initSkillNum)
  end
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  self.timer:Start()
  if pveTemplate.darkCornerType == Const.DarkCornerType.None then
    self.dark_corner_image:SetActive(false)
  else
    self.dark_corner_image:SetActive(true)
    self.dark_corner_image:LoadSprite(string.format(LoadPath.PVEScene, "UIpve_dark_corner_" .. pveTemplate.darkCornerType))
  end
end

function UIPVEMainView:RefreshHeroExpPanel()
end

function UIPVEMainView:OnBtnPause()
  if not DataCenter.BattleLevel:IsPaused() then
    DataCenter.BattleLevel:Pause()
  end
end

function UIPVEMainView:OnBtnHome()
  if DataCenter.BattleLevel:HandleSpecialEnd(nil, BindCallback(self, self.DoEnd)) then
    return
  else
    self:DoEnd()
  end
end

function UIPVEMainView:DoEnd()
  local levelType = DataCenter.BattleLevel:GetLevelType()
  if levelType == PveLevelType.NormalLevel or levelType == PveLevelType.NormalExpLevel or levelType == PveLevelType.SkillLevel then
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickPveBackBtn, tostring(self.levelId))
    self:OnExit()
  else
    UIUtil.ShowMessage(Localization:GetString("400001"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickPveBackBtn, tostring(self.levelId))
      self:OnExit()
    end)
  end
end

function UIPVEMainView:OnBtnHero()
  self.view.ctrl:OnFunctionClick(UIMainFunctionInfo.Hero)
end

function UIPVEMainView:OnBtnGoods()
  self.view.ctrl:OnFunctionClick(UIMainFunctionInfo.Goods)
end

function UIPVEMainView:OnBtnLevelStart()
  local curHeroCount = table.count(self.heroes)
  if curHeroCount == 0 then
    UIUtil.ShowTipsId(140065)
    return
  end
  if DataCenter.BuildManager.MainLv <= 8 and curHeroCount < 2 then
    UIUtil.ShowTipsId(140065)
    return
  end
  local maxHeroCount = DataCenter.BattleLevel:GetMaxHeroCount()
  PveUtil.CheckHeroSlotEmpty(curHeroCount, maxHeroCount, function()
    PveUtil.CheckHeroesRarity(self.heroes, function()
      PveUtil.CheckHeroesBreak(self.heroes, function()
        PveUtil.CheckHeroesMaxed(self.heroes, function()
          self.level_start_btn:SetInteractable(false)
          DataCenter.BattleLevel:GoStart()
        end)
      end)
    end)
  end)
end

function UIPVEMainView:InitGoodsNum()
  local storageCurExtra = LuaEntry.Effect:GetGameEffect(EffectDefine.STORAGE_MAX_EXTRA)
  local curNum = DataCenter.ResourceItemDataManager:GetResourceItemTotalNumByType(ResourceItemType.Farming)
  local maxNum = DataCenter.ResourceItemDataManager:GetFreezerStorageMax(true) + storageCurExtra
  self.goods_num:SetText(tostring(curNum) .. "/" .. math.floor(maxNum))
  if curNum >= maxNum and self.questCell then
    DataCenter.WarningBallManager:CheckBag()
  end
  if curNum < maxNum and self.questCell then
    for i = 1, table.count(self.questCell) do
      if self.questCell[i].ballState and self.questCell[i].ballState == BallType.Warn and self.questCell[i].warnIsShow then
        self.questCell[i]:BallPlayHide()
      end
    end
  end
end

function UIPVEMainView:InitContents()
  for _, contentEnum in pairs(ContentEnum) do
    self:ShowContent(contentEnum, self.showingContent[contentEnum])
  end
end

function UIPVEMainView:ShowContent(contentEnum, show)
  if self.showingContent == nil then
    self.showingContent = {}
  end
  self.showingContent[contentEnum] = show or false
  if self.contents and self.contents[contentEnum] then
    local isVisible = false
    if show ~= nil then
      isVisible = show
    end
    if self.view_option:GetIsOn() and self.hideInHighView[contentEnum] then
      isVisible = false
    end
    self.contents[contentEnum]:SetActive(isVisible)
  end
end

function UIPVEMainView:OnExit()
  DataCenter.BattleLevel:Exit(nil, PveExitType.ExitBtn)
end

function UIPVEMainView:PlayAnim(animName)
  self.anim:Play(animName, 0, 0)
end

function UIPVEMainView:SetUsedTime(usedTime)
  self.usedTime = usedTime
end

function UIPVEMainView:SetHeroes(heroes)
  self.heroes = heroes
end

function UIPVEMainView:SetOnHeroChanged(onHeroChanged)
  self.onHeroChanged = onHeroChanged
end

function UIPVEMainView:OnHeroChanged(i, heroUuid, isAdd)
  self:RefreshHeroExpPanel()
  if self.onHeroChanged then
    self.onHeroChanged(i, heroUuid, isAdd)
  end
end

function UIPVEMainView:SetSliderVisible(visible)
  if self.slider_go then
    self.slider_go:SetVisible(visible)
  end
end

function UIPVEMainView:SetSliderData(param)
  if self.slider_go then
    self.slider_go:SetData(param)
  end
end

function UIPVEMainView:AddOneBuff(id)
end

function UIPVEMainView:RemoveOneBuff(id)
  if self.skill ~= nil then
    self.skill:RemoveOneBuff(id)
  end
end

function UIPVEMainView:OnPveEnter(levelType)
  if levelType == PveLevelType.NormalLevel or levelType == PveLevelType.ZombieLevel or levelType == PveLevelType.ArmyLevel or levelType == PveLevelType.BarrageLevel then
    self:ShowContent(ContentEnum.BackBtn, true)
    self:ShowContent(ContentEnum.LevelStartBtn, false)
    self:ShowContent(ContentEnum.HeroBtn, true)
    self:ShowContent(ContentEnum.StaminaSlider, true)
    self:ShowContent(ContentEnum.Goods, true)
    self:ShowContent(ContentEnum.RewardLayer, true)
    self:ShowContent(ContentEnum.ResourceLayer, true)
    self:ShowContent(ContentEnum.SkillGo, true)
  elseif levelType == PveLevelType.HeroExpLevel then
    self:ShowContent(ContentEnum.BackBtn, true)
    self:ShowContent(ContentEnum.LevelStartBtn, true)
    self:ShowContent(ContentEnum.HeroBtn, false)
    self:ShowContent(ContentEnum.StaminaSlider, false)
    self:ShowContent(ContentEnum.Goods, true)
    self:ShowContent(ContentEnum.RewardLayer, true)
    self:ShowContent(ContentEnum.ResourceLayer, true)
    self:ShowContent(ContentEnum.SkillGo, false)
  elseif levelType == PveLevelType.NormalExpLevel then
    self:ShowContent(ContentEnum.BackBtn, true)
    self:ShowContent(ContentEnum.LevelStartBtn, false)
    self:ShowContent(ContentEnum.HeroBtn, false)
    self:ShowContent(ContentEnum.StaminaSlider, true)
    self:ShowContent(ContentEnum.Goods, true)
    self:ShowContent(ContentEnum.RewardLayer, true)
    self:ShowContent(ContentEnum.ResourceLayer, true)
    self:ShowContent(ContentEnum.SkillGo, true)
  elseif levelType == PveLevelType.BattleExpLevel then
    self:ShowContent(ContentEnum.BackBtn, true)
    self:ShowContent(ContentEnum.LevelStartBtn, false)
    self:ShowContent(ContentEnum.HeroBtn, false)
    self:ShowContent(ContentEnum.StaminaSlider, false)
    self:ShowContent(ContentEnum.Goods, true)
    self:ShowContent(ContentEnum.RewardLayer, true)
    self:ShowContent(ContentEnum.ResourceLayer, false)
    self:ShowContent(ContentEnum.SkillGo, false)
  elseif levelType == PveLevelType.AdventureLevel then
    self:ShowContent(ContentEnum.BackBtn, false)
    self:ShowContent(ContentEnum.LevelStartBtn, false)
    self:ShowContent(ContentEnum.HeroBtn, false)
    self:ShowContent(ContentEnum.StaminaSlider, false)
    self:ShowContent(ContentEnum.Goods, false)
    self:ShowContent(ContentEnum.RewardLayer, false)
    self:ShowContent(ContentEnum.ResourceLayer, false)
    self:ShowContent(ContentEnum.SkillGo, false)
  elseif levelType == PveLevelType.SkillLevel then
    self:ShowContent(ContentEnum.BackBtn, true)
    self:ShowContent(ContentEnum.LevelStartBtn, false)
    self:ShowContent(ContentEnum.HeroBtn, false)
    self:ShowContent(ContentEnum.StaminaSlider, true)
    self:ShowContent(ContentEnum.Goods, true)
    self:ShowContent(ContentEnum.RewardLayer, true)
    self:ShowContent(ContentEnum.ResourceLayer, true)
    self:ShowContent(ContentEnum.SkillGo, true)
  end
  self:ShowContent(ContentEnum.HomeBtn, false)
  self:ShowContent(ContentEnum.PlayerObj, true)
  self:ShowContent(ContentEnum.RewardLayer, true)
  self:ShowContent(ContentEnum.LvPoint, false)
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.PveAct then
    self:ShowContent(ContentEnum.PveAct, true)
  else
    self:ShowContent(ContentEnum.PveAct, false)
  end
end

function UIPVEMainView:OnPveStart(levelType)
  self:ShowContent(ContentEnum.LevelStartBtn, false)
  self:ShowContent(ContentEnum.StaminaSlider, true)
  if levelType == PveLevelType.HeroExpLevel then
    self:ShowContent(ContentEnum.LevelStartBtn, false)
    self:ShowContent(ContentEnum.SkillGo, true)
    self:ShowContent(ContentEnum.LvPoint, true)
  end
end

function UIPVEMainView:RefreshCarryResource()
  if self.resource_layer ~= nil then
    self.resource_layer:Refresh()
  end
end

function UIPVEMainView:RefreshFrontReward()
  if self.reward_layer ~= nil then
    self.reward_layer:Refresh()
  end
end

function UIPVEMainView:OnPVEHeroExpFly(param)
  if self.reward_layer ~= nil then
    local destPos = self.reward_layer.bg_image.transform.position
    local model = "Assets/_Art/Effect/prefab/ui/Common/FlyPveHeroExp.prefab"
    UIUtil.DoFlyCustom(nil, nil, 1, param.pos, destPos, nil, nil, nil, model)
  end
end

function UIPVEMainView:GetCanAddHero()
  return self.ctrl:GetCanAddHero()
end

function UIPVEMainView:OnDebugClick()
  if CS.CommonUtils.IsDebug() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEDebug)
  end
end

function UIPVEMainView:OnSettingClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingSet)
end

function UIPVEMainView:GetFlyNode(resType)
  if self.resource_layer ~= nil then
    return self.resource_layer:GetFlyNode(resType)
  end
end

function UIPVEMainView:AddSkillSliderNum(num)
  if self.skill ~= nil then
    self.skill:AddNum(num)
  end
end

function UIPVEMainView:ShowBuyAttackShop(list)
end

function UIPVEMainView:RefreshBuff()
end

function UIPVEMainView:RefreshPveStamina()
  if self.stamina_slider_go ~= nil then
    self.stamina_slider_go:RefreshStaminaLater()
  end
end

function UIPVEMainView:PveStaminaUpdateSignal()
  self:RefreshPveStamina()
end

function UIPVEMainView:ResourceUpdatedSignal()
  if self.resource_layer ~= nil then
    self.resource_layer:Refresh()
  end
end

function UIPVEMainView:RefreshResourceItemSignal()
  self:InitGoodsNum()
  if self.resource_layer ~= nil then
    self.resource_layer:Refresh()
  end
end

function UIPVEMainView:RefreshGuideSignal()
  self:AddGuideEndShowQuestTimer()
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil then
    if template.type == GuideType.PveShowStaminaLight then
      local canClickTime = tonumber(template.para1)
      local autoHideTime = tonumber(template.para2)
      self:ShowGuideMask(canClickTime, autoHideTime)
    end
  elseif self.isShowMask then
    self:SetGuideMaskSignal({
      eventType = GuideMaskTypeSignalType.UIPveMainResourceHide
    })
    self:SetGuideMaskSignal({
      eventType = GuideMaskTypeSignalType.UIPveMainStaminaSliderHide
    })
    self:SetGuideMaskSignal({
      eventType = GuideMaskTypeSignalType.UIPveMainBagHide
    })
  end
end

function UIPVEMainView:ShowGuideMask(canClickTime, autoHideTime)
  self.gray_mask:SetActive(true)
  self.canClickGuideMask = false
  self:StartTimer(canClickTime, autoHideTime)
end

function UIPVEMainView:OnClickGrayMask()
  if self.canClickGuideMask then
    self.gray_mask:SetActive(false)
    local guideType = DataCenter.GuideManager:GetGuideType()
    if guideType == GuideType.PveShowStaminaLight or guideType == GuideType.SetPveBagGuide or guideType == GuideType.SetPveOutBagGuide then
      DataCenter.GuideManager:DoNext()
    end
    if self.delayTimer1 ~= nil then
      self.delayTimer1:Stop()
      self.delayTimer1 = nil
    end
    if self.delayTimer2 ~= nil then
      self.delayTimer2:Stop()
      self.delayTimer2 = nil
    end
  end
end

function UIPVEMainView:StartTimer(canClickTime, autoHideTime)
  local realTime1 = 2
  if canClickTime ~= nil and canClickTime ~= "" then
    realTime1 = tonumber(canClickTime)
    if realTime1 ~= nil then
      realTime1 = math.ceil(tonumber(canClickTime) / 1000)
    else
      realTime1 = 2
    end
  end
  local realTime2 = 3
  if autoHideTime ~= nil and autoHideTime ~= "" then
    realTime2 = tonumber(autoHideTime)
    if realTime2 ~= nil then
      realTime2 = math.ceil(tonumber(autoHideTime) / 1000)
    else
      realTime2 = 3
    end
  end
  self.delayTimer1 = TimerManager:GetInstance():DelayInvoke(function()
    self.canClickGuideMask = true
  end, realTime1)
  self.delayTimer2 = TimerManager:GetInstance():DelayInvoke(function()
    self.canClickGuideMask = true
    self:OnClickGrayMask()
  end, realTime2)
end

function UIPVEMainView:PveTaskRefresh()
  self:PveTaskListHandle(2)
  self.pve_act:Refresh()
end

function UIPVEMainView:PveTaskGetRewardSignal(param)
  self:PveTaskListHandle(3, param)
end

function UIPVEMainView:PveTaskListHandle(type, param)
  for i = 1, #self.questCell do
    if type == 2 then
      self.questCell[i]:RefreshTask(2)
    elseif type == 3 then
      self.questCell[i]:CheckIsReward(param)
    end
  end
end

function UIPVEMainView:CheckTaskCanReceive()
  local pveTask = DataCenter.TaskManager:GetPveTaskList(self.levelId)
  for i = 1, table.count(pveTask) do
    if pveTask[i] ~= WarnList then
      local taskData = DataCenter.TaskManager:GetPveTaskByList(tonumber(pveTask[i]), self.levelId)
      if taskData and taskData.state == TaskState.CanReceive then
        self:PveTaskListHandle(2)
        break
      end
    end
  end
end

function UIPVEMainView:AddGuideEndShowQuestTimer()
  self:DeleteGuideEndShowQuestTimer()
  if self.guide_end_show_quest == nil then
    self.guide_end_show_quest = TimerManager:GetInstance():GetTimer(GuideEndWaitShowQuestTime, self.guide_end_show_quest_action, self, true, false, false)
    self.guide_end_show_quest:Start()
  end
end

function UIPVEMainView:GuideEndShowQuest()
  self:DeleteGuideEndShowQuestTimer()
  if self.questCell then
    for i = 1, table.count(self.questCell) do
      if self.questCell[i].taskData and self.questCell[i]:GetBallType() == BallType.Task then
        self.questCell[i]:RefreshTask(3)
        return
      end
    end
  end
end

function UIPVEMainView:DeleteGuideEndShowQuestTimer()
  if self.guide_end_show_quest ~= nil then
    self.guide_end_show_quest:Stop()
    self.guide_end_show_quest = nil
  end
end

function UIPVEMainView:SetPveSkillVisibleSignal()
  if self.skill ~= nil then
    self.skill:ReInit()
  end
end

function UIPVEMainView:RefreshUIPveMainVisibleSignal(param)
  if param ~= nil then
    local showUIMainType = tonumber(param)
    if showUIMainType == GuideUIMainShowType.Hide then
      self.safe_area:SetActive(false)
    elseif showUIMainType == GuideUIMainShowType.Show then
      self.safe_area:SetActive(true)
    end
  end
end

function UIPVEMainView:OnViewOptionClick(isOn)
  DataCenter.BattleLevel:SetHighView(isOn, true)
  for contentEnum, _ in pairs(self.hideInHighView) do
    self:ShowContent(contentEnum, self.showingContent[contentEnum])
  end
end

function UIPVEMainView:GetQuestCell()
  return self.questCell
end

function UIPVEMainView:GetSkillSliderNum()
  if self.skill ~= nil then
    return self.skill:GetNum()
  end
  return 0
end

function UIPVEMainView:SetPveStopRefreshStaminaSignal(param)
  if param ~= nil then
    local visible = tonumber(param)
    if visible == GuideSetNormalVisible.Hide then
      if self.stamina_slider_go ~= nil then
        self.stamina_slider_go:SetStopRefresh(false)
        self.stamina_slider_go:SetNoClick(false)
      end
    elseif visible == GuideSetNormalVisible.Show and self.stamina_slider_go ~= nil then
      self.stamina_slider_go:SetStopRefresh(true)
    end
  end
end

function UIPVEMainView:SetPveNoClickStaminaSignal(param)
  if param ~= nil then
    local visible = tonumber(param)
    if visible == GuideSetNormalVisible.Hide then
      if self.stamina_slider_go ~= nil then
        self.stamina_slider_go:SetNoClick(false)
      end
    elseif visible == GuideSetNormalVisible.Show and self.stamina_slider_go ~= nil then
      self.stamina_slider_go:SetNoClick(true)
    end
  end
end

function UIPVEMainView:GetFlyPosByRewardType(rewardType)
  if rewardType == RewardType.PVE_ACT_SCORE then
    if self.pve_act ~= nil and self.pve_act.rank_btn.gameObject.activeInHierarchy then
      return self.pve_act.rank_btn.transform.position
    elseif self.pve_act ~= nil and self.pve_act.main_btn.gameObject.activeInHierarchy then
      return self.pve_act.main_btn.transform.position
    elseif self.goods_btn ~= nil and self.goods_btn.gameObject.activeInHierarchy then
      return self.goods_btn.transform.position
    else
      return nil
    end
  end
end

function UIPVEMainView:SetLvPoint(lvPoint)
  if self.lv_point_num_text then
    self.lv_point_num_text:SetText(string.GetFormattedSeperatorNum(lvPoint))
  end
end

function UIPVEMainView:SetGuideMaskSignal(param)
  if param ~= nil then
    local eventType = param.eventType
    if eventType == GuideMaskTypeSignalType.UIPveMainBagHide then
      self.isShowMask = false
      if self.guideMaskParam ~= nil then
        self.guideMaskParam.transform.parent = self.guideMaskParam.originalParent.transform
        self.guideMaskParam.transform:SetSiblingIndex(self.guideMaskParam.childIndex)
        self.guideMaskParam.maskParent:SetActive(false)
        self.guideMaskParam = nil
      end
    elseif eventType == GuideMaskTypeSignalType.UIPveMainBagShow then
      self.isShowMask = true
      self.guideMaskParam = {}
      self.guideMaskParam.originalParent = self.goods_btn.transform.parent
      self.guideMaskParam.childIndex = self.goods_btn.transform:GetSiblingIndex()
      self.guideMaskParam.transform = self.goods_btn.transform
      self.guideMaskParam.maskParent = self.gray_mask
      self.guideMaskParam.maskParent:SetActive(true)
      self.guideMaskParam.transform:SetParent(self.guideMaskParam.maskParent.transform)
      local maskParam = MaskDelta.Bag
      if maskParam ~= nil then
        self.gray_mask_arrow:SetPosition(self.guideMaskParam.transform.position + maskParam.position)
        self.gray_mask_arrow:SetEulerAngles(maskParam.rotation)
      end
    elseif eventType == GuideMaskTypeSignalType.UIPveMainResourceHide then
      self.isShowMask = false
      if self.guideMaskParam ~= nil then
        self.guideMaskParam.transform.parent = self.guideMaskParam.originalParent.transform
        self.guideMaskParam.transform:SetSiblingIndex(self.guideMaskParam.childIndex)
        self.guideMaskParam.maskParent:SetActive(false)
        self.guideMaskParam = nil
      end
    elseif eventType == GuideMaskTypeSignalType.UIPveMainResourceShow then
      self.isShowMask = true
      self.guideMaskParam = {}
      self.guideMaskParam.originalParent = self.resource_layer.transform.parent
      self.guideMaskParam.childIndex = self.resource_layer.transform:GetSiblingIndex()
      self.guideMaskParam.transform = self.resource_layer.transform
      self.guideMaskParam.maskParent = self.gray_mask
      self.guideMaskParam.maskParent:SetActive(true)
      self.guideMaskParam.transform:SetParent(self.guideMaskParam.maskParent.transform)
      local maskParam = MaskDelta.Resource
      if maskParam ~= nil then
        self.gray_mask_arrow:SetPosition(self.guideMaskParam.transform.position + maskParam.position)
        self.gray_mask_arrow:SetEulerAngles(maskParam.rotation)
      end
    elseif eventType == GuideMaskTypeSignalType.UIPveMainStaminaSliderHide then
      self.isShowMask = false
      if self.guideMaskParam ~= nil then
        self.guideMaskParam.transform.parent = self.guideMaskParam.originalParent.transform
        self.guideMaskParam.transform:SetSiblingIndex(self.guideMaskParam.childIndex)
        self.guideMaskParam.maskParent:SetActive(false)
        self.guideMaskParam = nil
      end
      self:SetPveStopRefreshStaminaSignal(GuideSetNormalVisible.Hide)
    elseif eventType == GuideMaskTypeSignalType.UIPveMainStaminaSliderShow then
      self.isShowMask = true
      self.guideMaskParam = {}
      self.guideMaskParam.originalParent = self.stamina_slider_go.transform.parent
      self.guideMaskParam.childIndex = self.stamina_slider_go.transform:GetSiblingIndex()
      self.guideMaskParam.transform = self.stamina_slider_go.transform
      self.guideMaskParam.maskParent = self.gray_mask
      self.guideMaskParam.maskParent:SetActive(true)
      self.guideMaskParam.transform:SetParent(self.guideMaskParam.maskParent.transform)
      local maskParam = MaskDelta.Stamina
      if maskParam ~= nil then
        self.gray_mask_arrow:SetPosition(self.guideMaskParam.transform.position + maskParam.position)
        self.gray_mask_arrow:SetEulerAngles(maskParam.rotation)
      end
      self:SetPveStopRefreshStaminaSignal(GuideSetNormalVisible.Show)
    end
  end
end

function UIPVEMainView:OnBeginDrag(eventData)
  self._pveTaskMsg_rect:AutoHideTaskTime()
end

return UIPVEMainView
