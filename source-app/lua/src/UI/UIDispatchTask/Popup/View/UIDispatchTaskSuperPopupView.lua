local UIDispatchTaskSuperPopupView = BaseClass("UIDispatchTaskSuperPopupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local PopupItem = require("UI.UIDispatchTask.Popup.Component.UIDispatchTaskPopupItem")
local panel_path = "panel"
local txt_title_path = "panel/bg/txtTitle"
local close_btn_path = "panel/bg/CloseBtn"
local confirm_btn_path = "panel/bg/ConfirmBtn"
local confirm_btn_text_path = "panel/bg/ConfirmBtn/ConfirmBtnText"
local scroll_super_path = "panel/bg/rewardContent/scrollSuper"
local toggle_path = "panel/bg/toggleUR"
local txt_toggleDesc_path = "panel/bg/toggleDesc"
local Setting = CS.GameEntry.Setting

function UIDispatchTaskSuperPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIDispatchTaskSuperPopupView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDispatchTaskSuperPopupView:OnAddListener()
  base.OnAddListener(self)
end

function UIDispatchTaskSuperPopupView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDispatchTaskSuperPopupView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn_text = self:AddComponent(UITextMeshProUGUIEx, confirm_btn_text_path)
  self.scroll_super = self:AddComponent(UIScrollView, scroll_super_path)
  self.toggleOnlySelectUR = self:AddComponent(UIToggle, toggle_path)
  self.txt_toggleDesc = self:AddComponent(UITextMeshProUGUIEx, txt_toggleDesc_path)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scroll_super:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemCreateCell(itemObj, index)
  end)
  self.scroll_super:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemDeleteCell(itemObj, index)
  end)
  self.txt_title:SetText(Localization:GetString("dispatch_des009"))
  self.confirm_btn_text:SetText(Localization:GetString("dispatch_des013"))
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirm_btn:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
  if DataCenter.ActDispatchTaskDataManager:IsSelectURSwitchOpen() then
    self.toggleOnlySelectUR:SetActive(true)
    self.txt_toggleDesc:SetLocalText("activity_secret_select_limit_4")
    self.toggleOnlySelectUR:SetOnValueChanged(function(tf)
      self:OnToggleChange(tf)
    end)
  else
    self.toggleOnlySelectUR:SetActive(false)
    self.txt_toggleDesc:SetText("")
  end
end

function UIDispatchTaskSuperPopupView:DataDefine()
  local isSwitchOn = DataCenter.ActDispatchTaskDataManager:IsSelectURSwitchOpen()
  self.isOnlySelectUR = isSwitchOn and Setting:GetPrivateBool("DispatchTaskSuperPopupOnlySelectUR", true)
end

function UIDispatchTaskSuperPopupView:OnItemCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scroll_super:AddComponent(PopupItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local data = self.datas[index]
  item:Refresh(data)
end

function UIDispatchTaskSuperPopupView:OnItemDeleteCell(itemObj, index)
end

function UIDispatchTaskSuperPopupView:ComponentDestroy()
  self.scroll_super:ClearCells()
  self.scroll_super:RemoveComponents(PopupItem)
  self.scrollCellPool = {}
  self.panel = nil
  self.txt_title = nil
  self.close_btn = nil
  self.confirm_btn = nil
  self.confirm_btn_text = nil
  self.scroll_super = nil
end

function UIDispatchTaskSuperPopupView:DataDestroy()
end

local function SortTasks(taskA, taskB)
  if taskA and not taskB then
    return false
  end
  if not taskA and taskB then
    return true
  end
  local orderA = taskA.taskInfo.cfg.superdispatch_order or 0
  local orderB = taskB.taskInfo.cfg.superdispatch_order or 0
  if orderA ~= orderB then
    return orderA > orderB
  end
  local indexA = taskA.index
  local indexB = taskB.index
  return indexA < indexB
end

function UIDispatchTaskSuperPopupView:ReInit()
  self.datas = {}
  self.initSuperCount = 0
  self.toggleOnlySelectUR:SetIsOnWithoutNotify(self.isOnlySelectUR)
  local index = 0
  local allTasks = DataCenter.ActDispatchTaskDataManager:GetAllSingleTasks()
  for _, taskInfo in ipairs(allTasks) do
    if taskInfo.completionTime == 0 then
      index = index + 1
      table.insert(self.datas, {taskInfo = taskInfo, index = index})
    end
  end
  if #self.datas > 1 then
    table.sort(self.datas, SortTasks)
  end
  local maxMarch = DataCenter.ActDispatchTaskDataManager:GetMaxMarch()
  local curTaskingCount = DataCenter.ActDispatchTaskDataManager:GetSingleTaskIngCount()
  local tmpUsedHeroList = {}
  for _, v in ipairs(self.datas) do
    local info = v
    if maxMarch < curTaskingCount + 1 then
      info.selected = false
      info.lackArmy = true
    else
      local heroList, meetCondition = self.ctrl:GetRecommendHeroList(info.taskInfo, tmpUsedHeroList)
      if heroList and meetCondition then
        local color = info.taskInfo.cfg.color
        if self.isOnlySelectUR and color ~= ItemColor.ORANGE then
          info.selected = false
        else
          info.selected = true
        end
        info.heroList = heroList
        table.insertto(tmpUsedHeroList, heroList)
        self.initSuperCount = self.initSuperCount + 1
      else
        info.selected = false
        info.lackHero = true
      end
    end
  end
  local count = #self.datas
  self.scroll_super:SetTotalCount(count)
  if 0 < count then
    self.scroll_super:RefillCells()
  end
end

function UIDispatchTaskSuperPopupView:OnConfirmBtnClick()
  if SeasonUtil.IsInLandlordActAndOnCenterServer() then
    UIUtil.ShowTipsId("zonewar_landlord_tips_1012")
    return
  end
  local count = 0
  local sfsObj = SFSArray.New()
  for _, v in ipairs(self.datas) do
    local data = v
    if data.selected then
      local oneData = SFSObject.New()
      sfsObj:AddSFSObject(oneData)
      oneData:PutLong("uuid", data.taskInfo.uuid)
      oneData:PutLongArray("heroList", table.values(data.heroList))
      count = count + 1
    end
  end
  if 0 < count then
    if LuaEntry.Player:IsInBlackRange() then
      UIUtil.ShowMessage(Localization:GetString(457082))
    end
    SFSNetwork.SendMessage(MsgDefines.DispatchBatchStart, sfsObj)
    self.ctrl:CloseSelf()
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldPoint(LuaEntry.Player:GetMainWorldPos())
  elseif 0 < self.initSuperCount then
    UIUtil.ShowTips(Localization:GetString("dispatch_des016"))
  else
    UIUtil.ShowTips(Localization:GetString("dispatch_des017"))
  end
end

function UIDispatchTaskSuperPopupView:OnToggleChange(tf)
  self.isOnlySelectUR = tf
  Setting:SetPrivateBool("DispatchTaskSuperPopupOnlySelectUR", self.isOnlySelectUR)
  if tf then
    for _, v in ipairs(self.datas) do
      if v.selected and v.taskInfo.cfg.color ~= ItemColor.ORANGE then
        v.selected = false
      end
    end
    self.scroll_super:RefillCells()
    UIUtil.ShowTipsId("activity_secret_select_tips_on")
  else
    UIUtil.ShowTipsId("activity_secret_select_tips_off")
  end
end

return UIDispatchTaskSuperPopupView
