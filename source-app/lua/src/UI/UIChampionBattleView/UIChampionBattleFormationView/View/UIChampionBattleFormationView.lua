local FormationAddHero = require("UI.UIFormation.UIFormationTableNew.Component.FormationAddHero")
local FormationHero = require("UI.UIFormation.UIFormationTableNew.Component.FormationHero")
local FormationHeroSelectList = require("UI.UIFormation.UIFormationTableNew.Component.FormationHeroSelectList")
local CampRestraintItem = require("UI.UIFormation.UIFormationTableNew.Component.CampRestraintItem")
local CampDetailItem = require("UI.UIFormation.UIFormationTableNew.Component.CampDetailItem")
local FormationSoldierSelect = require("UI.UIChampionBattleView.UIChampionBattleFormationView.Component.UIChampionBattleFormationSoldierSelect")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIChampionBattleFormationView = BaseClass("UIChampionBattleFormationView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local close_btn_path = "animObj/SafeArea/btnClose"
local formation_hero_list_path = "animObj/SafeArea/FormationHeroList"
local formation_solider_select_path = "animObj/SafeArea/FormationSoldierSelect"
local effect_obj_path = "animObj/SafeArea/effectObj"
local camp_restraint_btn_path = "animObj/SafeArea/campRestraintBtn"
local camp_restraint_item_path = "animObj/SafeArea/campRestraintBtn/CampRestraintItem"
local camp_restraint_txt_path = "animObj/SafeArea/campRestraintBtn/campRestraintText"
local camp_btn_path = "animObj/SafeArea/campBtn"
local camp_icon_path = "animObj/SafeArea/campBtn/campIcon"
local camp_num_path = "animObj/SafeArea/campBtn/campText"
local hero_index_obj_1_path = "animObj/heroObj/heroIndex1Obj"
local hero_index_obj_2_path = "animObj/heroObj/heroIndex2Obj"
local hero_index_obj_3_path = "animObj/heroObj/heroIndex3Obj"
local hero_index_obj_4_path = "animObj/heroObj/heroIndex4Obj"
local hero_index_obj_5_path = "animObj/heroObj/heroIndex5Obj"
local power_btn_path = "powerDesBtn"
local power_txt_path = "powerDesBtn/powerText"
local power_icon_path = "powerDesBtn/powerIcon"
local battle_state_btn_path = "battle_state_btn"
local battle_state_img_path = "battle_state_btn/battle_img"
local def_btn_path = "animObj/SafeArea/effectObj/defDesBtn"
local def_txt_path = "animObj/SafeArea/effectObj/defDesBtn/defText"
local def_icon_path = "animObj/SafeArea/effectObj/defDesBtn/defIcon"
local atk_btn_path = "animObj/SafeArea/effectObj/atkDesBtn"
local atk_txt_path = "animObj/SafeArea/effectObj/atkDesBtn/atkText"
local atk_icon_path = "animObj/SafeArea/effectObj/atkDesBtn/atkIcon"
local no_army_march_btn_path = "animObj/SafeArea/btn_march"
local no_army_march_btn_text_path1 = "animObj/SafeArea/btn_march/btn_march_text/btn_march_text1"
local no_army_march_btn_text_path2 = "animObj/SafeArea/btn_march/btn_march_text/btn_march_text2"
local anim_path = "animObj"
local champion_battle_formation_path = "animObj/SafeArea/champion_battle_formation"
local champion_battle_formation_btn_path = "animObj/SafeArea/champion_battle_formation/champion_battle_formation_btn"
local champion_battle_formation_btn_text_path = "animObj/SafeArea/champion_battle_formation/champion_battle_formation_btn/champion_battle_formation_btn_text"
local champion_battle_formation_toggle_path = "animObj/SafeArea/champion_battle_formation/champion_battle_formation_toggle"
local champion_battle_formation_toggle_1_path = "animObj/SafeArea/champion_battle_formation/champion_battle_formation_toggle/champion_battle_formation_toggle_1"
local champion_battle_formation_toggle_2_path = "animObj/SafeArea/champion_battle_formation/champion_battle_formation_toggle/champion_battle_formation_toggle_2"
local champion_battle_formation_toggle_3_path = "animObj/SafeArea/champion_battle_formation/champion_battle_formation_toggle/champion_battle_formation_toggle_3"
local champion_battle_formation_toggle_text_1_path = "animObj/SafeArea/champion_battle_formation/champion_battle_formation_toggle/champion_battle_formation_toggle_1/champion_battle_formation_toggle_text_1"
local champion_battle_formation_toggle_text_2_path = "animObj/SafeArea/champion_battle_formation/champion_battle_formation_toggle/champion_battle_formation_toggle_2/champion_battle_formation_toggle_text_2"
local champion_battle_formation_toggle_text_3_path = "animObj/SafeArea/champion_battle_formation/champion_battle_formation_toggle/champion_battle_formation_toggle_3/champion_battle_formation_toggle_text_3"
local shareBtn_path = "shareBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData(self:GetUserData())
  self.animator = self:AddComponent(UIAnimator, anim_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCloseClick()
  end)
  self.formation_hero_list = self:AddComponent(FormationHeroSelectList, formation_hero_list_path)
  self.formation_solider_select = self:AddComponent(FormationSoldierSelect, formation_solider_select_path)
  self.camp_num = self:AddComponent(UIText, camp_num_path)
  self.camp_icon = self:AddComponent(CampDetailItem, camp_icon_path)
  self.camp_btn = self:AddComponent(UIButton, camp_btn_path)
  self.camp_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCampClick()
  end)
  self.camp_restraint_btn = self:AddComponent(UIButton, camp_restraint_btn_path)
  self.camp_restraint_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCampRestraintClick()
  end)
  self.camp_restraint_item = self:AddComponent(CampRestraintItem, camp_restraint_item_path)
  self.camp_restraint_txt = self:AddComponent(UIText, camp_restraint_txt_path)
  self.heroIndexObj = {}
  local index1 = self:AddComponent(UIBaseContainer, hero_index_obj_1_path)
  self.heroIndexObj[1] = index1
  local index2 = self:AddComponent(UIBaseContainer, hero_index_obj_2_path)
  self.heroIndexObj[2] = index2
  local index3 = self:AddComponent(UIBaseContainer, hero_index_obj_3_path)
  self.heroIndexObj[3] = index3
  local index4 = self:AddComponent(UIBaseContainer, hero_index_obj_4_path)
  self.heroIndexObj[4] = index4
  local index5 = self:AddComponent(UIBaseContainer, hero_index_obj_5_path)
  self.heroIndexObj[5] = index5
  self.effect_obj = self:AddComponent(UIBaseContainer, effect_obj_path)
  self.power_btn = self:AddComponent(UIButton, power_btn_path)
  self.power_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnPowerDesClick()
  end)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.power_icon = self:AddComponent(UIImage, power_icon_path)
  self.battle_state_btn = self:AddComponent(UIButton, battle_state_btn_path)
  self.battle_state_btn:SetActive(false)
  self.battle_state_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBattleStateClick()
  end)
  self.battle_state_btn:SetActive(false)
  self.shareBtn = self:AddComponent(UIButton, shareBtn_path)
  self.shareBtn:SetActive(false)
  self.battle_state_img = self:AddComponent(UIImage, battle_state_img_path)
  self.atk_btn = self:AddComponent(UIButton, atk_btn_path)
  self.atk_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAtkDesClick()
  end)
  self.atk_txt = self:AddComponent(UIText, atk_txt_path)
  self.atk_icon = self:AddComponent(UIImage, atk_icon_path)
  self.def_btn = self:AddComponent(UIButton, def_btn_path)
  self.def_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDefDesClick()
  end)
  self.def_txt = self:AddComponent(UIText, def_txt_path)
  self.def_icon = self:AddComponent(UIImage, def_icon_path)
  self.no_army_march_btn = self:AddComponent(UIButton, no_army_march_btn_path)
  self.no_army_march_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view.ctrl:OnStartClick()
  end)
  self.no_army_march_btn_text1 = self:AddComponent(UIText, no_army_march_btn_text_path1)
  self.no_army_march_btn_text1:SetLocalText(150122)
  self.no_army_march_btn_text2 = self:AddComponent(UIText, no_army_march_btn_text_path2)
  self.champion_battle_formation = self:AddComponent(UIBaseContainer, champion_battle_formation_path)
  self.champion_battle_formation:SetActive(true)
  self.champion_battle_formation_btn = self:AddComponent(UIButton, champion_battle_formation_btn_path)
  self.champion_battle_formation_btn_text = self:AddComponent(UIText, champion_battle_formation_btn_text_path)
  self.champion_battle_formation_toggle_1 = self:AddComponent(UIToggle, champion_battle_formation_toggle_1_path)
  self.champion_battle_formation_toggle_2 = self:AddComponent(UIToggle, champion_battle_formation_toggle_2_path)
  self.champion_battle_formation_toggle_3 = self:AddComponent(UIToggle, champion_battle_formation_toggle_3_path)
  self.champion_battle_formation_toggle_text_1 = self:AddComponent(UIText, champion_battle_formation_toggle_text_1_path)
  self.champion_battle_formation_toggle_text_2 = self:AddComponent(UIText, champion_battle_formation_toggle_text_2_path)
  self.champion_battle_formation_toggle_text_3 = self:AddComponent(UIText, champion_battle_formation_toggle_text_3_path)
  self.champion_battle_formation_toggle_text_1:SetLocalText(302032)
  self.champion_battle_formation_toggle_text_2:SetLocalText(302033)
  self.champion_battle_formation_toggle_text_3:SetLocalText(302034)
  self.champion_battle_formation_btn:SetOnClick(function()
    self:OnBattleFormationClick()
  end)
  self.champion_battle_formation_toggle_1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.champion_battle_formation_toggle_2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.champion_battle_formation_toggle_3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.model = {}
  self.campDataList = {}
  self.battleStateStr = ""
  self.targetPower = 0
  self.HeroCellList = {}
  local index = self:GetUserData()
  self.champion_battle_formation_toggle_1:SetIsOn(false)
  self.champion_battle_formation_toggle_2:SetIsOn(false)
  self.champion_battle_formation_toggle_3:SetIsOn(false)
  if index == 1 then
    self.champion_battle_formation_toggle_1:SetIsOn(true)
  elseif index == 2 then
    self.champion_battle_formation_toggle_2:SetIsOn(true)
  elseif index == 3 then
    self.champion_battle_formation_toggle_3:SetIsOn(true)
  end
  self.champion_battle_formation_toggle_1:SetActive(false)
  self.champion_battle_formation_toggle_2:SetActive(false)
  self.champion_battle_formation_toggle_3:SetActive(false)
