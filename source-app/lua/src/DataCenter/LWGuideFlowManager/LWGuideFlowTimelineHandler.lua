local LWGuideFlowTimelineHandler = BaseClass("LWGuideFlowTimelineHandler")

function LWGuideFlowTimelineHandler:__init()
  self.flowToSerialId = {}
end

function LWGuideFlowTimelineHandler:__delete()
  self.flowToSerialId = nil
end

function LWGuideFlowTimelineHandler:Startup()
end

function LWGuideFlowTimelineHandler:TimelineAwake(flowId)
end

function LWGuideFlowTimelineHandler:TimelineLoaded(flowId)
  if flowId == 1003 then
    self.flowToSerialId[flowId] = DataCenter.LWSoundManager:PlaySound(62242, false)
  elseif flowId == 1004 then
    self.flowToSerialId[flowId] = DataCenter.LWSoundManager:PlaySound(62247, false)
  elseif flowId == 2002 then
    self.flowToSerialId[flowId] = DataCenter.LWSoundManager:PlaySound(62258, false)
  end
end

function LWGuideFlowTimelineHandler:TimelineStoped(flowId)
  if self.flowToSerialId[flowId] then
    DataCenter.LWSoundManager:StopSound(self.flowToSerialId[flowId])
  end
  self.flowToSerialId[flowId] = nil
end

return LWGuideFlowTimelineHandler
