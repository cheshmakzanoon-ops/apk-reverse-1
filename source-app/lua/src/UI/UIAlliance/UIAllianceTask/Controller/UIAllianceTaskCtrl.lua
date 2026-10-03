local UIAllianceTaskCtrl = BaseClass("UIAllianceTaskCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceTask)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function JumpTo(self, jump, jumpParam)
  if jump == 1 then
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_GROCERY_STORE, WorldTileBtnType.City_GROCERY_STORE)
  elseif jump == 2 then
    GoToUtil.GoAttackMonster()
  elseif jump == 3 then
    local unlock = DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceOrder)
    if not unlock then
      UIUtil.ShowTipsId(390994)
      return
    end
    if DataCenter.ActAllianceOrderManager.actData then
      self:Close()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, tonumber(DataCenter.ActAllianceOrderManager.actData.id))
    end
  elseif jump == 4 then
    local unlock = DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceScience)
    if not unlock then
      UIUtil.ShowTipsId(390994)
      return
    end
    self:Close()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {
      anim = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    })
  elseif jump == 5 then
    self:Close()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlHelp, {anim = true})
  elseif jump == 6 then
    self:Close()
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  elseif jump == 7 then
    self:Close()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif jump == 8 then
  elseif jump == 9 then
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true})
  elseif jump == 10 then
    local unlock = DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceScience)
    if not unlock then
      UIUtil.ShowTipsId(390994)
      return
    end
    self:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {
      anim = true,
      hideTop = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, {
      openScienceId = tonumber(jumpParam)
    })
  end
end

local function ShareTask(self, taskConf, taskInfo, tempTime, isSeason)
  local share_param = {}
  share_param.post = PostType.Text_AllianceTaskShare
  share_param.taskId = taskConf.id
  share_param.taskName = taskConf.name
  share_param.curProg = taskInfo.curProg
  share_param.maxProg = taskConf.param
  share_param.tempTime = tempTime
  share_param.isSeason = isSeason
  share_param.postType = PostType.Text_AllianceTaskShare
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

UIAllianceTaskCtrl.CloseSelf = CloseSelf
UIAllianceTaskCtrl.Close = Close
UIAllianceTaskCtrl.JumpTo = JumpTo
UIAllianceTaskCtrl.ShareTask = ShareTask
return UIAllianceTaskCtrl
