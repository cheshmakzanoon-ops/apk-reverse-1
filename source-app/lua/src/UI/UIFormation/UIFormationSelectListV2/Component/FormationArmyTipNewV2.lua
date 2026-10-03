local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local FormationArmyTipNewV2 = BaseClass("FormationArmyTipNewV2", UIBaseContainer)
local FormationHeroItem = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationHeroItemV2")
local FormationHeroAdd = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationHeroAddV2")
local FormationSoldierSlider = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationSoldierSliderV2")
local FormationSoldierVerticalV2 = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationSoldierVerticalV2")
local FormationSeasonResistance = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationSeasonResistanceV2")
local FormationTacticalCardSkillPart = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationTacticalCardSkillPartV2")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local WorldToMaoScale = {x = 0.2, y = 0.15}
local MaxX = 330
local MaxY = 210
local offset = 27
local rect_info_path = "Rect_Info"
local bottom_path = "Rect_Info/bg/bottom"
local enter_btn_path = "Rect_Info/bg/bottom/enterBtn"
local btn_txt_path = "Rect_Info/bg/bottom/enterBtn/btnDes/Txt1"
local btn_num_path = "Rect_Info/bg/bottom/enterBtn/btnDes/txt2"
local btn_rally_path = "Rect_Info/bg/bottom/enterBtn/btnDes/txt3"
local btn_bubble_tips_path = "Rect_Info/bg/bottom/enterBtn/bubbleBg"
local btn_bubble_power_path = "Rect_Info/bg/bottom/enterBtn/bubbleBg/txtPower"
local gray_path = "Gray"
local edit_btn_path = "Rect_Info/bg/bottom/editBtn"
local edit_btn_txt_path = "Rect_Info/bg/bottom/editBtn/edit_txt"
local quick_btn_path = "Rect_Info/bg/bottom/quickBtn"
local setting_btn_path = "Rect_Info/bg/bottom/settingBtn"
local state_icon_path = "Rect_Info/bg/Warning/battle_state_btn/wbattle_img"
local effect_path = "Rect_Info/bg/Warning/battle_state_btn/wbattle_img/effect"
local hero_obj_path = "Rect_Info/bg/top/heroesAndDominator/layout/HeroObj"
local hero_1_obj_path = "Rect_Info/bg/top/heroesAndDominator/layout/HeroObj1"
local hero_2_obj_path = "Rect_Info/bg/top/heroesAndDominator/layout/HeroObj2"
local hero_3_obj_path = "Rect_Info/bg/top/heroesAndDominator/layout/HeroObj3"
local hero_4_obj_path = "Rect_Info/bg/top/heroesAndDominator/layout/HeroObj4"
local hero_5_obj_path = "Rect_Info/bg/top/heroesAndDominator/layout/HeroObj5"
local recommend_txt_path = "Rect_Info/bg/commendText"
local heroesAndDominator_path = "Rect_Info/bg/top/heroesAndDominator"
local top_path = "Rect_Info/bg/top"
local soldier_slider_text_path = "Rect_Info/bg/top/troopBg/totalNum"
local common_img_tipsarrow = "common_img_tipsarrow"
local stageRoot_path = "Rect_Info/bg/top/stateBg"
local layout_1_path = "Rect_Info/bg/top/stateBg/Bg/layout1"
local layout_2_path = "Rect_Info/bg/top/stateBg/Bg/layout2"
local layout_3_path = "Rect_Info/bg/top/stateBg/Bg/layout3"
local soldier_btn_path = "Rect_Info/bg/top/stateBg/Bg/layout1/loadNum/loadBtn"
local soldier_icon_path = "Rect_Info/bg/top/stateBg/Bg/layout1/loadNum/loadBtn/loadIcon"
local soldier_num_path = "Rect_Info/bg/top/stateBg/Bg/layout1/loadNum"
local add_img_path = "Rect_Info/bg/top/stateBg/Bg/layout1/loadNum/addImg"
local cost_btn_path = "Rect_Info/bg/top/stateBg/Bg/layout2/funNum/funBtn"
local cost_num_path = "Rect_Info/bg/top/stateBg/Bg/layout2/funNum"
local cost_img_path = "Rect_Info/bg/top/stateBg/Bg/layout2/funNum/funBtn/funIcon"
local cost_add_num_path = "Rect_Info/bg/top/stateBg/Bg/layout3/addNum"
local cost_add_btn_path = "Rect_Info/bg/top/stateBg/Bg/layout3/addNum/addBtn"
local cost_add_img_path = "Rect_Info/bg/top/stateBg/Bg/layout3/addNum/addBtn/addIcon"
local state_btn_path = "Rect_Info/bg/top/stateBg/Bg/layout2/funNum/battle_state_btn"
local soldier_info_scroll_view_path = "Rect_Info/bg/top/stateBg/SolderRoot/layout1/SoldierList1"
local cost_info_scroll_view_path = "Rect_Info/bg/top/stateBg/SolderRoot/layout2/SoldierList2"
local center_path = "Rect_Info/bg/center"
local des_path = "Rect_Info/bg/center/desTxt"
local toggle_path = "Rect_Info/bg/center/checkObj/item"
local soldierSlider_path = "Rect_Info/bg/top/soldierSliderBg"
local warningRoot_path = "Rect_Info/bg/Warning"
local warningText_path = "Rect_Info/bg/Warning/warnText"
local rect_bg_root_path = "Rect_Info/bg"
local layout_path = "Rect_Info/bg/top/heroesAndDominator/layout"
local soldier_slider_bg_base_path = "Rect_Info/bg/top/soldierSliderBg/soldierSliderBgBase"
local line_path = "Rect_Info/bg/top/soldierSliderBg/Line"
local switch_icon_path = "Rect_Info/bg/top/soldierSliderBg/stateBtn/SwitchIcon"
local switch_icon_top_path = "Rect_Info/bg/top/soldierSliderBg/stateBtn/SwitchIconTop"
local mummy_bg_path = "Rect_Info/bg/mummyBg"
local eff_ui_mummy_tips_anim_path = "Rect_Info/bg/top/soldierSliderBg/Slider/Fill Area/Fill"
local FormationTCSkillPartPrefabPath = "Assets/Main/Prefabs/UI/UIFormation/FormationTacticalCardSkillPart.prefab"

local function OnCreate(self)
  self.theBattleTeamInfo = nil
  self.seasonIndex = SeasonUtil.GetSeason()
  self.showArmyTipsAnimCount = nil
  self.fixedSoldierTypeDict = {}
  self.fixedSoldierType = SoldierType.Player
  self.ratio = 1
  self.totalSoldierPower = 0
  self.inBattleWorld = BattleFieldUtil.InBattleField()
  base.OnCreate(self)
  self.rect_info = self:AddComponent(UIBaseContainer, rect_info_path)
  self.troop_image = self:AddComponent(UIImage, "Rect_Info/bg/top/troopBg/BuildIcon")
  self.common_img_tips_arrow = self:AddComponent(UIImage, common_img_tipsarrow)
  self.bottom = self:AddComponent(UIBaseContainer, bottom_path)
  self.toggleLable = self:AddComponent(UIText, "Rect_Info/bg/top/troopBg/Toggle/Label")
  self.toggleLable:SetLocalText(GameDialogDefine.AUTO_SUPPLY_SOLDIERS)
  self.btn_txt = self:AddComponent(UIText, btn_txt_path)
  self.btn_num = self:AddComponent(UIText, btn_num_path)
  self.edit_btn_txt = self:AddComponent(UIText, edit_btn_txt_path)
  self.btn_txt:SetLocalText(GameDialogDefine.CREATE_MARCH)
  self.btn_txt_shadow = self:AddComponent(UIShadow, btn_txt_path)
  self.btn_num_shadow = self:AddComponent(UIShadow, btn_num_path)
  self.btn_bubble_tips = self:AddComponent(UIImage, btn_bubble_tips_path)
  self.btn_bubble_text = self:AddComponent(UIText, btn_bubble_power_path)
  self.recommend_txt = self:AddComponent(UIText, recommend_txt_path)
  self.recommend_txt:SetLocalText(121065)
  if self.transform:Find(quick_btn_path) ~= nil then
    self.quick_btn = self:AddComponent(UIButton, quick_btn_path)
    self.quick_btn:SetOnClick(function()
      self:OnQuickEditClick()
    end)
  end
  self.enter_btn = self:AddComponent(UIButton, enter_btn_path)
  self.enter_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_army_setout)
    local canMarch = DataCenter.LWRefundPunishManager:GetCanMarch()
    if not canMarch then
      return
    end
    if self.tcCardPartList then
      local cardSkillUseInfoList = {}
      for i, v in ipairs(self.tcCardPartList) do
        if v then
          local cardUuid, skillId = v:GetUseCardSkill()
          if cardUuid and skillId then
            local info = {}
            info.cardUuid = cardUuid
            info.cardSkillId = skillId
            table.insert(cardSkillUseInfoList, info)
          end
        end
      end
      DataCenter.TacticalCardDataManager:PushFormationViewCardSkillUseCache(cardSkillUseInfoList)
    end
    self:OnAtkClick()
  end)
  self.edit_btn = self:AddComponent(UIButton, edit_btn_path)
  self.edit_btn:SetOnClick(function()
    self:OnEditClick()
  end)
  self.setting_btn = self:AddComponent(UIButton, setting_btn_path)
  self.setting_btn:SetOnClick(function()
    self:OnEditClick()
  end)
  self.gray_image = self:AddComponent(UIImage, gray_path)
  self.gray = self.gray_image:GetMaterial()
  self.heroList = {}
  local hero_1 = self:AddComponent(UIBaseContainer, hero_1_obj_path)
  self.heroList[1] = hero_1
  local hero_2 = self:AddComponent(UIBaseContainer, hero_2_obj_path)
  self.heroList[2] = hero_2
  local hero_3 = self:AddComponent(UIBaseContainer, hero_3_obj_path)
  self.heroList[3] = hero_3
  local hero_4 = self:AddComponent(UIBaseContainer, hero_4_obj_path)
  self.heroList[4] = hero_4
  local hero_5 = self:AddComponent(UIBaseContainer, hero_5_obj_path)
  self.heroList[5] = hero_5
  self.heroesAndDominator = self:AddComponent(UIBaseContainer, heroesAndDominator_path)
  self.topContainer = self:AddComponent(UIBaseContainer, top_path)
  self.supplyText = {}
  for i = 1, 5 do
    self.supplyText[i] = self:AddComponent(UIText, hero_obj_path .. i .. "/loadNum" .. i)
  end
  self.supplyBar = {}
  for i = 1, 5 do
    self.supplyBar[i] = self:AddComponent(UISlider, hero_obj_path .. i .. "/Slider" .. i)
  end
  self.soldierSliderText = self:AddComponent(UIText, soldier_slider_text_path)
  self.model = {}
  self.oldUuid = 0
  self.showLackStamina = false
  self.collectMaxNum = 0
  self.isReturn = false
  self.totalSoldierNum = 0
  self.centerTf = self.transform:Find(center_path)
  self.formation_army_tips = self:AddComponent(UIAnimator, "")
  self.mummy_bg = self:AddComponent(UIImage, mummy_bg_path)
  self.eff_ui_mummy_tips_anim_root = self:AddComponent(UIBaseComponent, eff_ui_mummy_tips_anim_path)
  self.rect_bg_root = self:AddComponent(UIBaseComponent, rect_bg_root_path)
  self.layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, layout_path)
  self.soldier_slider_bg_base = self:AddComponent(UIImage, soldier_slider_bg_base_path)
  self.line = self:AddComponent(UIImage, line_path)
  self.switch_icon = self:AddComponent(UIImage, switch_icon_path)
  self.switch_icon_top = self:AddComponent(UIImage, switch_icon_top_path)
  if SeasonUtil.IsInSeasonDarknessMode(true) and LuaEntry.Player:GetCurWorldId() == 0 then
    local isSunrise = DataCenter.BloodyNightDataManager:IsSunrise()
    local mgr = DataCenter.SeasonPowerWorkerManager
    local lightHouseStatus = mgr.lightHouseStatus
    if not isSunrise and self.LightWorkerMan == nil and lightHouseStatus ~= nil and 0 < mgr:GetPowerWorkerCount() then
      local luaPath = "UI.LWSeason4.Component.LightWorkerMan"
      local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/LightWorkerMan.prefab"
      self.LightWorkerMan = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.topContainer, function()
        self:UpdateLightWorkerMan()
        if self.topContainer then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.topContainer.rectTransform)
        end
      end)
    end
  end
  self.UseLightWorkerMan = 0
  LuaEntry.GlobalData.UseLightWorkerMan = 0
  self:InitRallyTime()
  self:InitComponentForCollectRoot()
  self:InitMummyTipsEffect()
  self.tacticalCardSkillNode = self:AddComponent(UIBaseContainer, "Rect_Info/bg/top/tacticalCardSkillNode")
