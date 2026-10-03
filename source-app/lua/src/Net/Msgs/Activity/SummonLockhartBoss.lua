local SummonLockhartBoss = BaseClass("SummonLockhartBoss", SFSBaseMessage)
local base = SFSBaseMessage

function SummonLockhartBoss:OnCreate(level, useItem)
  base.OnCreate(self)
  if level == 0 or level == nil then
    local maxUnlockLevel = DataCenter.LWActivityLockhartManager:GetMaxLockHartUnlockLevel()
    local mainLv = DataCenter.BuildManager.MainLv
    if 0 < maxUnlockLevel then
      level = math.min(maxUnlockLevel, mainLv)
    else
      level = mainLv
    end
  end
  self.sfsObj:PutInt("level", level)
  if useItem == true then
    self.sfsObj:PutInt("useItem", 1)
  end
end

function SummonLockhartBoss:HandleMessage(data)
  base.HandleMessage(self, data)
  if data ~= nil and data.pointId ~= nil then
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldPointAndOpen(data.pointId, nil, data.monsterUid)
    if data.isLockhart == 0 then
      UIUtil.ShowTipsId("2010120")
    end
  elseif data.errorCode ~= nil then
    print(data.errorCode)
    if data.errorMsg ~= nil then
      print(data.errorMsg)
    end
    UIUtil.ShowTipsId(data.errorCode)
  else
    UIUtil.ShowTipsId("E120016")
  end
end

return SummonLockhartBoss
