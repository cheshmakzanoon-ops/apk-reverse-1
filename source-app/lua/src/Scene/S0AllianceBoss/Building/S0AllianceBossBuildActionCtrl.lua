local S0AllianceBossBuildActionCtrl = BaseClass("S0AllianceBossBuildActionCtrl")
local BUBBLE_PATH = "Assets/Main/Prefabs/March/WorldS0AllyDrillDonate.prefab"
local WORLD_MODEL_PATH = "Model/WorldModel"
local MODEL_LABEL_PATH = "ModelLabel"

function S0AllianceBossBuildActionCtrl:__init(uuid, transform)
  self.uuid = uuid
  self.transform = transform
  self.timer = nil
  self.bubbleGo = nil
  self.bubbleReq = nil
  self.bubbleSimpleAnim = nil
  self.simpleAnimation = nil
  self.touchEvent = nil
  self.pointId = nil
  self:InitModelData(transform)
end

function S0AllianceBossBuildActionCtrl:__delete()
  self:Destroy()
end

local function Destroy(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.bubbleGo = nil
  if self.bubbleReq then
    self.bubbleReq:Destroy()
    self.bubbleReq = nil
  end
  self.bubbleSimpleAnim = nil
  self.simpleAnimation = nil
  self.touchEvent = nil
  self.uuid = nil
  self.transform = nil
  self.pointId = nil
end

local function Refresh(self, uuid, transform)
  self.uuid = uuid
  self.transform = transform
  self:InitModelData(transform)
end

local function InitModelData(self, transform)
  if IsNull(transform) then
    return
  end
  self.pointId = nil
  if self.uuid and CS.SceneManager.World then
    local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
    if info then
      self.pointId = info.pointIndex
      self:CheckBubbleShow(info)
    else
      self:SetBuildBubbleShow(false)
    end
  else
    self:SetBuildBubbleShow(false)
  end
  local worldModel = transform:Find(WORLD_MODEL_PATH)
  if IsNull(worldModel) then
    Logger.LogError("S0AllianceBoss -- worldModel not found")
    return
  end
  self.simpleAnimation = worldModel:GetComponentInChildren(typeof(CS.SimpleAnimation))
end

local function CheckBubbleShow(self, info)
  if info and info.buildPointInfo and LuaEntry.Player.allianceId == info.buildPointInfo.allianceId then
    local _battleStartTime = info.buildPointInfo.startTime
    if 0 < _battleStartTime then
      self:SetBuildBubbleShow(DataCenter.S0AllianceBossDataManager:CheckBuildBubbleShow())
      return
    end
  end
  self:SetBuildBubbleShow(false)
end

local function SetBuildBubbleShow(self, show)
  self.showBubble = show
  if show then
    self:ShowBuildBubble()
  elseif self.bubbleGo then
    self:PlayBubbleAnim("out", function()
      if self.bubbleGo then
        self.bubbleGo:SetActive(false)
      end
    end)
  end
end

local function ShowBuildBubble(self)
  if self.bubbleGo then
    self.bubbleGo:SetActive(true)
    self:PlayBubbleAnim("Default")
  elseif self.bubbleReq then
  else
    local request = CS.GameEntry.Resource:InstantiateAsync(BUBBLE_PATH)
    request:completed("+", function(req)
      if req.isError then
        req:Destroy()
        return
      end
      if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.World or IsNull(CS.SceneManager.World) then
        req:Destroy()
        return
      end
      local go = req.gameObject
      local tf = go.transform
      self.bubbleGo = go
      self.bubbleSimpleAnim = tf:GetComponentInChildren(typeof(CS.SimpleAnimation))
      tf:SetParent(CS.SceneManager.World.DynamicObjNode)
      if self.transform then
        local pos = self.transform.position
        tf:Set_localPosition(pos.x, pos.y, pos.z)
      end
      go:SetActive(self.showBubble)
      if self.showBubble then
        self:PlayBubbleAnim("Default")
      end
      self.touchEvent = tf:Find("LodRoot/Transform/Item/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
      if self.touchEvent then
        self.touchEvent.previewType = WorldPreviewType.HighThanMultiObjects
        
        function self.touchEvent.onPointerClick()
          self:OnClick()
        end
      end
    end)
    self.bubbleReq = request
  end
end

local function PlayBubbleAnim(self, animName, callback)
  if self.bubbleSimpleAnim == nil then
    return
  end
  if string.IsNullOrEmpty(animName) then
    animName = "Default"
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if callback then
    local length = self.bubbleSimpleAnim:GetClipLength(animName)
    if 0 < length then
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        callback()
        if self.timer then
          self.timer:Stop()
          self.timer = nil
        end
      end, length)
    else
      callback()
    end
  end
  if self.bubbleSimpleAnim:IsPlaying(animName) then
    self.bubbleSimpleAnim:Rewind(animName)
  end
  self.bubbleSimpleAnim:Play(animName)
end

local function OnBuildDonatedSuccess(self, uuid)
  if uuid == self.uuid and CS.SceneManager.World then
    local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(uuid)
    if pointInfo then
      self:CheckBubbleShow(pointInfo)
    end
  end
end

local function OnClick(self)
  DataCenter.S0AllianceBossDataManager:GoToDonatePanel()
end

local function SetBuildingState(self, hide, cancel)
  if self.pointId then
    if hide then
      CS.SceneManager.World:HideObject(self.pointId)
    else
      CS.SceneManager.World:ShowObject(self.pointId)
      if cancel and self.simpleAnimation then
        self.simpleAnimation:Play("idle")
      end
    end
  end
end

S0AllianceBossBuildActionCtrl.InitModelData = InitModelData
S0AllianceBossBuildActionCtrl.CheckBubbleShow = CheckBubbleShow
S0AllianceBossBuildActionCtrl.SetBuildBubbleShow = SetBuildBubbleShow
S0AllianceBossBuildActionCtrl.ShowBuildBubble = ShowBuildBubble
S0AllianceBossBuildActionCtrl.PlayBubbleAnim = PlayBubbleAnim
S0AllianceBossBuildActionCtrl.OnBuildDonatedSuccess = OnBuildDonatedSuccess
S0AllianceBossBuildActionCtrl.Destroy = Destroy
S0AllianceBossBuildActionCtrl.Refresh = Refresh
S0AllianceBossBuildActionCtrl.OnClick = OnClick
S0AllianceBossBuildActionCtrl.SetBuildingState = SetBuildingState
return S0AllianceBossBuildActionCtrl