end

local function OnBattleFormationClick(self)
  local isActive = self.champion_battle_formation_toggle_1:GetActive()
  self.champion_battle_formation_toggle_1:SetActive(not isActive and DataCenter.ActChampionBattleManager:GetFormationIsOpen(1))
  self.champion_battle_formation_toggle_2:SetActive(not isActive and DataCenter.ActChampionBattleManager:GetFormationIsOpen(2))
  self.champion_battle_formation_toggle_3:SetActive(not isActive and DataCenter.ActChampionBattleManager:GetFormationIsOpen(3))
end

local function ToggleControlBorS(self)
  table.walk(self.heroIndexObj, function(k, v)
    v:RemoveComponents(FormationHero)
    v:RemoveComponents(FormationAddHero)
  end)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self.HeroCellList = {}
  if self.champion_battle_formation_toggle_1:GetIsOn() then
    self.ctrl:InitData(1, false)
    self.champion_battle_formation_btn_text:SetLocalText(302032)
  elseif self.champion_battle_formation_toggle_2:GetIsOn() then
    self.ctrl:InitData(2, false)
    self.champion_battle_formation_btn_text:SetLocalText(302033)
  elseif self.champion_battle_formation_toggle_3:GetIsOn() then
    self.ctrl:InitData(3, false)
    self.champion_battle_formation_btn_text:SetLocalText(302034)
  end
  self.champion_battle_formation_toggle_1:SetActive(false)
  self.champion_battle_formation_toggle_2:SetActive(false)
  self.champion_battle_formation_toggle_3:SetActive(false)
  self:InitView()
