local UIFactoryBoxModel = require("UI.UIFactory.Component.UIFactoryBoxModel")
local UIFactoryRobotModel = require("UI.UIFactory.Component.UIFactoryRobotModel")
local UIFactoryModel = BaseClass("UIFactoryModel")
local ResourceManager = CS.GameEntry.Resource
local Physics = CS.UnityEngine.Physics
local left_anim_path = "leftObj"
local right_anim_path = "rightObj"
local door_anim_path = "doorObj"
local transport_anim_path = "transportObj"
local box_list_path = "BoxModel"
local smoke_effect_path = "smokeEffect"
local camera1_path = "camera1"
local main_camera_path = "camera"
local isSpeedUp = false
local isAddbox = false
local largeGap = 1.326
local AnimatorState = {
  None = 0,
  QuitAnim = 1,
  AddAnimAfterQuit = 2,
  MoveAnim = 3,
  AddAnim = 4,
  AddResToBox = 5,
  AddResToBoxAndMove = 6
}
local camera_gap = 10

local function OnCreate(self, go, ctrl)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self.request = go
  self:ComponentDefine()
  self:DataDefine()
  self.ctrl = ctrl
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.left_anim = self.transform:Find(left_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.right_anim = self.transform:Find(right_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.door_anim = self.transform:Find(door_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.transport_anim = self.transform:Find(transport_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.smoke_effect = self.transform:Find(smoke_effect_path).gameObject
  self.box_list = self.transform:Find(box_list_path).transform
  local cam = self.transform:Find(camera1_path)
  if cam ~= nil then
    self.camera = cam:GetComponent(typeof(CS.UnityEngine.Camera))
  end
  local main = self.transform:Find(main_camera_path)
  if main ~= nil then
    self.mainCamera = main:GetComponent(typeof(CS.UnityEngine.Camera))
  end
  self.smoke_effect:SetActive(false)
  self:OnAddListener()
end

local function ComponentDestroy(self)
  self.left_anim = nil
  self.right_anim = nil
  self.door_anim = nil
  self.transport_anim = nil
  self.box_list = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.largeBoxPosList = {}
  table.insert(self.largeBoxPosList, Vector3.New(-4.024, 0.26, -0.419))
  table.insert(self.largeBoxPosList, Vector3.New(-2.059, 0.26, -0.419))
  self.smallBoxPosList = {}
  table.insert(self.smallBoxPosList, Vector3.New(-3.384, 0.26, -0.419))
  table.insert(self.smallBoxPosList, Vector3.New(-1.4, 0.26, -0.419))
  table.insert(self.smallBoxPosList, Vector3.New(-0.07, 0.26, -0.419))
  table.insert(self.smallBoxPosList, Vector3.New(1.26, 0.26, -0.419))
  table.insert(self.smallBoxPosList, Vector3.New(2.59, 0.26, -0.419))
  self.box = {}
  self.robot = {}
  self.creatingRobot = {}
  self.isInMove = false
  self.animationInfos = {}
  isSpeedUp = false
  isAddbox = false
  self.isTransport = false
end

local function DataDestroy(self)
  self.box = nil
  isSpeedUp = nil
  isAddbox = nil
end

local function UpdateAnimationState(self, index, state)
  if self.animationInfos[index] ~= nil then
    self.animationInfos[index].animationState = state
  end
end

local function UpdateAnimationDeltaTime(self, index, deltaTime)
  if self.animationInfos[index] ~= nil then
    self.animationInfos[index].deltaTime = deltaTime
  end
end

local function UpdateAnimationAnimatorTime(self, index, animatorTime)
  if self.animationInfos[index] ~= nil then
    self.animationInfos[index].animatorTime = animatorTime
  end
end

local function InitAnimationInfos(self, workingList)
  self.animationInfos = {}
  table.walk(workingList, function(_, v)
    local info = {}
    info.animationState = AnimatorState.None
    info.deltaTime = 0
    info.animatorTime = 0
    table.insert(self.animationInfos, info)
  end)
end

local function InitData(self)
  self.data = self.ctrl:GetProductData()
  self.isTransport = false
  self:InitAnimationInfos(self.data.workingList)
  if self.data.state == FactoryWorkState.Work then
    self.left_anim:Play("Zuobian_Xunhuan", 0, 0)
    self.right_anim:Play("Youbian_xunhuan", 0, 0)
    self.smoke_effect:SetActive(true)
  end
  self.box = {}
  local index = 0
  if self.data.boxDataList ~= nil then
    table.walk(self.data.boxDataList, function(k, v)
      local request = ResourceManager:InstantiateAsync(UIAssets.UIFactoryBoxModel)
      request:completed("+", function()
        if request.isError then
          return
        end
        index = index + 1
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(self.box_list)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local temp = UIFactoryBoxModel.New()
        temp:OnCreate(request, v)
        if self.data.state == FactoryWorkState.Work then
          local pos = Vector3.New(0, 0, 0)
          if self.data.isLargeModel then
            pos = self:GetPosByIndex(self:GetLargePos(index), index)
          elseif index <= #self.smallBoxPosList then
            pos = self:GetPosByIndex(self.smallBoxPosList[index], index)
          end
          temp:UpdatePos(pos)
          if self.data.states[index] == FactoryWorkState.Work then
            local num = math.random(1, 2)
            if num <= 1 then
              temp:InitWork(true)
              self:CreateRobot("Work", pos, true, index)
            else
              temp:InitWork(false)
              self:CreateRobot("Work", pos, false, index)
            end
          elseif v.itemId ~= nil then
            temp:InitClose()
          else
            temp:InitOpen()
          end
        elseif self.data.state == FactoryWorkState.Full then
          local pos = Vector3.New(0, 0, 0)
          if self.data.isLargeModel then
            pos = self:GetPosByIndex(self:GetLargePos(index), index)
          elseif index <= #self.smallBoxPosList then
            pos = self:GetPosByIndex(self.smallBoxPosList[index], index)
          end
          temp:UpdatePos(pos)
          if v.itemId ~= nil then
            temp:InitClose()
          else
            temp:InitOpen()
          end
        elseif self.data.state == FactoryWorkState.Free then
          local pos = Vector3.New(0, 0, 0)
          if self.data.isLargeModel then
            pos = self:GetPosByIndex(self:GetLargePos(index + 1), index + 1)
          else
            Logger.Log("get small list")
            if index < #self.smallBoxPosList then
              pos = self:GetPosByIndex(self.smallBoxPosList[index + 1], index + 1)
            end
          end
          temp:UpdatePos(pos)
          temp:InitOpen()
        end
        table.insert(self.box, temp)
      end)
    end)
  end
end

local function CreateRobot(self, para, pos, isRandomFirst, index)
  pos.y = self.largeBoxPosList[1].y
  if self.creatingRobot[index] == nil and self.robot[index] == nil then
    local request = ResourceManager:InstantiateAsync(UIAssets.UIFactoryRobotModel)
    self.creatingRobot[index] = request
    request:completed("+", function()
      if request.isError then
        return
      end
      self.creatingRobot[index] = nil
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(self.box_list)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.robot[index] = UIFactoryRobotModel.New()
      self.robot[index]:OnCreate(request, v)
      self.robot[index]:UpdatePos(pos)
      if para == "Add" then
        self.robot[index]:InitAdd()
      elseif para == "Work" then
        self.robot[index]:InitWork(isRandomFirst)
      elseif para == "ChangeWork" then
        self.robot[index]:ChangeToWork(isRandomFirst)
      elseif para == "Quit" then
        self.robot[index]:ChangeToQuit()
      end
    end)
  elseif self.robot[index] ~= nil then
    self.robot[index]:SetActive(true)
    self.robot[index]:UpdatePos(pos)
    if para == "Add" then
      self.robot[index]:InitAdd()
    elseif para == "Work" then
      self.robot[index]:InitWork(isRandomFirst)
    elseif para == "ChangeWork" then
      self.robot[index]:ChangeToWork(isRandomFirst)
    elseif para == "Quit" then
      self.robot[index]:ChangeToQuit()
    end
  end
end

local function GetProduct(self, index)
  self.data = self.ctrl:GetProductData()
  if index <= #self.box then
    self:UpdateAnimationState(index, AnimatorState.QuitAnim)
    self:UpdateAnimationDeltaTime(0)
    self:UpdateAnimationAnimatorTime(self.box[index]:GetEndAnimTime())
    self.box[index]:ChangeToQuit()
    self:CreateRobot("Quit", self.box[index]:GetCurPos(), false, index)
  end
  if self.data.state == FactoryWorkState.Free then
    self.left_anim:SetTrigger("finish")
    self.right_anim:SetTrigger("finish")
    self.smoke_effect:SetActive(false)
  end
end

local function AddBox(self, isAfterQuit)
  self.data = self.ctrl:GetProductData()
  local index = #self.box + 1
  local request = ResourceManager:InstantiateAsync(UIAssets.UIFactoryBoxModel)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(self.box_list)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local temp = UIFactoryBoxModel.New()
    temp:OnCreate(request, v)
    local pos = Vector3.New(0, 0, 0)
    if self.data.state == FactoryWorkState.Free or isAfterQuit then
      index = index + 1
    end
    if self.data.isLargeModel then
      pos = self:GetPosByIndex(self:GetLargePos(index), index)
    elseif index <= #self.smallBoxPosList then
      pos = self:GetPosByIndex(self.smallBoxPosList[index], index)
    end
    temp:UpdatePos(pos)
    temp:InitAdd()
    if isAfterQuit then
      self:UpdateAnimationState(index, AnimatorState.AddAnimAfterQuit)
    else
      self:UpdateAnimationState(index, AnimatorState.AddAnim)
    end
    self:UpdateAnimationAnimatorTime(index, temp:GetEnterAnimTime())
    self:UpdateAnimationDeltaTime(index, 0)
    table.insert(self.box, temp)
    self:MoveToLastBox()
    self:CreateRobot("Add", temp:GetCurPos(), false, index)
  end)
end

local function DoTransport(self)
  self.data = self.ctrl:GetProductData()
  if self.data.state ~= FactoryWorkState.Free then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Produce_Transport, false)
    self:UpdateAnimationDeltaTime(1, 0)
    if self.data.isLargeModel then
      local clips = self.transport_anim.runtimeAnimatorController.animationClips
      for i = 0, clips.Length - 1 do
        if clips[i].name == "Xiamian_changlvdai_yunxing" then
          self:UpdateAnimationAnimatorTime(1, clips[i].length)
        end
      end
    else
      local clips = self.transport_anim.runtimeAnimatorController.animationClips
      for i = 0, clips.Length - 1 do
        if clips[i].name == "Xiamian_duanlvdai_yunxing" then
          self:UpdateAnimationAnimatorTime(1, clips[i].length)
        end
      end
    end
    self.curPosArr = {}
    table.walk(self.box, function(k, v)
      local pos = v:GetCurPos()
      table.insert(self.curPosArr, pos)
    end)
    self:UpdateAnimationState(1, AnimatorState.MoveAnim)
    self.transport_anim:SetTrigger("move")
    self.door_anim:SetTrigger("open")
  else
    isSpeedUp = false
    table.walk(self.box, function(k, v)
      if self.data.isLargeModel then
        local pos = self:GetPosByIndex(self:GetLargePos(k + 1), k + 1)
        v:UpdatePos(pos)
      else
        local pos = self:GetPosByIndex(self.smallBoxPosList[k + 1], k + 1)
        v:UpdatePos(pos)
      end
    end)
  end
  EventManager:GetInstance():Broadcast(EventId.FactoryTransportAnimationStart)
end

local function StartWork(self, index)
  self.data = self.ctrl:GetProductData()
  local states = self.data.states
  if #self.box > 0 then
    table.walk(states, function(k, v)
      if v == FactoryWorkState.Work then
        if index ~= nil and k ~= index then
          return
        end
        local num = math.random(1, 2)
        if num <= 1 then
          self.box[k]:ChangeToWork(true, self.data.boxDataList[index])
          self:CreateRobot("ChangeWork", self.box[k]:GetCurPos(), true, k)
        else
          self.box[k]:ChangeToWork(false, self.data.boxDataList[index])
          self:CreateRobot("ChangeWork", self.box[k]:GetCurPos(), false, k)
        end
      end
    end)
  end
  if self.data.state == FactoryWorkState.Work then
    self.left_anim:SetTrigger("work")
    self.right_anim:SetTrigger("work")
    self.smoke_effect:SetActive(true)
  end
end

local function AddResToBox(self, boxNum, boxData, needTransAnim)
  self.data = self.ctrl:GetProductData()
  if self.box[boxNum] ~= nil then
    if self.data.states[boxNum] == FactoryWorkState.Work and not needTransAnim then
      self:StartWork(boxNum)
    else
      self.box[boxNum]:ChangeToClose(boxData)
    end
    if needTransAnim then
      self:UpdateAnimationState(boxNum, AnimatorState.AddResToBoxAndMove)
      self:UpdateAnimationDeltaTime(boxNum, 0)
      self:UpdateAnimationAnimatorTime(boxNum, self.box[boxNum]:GetCloseAnimTime())
      self.isTransport = needTransAnim
    end
  end
end

local function AddIconToBox(self, boxNum, boxData, needTransAnim)
  if self.box[boxNum] ~= nil then
    self.box[boxNum]:showIcon(boxData)
  end
end

local function RemoveIconToBox(self, boxNum, boxData, needTransAnim)
  if self.box[boxNum] ~= nil then
    self.box[boxNum]:hideIcon(boxData)
  end
end

local function Update(self)
  table.walk(self.animationInfos, function(index, info)
    if info.animationState ~= AnimatorState.None then
      info.deltaTime = info.deltaTime + Time.deltaTime
      if info.deltaTime >= info.animatorTime or isSpeedUp == true then
        if info.animationState == AnimatorState.QuitAnim then
          if index <= #self.box then
            if self.data.states[index] == nil then
              info.animationState = AnimatorState.None
              info.deltaTime = 0
              info.animatorTime = 0
              if self.robot[index] ~= nil then
                self.robot[index]:SetActive(false)
              end
              self.box[index]:ChangeToOpen()
            elseif self.data.state == FactoryWorkState.Full then
              info.animationState = AnimatorState.None
              info.deltaTime = 0
              info.animatorTime = 0
              table.walk(self.robot, function(_, v)
                if v ~= nil then
                  v:SetActive(false)
                end
              end)
              local deleteIndex = #self.data.workingList + 1
              local tmpIndex = 1
              while deleteIndex > tmpIndex do
                if tmpIndex ~= index then
                  self.box[tmpIndex]:InitClose()
                end
                tmpIndex = tmpIndex + 1
              end
              local max = #self.box
              if deleteIndex <= max and self.box[deleteIndex].data ~= nil and 0 < table.count(self.box[deleteIndex].data) then
                self.box[index]:ChangeToClose(self.box[deleteIndex].data)
                self.box[index]:InitClose()
                self.box[deleteIndex]:ChangeToOpen()
                local currentIndex = deleteIndex
                while max >= currentIndex do
                  if max >= currentIndex + 1 and self.box[currentIndex + 1].data ~= nil and 0 < table.count(self.box[currentIndex + 1].data) then
                    self.box[currentIndex]:ChangeToClose(self.box[currentIndex + 1].data)
                    self.box[currentIndex + 1]:ChangeToOpen()
                  end
                  currentIndex = currentIndex + 1
                end
              end
            else
              info.animationState = AnimatorState.None
              info.deltaTime = 0
              info.animatorTime = 0
              if self.robot[index] ~= nil then
                self.robot[index]:SetActive(false)
              end
              if self.data.states[index] == FactoryWorkState.Work then
                self:StartWork(index)
                local deleteIndex = #self.data.workingList + 1
                local max = #self.box
                if deleteIndex <= max and self.box[deleteIndex].data ~= nil and 0 < table.count(self.box[deleteIndex].data) then
                  self.box[deleteIndex]:ChangeToOpen()
                  local currentIndex = deleteIndex
                  while max >= currentIndex do
                    if max >= currentIndex + 1 and self.box[currentIndex + 1].data ~= nil and 0 < table.count(self.box[currentIndex + 1].data) then
                      self.box[currentIndex]:ChangeToClose(self.box[currentIndex + 1].data)
                      self.box[currentIndex + 1]:ChangeToOpen()
                    end
                    currentIndex = currentIndex + 1
                  end
                end
              elseif self.data.states[index] == FactoryWorkState.Free then
                if index == 1 and self.data.state == FactoryWorkState.Free then
                  self.box[index]:DestroySelf()
                  table.remove(self.box, index)
                  self:AddBox(true)
                else
                  self.box[index]:InitOpen()
                end
              end
            end
          end
        elseif info.animationState == AnimatorState.AddAnimAfterQuit then
          info.animationState = AnimatorState.None
          info.deltaTime = 0
          info.animatorTime = 0
          if self.robot[index] ~= nil then
            self.robot[index]:SetActive(false)
          end
          self:DoTransport()
        elseif info.animationState == AnimatorState.AddAnim then
          info.animationState = AnimatorState.None
          info.deltaTime = 0
          info.animatorTime = 0
          if self.robot[index] ~= nil then
            self.robot[index]:SetActive(false)
          end
          if self.data.state == FactoryWorkState.Work then
            isAddbox = false
            table.walk(self.box, function(k, v)
              if self.data.isLargeModel then
                local pos = self:GetPosByIndex(self:GetLargePos(k), k)
                v:UpdatePos(pos)
              else
                local pos = self:GetPosByIndex(self.smallBoxPosList[k], k)
                v:UpdatePos(pos)
              end
            end)
            self:StartWork()
          else
            table.walk(self.box, function(k, v)
              if self.data.isLargeModel then
                local pos = self:GetPosByIndex(self:GetLargePos(k + 1), k + 1)
                v:UpdatePos(pos)
              else
                local pos = self:GetPosByIndex(self.smallBoxPosList[k + 1], k + 1)
                v:UpdatePos(pos)
              end
            end)
          end
        elseif info.animationState == AnimatorState.MoveAnim then
          isSpeedUp = false
          isAddbox = false
          table.walk(self.box, function(k, v)
            if self.data.isLargeModel then
              local pos = self:GetPosByIndex(self:GetLargePos(k), k)
              v:UpdatePos(pos)
            else
              local pos = self:GetPosByIndex(self.smallBoxPosList[k], k)
              v:UpdatePos(pos)
            end
          end)
          info.animationState = AnimatorState.None
          info.deltaTime = 0
          info.animatorTime = 0
          self.door_anim:SetTrigger("close")
          if self.data.state == FactoryWorkState.Work then
            self:StartWork()
          end
          self.isTransport = false
          EventManager:GetInstance():Broadcast(EventId.FactoryTransportAnimationEnd)
        elseif info.animationState == AnimatorState.AddResToBoxAndMove then
          info.animationState = AnimatorState.None
          info.deltaTime = 0
          info.animatorTime = 0
          self:DoTransport()
        end
      elseif info.animationState == AnimatorState.MoveAnim then
        if table.count(self.curPosArr) ~= table.count(self.box) then
          self.curPosArr = {}
          table.walk(self.box, function(k, v)
            local pos = v:GetCurPos()
            table.insert(self.curPosArr, pos)
          end)
        end
        table.walk(self.box, function(k, v)
          if self.data.isLargeModel then
            local pos = Vector3.Lerp(self:GetPosByIndex(self.curPosArr[k], k), self:GetPosByIndex(self:GetLargePos(k), k), info.deltaTime / info.animatorTime)
            v:UpdatePos(pos)
          else
            local pos = Vector3.Lerp(self.curPosArr[k], self.smallBoxPosList[k], info.deltaTime / info.animatorTime)
            v:UpdatePos(pos)
          end
        end)
      end
    end
  end)
end

local function DestroySelf(self)
  if #self.box > 0 then
    table.walk(self.box, function(k, v)
      v:DestroySelf()
    end)
  end
  if self.robot ~= nil then
    table.walk(self.robot, function(_, v)
      v:DestroySelf()
    end)
  end
  if self.creatingRobot ~= nil then
    for k, v in pairs(self.creatingRobot) do
      v:Destroy()
    end
  end
  self.request:Destroy()
  self:OnRemoveListener()
end

local function OnAddListener(self)
  EventManager:GetInstance():AddListener(EventId.SkipFactoryAni, self.SkipFactorySpeedUp)
  EventManager:GetInstance():AddListener(EventId.AddFactoryBox, self.SkipAddBox)
end

local function OnRemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.SkipFactoryAni, self.SkipFactorySpeedUp)
  EventManager:GetInstance():RemoveListener(EventId.AddFactoryBox, self.SkipAddBox)
end

local function SkipFactorySpeedUp(self)
  isSpeedUp = true
end

local function SkipAddBox(self)
  isAddbox = true
end

local function DragBox(self, diffX, isDragMove)
  if self.box == nil then
    return
  end
  local count = #self.box
  if count == 0 then
    return
  end
  local firstIndex = 1
  local lastIndex = count
  if not self.data.isLargeModel then
    return
  end
  if self.isTransport then
    return
  end
  local isWorking = self.data.state ~= FactoryWorkState.Free
  local hasQueueToBuy = self.data.showAddBox
  if isWorking then
    firstIndex = 2
    if hasQueueToBuy then
      if count <= FactoryMaxShowWaitQueue and isDragMove then
        return
      end
    elseif count <= FactoryMaxShowWaitQueue + 1 and isDragMove then
      return
    end
  elseif hasQueueToBuy then
    if count <= FactoryMaxShowWaitQueue - 1 and isDragMove then
      return
    end
  elseif count <= FactoryMaxShowWaitQueue and isDragMove then
    return
  end
  local first = self.box[firstIndex]
  local last = self.box[lastIndex]
  if first.transform.position.x + diffX > self.largeBoxPosList[2].x then
    diffX = self.largeBoxPosList[2].x - first.transform.position.x
  end
  local lastPosIndex = FactoryMaxShowWaitQueue + 1
  if hasQueueToBuy then
    lastPosIndex = lastPosIndex - 1
  end
  local pos = self:GetLargePos(lastPosIndex)
  if last.transform.position.x + diffX < pos.x - 0.2 then
    diffX = pos.x - 0.2 - last.transform.position.x
  end
  for k, v in ipairs(self.box) do
    if k >= firstIndex then
      local pos = v.transform.position
      local posX = pos.x + diffX
      v.transform.position = Vector3.New(posX, pos.y, pos.z)
    end
  end
end

local function MoveToFirstBox(self)
  self:DragBox(10000, true)
end

local function MoveToLastBox(self)
  self:DragBox(-10000, true)
end

local function GetPosByIndex(self, pos, index, force)
  local isWorking = self.data.state ~= FactoryWorkState.Free
  if isWorking and (index == 1 or force) and self.data.isLargeModel then
    return Vector3.New(pos.x, pos.y + camera_gap, pos.z)
  end
  return pos
end

local function GetLargePos(self, index)
  local largeCount = #self.largeBoxPosList
  if index <= largeCount then
    return self.largeBoxPosList[index]
  end
  local startPt = self.largeBoxPosList[largeCount]
  return Vector3.New(startPt.x + (index - largeCount) * largeGap, startPt.y, startPt.z)
end

local function SetBoxCamera(self, showAddBox)
  if self.camera then
    if showAddBox then
      self.camera.fieldOfView = 12.2
      local pos = self.camera.gameObject.transform.localPosition
      pos.x = -0.2
      self.camera.gameObject.transform.localPosition = pos
    else
      self.camera.fieldOfView = 15
      local pos = self.camera.gameObject.transform.localPosition
      pos.x = 0.4
      self.camera.gameObject.transform.localPosition = pos
    end
  end
end

local function OnPointerClick(self, pos)
  local effect = LuaEntry.Effect:GetGameEffect(EffectDefine.FACTORY_CANCEL_EFFECT_ID)
  if effect <= 0 then
    return
  end
  
  local function ResetPos(pos, s, diffX, diffY)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local screenW = Screen.width
    local screenH = Screen.height
    local designW = 1920
    local designH = 1080
    local realH = designH * s * scaleFactor
    local realW = designW * s * scaleFactor
    local x = (pos.x - diffX - (screenW - realW) / 2) / (s * scaleFactor)
    local y = (pos.y - diffY - (screenH - realH) / 2) / (s * scaleFactor)
    pos.x = x
    pos.y = y
  end
  
  if self.camera ~= nil then
    if self.data.showAddBox then
      ResetPos(pos, 0.3, 25, 0)
    else
      ResetPos(pos, 0.36, 80, 0)
    end
    local ray = self.camera:ScreenPointToRay(pos)
    CS.UnityEngine.Debug.DrawRay(ray.origin, ray.direction, CS.UnityEngine.Color.red, 1000, true)
    local hits = Physics.RaycastAll(ray, SceneTouchDistance, LayerMask.GetMask("UIObject3D"))
    if hits ~= nil then
      for i = 0, hits.Length - 1 do
        local touchObj = hits[i].collider:GetComponent(typeof(CS.TouchObjectEventTrigger))
        if touchObj ~= nil and touchObj.onPointerClick ~= nil then
          touchObj.onPointerClick()
          return
        end
      end
    end
  end
  if self.mainCamera ~= nil then
    ResetPos(pos, 0.7, 0, 0)
    local ray = self.mainCamera:ScreenPointToRay(pos)
    local hits = Physics.RaycastAll(ray, SceneTouchDistance, LayerMask.GetMask("UIObject3D"))
    if hits ~= nil then
      for i = 0, hits.Length - 1 do
        local touchObj = hits[i].collider:GetComponent(typeof(CS.TouchObjectEventTrigger))
        if touchObj ~= nil and touchObj.onPointerClick ~= nil then
          touchObj.onPointerClick()
          return
        end
      end
    end
  end
end

UIFactoryModel.OnPointerClick = OnPointerClick
UIFactoryModel.SetBoxCamera = SetBoxCamera
UIFactoryModel.GetLargePos = GetLargePos
UIFactoryModel.GetPosByIndex = GetPosByIndex
UIFactoryModel.MoveToFirstBox = MoveToFirstBox
UIFactoryModel.MoveToLastBox = MoveToLastBox
UIFactoryModel.DragBox = DragBox
UIFactoryModel.OnCreate = OnCreate
UIFactoryModel.OnDestroy = OnDestroy
UIFactoryModel.ComponentDefine = ComponentDefine
UIFactoryModel.ComponentDestroy = ComponentDestroy
UIFactoryModel.DataDefine = DataDefine
UIFactoryModel.DataDestroy = DataDestroy
UIFactoryModel.InitData = InitData
UIFactoryModel.CreateRobot = CreateRobot
UIFactoryModel.GetProduct = GetProduct
UIFactoryModel.AddBox = AddBox
UIFactoryModel.DoTransport = DoTransport
UIFactoryModel.StartWork = StartWork
UIFactoryModel.Update = Update
UIFactoryModel.DestroySelf = DestroySelf
UIFactoryModel.AddResToBox = AddResToBox
UIFactoryModel.AddIconToBox = AddIconToBox
UIFactoryModel.RemoveIconToBox = RemoveIconToBox
UIFactoryModel.OnAddListener = OnAddListener
UIFactoryModel.OnRemoveListener = OnRemoveListener
UIFactoryModel.SkipFactorySpeedUp = SkipFactorySpeedUp
UIFactoryModel.SkipAddBox = SkipAddBox
UIFactoryModel.UpdateAnimationState = UpdateAnimationState
UIFactoryModel.UpdateAnimationDeltaTime = UpdateAnimationDeltaTime
UIFactoryModel.UpdateAnimationAnimatorTime = UpdateAnimationAnimatorTime
UIFactoryModel.InitAnimationInfos = InitAnimationInfos
return UIFactoryModel
