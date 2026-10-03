local UISkirmishMainView = BaseClass("UISkirmishMainView", UIBaseView)
local base = UIBaseView
local SkirmishHeroCell = require("UI.UISkirmish.Main.Component.SkirmishHeroCell")
local skirmishWeaponCell = require("UI.UISkirmish.Main.Component.SkirmishWeaponCell")
local TacticalWeaponSkillNodeComponent = require("UI.UIParkour.MainUI.Component.TacticalWeaponSkillNodeComponent")
local UICommonSoldierVertical = require("UI/UICommon/Component/UICommonSoldierVertical")
local SkirmishDominatorCell = require("UI.UISkirmish.Main.Component.SkirmishDominatorCell")
local UISkirmishMainDebugNode = require("UI.UISkirmish.Main.Component.UISkirmishMainDebugNode")
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local UIParkourHeroAwakenSkillComponent = require("UI/UIParkour/MainUI/Component/UIParkourHeroAwakenSkillComponent")
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen

function UISkirmishMainView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:InitView()
  self:PlayShowSound()
end

function UISkirmishMainView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISkirmishMainView:DataDefine()
  self.logic = DataCenter.LWBattleManager:GetCurBattleLogic()
end

function UISkirmishMainView:DataDestroy()
  self.logic = nil
end

function UISkirmishMainView:ComponentDefine()
  if not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
  self.delayEvents = {}
  self.back_btn = self:AddComponent(UIButton, "SafeArea/BackBtn")
  self.back_btn:SetActive(true)
  self.back_btn:SetOnClick(function()
    self:OnBtnHome()
  end)
  self.head1VS = self:AddComponent(UICommonHead, "Opening/Player1VS/Head1VS")
  self.head2VS = self:AddComponent(UICommonHead, "Opening/Player2VS/Head2VS")
  self.name1VS = self:AddComponent(UIText, "Opening/Player1VS/Name1VS")
  self.name2VS = self:AddComponent(UIText, "Opening/Player2VS/Name2VS")
  self.power1VS = self:AddComponent(UIText, "Opening/Player1VS/Power1VS")
  self.power2VS = self:AddComponent(UIText, "Opening/Player2VS/Power2VS")
  self.level1VS = self:AddComponent(UIText, "Opening/Player1VS/Level1VS")
  self.level2VS = self:AddComponent(UIText, "Opening/Player2VS/Level2VS")
  self.soldier1ScrollView = self:AddComponent(UIScrollView, "Opening/Player1VS/SoldierList1VS")
  self.soldier1ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateSoldier1ScrollCell(itemObj, index)
  end)
  self.soldier1ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteSoldier1ScrollCell(itemObj, index)
  end)
  self.soldier2ScrollView = self:AddComponent(UIScrollView, "Opening/Player2VS/SoldierList2VS")
  self.soldier2ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateSoldier2ScrollCell(itemObj, index)
  end)
  self.soldier2ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteSoldier2ScrollCell(itemObj, index)
  end)
  self.timeTxt = self:AddComponent(UIText, "SafeArea/Time")
  if self.logic.battleData then
    self.timeCount = self.logic.battleData.fightDuration
    self.timeTxt:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(self.timeCount))
  end
  self.opening = self:AddComponent(UIText, "Opening")
  self.opening:SetActive(true)
  self:AddDelayEvent(function()
    self.opening:SetActive(false)
  end, 2)
  self.heroCell = {}
  for i = 1, 5 do
    self.heroCell[i] = self:AddComponent(SkirmishHeroCell, string.format("SafeArea/HeroHead/SkirmishHeroCell%s", i))
    self.heroCell[i]:InitData(i)
  end
  self.weaponCell = self:AddComponent(skirmishWeaponCell, "SafeArea/TacticalWeapon")
  self.weaponCell:InitData(11)
  self.tacticalWeaponSkillNodeComponent = self:AddComponent(TacticalWeaponSkillNodeComponent, "SafeArea/TacticalWeaponSkillNode", true)
  self.tacticalWeaponSkillNodeComponent:SetActive(true)
  self.domiantorSlot = self:AddComponent(UIBaseContainer, "SafeArea/dominatorSlot")
  self.pauseBg = self:AddComponent(UIImage, "PauseCover/PauseBg")
  self.pauseBgCanvasGroup = self:AddComponent(UICanvasGroup, "PauseCover")
  self.heroAwakenSkillRoot = self:AddComponent(UIBaseContainer, "SafeArea/HeroAwakenSkillRoot")
  if CommonUtil.IsDebug() then
    self.debugReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/Skirmish/UISkirmishMainDebugNode.prefab", function(req)
      local name = "UISkirmishMainDebugNode"
      local go = req.gameObject
      go.transform.name = name
      go.transform.parent = self.transform:Find("SafeArea")
      go.transform.localPosition = Vector3.zero
      go.transform.localScale = Vector3.one
      self.debugNode = self:AddComponent(UISkirmishMainDebugNode, "SafeArea/" .. name)
      self.debugNode:SetAnchorMinXY(0, 0)
      self.debugNode:SetAnchorMaxXY(1, 1)
      self.debugNode:SetOffsetMinXY(0, 0)
      self.debugNode:SetOffsetMaxXY(0, 0)
    end)
  end
