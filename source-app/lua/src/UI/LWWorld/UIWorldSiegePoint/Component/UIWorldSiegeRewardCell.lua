local UIWorldSiegeRewardCell = BaseClass("UIWorldSiegeRewardCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local des_txt_path = "desTxt"
local reward_content_path = "rewardContent"

local function OnCreate(self)
  base.OnCreate(self)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
end

local function OnDestroy(self)
  self.des_txt = nil
  self.reward_content = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data, index)
  self.param = data
  self.des_txt:SetText(Localization:GetString("280138", index))
  self:SetRewardCellDestroy()
  local list = self.param
  if list ~= nil then
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.rewardModel[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.reward_content.transform)
        go.transform:Set_localScale(0.5, 0.5, 0.5)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.reward_content:AddComponent(UICommonResItem, nameStr)
        cell:ParseInfo(list[i])
      end)
    end
  end
end

local function SetRewardCellDestroy(self)
  self.reward_content:RemoveComponents(UICommonResItem)
  if self.rewardModel ~= nil then
    for k, v in pairs(self.rewardModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModel = {}
end

UIWorldSiegeRewardCell.OnCreate = OnCreate
UIWorldSiegeRewardCell.OnDestroy = OnDestroy
UIWorldSiegeRewardCell.OnEnable = OnEnable
UIWorldSiegeRewardCell.OnDisable = OnDisable
UIWorldSiegeRewardCell.RefreshData = RefreshData
UIWorldSiegeRewardCell.SetRewardCellDestroy = SetRewardCellDestroy
return UIWorldSiegeRewardCell
