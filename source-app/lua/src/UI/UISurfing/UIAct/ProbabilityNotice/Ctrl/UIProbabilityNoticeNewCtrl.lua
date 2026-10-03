local UIProbabilityNoticeNewCtrl = BaseClass("UIProbabilityNoticeNewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIProbabilityNoticeNew)
end

local function GetDropHeroList(self, lotteryId)
  local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
  if lotteryData == nil or lotteryData.dropHeroInfo == nil then
    return {}
  end
  local list = {}
  local dropList = string.split(lotteryData.dropHeroInfo, "|")
  for _, v in ipairs(dropList) do
    if v and v ~= "" then
      table.insert(list, tonumber(v))
    end
  end
  return list
end

local function GetDropRateInfo(self, lotteryId)
  local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
  if lotteryData == nil then
    return nil
  end
  local dropInfo = GetTableData(TableName.HeroRecruit, lotteryId, "dropinfo")
  local dict = {}
  local dropList = string.split(dropInfo, ";")
  for _, v in ipairs(dropList) do
    local dropItem = string.split(v, "|")
    if 2 <= #dropItem then
      dict[tonumber(dropItem[1])] = dropItem[2]
    end
  end
  return dict
end

local function GetDropCampInfo(self, lotteryId)
  local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
  if lotteryData == nil or lotteryData.dropCampInfo == nil then
    return {}
  end
  local campList = string.split(lotteryData.dropCampInfo, "|")
  return campList
end

UIProbabilityNoticeNewCtrl.CloseSelf = CloseSelf
UIProbabilityNoticeNewCtrl.GetDropHeroList = GetDropHeroList
UIProbabilityNoticeNewCtrl.GetDropCampInfo = GetDropCampInfo
UIProbabilityNoticeNewCtrl.GetDropRateInfo = GetDropRateInfo
return UIProbabilityNoticeNewCtrl
