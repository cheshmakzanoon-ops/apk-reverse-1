local GridInfinityScrollView = BaseClass("GridInfinityScrollView", UIBaseComponent)
local base = UIBaseComponent
local UnityScrollView = typeof(CS.GridInfinityScrollView)

local function OnCreate(self)
  base.OnCreate(self)
  self.content = self.gameObject:GetComponent(UnityScrollView)
end

local function OnDestroy(self)
  self.content:Dispose()
  self.content = nil
  base.OnDestroy(self)
end

local function Init(self, action1, action2, action3, obj)
  self.content:Init(action1, action2, action3, obj)
end

local function SetMaxCount(self, maxCount)
  if maxCount and 0 < maxCount then
    self.content.MaxCount = maxCount
  end
end

local function Dispose(self)
  self.content:Dispose()
end

local function SetItemCount(self, itemCount)
  self.content:SetItemCount(itemCount)
end

local function LaterItemByIndex(self, index, time, itemCount)
  self.content:LaterItemByIndex(index, time, itemCount)
end

local function Remark(self, itemCount)
  self.content:SetItemCount(itemCount)
end

local function ForceUpdate(self)
  self.content:ForceUpdate()
end

local function MoveItemByIndex(self, index, delay)
  self.content:MoveItemByIndex(index, delay)
end

local function GetRenderItemSizeY(self)
  return self.content:GetRenderItemSizeY()
end

local function RefreshMaskSize(self)
  return self.content:RefreshMaskSize()
end

local function IsItemVisible(self, index)
  return self.content:IsItemVisible(index)
end

GridInfinityScrollView.OnCreate = OnCreate
GridInfinityScrollView.OnDestroy = OnDestroy
GridInfinityScrollView.Init = Init
GridInfinityScrollView.Dispose = Dispose
GridInfinityScrollView.LaterItemByIndex = LaterItemByIndex
GridInfinityScrollView.ForceUpdate = ForceUpdate
GridInfinityScrollView.SetItemCount = SetItemCount
GridInfinityScrollView.Remark = Remark
GridInfinityScrollView.MoveItemByIndex = MoveItemByIndex
GridInfinityScrollView.GetRenderItemSizeY = GetRenderItemSizeY
GridInfinityScrollView.RefreshMaskSize = RefreshMaskSize
GridInfinityScrollView.SetMaxCount = SetMaxCount
GridInfinityScrollView.IsItemVisible = IsItemVisible
return GridInfinityScrollView
