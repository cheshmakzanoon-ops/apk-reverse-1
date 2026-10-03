local FormationCreateTipNew = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationCreateTipNew")
local FormationRallyTipNew = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationRallyTipNew")
local FormationArmyTipNew = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationArmyTipNew")
local FormationSelectListCellNew = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationSelectListCellNew")
local FormationScoutSelectList = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationScoutSelectList")
local FormationStaminaSlider = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationStaminaSlider")
local DisguiseArmyTip = require("UI.UIFormation.UIFormationSelectListNew.Component.DisguiseArmyTip")
local UIFormationSelectListNewView = BaseClass("UIFormationSelectListNewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local content_path = "Area/bg/layout"
local formation_army_tip_path = "Area/FormationArmyTips"
local rally_army_tip_path = "Area/RallyArmyTip"
local create_army_tip_path = "Area/CreateArmyTip"
local formationCampSelectList_path = "Area/bg"
local formationScoutSelectList_path = "Area/scoutBg"
local exchangeBtn_path = "Area/exchangeBtn"
local troopInfoIcon_path = "Area/formationBtn/troopImg"
local troopInfoNum_path = "Area/formationBtn/troopNum"
local guide_special_btn_path = "GuideSpecialBtn"
local formationStaminaSlider_path = "Area/bg/sliderBg"
local wormHoleTips_img_path = "Area/Img_WormHole"
local wormHoleTips_txt_path = "Area/Img_WormHole/Txt_WormHoleTips"
local disguiseArmyTip_path = "Area/DisguiseArmyTip"
local GuideClickCount = 2

local function OnCreate(self)
  base.OnCreate(self)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Darkness then
    LuaEntry.GlobalData.UseLightWorkerMan = 0
  end
  self.ctrl:InitData(self:GetUserData())
  if 0 < self.ctrl.defaultMarchIndex then
    self.editingIndex = self.ctrl.defaultMarchIndex
  end
  self.curFormationType = self.ctrl.formationType
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.formationCampSelectList = self:AddComponent(UIBaseContainer, formationCampSelectList_path)
  self.formation_army_tip = self:AddComponent(FormationArmyTipNew, formation_army_tip_path)
  self.formation_army_tip:SetActive(false)
  self.disguiseArmyTip = self:AddComponent(DisguiseArmyTip, disguiseArmyTip_path)
  self.disguiseArmyTip:SetActive(false)
  self.rally_army_tip = self:AddComponent(FormationRallyTipNew, rally_army_tip_path)
  self.rally_army_tip:SetActive(false)
  self.create_army_tip = self:AddComponent(FormationCreateTipNew, create_army_tip_path)
  self.create_army_tip:SetActive(false)
  self.formationScoutSelectList = self:AddComponent(FormationScoutSelectList, formationScoutSelectList_path)
  self.formationScoutSelectList:SetActive(false)
  self.formationStaminaSlider = self:AddComponent(FormationStaminaSlider, formationStaminaSlider_path)
  self.formationStaminaSlider:SetTipPivot(Vector2.zero)
  self.exchangeBtn = self:AddComponent(UIButton, exchangeBtn_path)
  self.exchangeBtn:SetOnClick(function()
    self:OnClickExchangeBtn()
  end)
  
  function self.timer_action(temp)
    self:RefreshFormationStamina()
  end
  
  self.guide_special_btn = self:AddComponent(UIButton, guide_special_btn_path)
  self.guide_special_btn:SetOnClick(function()
    self:OnClickGuideSpecialBtn()
  end)
  self.troopInfoIcon = self:AddComponent(UIImage, troopInfoIcon_path)
  self.troopInfoNum = self:AddComponent(UIText, troopInfoNum_path)
  self._wormHoleTips_img = self:AddComponent(UIBaseContainer, wormHoleTips_img_path)
  self._wormHoleTips_txt = self:AddComponent(UIText, wormHoleTips_txt_path)
  self.formationList = {}
  self.FormationTimeList = {}
  self.FormationPowerList = {}
  self.troopLine = nil
  self.dragInstance = nil
  self.guideState = 0
end

local function OnDestroy(self)
  self.title = nil
  self.content = nil
  self.return_btn = nil
  self.formationList = nil
  self.guideState = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.guide_special_btn:SetActive(false)
  self:OnRefresh()
  self:AddTimer()
  self.ctrl:TargetSpDeal(true)
end

local function OnDisable(self)
  self:DeleteTimer()
  self.ctrl:TargetSpDeal(false)
  base.OnDisable(self)
  CS.WorldScene.selectMarchUuid = 0
  if CS.SceneManager.World ~= nil then
    CS.SceneManager.World.marchUuid = 0
  end
  self:HideTroopLine()
end

function UIFormationSelectListNewView:SetEditingIndex(index)
  self.editingIndex = index
end

local function ClearContent(self)
  self.content:RemoveComponents(FormationSelectListCellNew)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self.formationList = {}
end

local function OnRefresh(self)
  if self.ctrl.targetType == MarchTargetType.BUILD_WORM_HOLE then
    self._wormHoleTips_img:SetActive(true)
    self._wormHoleTips_txt:SetLocalText(143581)
  elseif self.ctrl.targetType == MarchTargetType.CROSS_SERVER_WORM then
    self._wormHoleTips_img:SetActive(true)
    local des = Localization:GetString("104277", self.ctrl.targetServerId)
    self._wormHoleTips_txt:SetText(des)
  elseif self.ctrl.targetType == MarchTargetType.BACK_HOME and CrossServerUtil:GetIsCrossServer() then
    self._wormHoleTips_img:SetActive(true)
    local des = Localization:GetString("104277", self.ctrl.targetServerId)
    self._wormHoleTips_txt:SetText(des)
  else
    self._wormHoleTips_img:SetActive(false)
  end
  if self.ctrl.targetType == MarchTargetType.SIMPLE_CITY_EVENT_ATTACK or self.ctrl.targetType == MarchTargetType.SIMPLE_CITY_EVENT_COLLECT then
  end
  if self.curFormationType == 1 then
    self.formationCampSelectList:SetActive(true)
    self.formationScoutSelectList:SetActive(false)
    self:ClearContent()
    local createNum = 0
    local data = self.ctrl:GetFormationListData()
    local serverId = LuaEntry.Player:GetCurServerId()
    if self.view.ctrl.targetType == MarchTargetType.CROSS_SERVER_WORM then
      serverId = LuaEntry.Player:GetSelfServerId()
    end
    if data ~= nil then
      do
        local list = data.list
        if list ~= nil then
          do
            local selectIndex = self.editingIndex
            selectIndex = selectIndex or self.ctrl:BestSelect()
            for i = 1, data.maxNum do
              if self.model[i] == nil then
                self.model[i] = self:GameObjectInstantiateAsync(UIAssets.FormationSelectListCellNew, function(request)
                  if request.isError then
                    return
                  end
                  local go = request.gameObject
                  go.gameObject:SetActive(true)
                  go.transform:SetParent(self.content.transform)
                  go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                  local nameStr = tostring(NameCount)
                  go.name = nameStr
                  NameCount = NameCount + 1
                  local cell = self.content:AddComponent(FormationSelectListCellNew, nameStr)
                  if list[i] ~= nil then
                    cell:SetUuidAndIndex(i, list[i])
                    cell:RefreshData()
                  else
                    cell:SetUuidAndIndex(i)
                    cell:RefreshData()
                  end
                  self.formationList[i] = cell
                  createNum = createNum + 1
                  if createNum >= data.maxNum and self.ctrl.targetType >= 0 then
                    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
                    if selectIndex then
                      self.formationList[selectIndex]:OnAtkClick()
                    end
                  end
                end)
              end
            end
          end
        end
      end
    end
  else
    self:ClearContent()
    self.formationCampSelectList:SetActive(false)
    self.formationScoutSelectList:SetActive(true)
    self.formationScoutSelectList:InitUI()
  end
  self:RefreshTroopInfo()
  if self.ctrl.targetPoint and self.ctrl.targetPoint > 0 then
    self.exchangeBtn:SetActive(false)
  else
    self.exchangeBtn:SetActive(true)
  end
end

local function RefreshTroopInfo(self)
  local totalNum = 0
  local marchNum = 0
  if self.curFormationType == 1 then
    self.troopInfoIcon:LoadSprite(string.format(LoadPath.LWMainUINew, "dl_zhujiemian_chuzheng_chuzheng"))
    local march = self.view.ctrl:GetAllMarch()
    local list = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
    if list ~= nil then
      totalNum = #list
    end
    for k, v in pairs(march) do
      local theMarchType = v:GetMarchType()
      if theMarchType == NewMarchType.NORMAL or theMarchType == NewMarchType.CROSS_NORMAL or theMarchType == NewMarchType.FAKE_ATTACK or theMarchType == NewMarchType.ALL_OUT or theMarchType == NewMarchType.ASSEMBLY_MARCH or theMarchType == NewMarchType.EXPLORE then
        marchNum = marchNum + 1
      end
    end
  else
    self.troopInfoIcon:LoadSprite(string.format(LoadPath.UIMainNew, "UIMain_icon_detect"))
    local allInvesFormations = self.ctrl:GetAllScoutFormations()
    local march = self.view.ctrl:GetAllMarch()
    for k, v in pairs(march) do
      if v:IsScoutMarch() then
        marchNum = marchNum + 1
      end
    end
    totalNum = #allInvesFormations
  end
  self.troopInfoNum:SetText(marchNum .. "/" .. totalNum)
  if self.ctrl.targetType == MarchTargetType.GO_WORM_HOLE then
    self:SetRLInfo()
  end
end

local function OnClickExchangeBtn(self)
  if self.curFormationType == 1 then
    self.curFormationType = 2
    self:HideAllShowTip()
  else
    self.curFormationType = 1
  end
  self:OnRefresh()
end

local function OnMarchRefresh(self)
  if self.formationList ~= nil then
    table.walk(self.formationList, function(k, v)
      v:RefreshData()
    end)
  end
  self:RefreshTroopInfo()
end

local function OnSelectClick(self, uuid)
  table.walk(self.formationList, function(k, v)
    v:OnSelectClick(uuid)
  end)
  self:RefreshCost()
end

local function RefreshCost(self)
  self.formationStaminaSlider:UpdateCost()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MarchItemUpdateSelf, self.OnMarchRefresh)
  self:AddUIListener(EventId.ArmyFormatUpdate, self.OnMarchRefresh)
  self:AddUIListener(EventId.UpdateCollectPos, self.UpdateCollectPos)
  self:AddUIListener(EventId.ShowTroopBattleValue, self.ShowTroopBattleSignal)
  self:AddUIListener(EventId.RefreshGuide, self.OnRefreshGuideSignal)
  self:AddUIListener(EventId.AttackSpecialStateFlag, self.AttackSpecialStateFlagSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MarchItemUpdateSelf, self.OnMarchRefresh)
  self:RemoveUIListener(EventId.ArmyFormatUpdate, self.OnMarchRefresh)
  self:RemoveUIListener(EventId.UpdateCollectPos, self.UpdateCollectPos)
  self:RemoveUIListener(EventId.ShowTroopBattleValue, self.ShowTroopBattleSignal)
  self:RemoveUIListener(EventId.RefreshGuide, self.OnRefreshGuideSignal)
  self:RemoveUIListener(EventId.AttackSpecialStateFlag, self.AttackSpecialStateFlagSignal)