end

function FormationArmyTipNewV2:InitMummyTipsEffect()
  if not self.inBattleWorld and SeasonUtil.IsMummySoldierFunctionEnabled() then
    local prefabPath1 = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/Eff_ui_Tips_enviroment_in.prefab"
    local prefabPath2 = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/Eff_ui_Tips_enviroment_out.prefab"
    self.Eff_ui_Tips_enviroment_in = self:LoadComponentAsync(UIAsyncContainer, prefabPath1, self.mummy_bg, function(view, go, lua, callback_param)
      go.name = "Eff_ui_S3_Mummy_Tips_enviroment_in"
    end)
    self.Eff_ui_Tips_enviroment_out = self:LoadComponentAsync(UIAsyncContainer, prefabPath2, self.mummy_bg, function(view, go, lua, callback_param)
      go.name = "Eff_ui_S3_Mummy_Tips_enviroment_out"
    end)
    if self.Eff_ui_Tips_enviroment_in ~= nil then
      self.Eff_ui_Tips_enviroment_in:SetActive(false)
    end
    if self.Eff_ui_Tips_enviroment_out ~= nil then
      self.Eff_ui_Tips_enviroment_out:SetActive(false)
    end
  end
end

function FormationArmyTipNewV2:OnLightWorkerManValueChanged(tf)
  if tf then
    self.UseLightWorkerMan = 1
  else
    self.UseLightWorkerMan = 0
  end
  if self.formationData ~= nil then
    self:CostRefresh()
  end
  if self.battleSimulatedTip ~= nil then
    self.battleSimulatedTip:OnLightWorkerManValueChanged(tf)
  end
end

function FormationArmyTipNewV2:InitComponentForCollectRoot()
  local ssTransform = self.transform:Find(soldierSlider_path)
  if ssTransform ~= nil then
    self.stageRoot = self.transform:Find(stageRoot_path).gameObject
    self.soldierSlider = self:AddComponent(FormationSoldierSlider, soldierSlider_path)
    self.warnRoot = self.transform:Find(warningRoot_path).gameObject
    self.warnText = self:AddComponent(UIText, warningText_path)
    self.state_icon = self:AddComponent(UIImage, state_icon_path)
    self.effect = self:AddComponent(UIBaseContainer, effect_path)
    self.layout1 = self:AddComponent(UIBaseContainer, layout_1_path)
    self.layout2 = self:AddComponent(UIBaseContainer, layout_2_path)
    self.layout3 = self:AddComponent(UIBaseContainer, layout_3_path)
    self.soldier_btn = self:AddComponent(UIButton, soldier_btn_path)
    self.soldier_icon = self:AddComponent(UIImage, soldier_icon_path)
    self.my_power_num = self:AddComponent(UIText, soldier_num_path)
    self.add_img = self:AddComponent(UIText, add_img_path)
    self.cost_btn = self:AddComponent(UIButton, cost_btn_path)
    self.cost_btn:SetOnClick(function()
      self:OnPowerClick()
    end)
    self.cost_num = self:AddComponent(UIText, cost_num_path)
    self.consumeIcon = self:AddComponent(UIImage, cost_img_path)
    self.cost_add_num = self:AddComponent(UIText, cost_add_num_path)
    self.cost_add_btn = self:AddComponent(UIButton, cost_add_btn_path)
    self.cost_add_btn:SetOnClick(function()
      self:OnCollectAddClick()
    end)
    self.cost_add_img = self:AddComponent(UIImage, cost_add_img_path)
    self.soldier_btn:SetOnClick(function()
      self:OnSoliderNumClick()
    end)
    self.state_btn = self:AddComponent(UIButton, state_btn_path)
    self.state_btn:SetActive(false)
    self.state_btn:SetOnClick(function()
    end)
    self.vsIcon = self:AddComponent(UIImage, "Rect_Info/bg/top/stateBg/Bg/stageBgVS")
    self.soldierInfoRoot = self:AddComponent(UIBaseContainer, "Rect_Info/bg/top/stateBg/SolderRoot")
    self.mySoldierInfoScrollView = self:AddComponent(UIScrollView, soldier_info_scroll_view_path)
    self.mySoldierInfoScrollView:SetOnItemMoveIn(function(itemObj, index)
      self:OnCreateMySoldierInfoCell(itemObj, index)
    end)
    self.mySoldierInfoScrollView:SetOnItemMoveOut(function(itemObj, index)
      self:OnDeleteMySoldierInfoCell(itemObj, index)
    end)
    self.costInfoScrollView = self:AddComponent(UIScrollView, cost_info_scroll_view_path)
    self.costInfoScrollView:SetOnItemMoveIn(function(itemObj, index)
      self:OnCreateCostSoldierInfoCell(itemObj, index)
    end)
    self.costInfoScrollView:SetOnItemMoveOut(function(itemObj, index)
      self:OnDeleteCostSoldierInfoCell(itemObj, index)
    end)
  end
end

local function OnDestroy(self)
  DataCenter.TacticalCardDataManager:PopFormationViewCardSkillUseCache()
  self.tcCardPartList = nil
  self.theBattleTeamInfo = nil
  if self.collectRoot then
    self.collectRoot:Delete()
    self.collectRoot = nil
  end
  if self.kang_xing_root then
    self.kang_xing_root:Delete()
    self.kang_xing_root = nil
  end
  if self.dominatorLine then
    self.dominatorLine:Delete()
    self.dominatorLine = nil
  end
  if self.resistanceLeaderNode then
    self.resistanceLeaderNode:Delete()
    self.resistanceLeaderNode = nil
  end
  if self.battleSimulatedTip then
    self.battleSimulatedTip:UpdateTimer(false)
    self.battleSimulatedTip:Delete()
    self.battleSimulatedTip = nil
  end
  self.formation_army_tips = nil
  self.dominatorUuid = nil
  table.walk(self.heroList, function(k, v)
    v:RemoveComponents(FormationHeroItem)
    v:RemoveComponents(FormationHeroAdd)
  end)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  if self.animSwitchSoldier then
    self.animSwitchSoldier:Kill()
    self.animSwitchSoldier = nil
  end
  self.layout = nil
  self.btn_txt = nil
  self.enter_btn = nil
  self.monster = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnClearHeroList(self)
  if self.dominatorLine then
    self.dominatorLine:SetActive(false)
  end
  self.dominatorUuid = nil
  table.walk(self.heroList, function(k, v)
    v:RemoveComponents(FormationHeroItem)
    v:RemoveComponents(FormationHeroAdd)
  end)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function ResetOldUuid(self)
  self.oldUuid = 0
end

local function RefreshHeroList(self, formationData)
  self.oldUuid = self.uuid
  self:OnClearHeroList()
  if self.inMarch > 0 or self.canCreate == true then
    table.walk(self.heroList, function(k, v)
      local heroUuid
      for _, heroData in pairs(formationData.heroDataList) do
        if heroData.index == k then
          heroUuid = heroData.heroUuid
          break
        end
      end
      if heroUuid then
        if self.model[k] == nil then
          self.model[k] = self:GameObjectInstantiateAsync(UIAssets.FormationHeroItem, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            local go_tf = go.transform
            go.gameObject:SetActive(true)
            go_tf:SetParent(v.transform)
            go_tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go_tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            go.name = k
            local cell = v:AddComponent(FormationHeroItem, go.name)
            cell:InitData(heroUuid)
          end)
        end
      elseif self.model[k] == nil then
        self.model[k] = self:GameObjectInstantiateAsync(UIAssets.FormationSelectHeroAdd, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          local go_tf = go.transform
          go.gameObject:SetActive(true)
          go_tf:SetParent(v.transform)
          go_tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go_tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
          go.name = k
          local cell = v:AddComponent(FormationHeroAdd, go.name)
          cell:RefreshData(k, self.uuid, self.canCreate, GarageBuildIds[self.index])
        end)
      end
    end)
    local dominatorUuid = formationData.dominatorUuid
    self.dominatorUuid = dominatorUuid
    if dominatorUuid and 0 < dominatorUuid then
      if self.dominatorLine == nil then
        self.dominatorLine = UIAsyncLoaderBridge.New(self, "dominatorLine", self.layout.transform, "Assets/Main/Prefabs/UI/UIFormation/V2/DominatorAreaV2.prefab", "UI.UIFormation.UIFormationSelectListV2.Component.FormationDominatorLineV2", false, function()
          if self.layout then
            self.layout:SetEnable(true)
            CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
          end
        end)
      end
      if self.dominatorLine ~= nil then
        self.dominatorLine:SetActive(true)
        self.dominatorLine:InitData(dominatorUuid)
        if self.heroSoldierNum then
          self.dominatorLine:SetSupply(self.heroSoldierNum[ArmyFormationSlot.Dominator], self.fixedSoldierType)
        else
          self.dominatorLine:SetSupply(0, self.fixedSoldierType)
        end
        self.layout:SetSpacing(0)
      end
    else
      if self.dominatorLine then
        self.dominatorLine:SetActive(false)
      end
      self.layout:SetSpacing(6)
    end
    for k, v in pairs(self.heroList) do
      if v then
        if dominatorUuid and 0 < dominatorUuid then
          v:SetLocalScaleXYZ(0.9, 0.9, 0.9)
        else
          v:SetLocalScaleXYZ(1, 1, 1)
        end
      end
    end
    self.layout:SetEnable(true)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
  end
end

