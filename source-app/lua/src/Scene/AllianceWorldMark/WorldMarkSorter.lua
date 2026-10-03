local Sorter = {}
Sorter.marks = {}
Sorter.enabled = false
Sorter.ascending = false

function Sorter.RegisterMark(markData, worldPos, markSorter)
  if markData == nil or worldPos == nil or markSorter == nil then
    return
  end
  table.insert(Sorter.marks, {
    data = markData,
    pos = worldPos,
    sorter = markSorter
  })
  Sorter.reSort = true
  if not Sorter.enabled then
    UpdateManager:GetInstance():AddUpdate(Sorter.OnUpdate)
    EventManager:GetInstance():AddListener(EventId.SCREEN_TOUCH_MOVE, Sorter.OnScreenTouchMove)
    Sorter.enabled = true
  end
end

function Sorter.UnregisterMark(markData)
  if markData == nil then
    return
  end
  for i = #Sorter.marks, 1, -1 do
    if Sorter.marks[i].data == markData then
      table.remove(Sorter.marks, i)
      break
    end
  end
  if Sorter.enabled and #Sorter.marks == 0 then
    UpdateManager:GetInstance():RemoveUpdate(Sorter.OnUpdate)
    EventManager:GetInstance():RemoveListener(EventId.SCREEN_TOUCH_MOVE, Sorter.OnScreenTouchMove)
    Sorter.enabled = false
  end
end

function Sorter.OnUpdate()
  if Sorter.reSort then
    Sorter.reSort = false
    table.sort(Sorter.marks, function(a, b)
      if Sorter.ascending then
        if a.pos.z == b.pos.z then
          return a.pos.x > b.pos.x
        else
          return a.pos.z > b.pos.z
        end
      elseif a.pos.z == b.pos.z then
        return a.pos.x < b.pos.x
      else
        return a.pos.z < b.pos.z
      end
    end)
    for i = 1, #Sorter.marks do
      if IsNull(Sorter.marks[i].sorter) then
      else
        Sorter.marks[i].sorter.BaseOrder = 100 + i * 10
      end
    end
  end
end

function Sorter.OnScreenTouchMove(touchInfo)
  local ascending = touchInfo.deltaPos.x > 0
  if ascending ~= Sorter.ascending then
    Sorter.ascending = ascending
    Sorter.reSort = true
  end
end

return Sorter
