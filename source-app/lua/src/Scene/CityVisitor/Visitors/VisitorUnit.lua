local VisitorUnit = BaseClass("CallerUnit")
local Const = require("Scene.CityVisitor.Const")
local WorkerData = require("DataCenter.WorkerData.WorkerData")
local Resource = CS.GameEntry.Resource
local trigger_path = "TipRoot/Trigger"
local icon = "TipRoot/Icon"
local questionIcon = "TipRoot/Icon/questionIcon"
local smilingFaceIcon = "TipRoot/Icon/smilingFaceIcon"
local untaggerTag = "Untagged"
local visitorTag = "visitor"
local Localization = CS.GameEntry.Localization

function VisitorUnit:__init()
  self:ClearData()
  self:AddListener()
end

function VisitorUnit:StartCaller(callBack)
  if self.isCreate then
    return
  end
  self.callBack = callBack
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local delay = self.visitorData.startTime - curTime
  if 0 < delay then
    self.createDelay = TimerManager:GetInstance():DelayInvoke(function()
      self:TimerAction()
    end, delay / 1000)
  else
    self:CreateModel()
  end
  self.isStart = true
end

function VisitorUnit:CreateModel()
  if self.visitorData and self.visitorData.modelPath ~= nil and self.visitorData.modelPath ~= "" then
    self.req = Resource:InstantiateAsync(self.visitorData.modelPath)
    self.req:completed("+", function(req)
      self:OnCreateModel(req, self.visitorData.uid, self.visitorData:GetStartPos(), self.visitorData:GetEndPos())
    end)
  end
end

function VisitorUnit:OnDelayClick(fun)
  if not self.isConfirmClick then
    self.isConfirmClick = true
    if fun then
      fun()
    end
    self.cilickDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.isConfirmClick = false
    end, 1)
  end
end

function VisitorUnit:OnUpdate()
  if self.gameObjectValid and self.transformValid then
    if self.endPos == nil then
      return
    end
    local position = Vector3(self.transform:Get_position())
    if #self.endPos > 0 and Vector3.Distance(position, self.endPos[1]) > 0.001 then
      self.isArrival = false
      self.transform:Set_position(Vector3.MoveTowards(position, self.endPos[1], Time.deltaTime * Const.moveSpeed):Split())
    elseif #self.endPos >= 1 then
      table.remove(self.endPos, 1)
      if #self.endPos >= 1 then
        local lookRot = Quaternion.LookRotation(Vector3.Normalize(self.endPos[1] - position), Vector3.up)
        self.transform:Set_rotation(lookRot:Split())
        if self.tipRoot then
          self.tipRoot.transform:Set_rotation(CS.SceneManager.World:Get_rotation())
        end
      end
    else
      if not self.isArrival then
        self.isArrival = true
        local isNeedRotate = self.angleInfoArr ~= nil
        if not isNeedRotate then
          self:PlayAni(Const.animation.Idle)
        else
          self:RotateAngleWhenArrive(function()
            self:PlayAni(Const.animation.Idle)
          end)
        end
      end
      if self.isFinish then
        self:OnFinish()
      end
    end
  end
end