end

local function UpdateCollectPos(self, pos)
  self.ctrl:SetTargetPoint(pos)
end

local function ShowFormationArmyTip(self, posX, posY, formationData)
  self.formation_army_tip:SetActive(true)
  self.create_army_tip:SetActive(false)
  self.rally_army_tip:SetActive(false)
  self.disguiseArmyTip:SetActive(false)
  self.curMarchIndex = formationData.index
  self.formation_army_tip:RefreshData(posX, posY, formationData)
  if formationData ~= nil and self.ctrl.targetType >= 0 and self.ctrl.targetType ~= MarchTargetType.BACK_HOME and self.ctrl.targetType ~= MarchTargetType.CROSS_SERVER_WORM and self.ctrl.targetType ~= MarchTargetType.SIMPLE_CITY_EVENT_ATTACK then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    self:ShowTroopLine(formationData.startPos, self.ctrl.targetPoint, formationData.marchCurServer or formationData.serverId or loginServerId, self.ctrl.targetServerId)
  else
    self:HideTroopLine()
  end
  TimerManager:GetInstance():DelayInvoke(function()
    self:RefreshGuideBtn()
  end, 0.2)
end

local function ShowDisguiseArmyTip(self, posX, posY, formationData, isMarch)
  self.formation_army_tip:SetActive(false)
  self.create_army_tip:SetActive(false)
  self.rally_army_tip:SetActive(false)
  self.disguiseArmyTip:SetActive(true)
  self.disguiseArmyTip:RefreshData(posX, posY, formationData, isMarch)
  if formationData ~= nil and self.ctrl.targetType >= 0 and self.ctrl.targetType ~= MarchTargetType.BACK_HOME and self.ctrl.targetType ~= MarchTargetType.CROSS_SERVER_WORM then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    self:ShowTroopLine(formationData.startPos, self.ctrl.targetPoint, formationData.marchCurServer or formationData.serverId or loginServerId, self.ctrl.targetServerId)
  else
    self:HideTroopLine()
  end
  TimerManager:GetInstance():DelayInvoke(function()
    self:RefreshGuideBtn()
  end, 0.2)
