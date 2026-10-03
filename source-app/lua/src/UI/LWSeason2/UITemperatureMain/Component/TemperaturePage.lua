local TemperaturePage = BaseClass("TemperaturePage", UIBaseContainer)
local base = UIBaseContainer
local text1_path = "head1/text1"
local text2_path = "head2/text2"
local text3_path = "head3/text3"
local text4_path = "head4/text4"
local content_path = "Scroll/ViewPort/Content"
local bar_path = "Scroll/ViewPort/Content/bar"
local TemperatureCell = require("UI.LWSeason2.UITemperatureMain.Component.TemperatureCell")

function TemperaturePage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TemperaturePage:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TemperaturePage:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.bar = self:AddComponent(UIBaseComponent, bar_path)
  self.scrollRect = self:AddComponent(UIScrollRect, "Scroll")
  self.head = {}
  for i = 1, 4 do
    local head = self:AddComponent(UIButton, "head" .. i)
    head:SetOnClick(function()
      self:OnClickHead(i)
    end)
    self.head[i] = head
  end
end

function TemperaturePage:ComponentDestroy()
end

function TemperaturePage:OnClickHead(index)
  local temp = DataCenter.TemperatureManager:GetMyBaseTemperature()
  local curMeta, mark = DataCenter.TemperatureTemplateManager:GetTemplate(math.floor(temp))
  UIUtil.ShowBubbleTips(curMeta:GetDesc(index), self.head[index].transform.position, 0, -20, -20, nil, curMeta:GetName(index))
end

function TemperaturePage:Refresh()
  self:RemoveCells()
  local data = {}
  local allTempByTen = DataCenter.TemperatureTemplateManager:GetAllTemplateByTen()
  for _, v in ipairs(allTempByTen) do
    table.insert(data, v)
  end
  local temp = DataCenter.TemperatureManager:GetMyBaseTemperature()
  temp = math.floor(temp)
  local curMeta, mark = DataCenter.TemperatureTemplateManager:GetTemplate(temp)
  if mark == 1 then
    table.insert(data, 1, curMeta)
    self.curIndex = 1
  elseif mark == -1 then
    table.insert(data, curMeta)
    self.curIndex = #data
  elseif temp % 10 == 0 then
    for i, v in ipairs(data) do
      if temp == v.temperature then
        self.curIndex = i
        break
      end
    end
  else
    for i, v in ipairs(data) do
      if temp > v.temperature then
        table.insert(data, i, curMeta)
        self.curIndex = i
        break
      end
    end
  end
  local count = #data
  for k, v in ipairs(data) do
    self.reqs[k] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWSeason2/TemperatureCell.prefab", function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "TemperatureCell" .. k
      item.transform:SetParent(self.content.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.content:AddComponent(TemperatureCell, item.name)
      obj:SetData(v, k == self.curIndex, temp)
      if k == count then
        self.bar.transform:SetSiblingIndex(k + 1)
        if self.curIndex > 8 then
          self.scrollRect:SetVerticalNormalizedPosition((count - self.curIndex) / (count - 1))
        end
      end
    end)
  end
end

function TemperaturePage:RemoveCells()
  self.content:RemoveComponents(TemperatureCell)
  if self.reqs then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = {}
end

return TemperaturePage
