local UIDesertRulesRewardItemPoint = BaseClass("UIDesertRulesRewardItemPoint", UIBaseContainer)
local base = UIBaseContainer

function UIDesertRulesRewardItemPoint:OnCreate()
  base.OnCreate(self)
  self.point_cell = self:AddComponent(UIText, "")
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/Content")
  self.line = self:AddComponent(UIImage, "line")
  self.reqList = {}
end

function UIDesertRulesRewardItemPoint:OnDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.reqList then
    for _, req in pairs(self.reqList) do
      if req then
        req:Destroy()
      end
    end
    self.reqList = nil
  end
  base.OnDestroy(self)
end

function UIDesertRulesRewardItemPoint:ReInit(data, rewards)
  self.point_cell:SetText(string.format("%s-%s", data.s, data.e))
  local rCnt = #rewards
  local iCnt = #self.reqList
  local max = math.max(rCnt, iCnt)
  for i = 1, max do
    local cellIdx = i
    local theName = "Icon" .. cellIdx
    local req = self.reqList[cellIdx]
    if req ~= nil then
      self.content:RemoveComponent(theName, UICommonResItem)
      req:Destroy()
      self.reqList[cellIdx] = nil
    end
    local reward = rewards[cellIdx]
    if reward ~= nil then
      self.reqList[cellIdx] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          if self.reqList then
            self.reqList[cellIdx] = nil
          end
          return
        end
        local go = request.gameObject
        go.name = theName
        go.gameObject:SetActive(true)
        local tf = go.transform
        tf:SetParent(self.content.transform)
        tf:Reset()
        local cell = self.content:AddComponent(UICommonResItem, theName)
        cell:SetSizeDeltaXY(COMMON_RES_ITEM_DEF_SIZE, COMMON_RES_ITEM_DEF_SIZE)
        cell:SetLocalScaleXYZ(0.8, 0.8, 1)
        cell:ReInit(reward)
      end)
    end
  end
end

return UIDesertRulesRewardItemPoint
