local UITimeDSTTest = {}

local function Log(...)
  if Logger and Logger.LogInfo then
    Logger.LogInfo(string.format(...))
  else
    print(string.format(...))
  end
end

local function DumpTime(tag, t)
  if not t then
    Log("%s: <nil>", tag)
    return
  end
  Log("%s: %04d-%02d-%02d %02d:%02d:%02d, isdst=%s", tag, t.year, t.month, t.day, t.hour, t.min, t.sec, tostring(t.isdst))
end

local function CloneTimeTable(t)
  return {
    year = t.year,
    month = t.month,
    day = t.day,
    hour = t.hour,
    min = t.min,
    sec = t.sec,
    isdst = t.isdst
  }
end

local function TryRawOsTime(t)
  local ok, tsOrError = pcall(os.time, t)
  if ok then
    return tsOrError, nil
  end
  return nil, tsOrError
end

local function DumpTimestampResult(prefix, ts, errorMsg)
  if ts == nil then
    Log("%s = <nil>, err = %s", prefix, tostring(errorMsg))
    return
  end
  Log("%s = %s", prefix, tostring(ts))
  local ok, backOrError = pcall(os.date, "*t", ts)
  if ok then
    DumpTime(prefix .. " os.date(raw)", backOrError)
  else
    Log("%s os.date error: %s", prefix, tostring(backOrError))
  end
end

local function TestOne(desc, t)
  Log("========== %s ==========", desc)
  DumpTime("[SafeLocalOsTime] input      ", t)
  local raw_ts, raw_error = TryRawOsTime(CloneTimeTable(t))
  DumpTimestampResult("[os.time]         ", raw_ts, raw_error)
  local safe_ts = SafeLocalOsTime(CloneTimeTable(t))
  DumpTimestampResult("[SafeLocalOsTime]", safe_ts)
  if raw_ts ~= nil and safe_ts ~= nil then
    Log("[diff] safe - raw  = %s", tostring(safe_ts - raw_ts))
  end
end

local function RunCaseGroup(title, year, month, day, list)
  Log("===== [SafeLocalOsTime] %s, date = %04d-%02d-%02d =====", title, year, month, day)
  for _, v in ipairs(list) do
    local t = {
      year = year,
      month = month,
      day = day,
      hour = v.h,
      min = v.m,
      sec = v.sec or 0,
      isdst = v.isdst
    }
    local desc = v.desc
    if v.isdst == nil then
      desc = desc .. " / isdst=nil"
    else
      desc = string.format("%s / isdst=%s", desc, tostring(v.isdst))
    end
    TestOne(desc, t)
  end
end

function UITimeDSTTest.Run(year, month, day, fallbackYear, fallbackMonth, fallbackDay)
  local timeMgr = UITimeManager and UITimeManager:GetInstance()
  if not timeMgr then
    Log("[SafeLocalOsTime]UITimeDSTTest.Run failed: UITimeManager instance not found")
    return
  end
  year = year or 2026
  month = month or 3
  day = day or 8
  fallbackYear = fallbackYear or 2026
  fallbackMonth = fallbackMonth or 11
  fallbackDay = fallbackDay or 1
  local data = os.date("*t")
  Log("[SafeLocalOsTime] \229\189\147\229\137\141 isdst : %s", data.isdst)
  local timeStr = 1793580006
  local data2 = os.date("*t", timeStr)
  Log("[SafeLocalOsTime] 11\230\156\13602(1793580006) dst : %s", data2.isdst)
  Log("===== [SafeLocalOsTime] UITimeDSTTest.Run =====")
  Log("[SafeLocalOsTime] \229\189\147\229\137\141\230\156\172\229\156\176 UTC \229\129\143\231\167\187(\229\176\143\230\151\182)\239\188\154%s", tostring(timeMgr:GetLocalUTCOffset()))
  local safe_ts = SafeLocalOsTime()
  Log("[SafeLocalOsTime] empty = %s", tostring(safe_ts))
  RunCaseGroup("\230\152\165\229\173\163\232\183\179\230\151\182\230\160\183\228\190\139", year, month, day, {
    {
      h = 1,
      m = 59,
      desc = "[SafeLocalOsTime] \232\183\179\230\151\182\229\137\141  1:59"
    },
    {
      h = 2,
      m = 0,
      desc = "[SafeLocalOsTime] \232\183\179\230\151\182\231\130\185  2:00"
    },
    {
      h = 2,
      m = 30,
      desc = "[SafeLocalOsTime] \228\184\141\229\173\152\229\156\168\231\154\132 2:30"
    },
    {
      h = 2,
      m = 30,
      desc = "[SafeLocalOsTime] \228\184\141\229\173\152\229\156\168\231\154\132 2:30",
      isdst = false
    },
    {
      h = 2,
      m = 30,
      desc = "[SafeLocalOsTime] \228\184\141\229\173\152\229\156\168\231\154\132 2:30",
      isdst = true
    },
    {
      h = 3,
      m = 0,
      desc = "[SafeLocalOsTime] \232\183\179\230\151\182\229\144\142  3:00"
    }
  })
  RunCaseGroup("\231\167\139\229\173\163\229\155\158\230\139\168\230\160\183\228\190\139", fallbackYear, fallbackMonth, fallbackDay, {
    {
      h = 0,
      m = 59,
      desc = "[SafeLocalOsTime] \229\155\158\230\139\168\229\137\141  0:59"
    },
    {
      h = 1,
      m = 30,
      desc = "[SafeLocalOsTime] \233\135\141\229\164\141\231\154\132 1:30"
    },
    {
      h = 1,
      m = 30,
      desc = "[SafeLocalOsTime] \233\135\141\229\164\141\231\154\132 1:30",
      isdst = true
    },
    {
      h = 1,
      m = 30,
      desc = "[SafeLocalOsTime] \233\135\141\229\164\141\231\154\132 1:30",
      isdst = false
    },
    {
      h = 1,
      m = 59,
      desc = "[SafeLocalOsTime] \229\155\158\230\139\168\230\156\171  1:59"
    },
    {
      h = 2,
      m = 0,
      desc = "[SafeLocalOsTime] \229\155\158\230\139\168\229\144\142  2:00"
    }
  })
  Log("===== [SafeLocalOsTime] UITimeDSTTest.Run end =====")
end

return UITimeDSTTest
