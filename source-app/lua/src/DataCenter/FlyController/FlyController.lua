local FlyController = BaseClass("FlyController")
local ResourceManager = CS.GameEntry.Resource
local Screen = CS.UnityEngine.Screen
local IconPath = "Assets/_Art/Effect/prefab/ui/Common/FlyGoods.prefab"
local IconTextPath = "Assets/_Art/Effect/prefab/ui/Common/FlyGoodsText.prefab"
local ExpPath = "Assets/_Art/Effect/prefab/ui/Common/FlyExp.prefab"
local IconGiftBoxPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Binfenlihe/Eff_ui_binfenlihe_jingyan.prefab"
local MoneyPath = "Assets/_Art/Effect/prefab/ui/Common/FlyMoney.prefab"
local MoneyTextPath = "Assets/_Art/Effect/prefab/ui/Common/FlyMoneyText.prefab"
local CustomPath = "Assets/_Art/Effect/prefab/ui/Common/FlyCustom.prefab"
local FlyJumpPath = "Assets/_Art/Effect/prefab/ui/Common/VFX_ui_flyJump.prefab"
local FlyTextPath = "Assets/_Art/Effect/prefab/ui/Common/FloatText.prefab"
local ControlPointOffset = Vector3.New(0, 500, 0)
local SEGMENT_COUNT = 20
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)
local TimeDelta = 0.09
local TimeDelta1 = 0.15
local MinRange = -100.0
local MaxRange = 100.0

local function __init(self)
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimeCallBack()
  end
  
  self.checkRemoveList = {}
end

local function __delete(self)
  self:DeleteTimer()
  self:ClearCheckList()
end

local function Startup(self)
  self.checkRemoveList = {}
  self:AddTimer()
end

local function TimeCallBack(self)
  if #self.checkRemoveList > 0 then
    local needRemoveIndexList = {}
    for i = 1, #self.checkRemoveList do
      local data = self.checkRemoveList[i]
      data.time = data.time - 1
      if 0 >= data.time then
        local request = data.request
        if request ~= nil then
          request:Destroy()
        end
        table.insert(needRemoveIndexList, i)
      end
    end
    if 0 < #needRemoveIndexList then
      for j = #needRemoveIndexList, 1, -1 do
        table.remove(self.checkRemoveList, needRemoveIndexList[j])
      end
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function ClearCheckList(self)
  for k, v in pairs(self.checkRemoveList) do
    local request = v.request
    if request ~= nil then
      request:Destroy()
    end
  end
  self.checkRemoveList = {}
end

local function AddToCheckList(self, request, time)
  local oneData = {}
  oneData.request = request
  oneData.time = time + 1
  table.insert(self.checkRemoveList, oneData)
end

local function DoJumpFly(icon, nums, srcPos, destPos, delay, width, height, callback)
  local total = table.count(nums)
  local gap1 = 0.15
  if 10 <= total then
    gap1 = 0.1
  end
  local num1 = 0.4
  local num2 = 1.5
  local diff = -1
  local maxTime = 6
  local energyDelayTime = -1
  local energyTotalTime = -1
  local totalAniTime = 2.5
  delay = delay or 0
  for i = 1, total do
    local num = nums[i]
    local time = i * gap1
    local totalTime = Mathf.Pow(i, num1) * num2
    if diff < 0 then
      diff = totalTime - time
      diff = math.max(diff, 0)
    end
    totalTime = totalTime - diff
    if maxTime < totalTime then
      maxTime = maxTime + 0.02
    end
    totalTime = math.min(maxTime, totalTime)
    local delayTime = totalTime - time
    local radiusW = 100
    local radiusH = 50
    if energyDelayTime < 0 then
      energyDelayTime = totalTime + totalAniTime
    end
    if i == total then
      energyTotalTime = totalTime + totalAniTime - energyDelayTime
    end
    TimerManager:GetInstance():DelayInvoke(function()
      local request = ResourceManager:InstantiateAsync(FlyJumpPath)
      request:completed("+", function()
        if request.isError then
          return
        end
        local tf = request.gameObject.transform
        tf:SetParent(CS.GameEntry.UIContainer)
        local offSetX = math.random() * radiusW - radiusW / 2
        local offSetY = math.random() * radiusH - radiusH / 2
        if num == -2 then
          tf:Set_localScale(0.7, 0.7, 0.7)
          tf:Set_position(srcPos.x + offSetX + 75, srcPos.y + offSetY, srcPos.z)
        else
          tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          tf:Set_position(srcPos.x + offSetX, srcPos.y + offSetY, srcPos.z)
        end
        local image = tf:GetComponentInChildren(typeof(CS.UnityEngine.UI.Image))
        if image ~= nil then
          image:GetComponent(typeof(CS.UnityEngine.RectTransform)):Set_sizeDelta(width or 80, height or 80)
          if not string.IsNullOrEmpty(icon) then
            image:LoadSprite(icon)
          end
        end
        local text = tf:GetComponentInChildren(typeof(CS.UnityEngine.UI.Text))
        if num == nil or num <= 0 then
          text.text = ""
        else
          text.text = "+" .. string.GetFormattedSeperatorNum(num)
        end
        local isLeft = false
        local fly = tf:GetComponentInChildren(typeof(CS.UIJumpFly))
        local pos = CS.UnityEngine.Vector3(destPos.x, destPos.y, 0)
        DataCenter.FlyController:AddToCheckList(request, fly.moveTime + 12.0)
        if fly.DoFlyNew == nil then
          fly:DoFly(pos, function()
            request:Destroy()
            if callback ~= nil then
              callback()
            end
          end, isLeft)
        else
          fly:DoFlyNew(pos, function()
            request:Destroy()
            if callback ~= nil then
              callback()
            end
          end, isLeft, delayTime)
        end
      end)
    end, time + delay)
  end
  return energyDelayTime, energyTotalTime
