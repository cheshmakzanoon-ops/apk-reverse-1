local ActGhostreconAnimManager = BaseClass("ActGhostreconAnimManager", CEventable)
local ActGhostreconAnimPoint = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconAnimPoint")
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self.animPoints = {}
  self:AddListener()
end

local function __delete(self)
  self:RemoveAllPoint()
end

local function AddListener(self)
  self:RegisterEvent(EventId.OnEnterCity, self.RemoveAllPoint)
  self:RegisterEvent(EventId.WORLD_BUILD_OUT_VIEW, self.RemovePointAnim)
end

local function ShowPointAnim(self, pointUUid, memberList, isStart, serverId)
  if self.animPoints[pointUUid] == nil then
    self.animPoints[pointUUid] = ActGhostreconAnimPoint.New()
  end
  self.animPoints[pointUUid]:ShowPointAnim(pointUUid, memberList, isStart, serverId)
end

local function RemovePointAnim(self, pointUUid)
  pointUUid = tonumber(pointUUid)
  if self.animPoints[pointUUid] then
    self.animPoints[pointUUid]:OnDestroy()
    self.animPoints[pointUUid] = nil
  end
end

local function RemovePointOneAnimObj(self, animObj)
  if animObj and animObj.pointUUid and self.animPoints[animObj.pointUUid] then
    self.animPoints[animObj.pointUUid]:RemoveOneAnimObj(animObj)
  end
end

local function RemoveAllPoint(self)
  if self.animPoints then
    for key, value in pairs(self.animPoints) do
      value:OnDestroy()
    end
    self.animPoints = {}
  end
end

local function ShowWorldFingerArrow(self, pos, scale, closeTime, uuid)
  if not self.fingerArrowObj then
    self.fingerArrowObj = ResourceManager:InstantiateAsync(UIAssets.WorldFingerArrow)
    self.fingerArrowObj:completed("+", function()
      if self.fingerArrowObj.isError then
        return
      end
      self.fingerArrowObj.gameObject:SetActive(true)
      if scale then
        self.fingerArrowObj.gameObject.transform:Set_localScale(scale.x, scale.y, scale.z)
      else
        self.fingerArrowObj.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      end
      self.fingerArrowObj.gameObject.transform.position = pos
    end)
  else
    self.fingerArrowObj.gameObject.transform.position = pos
  end
  self.fingerUUid = uuid
  self:DeleteWorldFingerArrowTimer()
  self:AddWorldFingerArrowTimer(closeTime)
end

local function RemoveWorldFingerArrow(self)
  if self.fingerArrowObj then
    self.fingerArrowObj:Destroy()
    self.fingerArrowObj = nil
  end
end

local function RemoveWorldFingerArrowByUUid(self, uuid)
  if self.fingerArrowObj and self.fingerUUid == uuid then
    self.fingerArrowObj:Destroy()
    self.fingerArrowObj = nil
  end
end

local function AddWorldFingerArrowTimer(self, closeTime)
  if self.worldFingerArrow_timer == nil and closeTime then
    self.worldFingerArrow_timer = TimerManager:GetInstance():GetTimer(closeTime, function()
      self:RemoveWorldFingerArrow()
    end, self, true, false, false)
    self.worldFingerArrow_timer:Start()
  end
end

local function DeleteWorldFingerArrowTimer(self)
  if self.worldFingerArrow_timer then
    self.worldFingerArrow_timer:Stop()
    self.worldFingerArrow_timer = nil
  end
end

ActGhostreconAnimManager.__init = __init
ActGhostreconAnimManager.__delete = __delete
ActGhostreconAnimManager.AddListener = AddListener
ActGhostreconAnimManager.ShowPointAnim = ShowPointAnim
ActGhostreconAnimManager.RemovePointAnim = RemovePointAnim
ActGhostreconAnimManager.RemovePointOneAnimObj = RemovePointOneAnimObj
ActGhostreconAnimManager.RemoveAllPoint = RemoveAllPoint
ActGhostreconAnimManager.ShowWorldFingerArrow = ShowWorldFingerArrow
ActGhostreconAnimManager.RemoveWorldFingerArrow = RemoveWorldFingerArrow
ActGhostreconAnimManager.RemoveWorldFingerArrowByUUid = RemoveWorldFingerArrowByUUid
ActGhostreconAnimManager.AddWorldFingerArrowTimer = AddWorldFingerArrowTimer
ActGhostreconAnimManager.DeleteWorldFingerArrowTimer = DeleteWorldFingerArrowTimer
return ActGhostreconAnimManager