end

local function HideAllShowTip(self)
  self.disguiseArmyTip:SetActive(false)
  self.create_army_tip:SetActive(false)
  self.rally_army_tip:SetActive(false)
end

local function SetRLInfo(self)
  local list2 = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
  self.ASubwayPos = LuaEntry.Player:GetMainWorldPos()
  if list2 ~= nil and 0 < #list2 then
    for i = 1, #list2 do
      self.BSubwayPos = list2[i].pointId
      break
    end
  end
  self.formation_army_tip:SetSubwayToUIPos()
end

local function ShowTroopBattleSignal(self, data)
  local str = data
  if str ~= nil then
    local strArr = string.split(str, ";")
    if 3 < #strArr then
      local marchUuid = tonumber(strArr[1])
      local hp = tonumber(strArr[3])
      local hpMax = tonumber(strArr[4])
      if self.formationList ~= nil then
        table.walk(self.formationList, function(k, v)
          v:RefreshSlider(marchUuid, hp, hpMax)
        end)
      end
    end
  end
end

local function ShowFormationCreateTip(self, posX, posY, formationData)
  self.formation_army_tip:SetActive(false)
  self.create_army_tip:SetActive(true)
  self.rally_army_tip:SetActive(false)
  self.disguiseArmyTip:SetActive(false)
  self.create_army_tip:RefreshData(posX, posY, formationData)
  if formationData ~= nil and self.ctrl.targetType >= 0 and self.ctrl.targetType ~= MarchTargetType.BACK_HOME and self.ctrl.targetType ~= MarchTargetType.CROSS_SERVER_WORM then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    self:ShowTroopLine(formationData.startPos, self.ctrl.targetPoint, formationData.marchCurServer or formationData.serverId or loginServerId, self.ctrl.targetServerId)
  else
    self:HideTroopLine()
  end