end

local function DoFlyCustom(icon, content, num, srcPos, destPos, width, height, callback, model, minRange, maxRange, startDelay, parent, animType)
  local modelPath = model or CustomPath
  animType = animType or 999
  for i = 1, num do
    TimerManager:GetInstance():DelayInvoke(function()
      local request = ResourceManager:InstantiateAsync(modelPath)
      request:completed("+", function()
        if request.isError then
          return
        end
        local tf = request.gameObject.transform
        tf:SetParent(parent or CS.GameEntry.UIContainer)
        tf:Set_position(srcPos.x, srcPos.y, 0)
        tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local image = tf:GetComponentInChildren(typeof(CS.UnityEngine.UI.Image))
        if image ~= nil then
          image:GetComponent(typeof(CS.UnityEngine.RectTransform)):Set_sizeDelta(width or 80, height or 80)
          UIUtil.LoadSpriteRenderAuto(image, icon)
        end
        local text = tf:GetComponentInChildren(typeof(CS.UnityEngine.UI.Text))
        if not string.IsNullOrEmpty(content) then
          text.text = content
        end
        local fly = tf:GetComponent(typeof(CS.UIGoodsFly))
        local pos = CS.UnityEngine.Vector3(destPos.x, destPos.y, 0)
        local min = minRange == nil and MinRange or minRange
        local max = maxRange == nil and MaxRange or maxRange
        DataCenter.FlyController:AddToCheckList(request, fly.moveTime)
        if startDelay and 0 < startDelay then
          fly.enabled = false
          TimerManager:GetInstance():DelayInvoke(function()
            fly.enabled = true
          end, startDelay)
        end
        fly:DoAnimForLua(min, max, animType, icon, "", pos, function()
          request:Destroy()
          if callback ~= nil then
            callback(i)
          end
        end)
      end)
    end, (i - 1) * TimeDelta)
  end
end

local function GetFlyPrefabPath(rewardType, useTextFormat)
  if rewardType == RewardType.FOOD then
    if useTextFormat == true then
      return MoneyTextPath
    else
      return MoneyPath
    end
  elseif rewardType == RewardType.EXP then
    return ExpPath
  elseif rewardType == RewardType.ActGiftBox then
    return IconGiftBoxPath
  elseif useTextFormat == true then
    return IconTextPath
  else
    return IconPath
  end
end

