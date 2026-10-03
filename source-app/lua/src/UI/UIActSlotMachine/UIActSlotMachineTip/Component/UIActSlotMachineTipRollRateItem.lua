local UIActSlotMachineTipRollRateItem = BaseClass("UIActSlotMachineTipRollRateItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local slot1_path = "leftContent/slot1"
local slot2_path = "leftContent/slot2"
local slot3_path = "leftContent/slot3"
local u_i_common_res_item_path = "rightContent/UICommonResItem"
local get_num_path = "rightContent/getNum"
local rate_num_path = "rightContent/rateNum"
local bg_path = "bg"

function UIActSlotMachineTipRollRateItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActSlotMachineTipRollRateItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActSlotMachineTipRollRateItem:ComponentDefine()
  self.slot1 = self:AddComponent(UIImage, slot1_path)
  self.slot2 = self:AddComponent(UIImage, slot2_path)
  self.slot3 = self:AddComponent(UIImage, slot3_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.get_num = self:AddComponent(UITextMeshProUGUIEx, get_num_path)
  self.rate_num = self:AddComponent(UITextMeshProUGUIEx, rate_num_path)
  self.bg = self:AddComponent(UIImage, bg_path)
end

function UIActSlotMachineTipRollRateItem:ComponentDestroy()
  self.slot1 = nil
  self.slot2 = nil
  self.slot3 = nil
  self.u_i_common_res_item = nil
  self.get_num = nil
  self.rate_num = nil
  self.bg = nil
end

function UIActSlotMachineTipRollRateItem:DataDefine()
  self.groupid = nil
  self.param = nil
end

function UIActSlotMachineTipRollRateItem:DataDestroy()
  self.groupid = nil
  self.param = nil
end

function UIActSlotMachineTipRollRateItem:SetData(param, groupid, dropshow)
  self.groupid = groupid
  self.param = param
  self.dropshow = dropshow
  local rewardStr = self.param.temp.reward_show
  local rewardData = string.string2array_i(rewardStr, ";", "|")
  local showRewardData = {}
  local count = 0
  if rewardData[1] then
    if rewardData[1][1] == 1 then
      showRewardData = {
        rewardType = ResTypeToReward[rewardData[1][2]]
      }
      count = rewardData[1][3]
    else
      showRewardData = {
        rewardType = rewardData[1][1],
        itemId = rewardData[1][2]
      }
      count = rewardData[1][3]
    end
  end
  self.u_i_common_res_item:ReInit(showRewardData)
  self.get_num:SetText("x" .. count)
  local id1, id2, id3 = self:GetIdsByType(self.param.type)
  self.slot1:LoadSprite(self:GetImgPathByCfgId(id1))
  self.slot2:LoadSprite(self:GetImgPathByCfgId(id2))
  self.slot3:LoadSprite(self:GetImgPathByCfgId(id3))
  local rateNum = DataCenter.ActSlotMachineDataManager:GetDropShowRate(self.dropshow, self.param.type)
  self.rate_num:SetText(string.format("%.2f", rateNum / 100) .. "%")
  local scaleX = CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1
  self.bg:SetLocalScaleXYZ(scaleX, 1, 1)
end

function UIActSlotMachineTipRollRateItem:GetImgPathByCfgId(id)
  local path = ""
  if 0 < id then
    local temp = DataCenter.ActSlotMachineDataManager.iconDict[id]
    local imgName = temp.icon
    path = string.format(LoadPath.ItemPath, imgName)
  else
    local imgName = "Sprite/ActSlotMachine_remote/Mjc_huodong_laba_choujiangshuoming_icon01"
    path = string.format(UIAssets.UIActSlotMachineSpritePath, imgName)
  end
  return path
end

function UIActSlotMachineTipRollRateItem:GetIdsByType(type)
  local id1, id2, id3 = -1, -1, -1
  local data = DataCenter.ActSlotMachineDataManager.ActSlotRollResultTypeToIconId[self.groupid][type]
  if data and #data == 3 then
    id1 = data[1]
    id2 = data[2]
    id3 = data[3]
  end
  return id1, id2, id3
end

return UIActSlotMachineTipRollRateItem
