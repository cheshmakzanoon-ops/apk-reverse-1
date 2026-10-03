local UIActSlotMachineTipBoxRateItem = BaseClass("UIActSlotMachineTipBoxRateItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local title_txt_path = "titleTxt"
local reward_rate_item_path = "rewardRateContent/rewardRateItem"
local ItemShowNum = 4

function UIActSlotMachineTipBoxRateItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActSlotMachineTipBoxRateItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActSlotMachineTipBoxRateItem:ComponentDefine()
  self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
  self.info_items = {}
  for i = 1, ItemShowNum do
    local root = self:AddComponent(UIBaseContainer, reward_rate_item_path .. i)
    self.info_items[i] = {
      root = root,
      UICommonResItem = root:AddComponent(UICommonResItem, "UICommonResItem"),
      rateTxt = root:AddComponent(UITextMeshProUGUIEx, "rateTxt")
    }
  end
end

function UIActSlotMachineTipBoxRateItem:ComponentDestroy()
  self.title_txt = nil
  self.info_items = nil
end

function UIActSlotMachineTipBoxRateItem:DataDefine()
  self.param = nil
end

function UIActSlotMachineTipBoxRateItem:DataDestroy()
  self.param = nil
end

function UIActSlotMachineTipBoxRateItem:SetData(param, totalW)
  self.param = param
  self.totalW = totalW
  local boxRateNum = param.rate_show / totalW * 100
  local titleTxt = Localization:GetString(self.param.name) .. " " .. string.format("%.2f", boxRateNum) .. "%"
  self.title_txt:SetText(titleTxt)
  local rewardData = string.string2array_i(self.param.box_reward, ";", "|")
  local totalRate = 0
  for i = 1, #rewardData do
    local curRate = self.param.box_reward_rate_show[i] or 0
    totalRate = totalRate + curRate
  end
  for i = 1, ItemShowNum do
    if rewardData[i] then
      self.info_items[i].root:SetActive(true)
      local showRewardData = {}
      if rewardData[i][1] == 1 then
        showRewardData = {
          rewardType = ResTypeToReward[rewardData[i][2]],
          count = rewardData[i][3]
        }
      else
        showRewardData = {
          rewardType = rewardData[i][1],
          itemId = rewardData[i][2],
          count = rewardData[i][3]
        }
      end
      local curRate = self.param.box_reward_rate_show[i] or 0
      local rateNum = curRate / totalRate * 100
      self.info_items[i].UICommonResItem:ReInit(showRewardData)
      self.info_items[i].rateTxt:SetText(string.format("%.2f", rateNum) .. "%")
    else
      self.info_items[i].root:SetActive(false)
    end
  end
end

return UIActSlotMachineTipBoxRateItem
