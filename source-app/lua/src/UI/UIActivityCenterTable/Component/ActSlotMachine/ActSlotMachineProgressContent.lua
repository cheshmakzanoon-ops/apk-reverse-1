local ActSlotMachineProgressContent = BaseClass("ActSlotMachineProgressContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local progress_content_path = ""
local show_reward_u_i_common_res_item_path = "showProgress/showRewardUICommonResItem"
local progress_num_txt_path = "showProgress/numBg/progressNumTxt"
local red_point_path = "redPoint"

function ActSlotMachineProgressContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActSlotMachineProgressContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ActSlotMachineProgressContent:ComponentDefine()
  self.progress_content = self:AddComponent(UIButton, progress_content_path)
  self.show_reward_u_i_common_res_item = self:AddComponent(UICommonResItem, show_reward_u_i_common_res_item_path)
  self.progress_num_txt = self:AddComponent(UITextMeshProUGUIEx, progress_num_txt_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
end

function ActSlotMachineProgressContent:ComponentDestroy()
  self.progress_content = nil
  self.show_reward_u_i_common_res_item = nil
  self.progress_num_txt = nil
  self.red_point = nil
end

function ActSlotMachineProgressContent:DataDefine()
  self.actId = nil
  self.actinfo = nil
  self.actDetailData = nil
end

function ActSlotMachineProgressContent:DataDestroy()
  self.actId = nil
  self.actinfo = nil
  self.actDetailData = nil
end

function ActSlotMachineProgressContent:SetData(actId, actinfo, actDetailData)
  self.actId = actId
  self.actinfo = actinfo
  self.actDetailData = actDetailData
  self:RefreshView()
end

function ActSlotMachineProgressContent:RefreshView()
  local infoTemp = self.actDetailData.infoTemp
  local scoreRewardData = infoTemp.scoreRewardData
  local scoreRewardShowData = infoTemp.scoreRewardShowData
  local maxNum = scoreRewardData[#scoreRewardData][1]
  local curNum = self.actDetailData.totalScore
  local dataNum = 0
  local curIndex = 0
  for i = 1, #scoreRewardData do
    if curNum < scoreRewardData[i][1] then
      break
    end
    curIndex = i
  end
  local targetShowData
  local RewardStateType = {
    CanGet = 1,
    NotEnough = 2,
    HaveGet = 3
  }
  local rewardState = RewardStateType.CanGet
  for i = 1, curIndex do
    if self.actDetailData.rewardProcessDict[i - 1] == nil then
      rewardState = RewardStateType.CanGet
      targetShowData = scoreRewardShowData[i]
      dataNum = scoreRewardData[i][1]
      break
    end
  end
  if targetShowData == nil and curIndex + 1 < #scoreRewardData then
    rewardState = RewardStateType.NotEnough
    targetShowData = scoreRewardShowData[curIndex + 1]
    dataNum = scoreRewardData[curIndex + 1][1]
  end
  if targetShowData == nil then
    rewardState = RewardStateType.HaveGet
    targetShowData = scoreRewardShowData[#scoreRewardData]
    dataNum = scoreRewardData[#scoreRewardData][1]
  end
  local rewardInfo = {}
  rewardInfo.rewardType = targetShowData[1]
  rewardInfo.itemId = targetShowData[2]
  rewardInfo.count = targetShowData[3]
  self.show_reward_u_i_common_res_item:ReInit(rewardInfo)
  self.progress_num_txt:SetText(string.format("%s/%s", curNum, dataNum))
  local rewardNum = self.actDetailData:GetProgressRewardNum()
  self.red_point:SetActive(0 < rewardNum)
end

return ActSlotMachineProgressContent
