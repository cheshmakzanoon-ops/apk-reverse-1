local UIActivityFrontBreakSundayRewardsView = BaseClass("UIActivityFrontBreakSundayRewardsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AchieveItem = require("UI.UIActivityCenterTable.Component.UIActFrontBreakSunday.Rewards.Component.UIActivityFrontBreakSundayRewardAchieveItem")
local txt_title_path = "top/txtTitle"
local btn_close_path = "top/btnClose"
local scroll_achieve_path = "bg2/scrollAchieve"
local btn_all_path = "btnAll"
local txt_all_path = "btnAll/txtAll"
local img_gray_path = "btnAll/imgGray"
local txt_gray_path = "btnAll/imgGray/txtGray"
local black_path = "black"

function UIActivityFrontBreakSundayRewardsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIActivityFrontBreakSundayRewardsView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIActivityFrontBreakSundayRewardsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FrontBreakSundayActivityInfoChanged, self.OnInfoChange)
  self:AddUIListener(EventId.FrontBreakSundayTaskRewardChanged, self.OnInfoChange)
end

function UIActivityFrontBreakSundayRewardsView:OnRemoveListener()
  self:RemoveUIListener(EventId.FrontBreakSundayActivityInfoChanged, self.OnInfoChange)
  self:RemoveUIListener(EventId.FrontBreakSundayTaskRewardChanged, self.OnInfoChange)
  base.OnRemoveListener(self)
end

function UIActivityFrontBreakSundayRewardsView:ComponentDefine()
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
  self.activityId = self:GetUserData()
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
    local data = self.rewardDatas[dataIdx + 1]
    achieveItem:Refresh(data, self.activityId)
  end)
  self.black = self:AddComponent(UIButton, black_path)
  self.black:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIActivityFrontBreakSundayRewardsView:ComponentDestroy()
  self.txt_title = nil
  self.btn_close = nil
  self.scroll_achieve = nil
  self.btn_all = nil
  self.txt_all = nil
  self.img_gray = nil
  self.txt_gray = nil
  self.black = nil
  self.activityId = nil
end

function UIActivityFrontBreakSundayRewardsView:DataDefine()
end

function UIActivityFrontBreakSundayRewardsView:DataDestroy()
end

function UIActivityFrontBreakSundayRewardsView:OnInfoChange(activityId)
  if self.activityId and tonumber(activityId) == tonumber(self.activityId) then
    self:ReInit()
  end
end

function UIActivityFrontBreakSundayRewardsView:ReInit()
  local info = DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).info
  if not info then
    return
  end
  local rewardDatas = info.taskArr
  table.sort(rewardDatas, function(a, b)
    if a.state ~= b.state and (a.state > 1 or b.state > 1) then
      return a.state < b.state
    else
      local taskIdA = tonumber(a.taskId)
      local taskIdB = tonumber(b.taskId)
      return taskIdA > taskIdB
    end
  end)
  self.rewardDatas = rewardDatas
  self.scroll_achieve:SetDatas(self.rewardDatas)
  self.scroll_achieve:UpdateItems()
  self:RefreshBtnAll()
end

function UIActivityFrontBreakSundayRewardsView:RefreshBtnAll()
  local canReward = false
  for _, v in ipairs(self.rewardDatas) do
    if v.state == 1 then
      canReward = true
      break
    end
  end
  self.btn_all:SetInteractable(canReward)
  self.img_gray:SetActive(not canReward)
end

function UIActivityFrontBreakSundayRewardsView:OnAllBtnClick()
  local info = DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).info
  if not info then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.FrontBreakSundayReward, self.activityId, 0)
end

return UIActivityFrontBreakSundayRewardsView
