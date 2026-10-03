local UILWVIPRadarClaimPanelView = BaseClass("UILWVIPRadarClaimPanelView", UIBaseView)
local CS = _G.CS
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIManager = _G.UIManager
local UIAssets = _G.UIAssets
local UIUtil = _ENV.UIUtil
local VIPRadarRewardUtil = require("UI.UILWVIPRadar.Main.VIPRadarRewardUtil")
local table_insert = table.insert

local function to_positive_int(value)
  local num = tonumber(value)
  if not num then
    return 0
  end
  if num < 0 then
    return math.floor(num)
  end
  return math.floor(num + 1.0E-7)
end

local function to_array(items)
  if type(items) ~= "table" then
    return {}
  end
  local arr = {}
  local length = #items
  if 0 < length then
    for i = 1, length do
      arr[#arr + 1] = items[i]
    end
  else
    for _, reward in pairs(items) do
      arr[#arr + 1] = reward
    end
  end
  return arr
end

local function format_count(count)
  local num = tonumber(count) or 0
  if num <= 0 then
    return "0"
  end
  local formatFunc = string.GetFormattedSeperatorNum
  return formatFunc and formatFunc(num) or tostring(num)
end

local function sum_reward_quantities(list)
  return VIPRadarRewardUtil.sum_reward_quantities(list)
end

function UILWVIPRadarClaimPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ApplyPanelData(select(1, self:GetUserData()))
end

function UILWVIPRadarClaimPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWVIPRadarClaimPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnLWCommonNew = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnLWCommonNew:SetOnClick(function()
    self:OnBtnLWCommonNewClick()
  end)
  self.textNumTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textPayTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.payReward = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.accumulateReward = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.titleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.descTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.freeLabelTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.titleTxt:SetLocalText("activity_radarvipgift_claim_reward")
  self.descTxt:SetLocalText("activity_radarvipgift_claim_desc1")
  self.freeLabelTxt:SetLocalText("activity_radarvipgift_claim_desc2")
  self.textPayTxt:SetLocalText("activity_radarvipgift_claim_desc3")
  self.btnText:SetLocalText("activity_radarvipgift_claim_btn")
  self.textNumTxt:SetText("0")
end

function UILWVIPRadarClaimPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.btnLWCommonNew = nil
  self.textNumTxt = nil
  self.textPayTxt = nil
  self.payReward = nil
  self.accumulateReward = nil
  self.titleTxt = nil
  self.descTxt = nil
  self.freeLabelTxt = nil
  self.btnText = nil
end

function UILWVIPRadarClaimPanelView:DataDefine()
  local vipManager = DataCenter.VipGiftActDataManager or nil
  self.vipManager = vipManager
  self.actId = 0
  self.activityInfo = nil
  self.summary = nil
  self.overrideActId = nil
  self.panelData = nil
  self.panelFreeRewards = nil
  self.panelPayRewards = nil
  self.freeRewardReqs = {}
  self.payRewardReqs = {}
  self.onClosedCallback = nil
  self.closeNotified = false
  self.freeRewardCells = {}
  self.payRewardCells = {}
end

function UILWVIPRadarClaimPanelView:DataDestroy()
  self.vipManager = nil
  self.actId = 0
  self.activityInfo = nil
  self.summary = nil
  self.overrideActId = nil
  self.panelData = nil
  self.panelFreeRewards = nil
  self.panelPayRewards = nil
  if self.accumulateReward ~= nil then
    UIUtil.ClearReward(self.accumulateReward, self.freeRewardReqs)
  end
  if self.payReward ~= nil then
    UIUtil.ClearReward(self.payReward, self.payRewardReqs)
  end
  self.freeRewardReqs = {}
  self.payRewardReqs = {}
  self.onClosedCallback = nil
  self.closeNotified = false
  self.freeRewardCells = {}
  self.payRewardCells = {}
end

function UILWVIPRadarClaimPanelView:OnEnable()
  base.OnEnable(self)
  self.closeNotified = false
  self:ApplyPanelData(select(1, self:GetUserData()))
  self:RefreshActivityInfo()
  self:RefreshSummary()
  self:RefreshRewardDisplays()
end

function UILWVIPRadarClaimPanelView:OnDisable()
  if not self.closeNotified then
    self:NotifyCloseCallback()
  end
  base.OnDisable(self)
end

function UILWVIPRadarClaimPanelView:OnAddListener()
  base.OnAddListener(self)
end

function UILWVIPRadarClaimPanelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWVIPRadarClaimPanelView:ApplyPanelData(panelData)
  if type(panelData) ~= "table" then
    return
  end
  self.panelData = panelData
  self.onClosedCallback = panelData.onClosed
  local actIdValue = to_positive_int(panelData.actId)
  if 0 < actIdValue then
    self.overrideActId = actIdValue
  end
  self.panelFreeRewards = panelData.freeRewards
  self.panelPayRewards = panelData.payRewards
end

function UILWVIPRadarClaimPanelView:OnBtnLWCommonNewClick()
  self.ctrl:CloseSelf()
end

function UILWVIPRadarClaimPanelView:RefreshActivityInfo()
  local overrideActId = tonumber(self.overrideActId)
  if overrideActId and 0 < overrideActId then
    self.actId = to_positive_int(overrideActId)
    return
  end
  local info
  local actListManager = DataCenter and DataCenter.ActivityListDataManager or nil
  if actListManager ~= nil then
    info = actListManager:GetOneOpenActivityByType(EnumActivity.SurvivalVipGift.Type)
    local first = type(info) == "table" and info[1] or nil
    if first ~= nil then
      info = first
    end
  end
  self.activityInfo = info
  local actIdValue = 0
  if type(info) == "table" then
    local idValue = info.id or info.activityId
    if idValue ~= nil then
      local converter = type(toInt) == "function" and toInt or nil
      if converter then
        actIdValue = converter(idValue)
      else
        actIdValue = math.floor(tonumber(idValue) or 0)
      end
    end
  end
  self.actId = actIdValue
end

function UILWVIPRadarClaimPanelView:RefreshSummary()
  local actId = self.actId
  if actId <= 0 then
    self.textNumTxt:SetText("0")
    return
  end
  local manager = self.vipManager
  if manager == nil then
    self.textNumTxt:SetText("0")
    return
  end
  self.summary = manager:GetSummary(actId)
  if not self.summary then
    self.textNumTxt:SetText("0")
    local cached = manager:GetData(actId, true)
    if cached and cached.isShow == false then
      return
    end
    manager:SendGetInfo(actId)
    return
  end
end

function UILWVIPRadarClaimPanelView:GetFreeRewardsForDisplay()
  if type(self.panelFreeRewards) == "table" then
    return self.panelFreeRewards
  end
  local manager = self.vipManager
  if not manager then
    return {}
  end
  local data = manager:GetData(self.actId)
  if not data then
    return {}
  end
  return data.dailyReward or {}
end

function UILWVIPRadarClaimPanelView:GetPayRewardsForDisplay()
  if type(self.panelPayRewards) == "table" then
    return self.panelPayRewards
  end
  local manager = self.vipManager
  if not manager then
    return {}
  end
  local data = manager:GetData(self.actId)
  if not data then
    return {}
  end
  if data.extraRewardList and data.extraRewardList[1] and data.extraRewardList[1].putBoxParam then
    return data.extraRewardList[1].putBoxParam
  end
  return {}
end

function UILWVIPRadarClaimPanelView:RefreshRewardContainer(container, listFieldName, items, namePrefix, scale, showNum)
  if not (container and UIAssets) or not UIAssets.UICommonResItem then
    return
  end
  local reqList = self[listFieldName]
  if not reqList then
    reqList = {}
    self[listFieldName] = reqList
  end
  local cellFieldName = listFieldName .. "Cells"
  local cellList = self[cellFieldName]
  if not cellList then
    cellList = {}
    self[cellFieldName] = cellList
  end
  if cellFieldName == "freeRewardReqsCells" then
    self.freeRewardCells = cellList
  elseif cellFieldName == "payRewardReqsCells" then
    self.payRewardCells = cellList
  end
  UIUtil.ClearReward(container, reqList)
  for i = #reqList, 1, -1 do
    reqList[i] = nil
  end
  for i = #cellList, 1, -1 do
    cellList[i] = nil
  end
  local rewards = to_array(items)
  if #rewards == 0 then
    return
  end
  for index, reward in ipairs(rewards) do
    local prefabPath = UIAssets.UICommonResItem
    local name = string.format(namePrefix or "vip_radar_claim_reward_%d", index)
    if container.GameObjectInstantiateAsync then
      do
        local req
        local scaleRatio = scale or 1.1
        local itemShowNum = true
        if showNum ~= nil then
          itemShowNum = showNum
        end
        req = container:GameObjectInstantiateAsync(prefabPath, function()
          if not container then
            return
          end
          local go = req and req.gameObject or nil
          if not go then
            return
          end
          go.name = name
          go.transform:SetParent(container.transform)
          go.transform:Set_localScale(scaleRatio, scaleRatio, scaleRatio)
          go.transform:Set_localPosition(0, 0, 0)
          local cell = container:AddComponent(UICommonResItem, go)
          cell:ReInit(reward)
          cell:SetItemCountActive(itemShowNum)
          cellList[index] = cell
        end)
        if req then
          table_insert(reqList, req)
        end
      end
    end
  end
end

function UILWVIPRadarClaimPanelView:RefreshRewardDisplays()
  local freeRewards = to_array(self:GetFreeRewardsForDisplay())
  local payRewards = to_array(self:GetPayRewardsForDisplay())
  self:RefreshRewardContainer(self.accumulateReward, "freeRewardReqs", freeRewards, "vip_radar_claim_free_%d", 1.1)
  self:RefreshRewardContainer(self.payReward, "payRewardReqs", payRewards, "vip_radar_claim_pay_%d", 0.85, false)
  self.textNumTxt:SetText(format_count(sum_reward_quantities(payRewards)))
end

function UILWVIPRadarClaimPanelView:CollectClosePayload()
  local payload = {}
  if self.freeRewardCells and self.freeRewardCells[1] and self.freeRewardCells[1].GetPosition then
    payload.freeStartPos = self.freeRewardCells[1]:GetPosition()
  end
  if self.payRewardCells and #self.payRewardCells > 0 then
    payload.payStartPosList = {}
    for index, cell in ipairs(self.payRewardCells) do
      if cell and cell.GetPosition then
        payload.payStartPosList[index] = cell:GetPosition()
      end
    end
  end
  return payload
end

function UILWVIPRadarClaimPanelView:NotifyCloseCallback()
  if self.closeNotified then
    return
  end
  self.closeNotified = true
  if self.onClosedCallback then
    local payload = self:CollectClosePayload()
    self.onClosedCallback(payload)
  end
end

return UILWVIPRadarClaimPanelView