local function CreateFlyEffect(args)
  local request = ResourceManager:InstantiateAsync(args.path)
  request:completed("+", function()
    if request.isError then
      return
    end
    local tf = request.gameObject.transform
    tf:SetParent(args.parent or CS.GameEntry.UIContainer)
    tf:Set_position(args.srcPos.x, args.srcPos.y, args.srcPos.z)
    local scaleRatio = args.scaleRatio or 1
    tf:Set_localScale(ResetScale.x * scaleRatio, ResetScale.y * scaleRatio, ResetScale.z * scaleRatio)
    local rtf
    if args.rewardType == RewardType.FOOD or args.rewardType == RewardType.ActGiftBox then
      rtf = tf:GetComponent(typeof(CS.UnityEngine.RectTransform))
    else
      rtf = tf:Find("Image"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    end
    rtf:Set_sizeDelta(args.width or 80, args.height or 80)
    local fly = tf:GetComponent(typeof(CS.UIGoodsFly))
    if args.moveTime then
      fly.moveTime = args.moveTime
    end
    if args.controlPointOffset ~= nil then
      fly.controlPointOffset = args.controlPointOffset
    end
    local pos
    if args.destPos.x == 0 and args.destPos.y == 0 then
      pos = UIUtil.GetFlyTargetPosByRewardType(args.rewardType)
    else
      pos = args.destPos
    end
    DataCenter.FlyController:AddToCheckList(request, fly.moveTime)
    if args.startDelay and 0 < args.startDelay then
      fly.enabled = false
      TimerManager:GetInstance():DelayInvoke(function()
        fly.enabled = true
      end, args.startDelay)
    end
    local rangeMin = args.rangeMin or MinRange
    local rangeMax = args.rangeMax or MaxRange
    if args.isOnlyDisperse == nil then
    end
    local isOnlyDisperse = args.isOnlyDisperse
    fly:DoAnimForLua(rangeMin, rangeMax, args.rewardType, args.icon, args.num, pos, function()
      request:Destroy()
      FlyController.InternalCallback(args.rewardType)
      if args.callback ~= nil then
        args.callback()
      end
    end, isOnlyDisperse)
  end)
end

local function DoFlyCommon(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat, moveTime, startDelay, parent, config)
  local count = (rewardType == RewardType.EXP or useTextFormat == true) and 1 or num
  local path = GetFlyPrefabPath(rewardType, useTextFormat)
  local scaleRatio = useTextFormat == true and 1.5 or 1
  config = config or {}
  for i = 1, count do
    TimerManager:GetInstance():DelayInvoke(function()
      CreateFlyEffect({
        path = path,
        rewardType = rewardType,
        num = num,
        icon = icon,
        srcPos = srcPos,
        destPos = destPos,
        width = width,
        height = height,
        callback = callback,
        parent = parent,
        moveTime = moveTime,
        startDelay = startDelay,
        scaleRatio = scaleRatio,
        rangeMin = config.rangeMin,
        rangeMax = config.rangeMax,
        controlPointOffset = config.controlPointOffset,
        isOnlyDisperse = config.isOnlyDisperse
      })
    end, (i - 1) * TimeDelta)
  end
end

local function DoFly(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat, moveTime, startDelay, parent, isOnlyDisperse)
  local config
  if isOnlyDisperse ~= nil then
    config = {isOnlyDisperse = isOnlyDisperse}
  end
  DoFlyCommon(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat, moveTime, startDelay, parent, config)
end

local function DoFlyStraight(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat, moveTime, startDelay, parent)
  DoFlyCommon(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat, moveTime, startDelay, parent, {
    rangeMin = 0,
    rangeMax = 0,
    controlPointOffset = Vector3.zero,
    isOnlyDisperse = false
  })
end

local function DoFlyWithoutLogic(icon, num, srcPos, destPos, width, height, callback, model, minRange, maxRange, moveTime1, moveTime2, initCallback)
  local count = num
  for i = 1, count do
    TimerManager:GetInstance():DelayInvoke(function()
      local path = model
      local request = ResourceManager:InstantiateAsync(path)
      request:completed("+", function()
        if request.isError then
          return
        end
        local tf = request.gameObject.transform
        tf:SetParent(parent or CS.GameEntry.UIContainer)
        tf:Set_position(srcPos.x, srcPos.y, srcPos.z)
        local scaleRatio = 1
        tf:Set_localScale(ResetScale.x * scaleRatio, ResetScale.y * scaleRatio, ResetScale.z * scaleRatio)
        local rtf
        rtf = tf:Find("Image"):GetComponent(typeof(CS.UnityEngine.RectTransform))
        rtf:Set_sizeDelta(width or 80, height or 80)
        local fly = tf:GetComponent(typeof(CS.UIGoodsFly))
        local pos
        pos = destPos
        if moveTime2 then
          fly.moveTime = moveTime2
        end
        DataCenter.FlyController:AddToCheckList(request, fly.moveTime)
        if initCallback ~= nil then
          initCallback()
        end
        fly:DoAnimWithoutLogic(minRange, maxRange, icon, pos, function()
          request:Destroy()
          FlyController.InternalCallback()
          if callback ~= nil then
            callback()
          end
        end, moveTime1, moveTime2)
      end)
    end, (i - 1) * TimeDelta)
  end
end

local function InternalCallback(rewardType)
  if rewardType == RewardType.EXP then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Effect_Exp_FarmSystem, false)
    EventManager:GetInstance():Broadcast(EventId.UpdatePlayerExp)
  end
