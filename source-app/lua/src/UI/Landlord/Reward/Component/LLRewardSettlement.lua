local base = UIAsyncContainer
local LLRewardSettlement = BaseClass("LLRewardSettlement", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local ActMgr = DataCenter.LandlordMgr

function LLRewardSettlement:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRewardSettlement:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRewardSettlement:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compWin = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compFail = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textFail = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textWin = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
end

function LLRewardSettlement:ComponentDestroy()
  self.viewSkin = nil
  self.textTime = nil
  self.textDesc = nil
  self.compWin = nil
  self.compFail = nil
  self.textFail = nil
  self.textWin = nil
end

function LLRewardSettlement:DataDefine()
  self.asyncs = {}
  self.items = {}
  self.rewards = {}
  self.eTime = nil
end

function LLRewardSettlement:DataDestroy()
  if self.compWin ~= nil then
    self.compWin:RemoveAllComponentes()
  end
  if self.compFail ~= nil then
    self.compFail:RemoveAllComponentes()
  end
  self.asyncs = nil
  self.items = nil
  self.rewards = nil
  self.eTime = nil
end

function LLRewardSettlement:OnAddListener()
  base.OnAddListener(self)
end

function LLRewardSettlement:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRewardSettlement:SetCamp(camp)
  self.camp = camp
  self:RefreshView()
end

function LLRewardSettlement:UpdateData()
  self.eTime = ActMgr:GetWeekBattleEndTime(ActMgr:GetBattleWeek())
  self:UpdateTime()
  self:RefreshReward(self.compWin, LLConst.RewardType.Win)
  self:RefreshReward(self.compFail, LLConst.RewardType.Lose)
end

function LLRewardSettlement:Update1000MS()
  if self.eTime == nil or self.eTime == 0 then
    return
  end
  self:UpdateTime()
end

function LLRewardSettlement:UpdateTime()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remain = self.eTime - curSec
  if 0 < remain then
    self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtString(remain))
  else
    local newETime = ActMgr:GetWeekBattleEndTime(ActMgr:GetBattleWeek())
    if newETime ~= self.eTime then
      self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtString(0))
      self.eTime = newETime
    else
      self.textTime:SetLocalText("zonewar_landlord_limit_1050")
      self.eTime = 0
    end
  end
end

function LLRewardSettlement:RefreshReward(comp, rewardType)
  local list = ActMgr:GetReward(rewardType, self.camp)
  local info = list[1]
  if table.IsNullOrEmpty(info) then
    return
  end
  local value = info.para ~= nil and info.para[1] or 0
  local bLord = self.camp == LLConst.LandLordGroup.LORD
  if rewardType == LLConst.RewardType.Win then
    self.textWin:SetLocalText(bLord and "zonewar_landlord_desc_1024" or "zonewar_landlord_desc_1022", value)
  else
    self.textFail:SetLocalText(bLord and "zonewar_landlord_desc_1025" or "zonewar_landlord_desc_1023", value)
  end
  self.rewards = self.rewards or {}
  self.asyncs = self.asyncs or {}
  self.items = self.items or {}
  local rewards = RewardUtil.GetRewardsById(info.reward)
  self.rewards[rewardType] = rewards
  local items = self.items[rewardType] or {}
  self.items[rewardType] = items
  local asyncs = self.asyncs[rewardType] or {}
  self.asyncs[rewardType] = asyncs
  local iCnt = #items
  local rCnt = #rewards
  local max = math.max(iCnt, rCnt)
  for i = 1, max do
    local reward = rewards[i]
    local item = items[i]
    if reward ~= nil then
      if item ~= nil then
        self:RefreshIcon(i, rewardType)
      else
        local async = asyncs[i]
        if async == nil then
          local idx = i
          async = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.name = "Item_" .. idx
            go.gameObject:SetActive(true)
            local tf = go.transform
            tf:SetParent(comp.transform)
            tf:Reset()
            local cell = comp:AddComponent(UICommonResItem, go.name)
            items[idx] = cell
            cell:SetSizeDeltaXY(COMMON_RES_ITEM_DEF_SIZE, COMMON_RES_ITEM_DEF_SIZE)
            cell:SetLocalScaleXYZ(0.8, 0.8, 1)
            self:RefreshIcon(idx, rewardType)
          end)
          asyncs[i] = async
        end
      end
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
end

function LLRewardSettlement:RefreshIcon(i, rewardType)
  local item = self.items[rewardType][i]
  if item == nil then
    return
  end
  local info = self.rewards[rewardType][i]
  item:SetActive(info ~= nil)
  if info ~= nil then
    item:ReInit(info)
  end
end

return LLRewardSettlement