local function RefreshData(self, posX, posY, formationData)
  local targetType = self.view.ctrl.targetType
  local targetUuid = self.view.ctrl.targetUuid
  local serverId = formationData.serverId
  self.lastFixedSoldierType = self.fixedSoldierType
  self.formationData = formationData
  self.uuid = formationData.uuid
  self.canCreate = formationData.useForm
  self.inMarch = formationData.isMarch
  self.fixedSoldierType = formationData.fixedSoldierType or self.fixedSoldierTypeDict[self.uuid or "???"] or self.fixedSoldierType
  self.index = formationData.index
  self.isExplore = false
  self:RefreshHeroList(formationData)
  self.formation = formationData
  self.recommend_txt:SetActive(false)
  self.isReturn = false
  self.canClick = true
  self.extraTime = 0
  self.need_resistance = 0
  self.has_resistance = 0
  if serverId == nil or serverId <= 0 then
    serverId = LuaEntry.Player:GetSelfServerId()
  end
  if self.inMarch > 0 then
    local targetServerId = 0
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      targetServerId = toInt(march.targetServer)
    end
    if targetServerId <= 0 or not DataCenter.SeasonDataManager:IsInNinePalacesMode(targetServerId) then
      if targetType ~= MarchTargetType.CROSS_SERVER_WORM then
        if serverId ~= LuaEntry.Player:GetCurServerId() and self.inMarch > 0 then
          self.canClick = false
        end
      elseif serverId ~= LuaEntry.Player:GetSelfServerId() and self.inMarch > 0 then
        self.canClick = false
      end
    end
  end
  if self.inMarch == 0 and targetType == MarchTargetType.JOIN_RALLY and not self.inBattleWorld then
    local allianceWarData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.view.ctrl.targetUuid)
    if allianceWarData ~= nil then
      self.fixedSoldierType = allianceWarData.fixedSoldierType
    end
  end
  if self.fixedSoldierType ~= SoldierType.Player and self.fixedSoldierType ~= SoldierType.Mummy then
    self.fixedSoldierType = SoldierType.Player
  end
  if targetType < 0 then
    if self.inMarch then
      local marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
      if marchInfo ~= nil then
        if marchInfo:GetMarchStatus() == MarchStatus.ASSISTANCE then
          self.isReturn = true
        end
        if marchInfo:GetMarchType() == NewMarchType.EXPLORE then
          self.isExplore = true
        end
      end
    end
  else
    local rallyType = self.view.ctrl:GetRallyType()
    self.has_resistance, self.need_resistance, self.resistance_type = FormationSeasonResistance.CheckResistance(self, self.topContainer, targetType, self.fixedSoldierType, rallyType, targetUuid)
    self.warnRoot:SetActive(self.canStageRootShow and toInt(self.has_resistance) >= toInt(self.need_resistance))
  end
  self:SetButtonState()
  self:RefreshStaminaState()
  self:RefreshBtnActive()
  self:RefreshEditBtnText()
  self:SwitchFormationSoldierUI(true)
  self.common_img_tips_arrow:SetActive(true)
  self.common_img_tips_arrow:SetPositionXYZ(posX, posY, 0)
  self.common_img_tips_arrow:SetAlpha(1)
  if not IsNull(self.centerTf) then
    if MarchUtil.IsRallyMarch(self.view.ctrl.targetType) then
      self.btn_txt:SetActive(false)
      self.btn_num:SetActive(false)
      if self.rally_txt then
        self.rally_txt:SetActive(true)
      end
      self.centerTf.gameObject:SetActive(true)
      self:ToggleControlBorS()
    else
      self.btn_txt:SetActive(true)
      self.btn_num:SetActive(true)
      self.rally_txt:SetActive(false)
      self.centerTf.gameObject:SetActive(false)
    end
  else
    self.btn_txt:SetActive(true)
    self.btn_num:SetActive(true)
    if self.rally_txt then
      self.rally_txt:SetActive(false)
    end
  end
  self:UpdateLightWorkerMan()
  if self.inMarch > 0 then
    self:RefreshMarch()
  else
    self:RefreshFormation()
  end
  self:RefreshTCCardSkillNode()
end

function FormationArmyTipNewV2:RefreshTCCardSkillNode()
  if BattleFieldUtil.InBattleField() then
    self.tacticalCardSkillNode:SetActive(false)
    return
  end
  local marchType = self.view.ctrl.targetType
  local skillShowDataList = {}
  local posParam = {}
  posParam.usePos = MasterySkillUsePosType.FormationView
  local skillList = TacticalCardUtil.GetAllActiveSkillDataList()
  for i, skillData in ipairs(skillList) do
    if skillData then
      local checkPos = skillData:CheckUsePosition(posParam)
      if checkPos then
        local checkMarch = skillData:CheckMarchType(marchType)
        if checkMarch then
          local skillState = skillData:GetCastSkillState(posParam)
          local showData = {
            skillData = skillData,
            skillTemp = skillData.template,
            tempState = skillState
          }
          table.insert(skillShowDataList, showData)
        end
      end
    end
  end
  local skillCount = #skillShowDataList
  self.tacticalCardSkillNode:SetActive(0 < skillCount)
  if not self.tcCardPartList then
    self.tcCardPartList = {}
    for i = 1, skillCount do
      local part = self.tacticalCardSkillNode:LoadComponentAsync(FormationTacticalCardSkillPart, FormationTCSkillPartPrefabPath, self.tacticalCardSkillNode)
      table.insert(self.tcCardPartList, part)
    end
  end
  for i, v in ipairs(self.tcCardPartList) do
    if v and skillShowDataList[i] then
      v:SetDataCache(skillShowDataList[i])
      v:RefreshView()
    end
  end
end

function FormationArmyTipNewV2:UpdateLightWorkerMan()
  if self.inMarch ~= nil and self.formation ~= nil and self.LightWorkerMan ~= nil then
    self.LightWorkerMan:SetActive(true)
    if self.inMarch > 0 then
      if 0 < toInt(self.formation.ownerLightUuid) then
        self.UseLightWorkerMan = 1
      else
        self.UseLightWorkerMan = 0
      end
      self.LightWorkerMan:RefreshData(self.formation, true)
    else
      if self.LightWorkerMan:GetIsOn() then
        self.UseLightWorkerMan = 1
      else
        self.UseLightWorkerMan = 0
      end
      self.LightWorkerMan:RefreshData(self.formation, false)
    end
    if self.battleSimulatedTip ~= nil then
      self.battleSimulatedTip:OnLightWorkerManValueChanged(self.UseLightWorkerMan == 1)
    end
  end
end

local function SetButtonState(self)
  if self.inMarch == 1 and self.formation.canMove == true then
    self.enter_btn:SetMaterial(self.gray)
    self.isAssemble = true
  elseif self.inMarch == 1 and (MarchUtil.IsRallyMarch(self.view.ctrl.targetType) or self.view.ctrl.targetType == MarchTargetType.EXPLORE or self.view.ctrl.targetType == MarchTargetType.CROSS_SERVER_WORM or self.view.ctrl.targetType == MarchTargetType.GO_WORM_HOLE) then
    self.isAssemble = true
    self.enter_btn:SetMaterial(self.gray)
  else
    self.isAssemble = false
    if self.canCreate == false and self.inMarch ~= 1 then
      self.enter_btn:SetMaterial(self.gray)
      self.isAssemble = true
    else
      self.enter_btn:SetMaterial(nil)
    end
  end
end

local function UpdatePower(self)
  self.state_btn:SetActive(false)
  if self.uuid ~= nil then
    self:RefreshTime()
    local targetType = self.view.ctrl:GetTargetType()
    local targetPower
    local myPower = 0
    if targetType == MarchTargetType.EXPLORE then
      local info = CS.SceneManager.World:GetPointInfoByUuid(self.view.ctrl.targetUuid)
      if info ~= nil then
        cast(info, typeof(CS.ExplorePointInfo))
        if info ~= nil then
          local eventId = info.eventId
          myPower = self.view.ctrl:GetExploreFormationPowerByUuidAndEventId(self.uuid, eventId)
          self.consumeIcon:LoadSprite(string.format("Assets/Main/Sprites/UI/LWCommon/Sprite/UITroopsNew_icon3.png"))
          local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
          if template ~= nil then
            targetPower = tonumber(template.recommend_power)
          end
        end
      end
    else
      local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
      if 0 < self.inMarch then
        if formation then
          myPower = formation:GetHeroesCapacity() + formation:GetEquipCapacity() + formation:GetTWSkillChipCapacity() + self.totalSoldierPower + formation:GetDominatorCapacity()
          myPower = myPower * self.ratio
        end
      else
        myPower = self.view.ctrl:GetFormationPowerByUuid(self.uuid) * self.ratio
      end
      self.my_power_num:SetText(string.GetFormattedStr2(math.floor(myPower)))
      if targetType == MarchTargetType.ATTACK_MONSTER or targetType == MarchTargetType.RALLY_FOR_BOSS then
        if CS.SceneManager:IsInCity() then
          local monsterData = DataCenter.CityPointDataManager:GetPointDataByUuid(self.view.ctrl.targetUuid)
          if monsterData ~= nil then
            local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterData.itemId)
            if monster ~= nil then
              targetPower = tonumber(monster.recommend_power)
              self.monster = monster
            end
          end
        else
          local marchInfo = CS.SceneManager.World:GetMarch(self.view.ctrl.targetUuid)
          if marchInfo ~= nil then
            local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchInfo.monsterId)
            if monster ~= nil then
              targetPower = tonumber(monster.recommend_power)
              self.monster = monster
            end
          end
        end
      elseif targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD or targetType == MarchTargetType.RALLY_CITY_STRONGHOLD or targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or targetType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or targetType == MarchTargetType.RALLY_CENTER_THRONE or targetType == MarchTargetType.RAINFOREST_THRONE_RALLY then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.view.ctrl.targetPoint)
        if pointInfo ~= nil then
          local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
          if allianceCityPointInfo ~= nil then
            local state = allianceCityPointInfo.state
            if state == AllianceCityState.NEUTRAL then
              local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(allianceCityPointInfo.cityId)
              targetPower = tonumber(cityTemplate.recommend_soldier)
            end
          end
        end
      elseif targetType == MarchTargetType.JOIN_RALLY then
        local allianceWarData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.view.ctrl.targetUuid)
        if allianceWarData ~= nil then
          local rallyType = self.view.ctrl:GetRallyType()
          if rallyType == MarchTargetType.RALLY_FOR_BOSS then
            local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(allianceWarData.targetUid)
            if monster ~= nil then
              targetPower = tonumber(monster.recommend_power)
              self.monster = monster
            end
          elseif rallyType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or rallyType == MarchTargetType.RALLY_SERVER_THRONE_BUILDING or rallyType == MarchTargetType.RALLY_CENTER_THRONE or rallyType == MarchTargetType.RAINFOREST_THRONE_RALLY then
            local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(allianceWarData.targetContentId)
            if cityTemplate then
              targetPower = tonumber(cityTemplate.recommend_soldier or 0)
            end
          end
        end
      elseif targetType == MarchTargetType.ATTACK_CITY or targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or targetType == MarchTargetType.RALLY_FOR_CITY then
      elseif targetType == MarchTargetType.SIMPLE_CITY_EVENT_ATTACK then
        targetPower = 10000
      end
    end
    self:CheckBattleState(myPower, targetPower)
  end
  self:CostRefresh()
end