end

local function OnDestroy(self)
  table.walk(self.heroIndexObj, function(k, v)
    v:RemoveComponents(FormationHero)
    v:RemoveComponents(FormationAddHero)
  end)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.HeroCellList = nil
  self.close_btn = nil
  self.formation_hero_list = nil
  self.formation_solider_select = nil
  self.camp_num = nil
  self.select_hero_btn = nil
  self.heroIndexObj = nil
  base.OnDestroy(self)
end

local function InitView(self)
  self.effect_obj:SetActive(false)
  if self.ctrl:NeedTakeArmy() then
    self.animator:Play("select_anim_idle_soldier", 0, 0)
  else
    self.animator:Play("select_anim_idle_hero", 0, 0)
  end
  self.normalState = true
  self:UpdateArmyContent()
  self:UpdateHeroContent()
  self:UpdateCurHero()
  self:UpdateCampState()
  if self.ctrl:NeedTakeArmy() then
    self.no_army_march_btn:SetActive(false)
    self.formation_solider_select:CollectRefresh()
  else
    self.no_army_march_btn:SetActive(true)
    self:OnHeroSelectClick()
  end
end

local function OnSelectClick(self)
  if not self.ctrl:AllowChangeFormation() then
    return
  end
  self.normalState = not self.normalState
  if self.normalState == false then
    self.animator:Play("select_anim_hero", 0, 0)
  else
    self.animator:Play("select_anim_soldier", 0, 0)
  end
  if self.normalState == true then
    self:UpdateArmyContent()
  end
