local base = UIBaseContainer
local MemberListComponent = BaseClass("MemberListComponent", UIBaseContainer)
local GroupMemberItem = require("UI.UIGroupChatSetting.Component.GroupMemberItem")
local memberItemPath = "Assets/Main/Prefabs/UI/ChatNew/GroupChat/GroupChatMemberItem.prefab"

function MemberListComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MemberListComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MemberListComponent:ComponentDefine()
  self.compMemberList = self:AddComponent(UIGridLayoutGroup, "")
end

function MemberListComponent:ComponentDestroy()
  self:ClearMemberList()
  self.compMemberList = nil
end

function MemberListComponent:DataDefine()
  self.frame = nil
end

function MemberListComponent:DataDestroy()
  self.frame = nil
end

function MemberListComponent:SetContentViewScript(content)
  self.content = content
end

function MemberListComponent:ClearMemberList()
  self.compMemberList:RemoveComponents(GroupMemberItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function MemberListComponent:UpdateItem(data, index)
  if not data.memberList then
    return
  end
  local uidList = data.memberList
  self.index = index
  self:ClearMemberList()
  self.model = {}
  local uidListCount = #uidList
  local itemHeight = self.compMemberList:GetCellSize().y
  local spacingY = self.compMemberList:GetCellSpacing().y
  local itemsPerRow = self.compMemberList:GetConstraintCount()
  local rowCount = math.ceil(uidListCount / itemsPerRow)
  local selfHeight = rowCount * itemHeight + (rowCount - 1) * spacingY
  self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, selfHeight)
  for i = 1, uidListCount do
    local idx = i
    local itemData = uidList[i]
    self.model[i] = self:GameObjectInstantiateAsync(memberItemPath, function(request)
      if request.isError then
        return
      end
      local obj = request.gameObject
      obj.name = "head_" .. idx
      obj.transform:SetParent(self.compMemberList.transform, false)
      obj.transform:SetSiblingIndex(idx - 1)
      obj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local goItem = self.compMemberList:AddComponent(GroupMemberItem, obj.name)
      goItem:SetActive(true)
      goItem:UpdateItem(itemData)
    end)
  end
end

function MemberListComponent:SetFrame(frame)
  self.frame = frame
end

function MemberListComponent:OnAddListener()
  base.OnAddListener(self)
end

function MemberListComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MemberListComponent
