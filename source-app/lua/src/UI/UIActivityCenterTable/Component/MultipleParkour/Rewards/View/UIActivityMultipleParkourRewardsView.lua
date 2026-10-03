local UIActivityMultipleParkourRewardsView = BaseClass("UIActivityMultipleParkourRewardsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AchieveItem = require("UI.UIActivityCenterTable.Component.MultipleParkour.Rewards.Component.UIActivityMultipleParkourAchieveItem")
local txt_title_path = "top/txtTitle"
local btn_close_path = "top/btnClose"
local scroll_achieve_path = "bg2/scrollAchieve"
local btn_all_path = "btnAll"
local txt_all_path = "btnAll/txtAll"
local img_gray_path = "btnAll/imgGray"
local txt_gray_path = "btnAll/imgGray/txtGray"
local black_path = "black"

function UIActivityMultipleParkourRewardsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIActivityMultipleParkourRewardsView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIActivityMultipleParkourRewardsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MultipleParkourActivityInfoChanged, self.OnActivityInfoChanged)
  self:AddUIListener(EventId.MultipleParkourTaskRewardChanged, self.OnRewardChanged)
end

function UIActivityMultipleParkourRewardsView:OnRemoveListener()
  self:RemoveUIListener(EventId.MultipleParkourActivityInfoChanged, self.OnActivityInfoChanged)
  self:RemoveUIListener(EventId.MultipleParkourTaskRewardChanged, self.OnRewardChanged)
  base.OnRemoveListener(self)
end

function UIActivityMultipleParkourRewardsView:ComponentDefine()
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.scroll_achieve = self:AddComponent(UIDynamicVerticleScrollRectEx, scroll_achieve_path)
  self.btn_all = self:AddComponent(UIButton, btn_all_path)
  self.txt_all = self:AddComponent(UITextMeshProUGUIEx, txt_all_path)
  self.img_gray = self:AddComponent(UIImage, img_gray_path)
  self.txt_gray = self:AddComponent(UITextMeshProUGUIEx, txt_gray_path)
  self.txt_title:SetText(Localization:GetString(500265))
  self.txt_all:SetText(Localization:GetString(2000444))
  self.txt_gray:SetText(Localization:GetString(2000444))
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_all:SetOnClick(function()
    self:OnAllBtnClick()
  end)
  self.itemIncNo = 1
  self.itemMap = {}
  self.scroll_achieve:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "achieveItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local achieveItem = self:AddComponent(AchieveItem, itemObj)
    self.itemMap[itemObj] = achieveItem
  end)
  self.scroll_achieve:AddDisplayItemListener(function(itemObj, dataIdx)
    local achieveItem = self.itemMap[itemObj]
    assert(achieveItem, "achieveItem is nil. dataIdx:" .. dataIdx)
    local data = self.datas[dataIdx + 1]
    assert(data, "achieveData is nil. dataIdx:" .. dataIdx)
    achieveItem:Refresh(data, self.info.activityId)
  end)
  self.black = self:AddComponent(UIButton, black_path)
  self.black:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIActivityMultipleParkourRewardsView:DataDefine()
end

function UIActivityMultipleParkourRewardsView:ComponentDestroy()
  self.txt_title = nil
  self.btn_close = nil
  self.scroll_achieve = nil
  self.btn_all = nil
  self.txt_all = nil
  self.img_gray = nil
  self.txt_gray = nil
  self.black = nil
end

function UIActivityMultipleParkourRewardsView:DataDestroy()
end

function UIActivityMultipleParkourRewardsView:OnActivityInfoChanged(activityId)
  if self.info and tonumber(activityId) == tonumber(self.info.id) then
    self:ReInit()
  end
end

function UIActivityMultipleParkourRewardsView:OnRewardChanged(activityId)
  if self.info and tonumber(activityId) == tonumber(self.info.id) then
    table.sort(self.datas, function(a, b)
      if a.state ~= b.state and (a.state > 1 or b.state > 1) then
        return a.state < b.state
      else
        local taskIdA = tonumber(a.taskId)
        local taskIdB = tonumber(b.taskId)
        return taskIdA > taskIdB
      end
    end)
    self.scroll_achieve:SetDatas(self.datas)
    self.scroll_achieve:UpdateItems()
    self:RefreshBtnAll()
  end
end

function UIActivityMultipleParkourRewardsView:ReInit()
  local info = DataCenter.MultipleParkourActivityManager.info
  if not info then
    return
  end
  self.info = info
  local taskArr = self.info.taskArr
  self.datas = taskArr
  table.sort(self.datas, function(a, b)
    if a.state ~= b.state then
      if a.state == 1 then
        return true
      end
      if b.state == 1 then
        return false
      end
      return a.state < b.state
    else
      local taskIdA = tonumber(a.taskId)
      local taskIdB = tonumber(b.taskId)
      return taskIdA < taskIdB
    end
  end)
  self.scroll_achieve:SetDatas(self.datas)
  self.scroll_achieve:UpdateItems()
  self:RefreshBtnAll()
end

function UIActivityMultipleParkourRewardsView:RefreshBtnAll()
  local canReward = false
  for _, v in ipairs(self.datas) do
    if v.state == 1 then
      canReward = true
      break
    end
  end
  self.btn_all:SetInteractable(canReward)
  self.img_gray:SetActive(not canReward)
end

function UIActivityMultipleParkourRewardsView:OnAllBtnClick()
  if not self.info then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.MultipleParkourTaskReward, self.info.activityId, "0")
end

return UIActivityMultipleParkourRewardsView
