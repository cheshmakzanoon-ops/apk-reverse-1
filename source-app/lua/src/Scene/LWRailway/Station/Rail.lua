local Rail = BaseClass("Rail")
local Localization = CS.GameEntry.Localization

function Rail:__init(transform)
  self.transform = transform
  self:ComponentDefine()
end

function Rail:__delete()
  self:Destroy()
end

function Rail:Destroy()
  self:ComponentDestroy()
end

function Rail:ComponentDefine()
  self.trigger = self.transform:Find("Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnClick()
  end
end

function Rail:ComponentDestroy()
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  self.transform = nil
end

function Rail:OnClick()
  if DataCenter.LWAllyStationDataManager:IsTrainFunctionLock() then
    return
  end
  local closed, closeEndTime = DataCenter.LWAllyStationDataManager:IsTrainClosed()
  if closed then
    UIUtil.ShowMessage(Localization:GetString("alliance_train_041"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "alliance_train_040", nil, nil, nil, nil, nil, closeEndTime, CS.UnityEngine.TextAnchor.UpperLeft)
    return
  end
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData then
    RailwayUtil.ClickCityTrain(TrainPreparePage.Driver)
    return
  end
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(458620)
    return
  end
  if not RailwayUtil.CheckCanBuyTrain() then
    return
  end
  local cur, max = DataCenter.LWAllyStationDataManager:BuyCount()
  if max <= cur then
    UIUtil.ShowTipsId(458619)
  else
    RailwayUtil.BuyAllyTrain()
  end
end

return Rail
