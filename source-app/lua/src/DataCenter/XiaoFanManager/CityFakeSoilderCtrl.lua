local ctrl = {}
local SoilderAsset = "Assets/Main/Prefabs/LWOpeningStage/FakeSoilder.prefab"
ctrl.amount = 14
ctrl.soilders = {}
ctrl.bubbleCD = false
ctrl.dstPos = Vector3(102.53, 0, 91.54)
local FakeSoilder = {}

function FakeSoilder.Create(index, showEmoji)
  local copy = setmetatable({}, {__index = FakeSoilder})
  copy:Load(index, showEmoji)
  return copy
end

function FakeSoilder:Load(index, showEmoji)
  self.index = index
  self.handle = CS.GameEntry.Resource:InstantiateAsync(SoilderAsset)
  self.handle:completed("+", function(handle)
    self.gameObject = handle.gameObject
    self.transform = handle.gameObject.transform
    local soliderZ = DataCenter.LWCivilizationSparkExtend:FakeSoilder_getSoliderZ()
    self.transform.position = Vector3((index - 1) % 2 * 1.6 + 97.2, 0, -math.floor((index - 1) / 2) * 1.6 + soliderZ)
    self.touch = self.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
    
    function self.touch.onPointerClick()
      ctrl.ShowBubble()
    end
    
    self.bubbleRoot = self.transform:Find("Bubble")
    self.bubbleRoot.gameObject:SetActive(false)
    self.bubbleBg = self.transform:Find("Bubble/Bg")
    self.emojiMap = {}
    for j = 1, 7 do
      self.emojiMap[j] = self.transform:Find("Bubble/Bg/Emoji_" .. j)
    end
    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if showEmoji then
      self:ShowEmoji()
    end
    local yardLevel = DataCenter.BuildManager:GetMaxBuildingLevel(BuildingTypes.LW_BUILD_ARMY_YARD)
    if 1 <= yardLevel then
      local targetPos = DataCenter.LWCivilizationSparkExtend:FakeSoilder_getArmyPos(ctrl.dstPos)
      self:RunTo(targetPos)
    end
  end)
end

function FakeSoilder:Destroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if not IsNull(self.touch) then
    self.touch.onPointerClick = nil
  end
  if not IsNull(self.handle) then
    self.handle:Destroy()
  end
  self.handle = nil
  self.gameObject = nil
  self.transform = nil
  self.bubbleRoot = nil
  self.bubbleBg = nil
  self.emojiMap = nil
  self.anim = nil
  self:ClearRunSeq()
end

function FakeSoilder:ShowEmoji()
  local emojiNo = math.random(1, 7)
  for no, emoji in pairs(self.emojiMap) do
    emoji.gameObject:SetActive(no == emojiNo)
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.bubbleRoot.gameObject:SetActive(true)
    self.bubbleRoot.localEulerAngles = Vector3(45, -45, 0)
    local seq = CS.DG.Tweening.DOTween.Sequence()
    seq:Append(self.bubbleRoot:DOLocalRotate(Vector3(45, -45, 10), 0.05)):SetEase(CS.DG.Tweening.Ease.Linear)
    seq:Append(self.bubbleRoot:DOLocalRotate(Vector3(45, -45, -10), 0.1)):SetEase(CS.DG.Tweening.Ease.Linear)
    seq:Append(self.bubbleRoot:DOLocalRotate(Vector3(45, -45, 0), 0.05)):SetEase(CS.DG.Tweening.Ease.Linear)
  end, math.random() * 3)
end

function FakeSoilder:RunTo(dstPos)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.bubbleRoot.gameObject:SetActive(false)
  self.anim:Play("run")
  local pos = self.transform.position
  local dist = Vector3.Distance(pos, dstPos)
  local dir = (dstPos - pos).normalized
  self.transform.forward = dir
  self.transform:DOMove(dstPos, dist * 0.25):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
    if not IsNull(self.gameObject) then
      self.gameObject:SetActive(false)
    end
  end)
end

function FakeSoilder:ClearRunSeq()
  if self.runSeq then
    self.runSeq:Kill()
    self.runSeq = nil
  end
end

function ctrl.Update()
  local flagLevel = DataCenter.BuildManager:GetMaxBuildingLevel(BuildingTypes.LW_BUILD_FLAG)
  local yardLevel = DataCenter.BuildManager:GetMaxBuildingLevel(BuildingTypes.LW_BUILD_ARMY_YARD)
  if 0 < flagLevel and yardLevel == 0 then
    ctrl.ShowSoilders()
  end
end

function ctrl.ShowSoilders(showEmoji)
  local amount = DataCenter.LWCivilizationSparkExtend:FakeSoilder_getAmount(ctrl.amount)
  for i = 1, amount do
    local soilder = ctrl.soilders[i]
    if not soilder then
      soilder = FakeSoilder.Create(i, showEmoji and math.random() < 0.5)
      table.insert(ctrl.soilders, soilder)
    end
  end
end

function ctrl.HideSoilders()
  for _, soilder in ipairs(ctrl.soilders) do
    if soilder then
      soilder:Destroy()
    end
  end
  ctrl.soilders = {}
end

function ctrl.ShowBubble()
  if ctrl.bubbleCD then
    return
  end
  ctrl.bubbleCD = true
  local soliderZ = DataCenter.LWCivilizationSparkExtend:FakeSoilder_getSoliderZ()
  local bubblePos = Vector3(98, 2, soliderZ - 0.5)
  EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, {
    plotGroupId = 6013,
    anchor = bubblePos,
    mode = "3D"
  })
  TimerManager:GetInstance():DelayInvoke(function()
    ctrl.bubbleCD = false
  end, 3)
end

function ctrl.RunBabyRun()
  local targetPos = DataCenter.LWCivilizationSparkExtend:FakeSoilder_getArmyPos(ctrl.dstPos)
  for _, soilder in ipairs(ctrl.soilders) do
    if soilder then
      soilder:RunTo(targetPos)
    end
  end
end

function ctrl.Clear()
  ctrl.HideSoilders()
end

return ctrl