end

local function OnHeroSelectClick(self)
  self.normalState = false
  self.animator:Play("select_anim_hero", 0, 0)
end

local function SetViewPos(self)
  if self.normalState then
    self.main_obj.transform:Set_localPosition(0, 0, 0)
    self.formation_hero_list:SetActive(false)
    self.formation_solider_select:SetActive(true)
  else
    self.formation_hero_list:SetActive(true)
    self.main_obj.transform:Set_localPosition(355, 0, 0)
    self.formation_hero_list:SetActive(true)
    self.formation_solider_select:SetActive(false)
    if not self.ctrl:NeedTakeArmy() then
      local time = self.view.ctrl:GetCostTime()
      self.no_army_march_btn_text2:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time * 1000))
    end
  end
end

local function OnSelectHeroFinish(self, index)
  self:UpdateArmyContent()
  if self.heroIndexObj[index] ~= nil then
    self.heroIndexObj[index]:RemoveComponents(FormationHero)
    self.heroIndexObj[index]:RemoveComponents(FormationAddHero)
    if self.model[index] ~= nil then
      self:GameObjectDestroy(self.model[index])
      self.model[index] = nil
    end
    self.HeroCellList[index] = nil
    local heroData = self.ctrl:GetCurHeroData()
    self:CreateHeroByIndex(index, heroData)
  end
  self:UpdateCampState()
end

local function CreateHeroByIndex(self, index, heroData)
  if heroData[index] ~= nil then
    if self.model[index] == nil then
      self.model[index] = self:GameObjectInstantiateAsync(UIAssets.FormationHeroNew, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.heroIndexObj[index].transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.heroIndexObj[index]:AddComponent(FormationHero, nameStr)
        cell:InitData(heroData[index], index)
        self.HeroCellList[index] = cell
      end)
    else
    end
  else
    if self.model[index] == nil then
      self.model[index] = self:GameObjectInstantiateAsync(UIAssets.FormationAddHero, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.heroIndexObj[index].transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.heroIndexObj[index]:AddComponent(FormationAddHero, nameStr)
        cell:InitData(index, GarageBuildIds[self.ctrl.curIndex])
        self.HeroCellList[index] = cell
      end)
    else
    end
  end
end

local function UpdateCurHero(self)
  local heroData = self.ctrl:GetCurHeroData()
  self.HeroCellList = {}
  for i = 1, 5 do
    self:CreateHeroByIndex(i, heroData)
  end
end

local function UpdateHeroContent(self)
  if self.formation_hero_list ~= nil then
    self.formation_hero_list:RefreshData()
  end
end

local function UpdateArmyContent(self)
  if self.formation_solider_select ~= nil then
    self.formation_solider_select:RefreshData()
  end
end

local function UpdateCampState(self)
  self.campDataList = self.view.ctrl:GetCurCampData()
  if self.campDataList ~= nil then
    if #self.campDataList > 0 then
      local attackNum = 0
      for i = 1, #self.campDataList do
        attackNum = attackNum + self.campDataList[i].addEffectNum
      end
      self.camp_num:SetText(math.floor(attackNum) .. "%")
      self.camp_icon:InitData(self.campDataList)
    else
      self.camp_icon:InitData()
      self.camp_num:SetText("0%")
    end
  end
  local restraintData = self.view.ctrl:GetCampRestraintData()
  if restraintData ~= nil then
    self.camp_restraint_item:InitData(restraintData.camp, restraintData.num)
    self.camp_restraint_txt:SetText(restraintData.addValue .. "%")
  else
    self.camp_restraint_item:InitData()
    self.camp_restraint_txt:SetText("0%")
  end
end

local function UpdateViewState(self)
  if self.formation_solider_select ~= nil then
    self.formation_solider_select:UpdateViewState()
  end
end

local function OnCampClick(self)
  local x = self.camp_icon.transform.position.x
  local y = self.camp_icon.transform.position.y
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationState, {anim = true}, self.campDataList, x, y)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ArmyFormationSave, self.UpdateArmyContent)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ArmyFormationSave, self.UpdateArmyContent)
end

