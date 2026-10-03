local UILWWorkerListPanelCtrl = BaseClass("UILWWorkerListPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorkerList)
end

local function GetResidentWorkerList(self)
  local residentWorkers = {}
  residentWorkers = DataCenter.WorkerDataManager:GetAllWorkerData()
  local workerDataList = {}
  for __, v in pairs(residentWorkers) do
    if v.isUIPlaneShow == 1 then
      table.insert(workerDataList, v)
    end
  end
  table.sort(workerDataList, function(a, b)
    if a.quality ~= b.quality then
      return a.quality > b.quality
    end
    if a.state ~= b.state then
      if a.state == WorkerState.RESIDENTA then
        return true
      elseif b.state == WorkerState.RESIDENTA then
        return false
      end
    end
    return a.uid < b.uid
  end)
  local pureDataList = {}
  for __, v in pairs(workerDataList) do
    table.insert(pureDataList, v.uid)
  end
  return pureDataList
end

UILWWorkerListPanelCtrl.CloseSelf = CloseSelf
UILWWorkerListPanelCtrl.GetResidentWorkerList = GetResidentWorkerList
return UILWWorkerListPanelCtrl