end

local function CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

local function Bezier2Path(startPos, controlPos, endPos)
  for i = 1, SEGMENT_COUNT do
    local t = i / SEGMENT_COUNT
    local pixel = CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
    paths[i - 1] = pixel
  end
  return paths
end

local function DoFlyForLua(icon, content, num, srcPos, destPos, width, height, callback, model, minRange, maxRange, startDelay, parent, firstCurveTime, secondCurveTime)
  local modelPath = model or CustomPath
  firstCurveTime = firstCurveTime or 0.2
  secondCurveTime = secondCurveTime or 1
  for i = 1, num do
    TimerManager:GetInstance():DelayInvoke(function()
      local request = ResourceManager:InstantiateAsync(modelPath)
      request:completed("+", function()
        if request.isError then
          return
        end
        local tf = request.gameObject.transform
        tf:SetParent(parent or CS.GameEntry.UIContainer)
        tf:Set_position(srcPos.x, srcPos.y, srcPos.z)
        tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local image = tf:GetComponentInChildren(typeof(CS.UnityEngine.UI.Image))
        if image ~= nil then
          image:GetComponent(typeof(CS.UnityEngine.RectTransform)):Set_sizeDelta(width or 80, height or 80)
          if not string.IsNullOrEmpty(icon) then
            image:LoadSprite(icon)
          end
        end
        local text = tf:GetComponentInChildren(typeof(CS.UnityEngine.UI.Text))
        if not string.IsNullOrEmpty(content) then
          text.text = content
        end
        local fly = tf:GetComponent(typeof(CS.UIGoodsFly))
        local min = minRange == nil and MinRange or minRange
        local max = maxRange == nil and MaxRange or maxRange
        DataCenter.FlyController:AddToCheckList(request, fly.moveTime)
        if startDelay and 0 < startDelay then
          fly.enabled = false
          TimerManager:GetInstance():DelayInvoke(function()
            fly.enabled = true
          end, startDelay)
        end
        local startPos = srcPos
        local cross = Vector3.Cross(startPos, destPos)
        local controlPos = Vector3.zero
        if cross.y > 0 then
          controlPos = (startPos + destPos) * 0.5 + ControlPointOffset + Vector3.New(math.random(min, max), math.random(min, max), 0)
        else
          controlPos = (startPos + destPos) * 0.5 - ControlPointOffset + Vector3.New(math.random(min, max), math.random(min, max), 0)
        end
        local pathvec = Bezier2Path(startPos, controlPos, destPos)
        local seq = CS.DG.Tweening.DOTween.Sequence()
        seq:Append(tf:DOPath(pathvec, secondCurveTime)):SetEase(fly.secondCurve)
        
        function seq.onComplete()
          request:Destroy()
          if callback ~= nil then
            callback(i)
          end
        end
      end)
    end, (i - 1) * TimeDelta)
  end
end

local function DoFlySimpleFunc(path, srcPos, destPos, moveTime, parent, callback)
  if path == nil then
    return
  end
  local request = ResourceManager:InstantiateAsync(path)
  request:completed("+", function()
    if request.isError then
      return
    end
    local tf = request.gameObject.transform
    tf:SetParent(parent or CS.GameEntry.UIContainer)
    tf:Set_position(srcPos.x, srcPos.y, srcPos.z)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    tf:DOMove(destPos, moveTime):OnComplete(function()
      if callback ~= nil then
        callback()
      end
      request:Destroy()
    end)
    DataCenter.FlyController:AddToCheckList(request, moveTime)
  end)
end

local function DoFlyWithBezierFunc(path, srcPos, destPos, moveTime, parent, callback)
  if path == nil then
    return
  end
  local request = ResourceManager:InstantiateAsync(path)
  request:completed("+", function()
    if request.isError then
      return
    end
    local tf = request.gameObject.transform
    tf:SetParent(parent or CS.GameEntry.UIContainer)
    tf:Set_position(srcPos.x, srcPos.y, srcPos.z)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local startPos = srcPos
    local cross = Vector3.Cross(startPos, destPos)
    local controlPos = Vector3.zero
    if cross.y > 0 then
      controlPos = (startPos + destPos) * 0.5 + ControlPointOffset + Vector3.New(math.random(MinRange, MaxRange), math.random(MinRange, MaxRange), 0)
    else
      controlPos = (startPos + destPos) * 0.5 - ControlPointOffset + Vector3.New(math.random(MinRange, MaxRange), math.random(MinRange, MaxRange), 0)
    end
    local pathVec = Bezier2Path(startPos, controlPos, destPos)
    local seq = CS.DG.Tweening.DOTween.Sequence()
    seq:Append(tf:DOPath(pathVec, moveTime)):SetEase(CS.DG.Tweening.Ease.InOutQuad)
    
    function seq.onComplete()
      request:Destroy()
      if callback ~= nil then
        callback()
      end
    end
    
    DataCenter.FlyController:AddToCheckList(request, moveTime)
  end)