local function OnPowerDesClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.power_btn.transform.position + Vector3.New(-99, 30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("150209")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnAtkDesClick(self)
  local atkDes = self.ctrl:GetAtkDes()
  if atkDes ~= "" then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.atk_icon.transform.position + Vector3.New(0, -30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = atkDes
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function OnDefDesClick(self)
  local defDes = self.ctrl:GetDefDes()
  if defDes ~= "" then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.def_icon.transform.position + Vector3.New(0, -30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = defDes
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function UpdateNum(self)
  local powerNum = self.view.ctrl:GetFormationPower()
  self.power_txt:SetText(string.GetFormattedSeperatorNum(math.floor(powerNum)))
  self:CheckBattleState(powerNum)
  local atkNum = self.view.ctrl:GetAtkValue()
  self.atk_txt:SetText(string.GetFormattedSeperatorNum(math.floor(atkNum)))
  local defNum = self.view.ctrl:GetDefValue()
  self.def_txt:SetText(string.GetFormattedSeperatorNum(math.floor(defNum)))
  local atkImg = self.ctrl:GetAtkImage()
  if atkImg ~= "" then
    self.atk_icon:LoadSprite(atkImg)
  else
    self.atk_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/UITroops_icon_power")
  end
  local defImg = self.ctrl:GetDefImage()
  if defImg ~= "" then
    self.def_icon:LoadSprite(defImg)
  else
    self.def_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/UITroops_icon_power")
  end
end

local function CheckBattleState(self, power)
end

local function OnBattleStateClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.battle_state_btn.gameObject.transform.position + Vector3.New(0, 60, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.title = self.battleStateStr
  param.content = Localization:GetString("300695") .. ": " .. string.GetFormattedSeperatorNum(self.targetPower)
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 200
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnCloseClick(self)
  if self.normalState == false then
    if not self.ctrl:AllowChangeFormation() then
      self.ctrl:CloseSelf()
    else
      self:OnSelectClick()
    end
  elseif self.ctrl:GetTotalSoldierNum() > 0 then
    self.ctrl:OnFormationSave()
  else
    self.ctrl:CloseSelf()
  end
end

local function OnCampRestraintClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local x = self.camp_restraint_item.transform.position.x
  local y = self.camp_restraint_item.transform.position.y - 40 * scaleFactor
  local restraintData = self.view.ctrl:GetCampRestraintData()
  local campIndex = -1
  local campNum = -1
  if restraintData ~= nil then
    campIndex = restraintData.camp
    campNum = restraintData.num
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationRestraint, campIndex, campNum, x, y)
end

UIChampionBattleFormationView.OnCreate = OnCreate
UIChampionBattleFormationView.OnDestroy = OnDestroy
UIChampionBattleFormationView.OnEnable = OnEnable
UIChampionBattleFormationView.OnDisable = OnDisable
UIChampionBattleFormationView.InitView = InitView
UIChampionBattleFormationView.OnSelectClick = OnSelectClick
UIChampionBattleFormationView.OnSelectHeroFinish = OnSelectHeroFinish
UIChampionBattleFormationView.UpdateHeroContent = UpdateHeroContent
UIChampionBattleFormationView.SetViewPos = SetViewPos
UIChampionBattleFormationView.UpdateArmyContent = UpdateArmyContent
UIChampionBattleFormationView.CreateHeroByIndex = CreateHeroByIndex
UIChampionBattleFormationView.UpdateCurHero = UpdateCurHero
UIChampionBattleFormationView.UpdateCampState = UpdateCampState
UIChampionBattleFormationView.OnCampClick = OnCampClick
UIChampionBattleFormationView.OnAddListener = OnAddListener
UIChampionBattleFormationView.OnRemoveListener = OnRemoveListener
UIChampionBattleFormationView.OnHeroSelectClick = OnHeroSelectClick
UIChampionBattleFormationView.UpdateViewState = UpdateViewState
UIChampionBattleFormationView.UpdateNum = UpdateNum
UIChampionBattleFormationView.OnPowerDesClick = OnPowerDesClick
UIChampionBattleFormationView.OnAtkDesClick = OnAtkDesClick
UIChampionBattleFormationView.OnDefDesClick = OnDefDesClick
UIChampionBattleFormationView.CheckBattleState = CheckBattleState
UIChampionBattleFormationView.OnBattleStateClick = OnBattleStateClick
UIChampionBattleFormationView.OnCloseClick = OnCloseClick
UIChampionBattleFormationView.ToggleControlBorS = ToggleControlBorS
UIChampionBattleFormationView.OnBattleFormationClick = OnBattleFormationClick
UIChampionBattleFormationView.OnCampRestraintClick = OnCampRestraintClick
return UIChampionBattleFormationView
