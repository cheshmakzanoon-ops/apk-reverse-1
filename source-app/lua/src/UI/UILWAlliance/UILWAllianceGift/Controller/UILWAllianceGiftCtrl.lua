local AllianceGiftDataShow = {
  curLevel = 1,
  curExp = 0,
  maxExp = 1,
  list = {}
}
local OneData = DataClass("OneData", AllianceGiftDataShow)
local UILWAllianceGiftCtrl = BaseClass("UILWAllianceGiftCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceGift, {anim = true})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self)
  SFSNetwork.SendMessage(MsgDefines.AllianceGiftList, 0, 1000)
end

local function GetAllianceGiftData(self, type)
  local oneData = OneData.New()
  oneData.curLevel = DataCenter.AllianceGiftDataManager:GetCurLevel()
  oneData.curExp = DataCenter.AllianceGiftDataManager:GetCurExp()
  oneData.maxExp = DataCenter.AllianceGiftDataManager:GetMaxExp()
  local list = DataCenter.AllianceGiftDataManager:GetGiftInfoList(type)
  if list ~= nil then
    table.walk(list, function(k, v)
      local tempGiftType = GetTableData(TableName.AllianceGiftGroup, v.groupId, "type")
      local iGiftType = tonumber(tempGiftType)
      if iGiftType == type then
        local temp = {}
        temp.uuid = v.uuid
        local nameDialog = GetTableData(TableName.AllianceGiftGroup, v.groupId, "name")
        temp.name = Localization:GetString(nameDialog)
        temp.fromUid = v.fromUid
        if v.fromMsg ~= nil then
          if v.fromMsg.fromType == "monster" then
            if v.fromMsg.name ~= nil and v.fromMsg.name ~= "" then
              temp.monsterName = Localization:GetString(v.fromMsg.name)
            end
            temp.name = Localization:GetString(nameDialog, v.fromMsg.level)
          end
          if type == 1 and v.fromMsg.fromType == "exchange" then
            temp.fromPackage = v.fromMsg.name
          end
          if v.fromMsg.fromType == "richManBoss" then
            local userName = v.userName
            if userName == nil or userName == "" then
              userName = Localization:GetString("455106")
            end
            temp.fromTxt = Localization:GetString("richman_boss_desc12", userName)
          end
        end
        local colorStr = GetTableData(TableName.AllianceGiftGroup, v.groupId, "color")
        if colorStr ~= nil and colorStr ~= "" then
          temp.bg = tonumber(colorStr)
        end
        temp.icon = GetTableData(TableName.AllianceGiftGroup, v.groupId, "icon")
        temp.endTime = v.expirationTime
        temp.receiveState = v.receiveState
        temp.receiveTime = v.receiveTime
        temp.userName = v.userName
        temp.groupId = v.groupId
        temp.reward = v.reward
        temp.keyExp = v.keyExp
        temp.eachExp = v.eachExp
        temp.rewardType = type
        table.insert(oneData.list, temp)
      end
    end)
  end
  return oneData
end

local function OnOpenClick(self, uuid, type)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceGiftInfo, {anim = true}, uuid, type)
end

local function OnGetClick(self, uuid, type)
  DataCenter.AllianceGiftDataManager:SetGiftReceive(uuid, type)
  SFSNetwork.SendMessage(MsgDefines.AllianceGiftGetReward, uuid, type)
end

local function OnDelAllBtnClick(self, type)
end

local function OnRemoveClick(self, uuid)
end

local function OnGetAllBtnClick(self, type)
  DataCenter.AllianceGiftDataManager:SetAllGiftReceiveByType(type)
  SFSNetwork.SendMessage(MsgDefines.AllianceReceiveAllGift, type)
end

local function SetNoName(self, state)
  if state then
    SFSNetwork.SendMessage(MsgDefines.AllianceRewardHideName, 1)
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceRewardHideName, 0)
  end
end

local function CheckHasFirstPay()
  local rechargeIds = GiftPackageData.GetRechargeIdListByType(WelfareTagType.FirstCharge)
  if 0 < #rechargeIds then
    local packs = GiftPackageData.GetAllAvailablePackageByRechargeId(rechargeIds[1], false)
    if not table.IsNullOrEmpty(packs) then
      return packs[1]
    end
  end
  return nil
end

UILWAllianceGiftCtrl.CloseSelf = CloseSelf
UILWAllianceGiftCtrl.Close = Close
UILWAllianceGiftCtrl.GetAllianceGiftData = GetAllianceGiftData
UILWAllianceGiftCtrl.InitData = InitData
UILWAllianceGiftCtrl.OnOpenClick = OnOpenClick
UILWAllianceGiftCtrl.OnGetClick = OnGetClick
UILWAllianceGiftCtrl.SetNoName = SetNoName
UILWAllianceGiftCtrl.OnRemoveClick = OnRemoveClick
UILWAllianceGiftCtrl.OnDelAllBtnClick = OnDelAllBtnClick
UILWAllianceGiftCtrl.OnGetAllBtnClick = OnGetAllBtnClick
UILWAllianceGiftCtrl.CheckHasFirstPay = CheckHasFirstPay
return UILWAllianceGiftCtrl
