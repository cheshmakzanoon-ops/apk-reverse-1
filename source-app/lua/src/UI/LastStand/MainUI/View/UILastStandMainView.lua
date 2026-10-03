local UIMainResourceProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainResourceProgress")
local ParkourJoystick = require("UI.UIParkour.MainUI.Component.ParkourJoystick")
local UILastStandMainView = BaseClass("UILastStandMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MonsterIndicator = require("UI.LastStand.MainUI.Component.UILastStandMonsterIndicator")
local ResourceArray = {
  ResourceType.Wood,
  ResourceType.Metal,
  ResourceType.Food,
  ResourceType.Gold
}

function UILastStandMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitRes()
  self:InitRoundInfo()
  if self:GetUserData().onOpen then
    self:GetUserData().onOpen()
  end
end

function UILastStandMainView:OnDestroy()
  self:ComponentDestroy()
  self.nextCountDownTime = nil
  base.OnDestroy(self)
end

function UILastStandMainView:ComponentDefine()
  self.safeArea = self:AddComponent(UIBaseContainer, "SafeArea")
  self.joystick = self:AddComponent(ParkourJoystick, "SafeArea/Joystick")
  self.joystick:SetActive(true)
  self.joystick:ReInit()
  DataCenter.LWBattleManager.logic:SetJoystick(self.joystick)
  self.back_btn = self:AddComponent(UIButton, "SafeArea/BackBtn")
  self.back_btn:SetActive(true)
  self.back_btn:SetOnClick(function()
    self:OnExitBtnClick()
  end)
  self.resContent = self:AddComponent(UIBaseContainer, "SafeArea/ResNode")
  self.resContent:SetActive(true)
  self.resPrefab = self.transform:Find("SafeArea/ResNode/UIMainTopResourceCell").gameObject
  self.resPrefab:GameObjectCreatePool()
  self.resPrefab:SetActive(false)
  self.resCells = {}
  self.countDownTrans = self:AddComponent(UIBaseContainer, "SafeArea/countDown")
  self.textCountDown = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/countDown/bgImg/text")
  self.textCurRound = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/roundInfo/textCurRound")
  self.textMaxRound = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/roundInfo/textMaxRound")
  self.textCurKillMonster = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/killMonsterInfo/killNum")
  self.textMaxMonster = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/killMonsterInfo/maxNum")
  self.textGuide = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/textGuide")
  self:HideGuideText()
  self.indicator = self:AddComponent(UIBaseContainer, "SafeArea/centerLayer")
  self.indicatorObj = self.indicator.gameObject
  self.indicatorObj:GameObjectCreatePool()
  self.indicatorObj:SetActive(false)
  self.indicatorList = {}
  self.angleSlots = {}
  for i = 1, 6 do
    self.angleSlots[i] = {
      angleMin = (i - 1) * 60,
      angleMax = i * 60,
      uuid = nil
    }
  end
  self:CreateIndicator()
end

function UILastStandMainView:ComponentDestroy()
  self.safeArea:RemoveComponents(MonsterIndicator)
  self.safeArea = nil
  self.back_btn = nil
  self:ClearResContent()
  self.resContent = nil
  self.resPrefab = nil
  self.resCells = nil
  self.joystick = nil
  self.indicatorObj:GameObjectRecycleAll()
  self.indicator = nil
end

function UILastStandMainView:ClearResContent()
  self.resCells = {}
  self.resContent:RemoveComponents(UIMainResourceProgress)
  self.resPrefab:GameObjectRecycleAll()
end

function UILastStandMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPVEBattleGetGoods, self.OnPVEBattleGetGoods)
  self:AddUIListener(EventId.LastStandReduceCoin, self.UpgradeFlyCoin)
end

function UILastStandMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnPVEBattleGetGoods, self.OnPVEBattleGetGoods)
  self:RemoveUIListener(EventId.LastStandReduceCoin, self.UpgradeFlyCoin)
  base.OnRemoveListener(self)
end