end

local function ShowFormationRallyTip(self, posX, posY, formationData)
  self.formation_army_tip:SetActive(false)
  self.create_army_tip:SetActive(false)
  self.rally_army_tip:SetActive(true)
  self.disguiseArmyTip:SetActive(false)
  self.rally_army_tip:RefreshData(posX, posY, formationData)
  if formationData ~= nil and self.ctrl.targetType >= 0 and self.ctrl.targetType ~= MarchTargetType.BACK_HOME and self.ctrl.targetType ~= MarchTargetType.CROSS_SERVER_WORM then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    self:ShowTroopLine(formationData.startPos, self.ctrl.targetPoint, formationData.marchCurServer or formationData.serverId or loginServerId, self.ctrl.targetServerId)
  else
    self:HideTroopLine()
  end
end

local function GetTimeInFormation(self, formationUuid, fixedSoldierType, useLightWorkerMan)
  return self.ctrl:GetTimeFormCurPosToTarPos(formationUuid, fixedSoldierType, useLightWorkerMan)
end

local function OnAtkClick(self, uuid)
  if CS.SceneManager:IsInCity() then
    self.ctrl:OnChangeMarchInGuide(uuid)
  else
    self.ctrl:OnAtkClick(uuid)
  end
end

local function OnAttackAlCityBtnClick(self, uuid, timesIndex)
  if CS.SceneManager:IsInCity() then
    self.ctrl:OnChangeMarchInGuide(uuid)
  else
    self.ctrl:OnAtkClick(uuid, timesIndex)
  end
