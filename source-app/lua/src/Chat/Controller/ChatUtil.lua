local ChatUtil = BaseClass("ChatUtil")
local RectTransform = CS.UnityEngine.RectTransform
local UI = CS.UnityEngine.UI
local GameObject = CS.UnityEngine.GameObject

function ChatUtil.BinarySearchBySeqId(chatList, targetSeqId, nearest)
  if not targetSeqId or #chatList == 0 then
    return nil
  end
  local low, high = 1, #chatList
  while low <= high do
    local mid = math.floor((low + high) / 2)
    local midSeq = chatList[mid].seqId
    if midSeq == targetSeqId then
      return mid
    elseif targetSeqId > midSeq then
      low = mid + 1
    else
      high = mid - 1
    end
  end
  if not nearest then
    return nil
  end
  local leftIndex = high
  local rightIndex = low
  if leftIndex < 1 then
    return 1
  elseif rightIndex > #chatList then
    return #chatList
  end
  local leftDiff = math.abs(chatList[leftIndex].seqId - targetSeqId)
  local rightDiff = math.abs(chatList[rightIndex].seqId - targetSeqId)
  if leftDiff <= rightDiff then
    return leftIndex
  else
    return rightIndex
  end
end

function ChatUtil.CreateBlackMask(parent, alpha)
  alpha = alpha or 0.6
  local go = GameObject("LuaMask")
  local rt = go:AddComponent(typeof(RectTransform))
  local img = go:AddComponent(typeof(UI.Image))
  rt:SetParent(parent, false)
  rt.anchorMin = Vector2.New(0, 0)
  rt.anchorMax = Vector2.New(1, 1)
  rt.offsetMin = Vector2.New(0, 0)
  rt.offsetMax = Vector2.New(0, 0)
  img.color = Color.New(0, 0, 0, alpha)
  img.raycastTarget = false
  return img.transform
end

function ChatUtil.GetOrAddComponent(go, comp)
  local c = go:GetComponent(comp)
  if IsNull(c) then
    c = go:AddComponent(comp)
  end
  return c
end

function ChatUtil.CreateOrGetBlackMask(gameObject, alpha, addMask)
  alpha = alpha or 0.6
  local mask = gameObject.transform:Find("LuaMask")
  if IsNull(mask) then
    mask = ChatUtil.CreateBlackMask(gameObject.transform, alpha)
  else
    local img = mask.gameObject:GetComponent(typeof(UI.Image))
    if not IsNull(img) then
      img.color = Color.New(0, 0, 0, alpha)
    end
  end
  local maskComponent
  if addMask then
    maskComponent = ChatUtil.GetOrAddComponent(gameObject, typeof(UI.Mask))
  end
  return mask, maskComponent
end

function ChatUtil.GeneratePrivateRoomId(userId)
  local selfUid = LuaEntry.Player.uid
  if userId == selfUid then
    return
  end
  local template = "custom_%s_%s_v2"
  if not ChatInterface.isOnline() then
    template = "test_" .. template
  end
  local roomId
  if tostring(selfUid) > tostring(userId) then
    roomId = string.format(template, selfUid, userId)
  else
    roomId = string.format(template, userId, selfUid)
  end
  return roomId
end

function ChatUtil.GetPlayerUuidByPrivateRoomId(roomId)
  local selfUuid = LuaEntry.Player.uid
  if not roomId or roomId == "" then
    return nil
  end
  roomId = string.gsub(roomId, "^test_", "")
  local uuid1, uuid2 = string.match(roomId, "^custom_(%d+)_(%d+)_v2$")
  if not uuid1 or not uuid2 then
    return nil
  end
  if uuid1 == selfUuid then
    return uuid2
  elseif uuid2 == selfUuid then
    return uuid1
  end
  return nil
end

return ChatUtil