function UILastStandMainView:InitRes()
  self.resData = {}
  for i = 1, 1 do
    local resType = ResourceArray[i]
    self:AddResCell(resType)
  end
end

function UILastStandMainView:AddResCell(resType)
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local defaultNum = 0
  if logic then
    defaultNum = logic.coinNum or 0
  end
  self.resData[resType] = defaultNum
  local item = self.resPrefab:GameObjectSpawn(self.resContent.transform)
  item.name = "Res" .. resType
  local cell = self.resContent:AddComponent(UIMainResourceProgress, item.name)
  local param = {}
  param.resourceType = resType
  param.iconName = DataCenter.ResourceManager:GetResourceIconByType(resType)
  param.showCount = defaultNum
  cell:SetZero(param)
  cell:SetActive(true)
  self.resCells[resType] = cell
end

function UILastStandMainView:OnPVEBattleGetGoods(param)
  if self.resCells[param.goodsId] == nil then
    self:AddResCell(param.goodsId)
  end
  self.resCells[param.goodsId]:SetActive(true)
  local pic = DataCenter.ResourceManager:GetResourceIconByType(param.goodsId)
  local srcPos = CS.CSUtils.WorldPositionToUISpacePosition(param.worldPosition)
  local targetPos = self.resCells[param.goodsId]:GetResourcePos()
  local FlyParkourPath = "Assets/_Art/Effect/prefab/ui/Common/FlyParkour.prefab"
  DataCenter.FlyController.DoFlyForLua(pic, nil, 1, srcPos, targetPos, 40, 40, function()
    self:AddRes(param.goodsId, param.goodsCount)
    local battleMgr = DataCenter.LWBattleManager.logic
    if battleMgr and battleMgr.AddCoin then
      battleMgr:AddCoin(param.goodsCount)
    end
  end, FlyParkourPath, nil, -50, nil, nil)
end

function UILastStandMainView:UpgradeFlyCoin(param)
  local pic = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Wood)
  local srcPos = self.resCells[ResourceType.Wood]:GetResourcePos()
  local targetPos = CS.CSUtils.WorldPositionToUISpacePosition(param.worldPosition)
  local FlyParkourPath = "Assets/Main/Prefabs/UI/LastStand/UILastStandFlyCoin.prefab"
  DataCenter.FlyController.DoFlyWithoutLogic(pic, 1, srcPos, targetPos, 40, 40, nil, FlyParkourPath, 0, 0, 0.1, 0.1)
end

function UILastStandMainView:AddRes(goodsId, goodsCount)
  if not self.resCells or not self.resCells[goodsId] then
    return
  end
  local param = {}
  param.resourceType = goodsId
  self.resData[goodsId] = self.resData[goodsId] + goodsCount
  param.showCount = self.resData[goodsId]
  self.resCells[goodsId]:SetData(param)
end

function UILastStandMainView:OnExitBtnClick()
  if DataCenter.LWBattleManager.logic.winTimer or DataCenter.LWBattleManager.gameOver then
    return
  end
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic.param.enterType == PVEEnterType.StageFeatureBuilding then
    DataCenter.StageFeatureBuildingManager:OnExitBattle(logic.param.buildUuid)
  end
  self:OnExit()
end

function UILastStandMainView:OnExit()
  self.ctrl:CloseSelf()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic and logic.param then
    local levelId = logic.param.levelId
    PostEventLog.Track(PostEventLog.Defines.LastStandGiveUpLevel, {levelId = levelId})
  end
  DataCenter.LWBattleManager:Exit(nil, "quit")
end

function UILastStandMainView:ReduceRes(goodsId, goodsCount)
  local param = {}
  param.resourceType = goodsId
  self.resData[goodsId] = self.resData[goodsId] - goodsCount
  param.showCount = self.resData[goodsId]
  self.resCells[goodsId]:SetData(param)
end

function UILastStandMainView:InitRoundInfo()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic then
    local maxRound = logic:GetMaxMonsterRound()
    self:SetMaxRound(maxRound)
    self:SetCurRound(1, maxRound)
    local maxNum = logic:GetCurRoundMaxMonsterNum(1)
    self:SetCurKillMonsterNum(0, maxNum)
  end
