local UIActMTTaskCell = BaseClass("UIActMTTaskCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local tipTxt_path = "rewardBg/Tip"
local content_path = "rewardBg/Rewards"
local pro_txt_path = "rewardBg/Txt_Pro"
local getReward_btn_path = "rewardBg/Btn__GetReward"
local getReward_txt_path = "rewardBg/Btn__GetReward/Txt_GetReward"
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self.rewardModels = {}
  self.rewardItemsList = {}
  self.tipN = self:AddComponent(UIText, tipTxt_path)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self._pro_txt = self:AddComponent(UIText, pro_txt_path)
  self._getReward_btn = self:AddComponent(UIButton, getReward_btn_path)
  self._getReward_btn:SetOnClick(function()
    self:GetRewardClick()
  end)
  self._getReward_txt = self:AddComponent(UIText, getReward_txt_path)
end

local function OnDestroy(self)
  self.rewardModels = nil
  self.rewardItemsList = nil
  self.tipN = nil
  self.contentN = nil
  base.OnDestroy(self)
end

local function ShowRewards(self, param, str)
  self.param = param
  local template = string.split(str, ";")
  local templateMonster = DataCenter.ActMonsterTowerData:GetTemplateByIndex(tonumber(template[3]))
  self.tipN:SetLocalText(tonumber(template[1]), template[2], Localization:GetString(templateMonster.difficulty_des), template[4])
  self._pro_txt:SetActive(param.state ~= 1)
  self._pro_txt:SetLocalText(150033, param.num, template[2])
  local isGray = false
  if param.state == 1 or param.num < tonumber(template[2]) then
    isGray = true
  end
  UIGray.SetGray(self._getReward_btn.transform, isGray, param.num >= tonumber(template[2]))
  self._getReward_txt:SetLocalText(param.state == 1 and 371068 or 371058)
  self:SetAllRewardsDestroy()
  self.rewardModelCount = 0
  local list = param.reward
  if list ~= nil and 0 < #list then
    for i = 1, table.length(list) do
      self.rewardModelCount = self.rewardModelCount + 1
      self.rewardModels[self.rewardModelCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.contentN.transform)
        go.transform.localScale = Vector3.New(0.54, 0.54, 1)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.contentN:AddComponent(UICommonResItem, nameStr)
        cell:ReInit(list[i])
        table.insert(self.rewardItemsList, cell)
      end)
    end
  end
end

local function SetAllRewardsDestroy(self)
  self.contentN:RemoveComponents(UICommonResItem)
  if self.rewardModels ~= nil then
    for k, v in pairs(self.rewardModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModels = {}
  self.rewardItemsList = {}
end

local function GetRewardClick(self)
  if self.param.state == 1 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ReceiveChallengeActTaskReward, self.view.actId, self.param.id)
end

UIActMTTaskCell.OnCreate = OnCreate
UIActMTTaskCell.OnDestroy = OnDestroy
UIActMTTaskCell.ShowRewards = ShowRewards
UIActMTTaskCell.SetAllRewardsDestroy = SetAllRewardsDestroy
UIActMTTaskCell.GetRewardClick = GetRewardClick
return UIActMTTaskCell