end

local function OnEditClick(self, uuid, needAutoFix, destroyTimeIndex)
  if CS.SceneManager:IsInCity() then
    if self.ctrl.targetType == MarchTargetType.SIMPLE_CITY_EVENT_ATTACK or self.ctrl.targetType == MarchTargetType.SIMPLE_CITY_EVENT_COLLECT then
      self.ctrl:OnEditClick(uuid, needAutoFix, destroyTimeIndex)
    else
      self.ctrl:OnCreateMarchInGuide(uuid, needAutoFix)
    end
  else
    self.ctrl:OnEditClick(uuid, needAutoFix, destroyTimeIndex)
  end
end

local function OnCreateClick(self, uuid, destroyTimeIndex)
  if CS.SceneManager:IsInCity() then
    self.ctrl:OnChangeMarchInGuide(uuid)
  else
    self.ctrl:OnCheckTime(uuid, destroyTimeIndex)
  end
end

local function ShowTroopLine(self, startPos, endPos, fromServer, targetServer)
  if BattleFieldUtil.InBattleField() then
    fromServer = LuaEntry.Player:GetCurServerId()
    startPos = LuaEntry.Player:GetBattleFieldPos()
  end
  if self.troopLine == nil and self.dragInstance == nil then
    self.dragInstance = ResourceManager:InstantiateAsync(CS.GameDefines.EntityAssets.TroopLineDrag)
    self.dragInstance:completed("+", function()
      if self.dragInstance.isError then
        return
      end
      self.dragInstance.gameObject:SetActive(true)
      self.dragInstance.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      self.simpleAnim = self.dragInstance.gameObject:GetComponent(typeof(CS.SimpleAnimation))
      if self.simpleAnim then
        self.simpleAnim:Play("Default")
      end
      self.troopLine = self.dragInstance.gameObject:GetComponent(typeof(CS.WorldTroopLine))
      if self.troopLine ~= nil then
        local troop = CS.SceneManager.World:GetCityTroop()
        if troop ~= nil then
          local pos = CS.GameEntry.Setting:GetPrivateInt(SettingKeys.CITY_TROOP_POSITION, -1)
          if 0 <= pos then
            self.troopLine:SetDragPath(SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World, fromServer), SceneUtils.TileIndexToWorld(endPos, ForceChangeScene.World, targetServer))
          else
            self.troopLine:SetDragPath(SceneUtils.TileIndexToWorld(startPos, ForceChangeScene.World, fromServer), SceneUtils.TileIndexToWorld(endPos, ForceChangeScene.World, targetServer))
          end
        else
          self.troopLine:SetDragPath(SceneUtils.TileIndexToWorld(startPos, ForceChangeScene.World, fromServer), SceneUtils.TileIndexToWorld(endPos, ForceChangeScene.World, targetServer))
        end
      end
    end)
  elseif self.troopLine ~= nil then
    self.troopLine:SetDragPath(SceneUtils.TileIndexToWorld(startPos, ForceChangeScene.World, fromServer), SceneUtils.TileIndexToWorld(endPos, ForceChangeScene.World, targetServer))
  end
