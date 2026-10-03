local UIBuildHeroListView = BaseClass("UIBuildHeroListView", UIBaseView)
local base = UIBaseView
local UIBuildHeroItem = require("UI.UIBuildHeroList.Component.UIBuildHeroItem")
local heroList_path = "panel/Common_bg_orange/scrollView_HeroList"
local title_path = "panel/Common_bg_orange/text_title"
local close_path = "panel"

function UIBuildHeroListView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UIBuildHeroListView:OnWorkerBtnClick()
  local curBuildData = self.ctrl:GetCurBuildData()
  if curBuildData and curBuildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
    local functionUnlock, tip = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
    if functionUnlock then
      local giftPackId, level = DataCenter.VIPManager:GetLeastUnboughtVipPack()
      if giftPackId then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip, level)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip)
      end
    else
      UIUtil.ShowTipsId(tip)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true}, nil, nil, nil, nil, true)
  end
end

function UIBuildHeroListView:ComponentDefine()
  self.heroList = self:AddComponent(UIScrollView, heroList_path)
  self.close = self:AddComponent(UIButton, close_path)
  self.titleText = self:AddComponent(UIText, title_path)
  self.closeBtn = self:AddComponent(UIButton, "panel/Common_bg_orange/closeBtn")
  self.noWorker = self:AddComponent(UIBaseContainer, "panel/Common_bg_orange/noWorker")
  self.battleBtn = self:AddComponent(UIButton, "panel/Common_bg_orange/noWorker/layout/battleBtn")
  self.workerBtn = self:AddComponent(UIButton, "panel/Common_bg_orange/noWorker/layout/workerBtn")
  self.battleBtnText = self:AddComponent(UIText, "panel/Common_bg_orange/noWorker/layout/battleBtn/battleText")
  self.workerBtnText = self:AddComponent(UIText, "panel/Common_bg_orange/noWorker/layout/workerBtn/workerText")
  self.noWorkerTitle = self:AddComponent(UIText, "panel/Common_bg_orange/noWorker/noWorkerTitle")
  self.battleBtn:SetOnClick(function()
    GoToUtil.CloseAllWindows()
    local pos = Vector3.New(100, 0, 75)
    GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime)
  end)
  self.workerBtn:SetOnClick(function()
    self:OnWorkerBtnClick()
  end)
  self.close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.heroList:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.heroList:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.titleText:SetLocalText(135187)
end

function UIBuildHeroListView:ComponentDestroy()
  self.heroList = nil
  self.close = nil
  DataCenter.ArrowManager:RemoveFingerArrow()
end

function UIBuildHeroListView:ShowScroll()
  self:ClearScroll()
  local count = #self.heroDatalist
  self.heroList:SetTotalCount(count)
  if 0 < count then
    self.heroList:RefillCells()
  end
end

function UIBuildHeroListView:ClearScroll()
  self.heroList:ClearCells()
  self.heroList:RemoveComponents(UIBuildHeroItem)
end

function UIBuildHeroListView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.heroList:AddComponent(UIBuildHeroItem, itemObj)
  local heroData = self.heroDatalist[index]
  if type(heroData) == "table" then
    heroData.slot = self.slot
  end
  item:ReInit(self.heroDatalist[index])
end

function UIBuildHeroListView:ReInit()
  self.curBuildIndex, self.slot = self:GetUserData()
  self.ctrl:UpdateDispatchingHeroDic()
  self.ctrl:SetCurBuildIndex(self.curBuildIndex)
  self.heroDatalist = self.ctrl:GetBuildShowHeroDataList(self.curBuildIndex)
  if self.heroDatalist and #self.heroDatalist > 0 then
    self:ShowScroll()
    self.noWorkerTitle:SetActive(false)
  else
    self:ClearScroll()
    self.noWorkerTitle:SetActive(true)
  end
  local curBuildData = self.ctrl:GetCurBuildData()
  if curBuildData and curBuildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
    self.workerBtn:SetActive(true)
    self.battleBtn:SetActive(false)
  else
    local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.Worker_Lottery)
    self.workerBtn:SetActive(unlock)
    self.battleBtn:SetActive(not DataCenter.MonopolyManager:GetIsEnd() and unlock)
  end
  self.battleBtnText:SetLocalText(151137)
  self.workerBtnText:SetLocalText(151137)
  self.noWorkerTitle:SetLocalText(130638)
end

function UIBuildHeroListView:OnDeleteCell(itemObj, index)
  self.heroList:RemoveComponent(itemObj.name, UIBuildHeroItem)
end

function UIBuildHeroListView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBuildHeroListView:OnEnable()
  base.OnEnable(self)
end

function UIBuildHeroListView:OnDisable()
  base.OnDisable(self)
end

function UIBuildHeroListView:DataDefine()
  self.curBuildIndex = nil
  self.heroDatalist = {}
  self.slot = nil
end

function UIBuildHeroListView:DataDestroy()
  self.heroDatalist = nil
  self.curBuildIndex = nil
  self.slot = nil
end

function UIBuildHeroListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.ReInit)
  self:AddUIListener(EventId.WorkerFragUnlock, self.ReInit)
end

function UIBuildHeroListView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.ReInit)
  self:RemoveUIListener(EventId.WorkerFragUnlock, self.ReInit)
end

return UIBuildHeroListView