function VisitorUnit:SetTargetEndPos(endPos)
  if self.transform and endPos then
    local tempPosList = {}
    local tempPos = {}
    for i = 1, #endPos do
      tempPos = {}
      tempPos = Vector3.New(endPos[i].x, endPos[i].y, endPos[i].z)
      if endPos[i].SqrMagnitude == nil then
        Logger.LogError("error !! vector3 is UnityEngine ")
      end
      table.insert(tempPosList, tempPos)
    end
    self.endPos = tempPosList
    local ro = Vector3.Normalize(self.endPos[1] - self.transform.position)
    local lookRot = self.transform.rotation
    if ro ~= Vector3.zero then
      lookRot = Quaternion.LookRotation(ro, Vector3.up)
    end
    self.transform.rotation = lookRot
    if self.tipRoot and CS.SceneManager.World then
      self.tipRoot.transform.rotation = CS.SceneManager.World:GetRotation()
    end
    self.curendPos = self.endPos[#self.endPos]
    self:PlayAni(Const.animation.Walk)
    self.isArrival = true
  end
end

function VisitorUnit:UpdateVisitorData(visitorData)
  self.visitorData = DeepCopy(visitorData)
  self.uid = visitorData.uid
end

function VisitorUnit:GetVisitorData()
  return self.visitorData
end

function VisitorUnit:TimerAction()
  self:CreateModel(self.visitorData.uid, self.visitorData:GetStartPos(), self.visitorData:GetEndPos())
end

function VisitorUnit:GetIsArrival()
  return self.isArrival
end

function VisitorUnit:OnCreateModel(req, uid, startPos, endPos)
  local gameObject = req.gameObject
  local transform = gameObject.transform
  self.gameObject = gameObject
  self.gameObjectValid = true
  self.transform = transform
  self.transformValid = true
  if CS.SceneManager.World then
    req.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
  end
  transform:Set_position(startPos.x, startPos.y, startPos.z)
  gameObject.name = "CallerUnit" .. tostring(uid)
  self.isArrival = false
  self.isCreate = true
  self.isFinish = false
  self.endPos = {}
  self.gameObject.tag = visitorTag
  self.startPos = startPos
  
  function self.updateTimer()
    self:OnUpdate()
  end
  
  self.update = UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  self.simpleAnims = self.transform:GetComponentsInChildren(typeof(CS.SimpleAnimation), true)
  self:PlayAni(Const.animation.Walk)
  local trigger_obj = self.transform:Find(trigger_path)
  if trigger_obj then
    self.trigger = trigger_obj:GetComponent(typeof(CS.TouchObjectEventTrigger))
  end
  self.icon = self.transform:Find(icon)
  self.questionIcon = self.transform:Find(questionIcon)
  if self.questionIcon then
    self.questionIcon.gameObject:SetActive(true)
    self.questionIcon.transform:Set_localScale(3, 3, 3)
  end
  self.smilingFaceIcon = self.transform:Find(smilingFaceIcon)
  if self.smilingFaceIcon then
    self.smilingFaceIcon.gameObject:SetActive(false)
  end
  self.modelTrigger = self.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
  if self.modelTrigger then
    function self.modelTrigger.onPointerClick()
      self:OnTriggerClick()
    end
  end
  if self.questionIcon then
    self.cancel_icon = self.questionIcon:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    if not string.IsNullOrEmpty(self.visitorData.tipIcon) then
      self.cancel_icon:LoadSprite(string.format(UIAssets.UIVisitorTipImagePath, self.visitorData.tipIcon))
    end
  end
  self.tipRoot = self.transform:Find("TipRoot")
  if self.tipRoot then
    self.tipRoot.gameObject:SetActive(true)
  end
  if self.trigger then
    function self.trigger.onPointerClick()
      self:OnTriggerClick()
    end
  end
  if self.callBack then
    self.callBack()
    self.callBack = nil
  end
  self:InitClickParam()
  self:SetTargetEndPos({
    [1] = endPos
  })
  if self.param.isNewLogic and self.param.dialogType == VisitorDialogType.TemperatureLogic then
    local tempIndex = self:GetTempIndex()
    local iconPath = self.param.iconName[tempIndex]
    self.param.tempIndex = tempIndex
    if self.cancel_icon then
      self.cancel_icon:LoadSprite(string.format(UIAssets.UIVisitorTipImagePath, iconPath))
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshVisitorBtnState)
end