end

local function HideTroopLine(self)
  if self.simpleAnim then
    self.simpleAnim:Play("Hide")
    TimerManager:GetInstance():GetTimer(0.5, function()
      if self.dragInstance ~= nil then
        self.dragInstance:Destroy()
        self.dragInstance = nil
      end
    end, self, true, false, false):Start()
  elseif self.dragInstance ~= nil then
    self.dragInstance:Destroy()
    self.dragInstance = nil
  end
  self.troopLine = nil
end

local function OnClickScoutTroopItem(self, tempIndex)
  if self.formationScoutSelectList then
    return self.formationScoutSelectList:OnSelectTroopBtnClick(tempIndex)
  end
end

local function GetScoutTroopUnlockLv(self, formationIndex)
  if self.formationScoutSelectList then
    return self.formationScoutSelectList:GetUnlockLv(formationIndex)
  end
end

local function ResetScoutSelectTipPosition(self, posX, posY)
  if self.formationScoutSelectList then
    return self.formationScoutSelectList:ResetTipPosition(posX, posY)
  end
end

local function GetInvesFormationStateDes(self)
  if self.formationScoutSelectList then
    return self.formationScoutSelectList:GetInvesFormationStateDes()
  end
end

local function GetInvesCostTime(self, targetPointID, targetServerId)
  if self.formationScoutSelectList then
    return self.formationScoutSelectList:GetInvesCostTime(targetPointID, targetServerId)
  end
end

local function OnClickStartInvestigate(self, param)
  if self.formationScoutSelectList then
    return self.formationScoutSelectList:OnClickStartInvestigate(param)
  end
end

local function AddTimer(self)
  local time = 1
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function RefreshFormationStamina(self)
  if self.formationList ~= nil then
    table.walk(self.formationList, function(k, v)
      v:UpdateTime()
    end)
  end
  self.formationStaminaSlider:UpdateStamina()
  if self.formation_army_tip:GetActive() then
    self.formation_army_tip:RefreshStaminaState()
  elseif self.rally_army_tip:GetActive() then
    self.rally_army_tip:RefreshStaminaState()
  elseif self.create_army_tip:GetActive() then
    self.create_army_tip:RefreshStaminaState()
  end
end

local function OnClickGuideSpecialBtn(self)
  self.guideState = self.guideState + 1
  if self.guideState > GuideClickCount then
    DataCenter.GuideManager:DoNext()
  elseif self.guideState == 1 then
    self.formation_army_tip:OnPowerClick()
  elseif self.guideState == 2 then
    self.formation_army_tip:OnCollectAddClick()
  end
end

local function OnRefreshGuideSignal(self)
  self:RefreshGuideBtn()
end

local function RefreshGuideBtn(self)
  local isShow = false
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and template.type == GuideType.CollectUISpecialGuide then
    isShow = true
    self.guideState = 0
    self.formation_army_tip:OnSoliderNumClick()
  end
  self.guide_special_btn:SetActive(isShow)
end

local function GetBuildLv(self)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_WORMHOLE_MAIN)
  if 0 < #list then
    return list[1].level
  end
end

local function AttackSpecialStateFlagSignal(self, flag)
  if flag ~= nil then
    flag = tonumber(flag)
    if flag == SetAttackGuideFlag.NoBackAndWaitResult then
      self.ctrl.autoBackHome = MarchAutoBackType.NoBack
      self.ctrl.directionWaitResult = true
    elseif flag == SetAttackGuideFlag.WaitResult then
      self.ctrl.directionWaitResult = true
    end
  end