end

local function DoFlyText(context)
  if not context then
    return
  end
  local icon = context.icon
  local textContent = context.text
  local srcPos = context.srcPos
  local dstPos = context.dstPos
  local srcScale = context.srcScale
  local dstScale = context.dstScale
  local fontSize = context.fontSize
  local moveTime = context.moveTime
  local startDelay = context.startDelay
  local callback = context.callback
  local parent = context.parent
  local iconIsLeft = context.iconIsLeft
  local modelPath = FlyTextPath
  local request = ResourceManager:InstantiateAsync(modelPath)
  request:completed("+", function()
    if request.isError then
      return
    end
    local tf = request.gameObject.transform
    tf:SetParent(parent or CS.GameEntry.UIContainer)
    tf:Set_position(srcPos.x, srcPos.y, srcPos.z)
    srcScale = srcScale or 1
    tf:Set_localScale(srcScale, srcScale, srcScale)
    local canvasGroupComp = tf:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    if canvasGroupComp ~= nil then
      canvasGroupComp.alpha = 1
    end
    local imageTf = tf:Find("Image")
    if not IsNull(imageTf) then
      local image = imageTf:GetComponent(typeof(CS.UnityEngine.UI.Image))
      if not string.IsNullOrEmpty(icon) then
        imageTf.gameObject:SetActive(true)
        image:LoadSprite(icon)
      else
        imageTf.gameObject:SetActive(false)
      end
      if iconIsLeft then
        imageTf:SetAsFirstSibling()
      else
        imageTf:SetAsLastSibling()
      end
    end
    local textTf = tf:Find("Text")
    if not IsNull(textTf) then
      local text = textTf:GetComponent(typeof(CS.UnityEngine.UI.Text))
      if not string.IsNullOrEmpty(textContent) then
        textTf.gameObject:SetActive(true)
        text.fontSize = fontSize or 30
        text.text = textContent
      else
        textTf.gameObject:SetActive(false)
      end
      if iconIsLeft then
        textTf:SetAsLastSibling()
      else
        textTf:SetAsFirstSibling()
      end
    end
    
    local function changeAlpha(x)
      if canvasGroupComp ~= nil then
        canvasGroupComp.alpha = x
      end
    end
    
    local function doFly()
      tf:DOMove(dstPos, moveTime):OnComplete(function()
        if callback ~= nil then
          callback()
        end
        request:Destroy()
      end)
      if dstScale and dstScale ~= srcScale then
        local dstScaleVec = Vector3.New(dstScale, dstScale, dstScale)
        tf:DOScale(dstScaleVec, moveTime):SetEase(CS.DG.Tweening.Ease.InOutQuad)
      end
      DOTween.To(changeAlpha, 1, 0, moveTime)
    end
    
    local flyTime = moveTime or 1
    if startDelay and 0 < startDelay then
      flyTime = flyTime + startDelay
      TimerManager:GetInstance():DelayInvoke(function()
        doFly()
      end, startDelay)
    else
      doFly()
    end
    DataCenter.FlyController:AddToCheckList(request, flyTime)
  end)
end

FlyController.__init = __init
FlyController.__delete = __delete
FlyController.Startup = Startup
FlyController.DoFly = DoFly
FlyController.DoFlyCustom = DoFlyCustom
FlyController.DoFlyForLua = DoFlyForLua
FlyController.DoFlyStraight = DoFlyStraight
FlyController.DoJumpFly = DoJumpFly
FlyController.InternalCallback = InternalCallback
FlyController.AddToCheckList = AddToCheckList
FlyController.AddTimer = AddTimer
FlyController.DeleteTimer = DeleteTimer
FlyController.TimeCallBack = TimeCallBack
FlyController.DoFlySimpleFunc = DoFlySimpleFunc
FlyController.DoFlyWithBezierFunc = DoFlyWithBezierFunc
FlyController.DoFlyText = DoFlyText
FlyController.ClearCheckList = ClearCheckList
FlyController.DoFlyWithoutLogic = DoFlyWithoutLogic
FlyController.Bezier2Path = Bezier2Path
return FlyController