function FormationArmyTipNewV2:HandleSoldierMaxLevelCheckTips(battleResultPredict)
  local function GetMaxLv(data)
    local res = math.mininteger
    
    if not table.IsNullOrEmpty(data) then
      for i, v in pairs(data) do
        local lv = checknumber(v.lv)
        if 0 < lv and res < lv then
          res = lv
        end
      end
    end
    return res
  end
  
  local function GetCount(data, targetLv)
    local res = 0
    if not table.IsNullOrEmpty(data) then
      for i, v in pairs(data) do
        local lv = checknumber(v.lv)
        if lv == targetLv then
          res = v.count
        end
      end
    end
    return res
  end
  
  if self.uuid ~= nil then
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
    if formation ~= nil then
      local armyId = self:GetArmyId()
      local mySoldierMaxLv = GetMaxLv(formation.soldiersLv)
      local armySoldierDataList = DataCenter.LWArmyTemplateManager:GetSoldierDataList(armyId)
      local armySoldierMaxLv = GetMaxLv(armySoldierDataList)
      local shouldCheckMaxLevel = checknumber(armyId) > 0
      local isCarryEnoughSoldier = true
      if self.fixedSoldierType ~= SoldierType.Mummy then
        local curInsideSoldiers = DataCenter.SoldierDataManager:GetInsideSoldiers(self.fixedSoldierType)
        local curInsideMaxLevelSoldierData
        if not table.IsNullOrEmpty(curInsideSoldiers) then
          for i, v in pairs(curInsideSoldiers) do
            if curInsideMaxLevelSoldierData == nil or v.lv > curInsideMaxLevelSoldierData.lv then
              curInsideMaxLevelSoldierData = v
            end
          end
        end
        if curInsideMaxLevelSoldierData ~= nil then
          local soldierLimit = formation:GetAllHeroSoldierCapacity()
          local curMaxLevelSoldierUseCount = GetCount(formation.soldiersLv, curInsideMaxLevelSoldierData.lv)
          if 0 < soldierLimit and soldierLimit > curMaxLevelSoldierUseCount then
            isCarryEnoughSoldier = false
          end
        end
      end
      if shouldCheckMaxLevel then
        if battleResultPredict == 1 or battleResultPredict == 2 then
          self.soldierInfoRoot:SetActive(false)
        elseif 0 < mySoldierMaxLv and 0 < armySoldierMaxLv and mySoldierMaxLv < armySoldierMaxLv and not SeasonUtil.IsInSeason(true) then
          self.battleStateStr = Localization:GetString("warning_soldier_level")
          self.state_icon:LoadSprite("Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaohong.png")
          self.warnText:SetText(string.format("<color=#f53c3d>%s</color>", self.battleStateStr))
          self.soldierInfoRoot:SetActive(true)
        elseif not isCarryEnoughSoldier then
          self.battleStateStr = Localization:GetString("warning_soldier_unfill")
          self.state_icon:LoadSprite("Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaocheng.png")
          self.warnText:SetText(string.format("<color=#f3b444>%s</color>", self.battleStateStr))
          self.soldierInfoRoot:SetActive(true)
        else
          self.soldierInfoRoot:SetActive(false)
        end
      else
        self.soldierInfoRoot:SetActive(not isCarryEnoughSoldier)
        if not isCarryEnoughSoldier then
          self.battleStateStr = Localization:GetString("warning_soldier_unfill")
          self.state_icon:LoadSprite("Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaocheng.png")
          self.warnText:SetText(string.format("<color=#f3b444>%s</color>", self.battleStateStr))
        end
      end
    end
  end
  if self.view.ctrl.targetType == MarchTargetType.SIMPLE_CITY_EVENT_ATTACK then
    self.soldierInfoRoot:SetActive(false)
  end
end

local function CheckBattleState(self, myPower, targetPower)
  local function GetMinLv(data)
    local res = math.maxinteger
    
    if not table.IsNullOrEmpty(data) then
      for i, v in pairs(data) do
        local lv = checknumber(v.lv)
        if 0 < lv and res > lv then
          res = lv
        end
      end
    end
    return res
  end
  
  self.battleStateStr = ""
  self.battleTargetNum = targetPower
  if MarchUtil.IsAssistanceMarch(self.view.ctrl.targetType) then
    self.stageRoot:SetActive(false)
    if self.collectRoot then
      self.collectRoot:SetActive(false)
    end
    self.soldierSlider:ShowTipBtn(false)
    self.warnRoot:SetActive(false)
    return
  end
  local battleResultPredict = 0
  if targetPower ~= nil and 0 < targetPower then
    local percent = (myPower - targetPower) / targetPower
    local k19 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k19", 0.1) or 0.1
    local k21 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k21", -0.1) or -0.1
    local isSoldierLvMustWin = true
    if self.uuid ~= nil then
      local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
      if formation ~= nil then
        local armyId = self:GetArmyId()
        if 0 < checknumber(armyId) then
          local mySoldierMinLv = GetMinLv(formation.soldiersLv)
          local armySoldierDataList = DataCenter.LWArmyTemplateManager:GetSoldierDataList(armyId)
          local armySoldierMinLv = GetMinLv(armySoldierDataList)
          if 0 < mySoldierMinLv and 0 < armySoldierMinLv and 1 < armySoldierMinLv - mySoldierMinLv then
            isSoldierLvMustWin = false
          end
        end
      end
    end
    if percent > k19 and isSoldierLvMustWin then
      self.effect:SetActive(false)
      local numStr = string.format(string.GetFormattedStr2(math.floor(targetPower)))
      self.cost_num:SetText(numStr)
      if self.seasonIndex == 0 then
        self.battleStateStr = Localization:GetString("150121")
        self.state_icon:LoadSprite("Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaolv.png")
      else
        self.battleStateStr = Localization:GetString("sim_battle_ui_2_limit_10")
        self.state_icon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/BattleSimulated/v10.png")
      end
      self.warnText:SetText(string.format("<color=#099b4a>%s</color>", self.battleStateStr))
      battleResultPredict = 1
    elseif percent < k21 then
      local numStr = string.format("<color=#f26a67>%s</color>", string.GetFormattedStr2(math.floor(targetPower)))
      self.cost_num:SetText(numStr)
      if self.seasonIndex == 0 then
        self.effect:SetActive(true)
        self.battleStateStr = Localization:GetString("150119")
        self.state_icon:LoadSprite("Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaohong.png")
      else
        self.effect:SetActive(false)
        self.battleStateStr = Localization:GetString("sim_battle_ui_5_limit_10")
        self.state_icon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/BattleSimulated/v40.png")
      end
      self.warnText:SetText(string.format("<color=#f53c3d>%s</color>", self.battleStateStr))
      battleResultPredict = 2
    else
      self.effect:SetActive(false)
      local numStr = string.format(string.GetFormattedStr2(math.floor(targetPower)))
      self.cost_num:SetText(numStr)
      self.battleStateStr = Localization:GetString("150120")
      self.warnText:SetText(string.format("<color=#f3b444>%s</color>", self.battleStateStr))
      if self.seasonIndex == 0 then
        self.state_icon:LoadSprite("Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaocheng.png")
      else
        self.state_icon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/BattleSimulated/v30.png")
      end
      battleResultPredict = 3
    end
  else
    self.effect:SetActive(false)
    self.cost_num:SetLocalText(454132)
    self.battleStateStr = Localization:GetString("150120")
    self.warnText:SetText(string.format("<color=#f3b444>%s</color>", self.battleStateStr))
    if self.seasonIndex == 0 then
      self.state_icon:LoadSprite("Assets/Main/Sprites/UI/UIFormationDefence/dl_chuzheng_tanhaocheng.png")
    else
      self.state_icon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/BattleSimulated/v30.png")
    end
    battleResultPredict = 3
  end
  self:HandleSoldierMaxLevelCheckTips(battleResultPredict)
  self:TrySimulatedBattle(battleResultPredict)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.warnRoot.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.stageRoot.transform)
end

function FormationArmyTipNewV2:OnBattleTeamInfoRefresh(data)
  if self.need_resistance == nil or self.need_resistance == 0 then
    return
  end
  if data and data.teamUuid and data.resistanceValue then
    local targetType = self.view.ctrl.targetType
    local targetUuid = self.view.ctrl.targetUuid
    if targetType == MarchTargetType.JOIN_RALLY and not self.inBattleWorld and targetUuid == data.teamUuid then
      self.theBattleTeamInfo = data
      if self.kang_xing_root ~= nil then
        self.kang_xing_root:SetActive(true)
        self.kang_xing_root:RefreshData(self.resistance_type, self.has_resistance, self.need_resistance, data)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.topContainer.rectTransform)
      end
    end
  end
end

function FormationArmyTipNewV2:TrySimulatedBattle(battleResultPredict)
  if self.battleSimulatedTip ~= nil then
    self.battleSimulatedTip:UpdateTimer(false)
    self.battleSimulatedTip:SetActive(false)
  end
  if self.need_resistance == nil or self.need_resistance == 0 then
    return
  end
  local targetType = self.view.ctrl.targetType
  local targetUuid = self.view.ctrl.targetUuid
  if targetType ~= MarchTargetType.ATTACK_MONSTER and targetType ~= MarchTargetType.RALLY_FOR_BOSS then
    return
  end
  if not (not self.inBattleWorld and LuaEntry.DataConfig:CheckSwitch("sim_battle_function_on")) or not SeasonUtil.IsInSeason(true) then
    return
  end
  local has_resistance = toInt(self.has_resistance)
  local need_resistance = toInt(self.need_resistance)
  if has_resistance >= need_resistance then
    return
  end
  local show_battle_simulated = false
  local monsterUuid = self.view.ctrl.uuid
  local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(monsterUuid)
  if marchInfo and marchInfo:IsMonsterOrOrdinaryBoss() then
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(tostring(marchInfo.monsterId))
    if monster then
      local targetSpecialType = monster.special
      if targetSpecialType == WorldMonsterSpecialType.CityStrongholdPVE or targetSpecialType == WorldMonsterSpecialType.CityStrongholdPVP or targetSpecialType == WorldMonsterSpecialType.CityStrongholdBOSS then
        show_battle_simulated = true
      elseif targetSpecialType == WorldMonsterSpecialType.Normal and (monster.type == LWWorldMonsterType.ResMetal or monster.type == LWWorldMonsterType.ResFood or monster.type == LWWorldMonsterType.ResGold or monster.type == LWWorldMonsterType.S4Tank or monster.type == LWWorldMonsterType.S4Airplane or monster.type == LWWorldMonsterType.S4Missile or monster.type == LWWorldMonsterType.S4TankBN or monster.type == LWWorldMonsterType.S4AirplaneBN or monster.type == LWWorldMonsterType.S4MissileBN) then
        show_battle_simulated = true
      elseif targetSpecialType == WorldMonsterSpecialType.Normal and (monster.type == LWWorldMonsterType.Boss or monster.type == LWWorldMonsterType.S4Boss or monster.type == LWWorldMonsterType.S4Boss or monster.type == LWWorldMonsterType.S4BossBN) then
        show_battle_simulated = true
      end
    end
  end
  if show_battle_simulated ~= true then
    return
  end
  if self.battleSimulatedTip == nil then
    self.battleSimulatedTip = UIAsyncLoaderBridge.New(self, "battleSimulatedTip", self.topContainer.transform, "Assets/Main/Prefabs/UI/UIFormation/V2/SimulatedBattleV2.prefab", "UI.UIFormation.UIFormationSelectListV2.Component.FormationSimulatedBattleV2", false)
  end
  if self.battleSimulatedTip ~= nil then
    self.battleSimulatedTip:SetActive(true)
    self.battleSimulatedTip:UpdateTimer(true)
    self.battleSimulatedTip:RefreshData(self.fixedSoldierType, self.uuid, targetType, self.view.ctrl.targetUuid, self.view.ctrl.targetServerId)
    if battleResultPredict ~= 0 then
      self.warnRoot:SetActive(false)
    end
  end
end

local function CostRefresh(self)
  if self.view.ctrl:ShowExplorePower(self.view.ctrl.targetType) or self.isExplore == true then
    self.layout1:SetActive(false)
    self.layout3:SetActive(false)
    return
  else
    self.layout1:SetActive(true)
  end
  self.vsIcon:SetActive(self.view.ctrl.targetType ~= MarchTargetType.COLLECT)
  self.layout3:SetActive(self.view.ctrl.targetType == MarchTargetType.COLLECT)
  self:ShowResourceCollect()
end

