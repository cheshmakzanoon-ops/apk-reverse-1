local UIHospitalCtrl = BaseClass("UIHospitalCtrl", UIBaseCtrl)

local function CloseSelf(self)
  if self.curScene ~= nil and self.curScene == CurScene.PVEScene then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHospital, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  else
    UIManager.Instance:DestroyWindow(UIWindowNames.UIHospital)
  end
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function GetHospitalQueue(self)
  if BattleFieldUtil.InBattleField() then
    return DataCenter.QueueDataManager:GetQueueByType(NewQueueType.DragonHospital)
  end
  return DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
end

local function InitData(self, curScene)
  self.curScene = curScene or nil
end

UIHospitalCtrl.CloseSelf = CloseSelf
UIHospitalCtrl.Close = Close
UIHospitalCtrl.GetHospitalQueue = GetHospitalQueue
UIHospitalCtrl.InitData = InitData
return UIHospitalCtrl