function VisitorUnit:InitClickParam()
  local param = {}
  local line = LocalController:instance():getLine(TableName.City_Visitor, self.visitorData.eventId)
  if not string.IsNullOrEmpty(line.dialog_type) then
    local dialotType = toInt(line.dialog_type)
    if dialotType == VisitorDialogType.TemperatureLogic then
      param.isNewLogic = true
      param.dialogType = VisitorDialogType.TemperatureLogic
      param.tempRange = {}
      param.desList = {}
      param.iconName = {}
      if not string.IsNullOrEmpty(line.dialog_para1) then
        local t = string.split(line.dialog_para1, "|")
        for index, value in ipairs(t) do
          local range = string.split(value, ";")
          local data = {}
          data.left = toInt(range[1])
          data.right = toInt(range[2])
          table.insert(param.tempRange, data)
        end
      end
      if not string.IsNullOrEmpty(line.dialog_para2) then
        local t = string.split(line.dialog_para2, "|")
        param.desList = t
      end
      if not string.IsNullOrEmpty(line.dialog_para3) then
        local t = string.split(line.dialog_para3, "|")
        param.iconName = t
      end
    elseif dialotType == VisitorDialogType.CommonRandomLogic then
      param.dialogType = VisitorDialogType.CommonRandomLogic
      param.isNewLogic = true
      local desList = string.split(line.dialog_para2, "|")
      param.desList = desList
    else
      local desList = string.split(line.dialog, "|")
      param.desList = desList
    end
  else
    local desList = string.split(line.dialog, "|")
    param.desList = desList
  end
  if not string.IsNullOrEmpty(line.special_condition) then
    param.specialCondition = line.special_condition
    if not string.IsNullOrEmpty(line.special_condition) then
      local vec = string.split(line.special_vistor_zone, ";")
      param.specialEndPos = Vector3.New(vec[1], 0, vec[2])
    end
    if not string.IsNullOrEmpty(line.special_dialog_para2) then
      local t = string.split(line.special_dialog_para2, "|")
      param.specialDesList = t
    end
  end
  if not string.IsNullOrEmpty(line.choose_treasure) then
    param.chooseTreasure = {}
    local chooseTreasureList = string.split(line.choose_treasure, "|")
    for _, v in ipairs(chooseTreasureList) do
      local treasure = string.split(v, ";")
      if #treasure == 2 then
        local chooseId = tonumber(treasure[1])
        local treasureId = tonumber(treasure[2])
        if chooseId and treasureId then
          table.insert(param.chooseTreasure, {chooseId = chooseId, treasureId = treasureId})
        end
      end
    end
  else
    param.chooseTreasure = nil
  end
  if self.visitorData.workerData then
    local one = WorkerData.New()
    one:UpdateInfo(self.visitorData.workerData)
    param.data = one
    self.workerData = one
  else
    param.data = {}
    param.data.modelId = self.visitorData.appearCfgId
    param.data.name = Localization:GetString(self.visitorData.name)
  end
  local btnList = string.split(line.btn_dialog, "|")
  
  function param.confirmFun()
    self:OnConfirmClick()
  end
  
  function param.cancelFun()
    self:CancelClick()
  end
  
  param.type = tonumber(self.visitorData.eventType) == VisitorType.MERCHANT and OptionType.Two or OptionType.One
  param.confirmText = btnList[1]
  param.cancelText = btnList[2]
  local finishPlot = line.finish_plot
  if not string.IsNullOrEmpty(finishPlot) then
    local finishPlotList = string.split(finishPlot, "|")
    param.finishPlotList = {}
    for _, v in ipairs(finishPlotList) do
      local plotId = tonumber(v) or 0
      if 0 < plotId then
        table.insert(param.finishPlotList, plotId)
      end
    end
  end
  self.param = self:OnInitClickParam(param)
  if line.rotate_when_arrive then
    local rotateAngleWhenArriveInfo = line.rotate_when_arrive
    local rotateInfoArr = string.split(rotateAngleWhenArriveInfo, "|")
    if 2 <= #rotateInfoArr then
      self.angleInfoArr = rotateInfoArr[1]
      self.rotateTime = tonumber(rotateInfoArr[2])
    end
  end
end

function VisitorUnit:OnInitClickParam(param)
  if not param or not param.desList then
    return
  end
  if param.isNewLogic == nil or param.isNewLogic == false then
    for i = 1, #param.desList do
      if not string.IsNullOrEmpty(param.desList[i]) then
        param.desList[i] = Localization:GetString(param.desList[i])
      end
    end
    if param.specialDesList then
      for i = 1, #param.specialDesList do
        if not string.IsNullOrEmpty(param.specialDesList[i]) then
          param.specialDesList[i] = Localization:GetString(param.specialDesList[i])
        end
      end
    end
  end
  return param
end

function VisitorUnit:GetTempIndex()
  if self.param.isNewLogic then
    local temp = DataCenter.TemperatureManager:GetMyBaseTemperature()
    local tempIndex = 0
    local count = #self.param.tempRange
    for index, value in ipairs(self.param.tempRange) do
      if index == 1 and temp > value.left then
        tempIndex = index
        break
      end
      if index == count and temp <= value.right then
        tempIndex = index
        break
      end
      if temp <= value.left and temp > value.right then
        tempIndex = index
        break
      end
    end
    if tempIndex == 0 then
      Logger.Log("Logic error")
      tempIndex = 1
    end
    return tempIndex
  end
  return 1
end

