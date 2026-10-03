local base = UIBaseContainer
local GroupHead = BaseClass("GroupHead", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local path = "GroupChat/zyf_qunliaoyouhua_quanxiaoxi_di2.png"
local selfPath = "GroupChat/zyf_qunliaoyouhua_quanxiaoxi_di1.png"
local maxCount = 9
local layoutMap = {
  {1},
  {2},
  {1, 2},
  {2, 2},
  {2, 3},
  {3, 3},
  {
    1,
    3,
    3
  },
  {
    2,
    3,
    3
  },
  {
    3,
    3,
    3
  }
}

function GroupHead:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GroupHead:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GroupHead:ComponentDefine()
  self.compGroup = self:AddComponent(UIBaseContainer, "group")
  self.headItem = self:AddComponent(UIBaseContainer, "UIPlayerHead")
  self.headItem.gameObject:GameObjectCreatePool()
  self.horizontalItem = self:AddComponent(UIBaseContainer, "layoutItem")
  self.horizontalItem.gameObject:GameObjectCreatePool()
  self.bgImg = self:AddComponent(UIImage, "bg")
end

function GroupHead:UpdateGroupHeadList(uidList, nightModel)
  if not uidList or #uidList == 0 then
    return
  end
  self.headItem.gameObject:GameObjectRecycleAll()
  self.horizontalItem.gameObject:GameObjectRecycleAll()
  self.compGroup:RemoveComponents(UICommonHead)
  local count = #uidList > maxCount and maxCount or #uidList
  self.hSpacing = 5
  self.vSpacing = 5
  local map = layoutMap[count]
  local rowCount = #map
  local maxCol = 0
  for _, col in ipairs(map) do
    if col > maxCol then
      maxCol = col
    end
  end
  local containerWidth = self.compGroup.rectTransform.rect.width
  local containerHeight = self.compGroup.rectTransform.rect.height
  local cellWidth = (containerWidth - self.hSpacing * (maxCol - 1)) / maxCol
  local cellHeight = (containerHeight - self.vSpacing * (rowCount - 1)) / rowCount
  local size = math.min(cellWidth, cellHeight)
  if #uidList == 1 then
    size = size * 0.8
  end
  self:DestroyItem()
  self.rows = {}
  self.headDic = {}
  local avatarIndex = 1
  for i, col in ipairs(map) do
    local row = self.horizontalItem.gameObject:GameObjectSpawn(self.compGroup.transform)
    row.name = "row" .. i
    row = self.compGroup:AddComponent(UIBaseContainer, row.name)
    for j = 1, col do
      local goItem = self.headItem.gameObject:GameObjectSpawn(row.transform)
      goItem.name = "head_" .. i .. j
      goItem = row:AddComponent(UICommonHead, goItem.name)
      goItem:SetSizeDeltaXY(size, size)
      local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(uidList[avatarIndex])
      goItem:SetHeadAndFrame(chatUserInfo.uid, chatUserInfo.headPic, chatUserInfo.headPicVer, false, chatUserInfo.headSkinId, chatUserInfo.headSkinET)
      avatarIndex = avatarIndex + 1
      self.headDic[chatUserInfo.uid] = goItem
    end
    table.insert(self.rows, row)
  end
  if nightModel then
    self.bgImg:LoadSprite(ChatInterface.GetChatUIPath(path))
  end
end

function GroupHead:SetBgImg(path)
  self.bgImg:LoadSprite(path)
end

function GroupHead:DestroyItem()
  for _, row in ipairs(self.rows or {}) do
    row:RemoveComponents(UICommonHead)
  end
  self.compGroup:RemoveComponents(UIBaseContainer)
  self.headItem.gameObject:GameObjectRecycleAll()
  self.horizontalItem.gameObject:GameObjectRecycleAll()
end

function GroupHead:ComponentDestroy()
  self:DestroyItem()
  self.compGroup = nil
end

function GroupHead:DataDefine()
end

function GroupHead:OnRefreshUserInfo(uid)
  if self.headDic and self.headDic[uid] then
    local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(uid)
    self.headDic[uid]:SetHeadAndFrame(chatUserInfo.uid, chatUserInfo.headPic, chatUserInfo.headPicVer, false, chatUserInfo.headSkinId, chatUserInfo.headSkinET)
  end
end

function GroupHead:DataDestroy()
  self.rows = nil
  self.headDic = nil
end

function GroupHead:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnRefreshUserInfo)
end

function GroupHead:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnRefreshUserInfo)
  base.OnRemoveListener(self)
end

return GroupHead