function FormationArmyTipNewV2:SoldierInfoRefresh(soldierLvData, armyId)
  self.mySoldierLvDataCache = {}
  self.armySoldierLvDataCache = {}
  local showSoldier = not table.IsNullOrEmpty(soldierLvData)
  self.mySoldierInfoScrollView:SetActive(showSoldier)
  if showSoldier then
    for i, v in pairs(soldierLvData) do
      table.insert(self.mySoldierLvDataCache, v)
      if T11Util.IsSuperSoldier(v.lv) then
        local curStage = T11Util.GetCurStage()
        local type = T11Util.GetCurT11SoldierType()
        v.t11Data = {type = type, stage = curStage}
      end
    end
    self.mySoldierInfoScrollView:ClearCells()
    self.mySoldierInfoScrollView:RemoveComponents(FormationSoldierVerticalV2)
    self.mySoldierInfoScrollView:SetTotalCount(#self.mySoldierLvDataCache)
    self.mySoldierInfoScrollView:RefillCells()
  end
  self.armySoldierLvDataCache = DataCenter.LWArmyTemplateManager:GetSoldierDataList(armyId)
  local showArmySoldier = not table.IsNullOrEmpty(self.armySoldierLvDataCache)
  self.costInfoScrollView:SetActive(showArmySoldier)
  if showArmySoldier then
    self.costInfoScrollView:ClearCells()
    self.costInfoScrollView:RemoveComponents(FormationSoldierVerticalV2)
    self.costInfoScrollView:SetTotalCount(#self.armySoldierLvDataCache)
    self.costInfoScrollView:RefillCells()
  end
end

function FormationArmyTipNewV2:OnCreateMySoldierInfoCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.mySoldierInfoScrollView:AddComponent(FormationSoldierVerticalV2, itemObj)
  if not table.IsNullOrEmpty(self.mySoldierLvDataCache) then
    local soldierData = self.mySoldierLvDataCache[index]
    if soldierData ~= nil then
      cellItem:SetLocalScaleXYZ(0.75, 0.75, 0.75)
      cellItem:SetData(soldierData)
    end
  end
end

function FormationArmyTipNewV2:OnCreateCostSoldierInfoCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.costInfoScrollView:AddComponent(FormationSoldierVerticalV2, itemObj)
  if not table.IsNullOrEmpty(self.armySoldierLvDataCache) then
    local soldierData = self.armySoldierLvDataCache[index]
    if soldierData ~= nil then
      cellItem:SetLocalScaleXYZ(0.75, 0.75, 0.75)
      cellItem:SetData(soldierData)
    end
  end
end

function FormationArmyTipNewV2:OnDeleteCostSoldierInfoCell(itemObj, index)
  self.costInfoScrollView:RemoveComponent(itemObj.name, FormationSoldierVerticalV2)
end

function FormationArmyTipNewV2:OnDeleteMySoldierInfoCell(itemObj, index)
  self.mySoldierInfoScrollView:RemoveComponent(itemObj.name, FormationSoldierVerticalV2)
end

function FormationArmyTipNewV2:ShowResourceCollect()
  if self.view.ctrl.targetType == MarchTargetType.COLLECT then
    self:ShowStageRoot(false)
    local info = CS.SceneManager.World:GetResourcePointInfoByIndex(self.view.ctrl.targetPoint)
    if not info or not info.id then
      self:DoWhenTargetInvalid()
      return
    end
    if info then
      local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(info.pointIndex)
      local remainRes = detail and detail.remainRes or 0
      local burden = remainRes
      if 0 < self.inMarch then
        local marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
        if marchInfo then
          local oldBurden = marchInfo:GetCurArmyWeight()
          local now = UITimeManager:GetInstance():GetServerTime()
          local newBurden = (now - marchInfo.startTime) * 0.001 * marchInfo.collectSpd
          burden = marchInfo.armyWeight - oldBurden - newBurden
        end
      else
        burden = DataCenter.ArmyFormationDataManager:GetFormationBurdenByUuid(self.uuid)
      end
      local canGetResourceNum = math.min(remainRes, burden)
      self.collectMaxNum = canGetResourceNum
      if self.collectRoot then
        self.collectRoot:SetResourceCollectData(MarchTargetType.COLLECT, info.id, canGetResourceNum, info.pointIndex)
      end
    end
  elseif self.view.ctrl.targetType == MarchTargetType.COLLECT_METEORITE then
    self:ShowStageRoot(false)
    if self.collectRoot then
      self.collectRoot:SetCollectIconPath(string.format(LoadPath.ItemPath, "lrb_zhouliuhuodong_jifen"))
    end
    local info = CS.SceneManager.World:GetPointInfo(self.view.ctrl.targetPoint)
    if info then
      local config = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(info.buildId)
      if config == nil then
        return
      end
      local remainRes = info.remainTime
      local canGetResourceNum = remainRes * config.point_produce_per_second + config.point_last
      self.collectMaxNum = canGetResourceNum
      if self.collectRoot then
        self.collectRoot:SetMeteoriteCollectData(MarchTargetType.COLLECT_METEORITE, remainRes, canGetResourceNum)
      end
    end
  elseif self.view.ctrl.targetType == MarchTargetType.PICK_GARBAGE then
    self:ShowStageRoot(false)
    if self.collectRoot then
      self.collectRoot:SetAsPickGarbage()
    end
  elseif self.view.ctrl.targetType == MarchTargetType.SAMPLE then
    self:ShowStageRoot(false)
    if self.collectRoot then
      self.collectRoot:SetSample()
    end
  elseif MarchUtil.IsAssistanceMarch(self.view.ctrl.targetType) then
    self.stageRoot:SetActive(false)
    if self.collectRoot then
      self.collectRoot:SetActive(false)
    end
    self.soldierSlider:ShowTipBtn(false)
    self.warnRoot:SetActive(false)
  elseif self.view.ctrl.targetType == MarchTargetType.ALLIANCE_RESOURCE_COLLECT then
    self:ShowStageRoot(false)
    local info = CS.SceneManager.World:GetPointInfo(self.view.ctrl.targetPoint)
    if not info or not info.configId then
      self:DoWhenTargetInvalid()
      return
    end
    if info then
      local detailData = DataCenter.WorldPointDetailManager:GetAllianceResourceData(info.uuid)
      local remainRes = detailData and detailData.remainValue or 0
      local burden = DataCenter.ArmyFormationDataManager:GetFormationBurdenByUuid(self.uuid)
      local canGetResourceNum = math.min(remainRes, burden)
      if self.collectRoot then
        self.collectRoot:SetAllianceResource(MarchTargetType.ALLIANCE_RESOURCE_COLLECT, info.id, info.configId, canGetResourceNum)
      end
    end
  else
    self:ShowStageRoot(true)
    if self.collectRoot then
      self.collectRoot:SetCollectIconPath("Assets/Main/Sprites/UI/UIFormationDefence/lyp_guaiwu_tubiao_zhanli.png")
    end
  end
end

function FormationArmyTipNewV2:ShowStageRoot(flag)
  self.canStageRootShow = flag
  self.stageRoot:SetActive(flag)
  if flag then
    if self.collectRoot then
      self.collectRoot:SetActive(false)
    end
  else
    if self.collectRoot == nil then
      self.collectRoot = UIAsyncLoaderBridge.New(self, "collectRoot", self.topContainer.transform, "Assets/Main/Prefabs/UI/UIFormation/V2/ResCollectRootV2.prefab", "UI.UIFormation.UIFormationSelectListV2.Component.FormationCollectV2", false, function()
        if self.collectRoot then
          self.collectRoot:SetAsLastSibling()
        end
        if self.tacticalCardSkillNode then
          self.tacticalCardSkillNode:SetAsLastSibling()
        end
        if self.topContainer then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.topContainer.rectTransform)
        end
      end)
    end
    if self.collectRoot ~= nil then
      self.collectRoot:SetActive(true)
      self.collectRoot:RefreshData(self)
    end
  end
  self.soldierSlider:ShowTipBtn(flag)
  self.warnRoot:SetActive(flag and toInt(self.has_resistance) >= toInt(self.need_resistance))
end

local function OnCollectAddClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.cost_add_btn.gameObject.transform.position + Vector3.New(-20, 33, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("121066")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 200
  param.pivot = 0.5
  param.position = position
  param.deltaX = 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnPowerClick(self)
  local desStr = ""
  if self.view.ctrl.targetType == MarchTargetType.PICK_GARBAGE or self.view.ctrl.targetType == MarchTargetType.SAMPLE then
    return
  elseif self.view.ctrl.targetType == MarchTargetType.COLLECT then
    desStr = Localization:GetString("121061")
  else
    desStr = Localization:GetString("120978")
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.cost_btn.gameObject.transform.position + Vector3.New(-20, 33, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = desStr
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 200
  param.pivot = 0.5
  param.position = position
  param.deltaX = 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnSoliderNumClick(self)
  local heroPower = 0
  local armyPower = 0
  local squadEquipPower = 0
  local otherPower = 0
  local dominatorPower = 0
  local isFakeArmyPower = false
  if self.uuid ~= nil then
    local targetType = self.view.ctrl:GetTargetType()
    if targetType == MarchTargetType.EXPLORE then
    else
      local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
      if 0 < self.inMarch then
        if formation then
          heroPower = formation:GetHeroesCapacity() * self.ratio
          armyPower = self.totalSoldierPower * self.ratio
          squadEquipPower = formation:GetEquipCapacity() * self.ratio
          otherPower = formation:GetTWSkillChipCapacity() * self.ratio
          dominatorPower = formation:GetDominatorCapacity() * self.ratio
          isFakeArmyPower = false
        end
      elseif formation then
        heroPower = formation:GetHeroesCapacity()
        armyPower = formation:GetSoldiersCapacity()
        squadEquipPower = formation:GetEquipCapacity()
        otherPower = formation:GetTWSkillChipCapacity()
        dominatorPower = formation:GetDominatorCapacity()
        isFakeArmyPower = false
      end
      local sourceData = {
        heroPower = math.floor(heroPower),
        armyPower = math.floor(armyPower),
        squadEquipPower = math.floor(squadEquipPower),
        otherPower = math.floor(otherPower),
        dominatorPower = math.floor(dominatorPower),
        isFakeArmyPower = isFakeArmyPower
      }
      UIUtil.ShowArmyFormationPowerTips(self.soldier_btn.gameObject.transform.position, -20, 33, sourceData)
    end
  end
end

local function RefreshTimeByUuid(self, uuid, time)
  if uuid ~= nil and self.uuid ~= nil and uuid == self.uuid then
    local realTime = time * 1000 + toInt(self.extraTime)
    local monsterSpecialType = self.view.ctrl.monsterSpecialType
    if self.view.ctrl.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS then
      local maxTime = DataCenter.ActBossDataManager.maxTime * 1000
      if realTime > maxTime then
        realTime = maxTime
      end
      self.isActBossWillDie = false
      local dataList = DataCenter.ActBossDataManager:GetActBossDataList()
      if dataList ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local targetUuid = self.view.ctrl.targetUuid
        for k, v in pairs(dataList) do
          if targetUuid == v.uuid then
            if realTime >= v.actEndTime - curTime + 10000 then
              self.isActBossWillDie = true
            end
            break
          end
        end
      end
    elseif self.view.ctrl.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BERSERK_BOSS then
      local timeLimit = LuaEntry.DataConfig:TryGetNum("BerserkBoss_config", "k2")
      if realTime >= timeLimit * 1000 then
        realTime = timeLimit * 1000
      end
    elseif self.view.ctrl.targetType == MarchTargetType.DETECT_TREASURE then
      local pointInfo = CS.SceneManager.World:GetPointInfo(self.view.ctrl.targetPoint)
      if pointInfo then
        cast(pointInfo, typeof(CS.TreasurePointInfo))
        if pointInfo then
          local worldTreasureType = pointInfo:GetWorldTreasureType()
          if worldTreasureType == WorldTreasureType.ActivityRadarTreasure then
            local maxTime = LuaEntry.DataConfig:TryGetNum("activity_detect_config", "k1", 0)
            if 0 < maxTime and realTime > maxTime * 1000 then
              realTime = maxTime * 1000
            end
          end
        end
      end
    elseif self.view.ctrl.targetType == MarchTargetType.SIMPLE_CITY_EVENT_ATTACK or self.view.ctrl.targetType == MarchTargetType.SIMPLE_CITY_EVENT_COLLECT then
      realTime = 5000
    elseif monsterSpecialType and monsterSpecialType == WorldMonsterSpecialType.S1RestBloodyQueenGunner then
      local cfgTime = LuaEntry.DataConfig:TryGetNum("s1_offSeason_rerecapture", "k17", 6)
      cfgTime = cfgTime * 1000
      if realTime > cfgTime then
        realTime = cfgTime
      end
    elseif monsterSpecialType and monsterSpecialType == WorldMonsterSpecialType.S1RestCityDefendMonster then
      local cfgTime = LuaEntry.DataConfig:TryGetNum("s1_offSeason_rerecapture", "k18", 6)
      cfgTime = cfgTime * 1000
      if realTime > cfgTime then
        realTime = cfgTime
      end
    end
    self.btn_num:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(realTime))
  end
end

local function OnAtkClick(self)
  if self.isAssemble then
    return
  end
  if self.showLackStamina == true and not BattleFieldUtil.InBattleField() then
    return
  end
  local targetType = self.view.ctrl.targetType
  local targetNeedUseMummy = self.view.ctrl.targetNeedUseMummy
  if targetType == MarchTargetType.JOIN_RALLY and not self.inBattleWorld and targetNeedUseMummy and self.fixedSoldierType ~= SoldierType.Mummy then
    UIUtil.ShowTipsId("season_s3_Mummy_tips010")
    return
  end
  if self.isActBossWillDie == true and DataCenter.ActBossDataManager.bossName ~= nil then
    UIUtil.ShowTips(Localization:GetString("456056", DataCenter.ActBossDataManager.bossName))
    return
  end
  if self.canClick == false then
    UIUtil.ShowTipsId(GameDialogDefine.MARCH_IN_OTHER_SERVER)
    return
  end
  local isWrapBySandWorm, time, monsterId = DataCenter.SandWormHuntDataManager:IsMyBaseWormWrap()
  if isWrapBySandWorm then
    if DataCenter.AllyDrillDataManager:IsMonsterBossSandWormCall(monsterId) then
      UIUtil.ShowTipsId("new_alliance_boss_tips_23")
    else
      UIUtil.ShowTipsId("season_activity_1000069_desc31")
    end
    return
  elseif DataCenter.JungleTrialDataManager:IsMyBaseSwallow() then
    UIUtil.ShowTipsId("season6_piranha_swallow_longtip")
    return
  end
  if self.totalSoldierNum == nil or self.totalSoldierNum <= 0 then
    if BattleFieldUtil.InBattleField() then
      local soldierId, count = 0, 0
      local soldier
      if BattleFieldUtil.InBattleField() then
        soldier = DataCenter.SoldierDataManager:GetDragonSoldierInfo()
      else
        local soldiers = DataCenter.SoldierDataManager:GetPlayerSoldiers()
        soldier = soldiers[1]
      end
      if soldier then
        soldierId = soldier.id
        count = soldier.count
      end
      if 0 < soldierId then
        local template = DataCenter.SoldierDataManager:GetTemplate(soldierId)
        LWResourceLackUtil:GotoResourceItemLack(template.resourceItemId, count + 1)
      end
      return
    end
    if self.fixedSoldierType == SoldierType.Mummy then
      UIUtil.ShowTipsId("battle_tip_soldiers")
      return
    end
    local curHaveSolider = DataCenter.ResourceItemDataManager:GetCountByItemId(ResourceItemId.Supply)
    local needCount = curHaveSolider + 1
    LWResourceLackUtil:GotoResourceItemLack(ResourceItemId.Supply, needCount)
    return
  end
  if self.view.ctrl.specialType == WorldMonsterSpecialType.AL_CHALLENGE_BOSS_KIROV then
    local newAlData = DataCenter.ActivityKillZombieManager.newAlData
    local personal = DataCenter.ActivityKillZombieManager:GetSelectMaxPersonalDamage()
    local alliance = DataCenter.ActivityKillZombieManager:GetSelectMaxAllianceDamage()
    if newAlData and personal <= newAlData.personalDamage and alliance <= newAlData.allianceDamage then
      local param = {
        contentText = Localization:GetString("challenge_zombie_attack_airship_check"),
        btnNum = 2,
        confirmBtnParam = {
          action = function()
            self.view.ctrl:OnCheckTime(self.uuid, 0)
          end
        },
        cancelBtnParam = {
          action = function()
            CS.SceneManager.World:SetTouchInputControllerEnable(true)
          end
        },
        closeAction = function()
          CS.SceneManager.World:SetTouchInputControllerEnable(true)
        end
      }
      UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.KillZombieAlBossChallengeMax, param)
    else
      self.view.ctrl:OnCheckTime(self.uuid, 0)
    end
    return
  end
  if self.view.ctrl.targetType == MarchTargetType.RALLY_FOR_BOSS then
    self.view.ctrl:OnCheckTime(self.uuid, 0)
    return
  end
  if self.view.ctrl.targetType == MarchTargetType.JOIN_RALLY then
    if not DataCenter.BuildManager:IsExistBuildByTypeLv(BuildingTypes.LW_BUILD_ALLIANCE_CENTER, 1) then
      GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_ALLIANCE_CENTER)
      return
    end
    if self.view.ctrl.specialType == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 and not DataCenter.S0AllianceBossDataManager:CheckMainLevelLimit() then
      return
    end
  end
  if targetType == MarchTargetType.SIMPLE_CITY_EVENT_ATTACK or targetType == MarchTargetType.SIMPLE_CITY_EVENT_COLLECT then
    self.view.ctrl:CloseSelf()
    return
  end
  if self.inMarch == 1 then
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
    if march ~= nil and (march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchStatus() == MarchStatus.CROSS_SERVER) then
      UIUtil.ShowTipsId(142514)
      return
    end
    self.view:OnAtkClick(self.uuid)
  elseif self.canCreate == true and self.inMarch ~= 1 then
    if self.fixedSoldierType == SoldierType.Mummy then
      local mummyCount = self.totalSoldierNum
      local tipText = Localization:GetString("season_s3_Mummy_march_tips01", mummyCount)
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.MummyAttackConfirm, tipText, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        if self.view and self.uuid then
          self.view:OnCreateClick(self.uuid)
        end
      end, function()
      end, nil, nil, false, nil, nil)
    else
      self.view:OnCreateClick(self.uuid)
    end
  end