end

function UISkirmishMainView:ComponentDestroy()
  if self.dominatorCell then
    self.domiantorSlot:RemoveComponent(self.dominatorCell:GetName(), SkirmishDominatorCell)
  end
  if self.dominatorCellReq then
    self:GameObjectDestroy(self.dominatorCellReq)
  end
  self.dominatorCell = nil
  self.dominatorCellReq = nil
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  self.back_btn = nil
  for _, v in pairs(self.delayEvents) do
    v:Stop()
  end
  self.delayEvents = nil
  self.skillBubble = nil
  self.skillImg = nil
  self.skillIcon = nil
  self.heroCell = nil
  self.weaponCell = nil
  self.pauseBg = nil
  self.pauseBgCanvasGroup = nil
  self.heroAwakenSkillRoot = nil
  if self.indexGO then
    self.indexGO:GameObjectRecycleAll()
    self.indexGO = nil
  end
end

function UISkirmishMainView:OnBtnHome()
  self.ctrl:CloseSelf()
  local isDetect = self:IsDetectBattle()
  if not isDetect then
    PostEventLog.QuitReplayLog(0)
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():JumpToEnd()
end

function UISkirmishMainView:IsDetectBattle()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local isDetect = false
  if logic.param.enterType == PVEEnterType.Radar or logic.param.enterType == PVEEnterType.TowerupJeepAdventure then
    isDetect = true
  end
  return isDetect
end

function UISkirmishMainView:OnEnable()
  base.OnEnable(self)
end

local DOMINATOR_CELL_PATH = "Assets/Main/Prefabs/UI/Skirmish/SkirmishDominatorCell.prefab"

