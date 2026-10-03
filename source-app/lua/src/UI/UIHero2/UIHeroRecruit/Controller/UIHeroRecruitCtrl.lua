local UIHeroRecruitCtrl = BaseClass("UIHeroRecruitCtrl", UIBaseCtrl)

local function CloseSelf(self)
  DataCenter.ArrowManager:RemoveArrow()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroRecruit)
end

local function OnClickGoldBtn(self)
  local param = {}
  CS.UIPreAdd.OpenGiftPackage(param)
end

local function GetSortedLotteryList(self)
  local dict = DataCenter.LotteryDataManager:GetOtherLotteryDict()
  local list = table.values(dict)
  table.sort(list, function(a, b)
    if a.order ~= b.order then
      return a.order > b.order
    end
    return tonumber(a.id) < tonumber(b.id)
  end)
  return list
end

local function GetNewLotteryList(self)
  local dict = DataCenter.LotteryDataManager:GetOtherLotteryDict()
  local list = table.values(dict)
  table.sort(list, function(a, b)
    local isOpenA = a:IsOpen()
    local isOpenB = b:IsOpen()
    if isOpenA and not isOpenB then
      return true
    end
    if isOpenA then
      return a.order > b.order
    elseif a.startTime ~= b.startTime then
      return a.startTime < b.startTime
    end
    return tonumber(a.id) < tonumber(b.id)
  end)
  local workerLotteryDict = DataCenter.LotteryDataManager:GetWorkerLotteryDict()
  for k, v in pairs(workerLotteryDict) do
    table.insert(list, v)
  end
  return list
end

local function GePackageInfo(self, itemId)
  local package = GiftPackageData.GetGivenPacks(itemId)
  if package and 0 < #package then
    return package[1]
  end
end

local function GetPackageInfoByItemId(self, itemId)
  local info
  local tipTemplates = DataCenter.LWResourceLackManager:GetGoodsWay(tonumber(itemId))
  if not tipTemplates or #tipTemplates == 0 then
    return info
  end
  local need = 1
  local dataList = LWResourceLackUtil:FilterResourceTemplates(tipTemplates, need)
  local groupId = ""
  if tipTemplates ~= nil then
    for k, v in pairs(dataList) do
      if v.tips == LWResourceLackGetWay.GiftPackage then
        groupId = v.para1
        break
      end
    end
  end
  if string.IsNullOrEmpty(groupId) then
    return info
  end
  local packsInfo = {}
  local groups = string.split(groupId, "|")
  for i = 1, #groups do
    packsInfo = GiftPackManager.GetPacksByGroupId(groups[i], false)
    packsInfo = GiftPackManager.FilterVipPacksExclude(packsInfo, VipPayGoodState.HasGet, true)
    if not table.IsNullOrEmpty(packsInfo) then
      break
    end
  end
  if packsInfo ~= nil and 0 < #packsInfo then
    info = packsInfo[1]
  else
    info = nil
  end
  return info
end

local function GetDataFromServer(self)
  SFSNetwork.SendMessage(MsgDefines.GetHeroLotteryInfo)
end

UIHeroRecruitCtrl.CloseSelf = CloseSelf
UIHeroRecruitCtrl.OnClickGoldBtn = OnClickGoldBtn
UIHeroRecruitCtrl.GetSortedLotteryList = GetSortedLotteryList
UIHeroRecruitCtrl.GetNewLotteryList = GetNewLotteryList
UIHeroRecruitCtrl.GePackageInfo = GePackageInfo
UIHeroRecruitCtrl.GetDataFromServer = GetDataFromServer
UIHeroRecruitCtrl.GetPackageInfoByItemId = GetPackageInfoByItemId
return UIHeroRecruitCtrl
