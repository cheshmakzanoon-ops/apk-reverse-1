local function default_fcompval(value)
  return value
end

local function fcompf(a, b)
  return a < b
end

local function fcompr(a, b)
  return b < a
end

function table.binsearch(tbl, value, fcompval, reversed)
  local fcompval = fcompval or default_fcompval
  local fcomp = reversed and fcompr or fcompf
  local iStart, iEnd, iMid = 1, #tbl, 0
  while iStart <= iEnd do
    iMid = math.floor((iStart + iEnd) / 2)
    local value2 = fcompval(tbl[iMid])
    if value == value2 then
      local tfound, num = {iMid, iMid}, iMid - 1
      while value == fcompval(tbl[num]) do
        tfound[1], num = num, num - 1
      end
      num = iMid + 1
      while value == fcompval(tbl[num]) do
        tfound[2], num = num, num + 1
      end
      return tfound
    elseif fcomp(value, value2) then
      iEnd = iMid - 1
    else
      iStart = iMid + 1
    end
  end
end

function table.bininsert(t, value, fcomp)
  local fcomp = fcomp or fcompf
  local iStart, iEnd, iMid, iState = 1, #t, 1, 0
  while iStart <= iEnd do
    iMid = math.floor((iStart + iEnd) / 2)
    if fcomp(value, t[iMid]) then
      iEnd, iState = iMid - 1, 0
    else
      iStart, iState = iMid + 1, 1
    end
  end
  table.insert(t, iMid + iState, value)
  return iMid + iState
end

function table.randomKey(tbl)
  local c = table.count(tbl)
  local idx = math.random(1, c)
  local i = 1
  for k, v in pairs(tbl) do
    if i == idx then
      return k
    end
    i = i + 1
  end
  return nil
end