end

local function OnEditClick(self)
  self.view:SetEditingIndex(self.index)
  if self.showLackStamina == true then
    local targetType = self.view.ctrl.targetType
    local pointIndex = self.view.ctrl.targetPoint
    local backHome = self.view.ctrl.autoBackHome
    local serverId = self.view.ctrl.targetServerId
    local monsterSpecialType = self.view.ctrl.monsterSpecialType
    local uuid = self.view.ctrl.uuid
    local rallyType = self.view.ctrl.rallyType
    local defaultIndex = self.view.curMarchIndex or 1
    LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy, nil, nil, function()
      local troop = CS.SceneManager.World:GetTroop(uuid)
      local track = false
      if troop then
        local marchInfo = troop:GetMarchInfo()
        if marchInfo and (marchInfo:IsWanderBoss() or marchInfo:GetMarchType() == NewMarchType.ZONE_MOBILIZATION_BOSS) then
          track = true
        end
      end
      UIUtil.OpenFormationSelectUI(1, targetType, pointIndex, uuid, nil, backHome, rallyType, serverId, monsterSpecialType, defaultIndex)
      if track then
        CS.SceneManager.World:TrackMarch(uuid)
      end
    end)
    return
  end
  if self.inMarch == 1 then
    if self.isReturn then
      local marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
      if marchInfo ~= nil then
        MarchUtil.OnBackHome(marchInfo.uuid)
        self.view:HideAllShowTip()
      end
    else
      UIUtil.ShowSingleTip(Localization:GetString("120209"))
    end
    return
  end
  self.view:HideAllShowTip()
  self.view:OnEditClick(self.uuid, false)
end

local function OnBattleStateClick(self)
  local showMessage = false
  local targetLevel = 0
  local k2 = LuaEntry.DataConfig:TryGetNum("res_lack", "k2")
  if k2 >= LuaEntry.Player.pveLevel and self.view.ctrl:GetTargetType() == MarchTargetType.ATTACK_MONSTER then
    local marchInfo = CS.SceneManager.World:GetMarch(self.view.ctrl.targetUuid)
    if marchInfo ~= nil then
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchInfo.monsterId)
      if monster ~= nil then
        targetLevel = tonumber(monster.level)
        local power = self.view.ctrl:GetFormationPowerByUuid(self.uuid)
        local percent = (power - self.battleTargetNum) / math.max(1, self.battleTargetNum)
        if percent <= 0 then
          showMessage = true
        end
      end
    end
  end
  local configOpenState = LuaEntry.DataConfig:CheckSwitch("detect_monster")
  if configOpenState then
    UIUtil.ShowMessage(Localization:GetString("121010"), 1, nil, nil, nil, nil, function(needSellConfirm)
      if needSellConfirm == false then
        Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 1)
      else
        Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 0)
      end
    end, 121009)
  else
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.state_btn.gameObject.transform.position
    local param = UIHeroTipView.Param.New()
    param.title = self.battleStateStr
    param.content = self.battleTargetNum and Localization:GetString("300695") .. ": " .. string.GetFormattedStr2(self.battleTargetNum) or ""
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 200
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function RefreshStaminaState(self)
  if BattleFieldUtil.InBattleField() then
    if self.showLackStamina == true then
      self.showLackStamina = false
      self:RefreshEditBtnText()
      self:RefreshBtnActive()
    end
    return
  end
  self.btn_bubble_tips:SetActive(false)
  if self.view.ctrl.targetType > 0 and self.uuid ~= nil and self.isAssemble == false then
    local costPoint = self.view.ctrl:GetCostStaminaByTargetType(self.view.ctrl.targetType)
    if 1 < costPoint then
      local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
      if formation ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = curTime - LuaEntry.Player.lastStaminaTime
        local curStamina = LuaEntry.Player.stamina
        if costPoint > curStamina then
          local speedAddEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_RECOVER_SPEED_ADD)
          local timeBase = LuaEntry.DataConfig:TryGetNum("car_stamina", "k2")
          local k2 = timeBase / (1 + speedAddEffect / 100)
          if 0 < k2 then
            local delta = costPoint - curStamina
            if delta < 1 then
              delta = 1
            end
            local needTime = delta * k2 * 1000
            if deltaTime < needTime then
              self.showLackStamina = true
              return
            end
          end
        end
      end
    end
  end
  if self.showLackStamina == true then
    self.showLackStamina = false
    self:RefreshEditBtnText()
    self:RefreshBtnActive()
  end
end

local function RefreshEditBtnText(self)
  if self.showLackStamina then
    self.edit_btn_txt:SetLocalText(GameDialogDefine.ADD_STAMINA)
  elseif self.isReturn then
    self.edit_btn_txt:SetLocalText(300520)
  else
    self.edit_btn_txt:SetLocalText(121008)
  end
  if self.rally_txt then
    if self.showLackStamina then
      self.rally_txt:SetLocalText(GameDialogDefine.ADD_STAMINA)
    else
      self.rally_txt:SetLocalText(300038)
    end
  end
end

local function RefreshBtnActive(self)
  if self.view.ctrl.targetType < 0 or self.showLackStamina then
    self.enter_btn:SetActive(false)
    self.setting_btn:SetActive(false)
    self.edit_btn:SetActive(true)
    if self.quick_btn then
      self.quick_btn:SetActive(false)
    end
  else
    self.enter_btn:SetActive(true)
    self.setting_btn:SetActive(true)
    self.edit_btn:SetActive(false)
    if self.quick_btn then
      self.quick_btn:SetActive(false)
      if self.inMarch == 0 then
        self:CalcQuickEditInfo()
      end
    end
  end