function VisitorUnit:OnTriggerClick()
  if not self.param then
    return
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.param.isNewLogic then
    self.playPlotGroupId = nil
    if self.param.dialogType == VisitorDialogType.TemperatureLogic then
      local tempIndex = self:GetTempIndex()
      local desList = self:GetDesList()
      self.playPlotGroupId = toInt(desList[tempIndex])
    elseif self.param.dialogType == VisitorDialogType.CommonRandomLogic then
      local desList = self:GetDesList()
      local count = #desList
      if count == 1 then
        self.playPlotGroupId = toInt(desList[1])
      elseif 0 < count then
        local random = math.random(1, count)
        self.playPlotGroupId = toInt(desList[random])
      else
        return
      end
    end
    if self.playPlotGroupId then
      if self.playPlotFinish then
        EventManager:GetInstance():RemoveListener(EventId.GF_plot_group_done, self.playPlotFinish)
        self.playPlotFinish = nil
      end
      if CS.CommonUtils.IsDebug() and (GMUtils.GetBool("DEBUG_JUMP_ALL_PLOT", false) or Setting:GetBool("DEBUG_JUMP_ALL_PLOT", false)) then
        self:OnConfirmClick()
        return
      end
      
      function self.playPlotFinish(finishGroupId)
        if finishGroupId == self.playPlotGroupId then
          self:OnConfirmClick()
        end
      end
      
      EventManager:GetInstance():AddListener(EventId.GF_plot_group_done, self.playPlotFinish)
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = self.playPlotGroupId,
        uid = self.visitorData.uid,
        choose = self.param.chooseTreasure,
        hideMainUI = true
      })
    end
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICityVisitor, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.param)
end

function VisitorUnit:OnArrivalTerminal()
  self.animator:SetTrigger(Const.animation.Idle)
end

function VisitorUnit:OnConfirmClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerDetail, {anim = true}, nil, nil, self.workerData, function()
    self:OnDelayClick(function()
      SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 1)
    end)
  end)
end

function VisitorUnit:CancelClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerDetail, {anim = true}, nil, nil, self.workerData, function()
    self:OnDelayClick(function()
      SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 0)
    end)
  end)
end

function VisitorUnit:FinishVisitor()
end

function VisitorUnit:OnFinish()
end

function VisitorUnit:__delete()
  if self.allRotateTweens then
    for _, tween in pairs(self.allRotateTweens) do
      tween:Kill()
    end
    self.allRotateTweens = nil
  end
  self:ResetChildModelRotate()
  self:RemoveListener()
  self:ClearData()
end

function VisitorUnit:ShowNextInfo()
  local nextModel = DataCenter.CityVisitorManager:GetNextVisitor(self.visitorData)
  if nextModel then
    self.showNextVisitor = TimerManager:GetInstance():DelayInvoke(function()
      if nextModel then
        nextModel:OnTriggerClick()
      end
    end, 0.5)
  end
end

function VisitorUnit:ClearData()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
  end
  if self.showNextVisitor then
    self.showNextVisitor:Stop()
    self.showNextVisitor = nil
  end
  if self.cilickDelay then
    self.cilickDelay:Stop()
    self.cilickDelay = nil
  end
  if not IsNull(self.gameObject) then
    self.gameObject.tag = untaggerTag
  end
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
  end
  if not IsNull(self.modelTrigger) then
    self.modelTrigger.onPointerClick = nil
  end
  self.transform = nil
  self.transformValid = nil
  self.gameObject = nil
  self.gameObjectValid = nil
  if self.req then
    self.req:Destroy()
  end
  if self.createDelay then
    self.createDelay:Stop()
    self.createDelay = nil
  end
  if self.delay then
    self.delay:Stop()
  end
  if not IsNull(self.tipRoot) and not IsNull(self.tipRoot.gameObject) then
    self.tipRoot.gameObject:SetActive(false)
    self.tipRoot = nil
  end
  self.updateTimer = nil
  self.update = nil
  self.req = nil
  self.position = nil
  self.isConfirmClick = false
  self.isVisible = nil
  self.visitorData = nil
  self.callBack = nil
  self.endPos = nil
  self.startPos = nil
  self.isArrival = nil
  self.isCreate = nil
  self.trigger = nil
  self.modelTrigger = nil
  self.icon_sprite = nil
  self.uid = nil
  self.simpleAnims = nil
  self.angleInfoArr = nil
  self.rotateTime = nil
  self.allChildOriAngle = nil
end

function VisitorUnit:AddListener()
  function self.BaseTempSudenChangeFun()
    self:BaseTempSudenChange()
  end
  
  EventManager:GetInstance():AddListener(EventId.MyBaseTemperatureChangeSuddenChange, self.BaseTempSudenChangeFun)