function UISkirmishMainView:InitView()
  if not self.logic.battleData then
    return
  end
  local data = self.logic.battleData.extData
  local player1 = data.player[1]
  local player2 = data.player[2]
  if MailBattleParseHelper.IsWerewolf(player1) then
    self.head1VS:ShowWerewolf()
    self.name1VS:SetLocalText(GameDialogDefine.WEREWOLF)
  else
    self.head1VS:ParseHeadInfo(player1)
    self.name1VS:SetText(player1.name)
  end
  if MailBattleParseHelper.IsWerewolf(player2) then
    self.head2VS:ShowWerewolf()
    self.name2VS:SetLocalText(GameDialogDefine.WEREWOLF)
  else
    self.head2VS:ParseHeadInfo(player2)
    self.name2VS:SetText(player2.name)
  end
  self.level1VS:SetText(player1.level)
  self.level2VS:SetText(player2.level)
  self.power1VS:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(player1.totalHeroPower))
  self.power2VS:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(player2.totalHeroPower))
  if not table.IsNullOrEmpty(player1.soldierBeforeStart) then
    self.soldier1ScrollView:SetActive(true)
    self.soldier1ScrollView:ClearCells()
    self.soldier1ScrollView:RemoveComponents(UICommonSoldierVertical)
    self.soldier1ScrollView:SetTotalCount(table.count(player1.soldierBeforeStart))
    self.soldier1ScrollView:RefillCells()
  else
    self.soldier1ScrollView:SetActive(false)
  end
  if not table.IsNullOrEmpty(player2.soldierBeforeStart) then
    self.soldier2ScrollView:SetActive(true)
    self.soldier2ScrollView:ClearCells()
    self.soldier2ScrollView:RemoveComponents(UICommonSoldierVertical)
    self.soldier2ScrollView:SetTotalCount(table.count(player2.soldierBeforeStart))
    self.soldier2ScrollView:RefillCells()
  else
    self.soldier2ScrollView:SetActive(false)
  end
  local dominator = self.logic:GetCaptain(PVPBattleSlot.SelfDominator)
  if dominator then
    self.dominatorReq = self:GameObjectInstantiateAsync(DOMINATOR_CELL_PATH, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local transform = obj.transform
      transform:SetParent(self.domiantorSlot.transform)
      transform:Set_localScale(1, 1, 1)
      self.dominatorCell = self.domiantorSlot:AddComponent(SkirmishDominatorCell, obj)
      self.dominatorCell:InitData(PVPBattleSlot.SelfDominator)
      self.dominatorCell:SetAnchoredPositionXY(0, 0)
    end)
  end
  self.back_btn:SetActive(self.ctrl:IsShowBackBtn())
  self.pauseBg:SetActive(false)
end

function UISkirmishMainView:OnCreateSoldier1ScrollCell(itemObj, index)
  itemObj.name = tostring(index)
  if self.logic ~= nil then
    local data = self.logic.battleData.extData.player[1].soldierBeforeStart
    if not table.IsNullOrEmpty(data) and data[index] ~= nil then
      local cellItem = self.soldier1ScrollView:AddComponent(UICommonSoldierVertical, itemObj)
      local soldierData = {}
      soldierData.id = data[index].soldierId
      soldierData.count = data[index].total
      local soldierEleven = self.logic.battleData.extData.player[1].soldierEleven
      if soldierEleven and not table.IsNullOrEmpty(soldierEleven) then
        local elevenData
        elevenData = {}
        elevenData.stage = soldierEleven.stage
        elevenData.type = T11Util.GetSoldierTypeByEffectList(soldierEleven.effects)
        soldierData.t11Data = elevenData
      end
      cellItem:SetData(soldierData)
    end
  end
end

function UISkirmishMainView:OnDeleteSoldier1ScrollCell(itemObj, index)
  self.soldier1ScrollView:RemoveComponent(itemObj.name, UICommonSoldierVertical)
end

function UISkirmishMainView:OnCreateSoldier2ScrollCell(itemObj, index)
  itemObj.name = tostring(index)
  if self.logic ~= nil then
    local data = self.logic.battleData.extData.player[2].soldierBeforeStart
    if not table.IsNullOrEmpty(data) and data[index] ~= nil then
      local cellItem = self.soldier2ScrollView:AddComponent(UICommonSoldierVertical, itemObj)
      local soldierData = {}
      soldierData.id = data[index].soldierId
      soldierData.count = data[index].total
      local soldierEleven = self.logic.battleData.extData.player[2].soldierEleven
      if soldierEleven and not table.IsNullOrEmpty(soldierEleven) then
        local elevenData = {}
        elevenData.stage = soldierEleven.stage
        elevenData.type = T11Util.GetSoldierTypeByEffectList(soldierEleven.effects)
        soldierData.t11Data = elevenData
      end
      cellItem:SetData(soldierData)
    end
  end
end

function UISkirmishMainView:OnDeleteSoldier2ScrollCell(itemObj, index)
  self.soldier2ScrollView:RemoveComponent(itemObj.name, UICommonSoldierVertical)
end

function UISkirmishMainView:OnUpdate()
end

