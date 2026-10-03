local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorWorkerLottery = BaseClass("VisitorWorkerLottery", CallerUnit)
local Const = require("Scene.CityVisitor.Const")

function VisitorWorkerLottery:FinishVisitor(operate)
  self.isFinish = true
  self:SetFinishTargetPos()
  self:PlayAni(Const.animation.Walk)
  if self.questionIcon then
    self.questionIcon.gameObject:SetActive(false)
  end
  if operate == 1 then
    if self.smilingFaceIcon then
      self.smilingFaceIcon.gameObject:SetActive(true)
    end
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      if self.tipRoot then
        self.tipRoot.gameObject:SetActive(false)
      end
    end, Const.showEmojiTime)
  elseif self.tipRoot then
    self.tipRoot.gameObject:SetActive(false)
  end
  if self.modelTrigger then
    self.modelTrigger.onPointerClick = nil
  end
  if self.trigger then
    self.trigger.onPointerClick = nil
  end
  DataCenter.CityVisitorManager:DeleteVisitor(self.visitorData.uid, self.visitorData.type)
end

function VisitorWorkerLottery:OnTriggerClick()
  GoToUtil.GotoWorkerRecruitView(true)
  local count = DataCenter.CityVisitorManager.GetFrontCount(self.visitorData.uid, self.visitorData.type)
  if count == 0 then
    local allNum = DataCenter.CityVisitorManager:GetQueueVisitorCount(Const.VisitorTypeToQueue[Const.VisitorType.WORKER_LOTTERY])
    if 1 < allNum then
      SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 1)
      return
    end
    local oldItemId = LuaEntry.DataConfig:TryGetNum("worker_recruit_1", "k3", 0)
    local itemId = DataCenter.LotteryDataManager:GetOnlyWorkerLotteryCostItemId() or oldItemId
    if 0 < itemId then
      local curNum = DataCenter.ItemData:GetItemCount(itemId)
      if curNum <= 0 then
        SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 1)
        return
      end
    end
  end
end

function VisitorWorkerLottery:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

return VisitorWorkerLottery
