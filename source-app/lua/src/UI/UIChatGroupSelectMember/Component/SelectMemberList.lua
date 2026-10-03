local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local SelectMemberList = BaseClass("SelectMemberList", base)
local GroupChatFrame = require("UI.UIChatGroupSelectMember.Component.GroupChatFrame")

function SelectMemberList:GetChatItemScriptName(index)
  return GroupChatFrame
end

function SelectMemberList:GetPostConfig()
end

function SelectMemberList:GetItemPrefabName(index)
  return "GroupChatFrame"
end

function SelectMemberList:OnDestroy()
  base.OnDestroy(self)
end

function SelectMemberList:RefreshViewList()
end

function SelectMemberList:RefreshList(dataList)
  self._chatDatas = dataList
  self:RefreshScrollView()
end

function SelectMemberList:RefreshScrollView()
  self._scrollView:ClearItemPosCache()
  self._scrollView:SetListItemCount_Mod(#self._chatDatas, false, false, true)
end

function SelectMemberList:UpdatePlayer(uid, isOn)
  self.view:UpdatePlayer(uid, isOn)
end

function SelectMemberList:GetSelectUidList()
  local uidList = {}
  for uid, isOn in pairs(self.uidDic) do
    if isOn then
      table.insert(uidList, uid)
    end
  end
  return uidList
end

function SelectMemberList:OnTopPull()
end

local startMaxCount = 60

function SelectMemberList:OnBottomPull()
  if ChatManager2:GetInstance().Room:GetIsNewPrivateList() then
    ChatInterface.getRoomMgr():GetNewPrivateList(#self._chatDatas)
  end
end

return SelectMemberList