function UISkirmishMainView:OnUpdateSec()
  if self.timeCount > 0 then
    self.timeTxt:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(self.timeCount))
    self.timeCount = self.timeCount - 1
  elseif self.timeCount <= 0 then
    self.timeTxt:SetText("00:00:00")
  end
end

function UISkirmishMainView:AddDelayEvent(event, delay)
  assert(event, "event invalid")
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function UISkirmishMainView:HideReturn()
  self.back_btn:SetActive(false)
end

function UISkirmishMainView:OnSkirmishTacticalWeaponLoadDone()
  if self.weaponCell then
    self.weaponCell:InitData(11)
  end
end

function UISkirmishMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkirmishTacticalWeaponLoadDone, self.OnSkirmishTacticalWeaponLoadDone)
  self:AddUIListener(EventId.SkirmishCastHeroAwakenSkill, self.OnSkirmishCastHeroAwakenSkill)
end

function UISkirmishMainView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SkirmishTacticalWeaponLoadDone, self.OnSkirmishTacticalWeaponLoadDone)
  self:RemoveUIListener(EventId.SkirmishCastHeroAwakenSkill, self.OnSkirmishCastHeroAwakenSkill)
end

function UISkirmishMainView:PlayShowSound()
  local curEnterType = DataCenter.LWBattleManager:GetPVEEnterType()
  if curEnterType == PVEEnterType.Radar then
    DataCenter.LWSoundManager:PlaySound(62268, false)
  end
end

function UISkirmishMainView:SetPauseBgActive(isActive)
  if self.pauseBg then
    self.pauseBg:SetActive(isActive)
  end
end

function UISkirmishMainView:OnSkirmishCastHeroAwakenSkill(captain)
  if captain == nil then
    return
  end
  local isSelfHero = captain.index <= PVPBattleSlot.SelfHero5
  if not isSelfHero then
    return
  end
  local worldPos = captain:GetPosition()
  local screenPos = CS.UnityEngine.Camera.main:WorldToScreenPoint(worldPos)
  local x = screenPos.x / Screen.width
  local y = screenPos.y / Screen.height
  local maskPX = 1.0 - (x - 0.5) * Screen.width * 0.001
  local maskPY = 1.0 - (y - 0.5) * Screen.height * 0.001
  if self.pauseBgMaterial == nil then
    self.pauseBgMaterial = self.pauseBg:GetMaterial()
  end
  if IsNotNull(self.pauseBgMaterial) then
    self.pauseBgMaterial:SetFloat("_MaskPX", maskPX)
    self.pauseBgMaterial:SetFloat("_MaskPY", maskPY)
  end
  local tween = CS.DG.Tweening.DOTween.Sequence()
  tween:AppendCallback(function()
    self.pauseBg:SetActive(true)
    self.pauseBgCanvasGroup:SetAlpha(1)
    self.pauseBgMaterial:SetFloat("_MaskSize", 20)
  end)
  tween:Append(CS.DG.Tweening.DOTween.To(function(value)
    self.pauseBgMaterial:SetFloat("_MaskSize", value)
  end, 20, 1, 0.2))
  tween:AppendInterval(0.7)
  tween:Append(self.pauseBgCanvasGroup.unity_canvas_group:DOFade(0, 0.1))
  tween:AppendCallback(function()
    self.pauseBg:SetActive(false)
  end)
  local skillInfo
  local heroInfo = captain.hero
  local skill = captain:GetHeroAwakenSkill()
  if skill then
    skillInfo = skill.skillInfo
  end
  if heroInfo == nil or skillInfo == nil then
  elseif self.heroAwakenSkill == nil then
    if self.heroAwakenSkillReq == nil then
      self.heroAwakenSkillReq = self:GameObjectInstantiateAsync(UIAssets.HeroAwakenParkourSkill, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.heroAwakenSkillRoot.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(0, 0, 0)
        self.heroAwakenSkill = self:AddComponent(UIParkourHeroAwakenSkillComponent, go)
        self.heroAwakenSkill:ReInit(skillInfo, heroInfo)
      end)
    end
  else
    self.heroAwakenSkill:ReInit(skillInfo, heroInfo)
  end
end

return UISkirmishMainView
