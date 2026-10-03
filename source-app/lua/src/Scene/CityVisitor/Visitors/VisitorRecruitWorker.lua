local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local RecruitWorker = BaseClass("RecruitWorker", CallerUnit)
local Const = require("Scene.CityVisitor.Const")
local p_entryPath = "ModelGo/point/p_entry"

function RecruitWorker:FinishVisitor()
  self.isFinish = true
  DataCenter.CityVisitorManager:DeleteVisitor(self.visitorData.uid, self.visitorData.type)
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(mainBuild.pointId)
  local p_entry = Vector3.New(98, 0, 98)
  if cityObj then
    local trans = cityObj.gameObject.transform:Find(p_entryPath)
    if not IsNull(trans) then
      p_entry = Vector3.New(trans.position.x, trans.position.y, trans.position.z)
    end
  end
  local incity, ouCity = DataCenter.InnerCityMapManager:GetCityDoorManager():GetDoorPos()
  local pathList = {ouCity, p_entry}
  self:SetTargetEndPos(pathList)
  self:PlayAni(Const.animation.Walk)
  if self.questionIcon then
    self.questionIcon.gameObject:SetActive(false)
  end
  if self.smilingFaceIcon then
    self.smilingFaceIcon.gameObject:SetActive(true)
  end
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    if self.tipRoot and self.tipRoot.gameObject then
      self.tipRoot.gameObject:SetActive(false)
    end
  end, Const.showEmojiTime)
  if self.modelTrigger then
    self.modelTrigger.onPointerClick = nil
  end
  if self.trigger then
    self.trigger.onPointerClick = nil
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshVisitorBtnState)
end

function RecruitWorker:OnTriggerClick()
  local plotId = tonumber(LocalController:instance():getValue(TableName.City_Visitor, self.visitorData.eventId, "plot"))
  if plotId then
    function self.__onPlotEnd(plotGroupId)
      if plotGroupId == plotId then
        EventManager:GetInstance():RemoveListener(EventId.PlotGroupDone, self.__onPlotEnd)
        
        self.__onPlotEnd = nil
        self:ShowRecuitView()
      end
    end
    
    EventManager:GetInstance():AddListener(EventId.PlotGroupDone, self.__onPlotEnd)
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = true})
  else
    self:ShowRecuitView()
  end
end

function RecruitWorker:ShowRecuitView()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerDetailRecruit, {anim = true}, self.workerData, function()
    if self.visitorData then
      SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 1)
      self:ShowNextInfo()
    else
      Logger.LogWarning("RecruitWorker:ShowRecuitView visitorData is nil ! ")
    end
  end)
end

function RecruitWorker:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

function RecruitWorker:__delete()
  if self.__onPlotEnd then
    EventManager:GetInstance():RemoveListener(EventId.PlotGroupDone, self.__onPlotEnd)
    self.__onPlotEnd = nil
  end
end

return RecruitWorker