end

function VisitorUnit:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.MyBaseTemperatureChangeSuddenChange, self.BaseTempSudenChangeFun)
  self.BaseTempSudenChangeFun = nil
  if self.playPlotFinish then
    EventManager:GetInstance():RemoveListener(EventId.GF_plot_group_done, self.playPlotFinish)
    self.playPlotFinish = nil
  end
end

function VisitorUnit:BaseTempSudenChange()
  if self.gameObject ~= nil and self.param ~= nil and self.param.isNewLogic and self.param.dialogType == VisitorDialogType.TemperatureLogic then
    local tempIndex = self:GetTempIndex()
    if self.param.tempIndex ~= tempIndex then
      local iconPath = self.param.iconName[tempIndex]
      self.param.tempIndex = tempIndex
      if self.cancel_icon then
        self.cancel_icon:LoadSprite(string.format(UIAssets.UIVisitorTipImagePath, iconPath))
      end
    end
  end
end

function VisitorUnit:CheckSpecialCondition()
  return self.param.specialCondition and not string.IsNullOrEmpty(LuaEntry.Player.allianceId) and LuaEntry.Player.allianceId == self.param.specialCondition
end

function VisitorUnit:GetDesList()
  local desList = self.param.desList
  if self:CheckSpecialCondition() and self.param.specialDesList then
    desList = self.param.specialDesList
  end
  return desList
end

function VisitorUnit:SetFinishTargetPos()
  local endPos = {}
  if self.param and self:CheckSpecialCondition() and self.param.specialEndPos then
    if self.curendPos then
      table.insert(endPos, Vector3.New(self.curendPos.x, self.curendPos.y, self.curendPos.z))
    end
    table.insert(endPos, self.param.specialEndPos)
  else
    if self.curendPos then
      table.insert(endPos, Vector3.New(self.curendPos.x - 2, self.curendPos.y, self.curendPos.z))
    end
    table.insert(endPos, self.visitorData:GetStartPos())
  end
  self:SetTargetEndPos(endPos)
end

function VisitorUnit:PlayAni(aniName)
  if self.simpleAnims == nil then
    return
  end
  for i = 0, self.simpleAnims.Length - 1 do
    self.simpleAnims[i]:Play(aniName)
  end
end

function VisitorUnit:RotateAngleWhenArrive(excuteWhenRotateFinish)
  if not self.angleInfoArr or not self.rotateTime then
    excuteWhenRotateFinish()
    return
  end
  local angleValueArr = string.split(self.angleInfoArr, ",")
  if #angleValueArr ~= self.simpleAnims.Length then
    excuteWhenRotateFinish()
    return
  end
  if self.allRotateTweens then
    for _, tween in pairs(self.allRotateTweens) do
      tween:Kill()
    end
    self.allRotateTweens = nil
  end
  self.allRotateTweens = {}
  self.allChildOriAngle = {}
  for i = 0, self.simpleAnims.Length - 1 do
    local rotateTrans = self.simpleAnims[i].gameObject.transform
    local oriAngle = {}
    local rotateAngle = tonumber(angleValueArr[i + 1])
    oriAngle.x = rotateTrans.localRotation.eulerAngles.x
    oriAngle.y = rotateTrans.localRotation.eulerAngles.y
    oriAngle.z = rotateTrans.localRotation.eulerAngles.z
    table.insert(self.allChildOriAngle, oriAngle)
    local tween = rotateTrans:DORotate(Vector3(0, rotateAngle, 0), self.rotateTime, CS.DG.Tweening.RotateMode.LocalAxisAdd)
    table.insert(self.allRotateTweens, tween)
    local isLast = i == self.simpleAnims.Length - 1
    if isLast then
      tween:OnComplete(excuteWhenRotateFinish)
    end
  end
end

function VisitorUnit:ResetChildModelRotate()
  if not (self.allChildOriAngle and self.simpleAnims) or #self.allChildOriAngle ~= self.simpleAnims.Length then
    return
  end
  local index = 0
  for _, angle in ipairs(self.allChildOriAngle) do
    if self.simpleAnims[index].gameObject.transform ~= nil then
      self.simpleAnims[index].gameObject.transform.localRotation = Quaternion.Euler(angle.x, angle.y, angle.z)
    end
    index = index + 1
  end
end

function VisitorUnit:OnVisitorFinishTrigger()
  self:ResetChildModelRotate()
end

return VisitorUnit