end

local function RefreshMarch(self)
  if self.inMarch <= 0 then
    return
  end
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
  if not formation then
    return
  end
  formation:ConscriptSoldier(false, self.fixedSoldierType)
  local armyInfo = self.formationData.armyInfo
  if not armyInfo then
    Logger.LogError("\232\161\140\229\134\155\231\154\132.combatInfos\229\173\151\230\174\181\228\184\186\231\169\186,\229\190\136\229\143\175\232\131\189\230\152\175\229\144\142\231\171\175\233\151\174\233\162\152,marchUuid=" .. self.formationData.marchUuid or 0)
    return
  end
  local dirty = false
  local s3_mummy_config_k7 = SeasonUtil.GetMummyConfigNum("k7", 1)
  local curSoldierTotalNum, soldierLv, heroSoldierNum, totalSoldierPower = MarchUtil.GetSoldierData(armyInfo, self.fixedSoldierType)
  local keys = table.keys(soldierLv)
  local t11_num = 0
  for _, v in ipairs(keys) do
    if T11Util.IsSuperSoldier(v) and soldierLv[v].count then
      t11_num = t11_num + soldierLv[v].count
    end
  end
  local superSoldierPower = 0
  if 0 < curSoldierTotalNum then
    superSoldierPower = T11Util.GetAttributePower(t11_num * 1.0 / curSoldierTotalNum)
  end
  totalSoldierPower = totalSoldierPower + superSoldierPower
  dirty = dirty or self.totalSoldierPower ~= totalSoldierPower or self.totalSoldierNum ~= curSoldierTotalNum
  self.heroSoldierNum = heroSoldierNum
  self.totalSoldierNum = curSoldierTotalNum
  for i = 1, 5 do
    self.supplyText[i]:SetActive(false)
    self.supplyBar[i]:SetActive(false)
  end
  for k, v in pairs(armyInfo.HeroInfos) do
    local i = v.index
    if i >= ArmyFormationSlot.Dominator then
      break
    end
    self.supplyText[i]:SetActive(true)
    self.supplyBar[i]:SetActive(true)
    local hero = DataCenter.HeroDataManager:GetHeroByHeroId(v.heroId)
    if hero then
      local capacity = hero:GetSoldierCapacity()
      if self.fixedSoldierType == SoldierType.Mummy and s3_mummy_config_k7 ~= 0 and s3_mummy_config_k7 ~= 1 then
        capacity = math.ceil(capacity / s3_mummy_config_k7)
      end
      if heroSoldierNum[i] then
        local supply = math.min(heroSoldierNum[i], capacity)
        local percent = supply / capacity
        self.supplyText[i]:SetText(math.floor(supply))
        self.supplyBar[i]:SetValue(percent)
      else
        self.supplyText[i]:SetText("0")
        self.supplyBar[i]:SetValue(0)
      end
    else
      self.supplyText[i]:SetText("0")
      self.supplyBar[i]:SetValue(0)
    end
  end
  if self.dominatorLine and heroSoldierNum then
    self.dominatorLine:SetSupply(heroSoldierNum[ArmyFormationSlot.Dominator], self.fixedSoldierType)
  end
  local soldierNumInMarch = curSoldierTotalNum
  local soldierLimit = formation:GetAllHeroSoldierCapacity()
  local soldierNumInMarchStr = string.GetFormattedSeparatorNum(math.floor(soldierNumInMarch))
  local soldierLimitStr = string.GetFormattedSeparatorNum(math.floor(soldierLimit))
  self.soldierSliderText:SetText(soldierNumInMarchStr .. "/" .. soldierLimitStr)
  self.ratio = soldierLimit == 0 and 0 or curSoldierTotalNum / soldierLimit
  self.totalSoldierPower = totalSoldierPower
  self:UpdatePower()
  local armyId = self:GetArmyId()
  local soldierData = self.soldierSlider:CreateParam(soldierLimit, soldierNumInMarch, soldierLv, armyId)
  self.soldierSlider:SetData(self, soldierData, self.fixedSoldierType)
  self:SoldierInfoRefresh(soldierLv, armyId)
  if dirty and self.battleSimulatedTip ~= nil then
    local has_resistance = toInt(self.has_resistance)
    local need_resistance = toInt(self.need_resistance)
    if has_resistance < need_resistance then
      self.battleSimulatedTip:TrySimulated()
    end
  end
end

function FormationArmyTipNewV2:SwitchFormationSoldierUI(first)
  if first and self.animSwitchSoldier ~= nil then
    self.animSwitchSoldier:Kill()
    self.animSwitchSoldier = nil
  end
  if not self.inBattleWorld and SeasonUtil.IsMummySoldierFunctionEnabled() then
    local isExistBuilding = DataCenter.BuildManager:HasSeasonMummyYardBuilding()
    if first then
      self.mummy_bg:LoadSprite("Assets/Main/SeasonRes/Shared/Textures/MummyAttack/ljq_saijis3_chuzheng_tips.png")
    end
    self.mummy_bg:SetActive(true)
    if self.fixedSoldierType == SoldierType.Mummy then
      self.soldier_slider_bg_base:SetEnable(false)
      self.line:SetEnable(false)
      if self.eff_ui_mummy_tips_anim == nil then
        local effectPrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/Eff_ui_S3_tips_saoguang.prefab"
        self.layout:SetEnable(false)
        self.eff_ui_mummy_tips_anim = UIBaseComponent.LoadComponentAsync(self, UIAsyncContainer, effectPrefabPath, self.eff_ui_mummy_tips_anim_root, function(view, go, lua, callback_param)
          if lua and lua.rectTransform then
            lua.rectTransform:Set_offsetMin(0, 0)
            lua.rectTransform:Set_offsetMax(0, 0)
          end
          if self.layout then
            self.layout:SetEnable(true)
            CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
          end
        end)
      else
        self.layout:SetEnable(true)
      end
    else
      self.mummy_bg:SetAlpha(0)
      self.layout:SetEnable(true)
      self.soldier_slider_bg_base:SetEnable(true)
      self.line:SetEnable(true)
    end
    local targetType = self.view.ctrl.targetType
    local targetUuid = self.view.ctrl.targetUuid
    if 0 <= targetType then
      local rallyType = self.view.ctrl:GetRallyType()
      self.has_resistance, self.need_resistance = FormationSeasonResistance.CheckResistance(self, self.topContainer, targetType, self.fixedSoldierType, rallyType, targetUuid)
      self.warnRoot:SetActive(self.canStageRootShow and toInt(self.has_resistance) >= toInt(self.need_resistance))
    end
    self.switch_icon:SetActive(isExistBuilding)
    self.switch_icon:SetEnable(isExistBuilding)
    self.switch_icon:SetSizeDeltaXY(88, 88)
    self.switch_icon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UIMummy/ljq_saijis3_chuzheng_qiehuan02.png")
    self.switch_icon_top:SetActive(isExistBuilding)
    self.switch_icon_top:SetEnable(isExistBuilding)
    self.switch_icon_top:SetSizeDeltaXY(88, 88)
    self.switch_icon_top:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UIMummy/ljq_saijis3_chuzheng_qiehuan01.png")
    self:InitFormationArmyTipsAnim(isExistBuilding)
    Setting:SetPrivateInt("TheLastUseSoldierType", self.fixedSoldierType or 1)
  else
    Setting:SetPrivateInt("TheLastUseSoldierType", SoldierType.Player)
    self.switch_icon:SetActive(false)
    self.switch_icon_top:SetActive(false)
    self.formation_army_tips:Enable(false)
    if self.mummy_bg then
      self.mummy_bg:SetActive(false)
    end
  end
  if self.eff_ui_mummy_tips_anim then
    self.eff_ui_mummy_tips_anim:SetActive(self.fixedSoldierType == SoldierType.Mummy)
  end
  self:InitRallyTime()
end

function FormationArmyTipNewV2:InitFormationArmyTipsAnim(isExistBuilding)
  if self.showArmyTipsAnimCount == nil then
    self.showArmyTipsAnimCount = 1
  else
    self.showArmyTipsAnimCount = self.showArmyTipsAnimCount + 1
  end
  if self.animSwitchSoldier == nil and isExistBuilding and self.showArmyTipsAnimCount > 1 then
    self.formation_army_tips:Enable(true)
    if self.fixedSoldierType == self.lastFixedSoldierType or self.lastFixedSoldierType == nil then
      if self.fixedSoldierType == SoldierType.Mummy then
        self.formation_army_tips:Play("default_show")
      else
        self.formation_army_tips:Play("default_hide")
      end
      self.common_img_tips_arrow:SetAlpha(1)
    elseif self.fixedSoldierType == SoldierType.Mummy then
      self.formation_army_tips:Play("V_ui_S3_tips_in")
    else
      self.formation_army_tips:Play("V_ui_S3_tips_out")
    end
  end
end

function FormationArmyTipNewV2:InitRallyTime()
  self.view.ctrl:InitRallyTime(self.fixedSoldierType)
  if not IsNull(self.centerTf) then
    local list = self.view.ctrl:GetRallyTimeList()
    if self.des == nil then
      self.des = self:AddComponent(UIText, des_path)
      self.des:SetLocalText(390136)
    end
    if self.rally_txt == nil then
      self.rally_txt = self:AddComponent(UIText, btn_rally_path)
    end
    if self.toggle == nil then
      self.toggle = {}
    end
    for i = 1, 4 do
      if self.toggle[i] == nil then
        self.toggle[i] = self:AddComponent(UIToggle, toggle_path .. i)
        self.toggle[i]:SetOnValueChanged(function(tf)
          if tf then
            self:ToggleControlBorS()
          end
        end)
      end
      if self.toggle[i] then
        if list[i] then
          self.toggle[i]:SetActive(true)
          self.toggle[i]:SetIsOn(i == 1)
          if self.toggle[i].text == nil then
            self.toggle[i].text = self.toggle[i]:AddComponent(UIText, "Text_num")
          end
          self.toggle[i].text:SetText(list[i] .. Localization:GetString("100165"))
        else
          self.toggle[i]:SetActive(false)
        end
      end
    end
    self:ToggleControlBorS()
  end
end

function FormationArmyTipNewV2:SwitchFormationSoldier()
  if not SeasonUtil.IsMummySoldierFunctionEnabled() or self.inBattleWorld then
    return
  end
  if self.inMarch == 1 then
    UIUtil.ShowTipsId("season_s3_tips011")
    return
  end
  local targetType = self.view.ctrl:GetTargetType()
  if targetType == MarchTargetType.JOIN_RALLY and self.fixedSoldierType == SoldierType.Mummy then
    local allianceWarData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.view.ctrl.targetUuid)
    if allianceWarData ~= nil and allianceWarData.fixedSoldierType == SoldierType.Mummy then
      UIUtil.ShowTipsId("season_s3_Mummy_tips008")
      return
    end
  end
  if MarchUtil.IsRallyMarch(targetType) and self.fixedSoldierType == SoldierType.Player then
    local number = LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_MUMMY_Effect_Id_RALLY_MARCH)
    if number <= 0 then
      UIUtil.ShowTipsId("season_s3_Mummy_tips007")
      return
    end
  end
  if self.animSwitchSoldier ~= nil then
    return
  end
  if self.fixedSoldierType == SoldierType.Player then
    local isExistBuilding = DataCenter.BuildManager:HasSeasonMummyYardBuilding()
    if not isExistBuilding then
      return
    end
    local mummyCount = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy)
    if mummyCount == 0 then
      UIUtil.ShowTipsId("season_s3_Mummy_tips015")
      return
    end
  end
  local sequence = DOTween.Sequence()
  sequence:InsertCallback(0, function()
    self.formation_army_tips:Enable(true)
    if self.fixedSoldierType == SoldierType.Mummy then
      self.formation_army_tips:Play("V_ui_S3_tips_out")
    else
      self.formation_army_tips:Play("V_ui_S3_tips_in")
    end
  end)
  sequence:AppendInterval(0.5)
  sequence:AppendCallback(function()
    if self.fixedSoldierType == SoldierType.Player then
      self.fixedSoldierType = SoldierType.Mummy
    else
      self.fixedSoldierType = SoldierType.Player
    end
    self.fixedSoldierTypeDict[self.uuid or "???"] = self.fixedSoldierType
    if self.inMarch > 0 then
      self:RefreshMarch()
    else
      self:RefreshFormation()
    end
    self:SwitchFormationSoldierUI(false)
  end)
  sequence:AppendInterval(0.5)
  sequence:AppendCallback(function()
    self.animSwitchSoldier = nil
  end)
  self.animSwitchSoldier = sequence
