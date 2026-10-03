local UILoopScrollTextVer = BaseClass("UILoopScrollTextVer")
local table_remove = table.remove
local table_insert = table.insert
local State = {
  Idle = 1,
  Stay = 2,
  Scrolling = 3
}
local UPDATE_INTERNAL = 0.1

local function __init(self)
  self.visibleCount = 0
  self.itemSize = 0
  self.scrollDuration = 0.3
  self.stayDuration = 1.5
  self.state = State.Idle
  self.speed = 20
  self.bufferCount = self.visibleCount + 1
  self.items = {}
  self.dataCount = 0
  self.updateItemCallback = nil
  self.offset = 0
  self.startIndex = 1
  self.stayDuration = 1.2
  self.stayTimer = self.stayDuration
end

local function __delete(self)
  self:RemoveTimer()
  self.visibleCount = nil
  self.itemSize = nil
  self.scrollDuration = nil
  self.stayDuration = nil
  self.state = nil
  self.speed = nil
  self.bufferCount = nil
  self.items = nil
  self.dataCount = nil
  self.updateItemCallback = nil
  self.offset = nil
  self.startIndex = nil
  self.stayTimer = nil
  self.stayDuration = nil
end

local function InitCom(self, visibleCount, itemSize)
  self.visibleCount = visibleCount
  self.itemSize = itemSize
end

local function BindItems(self, itemList, content)
  self.items = itemList
  local count = itemList and #itemList or 0
  self:SetDataCount(count)
  self.content = content
  self:RemoveTimer()
  if 1 < count then
    self:AddTimer()
  end
end

local function SetDataCount(self, count)
  self.dataCount = count
  if count <= 1 then
    self.state = State.Idle
  else
    self.state = State.Stay
    self.stayTimer = self.stayDuration
  end
end

local function SetUpdateItemCallback(self, func)
  self.updateItemCallback = func
end

local function GetLoopIndex(self, index)
  return (index - 1) % self.dataCount + 1
end

local function Refresh(self)
  self.offset = 0
  self.startIndex = 1
  local offsetY = 0
  for i, item in ipairs(self.items) do
    local dataIndex = GetLoopIndex(self, self.startIndex + i - 1)
    if self.updateItemCallback then
      self.updateItemCallback(item, dataIndex)
    end
    local height = self.itemSize
    local y = -(i - 1) * self.itemSize - self.itemSize / 2
    item:SetAnchoredPositionXY(item:GetAnchoredPositionX(), y)
    offsetY = offsetY + height
  end
  self.content:SetAnchoredPositionXY(0, 0)
end

local function Update(self)
  if self.state == State.Idle then
    return
  end
  if self.state == State.Stay then
    self.stayTimer = self.stayTimer - UPDATE_INTERNAL
    if self.stayTimer <= 0 then
      self.state = State.Scrolling
    end
    return
  end
  local move = self.speed * UPDATE_INTERNAL
  self.offset = self.offset + move
  while true do
    local safeOffset = 2
    if self.offset >= self.itemSize + safeOffset then
      self.offset = self.offset - self.itemSize
      self:Shift()
      self.state = State.Stay
      self.stayTimer = self.stayDuration
      break
    else
      break
    end
  end
  self.content:SetAnchoredPositionXY(0, self.offset)
end

local function UpdateContinuous(self, dt)
  self.offset = self.offset + self.speed * dt
  if self.offset >= self.itemSize then
    self.offset = self.offset - self.itemSize
    self:Shift()
  end
end

local function Shift(self)
  self.startIndex = self.startIndex + 1
  if self.startIndex > self.dataCount then
    self.startIndex = 1
  end
  local firstItem = table_remove(self.items, 1)
  table_insert(self.items, firstItem)
  local dataIndex = self.startIndex + self.visibleCount - 1
  dataIndex = (dataIndex - 1) % self.dataCount + 1
  if self.updateItemCallback then
    self.updateItemCallback(firstItem, dataIndex)
  end
  self:ReLayout()
end

local function ReLayout(self)
  local offsetY = 0
  for i, item in ipairs(self.items) do
    local y = -(i - 1) * self.itemSize - self.itemSize / 2
    item:SetAnchoredPositionXY(item:GetAnchoredPositionX(), y)
    offsetY = offsetY + self.itemSize
  end
end

local function AddTimer(self)
  if self.updateTimer == nil then
    self.updateTimer = TimerManager:GetInstance():GetTimer(UPDATE_INTERNAL, BindCallback(self, self.Update), self, false, false, false)
  end
  self.updateTimer:Start()
end

local function RemoveTimer(self)
  if self.updateTimer ~= nil then
    self.updateTimer:Stop()
    self.updateTimer = nil
  end
end

UILoopScrollTextVer.__init = __init
UILoopScrollTextVer.__delete = __delete
UILoopScrollTextVer.InitCom = InitCom
UILoopScrollTextVer.BindItems = BindItems
UILoopScrollTextVer.SetDataCount = SetDataCount
UILoopScrollTextVer.SetUpdateItemCallback = SetUpdateItemCallback
UILoopScrollTextVer.Refresh = Refresh
UILoopScrollTextVer.Update = Update
UILoopScrollTextVer.UpdateContinuous = UpdateContinuous
UILoopScrollTextVer.Shift = Shift
UILoopScrollTextVer.ReLayout = ReLayout
UILoopScrollTextVer.AddTimer = AddTimer
UILoopScrollTextVer.RemoveTimer = RemoveTimer
return UILoopScrollTextVer
