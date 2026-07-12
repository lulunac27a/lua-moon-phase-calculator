local function getMoonPhase(year, month, day)
    -- Known New Moon reference point: January 6, 2000
    local refYear = 2000
    local refMonth = 1
    local refDay = 6

    -- Synodic month (days it takes to complete a full lunar cycle)
    local synodicMonth = 29.5305882

    -- Convert Gregorian date to Julian Day (approximate)
    if month < 3 then
        year = year - 1
        month = month + 12
    end
    month = month + 1

    local c = 365.25 * year
    local e = math.floor(30.6 * month)
    local julianDays = c + e + day - 694039.09

    -- Calculate days elapsed since the reference new moon
    local daysElapsed = julianDays % synodicMonth

    -- Percentage of the lunar cycle completed (0.0 to 1.0)
    local percent = daysElapsed / synodicMonth

    -- Map the cycle to an 8-phase index (0-7)
    local phaseIndex = math.floor((daysElapsed / synodicMonth) * 8 + 0.5) % 8

    local phaseNames = {
        "New Moon",
        "Waxing Crescent",
        "First Quarter",
        "Waxing Gibbous",
        "Full Moon",
        "Waning Gibbous",
        "Last Quarter",
        "Waning Crescent"
    }

    return {
        percent = percent,
        index = phaseIndex,
        name = phaseNames[phaseIndex + 1],
        age = daysElapsed
    }
end

local year = tonumber(arg[1])
local month = tonumber(arg[2])
local day = tonumber(arg[3])
local date = { year = year, month = month, day = day }
local currentPhase = getMoonPhase(date.year, date.month, date.day)

print("Current Phase: " .. currentPhase.name)
print("Cycle Progress: " .. string.format("%.2f%%", currentPhase.percent * 100))
print("Moon Age: " .. string.format("%.2f", currentPhase.age) .. " days")