end

function FormationArmyTipNewV2:GetArmyId()
  local armyId = 0
  if self.monster and self.monster.armyId then
    armyId = self.monster.armyId
  elseif self.monster then
    local oneTemplate = LocalController:instance():tryGetLine(LuaEntry.Player:GetABTestTableName(TableName.Monster), tostring(self.monster.id))
    if oneTemplate ~= nil then
      local armyIds = oneTemplate:getValue("army")
      if armyIds then
        armyId = armyIds[1] or 0
      else
        armyId = 0
      end
    end
  end
  return armyId
end

local function RefreshFormation(self)
  if self.inMarch > 0 then
    return
  end
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
  if not formation then
    return
  end
  local dirty = false
  local s3_mummy_config_k7 = SeasonUtil.GetMummyConfigNum("k7", 1)
  formation:ConscriptSoldier(false, self.fixedSoldierType)
  dirty = dirty or self.heroTotalSoldierCapacity ~= formation.heroTotalSoldierCapacity or self.totalSoldierNum ~= formation.totalSoldierNum
  self.totalSoldierNum = formation.totalSoldierNum
  self.heroTotalSoldierCapacity = formation.heroTotalSoldierCapacity
  for i = 1, 5 do
    self.supplyText[i]:SetActive(false)
    self.supplyBar[i]:SetActive(false)
  end
  self.heroSoldierNum = {}
  for k, v in pairs(formation.soldiers) do
    self.heroSoldierNum[k] = v.supply
  end
  if self.formationData.heroDataList then
    for k, v in pairs(self.formationData.heroDataList) do
      local hero = DataCenter.HeroDataManager:GetHeroByUuid(v.heroUuid)
      local capacity = hero:GetSoldierCapacity()
      local i = formation.localHeroes[v.heroUuid]
      if i then
        if self.fixedSoldierType == SoldierType.Mummy and s3_mummy_config_k7 ~= 0 and s3_mummy_config_k7 ~= 1 then
          capacity = math.ceil(capacity / s3_mummy_config_k7)
        end
        self.supplyText[i]:SetActive(true)
        self.supplyBar[i]:SetActive(true)
        if formation.soldiers and formation.soldiers[i] and formation.soldiers[i].supply then
          local supply = math.min(formation.soldiers[i].supply, capacity)
          local percent = supply / capacity
          self.supplyText[i]:SetText(math.floor(supply))
          self.supplyBar[i]:SetValue(percent)
          local tmp = math.ceil(percent / 0.2)
          self:DoFlyAnim(i, tmp)
        else
          self.supplyText[i]:SetText("0")
          self.supplyBar[i]:SetValue(0)
        end
      end
    end
  end
  if self.dominatorLine and formation.soldiers then
    local data = formation.soldiers[ArmyFormationSlot.Dominator]
    if data then
      self.dominatorLine:SetSupply(data.supply, self.fixedSoldierType)
    end
  end
  local soldierNumInFormation = formation.totalSoldierNum
  local soldierLimit = formation:GetAllHeroSoldierCapacity()
  local soldierNumInFormationStr = string.GetFormattedSeparatorNum(math.floor(soldierNumInFormation))
  local soldierLimitStr = string.GetFormattedSeparatorNum(math.floor(soldierLimit))
  self.soldierSliderText:SetText(soldierNumInFormationStr .. "/" .. soldierLimitStr)
  self.ratio = soldierLimit == 0 and 0 or soldierNumInFormation / soldierLimit
  self:UpdatePower()
  local armyId = self:GetArmyId()
  local soldierData = self.soldierSlider:CreateParam(soldierLimit, soldierNumInFormation, formation.soldiersLv, armyId)
  self.soldierSlider:SetData(self, soldierData, self.fixedSoldierType)
  self:SoldierInfoRefresh(formation.soldiersLv, armyId)
  if dirty and self.battleSimulatedTip ~= nil then
    local has_resistance = toInt(self.has_resistance)
    local need_resistance = toInt(self.need_resistance)
    if has_resistance < need_resistance then
      self.battleSimulatedTip:TrySimulated()
    end
  end
end

local function DoFlyAnim(self, i, tmp)
  if not self:IsCanDoFlyAnim() then
    return
  end
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if not self.troop_image then
      return
    end
    if IsNull(self.troop_image.transform) then
      return
    end
    local pic = "Assets/Main/Sprites/ItemIcons/Common_icon_soldier_lv1.png"
    local srcPos = self.troop_image.transform.position
    local targetPos = self.heroList[i].transform.position
    UIUtil.DoFlyCustom(pic, nil, tmp, srcPos, targetPos, nil, nil, nil, nil, nil, nil, nil, self.transform, 34)
    DataCenter.LWSoundManager:PlaySound(10028)
  end, 3)
end

local function IsCanDoFlyAnim(self)
  local isDo = false
  local limitMainLv = 8
  local mainLv = DataCenter.BuildManager.MainLv or 0
  if limitMainLv > mainLv then
    isDo = true
  end
  return isDo
end

function FormationArmyTipNewV2:RefreshTime()
  if self.uuid then
    local time = self.view:GetTimeInFormation(self.uuid, self.fixedSoldierType, self.UseLightWorkerMan == 1)
    self:RefreshTimeByUuid(self.uuid, time)
  end
end

function FormationArmyTipNewV2:Update1000MS()
  self.view.ctrl:RefreshTargetPoint()
  self:RefreshTime()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.FormationSoldierUpdate, self.RefreshFormation)
  self:AddUIListener(EventId.WorldMarchDelete, self.RefreshFormation)
  self:AddUIListener(EventId.GF_hero_squad_saved, self.RefreshFormation)
  self:AddUIListener(EventId.MyBaseTemperatureConfigChange, self.RefreshTime)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshTime)
  self:AddUIListener(EventId.BattleTeamInfoRefresh, self.OnBattleTeamInfoRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.FormationSoldierUpdate, self.RefreshFormation)
  self:RemoveUIListener(EventId.WorldMarchDelete, self.RefreshFormation)
  self:RemoveUIListener(EventId.GF_hero_squad_saved, self.RefreshFormation)
  self:RemoveUIListener(EventId.MyBaseTemperatureConfigChange, self.RefreshTime)
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshTime)
  self:RemoveUIListener(EventId.BattleTeamInfoRefresh, self.OnBattleTeamInfoRefresh)
end

local function ToggleControlBorS(self)
  if not IsNull(self.centerTf) then
    self.timeIndex = 0
    for i = 1, #self.toggle do
      if self.toggle[i]:GetIsOn() then
        self.timeIndex = i
        break
      end
    end
    self.view.ctrl:SetTimeIndex(self.timeIndex)
  end
end

function FormationArmyTipNewV2:OnQuickEditClick()
  if self.quick_btn == nil or not self.quick_btn:GetActive() then
    return
  end
  local squadData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
  if not squadData then
    self.enter_btn:SetActive(true)
    self.quick_btn:SetActive(false)
    return
  end
  if DataCenter.HeroDataManager:AutoFillArmyFormation(squadData, 1) > 0 then
    DataCenter.LWSoundManager:PlaySound(10012)
  else
    self.enter_btn:SetActive(true)
    self.quick_btn:SetActive(false)
  end
end

function FormationArmyTipNewV2:CalcQuickEditInfo()
  if self.quick_btn == nil or self.enter_btn == nil or not self.enter_btn:GetActive() then
    return
  end
  local quickSquadCtrl = LuaEntry.DataConfig:TryGetNum("newbies_herosquad_control", "k1", 0)
  if quickSquadCtrl ~= 1 then
    return
  end
  local maxLevel = LuaEntry.DataConfig:TryGetNum("auto_arrangement", "k1", 0)
  if maxLevel == nil or maxLevel == 0 or maxLevel < DataCenter.BuildManager.MainLv then
    return
  end
  local squadData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
  if not squadData then
    return
  end
  local emptySlot = squadData:GetEmptySlotIndex()
  if emptySlot ~= nil then
    local hasIdleHero = false
    local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
    for uuid, _ in pairs(heroDataList) do
      local squadIndex = DataCenter.ArmyFormationDataManager:GetHeroSquadIndex(uuid)
      if squadIndex == nil then
        hasIdleHero = true
        break
      end
    end
    if hasIdleHero then
      self.enter_btn:SetActive(false)
      self.quick_btn:SetActive(true)
    end
  end
end

function FormationArmyTipNewV2:DoWhenTargetInvalid()
  UIUtil.ShowTipsId(120816)
  self.view:HideFormationArmyTip()
end

function FormationArmyTipNewV2:SetTacticalCardSkillNodeVisible(visible)
  if self.tacticalCardSkillNode then
    self.tacticalCardSkillNode:SetActive(visible)
  end
end

FormationArmyTipNewV2.RefreshFormation = RefreshFormation
FormationArmyTipNewV2.RefreshMarch = RefreshMarch
FormationArmyTipNewV2.OnAddListener = OnAddListener
FormationArmyTipNewV2.OnRemoveListener = OnRemoveListener
FormationArmyTipNewV2.OnDestroy = OnDestroy
FormationArmyTipNewV2.OnCreate = OnCreate
FormationArmyTipNewV2.OnEnable = OnEnable
FormationArmyTipNewV2.OnDisable = OnDisable
FormationArmyTipNewV2.RefreshData = RefreshData
FormationArmyTipNewV2.RefreshTimeByUuid = RefreshTimeByUuid
FormationArmyTipNewV2.OnAtkClick = OnAtkClick
FormationArmyTipNewV2.CostRefresh = CostRefresh
FormationArmyTipNewV2.OnEditClick = OnEditClick
FormationArmyTipNewV2.CheckBattleState = CheckBattleState
FormationArmyTipNewV2.UpdatePower = UpdatePower
FormationArmyTipNewV2.OnClearHeroList = OnClearHeroList
FormationArmyTipNewV2.OnBattleStateClick = OnBattleStateClick
FormationArmyTipNewV2.RefreshHeroList = RefreshHeroList
FormationArmyTipNewV2.OnPowerClick = OnPowerClick
FormationArmyTipNewV2.OnSoliderNumClick = OnSoliderNumClick
FormationArmyTipNewV2.ResetOldUuid = ResetOldUuid
FormationArmyTipNewV2.RefreshStaminaState = RefreshStaminaState
FormationArmyTipNewV2.SetButtonState = SetButtonState
FormationArmyTipNewV2.OnCollectAddClick = OnCollectAddClick
FormationArmyTipNewV2.RefreshEditBtnText = RefreshEditBtnText
FormationArmyTipNewV2.RefreshBtnActive = RefreshBtnActive
FormationArmyTipNewV2.ToggleControlBorS = ToggleControlBorS
FormationArmyTipNewV2.DoFlyAnim = DoFlyAnim
FormationArmyTipNewV2.IsCanDoFlyAnim = IsCanDoFlyAnim
return FormationArmyTipNewV2
