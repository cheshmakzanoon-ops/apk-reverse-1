local AttackCityMonsterDeadAnimObj = BaseClass("AttackCityMonsterDeadAnimObj")
local ResourceManager = CS.GameEntry.Resource
local delTextPath = "Assets/Main/Prefabs/UI/Common/UIWorldMonsterDelText.prefab"
local diaId = "pic_name_02"
local timerDelay = 0.01
local totalTime = 2

local function __init(self)
  self.pointUUid = nil
  self.anim = nil
  self.nowTime = nil
  self.keyId = nil
  self.gameObject = nil
  
  function self.timer_action()
    self:Update()
  end
end

local function __delete(self)
  self:OnDestroy()
  self.pointUUid = nil
  self.anim = nil
  self.nowTime = nil
  self.keyId = nil
  self.gameObject = nil
  self.timer_action = nil
end

local function ShowPointAnim(self, pointId, prefabPath)
  self.pointUUid = pointId
  self.keyId = pointId
  local prefab = prefabPath
  local startPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
  if self.airInst then
    self.airInst:Destroy()
    self.airInst = nil
  end
  local airInst = ResourceManager:InstantiateAsync(prefab)
  airInst:completed("+", function()
    self.gameObject = airInst.gameObject
    airInst.gameObject.transform:Set_position(startPos.x, startPos.y, startPos.z)
    airInst.gameObject.transform.eulerAngles = Vector3.New(0, 180, 0)
    self.anim = airInst.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self.anim:Play("dead")
    self:DisplayDeadTipText(self.gameObject.transform)
    self.nowTime = 0
    self:AddTimer()
    self:Update()
  end)
  self.airInst = airInst
end

local function DisplayDeadTipText(self, trans)
  if string.IsNullOrEmpty(diaId) then
    return
  end
  local context = CS.GameEntry.Localization:GetString(diaId)
  
  local function setTextCallback(text)
    if text then
      text.text = context
    end
  end
  
  local req = CS.GameEntry.Resource:InstantiateAsync(delTextPath)
  req:completed("+", function(req)
    if req.isError then
      req:Destroy()
      return
    end
    if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.World then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local tf = go.transform
    tf.parent = trans
    local text = tf:Find("VFX_defeatNoUI/zi_text"):GetComponent(typeof(CS.TextMeshProEx))
    setTextCallback(text)
    tf:Set_localPosition(0, 3.55, 0)
    tf.localScale = ResetScale
    go:SetActive(true)
  end)
  self.deadTextReq = req
end

local function OnDestroy(self)
  DataCenter.AttackCityAnimManager:RemovePointOneAnimObj(self)
  if self.deadTextReq then
    self.deadTextReq:Destroy()
    self.deadTextReq = nil
  end
  if self.airInst then
    self.airInst:Destroy()
    self.airInst = nil
  end
  self:DeleteTimer()
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(timerDelay, self.timer_action, self, false, true, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function Update(self)
  if self.nowTime >= totalTime then
    self:OnDestroy()
  else
    self.nowTime = self.nowTime + Time.deltaTime
  end
end

AttackCityMonsterDeadAnimObj.__init = __init
AttackCityMonsterDeadAnimObj.__delete = __delete
AttackCityMonsterDeadAnimObj.OnDestroy = OnDestroy
AttackCityMonsterDeadAnimObj.ShowPointAnim = ShowPointAnim
AttackCityMonsterDeadAnimObj.AddTimer = AddTimer
AttackCityMonsterDeadAnimObj.DeleteTimer = DeleteTimer
AttackCityMonsterDeadAnimObj.Update = Update
AttackCityMonsterDeadAnimObj.DisplayDeadTipText = DisplayDeadTipText
return AttackCityMonsterDeadAnimObj