end

function UILastStandMainView:SetMaxRound(maxRound)
  self.maxRound = maxRound or 0
end

function UILastStandMainView:SetCurRound(curRound)
  if self.textCurRound then
    self.textCurRound:SetText(string.format("<color=#F85C5C>%d</color>/%d", curRound, self.maxRound))
  end
end

function UILastStandMainView:SetCurKillMonsterNum(curNum, maxNum)
  self.textCurKillMonster:SetText(string.format("%d/%d", curNum, maxNum))
end

function UILastStandMainView:Update()
  self:UpdateMonsterIndicator()
end

function UILastStandMainView:Update1000MS()
  self:UpdateCountDown()
end

function UILastStandMainView:CreateIndicator()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local UIWorldPosHelper = CS.UIWorldPosHelper()
  UIWorldPosHelper:Init(scaleFactor)
  for i = 1, 6 do
    local item = self.indicatorObj:GameObjectSpawn(self.safeArea.transform)
    item.name = "MonsterIndicator_" .. i
    self.indicatorList[i] = self.safeArea:AddComponent(MonsterIndicator, item.name)
    self.indicatorList[i]:SetHelper(UIWorldPosHelper)
    self.indicatorList[i]:Hide()
  end
end

function UILastStandMainView:UpdateMonsterIndicator()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not logic then
    return
  end
  local allMonster = logic.unitMgr:GetAllZombie()
  local angleTable = {}
  for i, v in pairs(allMonster) do
    if v.curBlood > 0 then
      local angle = self:CalculateMonsterAngle(v)
      table.insert(angleTable, {
        uuid = i,
        angle = angle,
        monster = v
      })
    end
  end
  for i = 1, 6 do
    local slot = self.angleSlots[i]
    slot.uuid = nil
  end
  for _, monsterInfo in pairs(angleTable) do
    for i = 1, 6 do
      local slot = self.angleSlots[i]
      if not slot.uuid and monsterInfo.angle >= slot.angleMin and monsterInfo.angle < slot.angleMax then
        self.indicatorList[i]:UpdateIndicator(monsterInfo.monster)
        slot.uuid = monsterInfo.uuid
        break
      end
    end
  end
  for i = 1, 6 do
    local slot = self.angleSlots[i]
    if not slot.uuid then
      self.indicatorList[i]:Hide()
    end
  end
end

function UILastStandMainView:CalculateMonsterAngle(monster)
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not logic or not logic.team then
    return 0
  end
  local teamPos = logic.team:GetPosition()
  local monsterPos = monster:GetPosition()
  local dirX = monsterPos.x - teamPos.x
  local dirZ = monsterPos.z - teamPos.z
  local angle = math.deg(Mathf.Atan2(dirX, dirZ))
  if angle < 0 then
    angle = angle + 360
  end
  return angle
end

function UILastStandMainView:ShowGuideText(languageId)
  if not self.textGuide then
    return
  end
  self.textGuide:SetActive(true)
  self.textGuide:SetLocalText(languageId)
end

function UILastStandMainView:HideGuideText()
  if not self.textGuide then
    return
  end
  self.textGuide:SetActive(false)
end

function UILastStandMainView:UpdateCountDown()
  if not self.nextCountDownTime or self.nextCountDownTime <= 0 then
    return
  end
  self.nextCountDownTime = self.nextCountDownTime - 1
  if self.nextCountDownTime <= 0 then
    self.countDownTrans:SetActive(false)
  else
    self.textCountDown:SetLocalText("champion_duel_tips1083", self.nextCountDownTime)
  end
end

function UILastStandMainView:SetNextCountDownTime(time)
  self.nextCountDownTime = time
  if 0 < time then
    self.countDownTrans:SetActive(true)
    self.textCountDown:SetLocalText("champion_duel_tips1083", self.nextCountDownTime)
  else
    self.countDownTrans:SetActive(false)
  end
end

return UILastStandMainView
