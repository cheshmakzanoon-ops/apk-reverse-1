local MAX_ESTIMATE_ITERATOR = 32

local function __estimateTableSize(t, limit)
  local size = 0
  if type(t) == "table" then
    size = size + 56
    for k, v in pairs(t) do
      size = size + 32
      if type(v) == "table" then
        if limit < MAX_ESTIMATE_ITERATOR then
          limit = limit + 1
          size = size + __estimateTableSize(v, limit)
        else
          size = size + 56
        end
      elseif type(v) == "string" then
        size = size + 24 + #v + 1
      end
    end
  end
  return size
end

local function estimateTableSize(t)
  return __estimateTableSize(t, 0)
end

return estimateTableSize
