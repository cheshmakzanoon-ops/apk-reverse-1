local UIBuildQueueCtrl = BaseClass("UIBuildQueueCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWScienceQueue)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetQueueDataList()
  local dataList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
  local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILE_SCIENCE_TWO)
  if data and data.level == 0 then
    data = {}
    local pack = DataCenter.ScienceManager:GetGiftPack()
    if pack then
      data.pack = pack
      data.isBuy = true
      table.insert(dataList, data)
    end
  end
  return dataList
end

UIBuildQueueCtrl.CloseSelf = CloseSelf
UIBuildQueueCtrl.Close = Close
UIBuildQueueCtrl.GetQueueDataList = GetQueueDataList
return UIBuildQueueCtrl
