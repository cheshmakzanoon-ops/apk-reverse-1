local AlHelpAllMessage = BaseClass("AlHelpAllMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local _helpBtnPos, _flyToPos, _isOnlyDisperse, _isOnlyShowDiff

local function OnCreate(self, cmdBaseTime, helpBtnPos, toPos, isOnlyDisperse, isOnlyShowDiff)
  base.OnCreate(self)
  self.sfsObj:PutLong("cmdBaseTime", cmdBaseTime)
  _helpBtnPos = helpBtnPos
  _flyToPos = toPos
  _isOnlyDisperse = isOnlyDisperse
  _isOnlyShowDiff = isOnlyShowDiff
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local otherHelpInfoList = DataCenter.AllianceHelpDataManager.otherHelpInfoList
    DataCenter.AllianceHelpDataManager:OnHelpAll()
    if t.accPoint then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint, _helpBtnPos, _flyToPos, _isOnlyDisperse, _isOnlyShowDiff)
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceHelpSever)
    EventManager:GetInstance():Broadcast(EventId.UpdateAllianceHelpNum)
    UIUtil.ShowTipsId(390170)
  end
end

AlHelpAllMessage.OnCreate = OnCreate
AlHelpAllMessage.HandleMessage = HandleMessage
return AlHelpAllMessage
