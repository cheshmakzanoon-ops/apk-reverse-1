local UIDispatchTaskRefreshConfirmView = BaseClass("UIDispatchTaskRefreshConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local txt_title_path = "panel/bg/txtTitle"
local tip_text_path = "panel/bg/TipText"
local cost_title_path = "panel/bg/CostTitle"
local close_btn_path = "panel/bg/CloseBtn"
local confirm_btn_path = "panel/bg/ConfirmBtn"
local confirm_btn_text_path = "panel/bg/ConfirmBtn/ConfirmBtnText"
local item_path = "panel/bg/rewardContent/Item"
local content_path = "panel/bg/rewardContent/ScrollView/Viewport/Content"

function UIDispatchTaskRefreshConfirmView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIDispatchTaskRefreshConfirmView:OnDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDispatchTaskRefreshConfirmView:OnAddListener()
  base.OnAddListener(self)
end

function UIDispatchTaskRefreshConfirmView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDispatchTaskRefreshConfirmView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.cost_title = self:AddComponent(UITextMeshProUGUIEx, cost_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn_text = self:AddComponent(UITextMeshProUGUIEx, confirm_btn_text_path)
  self.txt_title:SetText(Localization:GetString("dispatch_des006"))
  self.cost_title:SetText(Localization:GetString("dispatch_des008"))
  self.confirm_btn_text:SetText(Localization:GetString(451020))
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirm_btn:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UIDispatchTaskRefreshConfirmView:DataDefine()
end

function UIDispatchTaskRefreshConfirmView:ComponentDestroy()
  self.panel = nil
  self.txt_title = nil
  self.tip_text = nil
  self.cost_title = nil
  self.close_btn = nil
  self.confirm_btn = nil
  self.confirm_btn_text = nil
  self.content = nil
end

function UIDispatchTaskRefreshConfirmView:DataDestroy()
end

function UIDispatchTaskRefreshConfirmView:ReInit()
  local allTasks = DataCenter.ActDispatchTaskDataManager:GetAllSingleTasks()
  local validCount = 0
  for _, taskInfo in ipairs(allTasks) do
    if taskInfo.completionTime == 0 and taskInfo.cfg and taskInfo.cfg.color < 5 then
      validCount = validCount + 1
    end
  end
  self.validCount = validCount
  self.tip_text:SetText(Localization:GetString("dispatch_des007", validCount))
  local itemId, itemCount, coinCount = DataCenter.ActDispatchTaskDataManager:GetTaskSuperRefreshSetting()
  local useCount = validCount * itemCount
  local useCoin = 0
  local itemData = DataCenter.ItemData:GetItemById(itemId)
  local hasItemCount = 0
  if itemData then
    hasItemCount = itemData.count
  end
  if useCount > hasItemCount then
    useCoin = (useCount - hasItemCount) * coinCount
    useCount = hasItemCount
  end
  self.useCount = useCount
  self.useCoin = useCoin
  self.content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  local showList = {}
  if 0 < useCount then
    local it = DataCenter.RewardManager:ParseOneRewardStr(itemId .. ";" .. RewardType.GOODS .. ";" .. useCount)
    table.insert(showList, it)
  end
  if 0 < useCoin then
    local it = DataCenter.RewardManager:ParseOneRewardStr("15;" .. RewardType.GOLD .. ";" .. useCoin)
    table.insert(showList, it)
  end
  for i, item in ipairs(showList) do
    local theName = "item_" .. i
    local goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = theName
    goItem:SetActive(true)
    local theItem = self.content:AddComponent(UICommonResItem, theName)
    theItem:ReInit(item)
  end
end

function UIDispatchTaskRefreshConfirmView:OnConfirmBtnClick()
  if self.validCount > 0 then
    if 0 < self.useCoin and LuaEntry.Player.gold < self.useCoin then
      UIUtil.ShowTipsId("E100001")
      return
    end
    DataCenter.ActDispatchTaskDataManager:SetNeedPlayedSweepEffect(true)
    SFSNetwork.SendMessage(MsgDefines.DispatchTaskRefresh, 0, 1)
    self.ctrl:CloseSelf()
  else
  end
end

return UIDispatchTaskRefreshConfirmView