end

local function HideFormationArmyTip(self)
  if self.formation_army_tip then
    self.formation_army_tip:SetActive(false)
  end
end

UIFormationSelectListNewView.HideFormationArmyTip = HideFormationArmyTip
UIFormationSelectListNewView.OnCreate = OnCreate
UIFormationSelectListNewView.OnDestroy = OnDestroy
UIFormationSelectListNewView.OnRefresh = OnRefresh
UIFormationSelectListNewView.OnEnable = OnEnable
UIFormationSelectListNewView.OnDisable = OnDisable
UIFormationSelectListNewView.OnAddListener = OnAddListener
UIFormationSelectListNewView.OnRemoveListener = OnRemoveListener
UIFormationSelectListNewView.OnMarchRefresh = OnMarchRefresh
UIFormationSelectListNewView.ShowFormationArmyTip = ShowFormationArmyTip
UIFormationSelectListNewView.ShowDisguiseArmyTip = ShowDisguiseArmyTip
UIFormationSelectListNewView.ShowFormationRallyTip = ShowFormationRallyTip
UIFormationSelectListNewView.ShowFormationCreateTip = ShowFormationCreateTip
UIFormationSelectListNewView.ClearContent = ClearContent
UIFormationSelectListNewView.GetTimeInFormation = GetTimeInFormation
UIFormationSelectListNewView.OnAtkClick = OnAtkClick
UIFormationSelectListNewView.UpdateCollectPos = UpdateCollectPos
UIFormationSelectListNewView.OnEditClick = OnEditClick
UIFormationSelectListNewView.OnCreateClick = OnCreateClick
UIFormationSelectListNewView.ShowTroopLine = ShowTroopLine
UIFormationSelectListNewView.HideTroopLine = HideTroopLine
UIFormationSelectListNewView.OnSelectClick = OnSelectClick
UIFormationSelectListNewView.ShowTroopBattleSignal = ShowTroopBattleSignal
UIFormationSelectListNewView.HideAllShowTip = HideAllShowTip
UIFormationSelectListNewView.SetRLInfo = SetRLInfo
UIFormationSelectListNewView.OnClickScoutTroopItem = OnClickScoutTroopItem
UIFormationSelectListNewView.GetScoutTroopUnlockLv = GetScoutTroopUnlockLv
UIFormationSelectListNewView.ResetScoutSelectTipPosition = ResetScoutSelectTipPosition
UIFormationSelectListNewView.GetInvesFormationStateDes = GetInvesFormationStateDes
UIFormationSelectListNewView.GetInvesCostTime = GetInvesCostTime
UIFormationSelectListNewView.OnClickStartInvestigate = OnClickStartInvestigate
UIFormationSelectListNewView.OnClickExchangeBtn = OnClickExchangeBtn
UIFormationSelectListNewView.RefreshTroopInfo = RefreshTroopInfo
UIFormationSelectListNewView.AddTimer = AddTimer
UIFormationSelectListNewView.DeleteTimer = DeleteTimer
UIFormationSelectListNewView.RefreshFormationStamina = RefreshFormationStamina
UIFormationSelectListNewView.OnClickGuideSpecialBtn = OnClickGuideSpecialBtn
UIFormationSelectListNewView.RefreshGuideBtn = RefreshGuideBtn
UIFormationSelectListNewView.OnRefreshGuideSignal = OnRefreshGuideSignal
UIFormationSelectListNewView.GetBuildLv = GetBuildLv
UIFormationSelectListNewView.AttackSpecialStateFlagSignal = AttackSpecialStateFlagSignal
UIFormationSelectListNewView.OnAttackAlCityBtnClick = OnAttackAlCityBtnClick
UIFormationSelectListNewView.RefreshCost = RefreshCost
return UIFormationSelectListNewView
