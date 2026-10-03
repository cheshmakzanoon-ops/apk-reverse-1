local FirstJoinAllianceMessage = BaseClass("FirstJoinAllianceMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("chooseLeader", param.chooseLeader)
    self.sfsObj:PutInt("status", param.status)
    if param.isRecommendNew then
      self.sfsObj:PutBool("isRecommendNew", param.isRecommendNew)
    end
  end
  DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.FirstJoinAlliance, true)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    if errCode == "455150" then
      UIUtil.ShowNoToggleSecondMessage("", Localization:GetString("455150"), 2, "", "", function()
        EventManager:GetInstance():Broadcast(EventId.AlCreateJoinViewJumpCreatePage)
      end, function(needSellConfirm)
      end, function()
      end, nil, nil, nil, nil, nil, nil, false)
    else
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
  if message.isRecommendNew then
    local params = {}
    params.showJoin = false
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    return
  end
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if LuaEntry.Player:IsInAlliance() then
    if allianceData.createdByPlayer == false and DataCenter.AllianceBaseDataManager:IsSelfLeader() then
      UIUtil.ShowNoToggleSecondMessage("", Localization:GetString("455149"), 1, "", "", function()
      end, function(needSellConfirm)
      end, function()
      end, nil, nil, nil, nil, nil, nil, false)
    else
      local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      local str = Localization:GetString("390084", allianceData.allianceName)
      UIUtil.ShowTips(str)
      DataCenter.AllianceBaseDataManager:Coalize(t)
    end
  end
end

FirstJoinAllianceMessage.OnCreate = OnCreate
FirstJoinAllianceMessage.HandleMessage = HandleMessage
return FirstJoinAllianceMessage
