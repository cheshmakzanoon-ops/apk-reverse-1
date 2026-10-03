local base = UIBaseContainer
local UIEBR_VsInfo = BaseClass("UIEBR_VsInfo", base)
local UIEBR_VsItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleResult.Component.UIEBR_VsItem")
local user_self_path = "UserSelf"
local user_other_path = "UserOther"

function UIEBR_VsInfo:OnCreate()
  base.OnCreate(self)
  self.user_self = self:AddComponent(UIEBR_VsItem, user_self_path)
  self.user_other = self:AddComponent(UIEBR_VsItem, user_other_path)
end

function UIEBR_VsInfo:OnDestroy()
  self.user_self = nil
  self.user_other = nil
  base.OnDestroy(self)
end

function UIEBR_VsInfo:SetData(msg)
  local myRole = msg.role
  local aList1, aList2 = {}, {}
  local alliances = msg.alliances or {}
  for _, v in ipairs(alliances) do
    if v.role == myRole then
      table.insert(aList1, v)
    else
      table.insert(aList2, v)
    end
  end
  local myInfo, otherInfo
  if myRole == 1 then
    myInfo = msg.landlord
    otherInfo = msg.farmer
  else
    myInfo = msg.farmer
    otherInfo = msg.landlord
  end
  if myInfo and otherInfo then
    self.user_self:SetData(myInfo, aList1)
    self.user_other:SetData(otherInfo, aList2)
    return myInfo.isWin, myInfo, otherInfo
  end
  return false, nil, nil
end

return UIEBR_VsInfo
