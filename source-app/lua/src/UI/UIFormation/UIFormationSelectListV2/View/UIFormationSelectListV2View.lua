local FormationArmyTipNew = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationArmyTipNewV2")
local FormationSelectListCellNew = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationSelectListCellNewV2")
local FormationStaminaSlider = require("UI.UIFormation.UIFormationSelectListV2.Component.FormationStaminaSliderV2")
local UIFormationSelectListV2View = BaseClass("UIFormationSelectListV2View", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local area_root_path = "Area"
local content_path = "Area/bg/layout"
local formation_army_tip_path = "Area/FormationArmyTips"
local formationCampSelectList_path = "Area/bg"
local exchangeBtn_path = "Area/exchangeBtn"
local guide_special_btn_path = "GuideSpecialBtn"
local formationStaminaSlider_path = "Area/bg/sliderBg"
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
  self.area_root = self:AddComponent(UIBaseContainer, area_root_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.formationCampSelectList = self:AddComponent(UIBaseContainer, formationCampSelectList_path)
  self.formation_army_tip = self:AddComponent(FormationArmyTipNew, formation_army_tip_path)
  self.formation_army_tip:SetActive(false)
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
  self.formationList = {}
  self.FormationTimeList = {}
  self.FormationPowerList = {}
  self.troopLine = nil
  self.dragInstance = nil
  self.guideState = 0
end

local function OnDestroy(self)
  if self.disguiseArmyTip then
    self.disguiseArmyTip:Delete()
    self.disguiseArmyTip = nil
  end
  if self.wormHoleTips then
    self.wormHoleTips:Delete()
    self.wormHoleTips = nil
  end
  if self.rally_army_tip then
    self.rally_army_tip:Delete()
    self.rally_army_tip = nil
  end
  if self.create_army_tip then
    self.create_army_tip:Delete()
    self.create_army_tip = nil
  end
  if self.formationScoutSelectList then
    self.formationScoutSelectList:Delete()
    self.formationScoutSelectList = nil
  end
  self.area_root = nil
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

function UIFormationSelectListV2View:SetEditingIndex(index)
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
  local wormHoleTipsMsg
  if self.ctrl.targetType == MarchTargetType.BUILD_WORM_HOLE then
    wormHoleTipsMsg = Localization:GetString("143581")
  elseif self.ctrl.targetType == MarchTargetType.CROSS_SERVER_WORM then
    wormHoleTipsMsg = Localization:GetString("104277", self.ctrl.targetServerId)
  elseif self.ctrl.targetType == MarchTargetType.BACK_HOME and CrossServerUtil:GetIsCrossServer() then
    wormHoleTipsMsg = Localization:GetString("104277", self.ctrl.targetServerId)
  end
  if wormHoleTipsMsg ~= nil and wormHoleTipsMsg ~= "" then
    if self.wormHoleTips == nil then
      self.wormHoleTips = UIAsyncLoaderBridge.New(self, "wormHoleTips", self.area_root.transform, "Assets/Main/Prefabs/UI/UIFormation/V2/Img_WormHole.prefab", "UI.UIFormation.UIFormationSelectListV2.Component.WormHoleTipsV2", false)
    end
    if self.wormHoleTips ~= nil then
      self.wormHoleTips:SetActive(true)
      self.wormHoleTips:RefreshData(wormHoleTipsMsg)
    end
  elseif self.wormHoleTips ~= nil then
    self.wormHoleTips:SetActive(false)
  end
  if self.ctrl.targetType == MarchTargetType.SIMPLE_CITY_EVENT_ATTACK or self.ctrl.targetType == MarchTargetType.SIMPLE_CITY_EVENT_COLLECT then
  end
  if self.curFormationType == 1 then
    self.formationCampSelectList:SetActive(true)
    if self.formationScoutSelectList ~= nil then
      self.formationScoutSelectList:SetActive(false)
    end
    self:ClearContent()
    local createNum = 0
    local data = self.ctrl:GetFormationListData()
    local serverId = LuaEntry.Player:GetCurServerId()
    if self.ctrl.targetType == MarchTargetType.CROSS_SERVER_WORM then
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
    if self.formationScoutSelectList == nil then
      self.formationScoutSelectList = UIAsyncLoaderBridge.New(self, "formationScoutSelectList", self.area_root.transform, "Assets/Main/Prefabs/UI/UIFormation/V2/ScoutBgV2.prefab", "UI.UIFormation.UIFormationSelectListV2.Component.FormationScoutSelectListV2", false)
    end
    if self.formationScoutSelectList ~= nil then
      self.formationScoutSelectList:SetActive(true)
      self.formationScoutSelectList:InitUI()
    end
  end
  if self.ctrl.targetPoint and self.ctrl.targetPoint > 0 then
    self.exchangeBtn:SetActive(false)
  else
    self.exchangeBtn:SetActive(true)
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

local function SecondsToHMS(seconds)
  local h = math.floor(seconds / 3600)
  local m = math.floor(seconds % 3600 / 60)
  local s = math.floor(seconds % 60)
  return string.format("%02d:%02d:%02d", h, m, s)
end

local function DebugPrintMarchTime(self, formationData)
  if GMUtils and GMUtils.GetBool and GMUtils.GetBool(GMConst.DebugClickLogWarning, false) then
    local uuid = formationData.uuid
    local fixedSoldierType = formationData.fixedSoldierType or SoldierType.Player
    local useLightWorkerMan = LuaEntry.GlobalData.UseLightWorkerMan == 1
    local debugInfo = self.ctrl:GetMarchTimeDebugInfo(uuid, fixedSoldierType, useLightWorkerMan)
    if debugInfo then
      local time = self:GetTimeInFormation(uuid, fixedSoldierType, useLightWorkerMan)
      local displayTime = time * 1000
      local hmsTime = SecondsToHMS(time)
      local logMsg = string.format("[\232\161\140\229\134\155\230\151\182\233\151\180\232\176\131\232\175\149] ====================\n\230\152\190\231\164\186\230\151\182\233\151\180: %.2f\231\167\146 (%s) (%.0f\230\175\171\231\167\146)\n===================\n\227\128\144\232\183\157\231\166\187\232\174\161\231\174\151\227\128\145\n\230\128\187\232\183\157\231\166\187: %.2f\n\231\153\189\229\156\159\229\156\176\232\183\157\231\166\187: %.2f\n\233\187\145\229\156\159\229\156\176\232\183\157\231\166\187: %.2f\n\n\227\128\144\233\128\159\229\186\166\232\174\161\231\174\151\227\128\145\n\229\159\186\231\161\128\233\128\159\229\186\166: %.4f (\230\160\188/\231\167\146)\n\229\138\160\230\136\144\231\179\187\230\149\176: %.4f (%s)\n\230\156\128\231\187\136\233\128\159\229\186\166: %.4f = %.4f \195\151 (1 + %.4f)", displayTime / 1000, hmsTime, displayTime, debugInfo.distance, debugInfo.whiteDistance, debugInfo.blackDistance, debugInfo.baseSpeed, debugInfo.addRatio or 0, debugInfo.addEffect or "\230\151\160", debugInfo.whiteSpeed, debugInfo.baseSpeed, debugInfo.addRatio or 0)
      if debugInfo.winterAdd and debugInfo.winterAdd ~= 0 then
        logMsg = logMsg .. string.format("\n\229\134\172\230\151\165\229\138\160\230\136\144: +%.4f", debugInfo.winterAdd)
      end
      if debugInfo.isBlackLand then
        local blackSpeedRatio = 0.5
        logMsg = logMsg .. string.format("\n\n\227\128\144\233\187\145\229\156\159\229\156\176\233\128\159\229\186\166\227\128\145\n\233\187\145\229\156\159\229\156\176\233\128\159\229\186\166: %.4f = %.4f \195\151 %.2f (\233\187\145\229\156\159\229\156\176\231\179\187\230\149\176)", debugInfo.blackSpeed, debugInfo.whiteSpeed, blackSpeedRatio)
        logMsg = logMsg .. string.format("\n\n\227\128\144\230\151\182\233\151\180\232\174\161\231\174\151\227\128\145\n\231\153\189\229\156\159\229\156\176\230\151\182\233\151\180: %.2f = %.2f / %.4f\n\233\187\145\229\156\159\229\156\176\230\151\182\233\151\180: %.2f = %.2f / %.4f\n\230\128\187\230\151\182\233\151\180: %.2f\231\167\146", debugInfo.whiteTime, debugInfo.whiteDistance, debugInfo.whiteSpeed, debugInfo.blackTime, debugInfo.blackDistance, debugInfo.blackSpeed, debugInfo.totalTime)
      else
        logMsg = logMsg .. string.format("\n\n\227\128\144\230\151\182\233\151\180\232\174\161\231\174\151\227\128\145\n\231\153\189\229\156\159\229\156\176\230\151\182\233\151\180: %.2f = %.2f / %.4f\n\230\128\187\230\151\182\233\151\180: %.2f\231\167\146 (\230\151\160\233\187\145\229\156\159\229\156\176)", debugInfo.whiteTime, debugInfo.whiteDistance, debugInfo.whiteSpeed, debugInfo.totalTime)
      end
      UIUtil.ShowTips("[Editor]\229\183\178\230\137\147\229\141\176\232\161\140\229\134\155\230\151\182\233\151\180\232\174\161\231\174\151\232\191\135\231\168\139")
      Logger.LogCustom(logMsg)
    end
  end
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
  if self.create_army_tip then
    self.create_army_tip:SetActive(false)
  end
  if self.rally_army_tip then
    self.rally_army_tip:SetActive(false)
  end
  if self.disguiseArmyTip then
    self.disguiseArmyTip:SetActive(false)
  end
  self.curMarchIndex = formationData.index
  self.formation_army_tip:RefreshData(posX, posY, formationData)
  self:DebugPrintMarchTime(formationData)
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
  if self.create_army_tip then
    self.create_army_tip:SetActive(false)
  end
  if self.rally_army_tip then
    self.rally_army_tip:SetActive(false)
  end
  if self.disguiseArmyTip == nil then
    self.disguiseArmyTip = UIAsyncLoaderBridge.New(self, "disguiseArmyTip", self.area_root.transform, "Assets/Main/Prefabs/UI/UIFormation/V2/DisguiseArmyTipV2.prefab", "UI.UIFormation.UIFormationSelectListV2.Component.DisguiseArmyTipV2", false)
  end
  if self.disguiseArmyTip ~= nil then
    self.disguiseArmyTip:SetActive(true)
    self.disguiseArmyTip:RefreshData(posX, posY, formationData, isMarch)
  end
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
  if self.disguiseArmyTip then
    self.disguiseArmyTip:SetActive(false)
  end
  if self.create_army_tip then
    self.create_army_tip:SetActive(false)
  end
  if self.rally_army_tip then
    self.rally_army_tip:SetActive(false)
  end
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
  if self.rally_army_tip then
    self.rally_army_tip:SetActive(false)
  end
  if self.disguiseArmyTip then
    self.disguiseArmyTip:SetActive(false)
  end
  if self.create_army_tip == nil then
    self.create_army_tip = UIAsyncLoaderBridge.New(self, "create_army_tip", self.area_root.transform, "Assets/Main/Prefabs/UI/UIFormation/V2/CreateArmyTipV2.prefab", "UI.UIFormation.UIFormationSelectListV2.Component.FormationCreateTipNewV2", false)
  end
  if self.create_army_tip then
    self.create_army_tip:SetActive(true)
    self.create_army_tip:RefreshData(posX, posY, formationData)
  end
  if formationData ~= nil and self.ctrl.targetType >= 0 and self.ctrl.targetType ~= MarchTargetType.BACK_HOME and self.ctrl.targetType ~= MarchTargetType.CROSS_SERVER_WORM then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    self:ShowTroopLine(formationData.startPos, self.ctrl.targetPoint, formationData.marchCurServer or formationData.serverId or loginServerId, self.ctrl.targetServerId)
  else
    self:HideTroopLine()
  end
end

local function ShowFormationRallyTip(self, posX, posY, formationData)
  self.formation_army_tip:SetActive(false)
  if self.create_army_tip then
    self.create_army_tip:SetActive(false)
  end
  if self.disguiseArmyTip then
    self.disguiseArmyTip:SetActive(false)
  end
  if self.rally_army_tip == nil then
    self.rally_army_tip = UIAsyncLoaderBridge.New(self, "rally_army_tip", self.area_root.transform, "Assets/Main/Prefabs/UI/UIFormation/V2/RallyArmyTipV2.prefab", "UI.UIFormation.UIFormationSelectListV2.Component.FormationRallyTipNewV2", false)
  end
  if self.rally_army_tip ~= nil then
    self.rally_army_tip:SetActive(true)
    self.rally_army_tip:RefreshData(posX, posY, formationData)
  end
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
  elseif self.rally_army_tip and self.rally_army_tip:GetActive() then
    self.rally_army_tip:RefreshStaminaState()
  elseif self.create_army_tip and self.create_army_tip:GetActive() then
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

UIFormationSelectListV2View.HideFormationArmyTip = HideFormationArmyTip
UIFormationSelectListV2View.OnCreate = OnCreate
UIFormationSelectListV2View.OnDestroy = OnDestroy
UIFormationSelectListV2View.OnRefresh = OnRefresh
UIFormationSelectListV2View.OnEnable = OnEnable
UIFormationSelectListV2View.OnDisable = OnDisable
UIFormationSelectListV2View.OnAddListener = OnAddListener
UIFormationSelectListV2View.OnRemoveListener = OnRemoveListener
UIFormationSelectListV2View.OnMarchRefresh = OnMarchRefresh
UIFormationSelectListV2View.ShowFormationArmyTip = ShowFormationArmyTip
UIFormationSelectListV2View.ShowDisguiseArmyTip = ShowDisguiseArmyTip
UIFormationSelectListV2View.ShowFormationRallyTip = ShowFormationRallyTip
UIFormationSelectListV2View.ShowFormationCreateTip = ShowFormationCreateTip
UIFormationSelectListV2View.ClearContent = ClearContent
UIFormationSelectListV2View.GetTimeInFormation = GetTimeInFormation
UIFormationSelectListV2View.OnAtkClick = OnAtkClick
UIFormationSelectListV2View.UpdateCollectPos = UpdateCollectPos
UIFormationSelectListV2View.OnEditClick = OnEditClick
UIFormationSelectListV2View.OnCreateClick = OnCreateClick
UIFormationSelectListV2View.ShowTroopLine = ShowTroopLine
UIFormationSelectListV2View.HideTroopLine = HideTroopLine
UIFormationSelectListV2View.OnSelectClick = OnSelectClick
UIFormationSelectListV2View.ShowTroopBattleSignal = ShowTroopBattleSignal
UIFormationSelectListV2View.HideAllShowTip = HideAllShowTip
UIFormationSelectListV2View.OnClickScoutTroopItem = OnClickScoutTroopItem
UIFormationSelectListV2View.GetScoutTroopUnlockLv = GetScoutTroopUnlockLv
UIFormationSelectListV2View.ResetScoutSelectTipPosition = ResetScoutSelectTipPosition
UIFormationSelectListV2View.GetInvesFormationStateDes = GetInvesFormationStateDes
UIFormationSelectListV2View.GetInvesCostTime = GetInvesCostTime
UIFormationSelectListV2View.OnClickStartInvestigate = OnClickStartInvestigate
UIFormationSelectListV2View.OnClickExchangeBtn = OnClickExchangeBtn
UIFormationSelectListV2View.AddTimer = AddTimer
UIFormationSelectListV2View.DeleteTimer = DeleteTimer
UIFormationSelectListV2View.RefreshFormationStamina = RefreshFormationStamina
UIFormationSelectListV2View.OnClickGuideSpecialBtn = OnClickGuideSpecialBtn
UIFormationSelectListV2View.RefreshGuideBtn = RefreshGuideBtn
UIFormationSelectListV2View.OnRefreshGuideSignal = OnRefreshGuideSignal
UIFormationSelectListV2View.AttackSpecialStateFlagSignal = AttackSpecialStateFlagSignal
UIFormationSelectListV2View.OnAttackAlCityBtnClick = OnAttackAlCityBtnClick
UIFormationSelectListV2View.RefreshCost = RefreshCost
UIFormationSelectListV2View.DebugPrintMarchTime = DebugPrintMarchTime
return UIFormationSelectListV2View
